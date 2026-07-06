"use client";

import { useEffect, useMemo, useState } from "react";
import { ArrowLeft, AlertTriangle, ImageOff, Search, XCircle } from "lucide-react";
import type { Part, PartCategory, PartMap } from "@/lib/types";
import { CATEGORY_LABEL } from "@/lib/compatibility";
import { CATEGORY_ICON } from "@/lib/category-icons";
import { partFullSpecs, partImageQuery, partMeta, partNote, partTitle } from "@/lib/part-specs";
import { useBuild } from "./build-provider";
import { PartOptionCard } from "./part-option-card";
import { StatusBadge } from "./status-badge";
import { SummaryPanel } from "./summary-panel";
import { cn } from "@/lib/utils";

const STATUS_COLOR: Record<"success" | "warning" | "danger" | "idle", string> = {
  idle: "#3F3F46",
  success: "#22C55E",
  warning: "#F59E0B",
  danger: "#EF4444",
};

const imageCache = new Map<string, string | null>();

function useProductImage(query: string | null): string | null {
  const [image, setImage] = useState<string | null>(query ? imageCache.get(query) ?? null : null);

  useEffect(() => {
    if (!query) {
      setImage(null);
      return;
    }

    const cached = imageCache.get(query);
    if (cached !== undefined) {
      setImage(cached);
      return;
    }

    let active = true;
    setImage(null);

    fetch(`/api/product-image?q=${encodeURIComponent(query)}`)
      .then((res) => res.json())
      .then((data: { image: string | null }) => {
        imageCache.set(query, data.image ?? null);
        if (active) setImage(data.image ?? null);
      })
      .catch(() => {
        if (active) setImage(null);
      });

    return () => {
      active = false;
    };
  }, [query]);

  return image;
}

export function CategoryDetail<K extends PartCategory>({
  category,
  options,
}: {
  category: K;
  options: PartMap[K][];
}) {
  const { selections, categoryStatus, selectPart, issuesFor, closeCategory, preview, previewPick } =
    useBuild();
  const Icon = CATEGORY_ICON[category as PartCategory];
  const selected = selections[category];
  const status = categoryStatus[category];
  const relevantIssues = issuesFor(category);

  const pickedPart = preview as PartMap[K] | undefined;

  const [search, setSearch] = useState("");
  useEffect(() => {
    setSearch("");
  }, [category]);
  const filteredOptions = useMemo(() => {
    const q = search.trim().toLowerCase();
    if (!q) return options;
    return options.filter((part) => partTitle(part).toLowerCase().includes(q));
  }, [options, search]);

  return (
    <div className="flex h-full flex-col">
      <button
        type="button"
        onClick={closeCategory}
        className="mb-4 inline-flex shrink-0 items-center gap-1.5 text-sm text-[#9CA3AF] transition-colors duration-150 hover:text-[#E4E4E7]"
      >
        <ArrowLeft className="h-4 w-4" strokeWidth={2} />
        전체 카테고리
      </button>

      <div className="mb-4 flex shrink-0 items-center justify-between gap-3">
        <div className="flex shrink-0 items-center gap-2.5">
          <Icon className="h-5 w-5 text-[#9CA3AF]" strokeWidth={1.75} />
          <h2 className="text-base font-semibold text-[#E4E4E7]">{CATEGORY_LABEL[category]}</h2>
        </div>
        <div className="relative min-w-0 flex-1">
          <Search className="pointer-events-none absolute left-2.5 top-1/2 h-3.5 w-3.5 -translate-y-1/2 text-[#71717A]" strokeWidth={2} />
          <input
            type="text"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="제품명 검색"
            className="w-full rounded-md border border-[#27272A] bg-[#0A0A0B] py-1.5 pl-8 pr-3 text-sm text-[#E4E4E7] placeholder-[#71717A] outline-none transition-colors duration-150 focus:border-[#6366F1]"
          />
        </div>
        <StatusBadge level={status} />
      </div>

      <div className="grid min-h-0 flex-1 grid-cols-2 grid-rows-[auto_minmax(0,1fr)] gap-3 lg:grid-rows-none lg:gap-4">
        {/* build progress: shares the top row with the detail panel on mobile; desktop keeps its own full-width copy above */}
        <div className="col-start-1 row-start-1 lg:hidden">
          <SummaryPanel compact />
        </div>

        {/* photo + detailed spec panel: always fully shown, no clipping/scrolling on mobile */}
        <div className="col-start-2 row-start-1 lg:h-full lg:overflow-y-auto lg:pr-1">
          {options.length > 0 ? (
            <DetailPanel
              part={pickedPart}
              committed={pickedPart?.id === selected?.id}
              status={status}
              placeholderIcon={Icon}
              onConfirm={() => {
                if (!pickedPart) return;
                if (selected?.id !== pickedPart.id) {
                  selectPart(category, pickedPart);
                }
                closeCategory();
              }}
            />
          ) : (
            <div className="rounded-lg border border-[#27272A] bg-[#151517] p-6 text-sm text-[#9CA3AF]">
              선택 가능한 제품이 없습니다.
            </div>
          )}

          {relevantIssues.length > 0 && (
            <ul className="mt-4 space-y-1.5 rounded-lg border border-[#27272A] bg-[#151517] p-4">
              {relevantIssues.map((issue) => {
                const IssueIcon = issue.level === "danger" ? XCircle : AlertTriangle;
                return (
                  <li
                    key={issue.id}
                    className={cn(
                      "flex items-start gap-1.5 text-xs leading-snug",
                      issue.level === "danger" ? "text-[#EF4444]" : "text-[#F59E0B]"
                    )}
                  >
                    <IssueIcon className="mt-0.5 h-3.5 w-3.5 shrink-0" strokeWidth={2} />
                    {issue.message}
                  </li>
                );
              })}
            </ul>
          )}
        </div>

        {/* product list: own scroll container so scrolling it never moves the rest of the page */}
        <div className="col-span-2 row-start-2 flex min-h-0 flex-col gap-2.5 overflow-y-auto pr-1 lg:col-span-1 lg:col-start-1 lg:row-start-1 lg:h-full">
          {filteredOptions.length === 0 && (
            <div className="rounded-lg border border-[#27272A] bg-[#151517] p-6 text-sm text-[#9CA3AF]">
              검색 결과가 없습니다.
            </div>
          )}
          {filteredOptions.map((part) => (
            <PartOptionCard
              key={part.id}
              part={part}
              selected={pickedPart?.id === part.id}
              onSelect={() => {
                if (selected?.id === part.id) {
                  // clicking the already-committed item again deselects it directly
                  selectPart(category, part);
                  closeCategory();
                } else {
                  previewPick(part);
                }
              }}
            />
          ))}
        </div>
      </div>
    </div>
  );
}

