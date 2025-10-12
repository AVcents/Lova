import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

// Récupération des secrets
const OPENAI_API_KEY = Deno.env.get('OPENAI_API_KEY')
const SUPABASE_URL = Deno.env.get('SUPABASE_URL')
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')

/**
 * Génère un résumé de secours en cas d'échec OpenAI
 */
function generateFallbackInsight(stats: any, correlations: any): string {
  const avgMood = stats.average_mood || 0
  const checkinCount = stats.checkin_count || 0
  const positiveDays = stats.positive_days || 0

  let sentiment: string
  if (avgMood >= 3.5) {
    sentiment = 'Ce mois a été globalement positif'
  } else if (avgMood >= 2.5) {
    sentiment = 'Ce mois a présenté des hauts et des bas'
  } else {
    sentiment = 'Ce mois a été plus difficile'
  }

  const topTriggers = (stats.top_triggers || [])
    .slice(0, 2)
    .map((t: any) => t.name)
    .join(' et ') || 'divers facteurs'

  const impactDiff = correlations.impact_difference || 0
  const ritualEffect = impactDiff > 0.5
    ? `Les jours avec rituels montrent une amélioration notable de l'humeur (+${impactDiff.toFixed(1)} points en moyenne).`
    : 'Continuer les rituels quotidiens peut aider à maintenir un bien-être stable.'

  return `${sentiment} avec ${checkinCount} check-ins effectués et une humeur moyenne de ${avgMood.toFixed(1)}/5.

${positiveDays} jours ont été marqués par une humeur positive. Les déclencheurs les plus fréquents étaient ${topTriggers}.

${ritualEffect}

Pour le mois prochain, maintenir une pratique régulière des rituels et rester attentif aux déclencheurs identifiés peut être bénéfique.`
}

/**
 * Appel à l'API OpenAI pour générer l'insight
 */
async function callOpenAI(prompt: string): Promise<string> {
  if (!OPENAI_API_KEY) {
    throw new Error('OPENAI_API_KEY non configurée')
  }

  const response = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${OPENAI_API_KEY}`,
    },
    body: JSON.stringify({
      model: 'gpt-4o',
      messages: [
        {
          role: 'system',
          content: 'Vous êtes Loova, un assistant bienveillant spécialisé dans l\'accompagnement au bien-être. Vous analysez des données émotionnelles de manière factuelle et encourageante, sans jamais diagnostiquer. Vos analyses sont concises (300-400 mots), empathiques et orientées action.'
        },
        { role: 'user', content: prompt }
      ],
      max_tokens: 800,
      temperature: 0.7
    })
  })

  if (!response.ok) {
    const errorData = await response.json().catch(() => ({}))
    throw new Error(`OpenAI API error: ${response.status} - ${JSON.stringify(errorData)}`)
  }

  const data = await response.json()

  if (data.error) {
    throw new Error(`OpenAI error: ${data.error.message}`)
  }

  if (!data.choices || !data.choices[0] || !data.choices[0].message) {
    throw new Error('Format de réponse OpenAI invalide')
  }

  return data.choices[0].message.content
}

serve(async (req) => {
  // Gestion CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    console.log('[generate-monthly-insight] Début de la requête')

    // Validation des secrets
    if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY) {
      throw new Error('Configuration Supabase manquante (URL ou SERVICE_ROLE_KEY)')
    }

    // Création du client Supabase avec service role (bypass RLS)
    const supabaseAdmin = createClient(
      SUPABASE_URL,
      SUPABASE_SERVICE_ROLE_KEY,
      {
        auth: {
          autoRefreshToken: false,
          persistSession: false
        }
      }
    )

    // Parsing et validation des paramètres
    const { user_id, year, month, prompt, stats, correlations } = await req.json()

    if (!user_id || !year || !month || !prompt) {
      return new Response(
        JSON.stringify({
          error: 'Paramètres manquants',
          required: ['user_id', 'year', 'month', 'prompt']
        }),
        {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' }
        }
      )
    }

    // Validation des types
    if (typeof year !== 'number' || typeof month !== 'number') {
      return new Response(
        JSON.stringify({ error: 'year et month doivent être des nombres' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    if (month < 1 || month > 12) {
      return new Response(
        JSON.stringify({ error: 'month doit être entre 1 et 12' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    console.log(`[generate-monthly-insight] Génération pour user=${user_id}, ${year}-${month}`)

    // Vérifier que l'enregistrement existe
    const { data: existing, error: checkError } = await supabaseAdmin
      .from('me_monthly_analyses')
      .select('id, ai_insight')
      .eq('user_id', user_id)
      .eq('year', year)
      .eq('month', month)
      .maybeSingle()

    if (checkError) {
      console.error('[generate-monthly-insight] Erreur vérification:', checkError)
      throw new Error(`Erreur vérification base: ${checkError.message}`)
    }

    if (!existing) {
      return new Response(
        JSON.stringify({
          error: 'Aucune analyse trouvée pour cette période. Créez d\'abord l\'entrée avec stats/correlations.'
        }),
        { status: 404, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Si ai_insight existe déjà, on peut soit le régénérer soit retourner l'existant
    if (existing.ai_insight && existing.ai_insight.trim()) {
      console.log('[generate-monthly-insight] ai_insight existe déjà, régénération...')
    }

    // Tentative d'appel OpenAI
    let aiInsight: string
    let usedFallback = false

    try {
      aiInsight = await callOpenAI(prompt)
      console.log('[generate-monthly-insight] OpenAI success')
    } catch (openaiError) {
      console.error('[generate-monthly-insight] Erreur OpenAI:', openaiError)

      // Fallback : génération simple basée sur stats
      if (stats && correlations) {
        aiInsight = generateFallbackInsight(stats, correlations)
        usedFallback = true
        console.log('[generate-monthly-insight] Utilisation du fallback')
      } else {
        throw new Error(`Échec OpenAI et pas de données pour fallback: ${openaiError.message}`)
      }
    }

    // Update en base
    const { error: updateError } = await supabaseAdmin
      .from('me_monthly_analyses')
      .update({
        ai_insight: aiInsight,
        updated_at: new Date().toISOString()
      })
      .eq('user_id', user_id)
      .eq('year', year)
      .eq('month', month)

    if (updateError) {
      console.error('[generate-monthly-insight] Erreur update:', updateError)
      throw new Error(`Erreur update base: ${updateError.message}`)
    }

    console.log('[generate-monthly-insight] Update réussi')

    // Réponse de succès
    return new Response(
      JSON.stringify({
        ok: true,
        insight: aiInsight,
        used_fallback: usedFallback,
        user_id,
        year,
        month
      }),
      {
        status: 200,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      }
    )

  } catch (error) {
    console.error('[generate-monthly-insight] Erreur générale:', error)

    return new Response(
      JSON.stringify({
        error: error.message || 'Erreur interne',
        details: error.toString()
      }),
      {
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      }
    )
  }
})