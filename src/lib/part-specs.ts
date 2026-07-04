import type { Part } from "./types";

export function partMeta(part: Part): string | null {
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

export function partTitle(part: Part): string {
  switch (part.category) {
    case "cpu":
      return `${part.tier} ${part.model}`;
    default:
      return part.model;
  }
}

export function partSpecLine(part: Part): string {
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

const CATEGORY_SEARCH_HINT: Partial<Record<Part["category"], string>> = {
  motherboard: "메인보드",
  ram: "RAM",
  ssd: "SSD",
  psu: "파워서플라이",
  cooler: "쿨러",
};

export function partImageQuery(part: Part): string {
  const prefix = partMeta(part) ?? CATEGORY_SEARCH_HINT[part.category] ?? "";
  return [prefix, partTitle(part)].filter(Boolean).join(" ");
}

export function partNote(part: Part): string | null {
  if (!("extra" in part)) return null;
  const note = part.extra?.note;
  return typeof note === "string" ? note : null;
}

export interface SpecRow {
  label: string;
  value: string;
}

export function partFullSpecs(part: Part): SpecRow[] {
  switch (part.category) {
    case "cpu":
      return [
        { label: "브랜드", value: part.brand },
        { label: "티어", value: part.tier },
        { label: "소켓", value: part.socket },
        { label: "코어/스레드", value: part.cores_threads },
        { label: "클럭", value: `${part.base_ghz}GHz ~ ${part.boost_ghz}GHz` },
        { label: "캐시", value: part.cache },
        { label: "TDP", value: `${part.tdp_w}W` },
        { label: "지원 메모리", value: part.memory },
        ...(part.codename ? [{ label: "코드네임", value: part.codename }] : []),
      ];
    case "motherboard":
      return [
        { label: "소켓", value: part.socket },
        { label: "칩셋", value: part.chipset },
        { label: "폼팩터", value: part.form_factor },
        { label: "크기", value: `${part.width_mm} x ${part.depth_mm}mm` },
        { label: "메모리 타입", value: part.memory_type },
        {
          label: "PCIe x16 슬롯",
          value:
            part.pcie_x16_total_slots !== null
              ? `${part.pcie_x16_usable_slots} 사용가능 / ${part.pcie_x16_total_slots} 전체`
              : `${part.pcie_x16_usable_slots}개`,
        },
      ];
    case "ram":
      return [
        { label: "타입", value: part.type },
        { label: "속도", value: `${part.speed_mhz}MHz` },
        ...(part.voltage_v ? [{ label: "전압", value: `${part.voltage_v}V` }] : []),
        ...(part.heatsink_height_mm
          ? [{ label: "방열판 높이", value: `${part.heatsink_height_mm}mm` }]
          : []),
      ];
    case "ssd":
      return [
        { label: "타입", value: part.type },
        { label: "인터페이스", value: part.interface },
      ];
    case "gpu":
      return [
        { label: "시리즈", value: part.series },
        { label: "VRAM", value: `${part.vram_gb}GB` },
        ...(part.tdp_w ? [{ label: "TDP", value: `${part.tdp_w}W` }] : []),
        { label: "전원 커넥터", value: part.connector },
        { label: "권장 PSU", value: `${part.recommended_psu_w}W` },
        { label: "길이", value: `${part.length_mm}mm` },
        { label: "두께", value: part.thickness },
        { label: "팬 개수", value: `${part.fans}개` },
        { label: "검증 여부", value: part.verified ? "검증됨" : "미검증" },
      ];
    case "psu":
      return [
        { label: "용량", value: `${part.watt}W` },
        { label: "등급", value: part.grade },
        { label: "길이", value: `${part.length_mm}mm` },
        { label: "ATX 버전", value: part.atx_version },
        { label: "폼팩터", value: part.form_factor },
      ];
    case "case":
      return [
        { label: "타워 타입", value: part.tower_type },
        { label: "지원 메인보드", value: part.supported_mb },
        { label: "GPU 최대 길이", value: `${part.gpu_max_length_mm}mm` },
        { label: "쿨러 최대 높이", value: `${part.cpu_cooler_max_height_mm}mm` },
        { label: "PSU 지지", value: part.psu_support },
        { label: "PSU 장착 위치", value: part.psu_position },
        ...(part.psu_max_length_mm
          ? [{ label: "PSU 최대 길이", value: `${part.psu_max_length_mm}mm` }]
          : []),
        ...(part.radiator_top_mm ? [{ label: "라디에이터(상단)", value: `${part.radiator_top_mm}mm` }] : []),
        ...(part.radiator_front_mm
          ? [{ label: "라디에이터(전면)", value: `${part.radiator_front_mm}mm` }]
          : []),
        ...(part.radiator_side_mm ? [{ label: "라디에이터(측면)", value: `${part.radiator_side_mm}mm` }] : []),
      ];
    case "cooler":
      return [
        { label: "타입", value: part.type === "air" ? "공랭" : "수랭" },
        ...(part.height_mm ? [{ label: "높이", value: `${part.height_mm}mm` }] : []),
        ...(part.radiator_size_mm
          ? [{ label: "라디에이터 크기", value: `${part.radiator_size_mm}mm` }]
          : []),
        { label: "지원 소켓", value: part.supported_sockets },
      ];
  }
}
