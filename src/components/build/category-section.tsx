"use client";

import { Cpu, CircuitBoard, MemoryStick, HardDrive, Gpu, Zap, Box, Fan, AlertTriangle, XCircle } from "lucide-react";
import type { LucideIcon } from "lucide-react";
import type { PartCategory, PartMap } from "@/lib/types";
import { CATEGORY_LABEL } from "@/lib/compatibility";
import { useBuild } from "./build-provider";
import { PartOptionCard } from "./part-option-card";
import { StatusBadge } from "./status-badge";
import { cn } from "@/lib/utils";

const ICON: Record<PartCategory, LucideIcon> = {
  cpu: Cpu,
  motherboard: CircuitBoard,
  ram: MemoryStick,
  ssd: HardDrive,
  gpu: Gpu,
  psu: Zap,
  case: Box,
  cooler: Fan,
};

export function CategorySection<K extends PartCategory>({
  category,
  options,
}: {
  category: K;
  options: PartMap[K][];
}) {
  const { selections, categoryStatus, selectPart, issuesFor } = useBuild();
  const Icon = ICON[category as PartCategory];
  const selected = selections[category];
  const status = categoryStatus[category];
  const relevantIssues = issuesFor(category);

  return (
    <section
      id={`category-${category}`}
      className="rounded-lg border border-[#27272A] bg-[#151517] p-5 scroll-mt-24"
    >
      <div className="mb-4 flex items-center justify-between">
        <div className="flex items-center gap-2.5">
          <Icon className="h-4.5 w-4.5 text-[#9CA3AF]" strokeWidth={1.75} />
          <h2 className="text-sm font-semibold text-[#E4E4E7]">{CATEGORY_LABEL[category]}</h2>
        </div>
        <StatusBadge level={status} />
      </div>

      <div className="grid grid-cols-1 gap-2.5 sm:grid-cols-2">
        {options.map((part) => (
          <PartOptionCard
            key={part.id}
            part={part}
            selected={selected?.id === part.id}
            onSelect={() => selectPart(category, part)}
          />
        ))}
      </div>

      {relevantIssues.length > 0 && (
        <ul className="mt-4 space-y-1.5 border-t border-[#27272A] pt-3">
          {relevantIssues.map((issue) => {
            const IssueIcon = issue.level === "danger" ? XCircle : AlertTriangle;
            return (
              <li
                key={issue.id}
                className={cn(
                  "flex items-start gap-1.5 text-xs leading-snug",
                  issue.level === "danger" ? "text-[#EF4444]" : "text-[#F59E0B]"
                )}
              >
                <IssueIcon className="mt-0.5 h-3.5 w-3.5 shrink-0" strokeWidth={2} />
                {issue.message}
              </li>
            );
          })}
        </ul>
      )}
    </section>
  );
}
