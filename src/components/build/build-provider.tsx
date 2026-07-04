"use client";

import { createContext, useContext, useMemo, useState, type ReactNode } from "react";
import type { CompatIssue, CompatLevel, PartCategory, PartMap, Selections } from "@/lib/types";
import {
  CATEGORY_ORDER,
  computeCategoryStatus,
  computePsuMarginPct,
  estimateTotalPowerW,
  evaluateIssues,
} from "@/lib/compatibility";

interface BuildContextValue {
  selections: Selections;
  issues: CompatIssue[];
  categoryStatus: Record<PartCategory, CompatLevel>;
  totalPowerW: number;
  psuMarginPct: number | null;
  selectedCount: number;
  totalCategories: number;
  selectPart: <K extends PartCategory>(category: K, part: PartMap[K]) => void;
  issuesFor: (category: PartCategory) => CompatIssue[];
  activeCategory: PartCategory | null;
  openCategory: (category: PartCategory) => void;
  closeCategory: () => void;
}

const BuildContext = createContext<BuildContextValue | null>(null);

export function BuildProvider({ children }: { children: ReactNode }) {
  const [selections, setSelections] = useState<Selections>({});
  const [activeCategory, setActiveCategory] = useState<PartCategory | null>(null);

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

  const issues = useMemo(() => evaluateIssues(selections), [selections]);
  const categoryStatus = useMemo(
    () => computeCategoryStatus(selections, issues),
    [selections, issues]
  );
  const totalPowerW = useMemo(() => estimateTotalPowerW(selections), [selections]);
  const psuMarginPct = useMemo(() => computePsuMarginPct(selections), [selections]);
  const selectedCount = CATEGORY_ORDER.filter((c) => selections[c]).length;

  const issuesFor = (category: PartCategory) =>
    issues.filter((issue) => issue.categories.includes(category));

  return (
    <BuildContext.Provider
      value={{
        selections,
        issues,
        categoryStatus,
        totalPowerW,
        psuMarginPct,
        selectedCount,
        totalCategories: CATEGORY_ORDER.length,
        selectPart,
        issuesFor,
        activeCategory,
        openCategory: setActiveCategory,
        closeCategory: () => setActiveCategory(null),
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
