-- ============================================
-- MIGRATION 1 : COUPLE_AI_USAGE
-- Tracking tokens IA + quotas mensuels
-- ============================================

-- 1. CREATE TABLE
CREATE TABLE IF NOT EXISTS public.couple_ai_usage (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    relation_id UUID NOT NULL REFERENCES public.relations(id) ON DELETE CASCADE,

    -- Période de tracking (mois calendaire)
    usage_month DATE NOT NULL, -- Format YYYY-MM-01

    -- Compteurs tokens par type d'appel
    tokens_classifier INTEGER DEFAULT 0, -- Haiku, ~60 tokens/call
    tokens_coach INTEGER DEFAULT 0,      -- Sonnet, ~120 tokens/call
    tokens_monthly INTEGER DEFAULT 0,    -- Sonnet, ~800 tokens/call
    tokens_total INTEGER GENERATED ALWAYS AS (
        tokens_classifier + tokens_coach + tokens_monthly
    ) STORED,

    -- Compteurs appels
    calls_classifier INTEGER DEFAULT 0,
    calls_coach INTEGER DEFAULT 0,
    calls_monthly INTEGER DEFAULT 0,

    -- Métadonnées
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    -- Contraintes
    CONSTRAINT couple_ai_usage_unique_month UNIQUE(relation_id, usage_month),
    CONSTRAINT tokens_positive CHECK (
        tokens_classifier >= 0 AND
        tokens_coach >= 0 AND
        tokens_monthly >= 0
    )
);

-- 2. INDEXES
CREATE INDEX idx_couple_ai_usage_relation ON public.couple_ai_usage(relation_id);
CREATE INDEX idx_couple_ai_usage_month ON public.couple_ai_usage(usage_month);

-- 3. RLS POLICIES
ALTER TABLE public.couple_ai_usage ENABLE ROW LEVEL SECURITY;

-- Policy : Lecture (membres du couple uniquement)
CREATE POLICY "Users can view their couple AI usage"
    ON public.couple_ai_usage
    FOR SELECT
    USING (
        relation_id IN (
            SELECT relation_id
            FROM public.relation_members
            WHERE user_id = auth.uid()
        )
    );

-- Policy : Pas d'écriture directe (seulement via Edge Functions)
-- Les Edge Functions utilisent le service_role key qui bypass RLS

-- 4. FUNCTION : Incrémenter usage IA
CREATE OR REPLACE FUNCTION public.increment_ai_usage(
    p_relation_id UUID,
    p_type TEXT, -- 'classifier' | 'coach' | 'monthly'
    p_tokens INTEGER,
    p_month DATE DEFAULT DATE_TRUNC('month', NOW())
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER -- Exécute avec droits owner (bypass RLS)
AS $$
DECLARE
    v_usage_month DATE;
    v_quota_exceeded BOOLEAN;
    v_current_total INTEGER;
BEGIN
    -- Normaliser le mois (toujours 1er du mois)
    v_usage_month := DATE_TRUNC('month', p_month);

    -- Upsert : créer ou mettre à jour le compteur
    INSERT INTO public.couple_ai_usage (
        relation_id,
        usage_month,
        tokens_classifier,
        tokens_coach,
        tokens_monthly,
        calls_classifier,
        calls_coach,
        calls_monthly
    )
    VALUES (
        p_relation_id,
        v_usage_month,
        CASE WHEN p_type = 'classifier' THEN p_tokens ELSE 0 END,
        CASE WHEN p_type = 'coach' THEN p_tokens ELSE 0 END,
        CASE WHEN p_type = 'monthly' THEN p_tokens ELSE 0 END,
        CASE WHEN p_type = 'classifier' THEN 1 ELSE 0 END,
        CASE WHEN p_type = 'coach' THEN 1 ELSE 0 END,
        CASE WHEN p_type = 'monthly' THEN 1 ELSE 0 END
    )
    ON CONFLICT (relation_id, usage_month)
    DO UPDATE SET
        tokens_classifier = couple_ai_usage.tokens_classifier +
            CASE WHEN p_type = 'classifier' THEN p_tokens ELSE 0 END,
        tokens_coach = couple_ai_usage.tokens_coach +
            CASE WHEN p_type = 'coach' THEN p_tokens ELSE 0 END,
        tokens_monthly = couple_ai_usage.tokens_monthly +
            CASE WHEN p_type = 'monthly' THEN p_tokens ELSE 0 END,
        calls_classifier = couple_ai_usage.calls_classifier +
            CASE WHEN p_type = 'classifier' THEN 1 ELSE 0 END,
        calls_coach = couple_ai_usage.calls_coach +
            CASE WHEN p_type = 'coach' THEN 1 ELSE 0 END,
        calls_monthly = couple_ai_usage.calls_monthly +
            CASE WHEN p_type = 'monthly' THEN 1 ELSE 0 END,
        updated_at = NOW()
    RETURNING tokens_total INTO v_current_total;

    -- Check quota (20k tokens/mois max)
    v_quota_exceeded := v_current_total > 20000;

    RETURN jsonb_build_object(
        'success', true,
        'current_total', v_current_total,
        'quota_exceeded', v_quota_exceeded,
        'remaining', GREATEST(0, 20000 - v_current_total)
    );
END;
$$;

-- 5. TRIGGER : Updated_at automatique
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_updated_at
    BEFORE UPDATE ON public.couple_ai_usage
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_updated_at();

-- 6. GRANT PERMISSIONS
GRANT SELECT ON public.couple_ai_usage TO authenticated;
GRANT EXECUTE ON FUNCTION public.increment_ai_usage TO service_role;

-- 7. COMMENTAIRES
COMMENT ON TABLE public.couple_ai_usage IS 'Tracking mensuel des tokens IA par couple (quota 20k/mois)';
COMMENT ON FUNCTION public.increment_ai_usage IS 'Incrémente usage IA et vérifie quota. Appelé uniquement par Edge Functions.';