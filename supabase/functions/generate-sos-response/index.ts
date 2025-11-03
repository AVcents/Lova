import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.0";

const MISTRAL_API_KEY = Deno.env.get("MISTRAL_API_KEY")!;
const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

interface SOSRequest {
  session_id: string;
  user_message: string;
  relation_id: string;
  user_id: string;
}

interface SOSResponse {
  ai_message: string;
  tokens_used: number;
  max_turns_reached: boolean;
  error?: string;
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
    const { session_id, user_message, relation_id, user_id }: SOSRequest = await req.json();

    if (!session_id || !user_message || !relation_id || !user_id) {
      throw new Error("Missing required fields");
    }

    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

    // 1. Vérifier quota
    const currentMonth = new Date().toISOString().slice(0, 7) + "-01";
    const { data: usage } = await supabase
      .from("couple_ai_usage")
      .select("tokens_total")
      .eq("relation_id", relation_id)
      .eq("usage_month", currentMonth)
      .single();

    if ((usage?.tokens_total || 0) >= 20000) {
      return new Response(
        JSON.stringify({
          error: "Quota mensuel dépassé. Votre limite sera réinitialisée le 1er du mois prochain.",
          ai_message: "Je ne peux plus répondre ce mois-ci. Quota atteint.",
          tokens_used: 0,
          max_turns_reached: false,
        }),
        { status: 429, headers: { "Content-Type": "application/json" } }
      );
    }

    // 2. Récupérer session + historique
    const { data: session, error: sessionError } = await supabase
      .from("sos_sessions")
      .select("*")
      .eq("id", session_id)
      .single();

    if (sessionError || !session) {
      throw new Error("Session SOS introuvable");
    }

    // Vérifier limite 8 tours
    if (session.ai_responses >= 8) {
      await supabase
        .from("sos_sessions")
        .update({ max_turns_reached: true })
        .eq("id", session_id);

      return new Response(
        JSON.stringify({
          ai_message: "Nous avons atteint la limite de 8 échanges pour cette session. Si la tension persiste, je vous recommande de consulter un professionnel de la thérapie de couple.",
          tokens_used: 0,
          max_turns_reached: true,
        }),
        { status: 200, headers: { "Content-Type": "application/json" } }
      );
    }

    // 3. Récupérer historique conversation
    const { data: events } = await supabase
      .from("sos_events")
      .select("event_type, content, created_at")
      .eq("session_id", session_id)
      .order("created_at", { ascending: true });

    // Construire historique pour contexte IA
    const conversationHistory = events
      ?.filter((e) => ["user_message", "ai_response"].includes(e.event_type))
      .map((e) => ({
        role: e.event_type === "user_message" ? "user" : "assistant",
        content: e.content,
      })) || [];

    // 4. Enregistrer le message user
    await supabase.from("sos_events").insert({
      session_id,
      event_type: "user_message",
      user_id,
      content: user_message,
    });

    // 5. Appel Mistral Large
const systemPrompt = `Tu es LOOVA, médiateur de couple expert (Gottman + EFT).

RÈGLES ULTRA-STRICTES :
- MAX 25 MOTS par message (compte les mots !)
- 1 à 2 phrases COURTES max
- Ton SMS, pas email : direct, chaleureux, conversationnel
- 1 seule action OU question à la fois
- JAMAIS de listes numérotées
- JAMAIS d'explications théoriques
- Préfère les questions ouvertes aux affirmations

CONTEXTE SESSION :
Phase: ${session.current_phase} | Tour: ${session.turn_count}/3 | Intensité: ${session.intensity_level}/5
Départ: ${session.initial_emotion} - "${session.initial_description}"

OBJECTIF : Ralentir, écouter, connecter. Pas expliquer.

✅ EXEMPLES PARFAITS (≤25 mots) :
"Je comprends. Prenons 10 secondes pour respirer. Prêts ?"
"Merci d'avoir partagé. [Prénom], qu'est-ce que ça te fait d'entendre ça ?"
"Pause. Qu'est-ce dont vous avez le plus besoin là, maintenant ?"
"Je vous entends. [Prénom], qu'est-ce qui compte vraiment pour toi ici ?"

❌ EXEMPLES INTERDITS (trop longs/théoriques) :
"Je comprends que cette situation financière puisse être stressante. C'est normal de ressentir de la frustration quand..."
"Prenons un moment pour identifier les besoins de chacun dans cette situation et voir comment..."

RAPPEL : Tes messages doivent tenir dans une bulle SMS. Vise 15-20 mots.`;

    const mistralResponse = await fetch("https://api.mistral.ai/v1/chat/completions", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${MISTRAL_API_KEY}`,
      },
      body: JSON.stringify({
        model: "mistral-large-latest",
        messages: [
          { role: "system", content: systemPrompt },
          ...conversationHistory,
          { role: "user", content: user_message },
        ],
        temperature: 0.7,
        max_tokens: 150,  // Réduit de 250 à 150 pour forcer des réponses plus courtes
      }),
    });

    if (!mistralResponse.ok) {
      throw new Error(`Mistral API error: ${await mistralResponse.text()}`);
    }

    const mistralData = await mistralResponse.json();
    const aiMessage = mistralData.choices[0].message.content;
    const tokensUsed = mistralData.usage.total_tokens;

    // 6. Enregistrer réponse IA
    await supabase.from("sos_events").insert({
      session_id,
      event_type: "ai_response",
      content: aiMessage,
      ai_tokens_used: tokensUsed,
    });

    // 7. Incrémenter usage IA
    await supabase.rpc("increment_ai_usage", {
      p_relation_id: relation_id,
      p_type: "coach",
      p_tokens: tokensUsed,
    });

    // 8. Response
    const response: SOSResponse = {
      ai_message: aiMessage,
      tokens_used: tokensUsed,
      max_turns_reached: session.ai_responses + 1 >= 8,
    };

    return new Response(JSON.stringify(response), {
      status: 200,
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
      },
    });
  } catch (error) {
    console.error("SOS response error:", error);

    return new Response(
      JSON.stringify({
        error: error.message,
        ai_message: "Une erreur est survenue. Réessayez dans quelques instants.",
        tokens_used: 0,
        max_turns_reached: false,
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