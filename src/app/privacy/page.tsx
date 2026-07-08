import type { Metadata } from "next";
import { LegalPage } from "@/components/legal-page";
import { PrivacyContent } from "@/components/legal-content";

export const metadata: Metadata = {
  title: "개인정보처리방침 | 트라이핏 (TriFit)",
};

export default function PrivacyPage() {
  return (
    <LegalPage>
      <PrivacyContent />
    </LegalPage>
  );
}
