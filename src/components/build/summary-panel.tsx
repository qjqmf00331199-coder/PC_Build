"use client";

import { Gauge } from "lucide-react";
import { useBuild } from "./build-provider";
import { cn } from "@/lib/utils";

export function SummaryPanel({ compact = false }: { compact?: boolean }) {
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
    <div className={cn("rounded-lg border border-[#27272A] bg-[#151517]", compact ? "p-3" : "p-5")}>
      <div className={cn("flex items-center justify-between", compact ? "mb-2" : "mb-4")}>
        <span
          className={cn(
            "font-medium uppercase tracking-wide text-[#9CA3AF]",
            compact ? "text-[10px]" : "text-xs"
          )}
        >
          빌드 진행 상황
        </span>
        <span className={cn("font-mono font-semibold text-[#E4E4E7]", compact ? "text-xs" : "text-sm")}>
          {selectedCount} / {totalCategories}
        </span>
      </div>

      <div className={cn("h-1.5 w-full overflow-hidden rounded-full bg-[#27272A]", compact ? "mb-3" : "mb-4")}>
        <div
          className="h-full rounded-full bg-[var(--accent)] transition-[width] duration-300 ease-in-out"
          style={{ width: `${(selectedCount / totalCategories) * 100}%` }}
        />
      </div>

      <div className={cn("grid gap-4", compact ? "grid-cols-2 gap-x-3 gap-y-0" : "grid-cols-2")}>
        <div>
          <span className={cn("block text-[#9CA3AF]", compact ? "text-[9px]" : "text-xs")}>
            예상 총 소비전력
          </span>
          <span className={cn("font-mono font-semibold text-[#E4E4E7]", compact ? "text-xs" : "text-lg")}>
            {totalPowerW}W
          </span>
        </div>
        <div>
          <span className={cn("flex items-center gap-1 text-[#9CA3AF]", compact ? "text-[9px]" : "text-xs")}>
            <Gauge className="h-3 w-3" /> PSU 여유율
          </span>
          <span className={cn("font-mono font-semibold", compact ? "text-xs" : "text-lg", marginColor)}>
            {psuMarginPct === null ? "-" : `${psuMarginPct}%`}
          </span>
        </div>
      </div>

      {!compact && effectiveSelections.psu && (
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
