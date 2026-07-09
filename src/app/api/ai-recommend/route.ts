import { NextRequest } from "next/server";
import { getAllParts } from "@/lib/supabase/fetch-parts";
import { evaluateIssues } from "@/lib/compatibility";
import { evaluateAllBottlenecks, worstLevel } from "@/lib/bottleneck";
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

const GEMINI_MODEL = "gemini-2.5-flash";
const GEMINI_ENDPOINT = `https://generativelanguage.googleapis.com/v1beta/models/${GEMINI_MODEL}:generateContent`;
const MAX_ATTEMPTS = 3;
// 전체 요청 최장 1분 예산 — 개별 Gemini 호출 타임아웃은 남은 예산에 맞춰 매 시도마다 재계산한다.
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

interface ChatMessage {
  role: "system" | "user" | "assistant";
  content: string;
}

// Gemini는 OpenAI식 system/user/assistant 롤이 아니라 system은 별도 systemInstruction으로,
// user/assistant는 user/model 롤의 contents 배열로 보낸다.
function toGeminiRequestBody(messages: ChatMessage[]) {
  const systemMessage = messages.find((m) => m.role === "system");
  const contents = messages
    .filter((m) => m.role !== "system")
    .map((m) => ({ role: m.role === "assistant" ? "model" : "user", parts: [{ text: m.content }] }));

  return {
    ...(systemMessage ? { systemInstruction: { parts: [{ text: systemMessage.content }] } } : {}),
    contents,
    generationConfig: {
      temperature: 0.3,
      maxOutputTokens: 600,
      responseMimeType: "application/json",
      // 2.5-flash는 기본적으로 내부 사고(thinking) 토큰을 먼저 소비하는데, 이 작업은
      // 정해진 목록에서 id만 고르는 단순 작업이라 그걸로 maxOutputTokens가 다 날아간다.
      thinkingConfig: { thinkingBudget: 0 },
    },
  };
}

async function callGemini(apiKey: string, messages: ChatMessage[], timeoutMs: number): Promise<string> {
  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), timeoutMs);
  try {
    const res = await fetch(GEMINI_ENDPOINT, {
      method: "POST",
      headers: {
        "x-goog-api-key": apiKey,
        "Content-Type": "application/json",
      },
      body: JSON.stringify(toGeminiRequestBody(messages)),
      signal: controller.signal,
    });
    if (!res.ok) {
      const bodyText = await res.text().catch(() => "");
      console.warn("[ai-recommend][debug] Gemini error body:", bodyText.slice(0, 1000));
      throw new Error(`Gemini API 응답 오류: ${res.status}`);
    }
    const data = await res.json();
    const parts = data.candidates?.[0]?.content?.parts as { text?: string }[] | undefined;
    return parts?.map((p) => p.text ?? "").join("") ?? "";
  } catch (err) {
    if (err instanceof Error && err.name === "AbortError") {
      throw new Error(`Gemini API 응답 지연 (${timeoutMs}ms 초과)`);
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
  const apiKey = process.env.GOOGLE_API_KEY;

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
    return safeguard("GOOGLE_API_KEY가 설정되지 않아 검증된 기본 조합을 보여드려요.");
  }

  const messages: ChatMessage[] = [
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

      let raw: string;
      try {
        raw = await callGemini(apiKey, messages, remaining);
      } catch (err) {
        // 타임아웃/API 오류 등 네트워크성 실패는 이번 시도만 버리고 남은 예산으로 재시도한다 —
        // 여기서 그냥 continue하면 MAX_ATTEMPTS 재시도가 실질적으로 소진된다.
        console.warn(`[ai-recommend] Gemini 호출 실패 (시도 ${attempt + 1}/${MAX_ATTEMPTS}):`, err);
        continue;
      }

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
      const bottleneckLevel = worstLevel(evaluateAllBottlenecks(selections));
      const hasBottleneckDanger = bottleneckLevel === "danger";

      // 위험(danger)급 비호환 조합·심한 성능 병목 조합은 절대 사용자에게 노출하지 않는다 —
      // 문제가 있으면 AI에게 무엇이 잘못됐는지 알려주고 같은 대화 안에서 다시 고르게 한다.
      if (missing.length === 0 && dangerMessages.length === 0 && !hasBottleneckDanger) {
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
        ...(hasBottleneckDanger ? ["CPU와 GPU 성능 격차가 너무 커서 병목이 심합니다. CPU와 GPU 성능을 서로 비슷한 등급으로 맞춰 다시 골라주세요."] : []),
      ];
      messages.push({ role: "assistant", content: raw });
      messages.push({ role: "user", content: buildRetryPrompt(problems) });
    }

    // MAX_ATTEMPTS번 시도해도 계속 위험 조합을 내놓으면 검증된 안전 조합으로 대체
    console.warn("[ai-recommend] AI가 danger 없는 조합을 못 찾음, 안전 조합으로 대체", lastSelections);
    return safeguard("AI가 완전히 호환되는 조합을 찾지 못해 검증된 기본 조합으로 대체했습니다.");
  } catch (err) {
    console.warn("[ai-recommend] Gemini 호출 실패, 검증된 기본 조합으로 대체:", err);
    return safeguard("AI 추천 처리 중 오류가 발생해 검증된 기본 조합으로 대체했습니다.");
  }
}
