"use client";

import { createContext, useCallback, useContext, useMemo, useState, type ReactNode } from "react";
import type { CompatIssue, CompatLevel, Part, PartCategory, PartMap, Selections } from "@/lib/types";
import type { PartsData } from "@/lib/supabase/fetch-parts";
import {
  CATEGORY_ORDER,
  computeCategoryStatus,
  computePsuMarginPct,
  estimateTotalPowerW,
  evaluateIssues,
} from "@/lib/compatibility";
import { isFullMikuBuild } from "@/lib/miku";

interface BuildContextValue {
  selections: Selections;
  effectiveSelections: Selections;
  issues: CompatIssue[];
  categoryStatus: Record<PartCategory, CompatLevel>;
  totalPowerW: number;
  psuMarginPct: number | null;
  selectedCount: number;
  totalCategories: number;
  selectPart: <K extends PartCategory>(category: K, part: PartMap[K]) => void;
  resetSelections: () => void;
  issuesFor: (category: PartCategory) => CompatIssue[];
  levelForOption: (category: PartCategory, part: Part) => CompatLevel;
  activeCategory: PartCategory | null;
  preview: Part | undefined;
  openCategory: (category: PartCategory) => void;
  closeCategory: () => void;
  previewPick: (part: Part | undefined) => void;
  isMikuBuild: boolean;
}

const BuildContext = createContext<BuildContextValue | null>(null);

export function BuildProvider({ children, parts }: { children: ReactNode; parts: PartsData }) {
  const [selections, setSelections] = useState<Selections>({});
  const [activeCategory, setActiveCategory] = useState<PartCategory | null>(null);
  const [preview, setPreview] = useState<Part | undefined>(undefined);

  const selectPart = <K extends PartCategory>(category: K, part: PartMap[K]) => {
    setSelections((prev) => {
      const current = prev[category] as PartMap[K] | undefined;
      if (current && current.id === part.id) {
        const next = { ...prev };
        delete next[category];
        return next;
      }
      return { ...prev, [category]: part };
    });
  };

  // while browsing a category, overlay the not-yet-committed pick so the
  // sidebar/illustration/power stats preview it live without saving it
  const effectiveSelections = useMemo(() => {
    if (!activeCategory) return selections;
    const next = { ...selections } as Record<string, unknown>;
    if (preview) {
      next[activeCategory] = preview;
    } else {
      delete next[activeCategory];
    }
    return next as Selections;
  }, [selections, activeCategory, preview]);

  const issues = useMemo(() => evaluateIssues(effectiveSelections), [effectiveSelections]);
  const categoryStatus = useMemo(
    () => computeCategoryStatus(effectiveSelections, issues),
    [effectiveSelections, issues]
  );
  const totalPowerW = useMemo(() => estimateTotalPowerW(effectiveSelections), [effectiveSelections]);
  const psuMarginPct = useMemo(() => computePsuMarginPct(effectiveSelections), [effectiveSelections]);
  const selectedCount = CATEGORY_ORDER.filter((c) => effectiveSelections[c]).length;
  const isMikuBuild = useMemo(() => isFullMikuBuild(effectiveSelections, parts), [effectiveSelections, parts]);

  const resetSelections = () => {
    setSelections({});
    setPreview(undefined);
    setActiveCategory(null);
  };

  const issuesFor = (category: PartCategory) =>
    issues.filter((issue) => issue.categories.includes(category));

  // per-option preview: how would this candidate part fare against the OTHER
  // already-committed categories (not the in-progress preview of this same category)
  const levelForOption = useCallback(
    (category: PartCategory, part: Part): CompatLevel => {
      const others = { ...selections } as Record<string, unknown>;
      delete others[category];
      const hasOtherSelection = CATEGORY_ORDER.some((c) => c !== category && others[c]);
      if (!hasOtherSelection) return "idle";

      const hypothetical = { ...others, [category]: part } as Selections;
      const candidateIssues = evaluateIssues(hypothetical).filter((issue) =>
        issue.categories.includes(category)
      );
      if (candidateIssues.some((issue) => issue.level === "danger")) return "danger";
      if (candidateIssues.some((issue) => issue.level === "warning")) return "warning";
      return "success";
    },
    [selections]
  );

  return (
    <BuildContext.Provider
      value={{
        selections,
        effectiveSelections,
        issues,
        categoryStatus,
        totalPowerW,
        psuMarginPct,
        selectedCount,
        totalCategories: CATEGORY_ORDER.length,
        selectPart,
        resetSelections,
        issuesFor,
        levelForOption,
        activeCategory,
        preview,
        openCategory: (category) => {
          setPreview(selections[category]);
          setActiveCategory(category);
        },
        closeCategory: () => {
          setPreview(undefined);
          setActiveCategory(null);
        },
        previewPick: setPreview,
        isMikuBuild,
      }}
    >
      {children}
    </BuildContext.Provider>
  );
}

export function useBuild() {
  const ctx = useContext(BuildContext);
  if (!ctx) throw new Error("useBuild must be used within BuildProvider");
  return ctx;
}
