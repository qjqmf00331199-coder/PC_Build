import type { CPU, Motherboard, RAM, SSD, GPU, PSU, PCCase, Cooler } from "./types";

export const CPUS: CPU[] = [
  { id: "cpu-i5-14600k", category: "cpu", brand: "Intel", name: "Core i5-14600K", socket: "LGA1700", tdp_w: 125, cores: "14C/20T", price_krw: 389000 },
  { id: "cpu-i7-14700k", category: "cpu", brand: "Intel", name: "Core i7-14700K", socket: "LGA1700", tdp_w: 125, cores: "20C/28T", price_krw: 559000 },
  { id: "cpu-i9-14900k", category: "cpu", brand: "Intel", name: "Core i9-14900K", socket: "LGA1700", tdp_w: 125, cores: "24C/32T", price_krw: 749000 },
  { id: "cpu-i3-14100", category: "cpu", brand: "Intel", name: "Core i3-14100", socket: "LGA1700", tdp_w: 60, cores: "4C/8T", price_krw: 159000 },
  { id: "cpu-r5-7600x", category: "cpu", brand: "AMD", name: "Ryzen 5 7600X", socket: "AM5", tdp_w: 105, cores: "6C/12T", price_krw: 259000 },
  { id: "cpu-r7-7800x3d", category: "cpu", brand: "AMD", name: "Ryzen 7 7800X3D", socket: "AM5", tdp_w: 120, cores: "8C/16T", price_krw: 469000 },
  { id: "cpu-r9-7950x", category: "cpu", brand: "AMD", name: "Ryzen 9 7950X", socket: "AM5", tdp_w: 170, cores: "16C/32T", price_krw: 699000 },
  { id: "cpu-r5-5600", category: "cpu", brand: "AMD", name: "Ryzen 5 5600", socket: "AM4", tdp_w: 65, cores: "6C/12T", price_krw: 129000 },
];

export const MOTHERBOARDS: Motherboard[] = [
  { id: "mb-z790-strix", category: "motherboard", brand: "ASUS", name: "ROG STRIX Z790-E GAMING", socket: "LGA1700", ram_type: "DDR5", max_ram_speed_mhz: 7800, max_ram_capacity_gb: 128, m2_slots: 4, m2_interface: 4, form_factor: "ATX", price_krw: 519000 },
  { id: "mb-b760m-pro", category: "motherboard", brand: "MSI", name: "PRO B760M-A DDR5", socket: "LGA1700", ram_type: "DDR5", max_ram_speed_mhz: 6400, max_ram_capacity_gb: 128, m2_slots: 2, m2_interface: 4, form_factor: "mATX", price_krw: 179000 },
  { id: "mb-z790-carbon", category: "motherboard", brand: "MSI", name: "MPG Z790 CARBON WIFI", socket: "LGA1700", ram_type: "DDR5", max_ram_speed_mhz: 7600, max_ram_capacity_gb: 128, m2_slots: 5, m2_interface: 4, form_factor: "ATX", price_krw: 459000 },
  { id: "mb-b650-aorus", category: "motherboard", brand: "GIGABYTE", name: "B650 AORUS ELITE AX", socket: "AM5", ram_type: "DDR5", max_ram_speed_mhz: 6000, max_ram_capacity_gb: 128, m2_slots: 3, m2_interface: 4, form_factor: "ATX", price_krw: 259000 },
  { id: "mb-x670e-tuf", category: "motherboard", brand: "ASUS", name: "TUF GAMING X670E-PLUS", socket: "AM5", ram_type: "DDR5", max_ram_speed_mhz: 6400, max_ram_capacity_gb: 128, m2_slots: 4, m2_interface: 5, form_factor: "ATX", price_krw: 389000 },
  { id: "mb-a620m", category: "motherboard", brand: "GIGABYTE", name: "A620M GAMING X", socket: "AM5", ram_type: "DDR5", max_ram_speed_mhz: 5200, max_ram_capacity_gb: 64, m2_slots: 2, m2_interface: 4, form_factor: "mATX", price_krw: 119000 },
  { id: "mb-b550m-hdv", category: "motherboard", brand: "ASRock", name: "B550M-HDV", socket: "AM4", ram_type: "DDR4", max_ram_speed_mhz: 3200, max_ram_capacity_gb: 64, m2_slots: 1, m2_interface: 3, form_factor: "mATX", price_krw: 89000 },
];

