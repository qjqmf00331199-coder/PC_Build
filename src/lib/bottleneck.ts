import type { CPU, GPU, CompatLevel, Selections } from "./types";
import { describeGpuPcieGap, describeSsdPcieGap, gpuPcieBottleneck, ssdPcieBottleneck } from "./pcie";

/**
 * CPU-GPU 성능 병목 진단 — 순수 함수 모듈.
 *
 * 벤치마크 점수가 DB/타입에 없어서 코어수·클럭·아키텍처 세대·GPU 칩셋 등급으로
 * 근사한 추정 점수다. 실제 벤치마크 데이터(PassMark, TechPowerUp 상대성능표 등)를
 * 구하면 scoreCpu/GPU_CHIP_SCORES만 교체하면 되도록 계산과 UI를 분리해뒀다.
 */

export type PerformanceTier = "S" | "A" | "B" | "C" | "D";
export type BottleneckLevel = Exclude<CompatLevel, "idle">;
// 진단 대상 부품이 한쪽만 선택된 상태 — 아직 비교할 상대가 없어서 결과는 없지만,
// 어떤 부품을 더 고르면 진단이 가능한지 미리 알려주기 위한 레벨.
export type EntryLevel = BottleneckLevel | "pending";
export type BottleneckDirection = "cpu" | "gpu" | "balanced";

export interface BottleneckResult {
  cpuScore: number;
  gpuScore: number;
  cpuTier: PerformanceTier;
  gpuTier: PerformanceTier;
  gapPercent: number;
  direction: BottleneckDirection;
  level: BottleneckLevel;
  message: string;
}

// 아키텍처(codename) 기준 IPC 가중치. 추정치 — 세대 간 상대적인 게이밍 IPC 격차를 근사.
const IPC_COEFF: Record<string, number> = {
  "마티스": 0.9,
  "르누아르-X": 0.9,
  "버미어": 1.0,
  "세잔": 0.95,
  "피닉스": 0.95,
  "라파엘": 1.15,
  "그래니트 릿지": 1.3,
  "엘더레이크": 1.05,
  "랩터레이크": 1.15,
  "랩터레이크-R": 1.15,
  "애로우레이크": 1.25,
};

// 8코어까지는 게임 프레임에 그대로 기여하지만, 그 이상은 대부분 게임 엔진이
// 잘 못 써먹는다고 보고 15%만 반영한다 (고코어 워크스테이션 CPU 과대평가 방지).
function gamingCoreWeight(effectiveCores: number): number {
  if (effectiveCores <= 8) return effectiveCores;
  return 8 + (effectiveCores - 8) * 0.15;
}

// codename이 없는 항목(현재 시드 데이터의 i3 13100/13100F/14100)은 모델명 앞자리로
// 세대를 추정한다. Intel 모델 넘버링 규칙(14xxx/13xxx/12xxx = 세대)에 의존.
function ipcCoeff(cpu: CPU): number {
  if (cpu.codename && cpu.codename in IPC_COEFF) return IPC_COEFF[cpu.codename];
  if (cpu.model.startsWith("14")) return IPC_COEFF["랩터레이크-R"];
  if (cpu.model.startsWith("13")) return IPC_COEFF["랩터레이크"];
  if (cpu.model.startsWith("12")) return IPC_COEFF["엘더레이크"];
  return 1.0;
}

// "6C/12T" -> 6. 스레드 수 절반이 P코어+E코어×0.5와 수학적으로 같아서
// (하이퍼스레딩은 P코어에만 붙는다는 전제 하에) 굳이 P/E를 나누지 않고 threads/2로 계산한다.
function effectiveCores(cpu: CPU): number {
  const threads = Number(cpu.cores_threads.split("/")[1]?.replace(/[^\d]/g, ""));
  return threads / 2;
}

// 시드 데이터에 v_cache 플래그가 빠진 X3D 모델(9950X3D, 9900X3D)이 있어서
// extra.v_cache 뿐 아니라 모델명에 "X3D"가 들어있는지도 함께 본다.
function isX3D(cpu: CPU): boolean {
  const flagged = Boolean((cpu.extra as Record<string, unknown> | null)?.v_cache);
  return flagged || cpu.model.includes("X3D");
}

