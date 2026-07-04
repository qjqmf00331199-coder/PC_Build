"use client";

import { Gauge } from "lucide-react";
import { useBuild } from "./build-provider";
import { cn } from "@/lib/utils";

export function SummaryPanel() {
  const { selectedCount, totalCategories, totalPowerW, psuMarginPct, effectiveSelections } = useBuild();

  const marginColor =
    psuMarginPct === null
      ? "text-[#9CA3AF]"
      : psuMarginPct < 0
        ? "text-[#EF4444]"
        : psuMarginPct < 20
          ? "text-[#F59E0B]"
          : "text-[#22C55E]";

  const barColor =
    psuMarginPct === null
      ? "bg-[#3F3F46]"
      : psuMarginPct < 0
        ? "bg-[#EF4444]"
        : psuMarginPct < 20
          ? "bg-[#F59E0B]"
          : "bg-[#22C55E]";

  const barWidth = effectiveSelections.psu
    ? Math.min(100, Math.max(4, (totalPowerW / effectiveSelections.psu.watt) * 100))
    : 0;

  return (
    <div className="rounded-lg border border-[#27272A] bg-[#151517] p-5">
      <div className="mb-4 flex items-center justify-between">
        <span className="text-xs font-medium uppercase tracking-wide text-[#9CA3AF]">
          빌드 진행 상황
        </span>
        <span className="font-mono text-sm font-semibold text-[#E4E4E7]">
          {selectedCount} / {totalCategories}
        </span>
      </div>

      <div className="mb-4 h-1.5 w-full overflow-hidden rounded-full bg-[#27272A]">
        <div
          className="h-full rounded-full bg-[#6366F1] transition-[width] duration-300 ease-in-out"
          style={{ width: `${(selectedCount / totalCategories) * 100}%` }}
        />
      </div>

      <div className="grid grid-cols-2 gap-4">
        <div>
          <span className="block text-xs text-[#9CA3AF]">예상 총 소비전력</span>
          <span className="font-mono text-lg font-semibold text-[#E4E4E7]">{totalPowerW}W</span>
        </div>
        <div>
          <span className="flex items-center gap-1 text-xs text-[#9CA3AF]">
            <Gauge className="h-3 w-3" /> PSU 여유율
          </span>
          <span className={cn("font-mono text-lg font-semibold", marginColor)}>
            {psuMarginPct === null ? "-" : `${psuMarginPct}%`}
          </span>
        </div>
      </div>

      {effectiveSelections.psu && (
        <div className="mt-3 h-1.5 w-full overflow-hidden rounded-full bg-[#27272A]">
          <div
            className={cn("h-full rounded-full transition-[width] duration-300 ease-in-out", barColor)}
            style={{ width: `${barWidth}%` }}
          />
        </div>
      )}
    </div>
  );
}