function DetailPanel({
  part,
  committed,
  status,
  placeholderIcon: PlaceholderIcon,
  onConfirm,
}: {
  part: Part | undefined;
  committed: boolean;
  status: "success" | "warning" | "danger" | "idle";
  placeholderIcon: typeof ImageOff;
  onConfirm: () => void;
}) {
  const imageUrl = useProductImage(part ? partImageQuery(part) : null);

  if (!part) {
    return (
      <div className="rounded-lg border border-[#27272A] bg-[#151517] p-3 lg:p-5">
        <div className="mb-3 flex h-24 w-full items-center justify-center rounded-lg border border-[#27272A] bg-white/[0.02] lg:mb-4 lg:h-40">
          <PlaceholderIcon className="h-10 w-10 text-[#3F3F46] lg:h-14 lg:w-14" strokeWidth={1.25} />
        </div>
        <p className="text-xs text-[#9CA3AF] lg:text-sm">
          왼쪽 목록에서 제품을 선택하면 사진과 상세 스펙이 여기에 표시됩니다.
        </p>
        <button
          type="button"
          disabled
          className="mt-3 w-full cursor-not-allowed rounded-lg border border-[#27272A] py-2 text-xs font-medium text-[#9CA3AF]/50 lg:mt-5 lg:py-2.5 lg:text-sm"
        >
          제품을 선택하세요
        </button>
      </div>
    );
  }

  const metaLabel = partMeta(part);
  const note = partNote(part);
  const specs = partFullSpecs(part);

  return (
    <div className="rounded-lg border border-[#27272A] bg-[#151517] p-3 lg:p-5">
      <div
        className="mb-3 flex h-24 w-full items-center justify-center overflow-hidden rounded-lg border transition-colors duration-300 ease-in-out lg:mb-4 lg:h-40"
        style={{
          borderColor: STATUS_COLOR[status],
          backgroundColor: `${STATUS_COLOR[status]}0F`,
        }}
      >
        {imageUrl ? (
          // eslint-disable-next-line @next/next/no-img-element
          <img src={imageUrl} alt={partTitle(part)} className="h-full w-full object-contain" />
        ) : (
          <PlaceholderIcon className="h-10 w-10 lg:h-14 lg:w-14" strokeWidth={1.25} style={{ color: STATUS_COLOR[status] }} />
        )}
      </div>

      <div className="flex items-start justify-between gap-2">
        <div>
          {metaLabel && <p className="text-[11px] text-[#9CA3AF] lg:text-xs">{metaLabel}</p>}
          <h3 className="text-sm font-semibold text-[#E4E4E7] lg:text-base">{partTitle(part)}</h3>
        </div>
        {committed && (
          <span className="shrink-0 rounded-full bg-[#6366F1]/15 px-2 py-0.5 text-[10px] font-medium text-[#6366F1]">
            선택됨
          </span>
        )}
      </div>

      {note && <p className="mt-1 text-[11px] italic text-[#F59E0B]/80 lg:text-xs">{note}</p>}

      <dl className="mt-3 grid grid-cols-2 gap-x-3 gap-y-1.5 border-t border-[#27272A] pt-3 lg:mt-4 lg:block lg:space-y-2 lg:pt-4">
        {specs.map((row) => (
          <div
            key={row.label}
            className="flex flex-col gap-0.5 text-[11px] lg:flex-row lg:items-start lg:justify-between lg:gap-3 lg:text-xs"
          >
            <dt className="text-[#9CA3AF]">{row.label}</dt>
            <dd className="font-mono text-[#E4E4E7] lg:text-right">{row.value}</dd>
          </div>
        ))}
      </dl>

      <button
        type="button"
        onClick={onConfirm}
        className="mt-3 w-full rounded-lg bg-[#6366F1] py-2 text-xs font-medium text-white transition-colors duration-150 hover:bg-[#6366F1]/90 lg:mt-5 lg:py-2.5 lg:text-sm"
      >
        이 제품 선택하기
      </button>
    </div>
  );
}
