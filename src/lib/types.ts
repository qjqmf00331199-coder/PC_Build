export type Socket = "LGA1700" | "AM5" | "AM4";
export type RamType = "DDR5" | "DDR4";
export type FormFactor = "ATX" | "mATX" | "ITX";
export type PsuFormFactor = "ATX" | "SFX";
export type CoolerType = "air" | "aqua";

export interface CPU {
  id: string;
  category: "cpu";
  name: string;
  brand: string;
  socket: Socket;
  tdp_w: number;
  cores: string;
  price_krw: number;
}

export interface Motherboard {
  id: string;
  category: "motherboard";
  name: string;
  brand: string;
  socket: Socket;
  ram_type: RamType;
  max_ram_speed_mhz: number;
  max_ram_capacity_gb: number;
  m2_slots: number;
  m2_interface: number; // max supported PCIe generation for M.2
  form_factor: FormFactor;
  price_krw: number;
}

export interface RAM {
  id: string;
  category: "ram";
  name: string;
  brand: string;
  type: RamType;
  speed_mhz: number;
  capacity_gb: number;
  price_krw: number;
}

export interface SSD {
  id: string;
  category: "ssd";
  name: string;
  brand: string;
  interface: "NVMe" | "SATA";
  pcie_version: number | null;
  capacity_gb: number;
  price_krw: number;
}

export interface GPU {
  id: string;
  category: "gpu";
  name: string;
  brand: string;
  length_mm: number;
  recommended_psu_w: number;
  vram_gb: number;
  price_krw: number;
}

export interface PSU {
  id: string;
  category: "psu";
  name: string;
  brand: string;
  wattage_w: number;
  form_factor: PsuFormFactor;
  rating: string;
  price_krw: number;
}

export interface PCCase {
  id: string;
  category: "case";
  name: string;
  brand: string;
  max_gpu_length_mm: number;
  psu_form_factor: PsuFormFactor;
  supported_form_factors: FormFactor[];
  max_cooler_height_mm: number;
  supported_radiator_sizes: number[];
  price_krw: number;
}

export interface Cooler {
  id: string;
  category: "cooler";
  name: string;
  brand: string;
  type: CoolerType;
  supported_sockets: Socket[];
  max_tdp_w: number | null;
  height_mm: number | null;
  radiator_size_mm: number | null;
  price_krw: number;
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
