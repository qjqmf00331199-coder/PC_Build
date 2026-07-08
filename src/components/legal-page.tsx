"use client";

import { useRouter } from "next/navigation";
import { useState } from "react";
import Link from "next/link";
import { motion } from "framer-motion";

const DURATION = 0.28;
const EASE = [0.4, 0, 0.2, 1] as const;

// entrance: fades/slides up in from below (mirrors the landing-gate slide feel
// without stealing its left/right direction, since this is a plain route nav).
// leaving: reverses the same motion (fade/slide back down) before the actual
// router.push, so "back to landing" reads as the opposite of "open this page".
export function LegalPage({ children }: { children: React.ReactNode }) {
  const router = useRouter();
  const [leaving, setLeaving] = useState(false);

  const goBack = (e: React.MouseEvent) => {
    e.preventDefault();
    setLeaving(true);
    setTimeout(() => router.push("/"), DURATION * 1000);
  };

  return (
    <motion.div
      initial={{ opacity: 0, y: 16 }}
      animate={leaving ? { opacity: 0, y: 16 } : { opacity: 1, y: 0 }}
      transition={{ duration: DURATION, ease: EASE }}
      className="mx-auto max-w-2xl px-6 py-16 text-sm leading-relaxed text-[#E4E4E7]"
    >
      <Link href="/" onClick={goBack} className="text-xs text-[var(--accent)]">
        ↓ 트라이핏(TriFit)으로 돌아가기
      </Link>
      {children}
    </motion.div>
  );
}
