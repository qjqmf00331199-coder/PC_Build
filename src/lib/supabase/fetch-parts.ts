import { supabase } from "./client";
import { SEED } from "../seed-data";
import type { PartMap } from "../types";

const TABLE_BY_CATEGORY: Record<keyof PartMap, string> = {
  cpu: "cpu",
  motherboard: "motherboard",
  ram: "ram",
  ssd: "ssd",
  gpu: "gpu",
  psu: "psu",
  case: "pc_case",
  cooler: "cooler",
};

export type PartsData = { [K in keyof PartMap]: PartMap[K][] };

export async function getAllParts(): Promise<PartsData> {
  if (!supabase) {
    return SEED;
  }

  const categories = Object.keys(TABLE_BY_CATEGORY) as (keyof PartMap)[];

  try {
    const results = await Promise.all(
      categories.map((category) =>
        supabase!.from(TABLE_BY_CATEGORY[category]).select("*").order("id")
      )
    );

    const data: Record<string, unknown> = {};
    categories.forEach((category, i) => {
      const { data: rows, error } = results[i];
      if (error || !rows || rows.length === 0) {
        throw error ?? new Error(`empty table: ${TABLE_BY_CATEGORY[category]}`);
      }
      data[category] = rows.map((row) => ({ ...row, category }));
    });

    return data as PartsData;
  } catch (err) {
    // Supabase 테이블이 아직 비어있거나(seed.sql 미실행) 접근에 실패하면
    // 로컬 목데이터로 폴백해 화면이 항상 동작하도록 한다.
    console.warn("[getAllParts] Supabase fetch failed, falling back to local seed data:", err);
    return SEED;
  }
}
