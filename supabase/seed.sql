-- PC 부품 호환성 체커 v1 — Supabase 스키마 및 시드 데이터
-- 관리자가 Table Editor에서 수동 입력하기 전, 초기 테스트 데이터를 한 번에 넣기 위한 스크립트.
-- src/lib/seed-data.ts 의 목데이터와 1:1로 대응한다.
-- Supabase SQL Editor에서 전체 실행. v1은 로그인 없는 공개 조회형 도구이므로
-- anon(publishable key)에 SELECT만 허용하는 RLS 정책을 함께 건다.

create table if not exists cpus (
  id text primary key,
  brand text not null,
  name text not null,
  socket text not null,
  tdp_w int not null,
  cores text not null,
  price_krw int not null
);

create table if not exists motherboards (
  id text primary key,
  brand text not null,
  name text not null,
  socket text not null,
  ram_type text not null,
  max_ram_speed_mhz int not null,
  max_ram_capacity_gb int not null,
  m2_slots int not null,
  m2_interface int not null,
  form_factor text not null,
  price_krw int not null
);

create table if not exists rams (
  id text primary key,
  brand text not null,
  name text not null,
  type text not null,
  speed_mhz int not null,
  capacity_gb int not null,
  price_krw int not null
);

create table if not exists ssds (
  id text primary key,
  brand text not null,
  name text not null,
  interface text not null,
  pcie_version int,
  capacity_gb int not null,
  price_krw int not null
);

create table if not exists gpus (
  id text primary key,
  brand text not null,
  name text not null,
  length_mm int not null,
  recommended_psu_w int not null,
  vram_gb int not null,
  price_krw int not null
);

create table if not exists psus (
  id text primary key,
  brand text not null,
  name text not null,
  wattage_w int not null,
  form_factor text not null,
  rating text not null,
  price_krw int not null
);

create table if not exists pc_cases (
  id text primary key,
  brand text not null,
  name text not null,
  max_gpu_length_mm int not null,
  psu_form_factor text not null,
  supported_form_factors text[] not null,
  max_cooler_height_mm int not null,
  supported_radiator_sizes int[] not null,
  price_krw int not null
);

create table if not exists coolers (
  id text primary key,
  brand text not null,
  name text not null,
  type text not null,
  supported_sockets text[] not null,
  max_tdp_w int,
  height_mm int,
  radiator_size_mm int,
  price_krw int not null
);

-- CPU
insert into cpus (id, brand, name, socket, tdp_w, cores, price_krw) values
  ('cpu-i5-14600k', 'Intel', 'Core i5-14600K', 'LGA1700', 125, '14C/20T', 389000),
  ('cpu-i7-14700k', 'Intel', 'Core i7-14700K', 'LGA1700', 125, '20C/28T', 559000),
  ('cpu-i9-14900k', 'Intel', 'Core i9-14900K', 'LGA1700', 125, '24C/32T', 749000),
  ('cpu-i3-14100', 'Intel', 'Core i3-14100', 'LGA1700', 60, '4C/8T', 159000),
  ('cpu-r5-7600x', 'AMD', 'Ryzen 5 7600X', 'AM5', 105, '6C/12T', 259000),
  ('cpu-r7-7800x3d', 'AMD', 'Ryzen 7 7800X3D', 'AM5', 120, '8C/16T', 469000),
  ('cpu-r9-7950x', 'AMD', 'Ryzen 9 7950X', 'AM5', 170, '16C/32T', 699000),
  ('cpu-r5-5600', 'AMD', 'Ryzen 5 5600', 'AM4', 65, '6C/12T', 129000)
on conflict (id) do nothing;

