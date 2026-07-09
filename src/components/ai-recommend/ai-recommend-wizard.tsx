"use client";

import { useEffect, useState } from "react";
import dynamic from "next/dynamic";
import type { CompatIssue, PartCategory, Selections } from "@/lib/types";
import { CATEGORY_LABEL, CATEGORY_ORDER } from "@/lib/compatibility";
import { partSpecLine, partTitle } from "@/lib/part-specs";
import { formatPriceKrw, useProductInfo } from "@/lib/use-product-info";
import { cn } from "@/lib/utils";

const PopupAd = dynamic(() => import("@/components/popup-ad").then((m) => m.PopupAd));

type StepId = "purpose" | "priority" | "brand" | "preference" | "detail";

interface StepOption {
  value: string;
  label: string;
  desc: string;
}

interface Step {
  id: StepId;
  question: string;
  type: "choice" | "text";
  options?: StepOption[];
}

const STEPS: Step[] = [
  {
    id: "purpose",
    question: "어떤 용도로 PC를 쓰실 건가요?",
    type: "choice",
    options: [
      { value: "office", label: "사무용", desc: "문서 작업, 웹서핑, 인터넷 강의 위주" },
      { value: "gaming", label: "게이밍용", desc: "고사양 게임 구동 위주" },
      { value: "editing", label: "영상/방송용", desc: "편집, 인코딩, 스트리밍 위주" },
    ],
  },
  {
    id: "priority",
    question: "무엇을 가장 중요하게 볼까요?",
    type: "choice",
    options: [
      { value: "performance", label: "고성능 최우선", desc: "최고 성능 위주로 구성" },
      { value: "value", label: "합리적인 구성", desc: "가성비 좋은 조합 위주로 구성" },
      { value: "balanced", label: "무난한 균형", desc: "성능과 합리성 사이 균형" },
    ],
  },
  {
    id: "brand",
    question: "선호하는 브랜드가 있나요?",
    type: "choice",
    options: [
      { value: "intel", label: "Intel", desc: "인텔 CPU 기반으로 구성" },
      { value: "amd", label: "AMD", desc: "라이젠 CPU 기반으로 구성" },
      { value: "any", label: "상관없음", desc: "브랜드 무관, 적합한 걸로" },
    ],
  },
  {
    id: "preference",
    question: "추가로 신경 쓰이는 부분이 있나요?",
    type: "choice",
    options: [
      { value: "quiet", label: "정숙성", desc: "조용한 쿨링 위주로 구성" },
      { value: "compact", label: "작은 크기", desc: "소형 PC로 구성" },
      { value: "none", label: "특별히 없음", desc: "상관없어요" },
    ],
  },
  {
    id: "detail",
    question: "마지막으로, 자유롭게 더 알려주고 싶은 게 있나요?",
    type: "text",
  },
];

interface AiRecommendResult {
  selections: Selections;
  reason: string;
  issues: CompatIssue[];
  fallback: boolean;
}

type Phase = "quiz" | "loading" | "result" | "error";

// 백엔드 예산(OVERALL_BUDGET_MS, route.ts)이 최장 1분이라 프론트도 여유를 두고 65초로 잡는다.
const REQUEST_TIMEOUT_MS = 65000;

const DEFAULT_LOADING_MESSAGE = "AI가 답변을 바탕으로 부품 조합을 고르고 있어요...";
// 최장 1분을 5분기(12초 간격)로 나눠 분기마다 멘트를 바꾼다. 기존 멘트 3개 그대로 쓰고
// 앞뒤로 시작 멘트(기존 DEFAULT)와 마무리 멘트(신규)를 붙여 5개를 채운다.
const LOADING_MESSAGE_SCHEDULE: { delay: number; message: string }[] = [
  { delay: 0, message: DEFAULT_LOADING_MESSAGE },
  { delay: 12000, message: "고객님의 니즈에 맞춰 찾는중이예요 잠시만 기다려 주세요!!" },
  { delay: 24000, message: "열심히 찾아오고 있어요 잠시만 기다려 주세요!!" },
  { delay: 36000, message: "다 찾았어요!! 잠시만 기다려 주세요!!" },
  { delay: 48000, message: "완벽한 조합인지 마지막으로 검증하고 있어요!!" },
];

