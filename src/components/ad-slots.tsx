import Image from "next/image";
import { cn } from "@/lib/utils";

const AD_LINK = "https://nbcamp.spartaclub.kr/";

export function AdSlots({ narrow = false }: { narrow?: boolean }) {
  // side rails need (viewport width - centered content width) / 2 >= rail width(192px).
  // the build page's content maxes out at 1152px so it only fits from 2xl(1536px) up;
  // the AI wizard / landing screens are much narrower (max-w-2xl/3xl), so they already
  // have room from xl(1280px) up — showing rails there instead of leaving a dead gutter.
  const railBreakpoint = narrow ? "xl:flex" : "2xl:flex";

  return (
    <>
      {/* desktop: 160x600 rails, only when there's enough side gutter beyond the centered app column */}
      <div className={cn("fixed inset-y-0 left-0 z-[60] hidden w-48 items-center justify-end pr-6", railBreakpoint)}>
        <a href={AD_LINK} target="_blank" rel="noopener noreferrer" aria-label="광고">
          <Image
            src="/ad-desktop.jpg"
            alt="광고"
            width={160}
            height={600}
            className="rounded-lg border border-[#27272A] bg-[#151517] object-contain"
          />
        </a>
      </div>
      <div className={cn("fixed inset-y-0 right-0 z-[60] hidden w-48 items-center justify-start pl-6", railBreakpoint)}>
        <a href={AD_LINK} target="_blank" rel="noopener noreferrer" aria-label="광고">
          <Image
            src="/ad-desktop.jpg"
            alt="광고"
            width={160}
            height={600}
            className="rounded-lg border border-[#27272A] bg-[#151517] object-contain"
          />
        </a>
      </div>

      {/* mobile: bar pinned to the bottom of the viewport, fixed 56px height so
          the app above can reserve exactly enough space and never overlap it */}
      <div className="fixed inset-x-0 bottom-0 z-[60] flex h-14 items-center justify-center border-t border-[#27272A] bg-[#0A0A0B] lg:hidden">
        <a href={AD_LINK} target="_blank" rel="noopener noreferrer" aria-label="광고" className="relative h-full w-[320px] max-w-full">
          <Image src="/ad-mobile.png" alt="광고" fill sizes="320px" className="rounded bg-[#151517] object-contain" />
        </a>
      </div>
    </>
  );
}
