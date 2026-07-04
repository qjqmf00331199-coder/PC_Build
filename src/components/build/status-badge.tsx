import { CheckCircle2, AlertTriangle, XCircle, Circle } from "lucide-react";
import type { CompatLevel } from "@/lib/types";
import { cn } from "@/lib/utils";

const CONFIG: Record<CompatLevel, { icon: typeof CheckCircle2; label: string; classes: string }> = {
  success: {
    icon: CheckCircle2,
    label: "호환",
    classes: "text-[#22C55E] bg-[#22C55E]/10 border-[#22C55E]/30",
  },
  warning: {
    icon: AlertTriangle,
    label: "주의",
    classes: "text-[#F59E0B] bg-[#F59E0B]/10 border-[#F59E0B]/30",
  },
  danger: {
    icon: XCircle,
    label: "불가",
    classes: "text-[#EF4444] bg-[#EF4444]/10 border-[#EF4444]/30",
  },
  idle: {
    icon: Circle,
    label: "미선택",
    classes: "text-[#9CA3AF] bg-white/5 border-[#27272A]",
  },
};

export function StatusBadge({ level, className }: { level: CompatLevel; className?: string }) {
  const { icon: Icon, label, classes } = CONFIG[level];
  return (
    <span
      className={cn(
        "inline-flex items-center gap-1 rounded-full border px-2 py-0.5 text-xs font-medium",
        classes,
        className
      )}
    >
      <Icon className="h-3.5 w-3.5" strokeWidth={2.25} />
      {label}
    </span>
  );
}
