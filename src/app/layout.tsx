import type { Metadata } from "next";
import { Inter, JetBrains_Mono } from "next/font/google";
import "./globals.css";
import { AdSlots } from "@/components/ad-slots";

const inter = Inter({
  variable: "--font-inter",
  subsets: ["latin"],
});

const jetbrainsMono = JetBrains_Mono({
  variable: "--font-jetbrains-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "트라이핏 (TriFit) | PC 부품 호환성 체커",
  description: "CPU·메인보드·RAM·GPU 등 PC 부품 선택 시 실시간으로 호환성을 확인하는 도구",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="ko">
      <body className={`${inter.variable} ${jetbrainsMono.variable} antialiased`}>
        {children}
        <AdSlots />
      </body>
    </html>
  );
}
