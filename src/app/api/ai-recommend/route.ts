import { NextRequest } from "next/server";
import { getAllParts } from "@/lib/supabase/fetch-parts";
import { evaluateIssues } from "@/lib/compatibility";
import {
  AI_SYSTEM_PROMPT,
  buildRetryPrompt,
  buildUserPrompt,
  dangerIssueMessages,
  findGuaranteedSafeSelections,
  missingRequiredCategories,
  parseAiPicks,
  resolveSelections,
  type AiRecommendAnswers,
  type BrandPreference,
  type Preference,
  type Priority,
  type Purpose,
} from "@/lib/ai-recommend";
import { CATEGORY_LABEL } from "@/lib/compatibility";
import type { Selections } from "@/lib/types";

const NIM_ENDPOINT = "https://integrate.api.nvidia.com/v1/chat/completions";
const NIM_MODEL = "meta/llama-3.1-70b-instruct";
const MAX_ATTEMPTS = 3;
// 전체 요청 최장 1분 예산 — 개별 NIM 호출 타임아웃은 남은 예산에 맞춰 매 시도마다 재계산한다.
const OVERALL_BUDGET_MS = 58_000;
const MIN_ATTEMPT_TIMEOUT_MS = 3_000;

export const maxDuration = 65;

function isPurpose(value: unknown): value is Purpose {
  return value === "office" || value === "gaming" || value === "editing";
}
function isPriority(value: unknown): value is Priority {
  return value === "performance" || value === "value" || value === "balanced";
}
function isBrand(value: unknown): value is BrandPreference {
  return value === "intel" || value === "amd" || value === "any";
}
function isPreference(value: unknown): value is Preference {
  return value === "quiet" || value === "compact" || value === "none";
}

interface NimMessage {
  role: "system" | "user" | "assistant";
  content: string;
}

async function callNim(apiKey: string, messages: NimMessage[], timeoutMs: number): Promise<string> {
  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), timeoutMs);
  try {
    const res = await fetch(NIM_ENDPOINT, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${apiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: NIM_MODEL,
        messages,
        temperature: 0.3,
        max_tokens: 600,
      }),
      signal: controller.signal,
    });
    if (!res.ok) throw new Error(`NIM API 응답 오류: ${res.status}`);
    const data = await res.json();
    return data.choices?.[0]?.message?.content ?? "";
  } catch (err) {
    if (err instanceof Error && err.name === "AbortError") {
      throw new Error(`NIM API 응답 지연 (${timeoutMs}ms 초과)`);
    }
    throw err;
  } finally {
    clearTimeout(timer);
  }
}

export async function POST(req: NextRequest) {
  const body = await req.json().catch(() => null);
  const { purpose, priority, brand, preference } = body ?? {};
  const detail = typeof body?.detail === "string" ? body.detail : "";

  if (!isPurpose(purpose) || !isPriority(priority) || !isBrand(brand) || !isPreference(preference)) {
    return Response.json({ error: "요청 형식이 올바르지 않습니다." }, { status: 400 });
  }

  const answers: AiRecommendAnswers = { purpose, priority, brand, preference, detail };
  const parts = await getAllParts();
  const apiKey = process.env.NVIDIA_API_KEY;

  const safeguard = (reason: string) => {
    const selections = findGuaranteedSafeSelections(parts);
    return Response.json({
      selections,
      reason,
      issues: evaluateIssues(selections),
      fallback: true,
    });
  };

  if (!apiKey) {
    return safeguard("NVIDIA_API_KEY가 설정되지 않아 검증된 기본 조합을 보여드려요.");
  }

  const messages: NimMessage[] = [
    { role: "system", content: AI_SYSTEM_PROMPT },
    { role: "user", content: buildUserPrompt(parts, answers) },
  ];

  const deadline = Date.now() + OVERALL_BUDGET_MS;

  try {
    let lastReason = "";
    let lastSelections: Selections = {};

    for (let attempt = 0; attempt < MAX_ATTEMPTS; attempt++) {
      const remaining = deadline - Date.now();
      if (remaining < MIN_ATTEMPT_TIMEOUT_MS) {
        console.warn("[ai-recommend] 1분 예산 소진, 안전 조합으로 대체");
        return safeguard("AI 추천이 1분 내에 끝나지 않아 검증된 기본 조합으로 대체했습니다.");
      }

      const raw = await callNim(apiKey, messages, remaining);
      const picked = parseAiPicks(raw);
      if (!picked) {
        messages.push({ role: "assistant", content: raw });
        messages.push({
          role: "user",
          content: "응답을 JSON으로 해석하지 못했습니다. 설명 없이 JSON 하나만 다시 출력해주세요.",
        });
        continue;
      }

      const selections = resolveSelections(parts, picked.picks);
      lastReason = picked.reason || lastReason;
      lastSelections = selections;

      const missing = missingRequiredCategories(selections);
      const dangerMessages = dangerIssueMessages(selections);

      // 위험(danger)급 비호환 조합은 절대 사용자에게 노출하지 않는다 — 문제가 있으면
      // AI에게 무엇이 잘못됐는지 알려주고 같은 대화 안에서 다시 고르게 한다.
      if (missing.length === 0 && dangerMessages.length === 0) {
        return Response.json({
          selections,
          reason: lastReason || "AI가 조합을 추천했어요.",
          issues: evaluateIssues(selections),
          fallback: false,
        });
      }

      const problems = [
        ...missing.map((c) => `${CATEGORY_LABEL[c]} 항목이 빠졌습니다.`),
        ...dangerMessages,
      ];
      messages.push({ role: "assistant", content: raw });
      messages.push({ role: "user", content: buildRetryPrompt(problems) });
    }

    // MAX_ATTEMPTS번 시도해도 계속 위험 조합을 내놓으면 검증된 안전 조합으로 대체
    console.warn("[ai-recommend] AI가 danger 없는 조합을 못 찾음, 안전 조합으로 대체", lastSelections);
    return safeguard("AI가 완전히 호환되는 조합을 찾지 못해 검증된 기본 조합으로 대체했습니다.");
  } catch (err) {
    console.warn("[ai-recommend] NVIDIA NIM 호출 실패, 검증된 기본 조합으로 대체:", err);
    return safeguard("AI 추천 처리 중 오류가 발생해 검증된 기본 조합으로 대체했습니다.");
  }
}
