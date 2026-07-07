"use client";

import { useEffect, useState } from "react";
import Image from "next/image";

const AD_LINK = "https://nbcamp.spartaclub.kr/";
const POPUP_IMAGES = ["/ad-popup-1.jpg", "/ad-popup-2.jpg"];
const AUTO_CLOSE_MS = 6000;
const IMAGE_SWITCH_MS = 3000;
const RING_RADIUS = 15;
const RING_CIRCUMFERENCE = 2 * Math.PI * RING_RADIUS;

export function PopupAd({ onClose }: { onClose: () => void }) {
  const [startIndex] = useState(() => Math.floor(Math.random() * POPUP_IMAGES.length));
  const [imageIndex, setImageIndex] = useState(startIndex);
  const [secondsLeft, setSecondsLeft] = useState(5);
  const [depleted, setDepleted] = useState(false);

  useEffect(() => {
    const raf = requestAnimationFrame(() => setDepleted(true));
    const closeTimer = setTimeout(onClose, AUTO_CLOSE_MS);
    const switchTimer = setTimeout(
      () => setImageIndex((i) => (i + 1) % POPUP_IMAGES.length),
      IMAGE_SWITCH_MS
    );
    const tickTimer = setInterval(() => setSecondsLeft((s) => Math.max(s - 1, 0)), 1000);
    return () => {
      cancelAnimationFrame(raf);
      clearTimeout(closeTimer);
      clearTimeout(switchTimer);
      clearInterval(tickTimer);
    };
  }, [onClose]);

  const src = POPUP_IMAGES[imageIndex];

  return (
    <div className="fixed inset-0 z-[100] flex items-center justify-center bg-black/70 p-4">
      <div className="popup-ad-scale-in relative w-full max-w-sm">
        <a
          href={AD_LINK}
          target="_blank"
          rel="noopener noreferrer"
          aria-label="광고"
          className="block overflow-hidden rounded-lg border border-[#27272A] bg-white"
        >
          <Image
            key={src}
            src={src}
            alt="광고"
            width={600}
            height={338}
            priority
            className="ad-fade-in w-full object-contain"
          />
          <div className="relative bg-white py-1.5">
            <span className="absolute bottom-0.5 left-2 text-[6px] leading-none text-[#A1A1AA]">AD</span>
            <p className="text-center text-[9px] text-[#71717A]">광고는 운영자에게 큰 힘이 됩니다!</p>
          </div>
        </a>
        <button
          type="button"
          onClick={onClose}
          aria-label="광고 닫기"
          className="absolute -right-3 -top-3 flex h-9 w-9 items-center justify-center rounded-full bg-[#0A0A0B]"
        >
          <svg width="36" height="36" viewBox="0 0 36 36" className="-rotate-90">
            <circle cx="18" cy="18" r={RING_RADIUS} fill="none" stroke="#27272A" strokeWidth="2.5" />
            <circle
              cx="18"
              cy="18"
              r={RING_RADIUS}
              fill="none"
              stroke="var(--accent)"
              strokeWidth="2.5"
              strokeLinecap="round"
              strokeDasharray={RING_CIRCUMFERENCE}
              strokeDashoffset={depleted ? RING_CIRCUMFERENCE : 0}
              style={{ transition: `stroke-dashoffset ${AUTO_CLOSE_MS}ms linear` }}
            />
          </svg>
          <span className="absolute text-[11px] font-bold text-[#E4E4E7]">
            {secondsLeft > 0 ? secondsLeft : "×"}
          </span>
        </button>
      </div>
    </div>
  );
}
