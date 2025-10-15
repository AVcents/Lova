import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

interface QuotaRequest {
  relation_id: string;
}

interface QuotaResponse {
  quota_exceeded: boolean;
  tokens_used: number;
  tokens_remaining: number;
  quota_limit: number;
}

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", {
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
      },
    });
  }

  try {
    const { relation_id }: QuotaRequest = await req.json();

    if (!relation_id) {
      throw new Error("Missing relation_id");
    }

    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

    // Mois actuel (format YYYY-MM-01)
    const currentMonth = new Date().toISOString().slice(0, 7) + "-01";
    const QUOTA_LIMIT = 20000;

    // Récupérer usage du mois
    const { data: usage, error } = await supabase
      .from("couple_ai_usage")
      .select("tokens_total")
      .eq("relation_id", relation_id)
      .eq("usage_month", currentMonth)
      .single();

    if (error && error.code !== "PGRST116") {
      // PGRST116 = no rows, c'est OK (premier appel du mois)
      throw error;
    }

    const tokensUsed = usage?.tokens_total || 0;
    const tokensRemaining = Math.max(0, QUOTA_LIMIT - tokensUsed);
    const quotaExceeded = tokensUsed >= QUOTA_LIMIT;

    const response: QuotaResponse = {
      quota_exceeded: quotaExceeded,
      tokens_used: tokensUsed,
      tokens_remaining: tokensRemaining,
      quota_limit: QUOTA_LIMIT,
    };

    return new Response(JSON.stringify(response), {
      status: 200,
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
      },
    });
  } catch (error) {
    console.error("Quota check error:", error);

    return new Response(
      JSON.stringify({
        error: error.message,
        quota_exceeded: true, // Safe fallback : bloquer si erreur
        tokens_used: 0,
        tokens_remaining: 0,
        quota_limit: 20000,
      }),
      {
        status: 500,
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*",
        },
      }
    );
  }
});