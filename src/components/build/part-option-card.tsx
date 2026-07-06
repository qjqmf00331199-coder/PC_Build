"use client";

import type { CompatLevel, Part } from "@/lib/types";
import { partMeta, partNote, partSpecLine, partTitle } from "@/lib/part-specs";
import { cn } from "@/lib/utils";

const COMPAT_BORDER: Record<CompatLevel, string> = {
  idle: "border-[#27272A] hover:border-[#3F3F46]",
  success: "border-[#22C55E] bg-[#22C55E]/5 hover:border-[#22C55E]",
  warning: "border-[#F59E0B] bg-[#F59E0B]/5 hover:border-[#F59E0B]",
  danger: "border-[#EF4444] bg-[#EF4444]/5 hover:border-[#EF4444]",
};

export function PartOptionCard({
  part,
  selected,
  compatLevel = "idle",
  onSelect,
}: {
  part: Part;
  selected: boolean;
  compatLevel?: CompatLevel;
  onSelect: () => void;
}) {
  const metaLabel = partMeta(part);
  const note = partNote(part);

  return (
    <button
      type="button"
      onClick={onSelect}
      aria-pressed={selected}
      className={cn(
        "flex flex-col items-start gap-1 rounded-lg border-2 bg-[#151517] px-3 py-2.5 text-left transition-colors duration-150 sm:px-4 sm:py-3",
        selected ? "border-[var(--accent)] bg-[var(--accent)]/5" : COMPAT_BORDER[compatLevel]
      )}
    >
      <div className="flex w-full items-center justify-between gap-2">
        <span className="text-xs text-[#9CA3AF]">{metaLabel ?? " "}</span>
        {selected ? (
          <span className="rounded-full bg-[var(--accent)]/15 px-2 py-0.5 text-[10px] font-medium text-[var(--accent)]">
            선택됨
          </span>
        ) : compatLevel === "danger" ? (
          <span className="rounded-full bg-[#EF4444]/15 px-2 py-0.5 text-[10px] font-medium text-[#EF4444]">
            비호환
          </span>
        ) : compatLevel === "success" ? (
          <span className="rounded-full bg-[#22C55E]/15 px-2 py-0.5 text-[10px] font-medium text-[#22C55E]">
            호환됨
          </span>
        ) : null}
      </div>
      <span className="text-sm font-medium text-[#E4E4E7]">{partTitle(part)}</span>
      <span className="font-mono text-xs text-[#9CA3AF]">{partSpecLine(part)}</span>
      {note && <span className="text-xs italic text-[#F59E0B]/80">{note}</span>}
    </button>
  );
}