export function AiRecommendWizard({
  onApply,
  onCancel,
}: {
  onApply: (selections: Selections) => void;
  onCancel: () => void;
}) {
  const [stepIndex, setStepIndex] = useState(0);
  const [direction, setDirection] = useState<"forward" | "backward">("forward");
  const [answers, setAnswers] = useState<Record<StepId, string>>({
    purpose: "",
    priority: "",
    brand: "",
    preference: "",
    detail: "",
  });
  const [phase, setPhase] = useState<Phase>("quiz");
  const [result, setResult] = useState<AiRecommendResult | null>(null);
  const [errorMessage, setErrorMessage] = useState("");
  const [loadingMessage, setLoadingMessage] = useState(DEFAULT_LOADING_MESSAGE);
  const [showPopupAd, setShowPopupAd] = useState(false);

  useEffect(() => {
    if (phase !== "loading") {
      setLoadingMessage(DEFAULT_LOADING_MESSAGE);
      return;
    }
    const timers = LOADING_MESSAGE_SCHEDULE.map(({ delay, message }) =>
      setTimeout(() => setLoadingMessage(message), delay)
    );
    return () => timers.forEach(clearTimeout);
  }, [phase]);

  useEffect(() => {
    if (phase !== "loading") return;
    const popupTimer = setTimeout(() => setShowPopupAd(true), 1000);
    return () => clearTimeout(popupTimer);
  }, [phase]);

  const step = STEPS[stepIndex];
  const isLastStep = stepIndex === STEPS.length - 1;
  const canAdvance = step.type === "text" || Boolean(answers[step.id]);

  // fixed set of 8 categories called in a stable order every render, so calling
  // the price-fetch hook once per category (instead of in a loop) stays rules-of-hooks safe
  const sel = result?.selections;
  const partPrice: Record<PartCategory, number | null> = {
    cpu: useProductInfo(sel?.cpu ?? null).price,
    motherboard: useProductInfo(sel?.motherboard ?? null).price,
    ram: useProductInfo(sel?.ram ?? null).price,
    ssd: useProductInfo(sel?.ssd ?? null).price,
    gpu: useProductInfo(sel?.gpu ?? null).price,
    psu: useProductInfo(sel?.psu ?? null).price,
    case: useProductInfo(sel?.case ?? null).price,
    cooler: useProductInfo(sel?.cooler ?? null).price,
  };
  const selectedCategories = sel ? CATEGORY_ORDER.filter((c) => sel[c]) : [];
  const totalPrice = selectedCategories.reduce((sum, c) => sum + (partPrice[c] ?? 0), 0);
  const totalPriceLoading = selectedCategories.some((c) => partPrice[c] === null);

  const submit = async () => {
    setPhase("loading");
    const controller = new AbortController();
    const timer = setTimeout(() => controller.abort(), REQUEST_TIMEOUT_MS);
    try {
      const res = await fetch("/api/ai-recommend", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(answers),
        signal: controller.signal,
      });
      if (!res.ok) throw new Error(`요청 실패 (${res.status})`);
      const data = (await res.json()) as AiRecommendResult;
      setResult(data);
      setPhase("result");
    } catch (err) {
      const isTimeout = err instanceof Error && err.name === "AbortError";
      setErrorMessage(
        isTimeout
          ? "응답이 너무 오래 걸려요. 잠시 후 다시 시도해주세요."
          : err instanceof Error
            ? err.message
            : "알 수 없는 오류가 발생했습니다."
      );
      setPhase("error");
    } finally {
      clearTimeout(timer);
    }
  };

  const goNext = () => {
    if (!canAdvance) return;
    if (isLastStep) {
      void submit();
      return;
    }
    setDirection("forward");
    setStepIndex((i) => i + 1);
  };

  const goBack = () => {
    if (stepIndex === 0) return;
    setDirection("backward");
    setStepIndex((i) => i - 1);
  };

  return (
    // landing-gate wraps every screen in an absolute-inset-0 + overflow-hidden shell
    // (no page-level scroll to fall back on), so this component must own its own
    // scroll container — otherwise a tall result (8 parts + issues + button) just
    // gets clipped with no way to reach the bottom
    <div className="mx-auto h-dvh max-w-2xl overflow-y-auto px-6 py-16">
      <div className="flex min-h-full flex-col justify-center">
      {showPopupAd && <PopupAd onClose={() => setShowPopupAd(false)} />}
      <button
        type="button"
        onClick={onCancel}
        className="mb-8 self-start text-xs text-[#9CA3AF] transition-colors hover:text-[var(--accent)]"
      >
        ← 처음으로
      </button>

      {phase === "quiz" && (
        <>
          <div className="mb-1 flex items-center justify-between">
            <div className="flex items-center gap-2 text-[10px] tracking-[0.2em] text-[var(--accent)]">
              <span className="h-1.5 w-1.5 shrink-0 rounded-full bg-[var(--accent)]" />
              AI 사전 추천
            </div>
            <span className="font-mono text-xs text-[#9CA3AF]">
              {stepIndex + 1} / {STEPS.length}
            </span>
          </div>
          <div className="mb-8 h-1.5 w-full overflow-hidden rounded-full bg-[#27272A]">
            <div
              className="h-full rounded-full bg-[var(--accent)] transition-[width] duration-300 ease-in-out"
              style={{ width: `${((stepIndex + 1) / STEPS.length) * 100}%` }}
            />
          </div>

          <div key={`${stepIndex}-${direction}`} className={cn(`step-slide-in-${direction}`)}>
            <h2 className="text-2xl font-extrabold tracking-tight sm:text-3xl">{step.question}</h2>

            {step.type === "choice" && (
              <div className="mt-6 grid grid-cols-1 gap-3 sm:grid-cols-3">
                {step.options!.map((opt) => (
                  <button
                    key={opt.value}
                    type="button"
                    onClick={() => setAnswers((a) => ({ ...a, [step.id]: opt.value }))}
                    className={cn(
                      "rounded-lg border p-4 text-left transition-colors hover:border-[var(--accent)]",
                      answers[step.id] === opt.value
                        ? "border-[var(--accent)] bg-[#151517]"
                        : "border-[#27272A] bg-[#111113]"
                    )}
                  >
                    <div className="text-sm font-semibold text-[#E4E4E7]">{opt.label}</div>
                    <div className="mt-1 text-xs text-[#9CA3AF]">{opt.desc}</div>
                  </button>
                ))}
              </div>
            )}

            {step.type === "text" && (
              <textarea
                value={answers.detail}
                onChange={(e) => setAnswers((a) => ({ ...a, detail: e.target.value }))}
                rows={4}
                autoFocus
                className="mt-6 w-full resize-none rounded-lg border border-[#27272A] bg-[#111113] p-3 text-sm text-[#E4E4E7] outline-none focus:border-[var(--accent)]"
                placeholder="자유롭게 적어주세요. 비워둬도 괜찮아요. (이름, 연락처 등 개인정보는 입력하지 마세요)"
              />
            )}
          </div>

          {isLastStep && (
            <p className="mt-4 text-[11px] leading-relaxed text-[#71717A]">
              입력하신 답변은 AI 추천 생성을 위해 해외 서버(Groq)로 전송되며, 저장되지 않고 즉시 폐기됩니다.{" "}
              <a href="/privacy" target="_blank" rel="noopener noreferrer" className="underline hover:text-[var(--accent)]">
                자세히
              </a>
            </p>
          )}

          <div className="mt-8 flex gap-3">
            {stepIndex > 0 && (
              <button
                type="button"
                onClick={goBack}
                className="rounded-full border border-[#27272A] px-5 py-3 text-sm text-[#9CA3AF] transition-colors hover:text-[var(--accent)]"
              >
                이전
              </button>
            )}
            <button
              type="button"
              disabled={!canAdvance}
              onClick={goNext}
              className={cn(
                "flex-1 rounded-full py-3 text-sm font-bold transition-transform",
                canAdvance
                  ? "bg-[var(--accent)] text-[#0a0a0b] hover:scale-[1.02] active:scale-[0.98]"
                  : "cursor-not-allowed bg-[#27272A] text-[#6B7280]"
              )}
            >
              {isLastStep ? "AI 추천 받기 ✨" : "다음"}
            </button>
          </div>
        </>
      )}

      {phase === "loading" && (
        <div className="flex flex-col items-center justify-center gap-6 rounded-lg border border-[#27272A] bg-[#151517] py-20 text-center">
          <div className="logo-charge text-4xl font-extrabold tracking-tight sm:text-5xl" role="img" aria-label="TriFIT 로딩 중">
            <span className="block">
              <span className="text-[#3F3F46]">Tri</span>
              <span className="text-[#3F3F46]">FIT</span>
            </span>
            <span className="logo-charge-fill" aria-hidden="true">
              <span className="logo-charge-fill-inner">
                <span className="text-[#E4E4E7]">Tri</span>
                <span className="text-[var(--accent)]">FIT</span>
              </span>
            </span>
          </div>
          <p className="text-sm text-[#9CA3AF]">{loadingMessage}</p>
        </div>
      )}

      {phase === "error" && (
        <div className="rounded-lg border border-red-500/40 bg-[#151517] p-5">
          <p className="text-sm text-red-400">추천 요청에 실패했어요: {errorMessage}</p>
          <button
            type="button"
            onClick={() => void submit()}
            className="mt-3 rounded-full border border-[#27272A] px-4 py-2 text-xs text-[#9CA3AF] hover:text-[var(--accent)]"
          >
            다시 시도
          </button>
        </div>
      )}

      {phase === "result" && result && (
        <div className="rounded-lg border border-[#27272A] bg-[#151517] p-5">
          <h3 className="mb-2 text-sm font-semibold text-[#E4E4E7]">추천 조합</h3>
          <p className="mb-4 text-xs text-[#9CA3AF]">{result.reason}</p>

          {result.fallback && (
            <div className="mb-3 flex items-center justify-between gap-3 rounded-md border border-yellow-500/40 bg-yellow-500/10 px-3 py-2 text-xs text-yellow-400">
              <span>AI 대신 검증된 기본 조합을 보여드리고 있어요.</span>
              <button
                type="button"
                onClick={() => void submit()}
                className="shrink-0 rounded-full border border-yellow-500/40 px-3 py-1 font-semibold text-yellow-300 transition-colors hover:border-[var(--accent)] hover:text-[var(--accent)]"
              >
                다시 시도
              </button>
            </div>
          )}

          {result.issues.length > 0 && (
            <ul className="mb-3 space-y-1">
              {result.issues.map((issue) => (
                <li
                  key={issue.id}
                  className={cn(
                    "rounded-md px-3 py-2 text-xs",
                    issue.level === "danger"
                      ? "border border-red-500/40 bg-red-500/10 text-red-400"
                      : "border border-yellow-500/40 bg-yellow-500/10 text-yellow-400"
                  )}
                >
                  {issue.message}
                </li>
              ))}
            </ul>
          )}

          <ul className="divide-y divide-[#27272A]">
            {CATEGORY_ORDER.map((category: PartCategory) => {
              const part = result.selections[category];
              const price = partPrice[category];
              return (
                <li key={category} className="flex items-center justify-between py-2.5 text-sm">
                  <div className="flex flex-col">
                    <span className="text-[10px] uppercase tracking-wide text-[#9CA3AF]">
                      {CATEGORY_LABEL[category]}
                    </span>
                    <span className="text-[#E4E4E7]">{part ? partTitle(part) : "미선택"}</span>
                    {part && <span className="text-xs text-[#9CA3AF]">{partSpecLine(part)}</span>}
                  </div>
                  <span className="shrink-0 font-mono text-xs font-semibold text-[#E4E4E7]">
                    {!part ? "-" : price !== null ? formatPriceKrw(price) : "조회중"}
                  </span>
                </li>
              );
            })}
          </ul>

          <div className="mt-3 flex items-center justify-between border-t border-[#27272A] pt-3">
            <span className="text-sm font-medium text-[#9CA3AF]">총 견적 가격</span>
            <span className="font-mono text-lg font-bold text-[var(--accent)]">
              {totalPriceLoading ? "가격 조회중..." : formatPriceKrw(totalPrice)}
            </span>
          </div>

          <button
            type="button"
            onClick={() => onApply(result.selections)}
            className="mt-5 w-full rounded-full bg-[var(--accent)] py-3 text-sm font-bold text-[#0a0a0b] transition-transform hover:scale-[1.02] active:scale-[0.98]"
          >
            이대로 견적 짜기 →
          </button>
        </div>
      )}
      </div>
    </div>
  );
}
