-- PC 부품 호환성 체커 v2 -- 실제 부품 스펙 DB (parts_db_merged.xlsx 기반)
-- 기존 목데이터 테이블(cpus/motherboards/... 복수형, 가상 가격 포함) 정리 후
-- 엑셀 원본 데이터로 새 테이블(단수형)을 만든다. 가격 필드 없음.

drop table if exists cpus, motherboards, rams, ssds, gpus, psus, pc_cases, coolers cascade;

create table if not exists cpu (
  id text primary key,
  brand text not null,
  tier text not null,
  model text not null,
  codename text,
  socket text not null,
  cores_threads text not null,
  base_ghz numeric not null,
  boost_ghz numeric not null,
  cache text not null,
  tdp_w int not null,
  memory text not null,
  extra jsonb
);

create table if not exists motherboard (
  id text primary key,
  model text not null,
  socket text not null,
  chipset text not null,
  form_factor text not null,
  width_mm int not null,
  depth_mm int not null,
  pcie_x16_usable_slots int not null,
  pcie_x16_total_slots int,
  memory_type text not null,
  extra jsonb
);

create table if not exists ram (
  id text primary key,
  type text not null,
  model text not null,
  speed_mhz int not null,
  heatsink_height_mm numeric,
  voltage_v numeric,
  extra jsonb
);

create table if not exists gpu (
  id text primary key,
  series text not null,
  model text not null,
  vram_gb int not null,
  tdp_w numeric,
  connector text not null,
  recommended_psu_w int not null,
  length_mm numeric not null,
  thickness text not null,
  fans int not null,
  verified boolean not null default true,
  extra jsonb
);

create table if not exists psu (
  id text primary key,
  model text not null,
  watt int not null,
  grade text not null,
  length_mm int not null,
  atx_version text not null,
  form_factor text not null,
  extra jsonb
);

create table if not exists pc_case (
  id text primary key,
  model text not null,
  tower_type text not null,
  supported_mb text not null,
  gpu_max_length_mm int not null,
  cpu_cooler_max_height_mm numeric not null,
  psu_support text not null,
  psu_position text not null,
  psu_max_length_mm text,
  radiator_top_mm text,
  radiator_front_mm text,
  radiator_side_mm text
);

create table if not exists ssd (
  id text primary key,
  model text not null,
  type text not null,
  interface text not null
);

create table if not exists cooler (
  id text primary key,
  model text not null,
  type text not null,
  height_mm numeric,
  radiator_size_mm numeric,
  supported_sockets text not null,
  extra jsonb
);

