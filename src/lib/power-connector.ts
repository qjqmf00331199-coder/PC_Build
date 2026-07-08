import type { GPU, PSU } from "./types";

/**
 * GPU 12핀(16핀) 전원 커넥터 세대 호환성 — 순수 함수 모듈.
 *
 * 12VHPWR(ATX3.0)과 12V-2x6(ATX3.1)은 핀 배열·전력 스펙이 동일하고 커넥터 쉘도
 * 호환되는 리비전 관계라 케이블/카드 조합에 실질적 제약이 없다(12V-2x6은 감지 핀
 * 길이만 조정한 개정판). 그래서 "다른 세대끼리 안 맞는다"는 문제는 없고, 실제 체크
 * 포인트는 PSU가 애초에 12핀 네이티브 케이블을 제공하는지(ATX3.0/3.1) 뿐이다 —
 * 구형 ATX12V PSU는 8핀 PCIe 케이블만 있어 GPU 동봉 8핀→16핀 어댑터가 필요하다.
 */

export function gpuNeedsHighPowerConnector(gpu: GPU): boolean {
  return gpu.power_connector_pins === 12;
}

export function describeGpuConnector(gpu: GPU): string {
  return gpu.power_connector_pins === 12
    ? `16핀(12VHPWR/12V-2x6 겸용) x${gpu.power_connector_count}`
    : `8핀 x${gpu.power_connector_count}`;
}

export function describePsuNativeConnector(psu: PSU): string {
  if (psu.native_gpu_connector === "12V-2x6") return "12V-2x6 네이티브 케이블 (ATX3.1)";
  if (psu.native_gpu_connector === "12VHPWR") return "12VHPWR 네이티브 케이블 (ATX3.0)";
  return "12핀 네이티브 케이블 없음 (ATX12V, 8핀 PCIe만 제공)";
}

export function gpuPsuConnectorNeedsAdapter(gpu: GPU, psu: PSU): boolean {
  return gpuNeedsHighPowerConnector(gpu) && psu.native_gpu_connector === null;
}

export function describeGpuPsuConnectorFit(gpu: GPU, psu: PSU): string {
  if (!gpuNeedsHighPowerConnector(gpu)) {
    return "GPU가 8핀 PCIe 커넥터만 사용해 PSU의 ATX 버전과 무관하게 연결 가능합니다.";
  }
  if (psu.native_gpu_connector) {
    return `GPU가 요구하는 16핀 커넥터를 PSU가 ${psu.native_gpu_connector} 네이티브 케이블로 지원합니다. 12VHPWR ↔ 12V-2x6은 핀 배열과 커넥터 규격이 동일해 세대가 달라도 케이블을 그대로 꽂아 쓸 수 있습니다.`;
  }
  return `PSU(${psu.atx_spec})에 16핀 네이티브 케이블이 없어 GPU 동봉 8핀→16핀 어댑터가 필요합니다. 어댑터로 전원 공급 자체는 가능하지만 커넥터가 완전히 삽입됐는지 더 신경 써서 확인하세요.`;
}
