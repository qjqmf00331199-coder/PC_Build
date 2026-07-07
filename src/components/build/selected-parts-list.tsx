"use client";

import { CATEGORY_LABEL, CATEGORY_ORDER } from "@/lib/compatibility";
import { CATEGORY_ICON } from "@/lib/category-icons";
import { partTitle } from "@/lib/part-specs";
import { formatPriceKrw } from "@/lib/use-product-info";
import { useBuild } from "./build-provider";
import { cn } from "@/lib/utils";

const DOT_COLOR: Record<"success" | "warning" | "danger" | "idle", string> = {
  idle: "#3F3F46",
  success: "#22C55E",
  warning: "#F59E0B",
  danger: "#EF4444",
};

export function SelectedPartsList() {
  const { effectiveSelections, categoryStatus, openCategory, partInfo } = useBuild();

  return (
    <div className="mt-5 border-t border-[#27272A] pt-4">
      <span className="mb-2 block text-xs font-medium uppercase tracking-wide text-[#9CA3AF]">
        선택한 부품
      </span>
      <ul className="space-y-1">
        {CATEGORY_ORDER.map((category) => {
          const Icon = CATEGORY_ICON[category];
          const part = effectiveSelections[category];
          const status = categoryStatus[category];
          const price = part ? partInfo[category].price : null;
          return (
            <li key={category}>
              <button
                type="button"
                onClick={() => openCategory(category)}
                className="flex w-full items-center gap-2 rounded-md px-1.5 py-1.5 text-left transition-colors duration-150 hover:bg-white/5"
              >
                <span
                  className="h-1.5 w-1.5 shrink-0 rounded-full transition-colors duration-300 ease-in-out"
                  style={{ backgroundColor: DOT_COLOR[status] }}
                />
                <Icon className="h-3.5 w-3.5 shrink-0 text-[#9CA3AF]" strokeWidth={1.75} />
                <span className="min-w-0 flex-1 truncate text-xs text-[#9CA3AF]">
                  {CATEGORY_LABEL[category]}
                </span>
                <span className="flex min-w-0 max-w-[50%] flex-col items-end">
                  <span
                    className={cn(
                      "w-full truncate text-right text-xs",
                      part ? "text-[#E4E4E7]" : "text-[#9CA3AF]/60"
                    )}
                  >
                    {part ? partTitle(part) : "미선택"}
                  </span>
                  {part && (
                    <span className="font-mono text-[10px] text-[var(--accent)]">
                      {price !== null ? formatPriceKrw(price) : "조회중"}
                    </span>
                  )}
                </span>
              </button>
            </li>
          );
        })}
      </ul>
    </div>
  );
}
