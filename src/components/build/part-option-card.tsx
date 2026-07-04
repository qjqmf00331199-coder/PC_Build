"use client";

import type { Part } from "@/lib/types";
import { cn } from "@/lib/utils";

function formatKrw(value: number) {
  return `₩${value.toLocaleString("ko-KR")}`;
}

function specLine(part: Part): string {
  switch (part.category) {
    case "cpu":
      return `${part.socket} · TDP ${part.tdp_w}W · ${part.cores}`;
    case "motherboard":
      return `${part.socket} · ${part.ram_type} · ${part.form_factor} · M.2×${part.m2_slots}`;
    case "ram":
      return `${part.type}-${part.speed_mhz} · ${part.capacity_gb}GB`;
    case "ssd":
      return part.interface === "NVMe"
        ? `NVMe PCIe${part.pcie_version}.0 · ${part.capacity_gb / 1000}TB`
        : `SATA · ${part.capacity_gb / 1000}TB`;
    case "gpu":
      return `${part.length_mm}mm · 권장 PSU ${part.recommended_psu_w}W · ${part.vram_gb}GB`;
    case "psu":
      return `${part.wattage_w}W · ${part.form_factor} · ${part.rating}`;
    case "case":
      return `GPU ${part.max_gpu_length_mm}mm · ${part.psu_form_factor} · 쿨러 ${part.max_cooler_height_mm}mm`;
    case "cooler":
      return part.type === "air"
        ? `공랭 · 높이 ${part.height_mm}mm · TDP ${part.max_tdp_w ?? "-"}W`
        : `수랭 · 라디에이터 ${part.radiator_size_mm}mm`;
  }
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
        <span className="text-xs text-[#9CA3AF]">{part.brand}</span>
        {selected && (
          <span className="rounded-full bg-[#6366F1]/15 px-2 py-0.5 text-[10px] font-medium text-[#6366F1]">
            선택됨
          </span>
        )}
      </div>
      <span className="text-sm font-medium text-[#E4E4E7]">{part.name}</span>
      <span className="font-mono text-xs text-[#9CA3AF]">{specLine(part)}</span>
      <span className="font-mono text-xs text-[#E4E4E7]">{formatKrw(part.price_krw)}</span>
    </button>
  );
}
