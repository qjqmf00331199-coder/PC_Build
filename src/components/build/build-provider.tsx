"use client";

import { createContext, useCallback, useContext, useEffect, useMemo, useRef, useState, type ReactNode } from "react";
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
import type { ProductInfo } from "@/app/api/product-image/route";
import { useProductInfo } from "@/lib/use-product-info";

interface BuildContextValue {
  selections: Selections;
  effectiveSelections: Selections;
  issues: CompatIssue[];
  categoryStatus: Record<PartCategory, CompatLevel>;
  totalPowerW: number;
  psuMarginPct: number | null;
  selectedCount: number;
  totalCategories: number;
  partInfo: Record<PartCategory, ProductInfo>;
  totalPrice: number;
  totalPriceLoading: boolean;
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

export function BuildProvider({
  children,
  parts,
  initialSelections,
}: {
  children: ReactNode;
  parts: PartsData;
  initialSelections?: Selections;
}) {
  const [selections, setSelections] = useState<Selections>(initialSelections ?? {});
  const [activeCategory, setActiveCategory] = useState<PartCategory | null>(null);
  const [preview, setPreview] = useState<Part | undefined>(undefined);

  // refs so commitPreview (called from event handlers set up once, or from the
  // popstate listener) always reads the latest in-progress pick, not a stale closure
  const activeCategoryRef = useRef(activeCategory);
  activeCategoryRef.current = activeCategory;
  const previewRef = useRef(preview);
  previewRef.current = preview;

  // a card click only updates `preview` (so browsing options can live-preview
  // compat/power stats without committing); leaving the category in ANY way
  // (back arrow, browser/mobile back, jumping straight to another category from
  // the sidebar) must save that pending pick first, or it silently vanishes
  const commitPreview = useCallback(() => {
    const category = activeCategoryRef.current;
    if (!category) return;
    const part = previewRef.current;
    setSelections((prev) => {
      if (!part) {
        if (!(category in prev)) return prev;
        const next = { ...prev };
        delete next[category];
        return next;
      }
      if (prev[category]?.id === part.id) return prev;
      return { ...prev, [category]: part } as Selections;
    });
  }, []);

  // opening a category pushes a history entry (see openCategory below) so the
  // mobile/browser back button closes the detail view instead of leaving the site
  useEffect(() => {
    const onPopState = (e: PopStateEvent) => {
      commitPreview();
      const category = (e.state as { trifitCategory?: PartCategory } | null)?.trifitCategory ?? null;
      setActiveCategory(category);
      setPreview(category ? selections[category] : undefined);
    };
    window.addEventListener("popstate", onPopState);
    return () => window.removeEventListener("popstate", onPopState);
  }, [selections, commitPreview]);

  const selectPart = useCallback(<K extends PartCategory>(category: K, part: PartMap[K]) => {
    setSelections((prev) => {
      const current = prev[category] as PartMap[K] | undefined;
      if (current && current.id === part.id) {
        const next = { ...prev };
        delete next[category];
        return next;
      }
      return { ...prev, [category]: part };
    });
  }, []);

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

  // fixed set of 8 categories called in a stable order every render, so calling
  // the price-fetch hook once per category (instead of in a loop) stays rules-of-hooks safe
  const cpuInfo = useProductInfo(effectiveSelections.cpu ?? null);
  const motherboardInfo = useProductInfo(effectiveSelections.motherboard ?? null);
  const ramInfo = useProductInfo(effectiveSelections.ram ?? null);
  const ssdInfo = useProductInfo(effectiveSelections.ssd ?? null);
  const gpuInfo = useProductInfo(effectiveSelections.gpu ?? null);
  const psuInfo = useProductInfo(effectiveSelections.psu ?? null);
  const caseInfo = useProductInfo(effectiveSelections.case ?? null);
  const coolerInfo = useProductInfo(effectiveSelections.cooler ?? null);
  // each useProductInfo result is a referentially stable object when its data
  // hasn't changed, so wrapping the lookup itself in useMemo (keyed off those
  // same references) keeps `partInfo` stable too — without this, a brand new
  // object here would bust the context value memo below on every render
  const partInfo: Record<PartCategory, ProductInfo> = useMemo(
    () => ({
      cpu: cpuInfo,
      motherboard: motherboardInfo,
      ram: ramInfo,
      ssd: ssdInfo,
      gpu: gpuInfo,
      psu: psuInfo,
      case: caseInfo,
      cooler: coolerInfo,
    }),
    [cpuInfo, motherboardInfo, ramInfo, ssdInfo, gpuInfo, psuInfo, caseInfo, coolerInfo]
  );
  const selectedPrices = CATEGORY_ORDER.filter((c) => effectiveSelections[c]).map((c) => partInfo[c].price);
  const totalPrice = selectedPrices.reduce((sum: number, p) => sum + (p ?? 0), 0);
  const totalPriceLoading = selectedPrices.some((p) => p === null);

  const resetSelections = useCallback(() => {
    setSelections({});
    setPreview(undefined);
    setActiveCategory(null);
  }, []);

  const issuesFor = useCallback(
    (category: PartCategory) => issues.filter((issue) => issue.categories.includes(category)),
    [issues]
  );

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

  const openCategory = useCallback(
    (category: PartCategory) => {
      // jumping straight from one category's detail into another (e.g. via the
      // sidebar's selected-parts list) skips closeCategory, so commit here too
      commitPreview();
      const base = (window.history.state as { depth?: number } | null) ?? {};
      window.history.pushState({ ...base, trifitCategory: category, depth: (base.depth ?? 0) + 1 }, "");
      setPreview(selections[category]);
      setActiveCategory(category);
    },
    [commitPreview, selections]
  );

  const closeCategory = useCallback(() => {
    if (activeCategory === null) return;
    window.history.back();
  }, [activeCategory]);

  // stable unless something a consumer actually reads changes — otherwise every
  // BuildProvider render (e.g. from openCategory's setPreview/setActiveCategory,
  // which fires right as CategoryStage starts its transition) would hand out a
  // brand new context value and force every consumer (sidebar, summary panel,
  // case illustration, all 8 category cards, etc.) to re-render at the same time,
  // stacking on top of the detail view's own mount cost and showing up as jank
  const value = useMemo<BuildContextValue>(
    () => ({
      selections,
      effectiveSelections,
      issues,
      categoryStatus,
      totalPowerW,
      psuMarginPct,
      selectedCount,
      totalCategories: CATEGORY_ORDER.length,
      partInfo,
      totalPrice,
      totalPriceLoading,
      selectPart,
      resetSelections,
      issuesFor,
      levelForOption,
      activeCategory,
      preview,
      openCategory,
      closeCategory,
      previewPick: setPreview,
      isMikuBuild,
    }),
    [
      selections,
      effectiveSelections,
      issues,
      categoryStatus,
      totalPowerW,
      psuMarginPct,
      selectedCount,
      partInfo,
      totalPrice,
      totalPriceLoading,
      selectPart,
      resetSelections,
      issuesFor,
      levelForOption,
      activeCategory,
      preview,
      openCategory,
      closeCategory,
      isMikuBuild,
    ]
  );

  return <BuildContext.Provider value={value}>{children}</BuildContext.Provider>;
}

export function useBuild() {
  const ctx = useContext(BuildContext);
  if (!ctx) throw new Error("useBuild must be used within BuildProvider");
  return ctx;
}
