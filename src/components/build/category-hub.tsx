"use client";

import { AlertTriangle } from "lucide-react";
import type { PartCategory, PartMap } from "@/lib/types";
import { CATEGORY_LABEL, CATEGORY_ORDER } from "@/lib/compatibility";
import { CATEGORY_ICON } from "@/lib/category-icons";
import { partTitle } from "@/lib/part-specs";
import { useBuild } from "./build-provider";
import { StatusBadge } from "./status-badge";
import type { PartsData } from "@/lib/supabase/fetch-parts";
import { cn } from "@/lib/utils";

export function CategoryHub({ parts }: { parts: PartsData }) {
  const { selections, categoryStatus, issuesFor, openCategory } = useBuild();

  return (
    <div className="lg:h-full lg:overflow-y-auto lg:pr-1">
      <h2 className="mb-3 text-sm font-semibold text-[#E4E4E7]">카테고리 선택</h2>
      <div className="grid grid-cols-1 gap-3 sm:grid-cols-2">
        {CATEGORY_ORDER.map((category) => (
          <CategoryCard
            key={category}
            category={category}
            options={parts[category]}
            selected={selections[category]}
            status={categoryStatus[category]}
            issueCount={issuesFor(category).length}
            onOpen={() => openCategory(category)}
          />
        ))}
      </div>
    </div>
  );
}

function CategoryCard<K extends PartCategory>({
  category,
  options,
  selected,
  status,
  issueCount,
  onOpen,
}: {
  category: K;
  options: PartMap[K][];
  selected: PartMap[K] | undefined;
  status: "success" | "warning" | "danger" | "idle";
  issueCount: number;
  onOpen: () => void;
}) {
  const Icon = CATEGORY_ICON[category as PartCategory];

  return (
    <button
      type="button"
      onClick={onOpen}
      className={cn(
        "flex flex-col gap-3 rounded-lg border-2 bg-[#151517] p-5 text-left transition-colors duration-150",
        selected
          ? "border-[#6366F1] bg-[#6366F1]/5"
          : "border-[#27272A] hover:border-[#3F3F46]"
      )}
    >
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2.5">
          <Icon className="h-4.5 w-4.5 text-[#9CA3AF]" strokeWidth={1.75} />
          <span className="text-sm font-semibold text-[#E4E4E7]">{CATEGORY_LABEL[category]}</span>
        </div>
        <StatusBadge level={status} />
      </div>

      <div>
        <p className={cn("text-sm", selected ? "text-[#E4E4E7]" : "text-[#9CA3AF]")}>
          {selected ? partTitle(selected) : "미선택"}
        </p>
        <p className="mt-0.5 text-xs text-[#9CA3AF]">{options.length}개 옵션</p>
      </div>

      {issueCount > 0 && (
        <div className="flex items-center gap-1.5 text-xs text-[#F59E0B]">
          <AlertTriangle className="h-3.5 w-3.5" strokeWidth={2} />
          이슈 {issueCount}건
        </div>
      )}
    </button>
  );
}
