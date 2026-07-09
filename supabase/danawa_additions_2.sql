-- ==========================================================
-- danawa_additions_2.sql
-- parts_db_rebuild.xlsx에 다나와 크롤링으로 추가한 27개 신규 부품
-- (cpu 5 / gpu 3 / motherboard 3 / ram 3 / psu 3 / pc_case 4 / ssd 3 / cooler 3)
-- 전부 INSERT ... ON CONFLICT (id) DO UPDATE 방식 -- 이 파일만 실행하면 됨.
-- rebuild_full.sql을 재실행할 필요 없음.
-- ==========================================================

-- ---------- cpu ----------

INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-38', 'AMD', '라이젠5', '9600', '그래니트 릿지', 'AM5', '6C/12T', 3.8, 5.2, '6MB/32MB', 65, 'DDR5-5600', '{"tdp_max_ppt_w": 88, "has_igpu": true}')
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand, tier = EXCLUDED.tier, model = EXCLUDED.model, codename = EXCLUDED.codename,
  socket = EXCLUDED.socket, cores_threads = EXCLUDED.cores_threads, base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz, cache = EXCLUDED.cache, tdp_w = EXCLUDED.tdp_w, memory = EXCLUDED.memory, extra = EXCLUDED.extra;

INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-39', 'Intel', 'i9', '13900K', '랩터레이크', 'LGA1700', '24C/32T', 3.0, 5.8, '32MB/36MB', 125, 'DDR5-5600/DDR4-3200', '{"tdp_range_w": "125-253", "has_igpu": true}')
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand, tier = EXCLUDED.tier, model = EXCLUDED.model, codename = EXCLUDED.codename,
  socket = EXCLUDED.socket, cores_threads = EXCLUDED.cores_threads, base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz, cache = EXCLUDED.cache, tdp_w = EXCLUDED.tdp_w, memory = EXCLUDED.memory, extra = EXCLUDED.extra;

INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-40', 'Intel', 'i5', '12400', '엘더레이크', 'LGA1700', '6C/12T', 2.5, 4.4, '7.5MB/18MB', 65, 'DDR4-3200/DDR5-4800', '{"tdp_range_w": "65-117", "has_igpu": true}')
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand, tier = EXCLUDED.tier, model = EXCLUDED.model, codename = EXCLUDED.codename,
  socket = EXCLUDED.socket, cores_threads = EXCLUDED.cores_threads, base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz, cache = EXCLUDED.cache, tdp_w = EXCLUDED.tdp_w, memory = EXCLUDED.memory, extra = EXCLUDED.extra;

INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-41', 'Intel', 'i5', '13500', '랩터레이크', 'LGA1700', '14C/20T', 2.5, 4.8, '11.5MB/24MB', 65, 'DDR5-4800/DDR4-3200', '{"tdp_range_w": "65-154", "has_igpu": true}')
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand, tier = EXCLUDED.tier, model = EXCLUDED.model, codename = EXCLUDED.codename,
  socket = EXCLUDED.socket, cores_threads = EXCLUDED.cores_threads, base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz, cache = EXCLUDED.cache, tdp_w = EXCLUDED.tdp_w, memory = EXCLUDED.memory, extra = EXCLUDED.extra;

INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-42', 'AMD', '라이젠3', '3200G', '피카소', 'AM4', '4C/4T', 3.6, 4.0, '2MB/4MB', 65, 'DDR4-2933', '{"has_igpu": true, "gpu_model": "Radeon Vega 8"}')
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand, tier = EXCLUDED.tier, model = EXCLUDED.model, codename = EXCLUDED.codename,
  socket = EXCLUDED.socket, cores_threads = EXCLUDED.cores_threads, base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz, cache = EXCLUDED.cache, tdp_w = EXCLUDED.tdp_w, memory = EXCLUDED.memory, extra = EXCLUDED.extra;

-- ---------- gpu ----------

INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra, power_connector_pins, power_connector_count)
VALUES ('gpu-45', 'RTX50', 'PALIT 지포스 RTX 5060 Ti DUAL D7 8GB 이엠텍', 8, 180, '8핀', 600, 262.1, '2슬롯(40.1mm)', 2, true,
  '{"base_mhz": 2407, "boost_mhz": 2572, "pcie": "PCIe5.0x16(at x8)", "stream_processors": 4608, "memory_type": "GDDR7", "source": "danawa"}', 8, 1)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series, model = EXCLUDED.model, vram_gb = EXCLUDED.vram_gb, tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector, recommended_psu_w = EXCLUDED.recommended_psu_w, length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness, fans = EXCLUDED.fans, verified = EXCLUDED.verified, extra = EXCLUDED.extra,
  power_connector_pins = EXCLUDED.power_connector_pins, power_connector_count = EXCLUDED.power_connector_count;

INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra, power_connector_pins, power_connector_count)
VALUES ('gpu-46', 'RX9000', 'GIGABYTE 라데온 RX 9060 XT GAMING OC D6 8GB 피씨디렉트', 8, 160, '8핀x1', 450, 281, '3슬롯(40mm)', 3, true,
  '{"boost_mhz": 3320, "pcie": "PCIe5.0x16", "stream_processors": 2048, "memory_type": "GDDR6", "source": "danawa"}', 8, 1)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series, model = EXCLUDED.model, vram_gb = EXCLUDED.vram_gb, tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector, recommended_psu_w = EXCLUDED.recommended_psu_w, length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness, fans = EXCLUDED.fans, verified = EXCLUDED.verified, extra = EXCLUDED.extra,
  power_connector_pins = EXCLUDED.power_connector_pins, power_connector_count = EXCLUDED.power_connector_count;

INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra, power_connector_pins, power_connector_count)
VALUES ('gpu-47', 'RX9000', 'SAPPHIRE 라데온 RX 9070 PULSE D6 16GB', 16, 220, '8핀x2', 650, 280, '2슬롯(51.5mm)', 2, true,
  '{"boost_mhz": 2520, "pcie": "PCIe5.0x16", "stream_processors": 3584, "memory_type": "GDDR6", "source": "danawa"}', 8, 2)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series, model = EXCLUDED.model, vram_gb = EXCLUDED.vram_gb, tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector, recommended_psu_w = EXCLUDED.recommended_psu_w, length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness, fans = EXCLUDED.fans, verified = EXCLUDED.verified, extra = EXCLUDED.extra,
  power_connector_pins = EXCLUDED.power_connector_pins, power_connector_count = EXCLUDED.power_connector_count;

-- ---------- motherboard ----------

INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, m2_pcie_top, m2_pcie_verified, extra)
VALUES ('mb-47', 'ASUS ROG STRIX X570-E GAMING WIFI II 대원씨티에스', 'AM4', 'X570', 'ATX', 305, 244, 2, 3, 'DDR4', 'PCIe4.0x4', true,
  '{"pcie_x1_slots": 2, "m2_slots": 2, "sata_ports": 8, "source": "danawa"}')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model, socket = EXCLUDED.socket, chipset = EXCLUDED.chipset, form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm, depth_mm = EXCLUDED.depth_mm, pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots, memory_type = EXCLUDED.memory_type,
  m2_pcie_top = EXCLUDED.m2_pcie_top, m2_pcie_verified = EXCLUDED.m2_pcie_verified, extra = EXCLUDED.extra;

INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, m2_pcie_top, m2_pcie_verified, extra)
VALUES ('mb-48', 'GIGABYTE Z790 AORUS ELITE AX 피씨디렉트', 'LGA1700', 'Z790', 'ATX', 305, 244, 1, 3, 'DDR5', 'PCIe4.0x4', true,
  '{"pcie_x4_slots": 2, "m2_slots": 4, "note": "23년 11월 리비전 이후 전원부 70→90A, PCB/무선모듈 변경, 구매시 리비전 확인", "source": "danawa"}')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model, socket = EXCLUDED.socket, chipset = EXCLUDED.chipset, form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm, depth_mm = EXCLUDED.depth_mm, pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots, memory_type = EXCLUDED.memory_type,
  m2_pcie_top = EXCLUDED.m2_pcie_top, m2_pcie_verified = EXCLUDED.m2_pcie_verified, extra = EXCLUDED.extra;

INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, m2_pcie_top, m2_pcie_verified, extra)
VALUES ('mb-49', 'ASRock A620M-HDV/M.2 디앤디컴', 'AM5', 'A620', 'M-ATX', 244, 226, 1, 1, 'DDR5', 'PCIe4.0x4', true,
  '{"pcie_x1_slots": 2, "m2_slots": 2, "sata_ports": 2, "source": "danawa"}')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model, socket = EXCLUDED.socket, chipset = EXCLUDED.chipset, form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm, depth_mm = EXCLUDED.depth_mm, pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots, memory_type = EXCLUDED.memory_type,
  m2_pcie_top = EXCLUDED.m2_pcie_top, m2_pcie_verified = EXCLUDED.m2_pcie_verified, extra = EXCLUDED.extra;

-- ---------- ram ----------

INSERT INTO ram (id, type, model, speed_mhz, heatsink_height_mm, voltage_v, extra)
VALUES ('ram-34', 'DDR5', 'G.SKILL DDR5-7200 CL34 TRIDENT Z5 RGB J 패키지', 7200, 44, 1.40, '{"cl": "34-45-45-115"}')
ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type, model = EXCLUDED.model, speed_mhz = EXCLUDED.speed_mhz,
  heatsink_height_mm = EXCLUDED.heatsink_height_mm, voltage_v = EXCLUDED.voltage_v, extra = EXCLUDED.extra;

INSERT INTO ram (id, type, model, speed_mhz, heatsink_height_mm, voltage_v, extra)
VALUES ('ram-35', 'DDR4', 'CORSAIR DDR4-2666 CL16 VENGEANCE LPX 레드', 2666, null, 1.20, '{"cl": "16-18-18-35"}')
ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type, model = EXCLUDED.model, speed_mhz = EXCLUDED.speed_mhz,
  heatsink_height_mm = EXCLUDED.heatsink_height_mm, voltage_v = EXCLUDED.voltage_v, extra = EXCLUDED.extra;

INSERT INTO ram (id, type, model, speed_mhz, heatsink_height_mm, voltage_v, extra)
VALUES ('ram-36', 'DDR5', '킹스톤 FURY DDR5-5600 CL36 Beast 블랙 코잇', 5600, null, 1.25, '{"capacity_gb": 32, "cl": "36-38-38"}')
ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type, model = EXCLUDED.model, speed_mhz = EXCLUDED.speed_mhz,
  heatsink_height_mm = EXCLUDED.heatsink_height_mm, voltage_v = EXCLUDED.voltage_v, extra = EXCLUDED.extra;

-- ---------- psu ----------

INSERT INTO psu (id, model, watt, grade, length_mm, atx_version, form_factor, extra, atx_spec, native_gpu_connector)
VALUES ('psu-30', 'Corsair SF750 (SFX, ATX3.1)', 750, '플래티넘', 100, 'ATX3.1', 'SFX',
  '{"connectors": "24핀, EPS(4+4)x2, 12VHPWR x1, PCIe8핀x2, SATAx8", "fan_mm": 92, "note": "팬리스모드 지원, 24년 7월 ATX3.0→ATX3.1 인증 추가", "source": "danawa"}',
  'ATX3.1', '12VHPWR')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model, watt = EXCLUDED.watt, grade = EXCLUDED.grade, length_mm = EXCLUDED.length_mm,
  atx_version = EXCLUDED.atx_version, form_factor = EXCLUDED.form_factor, extra = EXCLUDED.extra,
  atx_spec = EXCLUDED.atx_spec, native_gpu_connector = EXCLUDED.native_gpu_connector;

