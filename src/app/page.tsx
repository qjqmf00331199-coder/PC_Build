import { BuildChecker } from "@/components/build/build-checker";
import { getAllParts } from "@/lib/supabase/fetch-parts";

export const dynamic = "force-dynamic";

export default async function Home() {
  const parts = await getAllParts();
  return <BuildChecker parts={parts} />;
}