export const RAMS: RAM[] = [
  { id: "ram-z5-6000", category: "ram", brand: "G.Skill", name: "Trident Z5 DDR5-6000 32GB(16Gx2)", type: "DDR5", speed_mhz: 6000, capacity_gb: 32, price_krw: 149000 },
  { id: "ram-vengeance-5600", category: "ram", brand: "Corsair", name: "Vengeance DDR5-5600 32GB(16Gx2)", type: "DDR5", speed_mhz: 5600, capacity_gb: 32, price_krw: 139000 },
  { id: "ram-flarex5-6400", category: "ram", brand: "G.Skill", name: "Flare X5 DDR5-6400 32GB(16Gx2)", type: "DDR5", speed_mhz: 6400, capacity_gb: 32, price_krw: 159000 },
  { id: "ram-fury-5200", category: "ram", brand: "Kingston", name: "FURY Beast DDR5-5200 16GB(8Gx2)", type: "DDR5", speed_mhz: 5200, capacity_gb: 16, price_krw: 79000 },
  { id: "ram-tforce-8000", category: "ram", brand: "TeamGroup", name: "T-Force Delta DDR5-8000 32GB(16Gx2)", type: "DDR5", speed_mhz: 8000, capacity_gb: 32, price_krw: 219000 },
  { id: "ram-vengeance-lpx-3200", category: "ram", brand: "Corsair", name: "Vengeance LPX DDR4-3200 16GB(8Gx2)", type: "DDR4", speed_mhz: 3200, capacity_gb: 16, price_krw: 59000 },
  { id: "ram-crucial-2666", category: "ram", brand: "Crucial", name: "DDR4-2666 8GB", type: "DDR4", speed_mhz: 2666, capacity_gb: 8, price_krw: 29000 },
];

export const SSDS: SSD[] = [
  { id: "ssd-990pro-2tb", category: "ssd", brand: "Samsung", name: "990 PRO 2TB NVMe", interface: "NVMe", pcie_version: 4, capacity_gb: 2000, price_krw: 219000 },
  { id: "ssd-sn850x-1tb", category: "ssd", brand: "WD", name: "Black SN850X 1TB NVMe", interface: "NVMe", pcie_version: 4, capacity_gb: 1000, price_krw: 129000 },
  { id: "ssd-t700-2tb", category: "ssd", brand: "Crucial", name: "T700 2TB NVMe (PCIe 5.0)", interface: "NVMe", pcie_version: 5, capacity_gb: 2000, price_krw: 289000 },
  { id: "ssd-firecuda-2tb", category: "ssd", brand: "Seagate", name: "FireCuda 530 2TB NVMe", interface: "NVMe", pcie_version: 4, capacity_gb: 2000, price_krw: 209000 },
  { id: "ssd-nv2-1tb", category: "ssd", brand: "Kingston", name: "NV2 1TB NVMe", interface: "NVMe", pcie_version: 4, capacity_gb: 1000, price_krw: 79000 },
  { id: "ssd-870evo-1tb", category: "ssd", brand: "Samsung", name: "870 EVO 1TB SATA", interface: "SATA", pcie_version: null, capacity_gb: 1000, price_krw: 99000 },
];

export const GPUS: GPU[] = [
  { id: "gpu-4090-fe", category: "gpu", brand: "NVIDIA", name: "GeForce RTX 4090 Founders Edition", length_mm: 304, recommended_psu_w: 850, vram_gb: 24, price_krw: 2390000 },
  { id: "gpu-4070ti-super", category: "gpu", brand: "NVIDIA", name: "GeForce RTX 4070 Ti SUPER", length_mm: 267, recommended_psu_w: 700, vram_gb: 16, price_krw: 1099000 },
  { id: "gpu-4070", category: "gpu", brand: "NVIDIA", name: "GeForce RTX 4070", length_mm: 242, recommended_psu_w: 650, vram_gb: 12, price_krw: 699000 },
  { id: "gpu-4060", category: "gpu", brand: "NVIDIA", name: "GeForce RTX 4060", length_mm: 200, recommended_psu_w: 550, vram_gb: 8, price_krw: 389000 },
  { id: "gpu-7900xtx", category: "gpu", brand: "AMD", name: "Radeon RX 7900 XTX", length_mm: 320, recommended_psu_w: 800, vram_gb: 24, price_krw: 1199000 },
  { id: "gpu-7800xt", category: "gpu", brand: "AMD", name: "Radeon RX 7800 XT", length_mm: 267, recommended_psu_w: 700, vram_gb: 16, price_krw: 649000 },
];

