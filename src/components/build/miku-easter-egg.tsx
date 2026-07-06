"use client";

export function MikuEasterEgg({ active }: { active: boolean }) {
  if (!active) return null;

  return (
    <div className="pointer-events-none fixed inset-0 z-50 overflow-hidden">
      {/* soft teal/pink wash over the whole page */}
      <div
        className="absolute inset-0 opacity-[0.07]"
        style={{
          background:
            "radial-gradient(circle at 15% 10%, #39c5bb, transparent 45%), radial-gradient(circle at 85% 90%, #ff8fc7, transparent 45%)",
        }}
      />

      {/* achievement banner */}
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

      {/* running miku sprite (bg removed from the provided gif), crosses the screen and flips on the return leg */}
      <div className="absolute bottom-2 w-40" style={{ animation: "miku-walk 16s linear infinite" }}>
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img src="/miku-walk.gif" alt="" className="w-full" />
      </div>
    </div>
  );
}
