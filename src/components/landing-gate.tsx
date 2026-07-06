"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { AdSlots } from "@/components/ad-slots";
import { BuildChecker } from "@/components/build/build-checker";
import { AiRecommendWizard } from "@/components/ai-recommend/ai-recommend-wizard";
import type { PartsData } from "@/lib/supabase/fetch-parts";
import type { Selections } from "@/lib/types";
import { cn } from "@/lib/utils";

const FEATURES = [
  { title: "실시간 호환성 체크", desc: "소켓, 전원, 크기까지 부품 고를 때마다 즉시 확인" },
  { title: "한눈에 보는 견적", desc: "선택한 부품과 예상 총액을 사이드에서 바로 확인" },
];

type View = "landing" | "ai" | "build";
type NavState = { view: View; depth: number };

export function LandingGate({ parts }: { parts: PartsData }) {
  const [view, setView] = useState<View>("landing");
  const [initialSelections, setInitialSelections] = useState<Selections | undefined>(undefined);

  // intercept the mobile/browser back button so it steps back through in-app
  // screens (landing <-> ai/build <-> category detail, the latter owned by
  // BuildProvider) instead of leaving the site
  useEffect(() => {
    // the React view state above always starts fresh at "landing" on mount
    // (selections aren't persisted either), so pin the history entry to match
    // regardless of whatever stale state a prior session left behind
    window.history.replaceState({ ...window.history.state, view: "landing", depth: 0 }, "");
    const onPopState = (e: PopStateEvent) => {
      const state = e.state as NavState | null;
      setView(state?.view ?? "landing");
    };
    window.addEventListener("popstate", onPopState);
    return () => window.removeEventListener("popstate", onPopState);
  }, []);

  // one level deeper than wherever we are now (landing -> ai/build)
  const enter = (next: View) => {
    const depth = ((window.history.state as NavState | null)?.depth ?? 0) + 1;
    window.history.pushState({ ...window.history.state, view: next, depth }, "");
    setView(next);
  };

  // swap the current screen without adding a back-button step (ai wizard -> build results)
  const swapInPlace = (next: View) => {
    const depth = (window.history.state as NavState | null)?.depth ?? 0;
    window.history.replaceState({ ...window.history.state, view: next, depth }, "");
    setView(next);
  };

  // jump straight back to the landing screen regardless of how deep we are
  // (e.g. the TriFit logo click from inside an open category detail)
  const backToLanding = () => {
    const depth = (window.history.state as NavState | null)?.depth ?? 0;
    if (depth > 0) window.history.go(-depth);
    else setView("landing");
  };

  if (view === "build") {
    return (
      <div className="relative">
        <AdSlots />
        <BuildChecker
          parts={parts}
          initialSelections={initialSelections}
          onLogoClick={() => {
            setInitialSelections(undefined);
            backToLanding();
          }}
        />
      </div>
    );
  }

  if (view === "ai") {
    return (
      <>
        <AdSlots narrow />
        <AiRecommendWizard
          onCancel={backToLanding}
          onApply={(selections) => {
            setInitialSelections(selections);
            swapInPlace("build");
          }}
        />
      </>
    );
  }

  return (
    <div className="relative mx-auto flex min-h-dvh max-w-3xl flex-col items-center justify-center px-6 py-16 text-center">
      <AdSlots narrow />
      <div className="mb-2 flex items-center gap-2 text-[10px] tracking-[0.2em] text-[var(--accent)] sm:text-xs">
        <span className="h-1.5 w-1.5 shrink-0 rounded-full bg-[var(--accent)]" />
        실시간 하드웨어 호환성 체크
      </div>

      <h1 className="text-5xl font-extrabold tracking-tight sm:text-7xl">
        <span className="text-[#E4E4E7]">Tri</span>
        <span className="text-[var(--accent)]">FIT</span>
      </h1>

      <p className="mt-4 max-w-md text-sm text-[#9CA3AF] sm:text-base">
        부품을 하나씩 고르면 소켓·전원·크기 호환성을 그 자리에서 바로 확인해주는 PC 견적 도구입니다.
      </p>

      <div className="mt-10 grid w-full grid-cols-1 gap-3 sm:grid-cols-2">
        {FEATURES.map((f) => (
          <div
            key={f.title}
            className="rounded-lg border border-[#27272A] bg-[#151517] p-4 text-left"
          >
            <div className="text-sm font-semibold text-[#E4E4E7]">{f.title}</div>
            <div className="mt-1 text-xs text-[#9CA3AF]">{f.desc}</div>
          </div>
        ))}
      </div>

      <div className="mt-12 flex flex-col items-center gap-3 sm:flex-row">
        <button
          type="button"
          onClick={() => enter("ai")}
          className={cn(
            "rounded-full border border-[var(--accent)] px-8 py-3.5 text-sm font-bold text-[var(--accent)]",
            "transition-transform hover:scale-[1.03] active:scale-[0.98]"
          )}
        >
          AI에게 추천받기 ✨
        </button>
        <button
          type="button"
          onClick={() => enter("build")}
          className={cn(
            "rounded-full bg-[var(--accent)] px-8 py-3.5 text-sm font-bold text-[#0a0a0b]",
            "transition-transform hover:scale-[1.03] active:scale-[0.98]"
          )}
        >
          PC 부품 골라보기 →
        </button>
      </div>

      <footer className="mt-16 flex flex-col items-center gap-2 text-[11px] text-[#71717A]">
        <p>부품 스펙·가격 데이터 출처: 다나와 · 제품 이미지: 네이버쇼핑 API / 각 제조사</p>
        <div className="flex items-center gap-3">
          <Link href="/privacy" className="hover:text-[#9CA3AF]">
            개인정보처리방침
          </Link>
          <span className="text-[#27272A]">|</span>
          <Link href="/terms" className="hover:text-[#9CA3AF]">
            이용약관
          </Link>
        </div>
      </footer>
    </div>
  );
}