// 9950X3D(16C/32T, 그래니트 릿지, 5.7GHz, X3D) 기준으로 100점이 나오도록 잡은 정규화 상수.
const CPU_SCORE_NORMALIZER = 76.35;

export function scoreCpu(cpu: CPU): number {
  const raw = gamingCoreWeight(effectiveCores(cpu)) * ipcCoeff(cpu) * cpu.boost_ghz * (isX3D(cpu) ? 1.12 : 1);
  return Math.max(0, Math.min(100, Math.round((raw / CPU_SCORE_NORMALIZER) * 100)));
}

// GPU는 벤치마크 데이터 대신 칩셋(모델명에서 추출) 등급표로 직접 매핑한다.
// AIB 브랜드(ASUS/MSI/갤럭시 등)는 성능에 영향 없으니 무시하고 칩 코드명만 본다.
// 순서 중요: 같은 숫자의 상위 변종(Ti/SUPER 등)을 먼저 검사해야 오매칭 안 난다.
const GPU_CHIP_SCORES: [pattern: RegExp, score: number][] = [
  [/4070\s*Ti\s*SUPER/i, 64],
  [/4080\s*SUPER/i, 74],
  [/4070\s*SUPER/i, 53],
  [/7900\s*XTX/i, 75],
  [/7800\s*XT/i, 50],
  [/7600\s*XT/i, 33],
  [/9070\s*XT/i, 62],
  [/9060\s*XT/i, 38],
  [/5070\s*Ti/i, 68],
  [/5060\s*Ti/i, 40],
  [/4060\s*Ti/i, 34],
  [/5090/i, 100],
  [/5080/i, 82],
  [/5070/i, 54],
  [/5060/i, 28],
  [/4090/i, 88],
  [/4060/i, 26],
  [/7600/i, 25],
];

export function scoreGpu(gpu: GPU): number {
  for (const [pattern, score] of GPU_CHIP_SCORES) {
    if (pattern.test(gpu.model)) return score;
  }
  return 50; // 등급표에 없는 미확인 칩 — 중간값으로 폴백
}

export function tierOf(score: number): PerformanceTier {
  if (score >= 90) return "S";
  if (score >= 75) return "A";
  if (score >= 60) return "B";
  if (score >= 45) return "C";
  return "D";
}

// 임계값을 러프하게 잡는다: 약간의 성능 차이는 실사용에 체감 안 되는 수준이라
// 문제없음으로 본다. 중간 정도부터 "생길 수 있음" 정도로만 경고하고,
// 격차가 아주 커야만 비추천으로 올린다.
function buildMessage(direction: BottleneckDirection, level: BottleneckLevel, gapPercent: number): string {
  if (direction === "balanced" || level === "success") {
    return "CPU와 GPU 밸런스에 이상 없어요. 약간의 성능 차이는 있어도 병목 걱정 없이 쓸 수 있어요.";
  }
  const weaker = direction === "cpu" ? "CPU" : "GPU";
  if (level === "warning") {
    return `${weaker}가 상대적으로 약해서 병목이 생길 수 있어요 (격차 약 ${gapPercent}%). 아주 심하진 않지만 ${weaker === "CPU" ? "GPU 성능을 100% 다 못 끌어낼 수 있어요." : "CPU 성능을 GPU가 못 따라갈 수 있어요."}`;
  }
  return `${weaker}가 많이 약해서 병목 현상이 심해요 (격차 약 ${gapPercent}%). 이 조합은 추천하지 않아요 — ${weaker}를 한 단계 올리는 걸 고려해보세요.`;
}

// 병목 진단 박스에 뜨는 항목 하나. CPU-GPU 성능 밸런스뿐 아니라 메인보드-GPU/SSD
// PCIe 세대 대역폭 체크도 같은 박스에 모아서 보여주기 위한 공통 포맷.
export interface BottleneckEntry {
  id: "cpu-gpu" | "mobo-gpu-pcie" | "mobo-ssd-pcie";
  label: string;
  level: EntryLevel;
  message: string;
  scores?: {
    cpuScore: number;
    gpuScore: number;
    cpuTier: PerformanceTier;
    gpuTier: PerformanceTier;
    direction: BottleneckDirection;
  };
}

const LEVEL_RANK: Record<EntryLevel, number> = { pending: -1, success: 0, warning: 1, danger: 2 };

