import type { CompatIssue, CompatLevel, PartCategory, Selections } from "./types";

const LEVEL_RANK: Record<CompatLevel, number> = {
  idle: 0,
  success: 1,
  warning: 2,
  danger: 3,
};

function higher(a: CompatLevel, b: CompatLevel): CompatLevel {
  return LEVEL_RANK[a] >= LEVEL_RANK[b] ? a : b;
}

export function evaluateIssues(sel: Selections): CompatIssue[] {
  const issues: CompatIssue[] = [];
  const { cpu, motherboard, ram, ssd, gpu, psu, case: pcCase, cooler } = sel;

  // CPU <-> Motherboard
  if (cpu && motherboard && cpu.socket !== motherboard.socket) {
    issues.push({
      id: "cpu-mobo-socket",
      level: "danger",
      categories: ["cpu", "motherboard"],
      message: `소켓 불일치: CPU(${cpu.socket})와 메인보드(${motherboard.socket})가 맞지 않습니다.`,
    });
  }

  // Motherboard <-> RAM
  if (motherboard && ram) {
    if (ram.type !== motherboard.ram_type) {
      issues.push({
        id: "mobo-ram-type",
        level: "danger",
        categories: ["motherboard", "ram"],
        message: `RAM 규격 불일치: 메인보드는 ${motherboard.ram_type}, RAM은 ${ram.type}입니다.`,
      });
    } else {
      if (ram.speed_mhz > motherboard.max_ram_speed_mhz) {
        issues.push({
          id: "mobo-ram-speed",
          level: "warning",
          categories: ["motherboard", "ram"],
          message: `RAM 속도(${ram.speed_mhz}MHz)가 메인보드 최대 지원 속도(${motherboard.max_ram_speed_mhz}MHz)를 초과해 다운클럭됩니다.`,
        });
      }
      if (ram.capacity_gb > motherboard.max_ram_capacity_gb) {
        issues.push({
          id: "mobo-ram-capacity",
          level: "danger",
          categories: ["motherboard", "ram"],
          message: `RAM 용량(${ram.capacity_gb}GB)이 메인보드 최대 지원 용량(${motherboard.max_ram_capacity_gb}GB)을 초과합니다.`,
        });
      }
    }
  }

  // GPU <-> Case
  if (gpu && pcCase && gpu.length_mm > pcCase.max_gpu_length_mm) {
    issues.push({
      id: "gpu-case-length",
      level: "danger",
      categories: ["gpu", "case"],
      message: `GPU 길이(${gpu.length_mm}mm)가 케이스 최대 허용 길이(${pcCase.max_gpu_length_mm}mm)를 초과합니다.`,
    });
  }

  // GPU <-> PSU
  if (gpu && psu && psu.wattage_w < gpu.recommended_psu_w) {
    issues.push({
      id: "gpu-psu-wattage",
      level: "danger",
      categories: ["gpu", "psu"],
      message: `PSU 용량(${psu.wattage_w}W)이 GPU 권장 파워(${gpu.recommended_psu_w}W)보다 부족합니다.`,
    });
  }

  // PSU <-> Case
  if (psu && pcCase && psu.form_factor !== pcCase.psu_form_factor) {
    issues.push({
      id: "psu-case-formfactor",
      level: "danger",
      categories: ["psu", "case"],
      message: `PSU 폼팩터(${psu.form_factor})가 케이스 지원 규격(${pcCase.psu_form_factor})과 다릅니다.`,
    });
  }

  // Cooler <-> CPU
  if (cooler && cpu) {
    if (!cooler.supported_sockets.includes(cpu.socket)) {
      issues.push({
        id: "cooler-cpu-socket",
        level: "danger",
        categories: ["cooler", "cpu"],
        message: `쿨러가 CPU 소켓(${cpu.socket})을 지원하지 않습니다.`,
      });
    } else if (cooler.max_tdp_w !== null && cooler.max_tdp_w < cpu.tdp_w) {
      issues.push({
        id: "cooler-cpu-tdp",
        level: "warning",
        categories: ["cooler", "cpu"],
        message: `쿨러 최대 지원 TDP(${cooler.max_tdp_w}W)가 CPU TDP(${cpu.tdp_w}W)보다 낮아 발열에 취약할 수 있습니다.`,
      });
    }
  }

  // Cooler(air) <-> Case
  if (cooler && pcCase && cooler.type === "air" && cooler.height_mm !== null) {
    if (cooler.height_mm > pcCase.max_cooler_height_mm) {
      issues.push({
        id: "cooler-case-height",
        level: "danger",
        categories: ["cooler", "case"],
        message: `공랭 쿨러 높이(${cooler.height_mm}mm)가 케이스 최대 허용 높이(${pcCase.max_cooler_height_mm}mm)를 초과합니다.`,
      });
    }
  }

  // Cooler(aqua) <-> Case
  if (cooler && pcCase && cooler.type === "aqua" && cooler.radiator_size_mm !== null) {
    if (!pcCase.supported_radiator_sizes.includes(cooler.radiator_size_mm)) {
      issues.push({
        id: "cooler-case-radiator",
        level: "danger",
        categories: ["cooler", "case"],
        message: `수랭 라디에이터(${cooler.radiator_size_mm}mm)를 케이스가 지원하지 않습니다.`,
      });
    }
  }

  // SSD <-> Motherboard
  if (ssd && motherboard && ssd.interface === "NVMe") {
    if (motherboard.m2_slots <= 0) {
      issues.push({
        id: "ssd-mobo-slot",
        level: "danger",
        categories: ["ssd", "motherboard"],
        message: `메인보드에 M.2 슬롯이 없어 NVMe SSD를 장착할 수 없습니다.`,
      });
    } else if (ssd.pcie_version !== null && ssd.pcie_version > motherboard.m2_interface) {
      issues.push({
        id: "ssd-mobo-pcie",
        level: "warning",
        categories: ["ssd", "motherboard"],
        message: `SSD(PCIe ${ssd.pcie_version}.0)가 메인보드 M.2 슬롯(PCIe ${motherboard.m2_interface}.0) 하위 호환으로 동작해 최대 속도가 제한됩니다.`,
      });
    }
  }

  // Motherboard <-> Case
  if (motherboard && pcCase && !pcCase.supported_form_factors.includes(motherboard.form_factor)) {
    issues.push({
      id: "mobo-case-formfactor",
      level: "danger",
      categories: ["motherboard", "case"],
      message: `메인보드 폼팩터(${motherboard.form_factor})가 케이스 지원 규격과 맞지 않습니다.`,
    });
  }

  return issues;
}

