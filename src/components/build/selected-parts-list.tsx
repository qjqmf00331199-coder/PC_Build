"use client";

import { CATEGORY_LABEL, CATEGORY_ORDER } from "@/lib/compatibility";
import { CATEGORY_ICON } from "@/lib/category-icons";
import { partTitle } from "@/lib/part-specs";
import { useBuild } from "./build-provider";
import { cn } from "@/lib/utils";

const DOT_COLOR: Record<"success" | "warning" | "danger" | "idle", string> = {
  idle: "#3F3F46",
  success: "#22C55E",
  warning: "#F59E0B",
  danger: "#EF4444",
};

export function SelectedPartsList() {
  const { selections, categoryStatus, openCategory } = useBuild();

  return (
    <div className="mt-5 border-t border-[#27272A] pt-4">
      <span className="mb-2 block text-xs font-medium uppercase tracking-wide text-[#9CA3AF]">
        선택한 부품
      </span>
      <ul className="space-y-1">
        {CATEGORY_ORDER.map((category) => {
          const Icon = CATEGORY_ICON[category];
          const part = selections[category];
          const status = categoryStatus[category];
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
                <span
                  className={cn(
                    "min-w-0 max-w-[45%] truncate text-xs",
                    part ? "text-[#E4E4E7]" : "text-[#9CA3AF]/60"
                  )}
                >
                  {part ? partTitle(part) : "미선택"}
                </span>
              </button>
            </li>
          );
        })}
      </ul>
    </div>
  );
}