insert into cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra) values
  ('cpu-01', 'AMD', '라이젠3', '3300X', '마티스', 'AM4', '4C/8T', 3.8, 4.3, '2MB/16MB', 65, 'DDR4-3200', null),
  ('cpu-02', 'AMD', '라이젠3', '4100', '르누아르-X', 'AM4', '4C/8T', 3.8, 4, '2MB/4MB', 65, 'DDR4-3200', null),
  ('cpu-03', 'AMD', '라이젠3', '3100', '마티스', 'AM4', '4C/8T', 3.6, 3.9, '2MB/16MB', 65, 'DDR4-3200', null),
  ('cpu-04', 'AMD', '라이젠5', '9600X', '그래니트 릿지', 'AM5', '6C/12T', 3.9, 5.4, '6MB/32MB', 65, 'DDR5-5600', '{"tdp_max_ppt_w": 88}'::jsonb),
  ('cpu-05', 'AMD', '라이젠5', '5600X', '버미어', 'AM4', '6C/12T', 3.7, 4.6, '3MB/32MB', 65, 'DDR4-3200', null),
  ('cpu-06', 'AMD', '라이젠5', '7600', '라파엘', 'AM5', '6C/12T', 3.8, 5.1, '6MB/32MB', 65, 'DDR5-5200', '{"has_igpu": true}'::jsonb),
  ('cpu-07', 'AMD', '라이젠7', '7800X3D', '라파엘', 'AM5', '8C/16T', 4.2, 5, '8MB/96MB', 120, 'DDR5-5200', '{"v_cache": true}'::jsonb),
  ('cpu-08', 'AMD', '라이젠7', '5700X', '버미어', 'AM4', '8C/16T', 3.4, 4.6, '4MB/32MB', 65, 'DDR4-3200', null),
  ('cpu-09', 'AMD', '라이젠5', '5600', '버미어', 'AM4', '6C/12T', 3.5, 4.4, '3MB/32MB', 65, 'DDR4-3200', '{"has_igpu": false}'::jsonb),
  ('cpu-10', 'AMD', '라이젠7', '5800X3D', '버미어', 'AM4', '8C/16T', 3.4, 4.5, '4MB/96MB', 105, 'DDR4-3200', '{"v_cache": true}'::jsonb),
  ('cpu-11', 'AMD', '라이젠7', '5700X3D', '버미어', 'AM4', '8C/16T', 3, 4.1, '4MB/96MB', 105, 'DDR4-3200', '{"v_cache": true}'::jsonb),
  ('cpu-12', 'Intel', 'i3', '14100', null, 'LGA1700', '4C/8T', 3.5, 4.7, '5MB/12MB', 60, 'DDR5-4800/DDR4-3200', '{"tdp_range_w": "60-110"}'::jsonb),
  ('cpu-13', 'Intel', 'i3', '13100F', null, 'LGA1700', '4C/8T', 3.4, 4.5, '5MB/12MB', 58, 'DDR5-4800/DDR4-3200', '{"tdp_range_w": "58-89"}'::jsonb),
  ('cpu-14', 'Intel', 'i3', '13100', null, 'LGA1700', '4C/8T', 3.4, 4.5, '5MB/12MB', 60, 'DDR5-4800/DDR4-3200', '{"tdp_range_w": "60-110"}'::jsonb),
  ('cpu-15', 'Intel', 'Ultra 9', '285K', '애로우레이크', 'LGA1851', '24C/24T', 3.7, 5.7, '36MB', 125, 'DDR5-6400', null),
  ('cpu-16', 'Intel', 'Ultra 7', '265K', '애로우레이크', 'LGA1851', '20C/20T', 3.9, 5.5, '30MB', 125, 'DDR5-6400', null),
  ('cpu-17', 'Intel', 'Ultra 5', '245K', '애로우레이크', 'LGA1851', '14C/14T', 4.2, 5.2, '24MB', 125, 'DDR5-6400', null),
  ('cpu-18', 'Intel', 'i9', '14900K', '랩터레이크-R', 'LGA1700', '24C/32T', 3.2, 6, '36MB', 125, 'DDR5-5600/DDR4-3200', null),
  ('cpu-19', 'Intel', 'i7', '14700K', '랩터레이크-R', 'LGA1700', '20C/28T', 3.4, 5.6, '33MB', 125, 'DDR5-5600/DDR4-3200', null),
  ('cpu-20', 'Intel', 'i5', '14600K', '랩터레이크-R', 'LGA1700', '14C/20T', 3.5, 5.3, '24MB', 125, 'DDR5-5600/DDR4-3200', null),
  ('cpu-21', 'Intel', 'i5', '13400F', '랩터레이크', 'LGA1700', '10C/16T', 2.5, 4.6, '20MB', 65, 'DDR5-4800/DDR4-3200', null),
  ('cpu-22', 'AMD', '라이젠7', '9800X3D', '그래니트 릿지', 'AM5', '8C/16T', 4.7, 5.2, '96MB', 120, 'DDR5-5600', '{"v_cache": true}'::jsonb),
  ('cpu-23', 'AMD', '라이젠9', '9950X', '그래니트 릿지', 'AM5', '16C/32T', 4.3, 5.7, '64MB', 170, 'DDR5-5600', null),
  ('cpu-24', 'AMD', '라이젠7', '9700X', '그래니트 릿지', 'AM5', '8C/16T', 3.8, 5.5, '32MB', 65, 'DDR5-5600', null),
  ('cpu-25', 'AMD', '라이젠5', '7500F', '라파엘', 'AM5', '6C/12T', 3.7, 5, '32MB', 65, 'DDR5-5200', '{"has_igpu": false}'::jsonb),
  ('cpu-26', 'Intel', 'i5', '14400F', '랩터레이크-R', 'LGA1700', '10C/16T', 2.5, 4.7, '20MB', 65, 'DDR5-4800/DDR4-3200', null),
  ('cpu-27', 'Intel', 'i5', '12400F', '엘더레이크', 'LGA1700', '6C/12T', 2.5, 4.4, '18MB', 65, 'DDR4-3200/DDR5-4800', null),
  ('cpu-28', 'AMD', '라이젠5', '5600G', '세잔', 'AM4', '6C/12T', 3.9, 4.4, '3MB/16MB', 65, 'DDR4-3200', '{"has_igpu": true, "gpu_model": "Radeon Vega 7"}'::jsonb)
