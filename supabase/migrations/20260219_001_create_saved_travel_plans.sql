-- Migration: Create saved_travel_plans for persisting pilgrimage plans

CREATE TABLE IF NOT EXISTS public.saved_travel_plans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    plan TEXT NOT NULL,
    from_location TEXT,
    start_date DATE,
    end_date DATE,
    destination_id INT,
    destination_name TEXT,
    destination_region TEXT,
    destination_image TEXT,
    title TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_saved_travel_plans_user_id
    ON public.saved_travel_plans(user_id);

CREATE INDEX IF NOT EXISTS idx_saved_travel_plans_created_at
    ON public.saved_travel_plans(created_at DESC);

ALTER TABLE public.saved_travel_plans ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own saved plans"
    ON public.saved_travel_plans FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own saved plans"
    ON public.saved_travel_plans FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own saved plans"
    ON public.saved_travel_plans FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own saved plans"
    ON public.saved_travel_plans FOR DELETE
    USING (auth.uid() = user_id);

-- Ensure the updated_at trigger function exists (may already exist from chat tables migration)
CREATE OR REPLACE FUNCTION public.update_chat_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_saved_travel_plans_updated_at
    BEFORE UPDATE ON public.saved_travel_plans
    FOR EACH ROW
    EXECUTE FUNCTION update_chat_updated_at();

GRANT ALL ON public.saved_travel_plans TO service_role;
