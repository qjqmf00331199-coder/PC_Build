"use client";

import { useEffect, useState } from "react";
import type { Part } from "./types";
import { localImageOverride } from "./local-images";
import { partImageQuery } from "./part-specs";
import type { ProductInfo } from "@/app/api/product-image/route";

const EMPTY: ProductInfo = { image: null, price: null, link: null, mallName: null };

const infoCache = new Map<string, ProductInfo>();
const inFlight = new Map<string, Promise<ProductInfo>>();

function fetchProductInfo(query: string): Promise<ProductInfo> {
  const cached = infoCache.get(query);
  if (cached !== undefined) return Promise.resolve(cached);

  const pending = inFlight.get(query);
  if (pending) return pending;

  const request = fetch(`/api/product-image?q=${encodeURIComponent(query)}`)
    .then((res) => res.json())
    .then((data: ProductInfo) => {
      infoCache.set(query, data);
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

export function useProductInfo(part: Part | null): ProductInfo {
  const override = part ? localImageOverride(part) : null;
  const query = part ? partImageQuery(part) : null;
  const [info, setInfo] = useState<ProductInfo>(query ? infoCache.get(query) ?? EMPTY : EMPTY);

  useEffect(() => {
    if (!query) {
      setInfo(EMPTY);
      return;
    }

    const cached = infoCache.get(query);
    if (cached !== undefined) {
      setInfo(cached);
      return;
    }

    let active = true;
    setInfo(EMPTY);

    fetchProductInfo(query).then((data) => {
      if (active) setInfo(data);
    });

    return () => {
      active = false;
    };
  }, [query]);

  return override ? { ...info, image: override } : info;
}

export function formatPriceKrw(price: number): string {
  return `${price.toLocaleString("ko-KR")}원`;
}