on conflict (id) do nothing;

insert into motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra) values
  ('mb-01', 'ASUS PRIME B650M-A II', 'AM5', 'B650', 'M-ATX', 244, 244, 1, 3, 'DDR5', null),
  ('mb-02', 'ASUS TUF GAMING B650-PLUS', 'AM5', 'B650', 'ATX', 305, 244, 2, 2, 'DDR5', '{"pcie_x1_slots": 2}'::jsonb),
  ('mb-03', 'ASUS ROG STRIX X870E-E GAMING WIFI', 'AM5', 'X870E', 'ATX', 305, 244, 2, null, 'DDR5', null),
  ('mb-04', 'GIGABYTE B650M AORUS ELITE', 'AM5', 'B650', 'M-ATX', 244, 244, 1, 3, 'DDR5', null),
  ('mb-05', 'GIGABYTE X870 AORUS ELITE WIFI7', 'AM5', 'X870', 'ATX', 305, 244, 3, null, 'DDR5', null),
  ('mb-06', 'GIGABYTE B760M AORUS ELITE D4 Gen5', 'LGA1700', 'B760', 'M-ATX', 244, 244, 2, null, 'DDR4', null),
  ('mb-07', 'GIGABYTE Z890 AORUS ELITE WIFI7', 'LGA1851', 'Z890', 'ATX', 305, 244, 2, null, 'DDR5', '{"pcie_note": "자료마다 표기 다름, 재확인 필요"}'::jsonb),
  ('mb-08', 'MSI MAG B650M 박격포 WIFI', 'AM5', 'B650', 'M-ATX', 244, 244, 1, 2, 'DDR5', '{"pcie_x1_slots": 1}'::jsonb),
  ('mb-09', 'MSI PRO B650M-A WIFI', 'AM5', 'B650', 'M-ATX', 244, 244, 1, 2, 'DDR5', '{"pcie_x1_slots": 1}'::jsonb),
  ('mb-10', 'MSI MPG X870E 엣지 TI WIFI', 'AM5', 'X870E', 'ATX', 305, 244, 3, null, 'DDR5', null),
  ('mb-11', 'MSI MAG B760M 박격포 II', 'LGA1700', 'B760', 'M-ATX', 244, 244, 1, null, 'DDR5', '{"pcie_x4_slots": 1}'::jsonb),
  ('mb-12', 'MSI PRO B760M-A DDR4 II', 'LGA1700', 'B760', 'M-ATX', 244, 244, 1, 2, 'DDR4', '{"pcie_x1_slots": 1}'::jsonb),
  ('mb-13', 'ASRock B650M PRO RS/X3D', 'AM5', 'B650', 'M-ATX', 244, 244, 1, null, 'DDR5', '{"pcie_x4_slots": 1}'::jsonb),
  ('mb-14', 'ASRock B650E PG-ITX/WiFi', 'AM5', 'B650E', 'Mini-ITX', 170, 170, 1, 1, 'DDR5', '{"note": "확장슬롯 1개뿐, 추가 확장카드 불가"}'::jsonb),
  ('mb-15', 'ASRock B760M Steel Legend', 'LGA1700', 'B760', 'M-ATX', 244, 244, 1, null, 'DDR5', '{"pcie_x1_slots": 1}'::jsonb),
  ('mb-16', 'ASRock Z890 PRO-A WiFi', 'LGA1851', 'Z890', 'ATX', 305, 244, 1, null, 'DDR5', '{"pcie_x4_slots": 2, "pcie_x1_slots": 1}'::jsonb)
