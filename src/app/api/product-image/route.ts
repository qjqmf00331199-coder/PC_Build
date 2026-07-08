import { NextRequest } from "next/server";

export interface ProductInfo {
  image: string | null;
  price: number | null;
  link: string | null;
  mallName: string | null;
}

const EMPTY: ProductInfo = { image: null, price: null, link: null, mallName: null };

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

  const url = `https://openapi.naver.com/v1/search/shop.json?query=${encodeURIComponent(query)}&display=1&sort=sim`;

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
    const item = data.items?.[0];
    const image: string | null = item?.image ?? null;
    const price: number | null = item?.lprice ? Number(item.lprice) : null;
    const link: string | null = item?.link ?? null;
    const mallName: string | null = item?.mallName ?? null;
    return Response.json({ image, price: Number.isFinite(price) ? price : null, link, mallName });
  } catch {
    return Response.json(EMPTY);
  }
}