export const PSUS: PSU[] = [
  { id: "psu-rm850x", category: "psu", brand: "Corsair", name: "RM850x", wattage_w: 850, form_factor: "ATX", rating: "80+ Gold", price_krw: 189000 },
  { id: "psu-focus-gx750", category: "psu", brand: "Seasonic", name: "FOCUS GX-750", wattage_w: 750, form_factor: "ATX", rating: "80+ Gold", price_krw: 149000 },
  { id: "psu-purepower-650", category: "psu", brand: "be quiet!", name: "Pure Power 12 M 650W", wattage_w: 650, form_factor: "ATX", rating: "80+ Gold", price_krw: 109000 },
  { id: "psu-maga650", category: "psu", brand: "MSI", name: "MAG A650BN", wattage_w: 650, form_factor: "ATX", rating: "80+ Bronze", price_krw: 79000 },
  { id: "psu-sf750", category: "psu", brand: "Corsair", name: "SF750", wattage_w: 750, form_factor: "SFX", rating: "80+ Platinum", price_krw: 219000 },
  { id: "psu-v550-sfx", category: "psu", brand: "Cooler Master", name: "V550 SFX", wattage_w: 550, form_factor: "SFX", rating: "80+ Gold", price_krw: 119000 },
];

export const CASES: PCCase[] = [
  { id: "case-o11-evo", category: "case", brand: "Lian Li", name: "O11 Dynamic EVO", max_gpu_length_mm: 420, psu_form_factor: "ATX", supported_form_factors: ["ATX", "mATX", "ITX"], max_cooler_height_mm: 167, supported_radiator_sizes: [240, 280, 360], price_krw: 219000 },
  { id: "case-4000d", category: "case", brand: "Corsair", name: "4000D Airflow", max_gpu_length_mm: 360, psu_form_factor: "ATX", supported_form_factors: ["ATX", "mATX", "ITX"], max_cooler_height_mm: 170, supported_radiator_sizes: [240, 280, 360], price_krw: 129000 },
  { id: "case-h510", category: "case", brand: "NZXT", name: "H510", max_gpu_length_mm: 381, psu_form_factor: "ATX", supported_form_factors: ["ATX", "mATX", "ITX"], max_cooler_height_mm: 165, supported_radiator_sizes: [240, 280], price_krw: 109000 },
  { id: "case-q300l", category: "case", brand: "Cooler Master", name: "MasterBox Q300L", max_gpu_length_mm: 360, psu_form_factor: "ATX", supported_form_factors: ["mATX", "ITX"], max_cooler_height_mm: 159, supported_radiator_sizes: [240], price_krw: 59000 },
  { id: "case-terra-itx", category: "case", brand: "Fractal Design", name: "Terra (Mini-ITX)", max_gpu_length_mm: 268, psu_form_factor: "SFX", supported_form_factors: ["ITX"], max_cooler_height_mm: 60, supported_radiator_sizes: [240], price_krw: 259000 },
];

export const COOLERS: Cooler[] = [
  { id: "cooler-nhd15", category: "cooler", brand: "Noctua", name: "NH-D15 (공랭)", type: "air", supported_sockets: ["LGA1700", "AM5", "AM4"], max_tdp_w: 220, height_mm: 165, radiator_size_mm: null, price_krw: 159000 },
  { id: "cooler-ak620", category: "cooler", brand: "DeepCool", name: "AK620 (공랭)", type: "air", supported_sockets: ["LGA1700", "AM5", "AM4"], max_tdp_w: 260, height_mm: 160, radiator_size_mm: null, price_krw: 69000 },
  { id: "cooler-hyper212", category: "cooler", brand: "Cooler Master", name: "Hyper 212 (공랭)", type: "air", supported_sockets: ["LGA1700", "AM4"], max_tdp_w: 150, height_mm: 159, radiator_size_mm: null, price_krw: 39000 },
  { id: "cooler-se224xt", category: "cooler", brand: "ID-COOLING", name: "SE-224-XT (공랭, 보급형)", type: "air", supported_sockets: ["LGA1700", "AM4"], max_tdp_w: 180, height_mm: 154, radiator_size_mm: null, price_krw: 29000 },
  { id: "cooler-h150i", category: "cooler", brand: "Corsair", name: "iCUE H150i ELITE (수랭 360mm)", type: "aqua", supported_sockets: ["LGA1700", "AM5", "AM4"], max_tdp_w: null, height_mm: null, radiator_size_mm: 360, price_krw: 259000 },
  { id: "cooler-kraken-x63", category: "cooler", brand: "NZXT", name: "Kraken X63 (수랭 280mm)", type: "aqua", supported_sockets: ["LGA1700", "AM5", "AM4"], max_tdp_w: null, height_mm: null, radiator_size_mm: 280, price_krw: 219000 },
];

export const SEED = {
  cpu: CPUS,
  motherboard: MOTHERBOARDS,
  ram: RAMS,
  ssd: SSDS,
  gpu: GPUS,
  psu: PSUS,
  case: CASES,
  cooler: COOLERS,
} as const;
