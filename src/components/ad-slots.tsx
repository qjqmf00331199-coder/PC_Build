"use client";

import { useEffect, useState } from "react";
import Image from "next/image";
import { cn } from "@/lib/utils";

const AD_LINK = "https://nbcamp.spartaclub.kr/";

const DESKTOP_ADS = ["/ad-desktop.jpg", "/ad-desktop-2.jpg", "/ad-desktop-3.jpg"];
const MOBILE_ADS = ["/ad-mobile.png", "/ad-mobile-2.jpg"];
const ROTATE_MIN_MS = 3000;
const ROTATE_MAX_MS = 5000;

function AdBadge() {
  return (
    <span
      aria-hidden="true"
      className="pointer-events-none absolute bottom-0.5 left-1 z-10 text-[6px] leading-none text-white/60"
    >
      AD
    </span>
  );
}

// 데스크톱 사이드 레일: 다음 노출 이미지를 매번 무작위로 뽑는다(직전과 같은 이미지는 다시 안 뽑음).
function useRandomAdIndex(length: number) {
  const [index, setIndex] = useState(0);
  useEffect(() => {
    if (length <= 1) return;
    let timer: ReturnType<typeof setTimeout>;
    const schedule = () => {
      const delay = ROTATE_MIN_MS + Math.random() * (ROTATE_MAX_MS - ROTATE_MIN_MS);
      timer = setTimeout(() => {
        setIndex((current) => {
          if (length <= 1) return current;
          let next = Math.floor(Math.random() * length);
          while (next === current) next = Math.floor(Math.random() * length);
          return next;
        });
        schedule();
      }, delay);
    };
    schedule();
    return () => clearTimeout(timer);
  }, [length]);
  return index;
}

// 모바일 하단 바: 이미지를 순서대로 옆에서 슬라이딩시키며 교체한다.
function useSequentialAdIndex(length: number) {
  const [index, setIndex] = useState(0);
  useEffect(() => {
    if (length <= 1) return;
    let timer: ReturnType<typeof setTimeout>;
    const schedule = () => {
      const delay = ROTATE_MIN_MS + Math.random() * (ROTATE_MAX_MS - ROTATE_MIN_MS);
      timer = setTimeout(() => {
        setIndex((current) => (current + 1) % length);
        schedule();
      }, delay);
    };
    schedule();
    return () => clearTimeout(timer);
  }, [length]);
  return index;
}

export function AdSlots({ narrow = false }: { narrow?: boolean }) {
  // side rails need (viewport width - centered content width) / 2 >= rail width(192px).
  // the build page's content maxes out at 1152px so it only fits from 2xl(1536px) up;
  // the AI wizard / landing screens are much narrower (max-w-2xl/3xl), so they already
  // have room from xl(1280px) up — showing rails there instead of leaving a dead gutter.
  const railBreakpoint = narrow ? "xl:flex" : "2xl:flex";
  // mobile bar must stay visible right up until the rails take over, otherwise
  // mid-width viewports (e.g. 1024~1535px on the non-narrow build page) show no ad at all
  const mobileBarHiddenBreakpoint = narrow ? "xl:hidden" : "2xl:hidden";

  const desktopAdIndex = useRandomAdIndex(DESKTOP_ADS.length);
  const desktopAdSrc = DESKTOP_ADS[desktopAdIndex];
  const mobileAdIndex = useSequentialAdIndex(MOBILE_ADS.length);

  return (
    <>
      {/* desktop: 160x600 rails, only when there's enough side gutter beyond the centered app column */}
      <div className={cn("fixed inset-y-0 left-0 z-[60] hidden w-48 items-center justify-end pr-6", railBreakpoint)}>
        <a href={AD_LINK} target="_blank" rel="noopener noreferrer" aria-label="광고" className="relative block">
          <Image
            key={desktopAdSrc}
            src={desktopAdSrc}
            alt=""
            width={160}
            height={600}
            className="ad-fade-in rounded-lg border border-[#27272A] bg-[#151517] object-contain"
          />
          <AdBadge />
        </a>
      </div>
      <div className={cn("fixed inset-y-0 right-0 z-[60] hidden w-48 items-center justify-start pl-6", railBreakpoint)}>
        <a href={AD_LINK} target="_blank" rel="noopener noreferrer" aria-label="광고" className="relative block">
          <Image
            key={desktopAdSrc}
            src={desktopAdSrc}
            alt=""
            width={160}
            height={600}
            className="ad-fade-in rounded-lg border border-[#27272A] bg-[#151517] object-contain"
          />
          <AdBadge />
        </a>
      </div>

      {/* mobile: bar pinned to the bottom of the viewport, fixed 56px height so
          the app above can reserve exactly enough space and never overlap it */}
      <div
        className={cn(
          "fixed inset-x-0 bottom-0 z-[60] flex h-14 items-center justify-center overflow-hidden border-t border-[#27272A] bg-[#0A0A0B]",
          mobileBarHiddenBreakpoint
        )}
      >
        <a href={AD_LINK} target="_blank" rel="noopener noreferrer" aria-label="광고" className="relative h-full w-[320px] max-w-full overflow-hidden">
          <div
            className="flex h-full transition-transform duration-500 ease-in-out"
            style={{
              width: `${MOBILE_ADS.length * 100}%`,
              transform: `translateX(-${mobileAdIndex * (100 / MOBILE_ADS.length)}%)`,
            }}
          >
            {MOBILE_ADS.map((src) => (
              <div key={src} className="relative h-full shrink-0" style={{ width: `${100 / MOBILE_ADS.length}%` }}>
                <Image src={src} alt="" fill sizes="320px" className="rounded bg-[#151517] object-contain" />
              </div>
            ))}
          </div>
          <AdBadge />
        </a>
      </div>
    </>
  );
}
