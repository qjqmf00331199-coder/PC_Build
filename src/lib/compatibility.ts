import type { CompatIssue, CompatLevel, PartCategory, Selections } from "./types";
import { describeGpuPcieGap, describeSsdPcieGap, gpuPcieBottleneck, ssdPcieBottleneck } from "./pcie";
import { gpuPsuConnectorNeedsAdapter } from "./power-connector";

const LEVEL_RANK: Record<CompatLevel, number> = {
  idle: 0,
  success: 1,
  warning: 2,
  danger: 3,
};

function higher(a: CompatLevel, b: CompatLevel): CompatLevel {
  return LEVEL_RANK[a] >= LEVEL_RANK[b] ? a : b;
}

function splitTokens(value: string | null | undefined, delimiters: RegExp): string[] {
  if (!value) return [];
  return value
    .split(delimiters)
    .map((s) => s.replace(/\([^)]*\)/g, "").trim())
    .filter(Boolean);
}

const STANDARD_RADIATOR_SIZES_MM = [120, 140, 240, 280, 360, 420];

// a case spec field for one mounting position (top/front/side) is either:
//   - "불가" / null: no radiator fits there
//   - a single number ("420"): the verified max for that position — mounting
//     holes for smaller standard sizes share the same column, so anything
//     up to that max fits too
//   - a slash list ("280/360"): only those exact sizes were verified by the
//     manufacturer, so we don't assume smaller unlisted sizes also fit
function isRadiatorCompatible(caseSpec: string | number | null, radiatorSize: number): boolean {
  if (caseSpec === null) return false;
  const field = String(caseSpec).trim();
  if (!field || field.includes("불가")) return false;

  const listed = field
    .split("/")
    .map((token) => parseInt(token.replace(/\([^)]*\)/g, "").trim(), 10))
    .filter((n) => !Number.isNaN(n));
  if (listed.length === 0) return false;
  if (listed.includes(radiatorSize)) return true;
  if (listed.length === 1) {
    return STANDARD_RADIATOR_SIZES_MM.includes(radiatorSize) && radiatorSize <= listed[0];
  }
  return false;
}

function radiatorSupportLabel(pcCase: {
  radiator_top_mm: string | number | null;
  radiator_front_mm: string | number | null;
  radiator_side_mm: string | number | null;
}): string {
  return [pcCase.radiator_top_mm, pcCase.radiator_front_mm, pcCase.radiator_side_mm]
    .filter((v): v is string | number => v !== null && !String(v).includes("불가"))
    .map(String)
    .join(", ");
}

