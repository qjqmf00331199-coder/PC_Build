"use client";

import { useEffect, useRef, useState } from "react";
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
  // 총 6초(AUTO_CLOSE_MS) 중 숫자는 5,4,3,2,1 다섯 칸만 쓰고, 마지막 1초는 × 표시 칸
  const [secondsLeft, setSecondsLeft] = useState(AUTO_CLOSE_MS / 1000 - 1);
  const [depleted, setDepleted] = useState(false);

  // ai-recommend-wizard.tsx passes onClose as an inline arrow fn, so it's a new
  // reference on every parent re-render (loading message ticking, price fetches
  // resolving, etc). Keeping onClose in the effect's deps re-ran this whole
  // effect on each of those renders, which reset raf/tick/close timers back to
  // 0 — the number stuck on screen the longest is just whichever one happened
  // to be showing when the parent last re-rendered. Stash it in a ref instead
  // so the effect (and its timers) run exactly once, for real.
  const onCloseRef = useRef(onClose);
  onCloseRef.current = onClose;

  useEffect(() => {
    const raf = requestAnimationFrame(() => setDepleted(true));
    const closeTimer = setTimeout(() => onCloseRef.current(), AUTO_CLOSE_MS);
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
  }, []);

  const src = POPUP_IMAGES[imageIndex];

  // X 버튼이든 배경(카드 바깥)이든, 자동으로 닫히기 전에 뭘 누르든 광고 링크로 보내고 닫는다.
  // 카드 안(이미지 링크·X버튼)은 stopPropagation으로 배경 클릭이 중복 발동해 탭이 두 번 열리는 걸 막는다.
  const openAdAndClose = () => {
    window.open(AD_LINK, "_blank", "noopener,noreferrer");
    onClose();
  };

  return (
    <div className="fixed inset-0 z-[100] flex items-center justify-center bg-black/70 p-4" onClick={openAdAndClose}>
      <div className="popup-ad-scale-in relative w-full max-w-sm" onClick={(e) => e.stopPropagation()}>
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
            alt=""
            width={600}
            height={338}
            priority
            className="ad-fade-in w-full object-contain"
          />
          <div className="relative bg-white py-1.5">
            <span aria-hidden="true" className="absolute bottom-0.5 left-2 text-[6px] leading-none text-[#A1A1AA]">AD</span>
            <p className="text-center text-[9px] text-[#71717A]">광고는 운영자에게 큰 힘이 됩니다!</p>
          </div>
        </a>
        <button
          type="button"
          onClick={openAdAndClose}
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
