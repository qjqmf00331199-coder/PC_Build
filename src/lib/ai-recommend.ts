import type { PartsData } from "./supabase/fetch-parts";
import type { PartCategory, Selections } from "./types";
import { CATEGORY_LABEL, CATEGORY_ORDER, evaluateIssues } from "./compatibility";
import { partSpecLine, partTitle } from "./part-specs";

export type Purpose = "office" | "gaming" | "editing";
export type Priority = "performance" | "value" | "balanced";
export type BrandPreference = "intel" | "amd" | "any";
export type Preference = "quiet" | "compact" | "none";

export const PURPOSE_LABEL: Record<Purpose, string> = {
  office: "사무용",
  gaming: "게이밍용",
  editing: "영상/방송용",
};

export const PRIORITY_LABEL: Record<Priority, string> = {
  performance: "고성능 최우선",
  value: "합리적인 구성(가성비)",
  balanced: "무난한 균형",
};

export const BRAND_LABEL: Record<BrandPreference, string> = {
  intel: "Intel 선호",
  amd: "AMD(라이젠) 선호",
  any: "브랜드 상관없음",
};

export const PREFERENCE_LABEL: Record<Preference, string> = {
  quiet: "정숙성이 중요함 (조용한 쿨링)",
  compact: "크기가 작아야 함 (소형 PC)",
  none: "특별히 상관없음",
};

export interface AiRecommendAnswers {
  purpose: Purpose;
  priority: Priority;
  brand: BrandPreference;
  preference: Preference;
  detail: string;
}

// GPU는 용도에 따라 필요 없을 수 있어(사무용 등) AI가 null로 골라도 되는 유일한 카테고리
const OPTIONAL_CATEGORIES: PartCategory[] = ["gpu"];

function splitSockets(value: string): string[] {
  return value.split(";").map((s) => s.trim()).filter(Boolean);
}

// 프롬프트에 넣을 부품 목록: 가격 필드는 DB에 아예 없으니 제외할 것도 없음.
// id를 반드시 포함시켜서, AI가 스펙을 새로 지어내지 못하고 id로만 고르게 강제한다.
export function compactPartsForPrompt(parts: PartsData): string {
  return CATEGORY_ORDER.map((category) => {
    const lines = parts[category]
      .map((part) => `  - ${part.id} | ${partTitle(part)} | ${partSpecLine(part)}`)
      .join("\n");
    return `[${CATEGORY_LABEL[category]} (key: ${category})]\n${lines}`;
  }).join("\n\n");
}

export const AI_SYSTEM_PROMPT = `너는 PC 조립 전문가야. 사용자의 용도와 요구사항을 보고, 주어진 부품 목록에서 카테고리별로 정확히 하나씩 골라 호환되는 조합을 추천해.

반드시 지켜야 할 호환 규칙:
1. CPU 소켓과 메인보드 소켓이 같아야 한다.
2. RAM 타입(DDR4/DDR5)이 메인보드 메모리 타입과 같아야 한다.
3. GPU 길이(length_mm)가 케이스 GPU 최대 길이 이하여야 한다.
4. PSU 용량(W)이 GPU 권장 파워 이상이어야 한다.
5. 쿨러 지원 소켓에 CPU 소켓이 포함돼야 한다.
6. 공랭 쿨러 높이가 케이스 최대 쿨러 높이 이하여야 한다.
7. 메인보드 폼팩터가 케이스 지원 목록에 포함돼야 한다.
8. gpu는 사무용처럼 내장그래픽으로 충분한 경우에만 null로 골라도 된다. 그 외 카테고리는 null 금지.
9. 가격 정보는 DB에 없다. 가격/비용을 절대 언급하지 마라.

반드시 부품 목록에 있는 id만 사용해라. id를 지어내지 마라.
다른 설명 없이 아래 JSON 하나만 출력해라(마크다운 코드블록도 쓰지 마라):
{"cpu":"id","motherboard":"id","ram":"id","ssd":"id","gpu":"id 또는 null","psu":"id","case":"id","cooler":"id","reason":"2~3문장 한글 추천 이유"}`;