-- Motherboard
insert into motherboards (id, brand, name, socket, ram_type, max_ram_speed_mhz, max_ram_capacity_gb, m2_slots, m2_interface, form_factor, price_krw) values
  ('mb-z790-strix', 'ASUS', 'ROG STRIX Z790-E GAMING', 'LGA1700', 'DDR5', 7800, 128, 4, 4, 'ATX', 519000),
  ('mb-b760m-pro', 'MSI', 'PRO B760M-A DDR5', 'LGA1700', 'DDR5', 6400, 128, 2, 4, 'mATX', 179000),
  ('mb-z790-carbon', 'MSI', 'MPG Z790 CARBON WIFI', 'LGA1700', 'DDR5', 7600, 128, 5, 4, 'ATX', 459000),
  ('mb-b650-aorus', 'GIGABYTE', 'B650 AORUS ELITE AX', 'AM5', 'DDR5', 6000, 128, 3, 4, 'ATX', 259000),
  ('mb-x670e-tuf', 'ASUS', 'TUF GAMING X670E-PLUS', 'AM5', 'DDR5', 6400, 128, 4, 5, 'ATX', 389000),
  ('mb-a620m', 'GIGABYTE', 'A620M GAMING X', 'AM5', 'DDR5', 5200, 64, 2, 4, 'mATX', 119000),
  ('mb-b550m-hdv', 'ASRock', 'B550M-HDV', 'AM4', 'DDR4', 3200, 64, 1, 3, 'mATX', 89000)
on conflict (id) do nothing;

-- RAM
insert into rams (id, brand, name, type, speed_mhz, capacity_gb, price_krw) values
  ('ram-z5-6000', 'G.Skill', 'Trident Z5 DDR5-6000 32GB(16Gx2)', 'DDR5', 6000, 32, 149000),
  ('ram-vengeance-5600', 'Corsair', 'Vengeance DDR5-5600 32GB(16Gx2)', 'DDR5', 5600, 32, 139000),
  ('ram-flarex5-6400', 'G.Skill', 'Flare X5 DDR5-6400 32GB(16Gx2)', 'DDR5', 6400, 32, 159000),
  ('ram-fury-5200', 'Kingston', 'FURY Beast DDR5-5200 16GB(8Gx2)', 'DDR5', 5200, 16, 79000),
  ('ram-tforce-8000', 'TeamGroup', 'T-Force Delta DDR5-8000 32GB(16Gx2)', 'DDR5', 8000, 32, 219000),
  ('ram-vengeance-lpx-3200', 'Corsair', 'Vengeance LPX DDR4-3200 16GB(8Gx2)', 'DDR4', 3200, 16, 59000),
  ('ram-crucial-2666', 'Crucial', 'DDR4-2666 8GB', 'DDR4', 2666, 8, 29000)
on conflict (id) do nothing;

-- SSD
insert into ssds (id, brand, name, interface, pcie_version, capacity_gb, price_krw) values
  ('ssd-990pro-2tb', 'Samsung', '990 PRO 2TB NVMe', 'NVMe', 4, 2000, 219000),
  ('ssd-sn850x-1tb', 'WD', 'Black SN850X 1TB NVMe', 'NVMe', 4, 1000, 129000),
  ('ssd-t700-2tb', 'Crucial', 'T700 2TB NVMe (PCIe 5.0)', 'NVMe', 5, 2000, 289000),
  ('ssd-firecuda-2tb', 'Seagate', 'FireCuda 530 2TB NVMe', 'NVMe', 4, 2000, 209000),
  ('ssd-nv2-1tb', 'Kingston', 'NV2 1TB NVMe', 'NVMe', 4, 1000, 79000),
  ('ssd-870evo-1tb', 'Samsung', '870 EVO 1TB SATA', 'SATA', null, 1000, 99000)
on conflict (id) do nothing;

-- GPU
insert into gpus (id, brand, name, length_mm, recommended_psu_w, vram_gb, price_krw) values
  ('gpu-4090-fe', 'NVIDIA', 'GeForce RTX 4090 Founders Edition', 304, 850, 24, 2390000),
  ('gpu-4070ti-super', 'NVIDIA', 'GeForce RTX 4070 Ti SUPER', 267, 700, 16, 1099000),
  ('gpu-4070', 'NVIDIA', 'GeForce RTX 4070', 242, 650, 12, 699000),
  ('gpu-4060', 'NVIDIA', 'GeForce RTX 4060', 200, 550, 8, 389000),
  ('gpu-7900xtx', 'AMD', 'Radeon RX 7900 XTX', 320, 800, 24, 1199000),
  ('gpu-7800xt', 'AMD', 'Radeon RX 7800 XT', 267, 700, 16, 649000)
