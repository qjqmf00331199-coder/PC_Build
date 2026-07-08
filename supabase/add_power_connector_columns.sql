-- ==========================================================
-- GPU/PSU 16핀(12VHPWR/12V-2x6) 전원 커넥터 호환 체크용 컬럼 추가
-- rebuild_full.sql은 이미 이 컬럼 포함해서 갱신됐지만, 이미 데이터가 들어있는
-- 라이브 Supabase DB에 4000줄짜리 전체 재삽입을 다시 돌릴 필요는 없으니
-- 이 파일만 Supabase SQL Editor에서 한 번 실행하면 됨 (기존 행 안 지움).
-- ==========================================================

alter table gpu add column if not exists power_connector_pins int;
alter table gpu add column if not exists power_connector_count int;

update gpu set
  power_connector_pins = case when connector like '16핀%' then 12 else 8 end,
  power_connector_count = case
    when connector ~ '[xX]\s*([0-9]+)\s*$' then substring(connector from '[0-9]+\s*$')::int
    else 1
  end;

alter table gpu alter column power_connector_pins set not null;
alter table gpu alter column power_connector_count set not null;

alter table psu add column if not exists atx_spec text;
alter table psu add column if not exists native_gpu_connector text;

update psu set
  atx_spec = case
    when atx_version ilike '%atx3.1%' then 'ATX3.1'
    when atx_version ilike '%atx3.0%' then 'ATX3.0'
    else 'ATX12V'
  end,
  native_gpu_connector = case
    when atx_version ilike '%atx3.1%' then '12V-2x6'
    when atx_version ilike '%atx3.0%' then '12VHPWR'
    else null
  end;

alter table psu alter column atx_spec set not null;
