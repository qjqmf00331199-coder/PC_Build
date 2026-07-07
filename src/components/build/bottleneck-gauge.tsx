"use client";

import { Cpu, Gpu, Gauge } from "lucide-react";
import type { CPU, GPU } from "@/lib/types";
import { evaluateBottleneck, type BottleneckLevel } from "@/lib/bottleneck";
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
  tier: string;
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

export function BottleneckGauge({ cpu, gpu, compact = false }: { cpu: CPU; gpu: GPU; compact?: boolean }) {
  const result = evaluateBottleneck(cpu, gpu);
  const { label, classes, barColor } = BOTTLENECK_LEVEL_CONFIG[result.level];

  return (
    <div className={cn("rounded-lg border border-[#27272A] bg-[#151517]", compact ? "p-3" : "p-5")}>
      <div className={cn("flex items-center justify-between", compact ? "mb-2" : "mb-4")}>
        <span
          className={cn(
            "flex items-center gap-1.5 font-medium uppercase tracking-wide text-[#9CA3AF]",
            compact ? "text-[10px]" : "text-xs"
          )}
        >
          <Gauge className="h-3.5 w-3.5" />
          성능 병목 진단
        </span>
        <span
          className={cn(
            "inline-flex items-center rounded-full border px-2 py-0.5 text-xs font-medium",
            classes
          )}
        >
          {label}
        </span>
      </div>

      <div className="space-y-3">
        <ScoreBar
          icon={Cpu}
          label="CPU"
          score={result.cpuScore}
          tier={result.cpuTier}
          barColor={barColor}
          weaker={result.direction === "cpu"}
        />
        <ScoreBar
          icon={Gpu}
          label="GPU"
          score={result.gpuScore}
          tier={result.gpuTier}
          barColor={barColor}
          weaker={result.direction === "gpu"}
        />
      </div>

      {!compact && <p className="mt-4 text-xs leading-snug text-[#9CA3AF]">{result.message}</p>}
    </div>
  );
}
