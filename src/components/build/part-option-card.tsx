"use client";

import type { Part } from "@/lib/types";
import { cn } from "@/lib/utils";

function meta(part: Part): string | null {
  switch (part.category) {
    case "cpu":
      return part.brand;
    case "gpu":
      return part.series;
    case "case":
      return part.tower_type;
    default:
      return null;
  }
}

function title(part: Part): string {
  switch (part.category) {
    case "cpu":
      return `${part.tier} ${part.model}`;
    default:
      return part.model;
  }
}

function specLine(part: Part): string {
  switch (part.category) {
    case "cpu":
      return `${part.socket} · ${part.cores_threads} · TDP ${part.tdp_w}W · ${part.base_ghz}~${part.boost_ghz}GHz`;
    case "motherboard":
      return `${part.socket} · ${part.chipset} · ${part.form_factor} · ${part.memory_type}`;
    case "ram":
      return `${part.type}-${part.speed_mhz}${part.voltage_v ? ` · ${part.voltage_v}V` : ""}`;
    case "ssd":
      return `${part.type} · ${part.interface}`;
    case "gpu":
      return `VRAM ${part.vram_gb}GB${part.tdp_w ? ` · TDP ${part.tdp_w}W` : ""} · 권장 PSU ${part.recommended_psu_w}W · ${part.length_mm}mm`;
    case "psu":
      return `${part.watt}W · ${part.grade} · ${part.form_factor}`;
    case "case":
      return `GPU ${part.gpu_max_length_mm}mm · 쿨러 ${part.cpu_cooler_max_height_mm}mm`;
    case "cooler":
      return part.type === "air"
        ? `공랭 · 높이 ${part.height_mm}mm`
        : `수랭 · 라디에이터 ${part.radiator_size_mm}mm`;
  }
}

function noteText(part: Part): string | null {
  if (!("extra" in part)) return null;
  const note = part.extra?.note;
  return typeof note === "string" ? note : null;
}

export function PartOptionCard({
  part,
  selected,
  onSelect,
}: {
  part: Part;
  selected: boolean;
  onSelect: () => void;
}) {
  const metaLabel = meta(part);
  const note = noteText(part);

  return (
    <button
      type="button"
      onClick={onSelect}
      aria-pressed={selected}
      className={cn(
        "flex flex-col items-start gap-1 rounded-lg border border-[#27272A] bg-[#151517] px-4 py-3 text-left transition-colors duration-150 hover:border-[#3F3F46]",
        selected && "ring-1 ring-[#6366F1] border-[#6366F1]/50"
      )}
    >
      <div className="flex w-full items-center justify-between gap-2">
        <span className="text-xs text-[#9CA3AF]">{metaLabel ?? " "}</span>
        {selected && (
          <span className="rounded-full bg-[#6366F1]/15 px-2 py-0.5 text-[10px] font-medium text-[#6366F1]">
            선택됨
          </span>
        )}
      </div>
      <span className="text-sm font-medium text-[#E4E4E7]">{title(part)}</span>
      <span className="font-mono text-xs text-[#9CA3AF]">{specLine(part)}</span>
      {note && <span className="text-xs italic text-[#F59E0B]/80">{note}</span>}
    </button>
  );
}
