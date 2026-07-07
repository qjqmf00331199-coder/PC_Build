import type { GPU, Motherboard, SSD } from "./types";

/**
 * 메인보드 PCIe 레인 세대(世代) 병목 진단 — 순수 함수 모듈.
 *
 * 메인보드 데이터에 x16 슬롯/M.2 슬롯 세대가 구조화 필드로 없어서, 칩셋명 기준으로
 * "공식 스펙상 상한"을 추정한다. 보드사가 리타이머 비용 때문에 한 단계 낮춰 배선하는
 * 경우가 있어(B650이 대표적) 실제보다 낙관적으로 나올 수 있다 — extra.pcie_note에
 * 실측값이 있으면 그쪽을 우선한다.
 */

interface ChipsetPcieProfile {
  gpuSlotGen: number; // x16 슬롯(CPU 직결) 세대 상한
  primaryM2Gen: number; // 1번 M.2 슬롯(CPU 직결) 세대 상한
}

const CHIPSET_PCIE_PROFILE: Record<string, ChipsetPcieProfile> = {
  // AMD AM5 — X870E/X870/B650E는 AMD 스펙상 PCIe5.0 GPU/M.2 필수, B650은 미필수(대부분 Gen4 배선)
  X870E: { gpuSlotGen: 5, primaryM2Gen: 5 },
  X870: { gpuSlotGen: 5, primaryM2Gen: 5 },
  B650E: { gpuSlotGen: 5, primaryM2Gen: 5 },
  B650: { gpuSlotGen: 4, primaryM2Gen: 4 },
  // AMD AM4 — A520은 AMD 스펙상 PCIe4.0 미지원(Gen3 고정)
  B550: { gpuSlotGen: 4, primaryM2Gen: 4 },
  A520: { gpuSlotGen: 3, primaryM2Gen: 3 },
  // Intel LGA1700 — CPU는 Gen5 x16 + Gen4 M.2, 칩셋(Z790/B760/H610)은 세대 무관 Gen4
  Z790: { gpuSlotGen: 5, primaryM2Gen: 4 },
  B760: { gpuSlotGen: 5, primaryM2Gen: 4 },
  H610: { gpuSlotGen: 5, primaryM2Gen: 4 },
  // Intel LGA1851(애로우레이크) — CPU가 M.2도 Gen5 직결 지원
  Z890: { gpuSlotGen: 5, primaryM2Gen: 5 },
  B860: { gpuSlotGen: 5, primaryM2Gen: 5 },
};

function moboGpuSlotGen(mobo: Motherboard): number | null {
  return CHIPSET_PCIE_PROFILE[mobo.chipset]?.gpuSlotGen ?? null;
}

function moboM2Gen(mobo: Motherboard): number | null {
  const note = (mobo.extra as Record<string, unknown> | null)?.pcie_note;
  if (typeof note === "string") {
    const gens = [...note.matchAll(/PCIe\s*(\d)\.0/gi)].map((m) => Number(m[1]));
    if (gens.length > 0) return Math.max(...gens);
  }
  return CHIPSET_PCIE_PROFILE[mobo.chipset]?.primaryM2Gen ?? null;
}

function parseSsdGen(ssd: SSD): number | null {
  const m = /PCIe\s*(\d)\.0/i.exec(ssd.interface);
  return m ? Number(m[1]) : null; // SATA 등은 매치 안 되어 null → 체크 스킵
}

// 칩셋 스펙에 pcie 필드가 없는 GPU(대부분)는 세대(제품군) 기준으로 추정
const GPU_SERIES_NATIVE_GEN: Record<string, number> = {
  RTX50: 5,
  RX9000: 5,
  RTX40: 4,
  RX7000: 4,
};

function parseGpuGen(gpu: GPU): number | null {
  const extraPcie = (gpu.extra as Record<string, unknown> | null)?.pcie;
  if (typeof extraPcie === "string") {
    const m = /PCIe\s*(\d)\.0/i.exec(extraPcie);
    if (m) return Number(m[1]);
  }
  return GPU_SERIES_NATIVE_GEN[gpu.series] ?? null;
}

export interface SsdPcieGap {
  ssdGen: number;
  moboGen: number;
}

// 칩셋/보드 데이터가 없으면(미지원 칩셋) 단정할 근거가 없으므로 null(체크 스킵)
export function ssdPcieBottleneck(mobo: Motherboard, ssd: SSD): SsdPcieGap | null {
  const ssdGen = parseSsdGen(ssd);
  const moboGen = moboM2Gen(mobo);
  if (ssdGen === null || moboGen === null || ssdGen <= moboGen) return null;
  return { ssdGen, moboGen };
}

export interface GpuPcieGap {
  gpuGen: number;
  moboGen: number;
}

export function gpuPcieBottleneck(mobo: Motherboard, gpu: GPU): GpuPcieGap | null {
  const gpuGen = parseGpuGen(gpu);
  const moboGen = moboGpuSlotGen(mobo);
  if (gpuGen === null || moboGen === null || gpuGen <= moboGen) return null;
  return { gpuGen, moboGen };
}

export function describeSsdPcieGap(gap: SsdPcieGap): string {
  return `SSD는 PCIe ${gap.ssdGen}.0을 지원하지만 메인보드 M.2 슬롯은 PCIe ${gap.moboGen}.0까지만 지원해 대역폭이 제한됩니다 (실측 속도가 SSD 스펙보다 낮게 나올 수 있어요).`;
}

export function describeGpuPcieGap(gap: GpuPcieGap): string {
  return `GPU는 PCIe ${gap.gpuGen}.0 x16 대역폭까지 활용하도록 설계됐지만 메인보드는 PCIe ${gap.moboGen}.0까지만 지원합니다. x16 폭 자체는 유지되어 실사용 프레임 손해는 보통 수 % 이내로 작지만, 최상위 GPU일수록 약간 아쉬울 수 있어요.`;
}
