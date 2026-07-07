import { NextRequest } from "next/server";
import * as cheerio from "cheerio";

export interface DanawaPriceInfo {
  price: number | null;
  link: string | null;
  title: string | null;
}

const EMPTY: DanawaPriceInfo = { price: null, link: null, title: null };

const HEADERS = {
  "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:106.0) Gecko/20100101 Firefox/106.0",
  Host: "search.danawa.com",
};

export async function GET(req: NextRequest) {
  const query = req.nextUrl.searchParams.get("q")?.trim();
  if (!query) {
    return Response.json(EMPTY);
  }

  try {
    const res = await fetch(
      `https://search.danawa.com/dsearch.php?query=${encodeURIComponent(query)}&tab=main`,
      { headers: HEADERS, next: { revalidate: 60 * 60 * 24 } }
    );
    if (!res.ok) {
      return Response.json(EMPTY);
    }

    const html = await res.text();
    const $ = cheerio.load(html);

    const firstItem = $("div.main_prodlist.main_prodlist_list ul.product_list li.prod_item").first();
    if (firstItem.length === 0) {
      return Response.json(EMPTY);
    }

    const rawId = firstItem.attr("id");
    const code = rawId?.replace("productItem", "");
    if (!code) {
      return Response.json(EMPTY);
    }

    const priceValue = $(`input#min_price_${code}`).attr("value");
    const price = priceValue ? Number(priceValue) : null;
    const title = firstItem.find("div.prod_main_info > div.prod_info > p.prod_name > a").text().trim() || null;
    const link = `https://prod.danawa.com/info/?pcode=${code}`;

    return Response.json({
      price: price !== null && Number.isFinite(price) ? price : null,
      link,
      title,
    });
  } catch {
    return Response.json(EMPTY);
  }
}
