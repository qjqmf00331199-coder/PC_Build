import type { Part } from "./types";

// 네이버 쇼핑 검색 이미지가 틀리거나 검색 결과가 아예 없는 부품은 여기에 등록.
// public/product-images/ 안에 파일을 넣고 아래 키를 "카테고리:model명"(카드에 보이는 모델명 그대로)으로 추가하면
// 네이버 API 호출 없이 이 파일을 바로 씀.
export const LOCAL_IMAGE_OVERRIDES: Record<string, string> = {
  "case:HYTE Y70": "/product-images/hyte-y70.jpg",
  "case:ASUS ROG Strix Helios II 하츠네 미쿠 에디션": "/product-images/miku-case.jpg",
};

export function localImageOverride(part: Part): string | null {
  return LOCAL_IMAGE_OVERRIDES[`${part.category}:${part.model}`] ?? null;
}