// 선택된 부품 조합에서 진단 가능한 병목 항목들을 전부 모은다. 짝이 되는 부품이 둘 다
// 있으면 실제 진단 결과를, 한쪽만 있으면 "이 부품을 더 고르면 확인 가능"이라는 pending
// 항목을 넣는다 — 그래서 관련 부품이 하나라도 선택되면 진단 패널이 뜬다.
export function evaluateAllBottlenecks(sel: Selections): BottleneckEntry[] {
  const { cpu, gpu, motherboard, ssd } = sel;
  const entries: BottleneckEntry[] = [];

  if (cpu && gpu) {
    const r = evaluateBottleneck(cpu, gpu);
    entries.push({
      id: "cpu-gpu",
      label: "CPU-GPU 성능 밸런스",
      level: r.level,
      message: r.message,
      scores: { cpuScore: r.cpuScore, gpuScore: r.gpuScore, cpuTier: r.cpuTier, gpuTier: r.gpuTier, direction: r.direction },
    });
  } else if (cpu || gpu) {
    entries.push({
      id: "cpu-gpu",
      label: "CPU-GPU 성능 밸런스",
      level: "pending",
      message: cpu ? "그래픽카드를 고르면 CPU와 성능 밸런스를 확인할 수 있어요." : "CPU를 고르면 GPU와 성능 밸런스를 확인할 수 있어요.",
    });
  }

  if (motherboard && gpu) {
    const gap = gpuPcieBottleneck(motherboard, gpu);
    entries.push({
      id: "mobo-gpu-pcie",
      label: "메인보드-GPU PCIe 대역폭",
      level: gap ? "warning" : "success",
      message: gap ? describeGpuPcieGap(gap) : "메인보드와 GPU의 PCIe 세대가 맞아 대역폭 손실 없이 쓸 수 있어요.",
    });
  } else if (motherboard || gpu) {
    entries.push({
      id: "mobo-gpu-pcie",
      label: "메인보드-GPU PCIe 대역폭",
      level: "pending",
      message: motherboard ? "그래픽카드를 고르면 PCIe 대역폭을 확인할 수 있어요." : "메인보드를 고르면 PCIe 대역폭을 확인할 수 있어요.",
    });
  }

  if (motherboard && ssd) {
    const gap = ssdPcieBottleneck(motherboard, ssd);
    entries.push({
      id: "mobo-ssd-pcie",
      label: "메인보드-SSD PCIe 대역폭",
      level: gap ? "warning" : "success",
      message: gap ? describeSsdPcieGap(gap) : "메인보드와 SSD의 PCIe 세대가 맞아 대역폭 손실 없이 쓸 수 있어요.",
    });
  } else if (motherboard || ssd) {
    entries.push({
      id: "mobo-ssd-pcie",
      label: "메인보드-SSD PCIe 대역폭",
      level: "pending",
      message: motherboard ? "SSD를 고르면 PCIe 대역폭을 확인할 수 있어요." : "메인보드를 고르면 PCIe 대역폭을 확인할 수 있어요.",
    });
  }

  return entries;
}

export function worstLevel(entries: BottleneckEntry[]): EntryLevel | null {
  if (entries.length === 0) return null;
  return entries.reduce<EntryLevel>((worst, e) => (LEVEL_RANK[e.level] > LEVEL_RANK[worst] ? e.level : worst), entries[0].level);
}

export function evaluateBottleneck(cpu: CPU, gpu: GPU): BottleneckResult {
  const cpuScore = scoreCpu(cpu);
  const gpuScore = scoreGpu(gpu);
  const gapPercent = Math.round((Math.abs(gpuScore - cpuScore) / Math.max(cpuScore, gpuScore, 1)) * 100);

  const direction: BottleneckDirection = gpuScore > cpuScore ? "cpu" : cpuScore > gpuScore ? "gpu" : "balanced";
  const level: BottleneckLevel = gapPercent < 15 ? "success" : gapPercent < 35 ? "warning" : "danger";

  return {
    cpuScore,
    gpuScore,
    cpuTier: tierOf(cpuScore),
    gpuTier: tierOf(gpuScore),
    gapPercent,
    direction,
    level,
    message: buildMessage(direction, level, gapPercent),
  };
}
