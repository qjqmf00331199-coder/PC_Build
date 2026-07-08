export type CoolerType = "air" | "aqua";

export interface CPU {
  id: string;
  category: "cpu";
  brand: string;
  tier: string;
  model: string;
  codename: string | null;
  socket: string;
  cores_threads: string;
  base_ghz: number;
  boost_ghz: number;
  cache: string;
  tdp_w: number;
  memory: string;
  extra: Record<string, unknown> | null;
}

export interface Motherboard {
  id: string;
  category: "motherboard";
  model: string;
  socket: string;
  chipset: string;
  form_factor: string;
  width_mm: number;
  depth_mm: number;
  pcie_x16_usable_slots: number;
  pcie_x16_total_slots: number | null;
  memory_type: string;
  extra: Record<string, unknown> | null;
}

export interface RAM {
  id: string;
  category: "ram";
  type: string;
  model: string;
  speed_mhz: number;
  heatsink_height_mm: number | null;
  voltage_v: number | null;
  extra: Record<string, unknown> | null;
}

export interface SSD {
  id: string;
  category: "ssd";
  model: string;
  type: string;
  interface: string;
}

export interface GPU {
  id: string;
  category: "gpu";
  series: string;
  model: string;
  vram_gb: number;
  tdp_w: number | null;
  connector: string;
  recommended_psu_w: number;
  length_mm: number;
  thickness: string;
  fans: number;
  verified: boolean;
  extra: Record<string, unknown> | null;
  power_connector_pins: 8 | 12;
  power_connector_count: number;
}

export type AtxSpec = "ATX12V" | "ATX3.0" | "ATX3.1";
export type GpuPowerConnectorGen = "12VHPWR" | "12V-2x6";

export interface PSU {
  id: string;
  category: "psu";
  model: string;
  watt: number;
  grade: string;
  length_mm: number;
  atx_version: string;
  form_factor: string;
  extra: Record<string, unknown> | null;
  atx_spec: AtxSpec;
  native_gpu_connector: GpuPowerConnectorGen | null;
}

export interface PCCase {
  id: string;
  category: "case";
  model: string;
  tower_type: string;
  supported_mb: string;
  gpu_max_length_mm: number;
  cpu_cooler_max_height_mm: number;
  psu_support: string;
  psu_position: string;
  psu_max_length_mm: string | number | null;
  radiator_top_mm: string | number | null;
  radiator_front_mm: string | number | null;
  radiator_side_mm: string | number | null;
}

export interface Cooler {
  id: string;
  category: "cooler";
  model: string;
  type: CoolerType;
  height_mm: number | null;
  radiator_size_mm: number | null;
  supported_sockets: string;
  extra: Record<string, unknown> | null;
}

export type Part = CPU | Motherboard | RAM | SSD | GPU | PSU | PCCase | Cooler;

export type PartCategory =
  | "cpu"
  | "motherboard"
  | "ram"
  | "ssd"
  | "gpu"
  | "psu"
  | "case"
  | "cooler";

export interface PartMap {
  cpu: CPU;
  motherboard: Motherboard;
  ram: RAM;
  ssd: SSD;
  gpu: GPU;
  psu: PSU;
  case: PCCase;
  cooler: Cooler;
}

export type Selections = {
  [K in PartCategory]?: PartMap[K];
};

export type CompatLevel = "success" | "warning" | "danger" | "idle";

export interface CompatIssue {
  id: string;
  level: "warning" | "danger";
  message: string;
  categories: PartCategory[];
}