on conflict (id) do nothing;

insert into ram (id, type, model, speed_mhz, heatsink_height_mm, voltage_v, extra) values
  ('ram-01', 'DDR5', '삼성전자 DDR5-5600 벌크', 5600, null, 1.1, null),
  ('ram-02', 'DDR5', 'SK하이닉스 DDR5-5600 16GB', 5600, null, 1.1, null),
  ('ram-03', 'DDR5', 'ESSENCORE KLEVV DDR5-5600 CL46', 5600, null, 1.1, null),
  ('ram-04', 'DDR5', 'ADATA XPG LANCER BLADE RGB DDR5-6000', 6000, 42, 1.35, null),
  ('ram-05', 'DDR5', '팀그룹 T-Force DELTA RGB DDR5-6000', 6000, 45.1, 1.35, null),
  ('ram-06', 'DDR4', 'SK하이닉스 DDR4-3200 벌크', 3200, null, 1.2, null),
  ('ram-07', 'DDR4', '지스킬 Trident Z RGB DDR4-3200', 3200, 44, 1.35, null),
  ('ram-08', 'DDR4', '팀그룹 T-Force DELTA RGB DDR4-3600', 3600, 41, 1.35, null),
  ('ram-09', 'DDR4', '팀그룹 T-Force DELTA RGB DDR4-3600 고클럭형', 3600, 41, 1.35, null),
  ('ram-10', 'DDR4', '실리콘파워 XPOWER Zenith DDR4-3600', 3600, null, null, null)
on conflict (id) do nothing;