export function buildUserPrompt(parts: PartsData, answers: AiRecommendAnswers): string {
  const detailLine = answers.detail.trim()
    ? `추가 요구사항: ${answers.detail.trim()}`
    : "추가 요구사항 없음.";
  return [
    `용도: ${PURPOSE_LABEL[answers.purpose]}`,
    `우선순위: ${PRIORITY_LABEL[answers.priority]}`,
    `브랜드 선호: ${BRAND_LABEL[answers.brand]}`,
    `기타 선호: ${PREFERENCE_LABEL[answers.preference]}`,
    detailLine,
    "",
    "[부품 목록]",
    compactPartsForPrompt(parts),
  ].join("\n");
}

export function buildRetryPrompt(problems: string[]): string {
  return `방금 고른 조합에 문제가 있습니다: ${problems.join(" ")} 이 문제를 모두 해결한 새 조합을 같은 JSON 형식으로 다시 골라주세요.`;
}

export interface AiPicks {
  picks: Partial<Record<PartCategory, string | null>>;
  reason: string;
}

export function parseAiPicks(raw: string): AiPicks | null {
  const match = raw.match(/\{[\s\S]*\}/);
  if (!match) return null;
  try {
    const parsed = JSON.parse(match[0]) as Record<string, unknown>;
    const picks: Partial<Record<PartCategory, string | null>> = {};
    for (const category of CATEGORY_ORDER) {
      const value = parsed[category];
      if (typeof value === "string") picks[category] = value;
      else if (value === null) picks[category] = null;
    }
    const reason = typeof parsed.reason === "string" ? parsed.reason : "";
    return { picks, reason };
  } catch {
    return null;
  }
}

export function resolveSelections(parts: PartsData, picks: AiPicks["picks"]): Selections {
  const selections: Selections = {};
  for (const category of CATEGORY_ORDER) {
    const id = picks[category];
    if (!id) continue;
    const found = (parts[category] as { id: string }[]).find((p) => p.id === id);
    if (found) (selections as Record<string, unknown>)[category] = found;
  }
  return selections;
}

export function missingRequiredCategories(selections: Selections): PartCategory[] {
  return CATEGORY_ORDER.filter(
    (category) => !OPTIONAL_CATEGORIES.includes(category) && !selections[category]
  );
}

export function dangerIssueMessages(selections: Selections): string[] {
  return evaluateIssues(selections)
    .filter((issue) => issue.level === "danger")
    .map((issue) => issue.message);
}

// AI가 계속 위험(danger)급 비호환 조합을 내놓거나 API 자체가 실패했을 때 쓰는
// 최후의 안전장치. DB 부품 조합을 직접 탐색해서 danger 이슈가 0개인 조합을
// 찾아 반환한다 — 어떤 경우에도 절대 선택 불가능한 조합이 사용자에게 노출되지 않게 보장.
export function findGuaranteedSafeSelections(parts: PartsData): Selections {
  for (const cpu of parts.cpu) {
    const motherboard = parts.motherboard.find((m) => m.socket === cpu.socket);
    if (!motherboard) continue;
    const ram = parts.ram.find((r) => r.type === motherboard.memory_type);
    if (!ram) continue;

    const candidateCases = parts.case.filter((c) =>
      splitSockets(c.supported_mb.replace(/,/g, ";")).includes(motherboard.form_factor)
    );
    const candidateCoolers = parts.cooler.filter(
      (c) => c.type === "air" && splitSockets(c.supported_sockets).includes(cpu.socket)
    );
    const psu = [...parts.psu].sort((a, b) => a.watt - b.watt)[0];
    const ssd = parts.ssd[0];

    for (const pcCase of candidateCases) {
      for (const cooler of candidateCoolers) {
        const candidate: Selections = { cpu, motherboard, ram, ssd, case: pcCase, cooler, psu };
        if (evaluateIssues(candidate).every((issue) => issue.level !== "danger")) {
          return candidate;
        }
      }
    }
  }
  return {};
}
