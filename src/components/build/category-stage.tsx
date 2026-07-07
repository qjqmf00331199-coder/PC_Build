"use client";

import { AnimatePresence, motion, type Variants } from "framer-motion";
import type { PartsData } from "@/lib/supabase/fetch-parts";
import { useBuild } from "./build-provider";
import { CategoryHub } from "./category-hub";
import { CategoryDetail } from "./category-detail";

const DURATION = 0.28;
const EASE = [0.4, 0, 0.2, 1] as const;

// direction 1 = opening a category (hub -> detail, or switching detail -> detail):
// incoming slides in from the right, outgoing exits to the left.
// direction -1 = closing back to the hub: incoming slides in from the left,
// outgoing exits to the right (mirror of the open animation).
const variants: Variants = {
  enter: (direction: 1 | -1) => ({ x: direction === 1 ? "100%" : "-100%", opacity: 0 }),
  center: { x: "0%", opacity: 1 },
  exit: (direction: 1 | -1) => ({ x: direction === 1 ? "-100%" : "100%", opacity: 0 }),
};

export function CategoryStage({ parts }: { parts: PartsData }) {
  const { activeCategory } = useBuild();
  const direction: 1 | -1 = activeCategory === null ? -1 : 1;

  return (
    <div className="relative h-full overflow-hidden">
      <AnimatePresence initial={false} custom={direction}>
        <motion.div
          key={activeCategory ?? "hub"}
          custom={direction}
          variants={variants}
          initial="enter"
          animate="center"
          exit="exit"
          transition={{ duration: DURATION, ease: EASE }}
          // absolute so the exiting and entering screens overlap in place
          // instead of shoving the flex layout around mid-transition — only
          // transform/opacity animate, so this stays on the GPU compositor
          className="absolute inset-0 h-full"
        >
          {activeCategory === null ? (
            <CategoryHub parts={parts} />
          ) : (
            <CategoryDetail category={activeCategory} options={parts[activeCategory]} />
          )}
        </motion.div>
      </AnimatePresence>
    </div>
  );
}
