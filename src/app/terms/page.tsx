import type { Metadata } from "next";
import Link from "next/link";

export const metadata: Metadata = {
  title: "이용약관 | 트라이핏 (TriFit)",
};

const REPO_URL = "https://github.com/qjqmf00331199-coder/PC_Build";

export default function TermsPage() {
  return (
    <div className="mx-auto max-w-2xl px-6 py-16 text-sm leading-relaxed text-[#E4E4E7]">
      <Link href="/" className="text-xs text-[var(--accent)]">
        ← 트라이핏(TriFit)으로 돌아가기
      </Link>

      <h1 className="mt-6 text-2xl font-bold">이용약관</h1>
      <p className="mt-2 text-xs text-[#9CA3AF]">시행일: 2026년 7월 6일</p>

      <h2 className="mt-8 text-base font-semibold text-[var(--accent)]">1. 서비스의 성격</h2>
      <p className="mt-3 text-[#9CA3AF]">
        트라이핏(TriFit, 이하 &quot;서비스&quot;)은 PC 부품 선택 시 소켓·전원·크기 등 호환성을 참고용으로 안내하는
        개인 학습 목적의 비상업적 웹 도구입니다. 회원가입, 결제, 구매 중개 기능은 제공하지 않습니다.
      </p>

      <h2 className="mt-8 text-base font-semibold text-[var(--accent)]">2. 정보 정확성에 대한 면책</h2>
      <p className="mt-3 text-[#9CA3AF]">
        서비스에 표시되는 부품 스펙·가격·호환성 판단 결과 및 AI 추천 결과는 참고 자료일 뿐이며, 실제 구매·조립 전 반드시
        제조사 공식 스펙과 판매처 정보를 재확인해야 합니다. 서비스는 표시된 정보의 정확성·최신성을 보증하지 않으며, 이를
        신뢰하여 발생한 손해에 대해 책임을 지지 않습니다.
      </p>

      <h2 className="mt-8 text-base font-semibold text-[var(--accent)]">3. 데이터 출처</h2>
      <p className="mt-3 text-[#9CA3AF]">
        부품 스펙·가격 데이터의 상당 부분은 다나와(danawa.com)에 공개된 정보를 참고하여 개인 학습 목적으로 정리한
        것입니다. 제품 이미지는 네이버쇼핑 검색 API를 통해 노출되는 판매처·제조사 제공 이미지이며, 각 이미지의 저작권은
        해당 제조사 또는 판매처에 있습니다.
      </p>

      <h2 className="mt-8 text-base font-semibold text-[var(--accent)]">4. 상표 및 브랜드 표기</h2>
      <p className="mt-3 text-[#9CA3AF]">
        서비스에 언급되는 Intel, AMD, NVIDIA, ASUS 등 제조사명 및 제품명은 각 권리자의 상표이며, 서비스와 해당 제조사 간
        제휴·후원 관계를 의미하지 않습니다. 부품 식별을 위한 정보 제공 목적으로만 사용됩니다.
      </p>

      <h2 className="mt-8 text-base font-semibold text-[var(--accent)]">5. 이용자의 의무</h2>
      <p className="mt-3 text-[#9CA3AF]">
        이용자는 서비스를 상업적 재배포, 무단 크롤링, 서비스 운영을 방해하는 방식으로 사용해서는 안 됩니다.
      </p>

      <h2 className="mt-8 text-base font-semibold text-[var(--accent)]">6. 약관 변경</h2>
      <p className="mt-3 text-[#9CA3AF]">
        본 약관은 서비스 기능 변경에 따라 개정될 수 있으며, 개정 시 본 페이지를 통해 고지합니다.
      </p>

      <h2 className="mt-8 text-base font-semibold text-[var(--accent)]">7. 문의</h2>
      <p className="mt-3">
        <a href={`${REPO_URL}/issues`} target="_blank" rel="noreferrer" className="text-[var(--accent)] underline">
          {REPO_URL}/issues
        </a>
      </p>
    </div>
  );
}