insert into gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra) values
  ('gpu-01', 'RTX50', 'NVIDIA GeForce RTX 5090 Founders Edition', 32, 575, '16핀', 1000, 304, '3슬롯(61mm)', 2, true, null),
  ('gpu-02', 'RTX50', 'PALIT 지포스 RTX 5080 GAMINGPRO D7 16GB', 16, 360, '16핀', 850, 331.9, '3슬롯(60mm)', 3, true, null),
  ('gpu-03', 'RTX50', 'MSI 지포스 RTX 5070 Ti 게이밍 트리오 OC 플러스 D7 16GB', 16, 300, '16핀', 750, 338, '3슬롯(50mm)', 3, true, null),
  ('gpu-04', 'RTX50', 'MSI 지포스 RTX 5070 벤투스 3X OC D7 12GB', 12, 250, '16핀', 650, 338, '3슬롯(50mm)', 3, true, null),
  ('gpu-05', 'RTX50', 'PALIT 지포스 RTX 5060 Ti Infinity 3 D7 16GB', 16, 180, '8핀', 600, 291.9, '3슬롯', 3, true, null),
  ('gpu-06', 'RTX50', '갤럭시 GALAX 지포스 RTX 5060 WHITE OC D7 8GB', 8, 140, '8핀', 550, 250, '2슬롯', 2, true, null),
  ('gpu-07', 'RTX40', 'NVIDIA GeForce RTX 4090 Founders Edition', 24, 450, '16핀', 850, 304, '3슬롯(61mm)', 2, true, null),
  ('gpu-08', 'RTX40', 'ASUS TUF Gaming GeForce RTX 4080 SUPER', 16, 320, '16핀', 750, 348.2, '3.65슬롯(72.6mm)', 3, true, null),
  ('gpu-09', 'RTX40', 'MSI GeForce RTX 4070 SUPER Gaming X Slim', 12, 220, '16핀', 650, 307, '2.3슬롯(46mm)', 3, true, null),
  ('gpu-10', 'RTX40', '이엠텍 지포스 RTX 4060 Ti MIRACLE X3', 8, 160, '8핀', 550, 282, '2.2슬롯(44mm)', 3, true, null),
  ('gpu-11', 'RTX40', '갤럭시 GALAX 지포스 RTX 4060 2X OC V2', 8, 115, '8핀', 500, 251, '2슬롯(40mm)', 2, true, null),
  ('gpu-12', 'RX7000', 'SAPPHIRE 라데온 RX 7900 XTX NITRO+ Vapor-X', 24, 420, '8핀x3', 850, 320, '3.5슬롯(71.6mm)', 3, true, null),
  ('gpu-13', 'RX7000', 'ASUS TUF Gaming 라데온 RX 7800 XT', 16, 263, '8핀x2', 700, 319.8, '2.96슬롯(59.2mm)', 3, true, null),
  ('gpu-14', 'RX7000', 'GIGABYTE 라데온 RX 7600 XT GAMING OC', 16, 190, '8핀', 600, 282, '2.5슬롯(53mm)', 3, true, null),
  ('gpu-15', 'RX7000', 'SAPPHIRE 라데온 RX 7600 PULSE', 8, 165, '8핀', 550, 240, '2.2슬롯(44mm)', 2, true, null),
  ('gpu-16', 'RTX40', '기가바이트 지포스 RTX 4070 Ti SUPER EAGLE OC ICE D6X 16GB', 16, 285, '16핀', 750, 261, '2.5슬롯(50mm)', 3, true, null),
  ('gpu-17', 'RTX40', 'MSI 지포스 RTX 4060 Ti 벤투스 2X 블랙 OC D6 16GB', 16, 165, '8핀', 550, 199, '2슬롯(42mm)', 2, true, null),
  ('gpu-18', 'RX9000', 'ASUS PRIME 라데온 RX 9070 XT OC D6 16GB', 16, null, '8핀x3', 750, 312, '3슬롯(50mm)', 3, true, '{"boost_mhz": 3010, "oc_mhz": 3030, "pcie": "PCIe5.0x16", "source": "danawa"}'::jsonb),
  ('gpu-19', 'RX9000', 'SAPPHIRE 라데온 RX 9070 XT NITRO+ OC D6 16GB', 16, 330, '16핀(12V2x6)x1', 750, 330.8, '3슬롯(65.7mm)', 3, true, '{"boost_mhz": 3060, "pcie": "PCIe5.0x16", "power_phase": "16페이즈", "source": "danawa"}'::jsonb),
  ('gpu-20', 'RX9000', 'GIGABYTE 라데온 RX 9070 XT GAMING OC D6 16GB', 16, null, '8핀x3', 850, 288, '3슬롯(56mm)', 3, true, '{"boost_mhz": 3060, "pcie": "PCIe5.0x16", "source": "danawa"}'::jsonb),
  ('gpu-21', 'RX9000', 'ASRock 라데온 RX 9070 XT CHALLENGER D6 16GB', 16, null, '8핀x2', 800, 290, '3슬롯(56mm)', 3, true, '{"boost_mhz": 2970, "pcie": "PCIe5.0x16", "source": "danawa"}'::jsonb),
  ('gpu-22', 'RX9000', 'XFX 라데온 RX 9070 XT SWIFT D6 16GB', 16, 304, '8핀x2', 800, 325, '3슬롯(65mm)', 3, true, '{"base_mhz": 1660, "boost_mhz": 2970, "pcie": "PCIe5.0x16", "source": "danawa"}'::jsonb),
  ('gpu-23', 'RX9000', 'PowerColor 라데온 RX 9070 XT Reaper D6 16GB', 16, null, '8핀x2', 750, 289, '3슬롯(41mm)', 3, true, '{"boost_mhz": 2970, "pcie": "PCIe5.0x16", "source": "danawa"}'::jsonb),
  ('gpu-24', 'RX9000', 'XFX 라데온 RX 9060 XT SWIFT DUAL OC D6 16GB', 16, 182, '8핀x1', 450, 270, '2슬롯(49mm)', 2, true, '{"base_mhz": 1900, "boost_mhz": 3320, "pcie": "PCIe5.0x16", "source": "danawa"}'::jsonb)
