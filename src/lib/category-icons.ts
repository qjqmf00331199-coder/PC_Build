import { Cpu, CircuitBoard, MemoryStick, HardDrive, Gpu, Zap, Box, Fan } from "lucide-react";
import type { LucideIcon } from "lucide-react";
import type { PartCategory } from "./types";

export const CATEGORY_ICON: Record<PartCategory, LucideIcon> = {
  cpu: Cpu,
  motherboard: CircuitBoard,
  ram: MemoryStick,
  ssd: HardDrive,
  gpu: Gpu,
  psu: Zap,
  case: Box,
  cooler: Fan,
};