export function computeCategoryStatus(
  sel: Selections,
  issues: CompatIssue[]
): Record<PartCategory, CompatLevel> {
  const status: Record<PartCategory, CompatLevel> = {
    cpu: sel.cpu ? "success" : "idle",
    motherboard: sel.motherboard ? "success" : "idle",
    ram: sel.ram ? "success" : "idle",
    ssd: sel.ssd ? "success" : "idle",
    gpu: sel.gpu ? "success" : "idle",
    psu: sel.psu ? "success" : "idle",
    case: sel.case ? "success" : "idle",
    cooler: sel.cooler ? "success" : "idle",
  };

  for (const issue of issues) {
    for (const cat of issue.categories) {
      status[cat] = higher(status[cat], issue.level);
    }
  }

  return status;
}

const GPU_DRAW_RATIO = 0.68; // recommended_psu_w already includes headroom over real draw
const BASELINE_DRAW_W = 75; // motherboard + RAM + storage + fans baseline

export function estimateTotalPowerW(sel: Selections): number {
  let total = BASELINE_DRAW_W;
  if (sel.cpu) total += sel.cpu.tdp_w;
  if (sel.gpu) total += Math.round(sel.gpu.recommended_psu_w * GPU_DRAW_RATIO);
  return total;
}

export function computePsuMarginPct(sel: Selections): number | null {
  if (!sel.psu) return null;
  const total = estimateTotalPowerW(sel);
  return Math.round(((sel.psu.wattage_w - total) / sel.psu.wattage_w) * 1000) / 10;
}

export const CATEGORY_ORDER: PartCategory[] = [
  "cpu",
  "motherboard",
  "ram",
  "ssd",
  "gpu",
  "psu",
  "case",
  "cooler",
];

export const CATEGORY_LABEL: Record<PartCategory, string> = {
  cpu: "CPU",
  motherboard: "메인보드",
  ram: "RAM",
  ssd: "SSD",
  gpu: "그래픽카드",
  psu: "파워서플라이",
  case: "케이스",
  cooler: "쿨러",
};
