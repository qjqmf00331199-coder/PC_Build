"use client";

import { useBuild } from "./build-provider";
import type { CompatLevel } from "@/lib/types";
import { formatPriceKrw } from "@/lib/use-product-info";
import { cn } from "@/lib/utils";

const FILL: Record<CompatLevel, string> = {
  idle: "#3F3F46",
  success: "#22C55E",
  warning: "#F59E0B",
  danger: "#EF4444",
};

function statusText(
  selectedCount: number,
  issues: { level: "warning" | "danger"; message: string }[]
) {
  const danger = issues.find((i) => i.level === "danger");
  if (danger) return danger.message;
  const warning = issues.find((i) => i.level === "warning");
  if (warning) return warning.message;
  if (selectedCount === 0) return "부품을 선택하면 실시간으로 호환성을 확인합니다.";
  return "선택한 부품이 서로 호환됩니다.";
}

export function CaseIllustration({ compact = false }: { compact?: boolean }) {
  const { categoryStatus, issues, selectedCount, totalPrice, totalPriceLoading } = useBuild();
  const text = statusText(selectedCount, issues);
  const overallDanger = issues.some((i) => i.level === "danger");
  const overallWarning = !overallDanger && issues.some((i) => i.level === "warning");
  const priceLabel =
    selectedCount === 0 ? null : totalPriceLoading ? "가격 조회중..." : `${formatPriceKrw(totalPrice)}`;

  return (
    <div className={cn("flex flex-col gap-4", compact && "flex-row items-center gap-4")}>
      <svg
        viewBox="0 0 360 480"
        className={
          compact ? "w-[88px] max-w-[88px] shrink-0" : "w-full max-w-[300px] mx-auto"
        }
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
      >
        {/* case outer shell */}
        <rect
          x="8"
          y="8"
          width="344"
          height="464"
          rx="10"
          stroke={FILL[categoryStatus.case]}
          strokeWidth="2.5"
          className="transition-[stroke] duration-300 ease-in-out"
          fill="#151517"
        />

        {/* motherboard */}
        <rect
          x="26"
          y="26"
          width="220"
          height="330"
          rx="4"
          fill={FILL[categoryStatus.motherboard]}
          fillOpacity="0.18"
          stroke={FILL[categoryStatus.motherboard]}
          strokeWidth="2"
          className="transition-[fill,stroke] duration-300 ease-in-out"
        />

        {/* cooler (behind/around cpu, tower shape) */}
        <rect
          x="52"
          y="46"
          width="70"
          height="70"
          rx="6"
          fill={FILL[categoryStatus.cooler]}
          fillOpacity="0.25"
          stroke={FILL[categoryStatus.cooler]}
          strokeWidth="2"
          className="transition-[fill,stroke] duration-300 ease-in-out"
        />
        {/* cooler fins */}
        {[0, 1, 2, 3, 4].map((i) => (
          <line
            key={i}
            x1={60 + i * 13}
            y1="52"
            x2={60 + i * 13}
            y2="110"
            stroke={FILL[categoryStatus.cooler]}
            strokeWidth="2"
            className="transition-[stroke] duration-300 ease-in-out"
          />
        ))}

        {/* cpu (under cooler) */}
        <rect
          x="72"
          y="66"
          width="30"
          height="30"
          rx="3"
          fill={FILL[categoryStatus.cpu]}
          className="transition-[fill] duration-300 ease-in-out"
        />

        {/* RAM sticks */}
        <rect
          x="150"
          y="46"
          width="14"
          height="120"
          rx="2"
          fill={FILL[categoryStatus.ram]}
          className="transition-[fill] duration-300 ease-in-out"
        />
        <rect
          x="172"
          y="46"
          width="14"
          height="120"
          rx="2"
          fill={FILL[categoryStatus.ram]}
          className="transition-[fill] duration-300 ease-in-out"
        />

        {/* SSD (m.2, small chip near mobo) */}
        <rect
          x="204"
          y="130"
          width="46"
          height="16"
          rx="2"
          fill={FILL[categoryStatus.ssd]}
          className="transition-[fill] duration-300 ease-in-out"
        />

        {/* GPU */}
        <rect
          x="40"
          y="230"
          width="200"
          height="46"
          rx="4"
          fill={FILL[categoryStatus.gpu]}
          className="transition-[fill] duration-300 ease-in-out"
        />
        <rect x="40" y="230" width="34" height="46" rx="4" fill="#0A0A0B" fillOpacity="0.35" />

        {/* PSU */}
        <rect
          x="26"
          y="392"
          width="220"
          height="64"
          rx="4"
          fill={FILL[categoryStatus.psu]}
          className="transition-[fill] duration-300 ease-in-out"
        />

        {/* case side panel accent (right column, always tied to case status) */}
        <rect
          x="270"
          y="26"
          width="56"
          height="430"
          rx="4"
          fill={FILL[categoryStatus.case]}
          fillOpacity="0.12"
          stroke={FILL[categoryStatus.case]}
          strokeWidth="1.5"
          className="transition-[fill,stroke] duration-300 ease-in-out"
        />
      </svg>

      {!compact && (
        <div className="space-y-3">
          <p
            className={cn(
              "text-center text-sm font-medium leading-snug",
              overallDanger && "text-[#EF4444]",
              overallWarning && "text-[#F59E0B]",
              !overallDanger && !overallWarning && "text-[#E4E4E7]"
            )}
          >
            {text}
          </p>
          <div className="flex items-center justify-center gap-4 text-xs text-[#9CA3AF]">
            <Legend color={FILL.success} label="호환" />
            <Legend color={FILL.warning} label="주의" />
            <Legend color={FILL.danger} label="불가" />
          </div>
          {priceLabel && (
            <div className="border-t border-[#27272A] pt-3 text-center">
              <span className="block text-[10px] uppercase tracking-wide text-[#9CA3AF]">총 견적 가격</span>
              <span className="font-mono text-lg font-bold text-[var(--accent)]">{priceLabel}</span>
            </div>
          )}
        </div>
      )}

      {compact && (
        <div className="min-w-0 flex-1">
          <p
            className={cn(
              "line-clamp-2 text-xs font-medium leading-snug",
              overallDanger && "text-[#EF4444]",
              overallWarning && "text-[#F59E0B]",
              !overallDanger && !overallWarning && "text-[#E4E4E7]"
            )}
          >
            {text}
          </p>
          {priceLabel && (
            <p className="mt-1 font-mono text-sm font-bold text-[var(--accent)]">
              총 견적 {priceLabel}
            </p>
          )}
        </div>
      )}
    </div>
  );
}

function Legend({ color, label }: { color: string; label: string }) {
  return (
    <span className="inline-flex items-center gap-1.5">
      <span className="h-2.5 w-2.5 rounded-full" style={{ backgroundColor: color }} />
      {label}
    </span>
  );
}
