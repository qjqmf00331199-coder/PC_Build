# [기획 명세서] PC 부품 호환성 체커

## 1. 프로젝트 개요

- **프로젝트명**: PC 부품 호환성 체커 (PC Build Compatibility Checker)
- **배경**: 커스텀 PC 조립 시 소켓/전원/사이즈 안 맞아 반품·재구매 발생. 초보자는 스펙표만 봐선 호환 여부 판단 어려움.
- **목표**: CPU/메인보드/RAM/SSD/GPU/PSU/케이스/쿨러 선택 시 실시간 호환성 체크. 초기 범위는 **선택+체크 기능만** (빌드 저장/공유는 차기 버전).

---

## 2. 핵심 기능 요구사항 (v1 범위)

- **부품 선택 UI**: 카테고리별(CPU→메인보드→RAM→SSD→GPU→PSU→케이스→쿨러) 드롭다운/카드 선택.
- **실시간 호환성 체크**: 부품 선택할 때마다 아래 규칙 검증, 위반 시 경고 표시.
- **결과 요약 패널**: 선택한 전체 조합 한눈에 보기 + 총 소비전력 합산 + PSU 여유율(%) 표시.
- **v1 제외 범위**: 빌드 저장, 로그인, 공유 링크, 가격 비교 — 전부 차기 버전.

---

## 3. 호환성 검증 규칙

| 항목 | 규칙 |
|---|---|
| CPU ↔ 메인보드 | `cpu.socket === motherboard.socket` |
| 메인보드 ↔ RAM | `ram.type === motherboard.ram_type`, `ram.speed_mhz <= motherboard.max_ram_speed_mhz`, `ram.capacity_gb <= motherboard.max_ram_capacity_gb` |
| GPU ↔ 케이스 | `gpu.length_mm <= pc_case.max_gpu_length_mm` |
| GPU ↔ PSU | `psu.wattage_w >= gpu.recommended_psu_w` |
| PSU ↔ 케이스 | `psu.form_factor === pc_case.psu_form_factor` |
| 쿨러 ↔ CPU | `cpu.socket ∈ cooler.supported_sockets`, `cooler.max_tdp_w >= cpu.tdp_w` (max_tdp_w NULL이면 체크 스킵) |
| 쿨러(공랭) ↔ 케이스 | `cooler.height_mm <= pc_case.max_cooler_height_mm` (type='air'일 때만) |
| 쿨러(수랭) ↔ 케이스 | `cooler.radiator_size_mm ∈ pc_case.supported_radiator_sizes` (type='aqua'일 때만) |
| SSD ↔ 메인보드 | `ssd.interface==='NVMe'` → `motherboard.m2_slots > 0` 및 `ssd.pcie_version <= motherboard.m2_interface` |
| 메인보드 ↔ 케이스 | `motherboard.form_factor ∈ pc_case.supported_form_factors` |

- **경고 등급 3단계 확정**: 초록(호환) / 노랑(주의 — 작동은 하나 성능 제한, 예: PCIe 하위호환) / 빨강(불가 — 소켓 불일치 등). 빨강이어도 선택 차단 안 함, 경고만 표시.

---

## 4. 데이터 입력 방식 (v1)

- 관리자(본인)가 Supabase Table Editor에서 **직접 수동 입력**.
- 초기 데이터량: 부품 카테고리당 5~10개 내외 (테스트용 소량).
- 입력 편의를 위해 시드 데이터 SQL 스크립트 별도 작성 예정.

---

## 5. UI 플로우 (Apple 구매 화면 스타일 확정)

왼쪽 sticky 패널에 PC 케이스 단면 일러스트, 오른쪽에 카테고리별 카드 순차 배치. 부품 선택 시 좌측 일러스트의 해당 부품 도형이 즉시 색 전환 애니메이션으로 반응.

**동작 확정 사항**:
- 트리거 시점: **즉시** (부품 옵션 클릭하는 순간 검증 및 색상 반영, 전체 완료 대기 안 함)
- 호환 불가 처리: **경고만 표시, 선택 차단하지 않음** (빨강 색상 + 하단 상태 텍스트로 안내, 유저가 그대로 진행 가능)

## 6. 화면 구성 (확정)

- **좌측(sticky)**: PC 케이스 내부 단면 일러스트 SVG — 메인보드/CPU+쿨러/RAM/GPU/SSD/PSU/케이스 각 부품 개별 도형, 상태별(호환/주의/불가) 색상 반응 + 하단 상태 텍스트 1줄 + 범례
- **우측**: 카테고리 카드 세로 스크롤 목록(진행 표시 N/8 포함)
- 모바일: 좌측 일러스트 축소해 상단 고정 바로 전환, 우측 카드만 스크롤
