"use client";

import { Cpu, Gpu, Gauge, CheckCircle2, AlertTriangle, X } from "lucide-react";
import type { PerformanceTier, BottleneckEntry, BottleneckLevel } from "@/lib/bottleneck";
import { cn } from "@/lib/utils";

export const BOTTLENECK_LEVEL_CONFIG: Record<BottleneckLevel, { label: string; classes: string; barColor: string }> = {
  success: {
    label: "이상 없음",
    classes: "text-[#22C55E] bg-[#22C55E]/10 border-[#22C55E]/30",
    barColor: "bg-[#22C55E]",
  },
  warning: {
    label: "병목 발생 가능",
    classes: "text-[#F59E0B] bg-[#F59E0B]/10 border-[#F59E0B]/30",
    barColor: "bg-[#F59E0B]",
  },
  danger: {
    label: "병목 심함 · 비추천",
    classes: "text-[#EF4444] bg-[#EF4444]/10 border-[#EF4444]/30",
    barColor: "bg-[#EF4444]",
  },
};

function ScoreBar({
  icon: Icon,
  label,
  score,
  tier,
  barColor,
  weaker,
}: {
  icon: typeof Cpu;
  label: string;
  score: number;
  tier: PerformanceTier;
  barColor: string;
  weaker: boolean;
}) {
  return (
    <div>
      <div className="mb-1 flex items-center justify-between text-xs">
        <span className="flex items-center gap-1.5 text-[#9CA3AF]">
          <Icon className="h-3.5 w-3.5" strokeWidth={1.75} />
          {label}
        </span>
        <span className="font-mono font-semibold text-[#E4E4E7]">
          {tier}티어 · {score}점
        </span>
      </div>
      <div className="h-1.5 w-full overflow-hidden rounded-full bg-[#27272A]">
        <div
          className={cn("h-full rounded-full transition-[width] duration-300 ease-in-out", weaker ? barColor : "bg-[var(--accent)]")}
          style={{ width: `${score}%` }}
        />
      </div>
    </div>
  );
}

function DiagnosisRow({ entry }: { entry: BottleneckEntry }) {
  const { classes, barColor } = BOTTLENECK_LEVEL_CONFIG[entry.level];

  return (
    <div className="rounded-md border border-[#27272A] bg-black/20 p-3">
      <div className="mb-2 flex items-center justify-between gap-2">
        <span className="text-xs font-medium text-[#E4E4E7]">{entry.label}</span>
        <span className={cn("inline-flex shrink-0 items-center gap-1 rounded-full border px-2 py-0.5 text-[10px] font-medium", classes)}>
          {entry.level === "success" ? <CheckCircle2 className="h-3 w-3" /> : <AlertTriangle className="h-3 w-3" />}
          {BOTTLENECK_LEVEL_CONFIG[entry.level].label}
        </span>
      </div>

      {entry.scores && (
        <div className="mb-2 space-y-2">
          <ScoreBar
            icon={Cpu}
            label="CPU"
            score={entry.scores.cpuScore}
            tier={entry.scores.cpuTier}
            barColor={barColor}
            weaker={entry.scores.direction === "cpu"}
          />
          <ScoreBar
            icon={Gpu}
            label="GPU"
            score={entry.scores.gpuScore}
            tier={entry.scores.gpuTier}
            barColor={barColor}
            weaker={entry.scores.direction === "gpu"}
          />
        </div>
      )}

      <p className="text-xs leading-snug text-[#9CA3AF]">{entry.message}</p>
    </div>
  );
}

export function BottleneckModal({
  entries,
  open,
  onClose,
}: {
  entries: BottleneckEntry[];
  open: boolean;
  onClose: () => void;
}) {
  return (
    <div
      className={cn(
        "fixed inset-0 z-[70] flex items-end justify-center bg-black/60 p-0 transition-opacity duration-300 sm:items-center sm:p-4",
        open ? "opacity-100" : "pointer-events-none opacity-0"
      )}
      onClick={() => {
        // 데스크탑(sm 이상)에서는 바깥 클릭으로 안 닫고 X 버튼만 닫게 함, 모바일은 바깥 탭하면 닫힘
        if (typeof window !== "undefined" && window.matchMedia("(min-width: 640px)").matches) return;
        onClose();
      }}
    >
      <div
        className={cn(
          "flex max-h-[85vh] w-full max-w-md flex-col rounded-t-xl border border-[#27272A] bg-[#151517] transition-transform duration-300 ease-out sm:rounded-xl",
          open ? "translate-y-0" : "translate-y-full"
        )}
        onClick={(e) => e.stopPropagation()}
      >
        <div className="flex shrink-0 items-center justify-between border-b border-[#27272A] px-5 py-4">
          <div className="flex items-center gap-2">
            <Gauge className="h-4.5 w-4.5 text-[var(--accent)]" strokeWidth={1.75} />
            <h3 className="text-sm font-semibold text-[#E4E4E7]">성능 병목 진단</h3>
          </div>
          <button
            type="button"
            onClick={onClose}
            aria-label="닫기"
            className="rounded-md p-1 text-[#9CA3AF] hover:text-[#E4E4E7]"
          >
            <X className="h-4 w-4" strokeWidth={2} />
          </button>
        </div>

        <div className="min-h-0 flex-1 space-y-2 overflow-y-auto px-5 py-4">
          {entries.map((entry) => (
            <DiagnosisRow key={entry.id} entry={entry} />
          ))}
        </div>
      </div>
    </div>
  );
}
