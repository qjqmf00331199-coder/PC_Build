"use client";

import { useEffect, useState } from "react";
import dynamic from "next/dynamic";
import { AnimatePresence, motion, type Variants } from "framer-motion";
import type { PartsData } from "@/lib/supabase/fetch-parts";
import { useBuild } from "./build-provider";
import { CategoryHub } from "./category-hub";

const CategoryDetail = dynamic(() =>
  import("./category-detail").then((m) => m.CategoryDetail)
) as typeof import("./category-detail").CategoryDetail;

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

// pointerEvents can't be animated, and framer-motion's own timing hooks for
// non-animatable values (transition delay, transitionEnd) turned out not to
// actually wait for the slide to finish in testing — the incoming screen
// stayed clickable (or, with transitionEnd, stayed permanently unclickable)
// regardless of its real on-screen position. So this is driven by plain React
// state instead: not interactive until settle fires, with a timer as a backstop
// in case onAnimationComplete doesn't fire (e.g. the very first, non-animated mount).
function AnimatedScreen({
  animKey,
  direction,
  children,
}: {
  animKey: string;
  direction: 1 | -1;
  children: React.ReactNode;
}) {
  const [settled, setSettled] = useState(false);

  useEffect(() => {
    const timer = setTimeout(() => setSettled(true), DURATION * 1000 + 50);
    return () => clearTimeout(timer);
  }, []);

  return (
    <motion.div
      key={animKey}
      custom={direction}
      variants={variants}
      initial="enter"
      animate="center"
      exit="exit"
      transition={{ duration: DURATION, ease: EASE }}
      onAnimationComplete={(target) => {
        if (target === "center") setSettled(true);
      }}
      style={{ pointerEvents: settled ? "auto" : "none" }}
      // absolute so the exiting and entering screens overlap in place
      // instead of shoving the flex layout around mid-transition — only
      // transform/opacity animate, so this stays on the GPU compositor
      className="absolute inset-0 h-full"
    >
      {children}
    </motion.div>
  );
}

export function CategoryStage({ parts }: { parts: PartsData }) {
  const { activeCategory } = useBuild();
  const direction: 1 | -1 = activeCategory === null ? -1 : 1;

  return (
    <div className="relative h-full overflow-hidden">
      <AnimatePresence initial={false} custom={direction}>
        <AnimatedScreen key={activeCategory ?? "hub"} animKey={activeCategory ?? "hub"} direction={direction}>
          {activeCategory === null ? (
            <CategoryHub />
          ) : (
            <CategoryDetail category={activeCategory} options={parts[activeCategory]} />
          )}
        </AnimatedScreen>
      </AnimatePresence>
    </div>
  );
}
