-- ==========================================================
-- TriFit 전체 통합 시드 SQL (원본 + danawa 추가분)
-- 전부 INSERT ... ON CONFLICT (id) DO UPDATE 방식이라 언제 다시 돌려도
-- 기존 행을 지우지 않고 갱신만 함 -- 이 파일 하나만 실행하면 됨.
-- ==========================================================


-- ============ 테이블 생성 (없으면) ============

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



-- ============ cpu 원본 데이터 ============


-- cpu-01: 3300X
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-01', 'AMD', '라이젠3', '3300X', '마티스', 'AM4', '4C/8T', 3.8, 4.3, '2MB/16MB', 65, 'DDR4-3200', null)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-02: 4100
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-02', 'AMD', '라이젠3', '4100', '르누아르-X', 'AM4', '4C/8T', 3.8, 4, '2MB/4MB', 65, 'DDR4-3200', null)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-03: 3100
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-03', 'AMD', '라이젠3', '3100', '마티스', 'AM4', '4C/8T', 3.6, 3.9, '2MB/16MB', 65, 'DDR4-3200', null)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-04: 9600X
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-04', 'AMD', '라이젠5', '9600X', '그래니트 릿지', 'AM5', '6C/12T', 3.9, 5.4, '6MB/32MB', 65, 'DDR5-5600', '{"tdp_max_ppt_w": 88}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-05: 5600X
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-05', 'AMD', '라이젠5', '5600X', '버미어', 'AM4', '6C/12T', 3.7, 4.6, '3MB/32MB', 65, 'DDR4-3200', null)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-06: 7600
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-06', 'AMD', '라이젠5', '7600', '라파엘', 'AM5', '6C/12T', 3.8, 5.1, '6MB/32MB', 65, 'DDR5-5200', '{"has_igpu": true}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-07: 7800X3D
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-07', 'AMD', '라이젠7', '7800X3D', '라파엘', 'AM5', '8C/16T', 4.2, 5, '8MB/96MB', 120, 'DDR5-5200', '{"v_cache": true}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-08: 5700X
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-08', 'AMD', '라이젠7', '5700X', '버미어', 'AM4', '8C/16T', 3.4, 4.6, '4MB/32MB', 65, 'DDR4-3200', null)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-09: 5600
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-09', 'AMD', '라이젠5', '5600', '버미어', 'AM4', '6C/12T', 3.5, 4.4, '3MB/32MB', 65, 'DDR4-3200', '{"has_igpu": false}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-10: 5800X3D
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-10', 'AMD', '라이젠7', '5800X3D', '버미어', 'AM4', '8C/16T', 3.4, 4.5, '4MB/96MB', 105, 'DDR4-3200', '{"v_cache": true}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-11: 5700X3D
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-11', 'AMD', '라이젠7', '5700X3D', '버미어', 'AM4', '8C/16T', 3, 4.1, '4MB/96MB', 105, 'DDR4-3200', '{"v_cache": true}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-12: 14100
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-12', 'Intel', 'i3', '14100', null, 'LGA1700', '4C/8T', 3.5, 4.7, '5MB/12MB', 60, 'DDR5-4800/DDR4-3200', '{"tdp_range_w": "60-110"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-13: 13100F
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-13', 'Intel', 'i3', '13100F', null, 'LGA1700', '4C/8T', 3.4, 4.5, '5MB/12MB', 58, 'DDR5-4800/DDR4-3200', '{"tdp_range_w": "58-89"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-14: 13100
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-14', 'Intel', 'i3', '13100', null, 'LGA1700', '4C/8T', 3.4, 4.5, '5MB/12MB', 60, 'DDR5-4800/DDR4-3200', '{"tdp_range_w": "60-110"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-15: 285K
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-15', 'Intel', 'Ultra 9', '285K', '애로우레이크', 'LGA1851', '24C/24T', 3.7, 5.7, '36MB', 125, 'DDR5-6400', null)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-16: 265K
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-16', 'Intel', 'Ultra 7', '265K', '애로우레이크', 'LGA1851', '20C/20T', 3.9, 5.5, '30MB', 125, 'DDR5-6400', null)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-17: 245K
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-17', 'Intel', 'Ultra 5', '245K', '애로우레이크', 'LGA1851', '14C/14T', 4.2, 5.2, '24MB', 125, 'DDR5-6400', null)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-18: 14900K
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-18', 'Intel', 'i9', '14900K', '랩터레이크-R', 'LGA1700', '24C/32T', 3.2, 6, '36MB', 125, 'DDR5-5600/DDR4-3200', null)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-19: 14700K
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-19', 'Intel', 'i7', '14700K', '랩터레이크-R', 'LGA1700', '20C/28T', 3.4, 5.6, '33MB', 125, 'DDR5-5600/DDR4-3200', null)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-20: 14600K
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-20', 'Intel', 'i5', '14600K', '랩터레이크-R', 'LGA1700', '14C/20T', 3.5, 5.3, '24MB', 125, 'DDR5-5600/DDR4-3200', null)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-21: 13400F
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-21', 'Intel', 'i5', '13400F', '랩터레이크', 'LGA1700', '10C/16T', 2.5, 4.6, '20MB', 65, 'DDR5-4800/DDR4-3200', null)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-22: 9800X3D
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-22', 'AMD', '라이젠7', '9800X3D', '그래니트 릿지', 'AM5', '8C/16T', 4.7, 5.2, '96MB', 120, 'DDR5-5600', '{"v_cache": true}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-23: 9950X
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-23', 'AMD', '라이젠9', '9950X', '그래니트 릿지', 'AM5', '16C/32T', 4.3, 5.7, '64MB', 170, 'DDR5-5600', null)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-24: 9700X
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-24', 'AMD', '라이젠7', '9700X', '그래니트 릿지', 'AM5', '8C/16T', 3.8, 5.5, '32MB', 65, 'DDR5-5600', null)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-25: 7500F
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-25', 'AMD', '라이젠5', '7500F', '라파엘', 'AM5', '6C/12T', 3.7, 5, '32MB', 65, 'DDR5-5200', '{"has_igpu": false}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-26: 14400F
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-26', 'Intel', 'i5', '14400F', '랩터레이크-R', 'LGA1700', '10C/16T', 2.5, 4.7, '20MB', 65, 'DDR5-4800/DDR4-3200', null)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-27: 12400F
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-27', 'Intel', 'i5', '12400F', '엘더레이크', 'LGA1700', '6C/12T', 2.5, 4.4, '18MB', 65, 'DDR4-3200/DDR5-4800', null)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-28: 5600G
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-28', 'AMD', '라이젠5', '5600G', '세잔', 'AM4', '6C/12T', 3.9, 4.4, '3MB/16MB', 65, 'DDR4-3200', '{"has_igpu": true, "gpu_model": "Radeon Vega 7"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;


-- ============ motherboard 원본 데이터 ============


-- mb-01: ASUS PRIME B650M-A II
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-01', 'ASUS PRIME B650M-A II', 'AM5', 'B650', 'M-ATX', 244, 244, 1, 3, 'DDR5', null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;

-- mb-02: ASUS TUF GAMING B650-PLUS
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-02', 'ASUS TUF GAMING B650-PLUS', 'AM5', 'B650', 'ATX', 305, 244, 2, 2, 'DDR5', '{"pcie_x1_slots": 2}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;

-- mb-03: ASUS ROG STRIX X870E-E GAMING WIFI
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-03', 'ASUS ROG STRIX X870E-E GAMING WIFI', 'AM5', 'X870E', 'ATX', 305, 244, 2, null, 'DDR5', null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;

-- mb-04: GIGABYTE B650M AORUS ELITE
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-04', 'GIGABYTE B650M AORUS ELITE', 'AM5', 'B650', 'M-ATX', 244, 244, 1, 3, 'DDR5', null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;

-- mb-05: GIGABYTE X870 AORUS ELITE WIFI7
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-05', 'GIGABYTE X870 AORUS ELITE WIFI7', 'AM5', 'X870', 'ATX', 305, 244, 3, null, 'DDR5', null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;

-- mb-06: GIGABYTE B760M AORUS ELITE D4 Gen5
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-06', 'GIGABYTE B760M AORUS ELITE D4 Gen5', 'LGA1700', 'B760', 'M-ATX', 244, 244, 2, null, 'DDR4', null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;

-- mb-07: GIGABYTE Z890 AORUS ELITE WIFI7
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-07', 'GIGABYTE Z890 AORUS ELITE WIFI7', 'LGA1851', 'Z890', 'ATX', 305, 244, 2, null, 'DDR5', '{"pcie_note": "자료마다 표기 다름, 재확인 필요"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;

-- mb-08: MSI MAG B650M 박격포 WIFI
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-08', 'MSI MAG B650M 박격포 WIFI', 'AM5', 'B650', 'M-ATX', 244, 244, 1, 2, 'DDR5', '{"pcie_x1_slots": 1}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;

-- mb-09: MSI PRO B650M-A WIFI
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-09', 'MSI PRO B650M-A WIFI', 'AM5', 'B650', 'M-ATX', 244, 244, 1, 2, 'DDR5', '{"pcie_x1_slots": 1}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;

-- mb-10: MSI MPG X870E 엣지 TI WIFI
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-10', 'MSI MPG X870E 엣지 TI WIFI', 'AM5', 'X870E', 'ATX', 305, 244, 3, null, 'DDR5', null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;

-- mb-11: MSI MAG B760M 박격포 II
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-11', 'MSI MAG B760M 박격포 II', 'LGA1700', 'B760', 'M-ATX', 244, 244, 1, null, 'DDR5', '{"pcie_x4_slots": 1}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;

-- mb-12: MSI PRO B760M-A DDR4 II
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-12', 'MSI PRO B760M-A DDR4 II', 'LGA1700', 'B760', 'M-ATX', 244, 244, 1, 2, 'DDR4', '{"pcie_x1_slots": 1}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;

-- mb-13: ASRock B650M PRO RS/X3D
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-13', 'ASRock B650M PRO RS/X3D', 'AM5', 'B650', 'M-ATX', 244, 244, 1, null, 'DDR5', '{"pcie_x4_slots": 1}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;

-- mb-14: ASRock B650E PG-ITX/WiFi
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-14', 'ASRock B650E PG-ITX/WiFi', 'AM5', 'B650E', 'Mini-ITX', 170, 170, 1, 1, 'DDR5', '{"note": "확장슬롯 1개뿐, 추가 확장카드 불가"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;

-- mb-15: ASRock B760M Steel Legend
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-15', 'ASRock B760M Steel Legend', 'LGA1700', 'B760', 'M-ATX', 244, 244, 1, null, 'DDR5', '{"pcie_x1_slots": 1}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;

-- mb-16: ASRock Z890 PRO-A WiFi
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-16', 'ASRock Z890 PRO-A WiFi', 'LGA1851', 'Z890', 'ATX', 305, 244, 1, null, 'DDR5', '{"pcie_x4_slots": 2, "pcie_x1_slots": 1}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;


-- ============ ram 원본 데이터 ============


-- ram-01: DDR5
INSERT INTO ram (id, type, model, speed_mhz, heatsink_height_mm, voltage_v, extra)
VALUES ('ram-01', 'DDR5', '삼성전자 DDR5-5600 벌크', 5600, null, 1.1, null)
ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  model = EXCLUDED.model,
  speed_mhz = EXCLUDED.speed_mhz,
  heatsink_height_mm = EXCLUDED.heatsink_height_mm,
  voltage_v = EXCLUDED.voltage_v,
  extra = EXCLUDED.extra;

-- ram-02: DDR5
INSERT INTO ram (id, type, model, speed_mhz, heatsink_height_mm, voltage_v, extra)
VALUES ('ram-02', 'DDR5', 'SK하이닉스 DDR5-5600 16GB', 5600, null, 1.1, null)
ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  model = EXCLUDED.model,
  speed_mhz = EXCLUDED.speed_mhz,
  heatsink_height_mm = EXCLUDED.heatsink_height_mm,
  voltage_v = EXCLUDED.voltage_v,
  extra = EXCLUDED.extra;

-- ram-03: DDR5
INSERT INTO ram (id, type, model, speed_mhz, heatsink_height_mm, voltage_v, extra)
VALUES ('ram-03', 'DDR5', 'ESSENCORE KLEVV DDR5-5600 CL46', 5600, null, 1.1, null)
ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  model = EXCLUDED.model,
  speed_mhz = EXCLUDED.speed_mhz,
  heatsink_height_mm = EXCLUDED.heatsink_height_mm,
  voltage_v = EXCLUDED.voltage_v,
  extra = EXCLUDED.extra;

-- ram-04: DDR5
INSERT INTO ram (id, type, model, speed_mhz, heatsink_height_mm, voltage_v, extra)
VALUES ('ram-04', 'DDR5', 'ADATA XPG LANCER BLADE RGB DDR5-6000', 6000, 42, 1.35, null)
ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  model = EXCLUDED.model,
  speed_mhz = EXCLUDED.speed_mhz,
  heatsink_height_mm = EXCLUDED.heatsink_height_mm,
  voltage_v = EXCLUDED.voltage_v,
  extra = EXCLUDED.extra;

-- ram-05: DDR5
INSERT INTO ram (id, type, model, speed_mhz, heatsink_height_mm, voltage_v, extra)
VALUES ('ram-05', 'DDR5', '팀그룹 T-Force DELTA RGB DDR5-6000', 6000, 45.1, 1.35, null)
ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  model = EXCLUDED.model,
  speed_mhz = EXCLUDED.speed_mhz,
  heatsink_height_mm = EXCLUDED.heatsink_height_mm,
  voltage_v = EXCLUDED.voltage_v,
  extra = EXCLUDED.extra;

-- ram-06: DDR4
INSERT INTO ram (id, type, model, speed_mhz, heatsink_height_mm, voltage_v, extra)
VALUES ('ram-06', 'DDR4', 'SK하이닉스 DDR4-3200 벌크', 3200, null, 1.2, null)
ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  model = EXCLUDED.model,
  speed_mhz = EXCLUDED.speed_mhz,
  heatsink_height_mm = EXCLUDED.heatsink_height_mm,
  voltage_v = EXCLUDED.voltage_v,
  extra = EXCLUDED.extra;

-- ram-07: DDR4
INSERT INTO ram (id, type, model, speed_mhz, heatsink_height_mm, voltage_v, extra)
VALUES ('ram-07', 'DDR4', '지스킬 Trident Z RGB DDR4-3200', 3200, 44, 1.35, null)
ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  model = EXCLUDED.model,
  speed_mhz = EXCLUDED.speed_mhz,
  heatsink_height_mm = EXCLUDED.heatsink_height_mm,
  voltage_v = EXCLUDED.voltage_v,
  extra = EXCLUDED.extra;

-- ram-08: DDR4
INSERT INTO ram (id, type, model, speed_mhz, heatsink_height_mm, voltage_v, extra)
VALUES ('ram-08', 'DDR4', '팀그룹 T-Force DELTA RGB DDR4-3600', 3600, 41, 1.35, null)
ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  model = EXCLUDED.model,
  speed_mhz = EXCLUDED.speed_mhz,
  heatsink_height_mm = EXCLUDED.heatsink_height_mm,
  voltage_v = EXCLUDED.voltage_v,
  extra = EXCLUDED.extra;

-- ram-09: DDR4
INSERT INTO ram (id, type, model, speed_mhz, heatsink_height_mm, voltage_v, extra)
VALUES ('ram-09', 'DDR4', '팀그룹 T-Force DELTA RGB DDR4-3600 고클럭형', 3600, 41, 1.35, null)
ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  model = EXCLUDED.model,
  speed_mhz = EXCLUDED.speed_mhz,
  heatsink_height_mm = EXCLUDED.heatsink_height_mm,
  voltage_v = EXCLUDED.voltage_v,
  extra = EXCLUDED.extra;

-- ram-10: DDR4
INSERT INTO ram (id, type, model, speed_mhz, heatsink_height_mm, voltage_v, extra)
VALUES ('ram-10', 'DDR4', '실리콘파워 XPOWER Zenith DDR4-3600', 3600, null, null, null)
ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  model = EXCLUDED.model,
  speed_mhz = EXCLUDED.speed_mhz,
  heatsink_height_mm = EXCLUDED.heatsink_height_mm,
  voltage_v = EXCLUDED.voltage_v,
  extra = EXCLUDED.extra;


-- ============ gpu 원본 데이터 ============


-- gpu-01: RTX50
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-01', 'RTX50', 'NVIDIA GeForce RTX 5090 Founders Edition', 32, 575, '16핀', 1000, 304, '3슬롯(61mm)', 2, true, null)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-02: RTX50
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-02', 'RTX50', 'PALIT 지포스 RTX 5080 GAMINGPRO D7 16GB', 16, 360, '16핀', 850, 331.9, '3슬롯(60mm)', 3, true, null)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-03: RTX50
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-03', 'RTX50', 'MSI 지포스 RTX 5070 Ti 게이밍 트리오 OC 플러스 D7 16GB', 16, 300, '16핀', 750, 338, '3슬롯(50mm)', 3, true, null)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-04: RTX50
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-04', 'RTX50', 'MSI 지포스 RTX 5070 벤투스 3X OC D7 12GB', 12, 250, '16핀', 650, 338, '3슬롯(50mm)', 3, true, null)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-05: RTX50
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-05', 'RTX50', 'PALIT 지포스 RTX 5060 Ti Infinity 3 D7 16GB', 16, 180, '8핀', 600, 291.9, '3슬롯', 3, true, null)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-06: RTX50
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-06', 'RTX50', '갤럭시 GALAX 지포스 RTX 5060 WHITE OC D7 8GB', 8, 140, '8핀', 550, 250, '2슬롯', 2, true, null)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-07: RTX40
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-07', 'RTX40', 'NVIDIA GeForce RTX 4090 Founders Edition', 24, 450, '16핀', 850, 304, '3슬롯(61mm)', 2, true, null)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-08: RTX40
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-08', 'RTX40', 'ASUS TUF Gaming GeForce RTX 4080 SUPER', 16, 320, '16핀', 750, 348.2, '3.65슬롯(72.6mm)', 3, true, null)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-09: RTX40
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-09', 'RTX40', 'MSI GeForce RTX 4070 SUPER Gaming X Slim', 12, 220, '16핀', 650, 307, '2.3슬롯(46mm)', 3, true, null)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-10: RTX40
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-10', 'RTX40', '이엠텍 지포스 RTX 4060 Ti MIRACLE X3', 8, 160, '8핀', 550, 282, '2.2슬롯(44mm)', 3, true, null)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-11: RTX40
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-11', 'RTX40', '갤럭시 GALAX 지포스 RTX 4060 2X OC V2', 8, 115, '8핀', 500, 251, '2슬롯(40mm)', 2, true, null)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-12: RX7000
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-12', 'RX7000', 'SAPPHIRE 라데온 RX 7900 XTX NITRO+ Vapor-X', 24, 420, '8핀x3', 850, 320, '3.5슬롯(71.6mm)', 3, true, null)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-13: RX7000
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-13', 'RX7000', 'ASUS TUF Gaming 라데온 RX 7800 XT', 16, 263, '8핀x2', 700, 319.8, '2.96슬롯(59.2mm)', 3, true, null)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-14: RX7000
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-14', 'RX7000', 'GIGABYTE 라데온 RX 7600 XT GAMING OC', 16, 190, '8핀', 600, 282, '2.5슬롯(53mm)', 3, true, null)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-15: RX7000
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-15', 'RX7000', 'SAPPHIRE 라데온 RX 7600 PULSE', 8, 165, '8핀', 550, 240, '2.2슬롯(44mm)', 2, true, null)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-16: RTX40
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-16', 'RTX40', '기가바이트 지포스 RTX 4070 Ti SUPER EAGLE OC ICE D6X 16GB', 16, 285, '16핀', 750, 261, '2.5슬롯(50mm)', 3, true, null)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-17: RTX40
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-17', 'RTX40', 'MSI 지포스 RTX 4060 Ti 벤투스 2X 블랙 OC D6 16GB', 16, 165, '8핀', 550, 199, '2슬롯(42mm)', 2, true, null)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-18: RX9000
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-18', 'RX9000', 'ASUS PRIME 라데온 RX 9070 XT OC D6 16GB', 16, null, '8핀x3', 750, 312, '3슬롯(50mm)', 3, true, '{"boost_mhz": 3010, "oc_mhz": 3030, "pcie": "PCIe5.0x16", "source": "danawa"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-19: RX9000
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-19', 'RX9000', 'SAPPHIRE 라데온 RX 9070 XT NITRO+ OC D6 16GB', 16, 330, '16핀(12V2x6)x1', 750, 330.8, '3슬롯(65.7mm)', 3, true, '{"boost_mhz": 3060, "pcie": "PCIe5.0x16", "power_phase": "16페이즈", "source": "danawa"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-20: RX9000
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-20', 'RX9000', 'GIGABYTE 라데온 RX 9070 XT GAMING OC D6 16GB', 16, null, '8핀x3', 850, 288, '3슬롯(56mm)', 3, true, '{"boost_mhz": 3060, "pcie": "PCIe5.0x16", "source": "danawa"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-21: RX9000
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-21', 'RX9000', 'ASRock 라데온 RX 9070 XT CHALLENGER D6 16GB', 16, null, '8핀x2', 800, 290, '3슬롯(56mm)', 3, true, '{"boost_mhz": 2970, "pcie": "PCIe5.0x16", "source": "danawa"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-22: RX9000
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-22', 'RX9000', 'XFX 라데온 RX 9070 XT SWIFT D6 16GB', 16, 304, '8핀x2', 800, 325, '3슬롯(65mm)', 3, true, '{"base_mhz": 1660, "boost_mhz": 2970, "pcie": "PCIe5.0x16", "source": "danawa"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-23: RX9000
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-23', 'RX9000', 'PowerColor 라데온 RX 9070 XT Reaper D6 16GB', 16, null, '8핀x2', 750, 289, '3슬롯(41mm)', 3, true, '{"boost_mhz": 2970, "pcie": "PCIe5.0x16", "source": "danawa"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-24: RX9000
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-24', 'RX9000', 'XFX 라데온 RX 9060 XT SWIFT DUAL OC D6 16GB', 16, 182, '8핀x1', 450, 270, '2슬롯(49mm)', 2, true, '{"base_mhz": 1900, "boost_mhz": 3320, "pcie": "PCIe5.0x16", "source": "danawa"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;


-- ============ psu 원본 데이터 ============


-- psu-01: FSP Hydro GE 650W
INSERT INTO psu (id, model, watt, grade, length_mm, atx_version, form_factor, extra)
VALUES ('psu-01', 'FSP Hydro GE 650W', 650, '골드', 170, 'ATX12V v2.4', 'ATX', null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  watt = EXCLUDED.watt,
  grade = EXCLUDED.grade,
  length_mm = EXCLUDED.length_mm,
  atx_version = EXCLUDED.atx_version,
  form_factor = EXCLUDED.form_factor,
  extra = EXCLUDED.extra;

-- psu-02: SuperFlower LEADEX III 650W
INSERT INTO psu (id, model, watt, grade, length_mm, atx_version, form_factor, extra)
VALUES ('psu-02', 'SuperFlower LEADEX III 650W', 650, '골드', 165, 'ATX12V v2.32(구형)/ATX3.1(신형)', 'ATX', '{"note": "리비전별 표기 다름"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  watt = EXCLUDED.watt,
  grade = EXCLUDED.grade,
  length_mm = EXCLUDED.length_mm,
  atx_version = EXCLUDED.atx_version,
  form_factor = EXCLUDED.form_factor,
  extra = EXCLUDED.extra;

-- psu-03: XFX XTR 650W Gold
INSERT INTO psu (id, model, watt, grade, length_mm, atx_version, form_factor, extra)
VALUES ('psu-03', 'XFX XTR 650W Gold', 650, '골드', 170, 'ATX12V(구형)', 'ATX', null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  watt = EXCLUDED.watt,
  grade = EXCLUDED.grade,
  length_mm = EXCLUDED.length_mm,
  atx_version = EXCLUDED.atx_version,
  form_factor = EXCLUDED.form_factor,
  extra = EXCLUDED.extra;

-- psu-04: 시소닉 NEW FOCUS V4 GX-750
INSERT INTO psu (id, model, watt, grade, length_mm, atx_version, form_factor, extra)
VALUES ('psu-04', '시소닉 NEW FOCUS V4 GX-750', 750, '골드', 140, 'ATX3.1', 'ATX', null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  watt = EXCLUDED.watt,
  grade = EXCLUDED.grade,
  length_mm = EXCLUDED.length_mm,
  atx_version = EXCLUDED.atx_version,
  form_factor = EXCLUDED.form_factor,
  extra = EXCLUDED.extra;

-- psu-05: EVGA SUPERNOVA 750 GA
INSERT INTO psu (id, model, watt, grade, length_mm, atx_version, form_factor, extra)
VALUES ('psu-05', 'EVGA SUPERNOVA 750 GA', 750, '골드', 150, 'ATX12V(구형)', 'ATX', null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  watt = EXCLUDED.watt,
  grade = EXCLUDED.grade,
  length_mm = EXCLUDED.length_mm,
  atx_version = EXCLUDED.atx_version,
  form_factor = EXCLUDED.form_factor,
  extra = EXCLUDED.extra;

-- psu-06: 맥스엘리트 STARS GEMINI 750W
INSERT INTO psu (id, model, watt, grade, length_mm, atx_version, form_factor, extra)
VALUES ('psu-06', '맥스엘리트 STARS GEMINI 750W', 750, '브론즈', 145, 'ATX3.1', 'ATX', null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  watt = EXCLUDED.watt,
  grade = EXCLUDED.grade,
  length_mm = EXCLUDED.length_mm,
  atx_version = EXCLUDED.atx_version,
  form_factor = EXCLUDED.form_factor,
  extra = EXCLUDED.extra;

-- psu-07: 마이크로닉스 Classic II 850W Gold
INSERT INTO psu (id, model, watt, grade, length_mm, atx_version, form_factor, extra)
VALUES ('psu-07', '마이크로닉스 Classic II 850W Gold', 850, '골드', 140, 'ATX3.1', 'ATX', null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  watt = EXCLUDED.watt,
  grade = EXCLUDED.grade,
  length_mm = EXCLUDED.length_mm,
  atx_version = EXCLUDED.atx_version,
  form_factor = EXCLUDED.form_factor,
  extra = EXCLUDED.extra;

-- psu-08: SuperFlower LEADEX VII 850W
INSERT INTO psu (id, model, watt, grade, length_mm, atx_version, form_factor, extra)
VALUES ('psu-08', 'SuperFlower LEADEX VII 850W', 850, '골드', 150, 'ATX3.1', 'ATX', null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  watt = EXCLUDED.watt,
  grade = EXCLUDED.grade,
  length_mm = EXCLUDED.length_mm,
  atx_version = EXCLUDED.atx_version,
  form_factor = EXCLUDED.form_factor,
  extra = EXCLUDED.extra;

-- psu-09: 시소닉 NEW FOCUS V4 GX-850
INSERT INTO psu (id, model, watt, grade, length_mm, atx_version, form_factor, extra)
VALUES ('psu-09', '시소닉 NEW FOCUS V4 GX-850', 850, '골드', 140, 'ATX3.1', 'ATX', null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  watt = EXCLUDED.watt,
  grade = EXCLUDED.grade,
  length_mm = EXCLUDED.length_mm,
  atx_version = EXCLUDED.atx_version,
  form_factor = EXCLUDED.form_factor,
  extra = EXCLUDED.extra;

-- psu-10: 시소닉 FOCUS(V4) GX-1000
INSERT INTO psu (id, model, watt, grade, length_mm, atx_version, form_factor, extra)
VALUES ('psu-10', '시소닉 FOCUS(V4) GX-1000', 1000, '골드', 140, 'ATX3.1', 'ATX', null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  watt = EXCLUDED.watt,
  grade = EXCLUDED.grade,
  length_mm = EXCLUDED.length_mm,
  atx_version = EXCLUDED.atx_version,
  form_factor = EXCLUDED.form_factor,
  extra = EXCLUDED.extra;

-- psu-11: 마이크로닉스 Classic II 1050W 230V EU
INSERT INTO psu (id, model, watt, grade, length_mm, atx_version, form_factor, extra)
VALUES ('psu-11', '마이크로닉스 Classic II 1050W 230V EU', 1050, '골드', 140, 'ATX3.0/구형리비전 12VHPWR', 'ATX', '{"note": "리비전별 표기 다름"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  watt = EXCLUDED.watt,
  grade = EXCLUDED.grade,
  length_mm = EXCLUDED.length_mm,
  atx_version = EXCLUDED.atx_version,
  form_factor = EXCLUDED.form_factor,
  extra = EXCLUDED.extra;

-- psu-12: FSP HYDRO G PRO 1000W
INSERT INTO psu (id, model, watt, grade, length_mm, atx_version, form_factor, extra)
VALUES ('psu-12', 'FSP HYDRO G PRO 1000W', 1000, '골드', 150, 'ATX3.0', 'ATX', null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  watt = EXCLUDED.watt,
  grade = EXCLUDED.grade,
  length_mm = EXCLUDED.length_mm,
  atx_version = EXCLUDED.atx_version,
  form_factor = EXCLUDED.form_factor,
  extra = EXCLUDED.extra;


-- ============ pc_case 원본 데이터 ============


-- case-01: DAVEN D7 Mesh 세븐팬
INSERT INTO pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm)
VALUES ('case-01', 'DAVEN D7 Mesh 세븐팬', '미들타워', 'ATX;M-ATX;Mini-ITX', 400, 170, '표준-ATX', '하단후면', '200', '280/360', '360', '불가')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  tower_type = EXCLUDED.tower_type,
  supported_mb = EXCLUDED.supported_mb,
  gpu_max_length_mm = EXCLUDED.gpu_max_length_mm,
  cpu_cooler_max_height_mm = EXCLUDED.cpu_cooler_max_height_mm,
  psu_support = EXCLUDED.psu_support,
  psu_position = EXCLUDED.psu_position,
  psu_max_length_mm = EXCLUDED.psu_max_length_mm,
  radiator_top_mm = EXCLUDED.radiator_top_mm,
  radiator_front_mm = EXCLUDED.radiator_front_mm,
  radiator_side_mm = EXCLUDED.radiator_side_mm;

-- case-02: darkFlash DS500 RGB
INSERT INTO pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm)
VALUES ('case-02', 'darkFlash DS500 RGB', '미들타워', 'ATX;M-ATX;Mini-ITX', 405, 165, '표준-ATX', '하단후면', '170', '240/280', '240/280/360', '불가')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  tower_type = EXCLUDED.tower_type,
  supported_mb = EXCLUDED.supported_mb,
  gpu_max_length_mm = EXCLUDED.gpu_max_length_mm,
  cpu_cooler_max_height_mm = EXCLUDED.cpu_cooler_max_height_mm,
  psu_support = EXCLUDED.psu_support,
  psu_position = EXCLUDED.psu_position,
  psu_max_length_mm = EXCLUDED.psu_max_length_mm,
  radiator_top_mm = EXCLUDED.radiator_top_mm,
  radiator_front_mm = EXCLUDED.radiator_front_mm,
  radiator_side_mm = EXCLUDED.radiator_side_mm;

-- case-03: 마이크로닉스 WIZMAX 우드리안 MAX
INSERT INTO pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm)
VALUES ('case-03', '마이크로닉스 WIZMAX 우드리안 MAX', '빅타워', 'ATX;ATX(후면커넥터);M-ATX;M-ATX(후면커넥터);Mini-ITX', 410, 160, '표준-ATX', '상단', null, '280/360', '360', '불가')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  tower_type = EXCLUDED.tower_type,
  supported_mb = EXCLUDED.supported_mb,
  gpu_max_length_mm = EXCLUDED.gpu_max_length_mm,
  cpu_cooler_max_height_mm = EXCLUDED.cpu_cooler_max_height_mm,
  psu_support = EXCLUDED.psu_support,
  psu_position = EXCLUDED.psu_position,
  psu_max_length_mm = EXCLUDED.psu_max_length_mm,
  radiator_top_mm = EXCLUDED.radiator_top_mm,
  radiator_front_mm = EXCLUDED.radiator_front_mm,
  radiator_side_mm = EXCLUDED.radiator_side_mm;

-- case-04: Antec FLUX PRO MESH
INSERT INTO pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm)
VALUES ('case-04', 'Antec FLUX PRO MESH', '빅타워', 'E-ATX;ATX;M-ATX;Mini-ITX', 455, 190, '표준-ATX', '하단후면', '180-300', '360/420', '360/420', '불가')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  tower_type = EXCLUDED.tower_type,
  supported_mb = EXCLUDED.supported_mb,
  gpu_max_length_mm = EXCLUDED.gpu_max_length_mm,
  cpu_cooler_max_height_mm = EXCLUDED.cpu_cooler_max_height_mm,
  psu_support = EXCLUDED.psu_support,
  psu_position = EXCLUDED.psu_position,
  psu_max_length_mm = EXCLUDED.psu_max_length_mm,
  radiator_top_mm = EXCLUDED.radiator_top_mm,
  radiator_front_mm = EXCLUDED.radiator_front_mm,
  radiator_side_mm = EXCLUDED.radiator_side_mm;

-- case-05: Antec FLUX SE MESH BTF
INSERT INTO pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm)
VALUES ('case-05', 'Antec FLUX SE MESH BTF', '미들타워', 'E-ATX;ATX(후면커넥터);M-ATX(후면커넥터);Mini-ITX', 408, 180, '표준-ATX', '하단후면', '235', '280/360', '360', '불가')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  tower_type = EXCLUDED.tower_type,
  supported_mb = EXCLUDED.supported_mb,
  gpu_max_length_mm = EXCLUDED.gpu_max_length_mm,
  cpu_cooler_max_height_mm = EXCLUDED.cpu_cooler_max_height_mm,
  psu_support = EXCLUDED.psu_support,
  psu_position = EXCLUDED.psu_position,
  psu_max_length_mm = EXCLUDED.psu_max_length_mm,
  radiator_top_mm = EXCLUDED.radiator_top_mm,
  radiator_front_mm = EXCLUDED.radiator_front_mm,
  radiator_side_mm = EXCLUDED.radiator_side_mm;

-- case-06: Antec FLUX MESH BTF
INSERT INTO pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm)
VALUES ('case-06', 'Antec FLUX MESH BTF', '미들타워', 'E-ATX;ATX(후면커넥터);M-ATX(후면커넥터);Mini-ITX', 408, 180, '표준-ATX', '하단후면', '235', '280/360', '360', '불가')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  tower_type = EXCLUDED.tower_type,
  supported_mb = EXCLUDED.supported_mb,
  gpu_max_length_mm = EXCLUDED.gpu_max_length_mm,
  cpu_cooler_max_height_mm = EXCLUDED.cpu_cooler_max_height_mm,
  psu_support = EXCLUDED.psu_support,
  psu_position = EXCLUDED.psu_position,
  psu_max_length_mm = EXCLUDED.psu_max_length_mm,
  radiator_top_mm = EXCLUDED.radiator_top_mm,
  radiator_front_mm = EXCLUDED.radiator_front_mm,
  radiator_side_mm = EXCLUDED.radiator_side_mm;

-- case-07: LIAN LI LANCOOL 207
INSERT INTO pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm)
VALUES ('case-07', 'LIAN LI LANCOOL 207', '컴팩트ATX', 'ATX;M-ATX;Mini-ITX', 375, 180, '표준-ATX', '전면', '160', '280/360', '불가', '불가')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  tower_type = EXCLUDED.tower_type,
  supported_mb = EXCLUDED.supported_mb,
  gpu_max_length_mm = EXCLUDED.gpu_max_length_mm,
  cpu_cooler_max_height_mm = EXCLUDED.cpu_cooler_max_height_mm,
  psu_support = EXCLUDED.psu_support,
  psu_position = EXCLUDED.psu_position,
  psu_max_length_mm = EXCLUDED.psu_max_length_mm,
  radiator_top_mm = EXCLUDED.radiator_top_mm,
  radiator_front_mm = EXCLUDED.radiator_front_mm,
  radiator_side_mm = EXCLUDED.radiator_side_mm;

-- case-08: LIAN LI LANCOOL 216
INSERT INTO pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm)
VALUES ('case-08', 'LIAN LI LANCOOL 216', '미들타워', 'E-ATX;ATX;M-ATX;Mini-ITX', 392, 180.5, '표준-ATX', '하단후면', '220', '280/360', '280/360', '불가')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  tower_type = EXCLUDED.tower_type,
  supported_mb = EXCLUDED.supported_mb,
  gpu_max_length_mm = EXCLUDED.gpu_max_length_mm,
  cpu_cooler_max_height_mm = EXCLUDED.cpu_cooler_max_height_mm,
  psu_support = EXCLUDED.psu_support,
  psu_position = EXCLUDED.psu_position,
  psu_max_length_mm = EXCLUDED.psu_max_length_mm,
  radiator_top_mm = EXCLUDED.radiator_top_mm,
  radiator_front_mm = EXCLUDED.radiator_front_mm,
  radiator_side_mm = EXCLUDED.radiator_side_mm;

-- case-09: 아이구주 HATCH 6 플렉스 메쉬 강화유리
INSERT INTO pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm)
VALUES ('case-09', '아이구주 HATCH 6 플렉스 메쉬 강화유리', '미들타워', 'ATX;M-ATX', 325, 160, '표준-ATX', '하단후면', null, '불가', '240/360', '불가')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  tower_type = EXCLUDED.tower_type,
  supported_mb = EXCLUDED.supported_mb,
  gpu_max_length_mm = EXCLUDED.gpu_max_length_mm,
  cpu_cooler_max_height_mm = EXCLUDED.cpu_cooler_max_height_mm,
  psu_support = EXCLUDED.psu_support,
  psu_position = EXCLUDED.psu_position,
  psu_max_length_mm = EXCLUDED.psu_max_length_mm,
  radiator_top_mm = EXCLUDED.radiator_top_mm,
  radiator_front_mm = EXCLUDED.radiator_front_mm,
  radiator_side_mm = EXCLUDED.radiator_side_mm;

-- case-10: DAVEN D6 MESH 강화유리
INSERT INTO pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm)
VALUES ('case-10', 'DAVEN D6 MESH 강화유리', '미들타워', 'ATX;M-ATX;Mini-ITX', 330, 173, '표준-ATX', '하단후면', '170-250', '240', '280/360', '불가')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  tower_type = EXCLUDED.tower_type,
  supported_mb = EXCLUDED.supported_mb,
  gpu_max_length_mm = EXCLUDED.gpu_max_length_mm,
  cpu_cooler_max_height_mm = EXCLUDED.cpu_cooler_max_height_mm,
  psu_support = EXCLUDED.psu_support,
  psu_position = EXCLUDED.psu_position,
  psu_max_length_mm = EXCLUDED.psu_max_length_mm,
  radiator_top_mm = EXCLUDED.radiator_top_mm,
  radiator_front_mm = EXCLUDED.radiator_front_mm,
  radiator_side_mm = EXCLUDED.radiator_side_mm;

-- case-11: 잘만 i8 백사십 터보
INSERT INTO pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm)
VALUES ('case-11', '잘만 i8 백사십 터보', '미들타워', 'ATX;M-ATX;Mini-ITX', 410, 180, '표준-ATX', '하단후면', '200', '280/360', '280/360', '불가')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  tower_type = EXCLUDED.tower_type,
  supported_mb = EXCLUDED.supported_mb,
  gpu_max_length_mm = EXCLUDED.gpu_max_length_mm,
  cpu_cooler_max_height_mm = EXCLUDED.cpu_cooler_max_height_mm,
  psu_support = EXCLUDED.psu_support,
  psu_position = EXCLUDED.psu_position,
  psu_max_length_mm = EXCLUDED.psu_max_length_mm,
  radiator_top_mm = EXCLUDED.radiator_top_mm,
  radiator_front_mm = EXCLUDED.radiator_front_mm,
  radiator_side_mm = EXCLUDED.radiator_side_mm;

-- case-12: HYTE Y70
INSERT INTO pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm)
VALUES ('case-12', 'HYTE Y70', '빅타워', 'E-ATX, ATX, M-ATX, Mini-ITX', 422, 180, '표준-ATX', '하단후면', '230', '280/360', '불가', '280/360')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  tower_type = EXCLUDED.tower_type,
  supported_mb = EXCLUDED.supported_mb,
  gpu_max_length_mm = EXCLUDED.gpu_max_length_mm,
  cpu_cooler_max_height_mm = EXCLUDED.cpu_cooler_max_height_mm,
  psu_support = EXCLUDED.psu_support,
  psu_position = EXCLUDED.psu_position,
  psu_max_length_mm = EXCLUDED.psu_max_length_mm,
  radiator_top_mm = EXCLUDED.radiator_top_mm,
  radiator_front_mm = EXCLUDED.radiator_front_mm,
  radiator_side_mm = EXCLUDED.radiator_side_mm;


-- ============ ssd 원본 데이터 ============


-- ssd-01: Samsung 990 PRO 1TB
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-01', 'Samsung 990 PRO 1TB', 'M.2 NVMe', 'PCIe4.0x4')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-02: Samsung 990 PRO 2TB
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-02', 'Samsung 990 PRO 2TB', 'M.2 NVMe', 'PCIe4.0x4')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-03: Samsung 990 PRO 4TB
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-03', 'Samsung 990 PRO 4TB', 'M.2 NVMe', 'PCIe4.0x4')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-04: Samsung 990 EVO Plus 1TB
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-04', 'Samsung 990 EVO Plus 1TB', 'M.2 NVMe', 'PCIe4.0x4/PCIe5.0x2')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-05: WD BLACK SN850X 1TB
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-05', 'WD BLACK SN850X 1TB', 'M.2 NVMe', 'PCIe4.0x4')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-06: WD BLACK SN850X 2TB
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-06', 'WD BLACK SN850X 2TB', 'M.2 NVMe', 'PCIe4.0x4')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-07: SK hynix Platinum P41 1TB
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-07', 'SK hynix Platinum P41 1TB', 'M.2 NVMe', 'PCIe4.0x4')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-08: Lexar NM790 1TB
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-08', 'Lexar NM790 1TB', 'M.2 NVMe', 'PCIe4.0x4')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-09: Crucial P5 Plus 1TB
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-09', 'Crucial P5 Plus 1TB', 'M.2 NVMe', 'PCIe4.0x4')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-10: Crucial P5 Plus 2TB
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-10', 'Crucial P5 Plus 2TB', 'M.2 NVMe', 'PCIe4.0x4')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-11: ADATA LEGEND 860 500GB
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-11', 'ADATA LEGEND 860 500GB', 'M.2 NVMe', 'PCIe4.0x4')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-12: KLEVV CRAS C910G 500GB
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-12', 'KLEVV CRAS C910G 500GB', 'M.2 NVMe', 'PCIe4.0x4')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-13: KLEVV CRAS C910G 1TB
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-13', 'KLEVV CRAS C910G 1TB', 'M.2 NVMe', 'PCIe4.0x4')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-14: Samsung 870 EVO 250GB
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-14', 'Samsung 870 EVO 250GB', 'SATA', 'SATA III')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-15: Samsung 870 EVO 500GB
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-15', 'Samsung 870 EVO 500GB', 'SATA', 'SATA III')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-16: Samsung 870 EVO 1TB
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-16', 'Samsung 870 EVO 1TB', 'SATA', 'SATA III')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-17: Samsung 870 EVO 2TB
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-17', 'Samsung 870 EVO 2TB', 'SATA', 'SATA III')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-18: Samsung 870 EVO 4TB
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-18', 'Samsung 870 EVO 4TB', 'SATA', 'SATA III')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-19: Samsung 870 EVO 8TB
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-19', 'Samsung 870 EVO 8TB', 'SATA', 'SATA III')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-20: Crucial MX500 500GB
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-20', 'Crucial MX500 500GB', 'SATA', 'SATA III')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-21: Crucial MX500 1TB
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-21', 'Crucial MX500 1TB', 'SATA', 'SATA III')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-22: Crucial MX500 2TB
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-22', 'Crucial MX500 2TB', 'SATA', 'SATA III')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-23: WD Blue 3D
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-23', 'WD Blue 3D', 'SATA', 'SATA III')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-24: Transcend SSD230S
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-24', 'Transcend SSD230S', 'SATA', 'SATA III')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;


-- ============ cooler 원본 데이터 ============


-- cooler-air-01: 쿨러마스터 Hyper 212 LED Turbo
INSERT INTO cooler (id, model, type, height_mm, radiator_size_mm, supported_sockets, extra)
VALUES ('cooler-air-01', '쿨러마스터 Hyper 212 LED Turbo', 'air', 163, null, 'AM4;AM5;LGA1700;LGA1200;LGA115x;LGA2011;LGA2011-V3;LGA775', '{"width_mm": 120, "depth_mm": 108, "fan_size_mm": 120, "fan_count": 1}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  height_mm = EXCLUDED.height_mm,
  radiator_size_mm = EXCLUDED.radiator_size_mm,
  supported_sockets = EXCLUDED.supported_sockets,
  extra = EXCLUDED.extra;

-- cooler-air-02: DEEPCOOL AK620
INSERT INTO cooler (id, model, type, height_mm, radiator_size_mm, supported_sockets, extra)
VALUES ('cooler-air-02', 'DEEPCOOL AK620', 'air', 160, null, 'AM4;AM5;LGA1851;LGA1700;LGA1200;LGA115x;LGA2066;LGA2011-V3', '{"width_mm": 129, "depth_mm": 138, "fan_size_mm": 120, "fan_count": 2, "tdp_rated_w": 260}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  height_mm = EXCLUDED.height_mm,
  radiator_size_mm = EXCLUDED.radiator_size_mm,
  supported_sockets = EXCLUDED.supported_sockets,
  extra = EXCLUDED.extra;

-- cooler-air-03: ID-COOLING SE-224-XT Basic
INSERT INTO cooler (id, model, type, height_mm, radiator_size_mm, supported_sockets, extra)
VALUES ('cooler-air-03', 'ID-COOLING SE-224-XT Basic', 'air', 154, null, 'AM4;LGA1700;LGA1200;LGA115x;LGA2066;LGA2011', '{"width_mm": 120, "depth_mm": 73, "fan_size_mm": 120, "fan_count": 1, "note": "AM5 미지원(구형 브라켓 기준), XTS 버전만 LGA1851/AM5 지원"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  height_mm = EXCLUDED.height_mm,
  radiator_size_mm = EXCLUDED.radiator_size_mm,
  supported_sockets = EXCLUDED.supported_sockets,
  extra = EXCLUDED.extra;

-- cooler-air-04: NOCTUA NH-D15
INSERT INTO cooler (id, model, type, height_mm, radiator_size_mm, supported_sockets, extra)
VALUES ('cooler-air-04', 'NOCTUA NH-D15', 'air', 165, null, 'AM4;AM5;LGA1851;LGA1700;LGA1200;LGA115x', '{"width_mm": 150, "depth_mm": 161, "fan_size_mm": 140, "fan_count": 2}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  height_mm = EXCLUDED.height_mm,
  radiator_size_mm = EXCLUDED.radiator_size_mm,
  supported_sockets = EXCLUDED.supported_sockets,
  extra = EXCLUDED.extra;

-- cooler-aio-01: NZXT KRAKEN 240
INSERT INTO cooler (id, model, type, height_mm, radiator_size_mm, supported_sockets, extra)
VALUES ('cooler-aio-01', 'NZXT KRAKEN 240', 'aqua', null, 240, 'AM4;AM5;TR4;sTRX4;LGA1851;LGA1700;LGA1200;LGA115x', '{"radiator_length_mm": 275, "radiator_thickness_mm": 30, "fan_size_mm": 120, "fan_count": 2}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  height_mm = EXCLUDED.height_mm,
  radiator_size_mm = EXCLUDED.radiator_size_mm,
  supported_sockets = EXCLUDED.supported_sockets,
  extra = EXCLUDED.extra;

-- cooler-aio-02: NZXT KRAKEN 280
INSERT INTO cooler (id, model, type, height_mm, radiator_size_mm, supported_sockets, extra)
VALUES ('cooler-aio-02', 'NZXT KRAKEN 280', 'aqua', null, 280, 'AM4;AM5;TR4;sTRX4;LGA1851;LGA1700;LGA1200;LGA115x', '{"radiator_length_mm": 315, "radiator_thickness_mm": 30, "fan_size_mm": 140, "fan_count": 2}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  height_mm = EXCLUDED.height_mm,
  radiator_size_mm = EXCLUDED.radiator_size_mm,
  supported_sockets = EXCLUDED.supported_sockets,
  extra = EXCLUDED.extra;

-- cooler-aio-03: NZXT KRAKEN 360
INSERT INTO cooler (id, model, type, height_mm, radiator_size_mm, supported_sockets, extra)
VALUES ('cooler-aio-03', 'NZXT KRAKEN 360', 'aqua', null, 360, 'AM4;AM5;TR4;sTRX4;LGA1851;LGA1700;LGA1200;LGA115x', '{"radiator_length_mm": 394, "radiator_thickness_mm": 27, "fan_size_mm": 120, "fan_count": 3}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  height_mm = EXCLUDED.height_mm,
  radiator_size_mm = EXCLUDED.radiator_size_mm,
  supported_sockets = EXCLUDED.supported_sockets,
  extra = EXCLUDED.extra;

-- cooler-aio-04: ARCTIC Liquid Freezer III 360
INSERT INTO cooler (id, model, type, height_mm, radiator_size_mm, supported_sockets, extra)
VALUES ('cooler-aio-04', 'ARCTIC Liquid Freezer III 360', 'aqua', null, 360, 'AM4;AM5;LGA1851;LGA1700', '{"radiator_length_mm": 398, "radiator_thickness_mm": 38, "fan_size_mm": 120, "fan_count": 3, "vrm_fan": true}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  height_mm = EXCLUDED.height_mm,
  radiator_size_mm = EXCLUDED.radiator_size_mm,
  supported_sockets = EXCLUDED.supported_sockets,
  extra = EXCLUDED.extra;


-- ============ danawa 추가분 (motherboard AM4 5개 포함) ============


-- ============ cpu 추가 (danawa) ============

-- cpu-29: AMD 라이젠9-6세대 9950X3D (그래니트 릿지) (멀티팩 정품)
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-29', 'AMD', '라이젠9', '9950X3D', '그래니트 릿지', 'AM5', '16C/32T', 4.3, 5.7, '16MB/128MB', 170, 'DDR5-5600', null)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-30: 인텔 코어i5-13세대 13600K (랩터레이크) (벌크 + 쿨러)
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-30', 'Intel', 'i5', '13600K', '랩터레이크', 'LGA1700', '14C/20T', 3.5, 5.1, '20MB/24MB', 125, 'DDR5-5600/DDR4-3200', '{"tdp_range_w": "125-181", "has_igpu": true}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-31: 인텔 코어i7-12세대 12700K (엘더레이크) (정품)
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-31', 'Intel', 'i7', '12700K', '엘더레이크', 'LGA1700', '12C/20T', 3.6, 5, '12MB/25MB', 125, 'DDR5-4800/DDR4-3200', '{"has_igpu": true}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-32: 인텔 코어i7-13세대 13700K (랩터레이크) (벌크 + 쿨러)
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-32', 'Intel', 'i7', '13700K', '랩터레이크', 'LGA1700', '16C/24T', 3.4, 5.4, '24MB/30MB', 125, 'DDR5-5600/DDR4-3200', '{"tdp_range_w": "125-253", "has_igpu": true}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-33: AMD 라이젠9-6세대 9900X (그래니트 릿지) (멀티팩 정품)
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-33', 'AMD', '라이젠9', '9900X', '그래니트 릿지', 'AM5', '12C/24T', 4.4, 5.6, '12MB/64MB', 120, 'DDR5-5600', '{"tdp_max_ppt_w": 162}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-34: AMD 라이젠9-6세대 9900X3D (그래니트 릿지) (멀티팩 정품)
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-34', 'AMD', '라이젠9', '9900X3D', '그래니트 릿지', 'AM5', '12C/24T', 4.4, 5.5, '12MB/128MB', 120, 'DDR5-5600', null)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-35: AMD 라이젠7-5세대 8700G (피닉스) (멀티팩 정품)
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-35', 'AMD', '라이젠7', '8700G', '피닉스', 'AM5', '8C/16T', 4.2, 5.1, '8MB/16MB', 65, 'DDR5-5200', '{"tdp_max_ppt_w": 88, "has_igpu": true}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-36: AMD 라이젠5-4세대 5500 (세잔) (벌크 정품)
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-36', 'AMD', '라이젠5', '5500', '세잔', 'AM4', '6C/12T', 3.6, 4.2, '3MB/16MB', 65, 'DDR4-3200', '{"has_igpu": false}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;

-- cpu-37: AMD 라이젠5-4세대 5500GT (세잔) (멀티팩 정품)
INSERT INTO cpu (id, brand, tier, model, codename, socket, cores_threads, base_ghz, boost_ghz, cache, tdp_w, memory, extra)
VALUES ('cpu-37', 'AMD', '라이젠5', '5500GT', '세잔', 'AM4', '6C/12T', 3.6, 4.4, '3MB/16MB', 65, 'DDR4-3200', '{"has_igpu": true}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  brand = EXCLUDED.brand,
  tier = EXCLUDED.tier,
  model = EXCLUDED.model,
  codename = EXCLUDED.codename,
  socket = EXCLUDED.socket,
  cores_threads = EXCLUDED.cores_threads,
  base_ghz = EXCLUDED.base_ghz,
  boost_ghz = EXCLUDED.boost_ghz,
  cache = EXCLUDED.cache,
  tdp_w = EXCLUDED.tdp_w,
  memory = EXCLUDED.memory,
  extra = EXCLUDED.extra;


-- ============ motherboard AM4 추가 ============
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-17', 'ASUS TUF Gaming B550M-PLUS', 'AM4', 'B550', 'M-ATX', 244, 244, 1, 2.0, 'DDR4', '{"pcie_x1_slots": 1, "pcie_x4_slots": 1}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-18', 'GIGABYTE B550M AORUS ELITE', 'AM4', 'B550', 'M-ATX', 244, 244, 2, 2.0, 'DDR4', '{"pcie_x1_slots": 1, "note": "2번째 PCIex16 전기적 대역폭 재확인 필요"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-19', 'ASRock B550M 스틸레전드', 'AM4', 'B550', 'M-ATX', 244, 244, 2, 2.0, 'DDR4', '{"pcie_x1_slots": 1, "note": "CrossFireX 지원, 2번째 슬롯 대역폭 재확인 필요"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-20', 'ASUS PRIME A520M-A II', 'AM4', 'A520', 'M-ATX', 244, 244, 1, 1.0, 'DDR4', '{"pcie_x1_slots": 2}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-21', 'GIGABYTE A520M K V2', 'AM4', 'A520', 'M-ATX', 233, 198, 1, 1.0, 'DDR4', '{"pcie_x1_slots": 1}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;


-- ============ motherboard 추가 (danawa, AM4 5개는 별도 반영됨) ============

-- mb-22: GIGABYTE B650M K 피씨디렉트
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-22', 'GIGABYTE B650M K 피씨디렉트', 'AM5', 'B650', 'M-ATX', 244, 244, 1, null, 'DDR5', '{"pcie_note": "PCIe4.0, PCIe3.0"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;

-- mb-23: GIGABYTE B650M K 제이씨현
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-23', 'GIGABYTE B650M K 제이씨현', 'AM5', 'B650', 'M-ATX', 244, 244, 1, null, 'DDR5', '{"pcie_note": "PCIe4.0, PCIe3.0"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;

-- mb-24: ASUS TUF Gaming B650EM-E WIFI 대원씨티에스
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-24', 'ASUS TUF Gaming B650EM-E WIFI 대원씨티에스', 'AM5', 'B650', 'M-ATX', 244, 244, 1, null, 'DDR5', '{"pcie_note": "PCIe5.0, PCIe4.0"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;

-- mb-25: MSI MAG B650 토마호크 WIFI
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-25', 'MSI MAG B650 토마호크 WIFI', 'AM5', 'B650', 'ATX', 305, 244, 1, null, 'DDR5', '{"pcie_note": "PCIe4.0, PCIe3.0"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;

-- mb-26: ASRock B650M Pro X3D 대원씨티에스
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-26', 'ASRock B650M Pro X3D 대원씨티에스', 'AM5', 'B650', 'M-ATX', 244, 244, 1, null, 'DDR5', '{"pcie_note": "PCIe5.0, PCIe4.0"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;

-- mb-27: ASUS PRIME B650EM-A 대원씨티에스
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-27', 'ASUS PRIME B650EM-A 대원씨티에스', 'AM5', 'B650', 'M-ATX', 244, 244, 1, null, 'DDR5', '{"pcie_note": "PCIe5.0, PCIe4.0"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;

-- mb-28: ASUS TUF Gaming B650EM-E WIFI STCOM
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-28', 'ASUS TUF Gaming B650EM-E WIFI STCOM', 'AM5', 'B650', 'M-ATX', 244, 244, 1, null, 'DDR5', '{"pcie_note": "PCIe5.0, PCIe4.0"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;

-- mb-29: GIGABYTE B650E AORUS ELITE X AX ICE 피씨디렉트
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-29', 'GIGABYTE B650E AORUS ELITE X AX ICE 피씨디렉트', 'AM5', 'B650E', 'ATX', 305, 244, 1, null, 'DDR5', '{"pcie_note": "PCIe5.0, PCIe3.0"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;

-- mb-30: ASRock B650M PG Lightning 에즈윈
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-30', 'ASRock B650M PG Lightning 에즈윈', 'AM5', 'B650', 'M-ATX', 244, 244, 1, null, 'DDR5', '{"pcie_note": "PCIe4.0, PCIe3.0"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;

-- mb-31: ASRock B650M Pro X3D 에즈윈
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-31', 'ASRock B650M Pro X3D 에즈윈', 'AM5', 'B650', 'M-ATX', 244, 244, 1, null, 'DDR5', '{"pcie_note": "PCIe5.0, PCIe4.0"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;

-- mb-32: COLORFUL BATTLE-AX B650M-PLUS V14 STCOM
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-32', 'COLORFUL BATTLE-AX B650M-PLUS V14 STCOM', 'AM5', 'B650', 'M-ATX', 244, 244, 1, null, 'DDR5', '{"pcie_note": "PCIe5.0, PCIe4.0"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;

-- mb-33: MSI PRO B650M-P
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-33', 'MSI PRO B650M-P', 'AM5', 'B650', 'M-ATX', 244, 244, 1, null, 'DDR5', '{"pcie_note": "PCIe4.0, PCIe3.0(x1 슬롯 2개), PCIex16 개수 스펙 미기재라 VGA연결단자 기준 1개로 추정"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;

-- mb-34: ASRock B650M PG Lightning 디앤디컴
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-34', 'ASRock B650M PG Lightning 디앤디컴', 'AM5', 'B650', 'M-ATX', 244, 244, 1, null, 'DDR5', '{"pcie_note": "PCIe4.0, PCIe3.0"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;

-- mb-35: ASRock B650M Pro X3D 디앤디컴
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-35', 'ASRock B650M Pro X3D 디앤디컴', 'AM5', 'B650', 'M-ATX', 244, 244, 1, null, 'DDR5', '{"pcie_note": "PCIe5.0, PCIe4.0"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;

-- mb-36: ASRock B650M PG Lightning 대원씨티에스
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-36', 'ASRock B650M PG Lightning 대원씨티에스', 'AM5', 'B650', 'M-ATX', 244, 244, 1, null, 'DDR5', '{"pcie_note": "PCIe4.0, PCIe3.0"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;

-- mb-37: GIGABYTE B650 AORUS ELITE AX V2 피씨디렉트
INSERT INTO motherboard (id, model, socket, chipset, form_factor, width_mm, depth_mm, pcie_x16_usable_slots, pcie_x16_total_slots, memory_type, extra)
VALUES ('mb-37', 'GIGABYTE B650 AORUS ELITE AX V2 피씨디렉트', 'AM5', 'B650', 'ATX', 305, 244, 1, null, 'DDR5', '{"pcie_note": "PCIe4.0, PCIe3.0"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  socket = EXCLUDED.socket,
  chipset = EXCLUDED.chipset,
  form_factor = EXCLUDED.form_factor,
  width_mm = EXCLUDED.width_mm,
  depth_mm = EXCLUDED.depth_mm,
  pcie_x16_usable_slots = EXCLUDED.pcie_x16_usable_slots,
  pcie_x16_total_slots = EXCLUDED.pcie_x16_total_slots,
  memory_type = EXCLUDED.memory_type,
  extra = EXCLUDED.extra;


-- ============ ram 추가 (danawa) ============

-- ram-11: TeamGroup DDR5-5600 CL46 Elite 서린 (16GB)
INSERT INTO ram (id, type, model, speed_mhz, heatsink_height_mm, voltage_v, extra)
VALUES ('ram-11', 'DDR5', 'TeamGroup DDR5-5600 CL46 Elite 서린 (16GB)', 5600, 32, 1.1, '{"capacity_gb": 16}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  model = EXCLUDED.model,
  speed_mhz = EXCLUDED.speed_mhz,
  heatsink_height_mm = EXCLUDED.heatsink_height_mm,
  voltage_v = EXCLUDED.voltage_v,
  extra = EXCLUDED.extra;

-- ram-12: ESSENCORE KLEVV DDR5-6000 CL30 CRAS V RGB WHITE 패키지 서린 (32GB(16Gx2))
INSERT INTO ram (id, type, model, speed_mhz, heatsink_height_mm, voltage_v, extra)
VALUES ('ram-12', 'DDR5', 'ESSENCORE KLEVV DDR5-6000 CL30 CRAS V RGB WHITE 패키지 서린 (32GB(16Gx2))', 6000, 44, 1.35, '{"capacity_gb": 32}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  model = EXCLUDED.model,
  speed_mhz = EXCLUDED.speed_mhz,
  heatsink_height_mm = EXCLUDED.heatsink_height_mm,
  voltage_v = EXCLUDED.voltage_v,
  extra = EXCLUDED.extra;

-- ram-13: 삼성전자 DDR5-5600 (16GB)
INSERT INTO ram (id, type, model, speed_mhz, heatsink_height_mm, voltage_v, extra)
VALUES ('ram-13', 'DDR5', '삼성전자 DDR5-5600 (16GB)', 5600, null, null, '{"capacity_gb": 16}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  model = EXCLUDED.model,
  speed_mhz = EXCLUDED.speed_mhz,
  heatsink_height_mm = EXCLUDED.heatsink_height_mm,
  voltage_v = EXCLUDED.voltage_v,
  extra = EXCLUDED.extra;

-- ram-14: ESSENCORE KLEVV DDR5-6000 CL30 FIT V 패키지 서린 (32GB(16Gx2))
INSERT INTO ram (id, type, model, speed_mhz, heatsink_height_mm, voltage_v, extra)
VALUES ('ram-14', 'DDR5', 'ESSENCORE KLEVV DDR5-6000 CL30 FIT V 패키지 서린 (32GB(16Gx2))', 6000, 33.21, 1.35, '{"capacity_gb": 32}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  model = EXCLUDED.model,
  speed_mhz = EXCLUDED.speed_mhz,
  heatsink_height_mm = EXCLUDED.heatsink_height_mm,
  voltage_v = EXCLUDED.voltage_v,
  extra = EXCLUDED.extra;

-- ram-15: PATRIOT DDR5-6000 CL30 SIGNATURE PREMIUM EVO 화이트 (16GB)
INSERT INTO ram (id, type, model, speed_mhz, heatsink_height_mm, voltage_v, extra)
VALUES ('ram-15', 'DDR5', 'PATRIOT DDR5-6000 CL30 SIGNATURE PREMIUM EVO 화이트 (16GB)', 6000, 37, 1.35, '{"capacity_gb": 16}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  model = EXCLUDED.model,
  speed_mhz = EXCLUDED.speed_mhz,
  heatsink_height_mm = EXCLUDED.heatsink_height_mm,
  voltage_v = EXCLUDED.voltage_v,
  extra = EXCLUDED.extra;

-- ram-16: G.SKILL DDR5-6000 CL36 TRIDENT Z5 NEO RGB J 패키지 (32GB(16Gx2))
INSERT INTO ram (id, type, model, speed_mhz, heatsink_height_mm, voltage_v, extra)
VALUES ('ram-16', 'DDR5', 'G.SKILL DDR5-6000 CL36 TRIDENT Z5 NEO RGB J 패키지 (32GB(16Gx2))', 6000, 44, 1.35, '{"capacity_gb": 32}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  model = EXCLUDED.model,
  speed_mhz = EXCLUDED.speed_mhz,
  heatsink_height_mm = EXCLUDED.heatsink_height_mm,
  voltage_v = EXCLUDED.voltage_v,
  extra = EXCLUDED.extra;

-- ram-17: PATRIOT DDR5-6000 CL30 SIGNATURE PREMIUM EVO 블랙 (16GB)
INSERT INTO ram (id, type, model, speed_mhz, heatsink_height_mm, voltage_v, extra)
VALUES ('ram-17', 'DDR5', 'PATRIOT DDR5-6000 CL30 SIGNATURE PREMIUM EVO 블랙 (16GB)', 6000, 37, 1.35, '{"capacity_gb": 16}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  model = EXCLUDED.model,
  speed_mhz = EXCLUDED.speed_mhz,
  heatsink_height_mm = EXCLUDED.heatsink_height_mm,
  voltage_v = EXCLUDED.voltage_v,
  extra = EXCLUDED.extra;

-- ram-18: GeIL DDR5-6000 CL38 GEMINI RGB White 패키지 (32GB(16Gx2))
INSERT INTO ram (id, type, model, speed_mhz, heatsink_height_mm, voltage_v, extra)
VALUES ('ram-18', 'DDR5', 'GeIL DDR5-6000 CL38 GEMINI RGB White 패키지 (32GB(16Gx2))', 6000, 45.1, 1.35, '{"capacity_gb": 32}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  model = EXCLUDED.model,
  speed_mhz = EXCLUDED.speed_mhz,
  heatsink_height_mm = EXCLUDED.heatsink_height_mm,
  voltage_v = EXCLUDED.voltage_v,
  extra = EXCLUDED.extra;

-- ram-19: 삼성전자 DDR5-6400 CL52 CUDIMM (16GB)
INSERT INTO ram (id, type, model, speed_mhz, heatsink_height_mm, voltage_v, extra)
VALUES ('ram-19', 'DDR5', '삼성전자 DDR5-6400 CL52 CUDIMM (16GB)', 6400, null, 1.1, '{"capacity_gb": 16}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  model = EXCLUDED.model,
  speed_mhz = EXCLUDED.speed_mhz,
  heatsink_height_mm = EXCLUDED.heatsink_height_mm,
  voltage_v = EXCLUDED.voltage_v,
  extra = EXCLUDED.extra;

-- ram-20: 삼성전자 노트북 DDR5-5600 (16GB)
INSERT INTO ram (id, type, model, speed_mhz, heatsink_height_mm, voltage_v, extra)
VALUES ('ram-20', 'DDR5', '삼성전자 노트북 DDR5-5600 (16GB)', 5600, null, null, '{"capacity_gb": 16}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  model = EXCLUDED.model,
  speed_mhz = EXCLUDED.speed_mhz,
  heatsink_height_mm = EXCLUDED.heatsink_height_mm,
  voltage_v = EXCLUDED.voltage_v,
  extra = EXCLUDED.extra;

-- ram-21: ESSENCORE KLEVV DDR5-6000 CL30 BOLT V 패키지 서린 (32GB(16Gx2))
INSERT INTO ram (id, type, model, speed_mhz, heatsink_height_mm, voltage_v, extra)
VALUES ('ram-21', 'DDR5', 'ESSENCORE KLEVV DDR5-6000 CL30 BOLT V 패키지 서린 (32GB(16Gx2))', 6000, 34, 1.35, '{"capacity_gb": 32}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  model = EXCLUDED.model,
  speed_mhz = EXCLUDED.speed_mhz,
  heatsink_height_mm = EXCLUDED.heatsink_height_mm,
  voltage_v = EXCLUDED.voltage_v,
  extra = EXCLUDED.extra;

-- ram-22: AGI DDR5-6000 CL30 TURBOJET UD858 RGB 블랙 패키지 서린 (32GB(16Gx2))
INSERT INTO ram (id, type, model, speed_mhz, heatsink_height_mm, voltage_v, extra)
VALUES ('ram-22', 'DDR5', 'AGI DDR5-6000 CL30 TURBOJET UD858 RGB 블랙 패키지 서린 (32GB(16Gx2))', 6000, 37, 1.35, '{"capacity_gb": 32}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  model = EXCLUDED.model,
  speed_mhz = EXCLUDED.speed_mhz,
  heatsink_height_mm = EXCLUDED.heatsink_height_mm,
  voltage_v = EXCLUDED.voltage_v,
  extra = EXCLUDED.extra;

-- ram-23: ESSENCORE KLEVV DDR5-6400 CL30 FIT V WHITE 패키지 서린 (32GB(16Gx2))
INSERT INTO ram (id, type, model, speed_mhz, heatsink_height_mm, voltage_v, extra)
VALUES ('ram-23', 'DDR5', 'ESSENCORE KLEVV DDR5-6400 CL30 FIT V WHITE 패키지 서린 (32GB(16Gx2))', 6400, 33.21, 1.4, '{"capacity_gb": 32}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  model = EXCLUDED.model,
  speed_mhz = EXCLUDED.speed_mhz,
  heatsink_height_mm = EXCLUDED.heatsink_height_mm,
  voltage_v = EXCLUDED.voltage_v,
  extra = EXCLUDED.extra;

-- ram-24: OLOy DDR5-5600 CL40 BLADE RGB BLACK 패키지 올로코리아 (32GB(16Gx2))
INSERT INTO ram (id, type, model, speed_mhz, heatsink_height_mm, voltage_v, extra)
VALUES ('ram-24', 'DDR5', 'OLOy DDR5-5600 CL40 BLADE RGB BLACK 패키지 올로코리아 (32GB(16Gx2))', 5600, 39, 1.25, '{"capacity_gb": 32}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  model = EXCLUDED.model,
  speed_mhz = EXCLUDED.speed_mhz,
  heatsink_height_mm = EXCLUDED.heatsink_height_mm,
  voltage_v = EXCLUDED.voltage_v,
  extra = EXCLUDED.extra;

-- ram-25: ESSENCORE KLEVV DDR5-6000 CL30 FIT V WHITE 패키지 서린 (32GB(16Gx2))
INSERT INTO ram (id, type, model, speed_mhz, heatsink_height_mm, voltage_v, extra)
VALUES ('ram-25', 'DDR5', 'ESSENCORE KLEVV DDR5-6000 CL30 FIT V WHITE 패키지 서린 (32GB(16Gx2))', 6000, 33.21, 1.35, '{"capacity_gb": 32}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  model = EXCLUDED.model,
  speed_mhz = EXCLUDED.speed_mhz,
  heatsink_height_mm = EXCLUDED.heatsink_height_mm,
  voltage_v = EXCLUDED.voltage_v,
  extra = EXCLUDED.extra;

-- ram-26: GeIL DDR5-5600 CL46 PRISTINE V (16GB)
INSERT INTO ram (id, type, model, speed_mhz, heatsink_height_mm, voltage_v, extra)
VALUES ('ram-26', 'DDR5', 'GeIL DDR5-5600 CL46 PRISTINE V (16GB)', 5600, 31.3, 1.1, '{"capacity_gb": 16}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  model = EXCLUDED.model,
  speed_mhz = EXCLUDED.speed_mhz,
  heatsink_height_mm = EXCLUDED.heatsink_height_mm,
  voltage_v = EXCLUDED.voltage_v,
  extra = EXCLUDED.extra;

-- ram-27: Apacer DDR5-5600 CL46 (16GB)
INSERT INTO ram (id, type, model, speed_mhz, heatsink_height_mm, voltage_v, extra)
VALUES ('ram-27', 'DDR5', 'Apacer DDR5-5600 CL46 (16GB)', 5600, 32, 1.1, '{"capacity_gb": 16}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  model = EXCLUDED.model,
  speed_mhz = EXCLUDED.speed_mhz,
  heatsink_height_mm = EXCLUDED.heatsink_height_mm,
  voltage_v = EXCLUDED.voltage_v,
  extra = EXCLUDED.extra;


-- ============ ssd 추가 (danawa) ============

-- ssd-25: ESSENCORE KLEVV CRAS C910G M.2 NVMe (1TB)
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-25', 'ESSENCORE KLEVV CRAS C910G M.2 NVMe (1TB)', 'M.2 NVMe', 'PCIe4.0x4')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-26: 삼성전자 990 PRO M.2 NVMe (1TB)
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-26', '삼성전자 990 PRO M.2 NVMe (1TB)', 'M.2 NVMe', 'PCIe4.0x4')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-27: ADATA LEGEND 900 M.2 NVMe 파인인포 (512GB)
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-27', 'ADATA LEGEND 900 M.2 NVMe 파인인포 (512GB)', 'M.2 NVMe', 'PCIe4.0x4')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-28: Western Digital WD BLACK SN850X M.2 NVMe (1TB)
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-28', 'Western Digital WD BLACK SN850X M.2 NVMe (1TB)', 'M.2 NVMe', 'PCIe4.0x4')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-29: SK하이닉스 Gold P31 M.2 NVMe (1TB)
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-29', 'SK하이닉스 Gold P31 M.2 NVMe (1TB)', 'M.2 NVMe', 'PCIe3.0x4')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-30: 삼성전자 990 EVO Plus M.2 NVMe (1TB)
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-30', '삼성전자 990 EVO Plus M.2 NVMe (1TB)', 'M.2 NVMe', 'PCIe4.0x4')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-31: 마이크론 Crucial P310 M.2 NVMe 대원씨티에스 (1TB)
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-31', '마이크론 Crucial P310 M.2 NVMe 대원씨티에스 (1TB)', 'M.2 NVMe', 'PCIe4.0x4')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-32: 삼성전자 PM9A1 M.2 NVMe 벌크 (512GB)
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-32', '삼성전자 PM9A1 M.2 NVMe 벌크 (512GB)', 'M.2 NVMe', 'PCIe4.0x4')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-33: SK하이닉스 Platinum P41 M.2 NVMe (1TB)
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-33', 'SK하이닉스 Platinum P41 M.2 NVMe (1TB)', 'M.2 NVMe', 'PCIe4.0x4')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-34: Western Digital WD Blue SN5000 M.2 NVMe (2TB)
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-34', 'Western Digital WD Blue SN5000 M.2 NVMe (2TB)', 'M.2 NVMe', 'PCIe4.0x4')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-35: 화웨이 eKitStor Xtreme 201 M.2 NVMe (1TB)
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-35', '화웨이 eKitStor Xtreme 201 M.2 NVMe (1TB)', 'M.2 NVMe', 'PCIe4.0x4')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-36: 키오시아 EXCERIA PLUS G4 M.2 NVMe (1TB)
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-36', '키오시아 EXCERIA PLUS G4 M.2 NVMe (1TB)', 'M.2 NVMe', 'PCIe5.0x4')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-37: SK하이닉스 Platinum P51 M.2 NVMe (2TB)
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-37', 'SK하이닉스 Platinum P51 M.2 NVMe (2TB)', 'M.2 NVMe', 'PCIe5.0x4')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-38: 삼성전자 9100 PRO M.2 NVMe (1TB)
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-38', '삼성전자 9100 PRO M.2 NVMe (1TB)', 'M.2 NVMe', 'PCIe5.0x4')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-39: 타무즈 M740Q M.2 NVMe 벌크 (512GB)
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-39', '타무즈 M740Q M.2 NVMe 벌크 (512GB)', 'M.2 NVMe', 'PCIe3.0x4')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-40: 삼성전자 PM981a M.2 NVMe 중고 (512GB)
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-40', '삼성전자 PM981a M.2 NVMe 중고 (512GB)', 'M.2 NVMe', 'PCIe3.0x4')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-41: Sandisk Optimus GX PRO 8100 M.2 NVMe (1TB)
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-41', 'Sandisk Optimus GX PRO 8100 M.2 NVMe (1TB)', 'M.2 NVMe', 'PCIe5.0x4')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-42: Seagate 파이어쿠다 X1070 M.2 NVMe (1TB)
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-42', 'Seagate 파이어쿠다 X1070 M.2 NVMe (1TB)', 'M.2 NVMe', 'PCIe4.0x4')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-43: 키오시아 EXCERIA 히트싱크 M.2 NVMe (2TB)
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-43', '키오시아 EXCERIA 히트싱크 M.2 NVMe (2TB)', 'M.2 NVMe', 'PCIe4.0x4')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;

-- ssd-44: 삼성전자 PM9C1 M.2 NVMe 벌크 (256GB)
INSERT INTO ssd (id, model, type, interface)
VALUES ('ssd-44', '삼성전자 PM9C1 M.2 NVMe 벌크 (256GB)', 'M.2 NVMe', 'PCIe4.0x4')
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  interface = EXCLUDED.interface;


-- ============ gpu 추가 (danawa) ============

-- gpu-25: MSI 지포스 RTX 5070 게이밍 트리오 OC D7 12GB 트라이프로져4
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-25', 'RTX50', 'MSI 지포스 RTX 5070 게이밍 트리오 OC D7 12GB 트라이프로져4', 12, 250, '16핀(12V2x6) x1', 650, 338, '3슬롯(50mm)', 3, true, '{"source": "danawa"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-26: ZOTAC GAMING 지포스 RTX 5070 SOLID OC D7 12GB
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-26', 'RTX50', 'ZOTAC GAMING 지포스 RTX 5070 SOLID OC D7 12GB', 12, 250, '16핀(12V2x6) x1', 650, 304.4, '3슬롯(41.6mm)', 3, true, '{"source": "danawa"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-27: MSI 지포스 RTX 5070 Ti 게이밍 트리오 OC D7 16GB 트라이프로져4
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-27', 'RTX50', 'MSI 지포스 RTX 5070 Ti 게이밍 트리오 OC D7 16GB 트라이프로져4', 16, 300, '16핀(12V2x6) x1', 750, 338, '3슬롯(50mm)', 3, true, '{"source": "danawa"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-28: ZOTAC GAMING 지포스 RTX 5070 Ti SOLID OC D7 16GB
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-28', 'RTX50', 'ZOTAC GAMING 지포스 RTX 5070 Ti SOLID OC D7 16GB', 16, 300, '16핀(12V2x6) x1', 750, 329.7, '3슬롯(67.8mm)', 3, true, '{"source": "danawa"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-29: PALIT 지포스 RTX 5070 Ti GAMINGPRO-S D7 16GB 이엠텍
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-29', 'RTX50', 'PALIT 지포스 RTX 5070 Ti GAMINGPRO-S D7 16GB 이엠텍', 16, 300, '16핀(12V2x6) x1', 750, 331.9, '3슬롯(49.7mm)', 3, true, '{"source": "danawa"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-30: ZOTAC GAMING 지포스 RTX 5070 Ti SOLID CORE OC White D7 16GB
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-30', 'RTX50', 'ZOTAC GAMING 지포스 RTX 5070 Ti SOLID CORE OC White D7 16GB', 16, 300, '16핀(12V2x6) x1', 750, 303.5, '3슬롯(55.7mm)', 3, true, '{"source": "danawa"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-31: GIGABYTE 지포스 RTX 5070 GAMING OC D7 12GB 제이씨현
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-31', 'RTX50', 'GIGABYTE 지포스 RTX 5070 GAMING OC D7 12GB 제이씨현', 12, null, '16핀(12V2x6) x1', 750, 327, '3슬롯(56mm)', 3, true, '{"source": "danawa"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-32: GIGABYTE 지포스 RTX 5070 Ti WINDFORCE OC SFF D7 16GB 피씨디렉트
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-32', 'RTX50', 'GIGABYTE 지포스 RTX 5070 Ti WINDFORCE OC SFF D7 16GB 피씨디렉트', 16, null, '16핀(12V2x6) x1', 750, 304, '3슬롯(50mm)', 3, true, '{"source": "danawa"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-33: PALIT 지포스 RTX 5070 INFINITY 3 D7 12GB 이엠텍
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-33', 'RTX50', 'PALIT 지포스 RTX 5070 INFINITY 3 D7 12GB 이엠텍', 12, 250, '16핀(12V2x6) x1', 650, 291.9, '3슬롯(41.3mm)', 3, true, '{"source": "danawa"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-34: 갤럭시 GALAX 지포스 RTX 5070 Ti EX GAMER WHITE OC D7 16GB
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-34', 'RTX50', '갤럭시 GALAX 지포스 RTX 5070 Ti EX GAMER WHITE OC D7 16GB', 16, 300, '16핀(12V2x6) x1', 750, 322, '3슬롯(52mm)', 3, true, '{"source": "danawa"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-35: MSI 지포스 RTX 5070 벤투스 2X OC D7 12GB
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-35', 'RTX50', 'MSI 지포스 RTX 5070 벤투스 2X OC D7 12GB', 12, 250, '16핀(12V2x6) x1', 650, 236, '2슬롯(50mm)', 2, true, '{"source": "danawa"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-36: ZOTAC GAMING 지포스 RTX 5070 Ti AMP Extreme Infinity D7 16GB
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-36', 'RTX50', 'ZOTAC GAMING 지포스 RTX 5070 Ti AMP Extreme Infinity D7 16GB', 16, 300, '16핀(12V2x6) x1', 750, 332.1, '3슬롯(69.6mm)', 3, true, '{"source": "danawa"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-37: ZOTAC GAMING 지포스 RTX 5070 Ti SOLID CORE OC D7 16GB
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-37', 'RTX50', 'ZOTAC GAMING 지포스 RTX 5070 Ti SOLID CORE OC D7 16GB', 16, 300, '16핀(12V2x6) x1', 750, 303.5, '3슬롯(55.7mm)', 3, true, '{"source": "danawa"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-38: 갤럭시 GALAX 지포스 RTX 5070 WHITE OC D7 12GB
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-38', 'RTX50', '갤럭시 GALAX 지포스 RTX 5070 WHITE OC D7 12GB', 12, 250, '16핀(12V2x6) x1', 650, 240, '2슬롯(39.6mm)', 2, true, '{"source": "danawa"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-39: 이엠텍 지포스 RTX 5070 MIRACLE WHITE D7 12GB
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-39', 'RTX50', '이엠텍 지포스 RTX 5070 MIRACLE WHITE D7 12GB', 12, null, '16핀(12V2x6) x1', 650, 329, '3슬롯(45mm)', 3, true, '{"source": "danawa"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-40: 갤럭시 GALAX 지포스 RTX 5070 Ti BLACK 2X OC D7 16GB
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-40', 'RTX50', '갤럭시 GALAX 지포스 RTX 5070 Ti BLACK 2X OC D7 16GB', 16, 300, '16핀(12V2x6) x1', 750, 239, '2슬롯(45mm)', 2, true, '{"source": "danawa"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-41: COLORFUL 지포스 RTX 5070 Ti 토마호크 EX D7 16GB 피씨디렉트
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-41', 'RTX50', 'COLORFUL 지포스 RTX 5070 Ti 토마호크 EX D7 16GB 피씨디렉트', 16, 300, '16핀(12V2x6) x1', 750, 330.6, '3슬롯(60mm)', 3, true, '{"source": "danawa"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-42: MSI 지포스 RTX 5070 쉐도우 2X OC D7 12GB
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-42', 'RTX50', 'MSI 지포스 RTX 5070 쉐도우 2X OC D7 12GB', 12, 250, '16핀(12V2x6) x1', 650, 231, '2슬롯(50mm)', 2, true, '{"source": "danawa"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;

-- gpu-43: PALIT 지포스 RTX 5070 WHITE OC D7 12GB 이엠텍
INSERT INTO gpu (id, series, model, vram_gb, tdp_w, connector, recommended_psu_w, length_mm, thickness, fans, verified, extra)
VALUES ('gpu-43', 'RTX50', 'PALIT 지포스 RTX 5070 WHITE OC D7 12GB 이엠텍', 12, 250, '16핀(12V2x6) x1', 650, 291, '3슬롯(41.3mm)', 3, true, '{"source": "danawa"}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  series = EXCLUDED.series,
  model = EXCLUDED.model,
  vram_gb = EXCLUDED.vram_gb,
  tdp_w = EXCLUDED.tdp_w,
  connector = EXCLUDED.connector,
  recommended_psu_w = EXCLUDED.recommended_psu_w,
  length_mm = EXCLUDED.length_mm,
  thickness = EXCLUDED.thickness,
  fans = EXCLUDED.fans,
  verified = EXCLUDED.verified,
  extra = EXCLUDED.extra;


-- ============ psu 추가 (danawa) ============

-- psu-13: 마이크로닉스 Classic II 750W 80PLUS골드 풀모듈러 ATX3.1
INSERT INTO psu (id, model, watt, grade, length_mm, atx_version, form_factor, extra)
VALUES ('psu-13', '마이크로닉스 Classic II 750W 80PLUS골드 풀모듈러 ATX3.1', 750, '골드', 140, 'ATX3.1', 'ATX', null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  watt = EXCLUDED.watt,
  grade = EXCLUDED.grade,
  length_mm = EXCLUDED.length_mm,
  atx_version = EXCLUDED.atx_version,
  form_factor = EXCLUDED.form_factor,
  extra = EXCLUDED.extra;

-- psu-14: 마이크로닉스 Classic II 풀체인지 750W 80PLUS스탠다드 ATX3.1
INSERT INTO psu (id, model, watt, grade, length_mm, atx_version, form_factor, extra)
VALUES ('psu-14', '마이크로닉스 Classic II 풀체인지 750W 80PLUS스탠다드 ATX3.1', 750, '스탠다드', 140, 'ATX3.1', 'ATX', null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  watt = EXCLUDED.watt,
  grade = EXCLUDED.grade,
  length_mm = EXCLUDED.length_mm,
  atx_version = EXCLUDED.atx_version,
  form_factor = EXCLUDED.form_factor,
  extra = EXCLUDED.extra;

-- psu-15: FSP VITA GD 750W 80PLUS골드 ATX3.1
INSERT INTO psu (id, model, watt, grade, length_mm, atx_version, form_factor, extra)
VALUES ('psu-15', 'FSP VITA GD 750W 80PLUS골드 ATX3.1', 750, '골드', 140, 'ATX3.1', 'ATX', null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  watt = EXCLUDED.watt,
  grade = EXCLUDED.grade,
  length_mm = EXCLUDED.length_mm,
  atx_version = EXCLUDED.atx_version,
  form_factor = EXCLUDED.form_factor,
  extra = EXCLUDED.extra;

-- psu-16: Antec GSK 750W V2 80PLUS골드 풀모듈러 ATX3.1
INSERT INTO psu (id, model, watt, grade, length_mm, atx_version, form_factor, extra)
VALUES ('psu-16', 'Antec GSK 750W V2 80PLUS골드 풀모듈러 ATX3.1', 750, '골드', 140, 'ATX3.1', 'ATX', null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  watt = EXCLUDED.watt,
  grade = EXCLUDED.grade,
  length_mm = EXCLUDED.length_mm,
  atx_version = EXCLUDED.atx_version,
  form_factor = EXCLUDED.form_factor,
  extra = EXCLUDED.extra;

-- psu-17: AONE 시그니처 750W 80PLUS브론즈 풀모듈러 베이직 ATX3.1
INSERT INTO psu (id, model, watt, grade, length_mm, atx_version, form_factor, extra)
VALUES ('psu-17', 'AONE 시그니처 750W 80PLUS브론즈 풀모듈러 베이직 ATX3.1', 750, '브론즈', 160, 'ATX3.1', 'ATX', null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  watt = EXCLUDED.watt,
  grade = EXCLUDED.grade,
  length_mm = EXCLUDED.length_mm,
  atx_version = EXCLUDED.atx_version,
  form_factor = EXCLUDED.form_factor,
  extra = EXCLUDED.extra;

-- psu-18: SuperFlower SF-750F14GE LEADEX III GOLD UP ATX3.1
INSERT INTO psu (id, model, watt, grade, length_mm, atx_version, form_factor, extra)
VALUES ('psu-18', 'SuperFlower SF-750F14GE LEADEX III GOLD UP ATX3.1', 750, '골드', 150, 'ATX3.1', 'ATX', null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  watt = EXCLUDED.watt,
  grade = EXCLUDED.grade,
  length_mm = EXCLUDED.length_mm,
  atx_version = EXCLUDED.atx_version,
  form_factor = EXCLUDED.form_factor,
  extra = EXCLUDED.extra;

-- psu-19: ASUS PRIME 750W Bronze
INSERT INTO psu (id, model, watt, grade, length_mm, atx_version, form_factor, extra)
VALUES ('psu-19', 'ASUS PRIME 750W Bronze', 750, '브론즈', 150, 'ATX12V', 'ATX', null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  watt = EXCLUDED.watt,
  grade = EXCLUDED.grade,
  length_mm = EXCLUDED.length_mm,
  atx_version = EXCLUDED.atx_version,
  form_factor = EXCLUDED.form_factor,
  extra = EXCLUDED.extra;

-- psu-20: MSI MAG A750GN 80PLUS골드 ATX3.1
INSERT INTO psu (id, model, watt, grade, length_mm, atx_version, form_factor, extra)
VALUES ('psu-20', 'MSI MAG A750GN 80PLUS골드 ATX3.1', 750, '골드', 140, 'ATX3.1', 'ATX', null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  watt = EXCLUDED.watt,
  grade = EXCLUDED.grade,
  length_mm = EXCLUDED.length_mm,
  atx_version = EXCLUDED.atx_version,
  form_factor = EXCLUDED.form_factor,
  extra = EXCLUDED.extra;

-- psu-21: 리안리 SP750 V2 80PLUS골드 블랙
INSERT INTO psu (id, model, watt, grade, length_mm, atx_version, form_factor, extra)
VALUES ('psu-21', '리안리 SP750 V2 80PLUS골드 블랙', 750, '골드', 100, 'ATX12V', 'ATX', null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  watt = EXCLUDED.watt,
  grade = EXCLUDED.grade,
  length_mm = EXCLUDED.length_mm,
  atx_version = EXCLUDED.atx_version,
  form_factor = EXCLUDED.form_factor,
  extra = EXCLUDED.extra;

-- psu-22: AONE 시그니처 750W 80PLUS골드 풀모듈러 ATX3.1 화이트
INSERT INTO psu (id, model, watt, grade, length_mm, atx_version, form_factor, extra)
VALUES ('psu-22', 'AONE 시그니처 750W 80PLUS골드 풀모듈러 ATX3.1 화이트', 750, '골드', 140, 'ATX3.1', 'ATX', null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  watt = EXCLUDED.watt,
  grade = EXCLUDED.grade,
  length_mm = EXCLUDED.length_mm,
  atx_version = EXCLUDED.atx_version,
  form_factor = EXCLUDED.form_factor,
  extra = EXCLUDED.extra;

-- psu-23: 마이크로닉스 Classic II 750W 80PLUS골드 풀모듈러 ATX3.1 화이트
INSERT INTO psu (id, model, watt, grade, length_mm, atx_version, form_factor, extra)
VALUES ('psu-23', '마이크로닉스 Classic II 750W 80PLUS골드 풀모듈러 ATX3.1 화이트', 750, '골드', 140, 'ATX3.1', 'ATX', null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  watt = EXCLUDED.watt,
  grade = EXCLUDED.grade,
  length_mm = EXCLUDED.length_mm,
  atx_version = EXCLUDED.atx_version,
  form_factor = EXCLUDED.form_factor,
  extra = EXCLUDED.extra;

-- psu-24: 마이크로닉스 Classic II 750W 80PLUS브론즈 230V EU HDB 핑크
INSERT INTO psu (id, model, watt, grade, length_mm, atx_version, form_factor, extra)
VALUES ('psu-24', '마이크로닉스 Classic II 750W 80PLUS브론즈 230V EU HDB 핑크', 750, '브론즈', 140, 'ATX12V', 'ATX', null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  watt = EXCLUDED.watt,
  grade = EXCLUDED.grade,
  length_mm = EXCLUDED.length_mm,
  atx_version = EXCLUDED.atx_version,
  form_factor = EXCLUDED.form_factor,
  extra = EXCLUDED.extra;

-- psu-25: AONE 시그니처 750W 80PLUS골드 풀모듈러 ATX3.1 블랙
INSERT INTO psu (id, model, watt, grade, length_mm, atx_version, form_factor, extra)
VALUES ('psu-25', 'AONE 시그니처 750W 80PLUS골드 풀모듈러 ATX3.1 블랙', 750, '골드', 140, 'ATX3.1', 'ATX', null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  watt = EXCLUDED.watt,
  grade = EXCLUDED.grade,
  length_mm = EXCLUDED.length_mm,
  atx_version = EXCLUDED.atx_version,
  form_factor = EXCLUDED.form_factor,
  extra = EXCLUDED.extra;

-- psu-26: GIGABYTE UD750GM PG5 V2 80PLUS골드 풀모듈러 ATX3.1 피씨디렉트
INSERT INTO psu (id, model, watt, grade, length_mm, atx_version, form_factor, extra)
VALUES ('psu-26', 'GIGABYTE UD750GM PG5 V2 80PLUS골드 풀모듈러 ATX3.1 피씨디렉트', 750, '골드', 140, 'ATX3.1', 'ATX', null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  watt = EXCLUDED.watt,
  grade = EXCLUDED.grade,
  length_mm = EXCLUDED.length_mm,
  atx_version = EXCLUDED.atx_version,
  form_factor = EXCLUDED.form_factor,
  extra = EXCLUDED.extra;

-- psu-27: SuperFlower SF-750C12FG COMBAT FG 80PLUS골드 ATX3.1
INSERT INTO psu (id, model, watt, grade, length_mm, atx_version, form_factor, extra)
VALUES ('psu-27', 'SuperFlower SF-750C12FG COMBAT FG 80PLUS골드 ATX3.1', 750, '골드', 140, 'ATX3.1', 'ATX', null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  watt = EXCLUDED.watt,
  grade = EXCLUDED.grade,
  length_mm = EXCLUDED.length_mm,
  atx_version = EXCLUDED.atx_version,
  form_factor = EXCLUDED.form_factor,
  extra = EXCLUDED.extra;

-- psu-28: 엔티스 EG 750W 80PLUS골드 풀모듈러 ATX3.1
INSERT INTO psu (id, model, watt, grade, length_mm, atx_version, form_factor, extra)
VALUES ('psu-28', '엔티스 EG 750W 80PLUS골드 풀모듈러 ATX3.1', 750, '골드', 140, 'ATX3.1', 'ATX', null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  watt = EXCLUDED.watt,
  grade = EXCLUDED.grade,
  length_mm = EXCLUDED.length_mm,
  atx_version = EXCLUDED.atx_version,
  form_factor = EXCLUDED.form_factor,
  extra = EXCLUDED.extra;


-- ============ pc_case 추가 (danawa) ============

-- case-13: darkFlash DPF70 ARGB (화이트)
INSERT INTO pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm)
VALUES ('case-13', 'darkFlash DPF70 ARGB (화이트)', '미들타워', 'ATX;M-ATX;ITX', 410, 160, '표준-ATX', '하단후면', '230', null, null, null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  tower_type = EXCLUDED.tower_type,
  supported_mb = EXCLUDED.supported_mb,
  gpu_max_length_mm = EXCLUDED.gpu_max_length_mm,
  cpu_cooler_max_height_mm = EXCLUDED.cpu_cooler_max_height_mm,
  psu_support = EXCLUDED.psu_support,
  psu_position = EXCLUDED.psu_position,
  psu_max_length_mm = EXCLUDED.psu_max_length_mm,
  radiator_top_mm = EXCLUDED.radiator_top_mm,
  radiator_front_mm = EXCLUDED.radiator_front_mm,
  radiator_side_mm = EXCLUDED.radiator_side_mm;

-- case-14: 잘만 N30 백사십 (블랙)
INSERT INTO pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm)
VALUES ('case-14', '잘만 N30 백사십 (블랙)', '미들타워', 'ATX;M-ATX;Mini-ITX', 430, 180, '표준-ATX', '하단후면', '200', null, null, null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  tower_type = EXCLUDED.tower_type,
  supported_mb = EXCLUDED.supported_mb,
  gpu_max_length_mm = EXCLUDED.gpu_max_length_mm,
  cpu_cooler_max_height_mm = EXCLUDED.cpu_cooler_max_height_mm,
  psu_support = EXCLUDED.psu_support,
  psu_position = EXCLUDED.psu_position,
  psu_max_length_mm = EXCLUDED.psu_max_length_mm,
  radiator_top_mm = EXCLUDED.radiator_top_mm,
  radiator_front_mm = EXCLUDED.radiator_front_mm,
  radiator_side_mm = EXCLUDED.radiator_side_mm;

-- case-15: 3RSYS L600 Quiet (블랙)
INSERT INTO pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm)
VALUES ('case-15', '3RSYS L600 Quiet (블랙)', '미들타워', 'E-ATX;ATX;M-ATX;ITX', 400, 180, '표준-ATX', '하단후면', '200', null, null, null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  tower_type = EXCLUDED.tower_type,
  supported_mb = EXCLUDED.supported_mb,
  gpu_max_length_mm = EXCLUDED.gpu_max_length_mm,
  cpu_cooler_max_height_mm = EXCLUDED.cpu_cooler_max_height_mm,
  psu_support = EXCLUDED.psu_support,
  psu_position = EXCLUDED.psu_position,
  psu_max_length_mm = EXCLUDED.psu_max_length_mm,
  radiator_top_mm = EXCLUDED.radiator_top_mm,
  radiator_front_mm = EXCLUDED.radiator_front_mm,
  radiator_side_mm = EXCLUDED.radiator_side_mm;

-- case-16: DAVEN AQUA 다이버 (블랙)
INSERT INTO pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm)
VALUES ('case-16', 'DAVEN AQUA 다이버 (블랙)', '미들타워', 'E-ATX;ATX;M-ATX;Mini-ITX', 400, 165, '표준-ATX', '하단후면', '220', null, null, null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  tower_type = EXCLUDED.tower_type,
  supported_mb = EXCLUDED.supported_mb,
  gpu_max_length_mm = EXCLUDED.gpu_max_length_mm,
  cpu_cooler_max_height_mm = EXCLUDED.cpu_cooler_max_height_mm,
  psu_support = EXCLUDED.psu_support,
  psu_position = EXCLUDED.psu_position,
  psu_max_length_mm = EXCLUDED.psu_max_length_mm,
  radiator_top_mm = EXCLUDED.radiator_top_mm,
  radiator_front_mm = EXCLUDED.radiator_front_mm,
  radiator_side_mm = EXCLUDED.radiator_side_mm;

-- case-17: 앱코 G31 오메가포스 세븐팬 (블랙)
INSERT INTO pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm)
VALUES ('case-17', '앱코 G31 오메가포스 세븐팬 (블랙)', '미들타워', 'ATX;M-ATX;Mini-ITX', 400, 165, '표준-ATX', '하단후면', '200', null, null, null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  tower_type = EXCLUDED.tower_type,
  supported_mb = EXCLUDED.supported_mb,
  gpu_max_length_mm = EXCLUDED.gpu_max_length_mm,
  cpu_cooler_max_height_mm = EXCLUDED.cpu_cooler_max_height_mm,
  psu_support = EXCLUDED.psu_support,
  psu_position = EXCLUDED.psu_position,
  psu_max_length_mm = EXCLUDED.psu_max_length_mm,
  radiator_top_mm = EXCLUDED.radiator_top_mm,
  radiator_front_mm = EXCLUDED.radiator_front_mm,
  radiator_side_mm = EXCLUDED.radiator_side_mm;

-- case-18: 오쓰 SOLID FULL MESH (블랙)
INSERT INTO pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm)
VALUES ('case-18', '오쓰 SOLID FULL MESH (블랙)', '미들타워', 'E-ATX;ATX;M-ATX;Mini-ITX', 390, 175, '표준-ATX', '하단후면', '200', null, null, null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  tower_type = EXCLUDED.tower_type,
  supported_mb = EXCLUDED.supported_mb,
  gpu_max_length_mm = EXCLUDED.gpu_max_length_mm,
  cpu_cooler_max_height_mm = EXCLUDED.cpu_cooler_max_height_mm,
  psu_support = EXCLUDED.psu_support,
  psu_position = EXCLUDED.psu_position,
  psu_max_length_mm = EXCLUDED.psu_max_length_mm,
  radiator_top_mm = EXCLUDED.radiator_top_mm,
  radiator_front_mm = EXCLUDED.radiator_front_mm,
  radiator_side_mm = EXCLUDED.radiator_side_mm;

-- case-19: 앱코 UD51L 엑시드 LCD 강화유리 ARGB BTF (블랙)
INSERT INTO pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm)
VALUES ('case-19', '앱코 UD51L 엑시드 LCD 강화유리 ARGB BTF (블랙)', '미들타워', 'ATX;ATX (후면커넥터);M-ATX;M-ATX (후면커넥터);ITX', 345, 160, '표준-ATX', '상단', '240', null, null, null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  tower_type = EXCLUDED.tower_type,
  supported_mb = EXCLUDED.supported_mb,
  gpu_max_length_mm = EXCLUDED.gpu_max_length_mm,
  cpu_cooler_max_height_mm = EXCLUDED.cpu_cooler_max_height_mm,
  psu_support = EXCLUDED.psu_support,
  psu_position = EXCLUDED.psu_position,
  psu_max_length_mm = EXCLUDED.psu_max_length_mm,
  radiator_top_mm = EXCLUDED.radiator_top_mm,
  radiator_front_mm = EXCLUDED.radiator_front_mm,
  radiator_side_mm = EXCLUDED.radiator_side_mm;

-- case-20: darkFlash DS900 ARGB 강화유리 (화이트)
INSERT INTO pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm)
VALUES ('case-20', 'darkFlash DS900 ARGB 강화유리 (화이트)', '미들타워', 'ATX;M-ATX;Mini-ITX', 425, 170, '표준-ATX', '하단후면', '260', null, null, null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  tower_type = EXCLUDED.tower_type,
  supported_mb = EXCLUDED.supported_mb,
  gpu_max_length_mm = EXCLUDED.gpu_max_length_mm,
  cpu_cooler_max_height_mm = EXCLUDED.cpu_cooler_max_height_mm,
  psu_support = EXCLUDED.psu_support,
  psu_position = EXCLUDED.psu_position,
  psu_max_length_mm = EXCLUDED.psu_max_length_mm,
  radiator_top_mm = EXCLUDED.radiator_top_mm,
  radiator_front_mm = EXCLUDED.radiator_front_mm,
  radiator_side_mm = EXCLUDED.radiator_side_mm;

-- case-21: darkFlash DLX21 RGB MESH 강화유리 (블랙)
INSERT INTO pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm)
VALUES ('case-21', 'darkFlash DLX21 RGB MESH 강화유리 (블랙)', '미들타워', 'E-ATX;ATX;M-ATX;Mini-ITX', 400, 180, '표준-ATX', '하단후면', '235', null, null, null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  tower_type = EXCLUDED.tower_type,
  supported_mb = EXCLUDED.supported_mb,
  gpu_max_length_mm = EXCLUDED.gpu_max_length_mm,
  cpu_cooler_max_height_mm = EXCLUDED.cpu_cooler_max_height_mm,
  psu_support = EXCLUDED.psu_support,
  psu_position = EXCLUDED.psu_position,
  psu_max_length_mm = EXCLUDED.psu_max_length_mm,
  radiator_top_mm = EXCLUDED.radiator_top_mm,
  radiator_front_mm = EXCLUDED.radiator_front_mm,
  radiator_side_mm = EXCLUDED.radiator_side_mm;

-- case-22: 마이크로닉스 WIZMAX 스텔라
INSERT INTO pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm)
VALUES ('case-22', '마이크로닉스 WIZMAX 스텔라', '미들타워', 'ATX;ATX (후면커넥터);M-ATX;M-ATX (후면커넥터);ITX', 425, 175, '표준-ATX', '상단', '160', null, null, null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  tower_type = EXCLUDED.tower_type,
  supported_mb = EXCLUDED.supported_mb,
  gpu_max_length_mm = EXCLUDED.gpu_max_length_mm,
  cpu_cooler_max_height_mm = EXCLUDED.cpu_cooler_max_height_mm,
  psu_support = EXCLUDED.psu_support,
  psu_position = EXCLUDED.psu_position,
  psu_max_length_mm = EXCLUDED.psu_max_length_mm,
  radiator_top_mm = EXCLUDED.radiator_top_mm,
  radiator_front_mm = EXCLUDED.radiator_front_mm,
  radiator_side_mm = EXCLUDED.radiator_side_mm;

-- case-23: 3RSYS R407 세븐팬 (블랙)
INSERT INTO pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm)
VALUES ('case-23', '3RSYS R407 세븐팬 (블랙)', '미들타워', 'ATX;M-ATX;ITX', 430, 170, '표준-ATX', '하단후면', '200', null, null, null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  tower_type = EXCLUDED.tower_type,
  supported_mb = EXCLUDED.supported_mb,
  gpu_max_length_mm = EXCLUDED.gpu_max_length_mm,
  cpu_cooler_max_height_mm = EXCLUDED.cpu_cooler_max_height_mm,
  psu_support = EXCLUDED.psu_support,
  psu_position = EXCLUDED.psu_position,
  psu_max_length_mm = EXCLUDED.psu_max_length_mm,
  radiator_top_mm = EXCLUDED.radiator_top_mm,
  radiator_front_mm = EXCLUDED.radiator_front_mm,
  radiator_side_mm = EXCLUDED.radiator_side_mm;

-- case-24: 앱코 U30 마린 (블랙)
INSERT INTO pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm)
VALUES ('case-24', '앱코 U30 마린 (블랙)', '미들타워', 'ATX;M-ATX;Mini-ITX', 400, 165, '표준-ATX', '하단후면', '240', null, null, null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  tower_type = EXCLUDED.tower_type,
  supported_mb = EXCLUDED.supported_mb,
  gpu_max_length_mm = EXCLUDED.gpu_max_length_mm,
  cpu_cooler_max_height_mm = EXCLUDED.cpu_cooler_max_height_mm,
  psu_support = EXCLUDED.psu_support,
  psu_position = EXCLUDED.psu_position,
  psu_max_length_mm = EXCLUDED.psu_max_length_mm,
  radiator_top_mm = EXCLUDED.radiator_top_mm,
  radiator_front_mm = EXCLUDED.radiator_front_mm,
  radiator_side_mm = EXCLUDED.radiator_side_mm;

-- case-25: 앱코 G50 빅플로우 MESH ARGB BTF (블랙)
INSERT INTO pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm)
VALUES ('case-25', '앱코 G50 빅플로우 MESH ARGB BTF (블랙)', '미들타워', 'E-ATX;ATX;ATX (후면커넥터);M-ATX;M-ATX (후면커넥터);Mini-ITX', 408, 180, '표준-ATX', '하단후면', '240', null, null, null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  tower_type = EXCLUDED.tower_type,
  supported_mb = EXCLUDED.supported_mb,
  gpu_max_length_mm = EXCLUDED.gpu_max_length_mm,
  cpu_cooler_max_height_mm = EXCLUDED.cpu_cooler_max_height_mm,
  psu_support = EXCLUDED.psu_support,
  psu_position = EXCLUDED.psu_position,
  psu_max_length_mm = EXCLUDED.psu_max_length_mm,
  radiator_top_mm = EXCLUDED.radiator_top_mm,
  radiator_front_mm = EXCLUDED.radiator_front_mm,
  radiator_side_mm = EXCLUDED.radiator_side_mm;

-- case-26: DAVEN 벤투스 420 MESH ARGB (블랙)
INSERT INTO pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm)
VALUES ('case-26', 'DAVEN 벤투스 420 MESH ARGB (블랙)', '미들타워', 'ATX;ATX (후면커넥터);M-ATX;M-ATX (후면커넥터);Mini-ITX', 395, 175, '표준-ATX', '하단후면', '220', null, null, null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  tower_type = EXCLUDED.tower_type,
  supported_mb = EXCLUDED.supported_mb,
  gpu_max_length_mm = EXCLUDED.gpu_max_length_mm,
  cpu_cooler_max_height_mm = EXCLUDED.cpu_cooler_max_height_mm,
  psu_support = EXCLUDED.psu_support,
  psu_position = EXCLUDED.psu_position,
  psu_max_length_mm = EXCLUDED.psu_max_length_mm,
  radiator_top_mm = EXCLUDED.radiator_top_mm,
  radiator_front_mm = EXCLUDED.radiator_front_mm,
  radiator_side_mm = EXCLUDED.radiator_side_mm;

-- case-27: 앱코 UD51 엑시드 ARGB BTF (블랙)
INSERT INTO pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm)
VALUES ('case-27', '앱코 UD51 엑시드 ARGB BTF (블랙)', '미들타워', 'E-ATX;ATX;ATX (후면커넥터);M-ATX;M-ATX (후면커넥터);Mini-ITX', 400, 160, '표준-ATX', '상단', '240', null, null, null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  tower_type = EXCLUDED.tower_type,
  supported_mb = EXCLUDED.supported_mb,
  gpu_max_length_mm = EXCLUDED.gpu_max_length_mm,
  cpu_cooler_max_height_mm = EXCLUDED.cpu_cooler_max_height_mm,
  psu_support = EXCLUDED.psu_support,
  psu_position = EXCLUDED.psu_position,
  psu_max_length_mm = EXCLUDED.psu_max_length_mm,
  radiator_top_mm = EXCLUDED.radiator_top_mm,
  radiator_front_mm = EXCLUDED.radiator_front_mm,
  radiator_side_mm = EXCLUDED.radiator_side_mm;

-- case-28: MSI MAG PANO 100L 프로젝트 제로 (블랙)
INSERT INTO pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm)
VALUES ('case-28', 'MSI MAG PANO 100L 프로젝트 제로 (블랙)', '미들타워', 'ATX;ATX (후면커넥터);M-ATX;M-ATX (후면커넥터);Mini-ITX', 380, 166, '표준-ATX', '하단후면', '200', null, null, null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  tower_type = EXCLUDED.tower_type,
  supported_mb = EXCLUDED.supported_mb,
  gpu_max_length_mm = EXCLUDED.gpu_max_length_mm,
  cpu_cooler_max_height_mm = EXCLUDED.cpu_cooler_max_height_mm,
  psu_support = EXCLUDED.psu_support,
  psu_position = EXCLUDED.psu_position,
  psu_max_length_mm = EXCLUDED.psu_max_length_mm,
  radiator_top_mm = EXCLUDED.radiator_top_mm,
  radiator_front_mm = EXCLUDED.radiator_front_mm,
  radiator_side_mm = EXCLUDED.radiator_side_mm;

-- case-29: 앱코 UD50C 루시드 앰비언트 풀커브드 ARGB BTF (블랙)
INSERT INTO pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm)
VALUES ('case-29', '앱코 UD50C 루시드 앰비언트 풀커브드 ARGB BTF (블랙)', '미들타워', 'ATX;ATX (후면커넥터);M-ATX;M-ATX (후면커넥터);Mini-ITX', 420, 160, '표준-ATX', '상단', '210', null, null, null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  tower_type = EXCLUDED.tower_type,
  supported_mb = EXCLUDED.supported_mb,
  gpu_max_length_mm = EXCLUDED.gpu_max_length_mm,
  cpu_cooler_max_height_mm = EXCLUDED.cpu_cooler_max_height_mm,
  psu_support = EXCLUDED.psu_support,
  psu_position = EXCLUDED.psu_position,
  psu_max_length_mm = EXCLUDED.psu_max_length_mm,
  radiator_top_mm = EXCLUDED.radiator_top_mm,
  radiator_front_mm = EXCLUDED.radiator_front_mm,
  radiator_side_mm = EXCLUDED.radiator_side_mm;

-- case-30: 1stPlayer AU8 빅포 ARGB (블랙)
INSERT INTO pc_case (id, model, tower_type, supported_mb, gpu_max_length_mm, cpu_cooler_max_height_mm, psu_support, psu_position, psu_max_length_mm, radiator_top_mm, radiator_front_mm, radiator_side_mm)
VALUES ('case-30', '1stPlayer AU8 빅포 ARGB (블랙)', '미들타워', 'ATX;M-ATX;ITX', 400, 174, '표준-ATX', '하단후면', '240', null, null, null)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  tower_type = EXCLUDED.tower_type,
  supported_mb = EXCLUDED.supported_mb,
  gpu_max_length_mm = EXCLUDED.gpu_max_length_mm,
  cpu_cooler_max_height_mm = EXCLUDED.cpu_cooler_max_height_mm,
  psu_support = EXCLUDED.psu_support,
  psu_position = EXCLUDED.psu_position,
  psu_max_length_mm = EXCLUDED.psu_max_length_mm,
  radiator_top_mm = EXCLUDED.radiator_top_mm,
  radiator_front_mm = EXCLUDED.radiator_front_mm,
  radiator_side_mm = EXCLUDED.radiator_side_mm;


-- ============ cooler 추가 (danawa) ============

-- cooler-air-05: DEEPCOOL AG620 G2 (블랙)
INSERT INTO cooler (id, model, type, height_mm, radiator_size_mm, supported_sockets, extra)
VALUES ('cooler-air-05', 'DEEPCOOL AG620 G2 (블랙)', 'air', 159, null, 'LGA1851;LGA1700;AM5;AM4', '{"width_mm": 129, "depth_mm": 136, "fan_size_mm": 120, "fan_count": 2, "tdp_rated_w": 270}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  height_mm = EXCLUDED.height_mm,
  radiator_size_mm = EXCLUDED.radiator_size_mm,
  supported_sockets = EXCLUDED.supported_sockets,
  extra = EXCLUDED.extra;

-- cooler-air-06: PCCOOLER CPS RT620 PRO 카본스틸 (블랙)
INSERT INTO cooler (id, model, type, height_mm, radiator_size_mm, supported_sockets, extra)
VALUES ('cooler-air-06', 'PCCOOLER CPS RT620 PRO 카본스틸 (블랙)', 'air', 153, null, 'LGA1851;LGA1700;LGA1200;LGA115x;AM5;AM4', '{"width_mm": 125, "depth_mm": 138, "fan_size_mm": 120, "fan_count": 2, "tdp_rated_w": 265}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  height_mm = EXCLUDED.height_mm,
  radiator_size_mm = EXCLUDED.radiator_size_mm,
  supported_sockets = EXCLUDED.supported_sockets,
  extra = EXCLUDED.extra;

-- cooler-air-07: Thermalright Peerless Assassin 120 SE 서린
INSERT INTO cooler (id, model, type, height_mm, radiator_size_mm, supported_sockets, extra)
VALUES ('cooler-air-07', 'Thermalright Peerless Assassin 120 SE 서린', 'air', 155, null, 'LGA1700;LGA1200;LGA115x;AM5;AM4', '{"width_mm": 125, "depth_mm": 135, "fan_size_mm": 120, "fan_count": 2, "tdp_rated_w": 260}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  height_mm = EXCLUDED.height_mm,
  radiator_size_mm = EXCLUDED.radiator_size_mm,
  supported_sockets = EXCLUDED.supported_sockets,
  extra = EXCLUDED.extra;

-- cooler-air-08: PCCOOLER PALADIN 400 (블랙)
INSERT INTO cooler (id, model, type, height_mm, radiator_size_mm, supported_sockets, extra)
VALUES ('cooler-air-08', 'PCCOOLER PALADIN 400 (블랙)', 'air', 157, null, 'LGA1851;LGA1700;LGA1200;LGA115x;AM5;AM4', '{"width_mm": 130, "depth_mm": 76, "fan_size_mm": 130, "fan_count": 1, "tdp_rated_w": 235}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  height_mm = EXCLUDED.height_mm,
  radiator_size_mm = EXCLUDED.radiator_size_mm,
  supported_sockets = EXCLUDED.supported_sockets,
  extra = EXCLUDED.extra;

-- cooler-aio-05: 마이크로닉스 ICEROCK CL-360 (블랙)
INSERT INTO cooler (id, model, type, height_mm, radiator_size_mm, supported_sockets, extra)
VALUES ('cooler-aio-05', '마이크로닉스 ICEROCK CL-360 (블랙)', 'aqua', null, 360, 'LGA1851;LGA1700;LGA1200;LGA115x;AM5;AM4', '{"radiator_length_mm": 396, "radiator_thickness_mm": 27, "fan_size_mm": 120, "fan_count": 3, "tdp_rated_w": 310}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  height_mm = EXCLUDED.height_mm,
  radiator_size_mm = EXCLUDED.radiator_size_mm,
  supported_sockets = EXCLUDED.supported_sockets,
  extra = EXCLUDED.extra;

-- cooler-aio-06: darkFlash WAVE DV360S MAX ARGB 디스플레이 (블랙)
INSERT INTO cooler (id, model, type, height_mm, radiator_size_mm, supported_sockets, extra)
VALUES ('cooler-aio-06', 'darkFlash WAVE DV360S MAX ARGB 디스플레이 (블랙)', 'aqua', null, 360, 'LGA1700;LGA1200;LGA115x;LGA1851;AM4;AM5', '{"radiator_length_mm": 397, "radiator_thickness_mm": 27, "fan_size_mm": 123, "fan_count": 3, "tdp_rated_w": 320}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  height_mm = EXCLUDED.height_mm,
  radiator_size_mm = EXCLUDED.radiator_size_mm,
  supported_sockets = EXCLUDED.supported_sockets,
  extra = EXCLUDED.extra;

-- cooler-air-09: DEEPCOOL AG400 G2 (블랙)
INSERT INTO cooler (id, model, type, height_mm, radiator_size_mm, supported_sockets, extra)
VALUES ('cooler-air-09', 'DEEPCOOL AG400 G2 (블랙)', 'air', null, null, 'LGA1851;LGA1700;AM5;AM4', '{"width_mm": 125, "depth_mm": 92, "fan_size_mm": 120, "fan_count": 1, "tdp_rated_w": 230}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  height_mm = EXCLUDED.height_mm,
  radiator_size_mm = EXCLUDED.radiator_size_mm,
  supported_sockets = EXCLUDED.supported_sockets,
  extra = EXCLUDED.extra;

-- cooler-aio-07: 잘만 ALPHA II SE A36 (블랙)
INSERT INTO cooler (id, model, type, height_mm, radiator_size_mm, supported_sockets, extra)
VALUES ('cooler-aio-07', '잘만 ALPHA II SE A36 (블랙)', 'aqua', null, 360, 'LGA1851;LGA1200;LGA115x;LGA1700;AM5;AM4', '{"radiator_length_mm": 394, "radiator_thickness_mm": 27, "fan_size_mm": 120, "fan_count": 3, "tdp_rated_w": 350}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  height_mm = EXCLUDED.height_mm,
  radiator_size_mm = EXCLUDED.radiator_size_mm,
  supported_sockets = EXCLUDED.supported_sockets,
  extra = EXCLUDED.extra;

-- cooler-air-10: Thermalright Peerless Assassin 120 Digital ARGB 서린 (화이트)
INSERT INTO cooler (id, model, type, height_mm, radiator_size_mm, supported_sockets, extra)
VALUES ('cooler-air-10', 'Thermalright Peerless Assassin 120 Digital ARGB 서린 (화이트)', 'air', 162, null, 'LGA1851;LGA1700;LGA115x;LGA1200;AM4;AM5', '{"width_mm": 125, "depth_mm": 138, "fan_size_mm": 120, "fan_count": 2}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  height_mm = EXCLUDED.height_mm,
  radiator_size_mm = EXCLUDED.radiator_size_mm,
  supported_sockets = EXCLUDED.supported_sockets,
  extra = EXCLUDED.extra;

-- cooler-aio-08: DEEPCOOL LT360 VISION ARGB (블랙)
INSERT INTO cooler (id, model, type, height_mm, radiator_size_mm, supported_sockets, extra)
VALUES ('cooler-aio-08', 'DEEPCOOL LT360 VISION ARGB (블랙)', 'aqua', null, 360, 'LGA1851;LGA1700;LGA1200;LGA115x;AM5;AM4', '{"radiator_length_mm": 402, "radiator_thickness_mm": 27, "fan_size_mm": 120, "fan_count": 3, "tdp_rated_w": 300}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  height_mm = EXCLUDED.height_mm,
  radiator_size_mm = EXCLUDED.radiator_size_mm,
  supported_sockets = EXCLUDED.supported_sockets,
  extra = EXCLUDED.extra;

-- cooler-aio-09: 쿨러마스터 MasterLiquid 360 Atmos II Stealth (블랙)
INSERT INTO cooler (id, model, type, height_mm, radiator_size_mm, supported_sockets, extra)
VALUES ('cooler-aio-09', '쿨러마스터 MasterLiquid 360 Atmos II Stealth (블랙)', 'aqua', null, 360, 'LGA1851;LGA1700;LGA1200;LGA115x;AM5;AM4', '{"radiator_length_mm": 394, "radiator_thickness_mm": 29, "fan_size_mm": 120, "fan_count": 3, "tdp_rated_w": 330}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  height_mm = EXCLUDED.height_mm,
  radiator_size_mm = EXCLUDED.radiator_size_mm,
  supported_sockets = EXCLUDED.supported_sockets,
  extra = EXCLUDED.extra;

-- cooler-aio-10: MSI MAG 코어리퀴드 I360 (블랙)
INSERT INTO cooler (id, model, type, height_mm, radiator_size_mm, supported_sockets, extra)
VALUES ('cooler-aio-10', 'MSI MAG 코어리퀴드 I360 (블랙)', 'aqua', null, 360, 'LGA1851;LGA1700;LGA1200;LGA115x;AM5;AM4', '{"radiator_length_mm": 394, "radiator_thickness_mm": 27, "fan_size_mm": 120, "fan_count": 3}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  height_mm = EXCLUDED.height_mm,
  radiator_size_mm = EXCLUDED.radiator_size_mm,
  supported_sockets = EXCLUDED.supported_sockets,
  extra = EXCLUDED.extra;

-- cooler-air-11: 3RSYS Socoool RC1900N 솔더링 (블랙)
INSERT INTO cooler (id, model, type, height_mm, radiator_size_mm, supported_sockets, extra)
VALUES ('cooler-air-11', '3RSYS Socoool RC1900N 솔더링 (블랙)', 'air', 157, null, 'LGA1700;LGA1200;LGA1851;LGA115x;AM4;AM5', '{"width_mm": 132, "depth_mm": 140, "fan_size_mm": 130, "fan_count": 2, "tdp_rated_w": 280}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  height_mm = EXCLUDED.height_mm,
  radiator_size_mm = EXCLUDED.radiator_size_mm,
  supported_sockets = EXCLUDED.supported_sockets,
  extra = EXCLUDED.extra;

-- cooler-aio-11: darkFlash NEBULA DN-360D ARGB (화이트)
INSERT INTO cooler (id, model, type, height_mm, radiator_size_mm, supported_sockets, extra)
VALUES ('cooler-aio-11', 'darkFlash NEBULA DN-360D ARGB (화이트)', 'aqua', null, 360, 'LGA1700;LGA1200;LGA115x;AM5;AM4', '{"radiator_length_mm": 397, "radiator_thickness_mm": 27, "fan_size_mm": 120, "fan_count": 3, "tdp_rated_w": 310}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  height_mm = EXCLUDED.height_mm,
  radiator_size_mm = EXCLUDED.radiator_size_mm,
  supported_sockets = EXCLUDED.supported_sockets,
  extra = EXCLUDED.extra;

-- cooler-aio-12: 쿨러마스터 MASTERLIQUID 360 ATMOS II VRM Fan (블랙)
INSERT INTO cooler (id, model, type, height_mm, radiator_size_mm, supported_sockets, extra)
VALUES ('cooler-aio-12', '쿨러마스터 MASTERLIQUID 360 ATMOS II VRM Fan (블랙)', 'aqua', null, 360, 'LGA1851;LGA115x;LGA1200;LGA1700;AM5;AM4', '{"radiator_length_mm": 394, "radiator_thickness_mm": 27, "fan_size_mm": 120, "fan_count": 3}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  height_mm = EXCLUDED.height_mm,
  radiator_size_mm = EXCLUDED.radiator_size_mm,
  supported_sockets = EXCLUDED.supported_sockets,
  extra = EXCLUDED.extra;

-- cooler-aio-13: Thermalright WONDER VISION 360 UB ARGB (화이트)
INSERT INTO cooler (id, model, type, height_mm, radiator_size_mm, supported_sockets, extra)
VALUES ('cooler-aio-13', 'Thermalright WONDER VISION 360 UB ARGB (화이트)', 'aqua', null, 360, 'LGA2011;LGA1200;LGA2066;LGA1851;LGA1700;LGA115x;AM5;AM4', '{"radiator_length_mm": 403, "radiator_thickness_mm": 27, "fan_size_mm": 120, "fan_count": 3}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  height_mm = EXCLUDED.height_mm,
  radiator_size_mm = EXCLUDED.radiator_size_mm,
  supported_sockets = EXCLUDED.supported_sockets,
  extra = EXCLUDED.extra;

-- cooler-air-12: SNOWMAN AX660 PRO-ARGB 뚜까리6 (화이트)
INSERT INTO cooler (id, model, type, height_mm, radiator_size_mm, supported_sockets, extra)
VALUES ('cooler-air-12', 'SNOWMAN AX660 PRO-ARGB 뚜까리6 (화이트)', 'air', 162, null, 'LGA1851;LGA1700;LGA1200;LGA115x;LGA1366;AM5;AM4', '{"width_mm": 124, "depth_mm": 137, "fan_size_mm": 120, "fan_count": 2, "tdp_rated_w": 270}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  height_mm = EXCLUDED.height_mm,
  radiator_size_mm = EXCLUDED.radiator_size_mm,
  supported_sockets = EXCLUDED.supported_sockets,
  extra = EXCLUDED.extra;

-- cooler-air-13: DEEPCOOL ASSASSIN VC ELITE (블랙)
INSERT INTO cooler (id, model, type, height_mm, radiator_size_mm, supported_sockets, extra)
VALUES ('cooler-air-13', 'DEEPCOOL ASSASSIN VC ELITE (블랙)', 'air', 164, null, 'LGA2066;LGA1700;LGA2011-V3;LGA115x;LGA2011;LGA1851;LGA1200;AM5;AM4', '{"width_mm": 147, "depth_mm": 144, "fan_size_mm": 120, "fan_count": 2, "tdp_rated_w": 300}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  height_mm = EXCLUDED.height_mm,
  radiator_size_mm = EXCLUDED.radiator_size_mm,
  supported_sockets = EXCLUDED.supported_sockets,
  extra = EXCLUDED.extra;

-- cooler-aio-14: NZXT KRAKEN PLUS 360
INSERT INTO cooler (id, model, type, height_mm, radiator_size_mm, supported_sockets, extra)
VALUES ('cooler-aio-14', 'NZXT KRAKEN PLUS 360', 'aqua', null, 360, 'LGA1851;LGA1700;LGA1200;LGA115x;AM5;AM4', '{"radiator_length_mm": 401, "radiator_thickness_mm": 27, "fan_size_mm": 120, "fan_count": 3}'::jsonb)
ON CONFLICT (id) DO UPDATE SET
  model = EXCLUDED.model,
  type = EXCLUDED.type,
  height_mm = EXCLUDED.height_mm,
  radiator_size_mm = EXCLUDED.radiator_size_mm,
  supported_sockets = EXCLUDED.supported_sockets,
  extra = EXCLUDED.extra;



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
