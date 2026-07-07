"use client";

import { useEffect, useState } from "react";
import { ExternalLink, Receipt, Scale, ShoppingCart, X } from "lucide-react";
import { CATEGORY_LABEL, CATEGORY_ORDER } from "@/lib/compatibility";
import { CATEGORY_ICON } from "@/lib/category-icons";
import { partImageQuery, partTitle } from "@/lib/part-specs";
import { formatPriceKrw } from "@/lib/use-product-info";
import { fetchDanawaPrice } from "@/lib/danawa-price";
import type { DanawaPriceInfo } from "@/app/api/danawa-price/route";
import type { PartCategory } from "@/lib/types";
import { useBuild } from "./build-provider";
import { cn } from "@/lib/utils";

export function PurchaseReceipt() {
  const { selections, partInfo, selectedCount, totalPrice, totalPriceLoading } = useBuild();
  const [open, setOpen] = useState(false);
  const [compareCategory, setCompareCategory] = useState<PartCategory | null>(null);
  const [danawa, setDanawa] = useState<DanawaPriceInfo | "loading" | null>(null);

  const rows = CATEGORY_ORDER.map((category) => ({
    category,
    part: selections[category],
    info: partInfo[category],
  }));

  useEffect(() => {
    if (!compareCategory) return;
    const part = selections[compareCategory];
    if (!part) return;
    setDanawa("loading");
    let active = true;
    fetchDanawaPrice(partImageQuery(part)).then((data) => {
      if (active) setDanawa(data);
    });
    return () => {
      active = false;
    };
  }, [compareCategory, selections]);

  const compareRow = compareCategory ? rows.find((r) => r.category === compareCategory) : null;

  return (
    <div className="mt-4 border-t border-[#27272A] pt-4">
      <button
        type="button"
        disabled={selectedCount === 0}
        onClick={() => setOpen(true)}
        className="flex w-full items-center justify-center gap-2 rounded-lg bg-[var(--accent)] py-3 text-sm font-semibold text-black transition-opacity duration-150 hover:opacity-90 disabled:cursor-not-allowed disabled:opacity-40"
      >
        <ShoppingCart className="h-4 w-4" strokeWidth={2.25} />
        구매하러 가기
      </button>

      <div
        className={cn(
          "fixed inset-0 z-[70] flex items-end justify-center bg-black/60 p-0 transition-opacity duration-300 sm:items-center sm:p-4",
          open ? "opacity-100" : "pointer-events-none opacity-0"
        )}
        onClick={() => {
          setOpen(false);
          setCompareCategory(null);
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
              <Receipt className="h-4.5 w-4.5 text-[var(--accent)]" strokeWidth={1.75} />
              <h3 className="text-sm font-semibold text-[#E4E4E7]">견적 영수증</h3>
            </div>
            <button
              type="button"
              onClick={() => {
                setOpen(false);
                setCompareCategory(null);
              }}
              aria-label="닫기"
              className="rounded-md p-1 text-[#9CA3AF] hover:text-[#E4E4E7]"
            >
              <X className="h-4 w-4" strokeWidth={2} />
            </button>
          </div>

          <ul className="min-h-0 flex-1 space-y-1 overflow-y-auto px-5 py-3">
            {rows.map(({ category, part, info }) => {
              const Icon = CATEGORY_ICON[category];
              return (
                <li
                  key={category}
                  className="flex items-center gap-2.5 border-b border-[#27272A]/60 py-2 last:border-0"
                >
                  <Icon className="h-4 w-4 shrink-0 text-[#9CA3AF]" strokeWidth={1.75} />
                  <div className="min-w-0 flex-1">
                    <p className="text-[10px] uppercase tracking-wide text-[#9CA3AF]">
                      {CATEGORY_LABEL[category]}
                    </p>
                    <p className="truncate text-xs text-[#E4E4E7]">
                      {part ? partTitle(part) : "미선택"}
                    </p>
                  </div>
                  <span className="shrink-0 font-mono text-xs font-semibold text-[#E4E4E7]">
                    {!part ? "-" : info.price !== null ? formatPriceKrw(info.price) : "조회중"}
                  </span>
                  {part && (
                    <button
                      type="button"
                      onClick={() =>
                        setCompareCategory((prev) => (prev === category ? null : category))
                      }
                      aria-pressed={compareCategory === category}
                      className={cn(
                        "flex shrink-0 items-center gap-1 rounded-full border px-2 py-1 text-[10px] transition-colors",
                        compareCategory === category
                          ? "border-[var(--accent)] bg-[var(--accent)]/15 text-[var(--accent)]"
                          : "border-[#27272A] text-[#9CA3AF] hover:border-[var(--accent)] hover:text-[var(--accent)]"
                      )}
                    >
                      <Scale className="h-3 w-3" strokeWidth={2} />
                      가격 비교
                    </button>
                  )}
                </li>
              );
            })}
          </ul>

          <div className="shrink-0 border-t border-[#27272A] px-5 py-4">
            <div className="flex items-center justify-between">
              <span className="text-sm font-medium text-[#9CA3AF]">총 합계</span>
              <span className="font-mono text-lg font-bold text-[var(--accent)]">
                {totalPriceLoading ? "가격 조회중..." : formatPriceKrw(totalPrice)}
              </span>
            </div>
            <p className="mt-2 text-center text-[10px] text-[#71717A]">
              가격은 네이버쇼핑 최저가 기준이며 실제 구매 시점과 다를 수 있습니다.
            </p>
          </div>
        </div>

        {/* price-compare side drawer: slides in from the right, sits above the receipt modal */}
        <div
          className={cn(
            "fixed inset-y-0 right-0 z-[60] flex w-[85vw] max-w-xs flex-col border-l border-[#27272A] bg-[#151517] shadow-2xl transition-transform duration-300 ease-out",
            compareRow ? "translate-x-0" : "translate-x-full"
          )}
          onClick={(e) => e.stopPropagation()}
        >
          {compareRow && (
            <>
              <div className="flex shrink-0 items-center justify-between border-b border-[#27272A] px-4 py-4">
                <div className="min-w-0">
                  <p className="text-[10px] uppercase tracking-wide text-[#9CA3AF]">
                    {CATEGORY_LABEL[compareRow.category]} 가격 비교
                  </p>
                  <p className="truncate text-xs font-medium text-[#E4E4E7]">
                    {compareRow.part ? partTitle(compareRow.part) : ""}
                  </p>
                </div>
                <button
                  type="button"
                  onClick={() => setCompareCategory(null)}
                  aria-label="닫기"
                  className="shrink-0 rounded-md p-1 text-[#9CA3AF] hover:text-[#E4E4E7]"
                >
                  <X className="h-4 w-4" strokeWidth={2} />
                </button>
              </div>

              <div className="flex-1 space-y-2.5 overflow-y-auto px-4 py-4">
                <CompareSiteRow
                  site="다나와"
                  price={danawa === "loading" || danawa === null ? null : danawa.price}
                  link={danawa === "loading" || danawa === null ? null : danawa.link}
                  loading={danawa === "loading"}
                />
                <CompareSiteRow
                  site="네이버쇼핑"
                  price={compareRow.info.price}
                  link={compareRow.info.link}
                  loading={compareRow.info.price === null && compareRow.info.link === null}
                />
              </div>
            </>
          )}
        </div>
      </div>
    </div>
  );
}

function CompareSiteRow({
  site,
  price,
  link,
  loading,
}: {
  site: string;
  price: number | null;
  link: string | null;
  loading: boolean;
}) {
  const content = (
    <>
      <div className="min-w-0">
        <p className="text-xs font-medium text-[#E4E4E7]">{site}</p>
        <p className="mt-0.5 font-mono text-sm font-semibold text-[var(--accent)]">
          {loading ? "조회중..." : price !== null ? formatPriceKrw(price) : "가격 정보 없음"}
        </p>
      </div>
      {link && <ExternalLink className="h-3.5 w-3.5 shrink-0 text-[#9CA3AF]" strokeWidth={2} />}
    </>
  );

  if (!link) {
    return (
      <div className="flex items-center justify-between rounded-lg border border-[#27272A] bg-[#0A0A0B] px-3 py-3 opacity-60">
        {content}
      </div>
    );
  }

  return (
    <a
      href={link}
      target="_blank"
      rel="noopener noreferrer"
      className="flex items-center justify-between rounded-lg border border-[#27272A] bg-[#0A0A0B] px-3 py-3 transition-colors hover:border-[var(--accent)]"
    >
      {content}
    </a>
  );
}