on conflict (id) do nothing;

insert into psu (id, model, watt, grade, length_mm, atx_version, form_factor, extra) values
  ('psu-01', 'FSP Hydro GE 650W', 650, '골드', 170, 'ATX12V v2.4', 'ATX', null),
  ('psu-02', 'SuperFlower LEADEX III 650W', 650, '골드', 165, 'ATX12V v2.32(구형)/ATX3.1(신형)', 'ATX', '{"note": "리비전별 표기 다름"}'::jsonb),
  ('psu-03', 'XFX XTR 650W Gold', 650, '골드', 170, 'ATX12V(구형)', 'ATX', null),
  ('psu-04', '시소닉 NEW FOCUS V4 GX-750', 750, '골드', 140, 'ATX3.1', 'ATX', null),
  ('psu-05', 'EVGA SUPERNOVA 750 GA', 750, '골드', 150, 'ATX12V(구형)', 'ATX', null),
  ('psu-06', '맥스엘리트 STARS GEMINI 750W', 750, '브론즈', 145, 'ATX3.1', 'ATX', null),
  ('psu-07', '마이크로닉스 Classic II 850W Gold', 850, '골드', 140, 'ATX3.1', 'ATX', null),
  ('psu-08', 'SuperFlower LEADEX VII 850W', 850, '골드', 150, 'ATX3.1', 'ATX', null),
  ('psu-09', '시소닉 NEW FOCUS V4 GX-850', 850, '골드', 140, 'ATX3.1', 'ATX', null),
  ('psu-10', '시소닉 FOCUS(V4) GX-1000', 1000, '골드', 140, 'ATX3.1', 'ATX', null),
  ('psu-11', '마이크로닉스 Classic II 1050W 230V EU', 1050, '골드', 140, 'ATX3.0/구형리비전 12VHPWR', 'ATX', '{"note": "리비전별 표기 다름"}'::jsonb),
  ('psu-12', 'FSP HYDRO G PRO 1000W', 1000, '골드', 150, 'ATX3.0', 'ATX', null)
on conflict (id) do nothing;

