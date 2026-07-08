"use client";

import { useState } from "react";
import dynamic from "next/dynamic";
import { ChevronDown, Gauge } from "lucide-react";
import { BOTTLENECK_LEVEL_CONFIG } from "./bottleneck-gauge";
import { BuildProvider, useBuild } from "./build-provider";
import { CaseIllustration } from "./case-illustration";
import { CategoryStage } from "./category-stage";
import { MikuEasterEgg } from "./miku-easter-egg";
import { SelectedPartsList } from "./selected-parts-list";
import { SummaryPanel } from "./summary-panel";
import { evaluateAllBottlenecks, worstLevel } from "@/lib/bottleneck";
import type { PartsData } from "@/lib/supabase/fetch-parts";
import type { Selections } from "@/lib/types";
import { cn } from "@/lib/utils";

const BottleneckModal = dynamic(() =>
  import("./bottleneck-gauge").then((m) => m.BottleneckModal)
);

function MobileCompactBar() {
  const { activeCategory } = useBuild();
  if (activeCategory !== null) return null;

  return (
    <div className="mb-5 shrink-0 rounded-lg border border-[#27272A] bg-[#151517] p-4 lg:hidden">
      <CaseIllustration compact />
    </div>
  );
}

// 병목 진단은 팝업으로 뜬다 — 진단 대상 부품(CPU/GPU/메인보드/SSD 등)이 2개 이상
// 선택돼서 진단 항목이 하나라도 있으면, 배지를 눌러 모달로 자세히 볼 수 있게 한다.
// 모바일은 한 줄 요약만 보이고 탭해야 펼쳐지는 아코디언(진행 상황 카드용)이라
// 배지 클릭은 별도로 stopPropagation해서 아코디언 토글과 겹치지 않게 한다.
function TopSummaryPanel() {
  const { activeCategory, effectiveSelections, selectedCount, totalCategories, totalPowerW } = useBuild();
  const bottleneckEntries = evaluateAllBottlenecks(effectiveSelections);
  const showBottleneck = bottleneckEntries.length > 0;
  const bottleneckLevel = worstLevel(bottleneckEntries);
  const [expanded, setExpanded] = useState(false);
  const [bottleneckOpen, setBottleneckOpen] = useState(false);

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
                role="button"
                tabIndex={0}
                onClick={(e) => {
                  e.stopPropagation();
                  setBottleneckOpen(true);
                }}
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
        {expanded && <div className="mt-4"><SummaryPanel /></div>}
      </div>

      {/* sm 이상: 항상 펼쳐진 상태, 병목 진단 있으면 진행 상황 카드 옆에 트리거 버튼 배치 */}
      <div className={cn("hidden gap-4 sm:grid", showBottleneck && "sm:grid-cols-2")}>
        <SummaryPanel />
        {showBottleneck && bottleneckLevel && (
          <button
            type="button"
            onClick={() => setBottleneckOpen(true)}
            className="rounded-lg border border-[#27272A] bg-[#151517] p-5 text-left transition-colors hover:border-[var(--accent)]"
          >
            <div className="mb-4 flex items-center justify-between">
              <span className="flex items-center gap-1.5 text-xs font-medium uppercase tracking-wide text-[#9CA3AF]">
                <Gauge className="h-3.5 w-3.5" />
                성능 병목 진단
              </span>
              <span
                className={cn(
                  "inline-flex items-center rounded-full border px-2 py-0.5 text-xs font-medium",
                  BOTTLENECK_LEVEL_CONFIG[bottleneckLevel].classes
                )}
              >
                {BOTTLENECK_LEVEL_CONFIG[bottleneckLevel].label}
              </span>
            </div>
            <p className="text-xs text-[#9CA3AF]">클릭하면 자세히 볼 수 있어요.</p>
          </button>
        )}
      </div>

      <BottleneckModal entries={bottleneckEntries} open={bottleneckOpen} onClose={() => setBottleneckOpen(false)} />
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
        "relative mx-auto flex h-dvh max-w-6xl flex-col overflow-hidden px-3 pb-14 pt-3 sm:px-4 sm:pt-4 lg:px-6 lg:pt-4 2xl:pb-6",
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
