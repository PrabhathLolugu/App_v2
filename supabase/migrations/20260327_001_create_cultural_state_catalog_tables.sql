-- State-level classical culture catalog (artforms + dances).
-- This feature intentionally maps to states/UTs, not city locations.

CREATE TABLE IF NOT EXISTS public.cultural_state_hubs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category TEXT NOT NULL CHECK (category IN ('classical_art', 'classical_dance')),
    slug TEXT NOT NULL UNIQUE,
    state_code TEXT NOT NULL,
    state_name TEXT NOT NULL,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    pin_hide_zoom_max DOUBLE PRECISION NOT NULL DEFAULT 8.0,
    sort_order INT NOT NULL DEFAULT 0,
    is_published BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (category, state_code)
);

CREATE TABLE IF NOT EXISTS public.cultural_state_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    hub_id UUID NOT NULL REFERENCES public.cultural_state_hubs(id) ON DELETE CASCADE,
    item_name TEXT NOT NULL,
    short_description TEXT NOT NULL,
    about_state_tradition TEXT NOT NULL,
    history TEXT,
    cultural_significance TEXT,
    practice_and_pedagogy TEXT,
    performance_context TEXT,
    notable_exponents TEXT,
    discussion_site_id UUID NOT NULL UNIQUE,
    cover_image_url TEXT,
    gallery_urls TEXT[] NOT NULL DEFAULT '{}',
    sort_order INT NOT NULL DEFAULT 0,
    is_published BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.cultural_item_submissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category TEXT NOT NULL CHECK (category IN ('classical_art', 'classical_dance')),
    hub_id UUID REFERENCES public.cultural_state_hubs(id) ON DELETE SET NULL,
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

CREATE INDEX IF NOT EXISTS idx_cultural_hubs_category_state
    ON public.cultural_state_hubs(category, state_name, sort_order);
CREATE INDEX IF NOT EXISTS idx_cultural_hubs_published_order
    ON public.cultural_state_hubs(is_published, sort_order);
CREATE INDEX IF NOT EXISTS idx_cultural_items_hub_order
    ON public.cultural_state_items(hub_id, sort_order);
CREATE INDEX IF NOT EXISTS idx_cultural_items_discussion_site
    ON public.cultural_state_items(discussion_site_id);
CREATE INDEX IF NOT EXISTS idx_cultural_submissions_status_created
    ON public.cultural_item_submissions(status, created_at DESC);

CREATE OR REPLACE FUNCTION public.set_updated_at_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_cultural_hubs_updated_at ON public.cultural_state_hubs;
CREATE TRIGGER trg_cultural_hubs_updated_at
    BEFORE UPDATE ON public.cultural_state_hubs
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at_timestamp();

DROP TRIGGER IF EXISTS trg_cultural_items_updated_at ON public.cultural_state_items;
CREATE TRIGGER trg_cultural_items_updated_at
    BEFORE UPDATE ON public.cultural_state_items
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at_timestamp();

DROP TRIGGER IF EXISTS trg_cultural_submissions_updated_at ON public.cultural_item_submissions;
CREATE TRIGGER trg_cultural_submissions_updated_at
    BEFORE UPDATE ON public.cultural_item_submissions
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at_timestamp();

ALTER TABLE public.cultural_state_hubs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cultural_state_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cultural_item_submissions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public can read published cultural hubs" ON public.cultural_state_hubs;
CREATE POLICY "Public can read published cultural hubs"
    ON public.cultural_state_hubs
    FOR SELECT
    USING (is_published = TRUE);

DROP POLICY IF EXISTS "Public can read published cultural items" ON public.cultural_state_items;
CREATE POLICY "Public can read published cultural items"
    ON public.cultural_state_items
    FOR SELECT
    USING (is_published = TRUE);

DROP POLICY IF EXISTS "Authenticated users can submit cultural items" ON public.cultural_item_submissions;
CREATE POLICY "Authenticated users can submit cultural items"
    ON public.cultural_item_submissions
    FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() IS NOT NULL);

DROP POLICY IF EXISTS "Users can read own cultural submissions" ON public.cultural_item_submissions;
CREATE POLICY "Users can read own cultural submissions"
    ON public.cultural_item_submissions
    FOR SELECT
    TO authenticated
    USING (submitted_by = auth.uid());

GRANT ALL ON public.cultural_state_hubs TO service_role;
GRANT ALL ON public.cultural_state_items TO service_role;
GRANT ALL ON public.cultural_item_submissions TO service_role;

