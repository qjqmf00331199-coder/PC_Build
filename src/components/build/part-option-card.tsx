"use client";

import type { Part } from "@/lib/types";
import { partMeta, partNote, partSpecLine, partTitle } from "@/lib/part-specs";
import { cn } from "@/lib/utils";

export function PartOptionCard({
  part,
  selected,
  onSelect,
  onHover,
}: {
  part: Part;
  selected: boolean;
  onSelect: () => void;
  onHover?: () => void;
}) {
  const metaLabel = partMeta(part);
  const note = partNote(part);

  return (
    <button
      type="button"
      onClick={onSelect}
      onMouseEnter={onHover}
      onFocus={onHover}
      aria-pressed={selected}
      className={cn(
        "flex flex-col items-start gap-1 rounded-lg border border-[#27272A] bg-[#151517] px-4 py-3 text-left transition-colors duration-150 hover:border-[#3F3F46]",
        selected && "ring-1 ring-[#6366F1] border-[#6366F1]/50"
      )}
    >
      <div className="flex w-full items-center justify-between gap-2">
        <span className="text-xs text-[#9CA3AF]">{metaLabel ?? " "}</span>
        {selected && (
          <span className="rounded-full bg-[#6366F1]/15 px-2 py-0.5 text-[10px] font-medium text-[#6366F1]">
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
