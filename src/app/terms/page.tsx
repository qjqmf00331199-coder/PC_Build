import type { Metadata } from "next";
import { LegalPage } from "@/components/legal-page";
import { TermsContent } from "@/components/legal-content";

export const metadata: Metadata = {
  title: "이용약관 | 트라이핏 (TriFit)",
};

export default function TermsPage() {
  return (
    <LegalPage>
      <TermsContent />
    </LegalPage>
  );
}
