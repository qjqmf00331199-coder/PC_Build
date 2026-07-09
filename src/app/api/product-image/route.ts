import { NextRequest } from "next/server";

export interface ProductInfo {
  image: string | null;
  price: number | null;
  link: string | null;
  mallName: string | null;
}

const EMPTY: ProductInfo = { image: null, price: null, link: null, mallName: null };

// 완본체/조립 PC로 묶여 파는 상품 제목에 흔히 붙는 키워드. 하나라도 있으면 단품이 아니라고 보고 제외.
const BUNDLE_EXCLUDE_KEYWORDS = [
  "완본체",
  "본체",
  "조립컴퓨터",
  "조립PC",
  "조립 PC",
  "조립피씨",
  "게이밍컴퓨터",
  "게이밍 컴퓨터",
  "풀세트",
  "풀패키지",
  "세트할인",
  "컴퓨터본체",
];

function stripHtmlTags(text: string): string {
  return text.replace(/<[^>]*>/g, "");
}

function isBundleProduct(title: string): boolean {
  const plain = stripHtmlTags(title);
  return BUNDLE_EXCLUDE_KEYWORDS.some((keyword) => plain.includes(keyword));
}

export async function GET(req: NextRequest) {
  const query = req.nextUrl.searchParams.get("q")?.trim();
  if (!query) {
    return Response.json(EMPTY);
  }

  const clientId = process.env.NAVER_CLIENT_ID;
  const clientSecret = process.env.NAVER_CLIENT_SECRET;
  if (!clientId || !clientSecret) {
    return Response.json(EMPTY);
  }

  const url = `https://openapi.naver.com/v1/search/shop.json?query=${encodeURIComponent(query)}&display=30&sort=sim`;

  try {
    const res = await fetch(url, {
      headers: {
        "X-Naver-Client-Id": clientId,
        "X-Naver-Client-Secret": clientSecret,
      },
      next: { revalidate: 60 * 60 * 24 },
    });
    if (!res.ok) {
      return Response.json(EMPTY);
    }
    const data = await res.json();
    const items: Array<{ title?: string; image?: string; lprice?: string; link?: string; mallName?: string }> =
      data.items ?? [];
    const item = items.find((candidate) => !isBundleProduct(candidate.title ?? "")) ?? null;
    const image: string | null = item?.image ?? null;
    const price: number | null = item?.lprice ? Number(item.lprice) : null;
    const link: string | null = item?.link ?? null;
    const mallName: string | null = item?.mallName ?? null;
    return Response.json({ image, price: Number.isFinite(price) ? price : null, link, mallName });
  } catch {
    return Response.json(EMPTY);
  }
}