INSERT INTO psu (id, model, watt, grade, length_mm, atx_version, form_factor, extra, atx_spec, native_gpu_connector)
VALUES ('psu-31', '시소닉 PRIME TITANIUM TX-1600 풀모듈러 ATX3.1', 1600, '티타늄', 210, 'ATX3.1', 'ATX',
  '{"connectors": "24핀, EPS(4+4)x3, 12V2x6 x2, PCIe8핀x6, SATAx16", "fan_mm": 135, "warranty_years": 12, "source": "danawa"}',
  'ATX3.1', '12V-2x6')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model, watt = EXCLUDED.watt, grade = EXCLUDED.grade, length_mm = EXCLUDED.length_mm,
  atx_version = EXCLUDED.atx_version, form_factor = EXCLUDED.form_factor, extra = EXCLUDED.extra,
  atx_spec = EXCLUDED.atx_spec, native_gpu_connector = EXCLUDED.native_gpu_connector;

INSERT INTO psu (id, model, watt, grade, length_mm, atx_version, form_factor, extra, atx_spec, native_gpu_connector)
VALUES ('psu-32', '마이크로닉스 Classic II 풀체인지 600W 80PLUS브론즈 ATX3.1', 600, '브론즈', 140, 'ATX3.1', 'ATX', null,
  'ATX3.1', null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model, watt = EXCLUDED.watt, grade = EXCLUDED.grade, length_mm = EXCLUDED.length_mm,
  atx_version = EXCLUDED.atx_version, form_factor = EXCLUDED.form_factor, extra = EXCLUDED.extra,
  atx_spec = EXCLUDED.atx_spec, native_gpu_connector = EXCLUDED.native_gpu_connector;

-- ---------- pc_case ----------

INSERT INTO pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm)
VALUES ('case-32', 'Fractal Design Define 7', '미들타워', 'E-ATX;ATX;M-ATX;Mini-ITX', 470, 185, '표준-ATX', '하단후면', '250', null, null, null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model, tower_type = EXCLUDED.tower_type, supported_mb = EXCLUDED.supported_mb,
  gpu_max_length_mm = EXCLUDED.gpu_max_length_mm, cpu_cooler_max_height_mm = EXCLUDED.cpu_cooler_max_height_mm,
  psu_support = EXCLUDED.psu_support, psu_position = EXCLUDED.psu_position, psu_max_length_mm = EXCLUDED.psu_max_length_mm,
  radiator_top_mm = EXCLUDED.radiator_top_mm, radiator_front_mm = EXCLUDED.radiator_front_mm, radiator_side_mm = EXCLUDED.radiator_side_mm;

INSERT INTO pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm)
VALUES ('case-33', 'SilverStone SUGO SST-SG13B-C', '미니ITX', 'Mini-ITX', 270, 61, '표준-ATX', '상단', '150', null, null, null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model, tower_type = EXCLUDED.tower_type, supported_mb = EXCLUDED.supported_mb,
  gpu_max_length_mm = EXCLUDED.gpu_max_length_mm, cpu_cooler_max_height_mm = EXCLUDED.cpu_cooler_max_height_mm,
  psu_support = EXCLUDED.psu_support, psu_position = EXCLUDED.psu_position, psu_max_length_mm = EXCLUDED.psu_max_length_mm,
  radiator_top_mm = EXCLUDED.radiator_top_mm, radiator_front_mm = EXCLUDED.radiator_front_mm, radiator_side_mm = EXCLUDED.radiator_side_mm;

INSERT INTO pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm)
VALUES ('case-34', '쿨러마스터 MasterBox TD500 Mesh V2', '미들타워', 'E-ATX;ATX;M-ATX;Mini-ITX;SSI-CEB', 410, 165, '표준-ATX', '하단후면', '170-200', null, null, null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model, tower_type = EXCLUDED.tower_type, supported_mb = EXCLUDED.supported_mb,
  gpu_max_length_mm = EXCLUDED.gpu_max_length_mm, cpu_cooler_max_height_mm = EXCLUDED.cpu_cooler_max_height_mm,
  psu_support = EXCLUDED.psu_support, psu_position = EXCLUDED.psu_position, psu_max_length_mm = EXCLUDED.psu_max_length_mm,
  radiator_top_mm = EXCLUDED.radiator_top_mm, radiator_front_mm = EXCLUDED.radiator_front_mm, radiator_side_mm = EXCLUDED.radiator_side_mm;

INSERT INTO pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm)
VALUES ('case-35', '리안리 PC-O11D EVO RGB', '미들타워', 'E-ATX;ATX;M-ATX;Mini-ITX', 456, 167, '표준-ATX', '하단후면', '190', '280/360', '280/360', '280/360')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model, tower_type = EXCLUDED.tower_type, supported_mb = EXCLUDED.supported_mb,
  gpu_max_length_mm = EXCLUDED.gpu_max_length_mm, cpu_cooler_max_height_mm = EXCLUDED.cpu_cooler_max_height_mm,
  psu_support = EXCLUDED.psu_support, psu_position = EXCLUDED.psu_position, psu_max_length_mm = EXCLUDED.psu_max_length_mm,
  radiator_top_mm = EXCLUDED.radiator_top_mm, radiator_front_mm = EXCLUDED.radiator_front_mm, radiator_side_mm = EXCLUDED.radiator_side_mm;

