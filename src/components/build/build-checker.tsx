"use client";

import { BuildProvider } from "./build-provider";
import { CaseIllustration } from "./case-illustration";
import { CategoryStage } from "./category-stage";
import { SelectedPartsList } from "./selected-parts-list";
import { SummaryPanel } from "./summary-panel";
import type { PartsData } from "@/lib/supabase/fetch-parts";

export function BuildChecker({ parts }: { parts: PartsData }) {
  return (
    <BuildProvider>
      <div className="mx-auto max-w-6xl px-4 pb-24 pt-6 lg:flex lg:h-screen lg:flex-col lg:overflow-hidden lg:px-6 lg:pb-6 lg:pt-6">
        <header className="mb-6 shrink-0 lg:mb-6">
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

        <div className="lg:grid lg:min-h-0 lg:flex-1 lg:grid-cols-[300px_1fr] lg:items-stretch lg:gap-8">
          {/* left illustration panel (desktop): fixed in place, own scroll if it ever overflows */}
          <aside className="hidden lg:block lg:h-full lg:overflow-y-auto lg:rounded-lg lg:border lg:border-[#27272A] lg:bg-[#151517] lg:p-6">
            <CaseIllustration />
            <SelectedPartsList />
          </aside>

          {/* right column */}
          <div className="flex flex-col gap-4 lg:h-full lg:min-h-0 lg:overflow-hidden">
            <SummaryPanel />
            <div className="lg:min-h-0 lg:flex-1 lg:overflow-hidden">
              <CategoryStage parts={parts} />
            </div>
          </div>
        </div>
      </div>
    </BuildProvider>
  );
}