function psuFormFactorToken(value: string): "ATX" | "SFX" | null {
  if (value.includes("SFX")) return "SFX";
  if (value.includes("ATX")) return "ATX";
  return null;
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

  // Motherboard <-> RAM (규격만 체크: 데이터에 메인보드 최대속도/용량 필드 없음)
  if (motherboard && ram && ram.type !== motherboard.memory_type) {
    issues.push({
      id: "mobo-ram-type",
      level: "danger",
      categories: ["motherboard", "ram"],
      message: `RAM 규격 불일치: 메인보드는 ${motherboard.memory_type}, RAM은 ${ram.type}입니다.`,
    });
  }

  // GPU <-> Case
  if (gpu && pcCase && gpu.length_mm > pcCase.gpu_max_length_mm) {
    issues.push({
      id: "gpu-case-length",
      level: "danger",
      categories: ["gpu", "case"],
      message: `GPU 길이(${gpu.length_mm}mm)가 케이스 최대 허용 길이(${pcCase.gpu_max_length_mm}mm)를 초과합니다.`,
    });
  }

  // GPU <-> PSU
  if (gpu && psu && psu.watt < gpu.recommended_psu_w) {
    issues.push({
      id: "gpu-psu-wattage",
      level: "danger",
      categories: ["gpu", "psu"],
      message: `PSU 용량(${psu.watt}W)이 GPU 권장 파워(${gpu.recommended_psu_w}W)보다 부족합니다.`,
    });
  }

  // GPU <-> PSU (16핀 전원 커넥터 — 12VHPWR/12V-2x6은 규격 호환이라 세대 불일치는 문제 없음,
  // PSU에 네이티브 16핀 케이블 자체가 없을 때만 어댑터 필요)
  if (gpu && psu && gpuPsuConnectorNeedsAdapter(gpu, psu)) {
    issues.push({
      id: "gpu-psu-connector-adapter",
      level: "warning",
      categories: ["gpu", "psu"],
      message: `GPU는 16핀(12VHPWR/12V-2x6) 전원 커넥터가 필요하지만 PSU(${psu.atx_spec})는 8핀 PCIe 케이블만 제공합니다. GPU 동봉 8핀→16핀 어댑터로 연결은 가능합니다.`,
    });
  }

  // PSU <-> Case
  if (psu && pcCase) {
    const psuToken = psuFormFactorToken(psu.form_factor);
    if (psuToken && !pcCase.psu_support.includes(psuToken)) {
      issues.push({
        id: "psu-case-formfactor",
        level: "danger",
        categories: ["psu", "case"],
        message: `PSU 폼팩터(${psu.form_factor})가 케이스 지원 규격(${pcCase.psu_support})과 다릅니다.`,
      });
    }
  }

  // Cooler <-> CPU
  if (cooler && cpu) {
    const sockets = splitTokens(cooler.supported_sockets, /;/);
    if (!sockets.includes(cpu.socket)) {
      issues.push({
        id: "cooler-cpu-socket",
        level: "danger",
        categories: ["cooler", "cpu"],
        message: `쿨러가 CPU 소켓(${cpu.socket})을 지원하지 않습니다.`,
      });
    } else {
      const ratedTdp = cooler.extra?.tdp_rated_w;
      if (typeof ratedTdp === "number" && ratedTdp < cpu.tdp_w) {
        issues.push({
          id: "cooler-cpu-tdp",
          level: "warning",
          categories: ["cooler", "cpu"],
          message: `쿨러 정격 TDP(${ratedTdp}W)가 CPU TDP(${cpu.tdp_w}W)보다 낮아 발열에 취약할 수 있습니다.`,
        });
      }
    }
  }

  // Cooler(air) <-> Case
  if (cooler && pcCase && cooler.type === "air" && cooler.height_mm !== null) {
    if (cooler.height_mm > pcCase.cpu_cooler_max_height_mm) {
      issues.push({
        id: "cooler-case-height",
        level: "danger",
        categories: ["cooler", "case"],
        message: `공랭 쿨러 높이(${cooler.height_mm}mm)가 케이스 최대 허용 높이(${pcCase.cpu_cooler_max_height_mm}mm)를 초과합니다.`,
      });
    }
  }

  // Cooler(aqua) <-> Case
  if (cooler && pcCase && cooler.type === "aqua" && cooler.radiator_size_mm !== null) {
    const radiatorSize = cooler.radiator_size_mm;
    const supported = [pcCase.radiator_top_mm, pcCase.radiator_front_mm, pcCase.radiator_side_mm].some(
      (spec) => isRadiatorCompatible(spec, radiatorSize)
    );
    if (!supported) {
      const label = radiatorSupportLabel(pcCase);
      issues.push({
        id: "cooler-case-radiator",
        level: "danger",
        categories: ["cooler", "case"],
        message: `수랭 라디에이터(${radiatorSize}mm)를 케이스가 지원하지 않습니다${label ? ` (지원: ${label}mm)` : ""}.`,
      });
    }
  }

  // Motherboard <-> SSD (PCIe 세대 대역폭)
  if (motherboard && ssd) {
    const gap = ssdPcieBottleneck(motherboard, ssd);
    if (gap) {
      issues.push({
        id: "mobo-ssd-pcie-gen",
        level: "warning",
        categories: ["motherboard", "ssd"],
        message: describeSsdPcieGap(gap),
      });
    }
  }

  // Motherboard <-> GPU (PCIe 세대 차이)
  if (motherboard && gpu) {
    const gap = gpuPcieBottleneck(motherboard, gpu);
    if (gap) {
      issues.push({
        id: "mobo-gpu-pcie-gen",
        level: "warning",
        categories: ["motherboard", "gpu"],
        message: describeGpuPcieGap(gap),
      });
    }
  }

  // Motherboard <-> Case
  if (motherboard && pcCase) {
    const supportedFormFactors = splitTokens(pcCase.supported_mb, /[;,]/);
    if (!supportedFormFactors.includes(motherboard.form_factor)) {
      issues.push({
        id: "mobo-case-formfactor",
        level: "danger",
        categories: ["motherboard", "case"],
        message: `메인보드 폼팩터(${motherboard.form_factor})가 케이스 지원 규격(${pcCase.supported_mb})과 맞지 않습니다.`,
      });
    }
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

const BASELINE_DRAW_W = 75; // 메인보드 + RAM + 저장장치 + 팬 등 기저 소비전력

export function estimateTotalPowerW(sel: Selections): number {
  let total = BASELINE_DRAW_W;
  if (sel.cpu) total += sel.cpu.tdp_w;
  if (sel.gpu?.tdp_w) total += sel.gpu.tdp_w;
  return total;
}

export function computePsuMarginPct(sel: Selections): number | null {
  if (!sel.psu) return null;
  const total = estimateTotalPowerW(sel);
  return Math.round(((sel.psu.watt - total) / sel.psu.watt) * 1000) / 10;
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