on conflict (id) do nothing;

-- PSU
insert into psus (id, brand, name, wattage_w, form_factor, rating, price_krw) values
  ('psu-rm850x', 'Corsair', 'RM850x', 850, 'ATX', '80+ Gold', 189000),
  ('psu-focus-gx750', 'Seasonic', 'FOCUS GX-750', 750, 'ATX', '80+ Gold', 149000),
  ('psu-purepower-650', 'be quiet!', 'Pure Power 12 M 650W', 650, 'ATX', '80+ Gold', 109000),
  ('psu-maga650', 'MSI', 'MAG A650BN', 650, 'ATX', '80+ Bronze', 79000),
  ('psu-sf750', 'Corsair', 'SF750', 750, 'SFX', '80+ Platinum', 219000),
  ('psu-v550-sfx', 'Cooler Master', 'V550 SFX', 550, 'SFX', '80+ Gold', 119000)
on conflict (id) do nothing;

-- Case
insert into pc_cases (id, brand, name, max_gpu_length_mm, psu_form_factor, supported_form_factors, max_cooler_height_mm, supported_radiator_sizes, price_krw) values
  ('case-o11-evo', 'Lian Li', 'O11 Dynamic EVO', 420, 'ATX', array['ATX','mATX','ITX'], 167, array[240,280,360], 219000),
  ('case-4000d', 'Corsair', '4000D Airflow', 360, 'ATX', array['ATX','mATX','ITX'], 170, array[240,280,360], 129000),
  ('case-h510', 'NZXT', 'H510', 381, 'ATX', array['ATX','mATX','ITX'], 165, array[240,280], 109000),
  ('case-q300l', 'Cooler Master', 'MasterBox Q300L', 360, 'ATX', array['mATX','ITX'], 159, array[240], 59000),
  ('case-terra-itx', 'Fractal Design', 'Terra (Mini-ITX)', 268, 'SFX', array['ITX'], 60, array[240], 259000)
on conflict (id) do nothing;

-- Cooler
insert into coolers (id, brand, name, type, supported_sockets, max_tdp_w, height_mm, radiator_size_mm, price_krw) values
  ('cooler-nhd15', 'Noctua', 'NH-D15 (공랭)', 'air', array['LGA1700','AM5','AM4'], 220, 165, null, 159000),
  ('cooler-ak620', 'DeepCool', 'AK620 (공랭)', 'air', array['LGA1700','AM5','AM4'], 260, 160, null, 69000),
  ('cooler-hyper212', 'Cooler Master', 'Hyper 212 (공랭)', 'air', array['LGA1700','AM4'], 150, 159, null, 39000),
  ('cooler-se224xt', 'ID-COOLING', 'SE-224-XT (공랭, 보급형)', 'air', array['LGA1700','AM4'], 180, 154, null, 29000),
  ('cooler-h150i', 'Corsair', 'iCUE H150i ELITE (수랭 360mm)', 'aqua', array['LGA1700','AM5','AM4'], null, null, 360, 259000),
  ('cooler-kraken-x63', 'NZXT', 'Kraken X63 (수랭 280mm)', 'aqua', array['LGA1700','AM5','AM4'], null, null, 280, 219000)
on conflict (id) do nothing;

-- 공개 읽기 정책: 로그인 없는 v1 특성상 anon(publishable key)에 SELECT만 허용
do $$
declare
  t text;
begin
  foreach t in array array['cpus','motherboards','rams','ssds','gpus','psus','pc_cases','coolers']
  loop
    execute format('alter table %I enable row level security', t);
    execute format('drop policy if exists "public read" on %I', t);
    execute format('create policy "public read" on %I for select to anon using (true)', t);
  end loop;
end $$;
