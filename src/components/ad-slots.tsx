export function AdSlots() {
  return (
    <>
      {/* desktop: 160x600 rails, only when there's enough side gutter beyond the centered app column */}
      <div className="fixed inset-y-0 left-0 z-[60] hidden w-48 items-center justify-end pr-6 2xl:flex">
        <img
          src="/ad-desktop.jpg"
          alt="광고"
          className="h-[600px] w-[160px] rounded-lg border border-[#27272A] bg-[#151517] object-contain"
        />
      </div>
      <div className="fixed inset-y-0 right-0 z-[60] hidden w-48 items-center justify-start pl-6 2xl:flex">
        <img
          src="/ad-desktop.jpg"
          alt="광고"
          className="h-[600px] w-[160px] rounded-lg border border-[#27272A] bg-[#151517] object-contain"
        />
      </div>

      {/* mobile: 320x50 bar pinned to the bottom of the viewport */}
      <div className="fixed inset-x-0 bottom-0 z-[60] flex justify-center border-t border-[#27272A] bg-[#0A0A0B] py-1 lg:hidden">
        <img
          src="/ad-mobile.png"
          alt="광고"
          className="h-[50px] w-[320px] max-w-full rounded bg-[#151517] object-contain"
        />
      </div>
    </>
  );
}
