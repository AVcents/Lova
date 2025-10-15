// supabase/functions/classifier-tone/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";

const MISTRAL_API_KEY = Deno.env.get("MISTRAL_API_KEY")!;
const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

interface ClassifierRequest {
  checkin_id: string;
  text: string; // Concatenation de gratitude + concern + need
  relation_id: string;
}

interface ClassifierResponse {
  tone: "positive" | "neutral" | "negative";
  tokens_used: number;
  error?: string;
}

serve(async (req) => {
  // CORS headers
  if (req.method === "OPTIONS") {
    return new Response("ok", {
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
      },
    });
  }

  try {
    // 1. Parse request
    const { checkin_id, text, relation_id }: ClassifierRequest = await req.json();

    if (!checkin_id || !text || !relation_id) {
      throw new Error("Missing required fields: checkin_id, text, relation_id");
    }

    // 2. Vérifier quota (20k tokens/mois max)
    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

    const currentMonth = new Date().toISOString().slice(0, 7) + "-01"; // YYYY-MM-01

    const { data: usage } = await supabase
      .from("couple_ai_usage")
      .select("tokens_total")
      .eq("relation_id", relation_id)
      .eq("usage_month", currentMonth)
      .single();

    const currentTokens = usage?.tokens_total || 0;

    if (currentTokens >= 20000) {
      return new Response(
        JSON.stringify({
          error: "Monthly quota exceeded (20,000 tokens)",
          tone: "neutral", // Fallback
          tokens_used: 0,
        }),
        {
          status: 429,
          headers: { "Content-Type": "application/json" },
        }
      );
    }

    // 3. Call Mistral API
    const mistralResponse = await fetch("https://api.mistral.ai/v1/chat/completions", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${MISTRAL_API_KEY}`,
      },
      body: JSON.stringify({
        model: "mistral-small-latest",
        messages: [
          {
            role: "system",
            content: `Tu es un classificateur de ton émotionnel pour une app de bien-être couple.
Analyse le texte et catégorise-le en UNE des 3 catégories suivantes :
- "positive" : gratitude, joie, amour, satisfaction, optimisme
- "neutral" : neutre, factuel, sans émotion marquée
- "negative" : frustration, tristesse, colère, préoccupation, tension

Réponds UNIQUEMENT avec un mot : positive, neutral, ou negative.`,
          },
          {
            role: "user",
            content: text,
          },
        ],
        temperature: 0.1,
        max_tokens: 10, // On attend juste 1 mot
      }),
    });

    if (!mistralResponse.ok) {
      const error = await mistralResponse.text();
      throw new Error(`Mistral API error: ${error}`);
    }

    const mistralData = await mistralResponse.json();
    const tone = mistralData.choices[0].message.content.trim().toLowerCase();

    // Valider la réponse
    const validTones = ["positive", "neutral", "negative"];
    const finalTone = validTones.includes(tone) ? tone : "neutral";

    const tokensUsed = mistralData.usage.total_tokens;

    // 4. Update couple_checkins
    await supabase
      .from("couple_checkins")
      .update({
        tone_detected: finalTone,
        ai_tokens_used: tokensUsed,
      })
      .eq("id", checkin_id);

    // 5. Increment AI usage
    await supabase.rpc("increment_ai_usage", {
      p_relation_id: relation_id,
      p_type: "classifier",
      p_tokens: tokensUsed,
    });

    // 6. Response
    const response: ClassifierResponse = {
      tone: finalTone as "positive" | "neutral" | "negative",
      tokens_used: tokensUsed,
    };

    return new Response(JSON.stringify(response), {
      status: 200,
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
      },
    });
  } catch (error) {
    console.error("Classifier error:", error);

    return new Response(
      JSON.stringify({
        error: error.message,
        tone: "neutral", // Fallback safe
        tokens_used: 0,
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