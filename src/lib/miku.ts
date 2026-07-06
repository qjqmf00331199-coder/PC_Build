import type { Part, PartCategory, Selections } from "./types";
import type { PartsData } from "./supabase/fetch-parts";

const MIKU_PATTERN = /하츠네\s*미쿠|미쿠\s*에디션|hatsune\s*miku/i;

export function isMikuPart(part: Part | undefined | null): boolean {
  return !!part && MIKU_PATTERN.test(part.model);
}

// only categories that actually have a 미쿠 에디션 option count toward the achievement,
// since not every category (e.g. cpu, ram) has one yet
export function mikuCategoriesAvailable(parts: PartsData): PartCategory[] {
  return (Object.keys(parts) as PartCategory[]).filter((category) =>
    parts[category].some((part) => isMikuPart(part))
  );
}

export function isFullMikuBuild(selections: Selections, parts: PartsData): boolean {
  const categories = mikuCategoriesAvailable(parts);
  if (categories.length === 0) return false;
  return categories.every((category) => isMikuPart(selections[category]));
}
