"use client";

import { useState } from "react";
import { ChevronDown } from "lucide-react";
import { BottleneckGauge, BOTTLENECK_LEVEL_CONFIG } from "./bottleneck-gauge";
import { BuildProvider, useBuild } from "./build-provider";
import { CaseIllustration } from "./case-illustration";
import { CategoryStage } from "./category-stage";
import { MikuEasterEgg } from "./miku-easter-egg";
import { SelectedPartsList } from "./selected-parts-list";
import { SummaryPanel } from "./summary-panel";
import { evaluateBottleneck } from "@/lib/bottleneck";
import type { PartsData } from "@/lib/supabase/fetch-parts";
import type { Selections } from "@/lib/types";
import { cn } from "@/lib/utils";

function MobileCompactBar() {
  const { activeCategory } = useBuild();
  if (activeCategory !== null) return null;

  return (
    <div className="mb-5 shrink-0 rounded-lg border border-[#27272A] bg-[#151517] p-4 lg:hidden">
      <CaseIllustration compact />
    </div>
  );
}

// 병목 진단 카드는 CPU/GPU가 둘 다 선택됐을 때만 뜨는데, sm 이상에서는 진행 상황
// 카드와 나란히 배치해서 자리를 지켜준다. 화면이 더 좁은 모바일에서는 두 카드를
// 펼쳐두면 카테고리 목록 볼 공간이 없어지므로, 기본은 한 줄 요약만 보이고
// 탭해야 펼쳐지는 아코디언으로 접어둔다.
function TopSummaryPanel() {
  const { activeCategory, effectiveSelections, selectedCount, totalCategories, totalPowerW } = useBuild();
  const { cpu, gpu } = effectiveSelections;
  const showBottleneck = Boolean(cpu && gpu);
  const bottleneckLevel = cpu && gpu ? evaluateBottleneck(cpu, gpu).level : null;
  const [expanded, setExpanded] = useState(false);

  const panels = (
    <>
      <SummaryPanel />
      {showBottleneck && cpu && gpu && <BottleneckGauge cpu={cpu} gpu={gpu} />}
    </>
  );

  return (
    <div className={cn(activeCategory !== null && "hidden lg:block")}>
      {/* 모바일: 접힌 한 줄 요약 + 탭하면 펼쳐지는 아코디언 */}
      <div className="sm:hidden">
        <button
          type="button"
          onClick={() => setExpanded((v) => !v)}
          className="flex w-full items-center justify-between gap-2 rounded-lg border border-[#27272A] bg-[#151517] px-4 py-3 text-xs"
        >
          <span className="flex items-center gap-3 font-mono font-semibold text-[#E4E4E7]">
            {selectedCount} / {totalCategories}
            <span className="text-[#9CA3AF]">{totalPowerW}W</span>
          </span>
          <span className="flex items-center gap-2">
            {bottleneckLevel && (
              <span
                className={cn(
                  "rounded-full border px-2 py-0.5 font-medium",
                  BOTTLENECK_LEVEL_CONFIG[bottleneckLevel].classes
                )}
              >
                {BOTTLENECK_LEVEL_CONFIG[bottleneckLevel].label}
              </span>
            )}
            <ChevronDown
              className={cn("h-4 w-4 text-[#9CA3AF] transition-transform duration-200", expanded && "rotate-180")}
            />
          </span>
        </button>
        {expanded && <div className="mt-4 flex flex-col gap-4">{panels}</div>}
      </div>

      {/* sm 이상: 항상 펼쳐진 상태, 병목 카드 있으면 나란히 배치 */}
      <div className={cn("hidden gap-4 sm:grid", showBottleneck && "sm:grid-cols-2")}>{panels}</div>
    </div>
  );
}

export function BuildChecker({
  parts,
  initialSelections,
  onLogoClick,
}: {
  parts: PartsData;
  initialSelections?: Selections;
  onLogoClick?: () => void;
}) {
  return (
    <BuildProvider parts={parts} initialSelections={initialSelections}>
      <BuildCheckerShell parts={parts} onLogoClick={onLogoClick} />
    </BuildProvider>
  );
}

function BuildCheckerShell({ parts, onLogoClick }: { parts: PartsData; onLogoClick?: () => void }) {
  const { isMikuBuild } = useBuild();

  return (
    <div
      className={cn(
        "relative mx-auto flex h-dvh max-w-6xl flex-col overflow-hidden px-3 pb-14 pt-3 sm:px-4 sm:pt-4 lg:px-6 lg:pb-6 lg:pt-4",
        isMikuBuild && "miku-theme"
      )}
    >
      <header className="relative mb-3 shrink-0">
        <div className="mb-1.5 flex items-center gap-2 text-[10px] tracking-[0.2em] text-[var(--accent)] lg:text-xs">
          <span className="h-1.5 w-1.5 shrink-0 rounded-full bg-[var(--accent)]" />
          실시간 하드웨어 호환성 체크
        </div>
        <div className="flex flex-wrap items-center gap-x-3 gap-y-0.5">
          <button type="button" onClick={onLogoClick} className="shrink-0" aria-label="처음 화면으로">
            <h1 className="text-2xl font-extrabold tracking-tight lg:text-4xl">
              <span className="text-[#E4E4E7]">Tri</span>
              <span className="text-[var(--accent)]">FIT</span>
            </h1>
          </button>
          <p className="text-[11px] tracking-wide text-[#9CA3AF] lg:text-sm">
            부품을 고르면 즉시 소켓·전원·크기 호환성을 확인합니다.
          </p>
        </div>
        {isMikuBuild && (
          // eslint-disable-next-line @next/next/no-img-element
          <img
            src="/miku-box.gif"
            alt="상자 미쿠"
            className="pointer-events-none absolute right-0 top-16 h-14 w-auto select-none lg:top-0 lg:h-24"
          />
        )}
      </header>

      {/* mobile compact top bar: only on category hub, not inside a category's product list */}
      <MobileCompactBar />

      <div className="grid min-h-0 flex-1 grid-cols-1 items-stretch gap-4 lg:grid-cols-[300px_1fr] lg:gap-8">
        {/* left illustration panel (desktop): fixed in place, own scroll if it ever overflows */}
        <aside className="hidden lg:block lg:h-full lg:overflow-y-auto lg:rounded-lg lg:border lg:border-[#27272A] lg:bg-[#151517] lg:p-6">
          <CaseIllustration />
          <SelectedPartsList />
        </aside>

        {/* right column */}
        <div className="flex h-full min-h-0 flex-col gap-4 overflow-hidden">
          <TopSummaryPanel />
          <div className="min-h-0 flex-1 overflow-hidden">
            <CategoryStage parts={parts} />
          </div>
        </div>
      </div>

      <MikuEasterEgg active={isMikuBuild} />
    </div>
  );
}
