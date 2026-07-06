import type { Metadata } from "next";
import Link from "next/link";

export const metadata: Metadata = {
  title: "개인정보처리방침 | 트라이핏 (TriFit)",
};

const REPO_URL = "https://github.com/qjqmf00331199-coder/PC_Build";

export default function PrivacyPage() {
  return (
    <div className="mx-auto max-w-2xl px-6 py-16 text-sm leading-relaxed text-[#E4E4E7]">
      <Link href="/" className="text-xs text-[var(--accent)]">
        ← 트라이핏(TriFit)으로 돌아가기
      </Link>

      <h1 className="mt-6 text-2xl font-bold">개인정보처리방침</h1>
      <p className="mt-2 text-xs text-[#9CA3AF]">시행일: 2026년 7월 6일</p>

      <p className="mt-6 text-[#9CA3AF]">
        트라이핏(TriFit, 이하 &quot;서비스&quot;)은 개인 학습 목적으로 제작된 비상업적 웹 도구입니다.
        서비스는 별도의 회원가입·로그인 기능이 없으며, 아래와 같이 최소한의 정보만 처리합니다.
      </p>

      <h2 className="mt-8 text-base font-semibold text-[var(--accent)]">1. 수집하는 정보</h2>
      <ul className="mt-3 list-disc space-y-2 pl-5 text-[#9CA3AF]">
        <li>
          <span className="text-[#E4E4E7]">부품 선택 정보</span> — CPU·메인보드·RAM 등 사용자가 화면에서 클릭해 고른 부품 값.
          브라우저 메모리에만 유지되며 서버에 저장되지 않습니다.
        </li>
        <li>
          <span className="text-[#E4E4E7]">AI 추천 설문 답변 및 자유 텍스트 입력</span> — &quot;AI에게 추천받기&quot; 기능 사용
          시 입력한 용도·우선순위·선호 브랜드 및 직접 작성한 요청사항.
        </li>
      </ul>

      <h2 className="mt-8 text-base font-semibold text-[var(--accent)]">2. 정보의 처리 목적 및 제3자 제공</h2>
      <p className="mt-3 text-[#9CA3AF]">
        AI 추천 기능은 입력값을 서버를 거쳐 외부 AI 모델 제공사(<span className="text-[#E4E4E7]">NVIDIA NIM API</span>, 모델:
        Llama 3.1)에 전달하여 추천 부품 조합을 생성합니다. 전달되는 정보는 설문 답변과 자유 텍스트뿐이며, 이름·이메일·연락처 등
        신원을 식별할 수 있는 정보는 수집하지 않으므로 함께 전송되지 않습니다.
      </p>
      <p className="mt-3 text-[#9CA3AF]">
        해당 API 호출은 서비스 서버에서 이루어지며, 요청·응답 내용은 별도 데이터베이스에 저장하지 않고 응답을 화면에 반환한
        뒤 폐기합니다. 단, API 제공사의 인프라가 국외에 위치할 수 있어 처리 과정에서 국외 서버를 경유합니다.
      </p>

      <h2 className="mt-8 text-base font-semibold text-[var(--accent)]">3. 부품 데이터베이스(Supabase)</h2>
      <p className="mt-3 text-[#9CA3AF]">
        서비스가 보여주는 CPU·GPU 등 부품 스펙 데이터는 Supabase에 저장된 카탈로그이며, 조회(읽기) 전용으로만 사용됩니다.
        이 데이터베이스에는 개인 식별 정보가 포함되어 있지 않습니다.
      </p>

      <h2 className="mt-8 text-base font-semibold text-[var(--accent)]">4. 쿠키 및 광고</h2>
      <p className="mt-3 text-[#9CA3AF]">
        서비스에 노출되는 광고 영역은 부트캠프 자체 홍보 이미지로, 외부 광고 네트워크·추적 쿠키를 사용하지 않습니다.
      </p>

      <h2 className="mt-8 text-base font-semibold text-[var(--accent)]">5. 보유 기간</h2>
      <p className="mt-3 text-[#9CA3AF]">
        서비스는 사용자 정보를 별도로 저장·보관하지 않으므로, 브라우저를 새로고침하거나 종료하면 입력했던 부품 선택·설문
        답변은 즉시 사라집니다.
      </p>

      <h2 className="mt-8 text-base font-semibold text-[var(--accent)]">6. 이용자 권리 및 문의</h2>
      <p className="mt-3 text-[#9CA3AF]">
        본 서비스는 개인정보를 별도로 저장하지 않아 열람·정정·삭제를 요청할 대상 데이터가 없습니다. 문의사항은 아래
        저장소의 Issue를 통해 남겨주세요.
      </p>
      <p className="mt-3">
        <a href={`${REPO_URL}/issues`} target="_blank" rel="noreferrer" className="text-[var(--accent)] underline">
          {REPO_URL}/issues
        </a>
      </p>

      <h2 className="mt-8 text-base font-semibold text-[var(--accent)]">7. 방침 변경</h2>
      <p className="mt-3 text-[#9CA3AF]">
        본 방침은 서비스 기능 변경에 따라 개정될 수 있으며, 개정 시 본 페이지를 통해 고지합니다.
      </p>
    </div>
  );
}
