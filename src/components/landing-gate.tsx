"use client";

import { useState } from "react";
import { cn } from "@/lib/utils";

const FEATURES = [
  { title: "실시간 호환성 체크", desc: "소켓, 전원, 크기까지 부품 고를 때마다 즉시 확인" },
  { title: "한눈에 보는 견적", desc: "선택한 부품과 예상 총액을 사이드에서 바로 확인" },
];

export function LandingGate({ children }: { children: React.ReactNode }) {
  const [entered, setEntered] = useState(false);

  if (entered) {
    return (
      <div className="relative">
        <button
          type="button"
          onClick={() => setEntered(false)}
          className="fixed right-3 top-3 z-50 rounded-full border border-[#27272A] bg-[#151517] px-3 py-1.5 text-xs text-[#9CA3AF] transition-colors hover:text-[var(--accent)] lg:right-4 lg:top-4"
        >
          ← 처음으로
        </button>
        {children}
      </div>
    );
  }

  return (
    <div className="relative mx-auto flex min-h-dvh max-w-3xl flex-col items-center justify-center px-6 py-16 text-center">
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

      <button
        type="button"
        onClick={() => setEntered(true)}
        className={cn(
          "mt-12 rounded-full bg-[var(--accent)] px-8 py-3.5 text-sm font-bold text-[#0a0a0b]",
          "transition-transform hover:scale-[1.03] active:scale-[0.98]"
        )}
      >
        PC 부품 골라보기 →
      </button>
    </div>
  );
}
