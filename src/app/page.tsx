import { LandingGate } from "@/components/landing-gate";
import { getAllParts } from "@/lib/supabase/fetch-parts";

export const dynamic = "force-dynamic";

export default async function Home() {
  const parts = await getAllParts();
  return <LandingGate parts={parts} />;
}
