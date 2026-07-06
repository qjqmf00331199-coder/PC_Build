"use client";

import { useEffect, useRef, useState } from "react";

const BANNER_DURATION_MS = 10_000;
const MOBILE_QUERY = "(max-width: 1023px)";

export function MikuEasterEgg({ active }: { active: boolean }) {
  const [showBanner, setShowBanner] = useState(false);
  const [isMobile, setIsMobile] = useState(false);
  const hasShownBannerRef = useRef(false);

  useEffect(() => {
    if (!active || hasShownBannerRef.current) return;
    hasShownBannerRef.current = true;
    setShowBanner(true);
    const timer = setTimeout(() => setShowBanner(false), BANNER_DURATION_MS);
    return () => clearTimeout(timer);
  }, [active]);

  useEffect(() => {
    const mq = window.matchMedia(MOBILE_QUERY);
    const update = () => setIsMobile(mq.matches);
    update();
    mq.addEventListener("change", update);
    return () => mq.removeEventListener("change", update);
  }, []);

  if (!active) return null;

  return (
    <>
      <div className="pointer-events-none fixed inset-0 z-50 overflow-hidden">
        {/* miku edition background, swapped by viewport */}
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img
          src={isMobile ? "/miku-bg-mobile.png" : "/miku-bg-desktop.jpg"}
          alt=""
          className="absolute inset-0 h-full w-full object-cover opacity-20"
        />

        {/* soft teal/pink wash over the whole page */}
        <div
          className="absolute inset-0 opacity-[0.07]"
          style={{
            background:
              "radial-gradient(circle at 15% 10%, #39c5bb, transparent 45%), radial-gradient(circle at 85% 90%, #ff8fc7, transparent 45%)",
          }}
        />

        {/* achievement banner: only on first trigger, auto-hides after 10s */}
        {showBanner && (
          <div
            className="absolute left-1/2 top-4 -translate-x-1/2 rounded-full border px-4 py-2 text-xs font-semibold shadow-lg"
            style={{
              borderColor: "#39c5bb",
              backgroundColor: "#0a0a0bcc",
              color: "#39c5bb",
              animation: "miku-fade-in 400ms ease-out",
            }}
          >
            ✨ 하츠네 미쿠 에디션 풀 빌드 달성!
          </div>
        )}
      </div>
      <MikuRunner />
    </>
  );
}

function MikuRunner() {
  const [done, setDone] = useState(false);

  if (done) return null;

  return (
    // sits above the mobile ad bar (h-14) instead of overlapping it
    <div className="pointer-events-none fixed inset-x-0 bottom-16 z-[70] overflow-hidden">
      <div
        className="relative w-40"
        style={{ animation: "miku-walk 16s linear 1 forwards" }}
        onAnimationEnd={() => setDone(true)}
      >
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img src="/miku-walk.gif" alt="" className="w-full" />
      </div>
    </div>
  );
}
