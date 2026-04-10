-- State-level native cultural Hindu food catalog.
-- This feature maps foods to states/UTs (not cities).

CREATE TABLE IF NOT EXISTS public.food_state_hubs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    slug TEXT NOT NULL UNIQUE,
    state_code TEXT NOT NULL UNIQUE,
    state_name TEXT NOT NULL,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    pin_hide_zoom_max DOUBLE PRECISION NOT NULL DEFAULT 8.0,
    sort_order INT NOT NULL DEFAULT 0,
    is_published BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.food_state_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    hub_id UUID NOT NULL REFERENCES public.food_state_hubs(id) ON DELETE CASCADE,
    food_name TEXT NOT NULL,
    short_description TEXT NOT NULL,
    about_food TEXT NOT NULL,
    history TEXT,
    ingredients TEXT,
    preparation_style TEXT,
    serving_context TEXT,
    nutrition_notes TEXT,
    best_season TEXT,
    discussion_site_id UUID NOT NULL UNIQUE,
    cover_image_url TEXT,
    gallery_urls TEXT[] NOT NULL DEFAULT '{}',
    sort_order INT NOT NULL DEFAULT 0,
    is_published BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.food_item_submissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    hub_id UUID REFERENCES public.food_state_hubs(id) ON DELETE SET NULL,
    submitted_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    payload JSONB NOT NULL DEFAULT '{}'::jsonb,
    status TEXT NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'approved', 'rejected')),
    moderator_notes TEXT,
    reviewed_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    reviewed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_food_hubs_published_order
    ON public.food_state_hubs(is_published, sort_order, state_name);
CREATE INDEX IF NOT EXISTS idx_food_items_hub_order
    ON public.food_state_items(hub_id, sort_order);
CREATE INDEX IF NOT EXISTS idx_food_items_discussion_site
    ON public.food_state_items(discussion_site_id);
CREATE INDEX IF NOT EXISTS idx_food_submissions_status_created
    ON public.food_item_submissions(status, created_at DESC);

CREATE OR REPLACE FUNCTION public.set_updated_at_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_food_hubs_updated_at ON public.food_state_hubs;
CREATE TRIGGER trg_food_hubs_updated_at
    BEFORE UPDATE ON public.food_state_hubs
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at_timestamp();

DROP TRIGGER IF EXISTS trg_food_items_updated_at ON public.food_state_items;
CREATE TRIGGER trg_food_items_updated_at
    BEFORE UPDATE ON public.food_state_items
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at_timestamp();

DROP TRIGGER IF EXISTS trg_food_submissions_updated_at ON public.food_item_submissions;
CREATE TRIGGER trg_food_submissions_updated_at
    BEFORE UPDATE ON public.food_item_submissions
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at_timestamp();

ALTER TABLE public.food_state_hubs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.food_state_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.food_item_submissions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public can read published food hubs" ON public.food_state_hubs;
CREATE POLICY "Public can read published food hubs"
    ON public.food_state_hubs
    FOR SELECT
    USING (is_published = TRUE);

DROP POLICY IF EXISTS "Public can read published food items" ON public.food_state_items;
CREATE POLICY "Public can read published food items"
    ON public.food_state_items
    FOR SELECT
    USING (is_published = TRUE);

DROP POLICY IF EXISTS "Authenticated users can submit food items" ON public.food_item_submissions;
CREATE POLICY "Authenticated users can submit food items"
    ON public.food_item_submissions
    FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() IS NOT NULL);

DROP POLICY IF EXISTS "Users can read own food submissions" ON public.food_item_submissions;
CREATE POLICY "Users can read own food submissions"
    ON public.food_item_submissions
    FOR SELECT
    TO authenticated
    USING (submitted_by = auth.uid());

GRANT ALL ON public.food_state_hubs TO service_role;
GRANT ALL ON public.food_state_items TO service_role;
GRANT ALL ON public.food_item_submissions TO service_role;

