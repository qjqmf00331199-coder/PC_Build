"use client";

import { BuildProvider } from "./build-provider";
import { CaseIllustration } from "./case-illustration";
import { CategorySection } from "./category-section";
import { SummaryPanel } from "./summary-panel";
import { CATEGORY_ORDER } from "@/lib/compatibility";
import { SEED } from "@/lib/seed-data";

export function BuildChecker() {
  return (
    <BuildProvider>
      <div className="mx-auto max-w-6xl px-4 pb-24 pt-6 lg:px-6 lg:pt-10">
        <header className="mb-6 lg:mb-10">
          <h1 className="text-xl font-semibold text-[#E4E4E7] lg:text-2xl">
            PC 부품 호환성 체커
          </h1>
          <p className="mt-1 text-sm text-[#9CA3AF]">
            부품을 고르면 즉시 소켓·전원·크기 호환성을 확인합니다.
          </p>
        </header>

        {/* mobile compact top bar */}
        <div className="mb-5 rounded-lg border border-[#27272A] bg-[#151517] p-4 lg:hidden sticky top-3 z-20 backdrop-blur supports-[backdrop-filter]:bg-[#151517]/90">
          <CaseIllustration compact />
        </div>

        <div className="lg:grid lg:grid-cols-[300px_1fr] lg:items-start lg:gap-8">
          {/* left sticky illustration panel (desktop) */}
          <aside className="hidden lg:sticky lg:top-10 lg:block lg:rounded-lg lg:border lg:border-[#27272A] lg:bg-[#151517] lg:p-6">
            <CaseIllustration />
          </aside>

          {/* right column */}
          <div className="flex flex-col gap-4">
            <SummaryPanel />
            {CATEGORY_ORDER.map((category) => (
              <CategorySection key={category} category={category} options={SEED[category]} />
            ))}
          </div>
        </div>
      </div>
    </BuildProvider>
  );
}