insert into pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm) values
  ('case-01', 'DAVEN D7 Mesh 세븐팬', '미들타워', 'ATX;M-ATX;Mini-ITX', 400, 170, '표준-ATX', '하단후면', '200', '280/360', '360', '불가'),
  ('case-02', 'darkFlash DS500 RGB', '미들타워', 'ATX;M-ATX;Mini-ITX', 405, 165, '표준-ATX', '하단후면', '170', '240/280', '240/280/360', '불가'),
  ('case-03', '마이크로닉스 WIZMAX 우드리안 MAX', '빅타워', 'ATX;ATX(후면커넥터);M-ATX;M-ATX(후면커넥터);Mini-ITX', 410, 160, '표준-ATX', '상단', null, '280/360', '360', '불가'),
  ('case-04', 'Antec FLUX PRO MESH', '빅타워', 'E-ATX;ATX;M-ATX;Mini-ITX', 455, 190, '표준-ATX', '하단후면', '180-300', '360/420', '360/420', '불가'),
  ('case-05', 'Antec FLUX SE MESH BTF', '미들타워', 'E-ATX;ATX(후면커넥터);M-ATX(후면커넥터);Mini-ITX', 408, 180, '표준-ATX', '하단후면', '235', '280/360', '360', '불가'),
  ('case-06', 'Antec FLUX MESH BTF', '미들타워', 'E-ATX;ATX(후면커넥터);M-ATX(후면커넥터);Mini-ITX', 408, 180, '표준-ATX', '하단후면', '235', '280/360', '360', '불가'),
  ('case-07', 'LIAN LI LANCOOL 207', '컴팩트ATX', 'ATX;M-ATX;Mini-ITX', 375, 180, '표준-ATX', '전면', '160', '280/360', '불가', '불가'),
  ('case-08', 'LIAN LI LANCOOL 216', '미들타워', 'E-ATX;ATX;M-ATX;Mini-ITX', 392, 180.5, '표준-ATX', '하단후면', '220', '280/360', '280/360', '불가'),
  ('case-09', '아이구주 HATCH 6 플렉스 메쉬 강화유리', '미들타워', 'ATX;M-ATX', 325, 160, '표준-ATX', '하단후면', null, '불가', '240/360', '불가'),
  ('case-10', 'DAVEN D6 MESH 강화유리', '미들타워', 'ATX;M-ATX;Mini-ITX', 330, 173, '표준-ATX', '하단후면', '170-250', '240', '280/360', '불가'),
  ('case-11', '잘만 i8 백사십 터보', '미들타워', 'ATX;M-ATX;Mini-ITX', 410, 180, '표준-ATX', '하단후면', '200', '280/360', '280/360', '불가'),
  ('case-12', 'HYTE Y70', '빅타워', 'E-ATX, ATX, M-ATX, Mini-ITX', 422, 180, '표준-ATX', '하단후면', '230', '280/360', '불가', '280/360')
on conflict (id) do nothing;

insert into ssd (id, model, type, interface) values
  ('ssd-01', 'Samsung 990 PRO 1TB', 'M.2 NVMe', 'PCIe4.0x4'),
  ('ssd-02', 'Samsung 990 PRO 2TB', 'M.2 NVMe', 'PCIe4.0x4'),
  ('ssd-03', 'Samsung 990 PRO 4TB', 'M.2 NVMe', 'PCIe4.0x4'),
  ('ssd-04', 'Samsung 990 EVO Plus 1TB', 'M.2 NVMe', 'PCIe4.0x4/PCIe5.0x2'),
  ('ssd-05', 'WD BLACK SN850X 1TB', 'M.2 NVMe', 'PCIe4.0x4'),
  ('ssd-06', 'WD BLACK SN850X 2TB', 'M.2 NVMe', 'PCIe4.0x4'),
  ('ssd-07', 'SK hynix Platinum P41 1TB', 'M.2 NVMe', 'PCIe4.0x4'),
  ('ssd-08', 'Lexar NM790 1TB', 'M.2 NVMe', 'PCIe4.0x4'),
  ('ssd-09', 'Crucial P5 Plus 1TB', 'M.2 NVMe', 'PCIe4.0x4'),
  ('ssd-10', 'Crucial P5 Plus 2TB', 'M.2 NVMe', 'PCIe4.0x4'),
  ('ssd-11', 'ADATA LEGEND 860 500GB', 'M.2 NVMe', 'PCIe4.0x4'),
  ('ssd-12', 'KLEVV CRAS C910G 500GB', 'M.2 NVMe', 'PCIe4.0x4'),
  ('ssd-13', 'KLEVV CRAS C910G 1TB', 'M.2 NVMe', 'PCIe4.0x4'),
  ('ssd-14', 'Samsung 870 EVO 250GB', 'SATA', 'SATA III'),
  ('ssd-15', 'Samsung 870 EVO 500GB', 'SATA', 'SATA III'),
  ('ssd-16', 'Samsung 870 EVO 1TB', 'SATA', 'SATA III'),
  ('ssd-17', 'Samsung 870 EVO 2TB', 'SATA', 'SATA III'),
  ('ssd-18', 'Samsung 870 EVO 4TB', 'SATA', 'SATA III'),
  ('ssd-19', 'Samsung 870 EVO 8TB', 'SATA', 'SATA III'),
  ('ssd-20', 'Crucial MX500 500GB', 'SATA', 'SATA III'),
  ('ssd-21', 'Crucial MX500 1TB', 'SATA', 'SATA III'),
  ('ssd-22', 'Crucial MX500 2TB', 'SATA', 'SATA III'),
  ('ssd-23', 'WD Blue 3D', 'SATA', 'SATA III'),
  ('ssd-24', 'Transcend SSD230S', 'SATA', 'SATA III')
