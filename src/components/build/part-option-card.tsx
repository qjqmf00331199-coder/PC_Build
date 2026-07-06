"use client";

import type { Part } from "@/lib/types";
import { partMeta, partNote, partSpecLine, partTitle } from "@/lib/part-specs";
import { cn } from "@/lib/utils";

export function PartOptionCard({
  part,
  selected,
  onSelect,
}: {
  part: Part;
  selected: boolean;
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
        selected
          ? "border-[var(--accent)] bg-[var(--accent)]/5"
          : "border-[#27272A] hover:border-[#3F3F46]"
      )}
    >
      <div className="flex w-full items-center justify-between gap-2">
        <span className="text-xs text-[#9CA3AF]">{metaLabel ?? " "}</span>
        {selected && (
          <span className="rounded-full bg-[var(--accent)]/15 px-2 py-0.5 text-[10px] font-medium text-[var(--accent)]">
            선택됨
          </span>
        )}
      </div>
      <span className="text-sm font-medium text-[#E4E4E7]">{partTitle(part)}</span>
      <span className="font-mono text-xs text-[#9CA3AF]">{partSpecLine(part)}</span>
      {note && <span className="text-xs italic text-[#F59E0B]/80">{note}</span>}
    </button>
  );
}
