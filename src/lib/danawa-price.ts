import type { DanawaPriceInfo } from "@/app/api/danawa-price/route";

const cache = new Map<string, DanawaPriceInfo>();
const inFlight = new Map<string, Promise<DanawaPriceInfo>>();

const EMPTY: DanawaPriceInfo = { price: null, link: null, title: null };

export function fetchDanawaPrice(query: string): Promise<DanawaPriceInfo> {
  const cached = cache.get(query);
  if (cached !== undefined) return Promise.resolve(cached);

  const pending = inFlight.get(query);
  if (pending) return pending;

  const request = fetch(`/api/danawa-price?q=${encodeURIComponent(query)}`)
    .then((res) => res.json())
    .then((data: DanawaPriceInfo) => {
      cache.set(query, data);
      inFlight.delete(query);
      return data;
    })
    .catch(() => {
      inFlight.delete(query);
      return EMPTY;
    });

  inFlight.set(query, request);
  return request;
}