-- ---------- ssd ----------

INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-50', 'Micron Crucial P3 Plus M.2 NVMe 해외구매 (1TB)', 'M.2 NVMe', 'PCIe4.0x4')
ON CONFLICT (id) DO UPDATE SET model = EXCLUDED.model, type = EXCLUDED.type, interface = EXCLUDED.interface;

INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-51', 'Western Digital WD Green SN350 M.2 NVMe (1TB)', 'M.2 NVMe', 'PCIe3.0x4')
ON CONFLICT (id) DO UPDATE SET model = EXCLUDED.model, type = EXCLUDED.type, interface = EXCLUDED.interface;

INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-52', '삼성전자 980 M.2 NVMe (1TB)', 'M.2 NVMe', 'PCIe3.0x4')
ON CONFLICT (id) DO UPDATE SET model = EXCLUDED.model, type = EXCLUDED.type, interface = EXCLUDED.interface;

-- ---------- cooler ----------

INSERT INTO cooler (id, model, type, height_mm, radiator_size_mm, supported_sockets, extra)
VALUES ('cooler-air-14', 'NOCTUA NH-L9x65', 'air', 65, null, 'AM4;AM5;LGA1851;LGA1700;LGA1200;LGA115x',
  '{"width_mm": 95, "depth_mm": 95, "fan_size_mm": 95, "fan_count": 1, "tdp_rated_w": 84, "low_profile": true}')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model, type = EXCLUDED.type, height_mm = EXCLUDED.height_mm,
  radiator_size_mm = EXCLUDED.radiator_size_mm, supported_sockets = EXCLUDED.supported_sockets, extra = EXCLUDED.extra;

INSERT INTO cooler (id, model, type, height_mm, radiator_size_mm, supported_sockets, extra)
VALUES ('cooler-air-15', 'be quiet! DARK ROCK PRO 5', 'air', 168, null, 'AM4;AM5;LGA1700;LGA1200;LGA115x',
  '{"width_mm": 136, "depth_mm": 145, "fan_size_mm": 135, "fan_count": 2, "tdp_rated_w": 270}')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model, type = EXCLUDED.type, height_mm = EXCLUDED.height_mm,
  radiator_size_mm = EXCLUDED.radiator_size_mm, supported_sockets = EXCLUDED.supported_sockets, extra = EXCLUDED.extra;

INSERT INTO cooler (id, model, type, height_mm, radiator_size_mm, supported_sockets, extra)
VALUES ('cooler-aio-16', 'CORSAIR iCUE LINK H150i RGB', 'aqua', null, 360, 'AM4;AM5;LGA2011;LGA2011-V3;LGA2066;LGA1700;LGA1200;LGA115x',
  '{"radiator_length_mm": 397, "radiator_thickness_mm": 27, "fan_size_mm": 120, "fan_count": 3}')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model, type = EXCLUDED.type, height_mm = EXCLUDED.height_mm,
  radiator_size_mm = EXCLUDED.radiator_size_mm, supported_sockets = EXCLUDED.supported_sockets, extra = EXCLUDED.extra;
