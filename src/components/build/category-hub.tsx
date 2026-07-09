"use client";

import { AlertTriangle, RefreshCw } from "lucide-react";
import type { PartCategory, PartMap } from "@/lib/types";
import { CATEGORY_LABEL, CATEGORY_ORDER } from "@/lib/compatibility";
import { CATEGORY_ICON } from "@/lib/category-icons";
import { partTitle } from "@/lib/part-specs";
import { formatPriceKrw } from "@/lib/use-product-info";
import { useBuild } from "./build-provider";
import { StatusBadge } from "./status-badge";
import { PurchaseReceipt } from "./purchase-receipt";
import type { PartsData } from "@/lib/supabase/fetch-parts";
import { cn } from "@/lib/utils";

export function CategoryHub({ parts }: { parts: PartsData }) {
  const { selections, categoryStatus, issuesFor, openCategory, resetSelections, partInfo, selectPart } = useBuild();

  return (
    <div className="h-full overflow-y-auto pr-1">
      <div className="mb-3 flex items-center justify-between">
        <h2 className="text-sm font-semibold text-[#E4E4E7]">카테고리 선택</h2>
        <button
          type="button"
          onClick={resetSelections}
          className="flex items-center gap-1.5 rounded-full border border-[#27272A] px-3 py-1.5 text-xs text-[#9CA3AF] transition-colors hover:border-[var(--accent)] hover:text-[var(--accent)]"
        >
          <RefreshCw className="h-3.5 w-3.5" strokeWidth={2} />
          새로고침
        </button>
      </div>
      <div className="grid grid-cols-1 gap-3 sm:grid-cols-2">
        {CATEGORY_ORDER.map((category) => (
          <CategoryCard
            key={category}
            category={category}
            options={parts[category]}
            selected={selections[category]}
            status={categoryStatus[category]}
            issueCount={issuesFor(category).length}
            price={selections[category] ? partInfo[category].price : null}
            onOpen={() => openCategory(category)}
            onRemove={
              selections[category]
                ? () => selectPart(category, selections[category]!)
                : undefined
            }
          />
        ))}
      </div>

      <PurchaseReceipt />
    </div>
  );
}

function CategoryCard<K extends PartCategory>({
  category,
  options,
  selected,
  status,
  issueCount,
  price,
  onOpen,
  onRemove,
}: {
  category: K;
  options: PartMap[K][];
  selected: PartMap[K] | undefined;
  status: "success" | "warning" | "danger" | "idle";
  issueCount: number;
  price: number | null;
  onOpen: () => void;
  onRemove?: () => void;
}) {
  const Icon = CATEGORY_ICON[category as PartCategory];

  return (
    <button
      type="button"
      onClick={onOpen}
      className={cn(
        "flex flex-col gap-3 rounded-lg border-2 bg-[#151517] p-3 text-left transition-colors duration-150 sm:p-4 lg:p-5",
        selected
          ? "border-[var(--accent)] bg-[var(--accent)]/5"
          : "border-[#27272A] hover:border-[#3F3F46]"
      )}
    >
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2.5">
          <Icon className="h-4.5 w-4.5 text-[#9CA3AF]" strokeWidth={1.75} />
          <span className="text-sm font-semibold text-[#E4E4E7]">{CATEGORY_LABEL[category]}</span>
        </div>
        {onRemove ? (
          <span
            role="button"
            tabIndex={0}
            onClick={(e) => {
              e.stopPropagation();
              onRemove();
            }}
            onKeyDown={(e) => {
              if (e.key === "Enter" || e.key === " ") {
                e.preventDefault();
                e.stopPropagation();
                onRemove();
              }
            }}
            title="선택 해제"
            className="cursor-pointer"
          >
            <StatusBadge level={status} />
          </span>
        ) : (
          <StatusBadge level={status} />
        )}
      </div>

      <div className="flex items-end justify-between gap-2">
        <div className="min-w-0">
          <p className={cn("truncate text-sm", selected ? "text-[#E4E4E7]" : "text-[#9CA3AF]")}>
            {selected ? partTitle(selected) : "미선택"}
          </p>
          <p className="mt-0.5 text-xs text-[#9CA3AF]">{options.length}개 옵션</p>
        </div>
        {selected && (
          <span className="shrink-0 font-mono text-sm font-semibold text-[var(--accent)]">
            {price !== null ? formatPriceKrw(price) : "조회중"}
          </span>
        )}
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
