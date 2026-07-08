"use client";

import { useEffect, useRef, useState } from "react";
import Link from "next/link";
import { AnimatePresence, motion, type Variants } from "framer-motion";
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
type Direction = "left" | "right";

const DURATION = 0.28;
const EASE = [0.4, 0, 0.2, 1] as const;

// direction the landing screen exits toward when entering each view
const EXIT_DIRECTION: Record<"ai" | "build", Direction> = { ai: "right", build: "left" };
const opposite = (d: Direction): Direction => (d === "left" ? "right" : "left");

// dir = the direction content moves in: the outgoing screen exits toward
// `dir`, the incoming screen starts from the opposite side and moves toward
// `dir` too, so both slide past each other instead of one just vanishing
const variants: Variants = {
  enter: (dir: Direction) => ({ x: dir === "left" ? "100%" : "-100%", opacity: 0 }),
  center: { x: "0%", opacity: 1 },
  exit: (dir: Direction) => ({ x: dir === "left" ? "-100%" : "100%", opacity: 0 }),
};

// pointerEvents can't be animated, and framer-motion's own timing hooks for
// non-animatable values (transition delay, transitionEnd) turned out not to
// actually wait for the slide to finish in testing — the incoming screen
// stayed clickable (or, with transitionEnd, stayed permanently unclickable)
// regardless of its real on-screen position. So this is driven by plain React
// state instead: not interactive until settle fires, with a timer as a backstop
// in case onAnimationComplete doesn't fire (e.g. the very first, non-animated mount).
function AnimatedScreen({ direction, children }: { direction: Direction; children: React.ReactNode }) {
  const [settled, setSettled] = useState(false);

  useEffect(() => {
    const timer = setTimeout(() => setSettled(true), DURATION * 1000 + 50);
    return () => clearTimeout(timer);
  }, []);

  return (
    <motion.div
      custom={direction}
      variants={variants}
      initial="enter"
      animate="center"
      exit="exit"
      transition={{ duration: DURATION, ease: EASE }}
      onAnimationComplete={(target) => {
        if (target === "center") setSettled(true);
      }}
      style={{ pointerEvents: settled ? "auto" : "none" }}
      className="absolute inset-0"
    >
      {children}
    </motion.div>
  );
}

export function LandingGate({ parts }: { parts: PartsData }) {
  const [view, setView] = useState<View>("landing");
  const [direction, setDirection] = useState<Direction>("left");
  const [initialSelections, setInitialSelections] = useState<Selections | undefined>(undefined);

  const viewRef = useRef<View>(view);
  useEffect(() => {
    viewRef.current = view;
  }, [view]);

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
      const nextView = state?.view ?? "landing";
      const prevView = viewRef.current;
      if (nextView === "landing" && (prevView === "ai" || prevView === "build")) {
        setDirection(opposite(EXIT_DIRECTION[prevView]));
      } else if ((nextView === "ai" || nextView === "build") && prevView === "landing") {
        setDirection(EXIT_DIRECTION[nextView]);
      }
      setView(nextView);
    };
    window.addEventListener("popstate", onPopState);
    return () => window.removeEventListener("popstate", onPopState);
  }, []);

  // one level deeper than wherever we are now (landing -> ai/build); AnimatePresence
  // (below) animates the actual slide once `view` changes, so this just flips state
  const enter = (next: "ai" | "build") => {
    setDirection(EXIT_DIRECTION[next]);
    const depth = ((window.history.state as NavState | null)?.depth ?? 0) + 1;
    window.history.pushState({ ...window.history.state, view: next, depth }, "");
    setView(next);
  };

  // swap the current screen without adding a back-button step (ai wizard -> build results)
  const swapInPlace = (next: View) => {
    setDirection("left");
    const depth = (window.history.state as NavState | null)?.depth ?? 0;
    window.history.replaceState({ ...window.history.state, view: next, depth }, "");
    setView(next);
  };

  // jump straight back to the landing screen regardless of how deep we are
  // (e.g. the TriFit logo click from inside an open category detail). when
  // depth > 0 this only triggers the navigation — onPopState (above) is what
  // sets the direction + view once the browser actually fires popstate
  const backToLanding = () => {
    const depth = (window.history.state as NavState | null)?.depth ?? 0;
    if (depth > 0) {
      window.history.go(-depth);
    } else {
      if (view === "ai" || view === "build") setDirection(opposite(EXIT_DIRECTION[view]));
      setView("landing");
    }
  };

  return (
    <div className="relative min-h-dvh overflow-hidden">
      <AnimatePresence initial={false} custom={direction}>
        <AnimatedScreen key={view} direction={direction}>
          {view === "build" && (
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
          )}

          {view === "ai" && (
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
          )}

          {view === "landing" && (
            // same absolute-inset-0 + overflow-hidden shell as the other screens (no
            // page-level scroll), so this owns its own scroll container too — see
            // ai-recommend-wizard.tsx for the same fix on the AI result screen
            <div className="mx-auto h-dvh max-w-3xl overflow-y-auto px-6 py-16">
            <div className="relative flex min-h-full flex-col items-center justify-center text-center">
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
                <p>
                  부품 스펙·가격 데이터 출처: 다나와
                  <br />
                  <span className="pl-3">· 제품 이미지: 네이버쇼핑 API / 각 제조사</span>
                </p>
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
            </div>
          )}
        </AnimatedScreen>
      </AnimatePresence>
    </div>
  );
}