on conflict (id) do nothing;

insert into cooler (id, model, type, height_mm, radiator_size_mm, supported_sockets, extra) values
  ('cooler-air-01', '쿨러마스터 Hyper 212 LED Turbo', 'air', 163, null, 'AM4;AM5;LGA1700;LGA1200;LGA115x;LGA2011;LGA2011-V3;LGA775', '{"width_mm": 120, "depth_mm": 108, "fan_size_mm": 120, "fan_count": 1}'::jsonb),
  ('cooler-air-02', 'DEEPCOOL AK620', 'air', 160, null, 'AM4;AM5;LGA1851;LGA1700;LGA1200;LGA115x;LGA2066;LGA2011-V3', '{"width_mm": 129, "depth_mm": 138, "fan_size_mm": 120, "fan_count": 2, "tdp_rated_w": 260}'::jsonb),
  ('cooler-air-03', 'ID-COOLING SE-224-XT Basic', 'air', 154, null, 'AM4;LGA1700;LGA1200;LGA115x;LGA2066;LGA2011', '{"width_mm": 120, "depth_mm": 73, "fan_size_mm": 120, "fan_count": 1, "note": "AM5 미지원(구형 브라켓 기준), XTS 버전만 LGA1851/AM5 지원"}'::jsonb),
  ('cooler-air-04', 'NOCTUA NH-D15', 'air', 165, null, 'AM4;AM5;LGA1851;LGA1700;LGA1200;LGA115x', '{"width_mm": 150, "depth_mm": 161, "fan_size_mm": 140, "fan_count": 2}'::jsonb),
  ('cooler-aio-01', 'NZXT KRAKEN 240', 'aqua', null, 240, 'AM4;AM5;TR4;sTRX4;LGA1851;LGA1700;LGA1200;LGA115x', '{"radiator_length_mm": 275, "radiator_thickness_mm": 30, "fan_size_mm": 120, "fan_count": 2}'::jsonb),
  ('cooler-aio-02', 'NZXT KRAKEN 280', 'aqua', null, 280, 'AM4;AM5;TR4;sTRX4;LGA1851;LGA1700;LGA1200;LGA115x', '{"radiator_length_mm": 315, "radiator_thickness_mm": 30, "fan_size_mm": 140, "fan_count": 2}'::jsonb),
  ('cooler-aio-03', 'NZXT KRAKEN 360', 'aqua', null, 360, 'AM4;AM5;TR4;sTRX4;LGA1851;LGA1700;LGA1200;LGA115x', '{"radiator_length_mm": 394, "radiator_thickness_mm": 27, "fan_size_mm": 120, "fan_count": 3}'::jsonb),
  ('cooler-aio-04', 'ARCTIC Liquid Freezer III 360', 'aqua', null, 360, 'AM4;AM5;LGA1851;LGA1700', '{"radiator_length_mm": 398, "radiator_thickness_mm": 38, "fan_size_mm": 120, "fan_count": 3, "vrm_fan": true}'::jsonb)
on conflict (id) do nothing;

-- 공개 읽기 정책: 로그인 없는 v1 특성상 anon(publishable key)에 SELECT만 허용
do $$
declare
  t text;
begin
  foreach t in array array['cpu','motherboard','ram','gpu','psu','pc_case','ssd','cooler']
  loop
    execute format('alter table %I enable row level security', t);
    execute format('drop policy if exists "public read" on %I', t);
    execute format('create policy "public read" on %I for select to anon using (true)', t);
  end loop;
end $$;
