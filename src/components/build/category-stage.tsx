"use client";

import { useEffect, useState } from "react";
import type { PartCategory } from "@/lib/types";
import type { PartsData } from "@/lib/supabase/fetch-parts";
import { useBuild } from "./build-provider";
import { CategoryHub } from "./category-hub";
import { CategoryDetail } from "./category-detail";
import { cn } from "@/lib/utils";

const FADE_MS = 180;

export function CategoryStage({ parts }: { parts: PartsData }) {
  const { activeCategory } = useBuild();
  const [rendered, setRendered] = useState<PartCategory | null>(activeCategory);
  const [fading, setFading] = useState(false);

  useEffect(() => {
    if (activeCategory === rendered) return;
    setFading(true);
    const timer = setTimeout(() => {
      setRendered(activeCategory);
      setFading(false);
    }, FADE_MS);
    return () => clearTimeout(timer);
  }, [activeCategory, rendered]);

  return (
    <div
      className={cn(
        "transition-opacity ease-in-out lg:h-full",
        fading ? "opacity-0 duration-150" : "opacity-100 duration-200"
      )}
    >
      {rendered === null ? (
        <CategoryHub parts={parts} />
      ) : (
        <CategoryDetail category={rendered} options={parts[rendered]} />
      )}
    </div>
  );
}
