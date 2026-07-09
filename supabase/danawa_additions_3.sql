-- ==========================================================
-- danawa_additions_3.sql
-- 구세대(legacy) 하드웨어 8종 추가: LGA1200/AM4 구형 CPU 3, GTX16/RX500 GPU 3,
-- 이들과 짝지을 LGA1200/AM4 구형 메인보드 2
-- 전부 다나와에서 현재 정가 판매중(가격 조회됨)인 것만 골랐음
-- (라이젠5 2600/2600X, 라이젠5 3600, B460/B450 DS3H 등은 다나와 판매가가
--  없어서-사실상 단종/재고없음-제외함)
-- INSERT ... ON CONFLICT (id) DO UPDATE 방식 -- 이 파일만 실행하면 됨.
-- ==========================================================

-- ---------- cpu ----------

INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-43', 'Intel', 'i5', '10400F', '코멧레이크S', 'LGA1200', '6C/12T', 2.9, 4.3, '12MB', 65, 'DDR4-2666', '{"has_igpu": false}')
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand, tier = EXCLUDED.tier, model = EXCLUDED.model, codename = EXCLUDED.codename,
  socket = EXCLUDED.socket, cores_threads = EXCLUDED.cores_threads, base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz, cache = EXCLUDED.cache, tdp_w = EXCLUDED.tdp_w, memory = EXCLUDED.memory, extra = EXCLUDED.extra;

INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-44', 'Intel', 'i3', '10100F', '코멧레이크S', 'LGA1200', '4C/8T', 3.6, 4.3, '6MB', 65, 'DDR4-2666', '{"has_igpu": false}')
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand, tier = EXCLUDED.tier, model = EXCLUDED.model, codename = EXCLUDED.codename,
  socket = EXCLUDED.socket, cores_threads = EXCLUDED.cores_threads, base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz, cache = EXCLUDED.cache, tdp_w = EXCLUDED.tdp_w, memory = EXCLUDED.memory, extra = EXCLUDED.extra;

INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-45', 'AMD', '라이젠7', '3700X', '마티스', 'AM4', '8C/16T', 3.6, 4.4, '4MB/32MB', 65, 'DDR4-3200', '{"has_igpu": false}')
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand, tier = EXCLUDED.tier, model = EXCLUDED.model, codename = EXCLUDED.codename,
  socket = EXCLUDED.socket, cores_threads = EXCLUDED.cores_threads, base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz, cache = EXCLUDED.cache, tdp_w = EXCLUDED.tdp_w, memory = EXCLUDED.memory, extra = EXCLUDED.extra;

-- ---------- gpu ----------

INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra, power_connector_pins, power_connector_count)
VALUES ('gpu-48', 'GTX16', '이엠텍 지포스 GTX 1660 SUPER MIRACLE II D6 6GB', 6, 125, '8핀', 450, 220, '2슬롯(45mm)', 2, true,
  '{"base_mhz": 1530, "boost_mhz": 1785, "pcie": "PCIe3.0x16", "stream_processors": 1408, "memory_type": "GDDR6", "source": "danawa"}', 8, 1)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series, model = EXCLUDED.model, vram_gb = EXCLUDED.vram_gb, tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector, recommended_psu_w = EXCLUDED.recommended_psu_w, length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness, fans = EXCLUDED.fans, verified = EXCLUDED.verified, extra = EXCLUDED.extra,
  power_connector_pins = EXCLUDED.power_connector_pins, power_connector_count = EXCLUDED.power_connector_count;

INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra, power_connector_pins, power_connector_count)
VALUES ('gpu-49', 'RX500', '액슬 라데온 RX 580 2048SP D5 8GB R2 에즈윈', 8, null, '8핀', 500, 213, '2슬롯(49mm)', 2, true,
  '{"boost_mhz": 1244, "pcie": "PCIe3.0x16", "stream_processors": 2048, "memory_type": "GDDR5", "source": "danawa"}', 8, 1)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series, model = EXCLUDED.model, vram_gb = EXCLUDED.vram_gb, tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector, recommended_psu_w = EXCLUDED.recommended_psu_w, length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness, fans = EXCLUDED.fans, verified = EXCLUDED.verified, extra = EXCLUDED.extra,
  power_connector_pins = EXCLUDED.power_connector_pins, power_connector_count = EXCLUDED.power_connector_count;

INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra, power_connector_pins, power_connector_count)
VALUES ('gpu-50', 'GTX16', '액슬 지포스 GTX 1650 D6 4GB R3 에즈윈', 4, null, '6핀', 300, 173, '2슬롯(40mm)', 2, true,
  '{"base_mhz": 1410, "boost_mhz": 1590, "pcie": "PCIe3.0x16", "stream_processors": 896, "memory_type": "GDDR6", "source": "danawa"}', 6, 1)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series, model = EXCLUDED.model, vram_gb = EXCLUDED.vram_gb, tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector, recommended_psu_w = EXCLUDED.recommended_psu_w, length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness, fans = EXCLUDED.fans, verified = EXCLUDED.verified, extra = EXCLUDED.extra,
  power_connector_pins = EXCLUDED.power_connector_pins, power_connector_count = EXCLUDED.power_connector_count;

-- ---------- motherboard ----------

INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, m2_pcie_top, m2_pcie_verified, extra)
VALUES ('mb-50', 'ASRock B560M-HDV 디앤디컴', 'LGA1200', 'B560', 'M-ATX', 244, 198, 1, 1, 'DDR4', 'PCIe3.0x4', false,
  '{"pcie_x1_slots": 2, "m2_slots": 2, "sata_ports": 4, "note": "M.2 상단슬롯 세대 danawa 스펙에 명기 안 됨, B560 통상값(PCIe3.0x4)으로 추정", "source": "danawa"}')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model, socket = EXCLUDED.socket, chipset = EXCLUDED.chipset, form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm, depth_mm = EXCLUDED.depth_mm, pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots, memory_type = EXCLUDED.memory_type,
  m2_pcie_top = EXCLUDED.m2_pcie_top, m2_pcie_verified = EXCLUDED.m2_pcie_verified, extra = EXCLUDED.extra;

INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, m2_pcie_top, m2_pcie_verified, extra)
VALUES ('mb-51', 'ASRock B450 스틸레전드 디앤디컴', 'AM4', 'B450', 'ATX', 305, 244, 2, 2, 'DDR4', 'PCIe3.0x4', false,
  '{"pcie_x1_slots": 4, "m2_slots": 2, "sata_ports": 6, "note": "M.2 상단슬롯 세대 danawa 스펙에 명기 안 됨, B450 통상값(PCIe3.0x4)으로 추정", "source": "danawa"}')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model, socket = EXCLUDED.socket, chipset = EXCLUDED.chipset, form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm, depth_mm = EXCLUDED.depth_mm, pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots, memory_type = EXCLUDED.memory_type,
  m2_pcie_top = EXCLUDED.m2_pcie_top, m2_pcie_verified = EXCLUDED.m2_pcie_verified, extra = EXCLUDED.extra;
