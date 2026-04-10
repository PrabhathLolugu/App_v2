-- Craft catalog tables for map/detail/shop experience.
-- Isolated from sacred_locations/site_details and fabric tables.

CREATE TABLE IF NOT EXISTS public.craft_hubs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    slug TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    region TEXT NOT NULL,
    state TEXT,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    craft_name TEXT NOT NULL,
    short_description TEXT NOT NULL,
    about_place_and_craft TEXT NOT NULL,
    history TEXT,
    cultural_significance TEXT,
    making_process TEXT,
    materials TEXT,
    motifs_and_style TEXT,
    care_and_authenticity TEXT,
    best_buying_season TEXT,
    cover_image_url TEXT,
    gallery_urls TEXT[] NOT NULL DEFAULT '{}',
    discussion_site_id UUID NOT NULL UNIQUE,
    sort_order INT NOT NULL DEFAULT 0,
    is_published BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.craft_sellers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    craft_hub_id UUID NOT NULL REFERENCES public.craft_hubs(id) ON DELETE CASCADE,
    seller_name TEXT NOT NULL,
    organization TEXT NOT NULL,
    seller_type TEXT NOT NULL CHECK (seller_type IN ('government', 'cooperative', 'verified')),
    contact_line TEXT,
    website TEXT,
    city TEXT,
    is_featured BOOLEAN NOT NULL DEFAULT FALSE,
    display_order INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.craft_seller_submissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    craft_hub_id UUID NOT NULL REFERENCES public.craft_hubs(id) ON DELETE CASCADE,
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

CREATE INDEX IF NOT EXISTS idx_craft_hubs_published_order
    ON public.craft_hubs(is_published, sort_order, name);
CREATE INDEX IF NOT EXISTS idx_craft_hubs_region
    ON public.craft_hubs(region);
CREATE INDEX IF NOT EXISTS idx_craft_hubs_discussion_site_id
    ON public.craft_hubs(discussion_site_id);

CREATE INDEX IF NOT EXISTS idx_craft_sellers_hub_order
    ON public.craft_sellers(craft_hub_id, display_order);
CREATE INDEX IF NOT EXISTS idx_craft_seller_submissions_status_created
    ON public.craft_seller_submissions(status, created_at DESC);

-- Reuse global timestamp trigger function if present.
CREATE OR REPLACE FUNCTION public.set_updated_at_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_craft_hubs_updated_at ON public.craft_hubs;
CREATE TRIGGER trg_craft_hubs_updated_at
    BEFORE UPDATE ON public.craft_hubs
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at_timestamp();

DROP TRIGGER IF EXISTS trg_craft_sellers_updated_at ON public.craft_sellers;
CREATE TRIGGER trg_craft_sellers_updated_at
    BEFORE UPDATE ON public.craft_sellers
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at_timestamp();

DROP TRIGGER IF EXISTS trg_craft_seller_submissions_updated_at ON public.craft_seller_submissions;
CREATE TRIGGER trg_craft_seller_submissions_updated_at
    BEFORE UPDATE ON public.craft_seller_submissions
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at_timestamp();

ALTER TABLE public.craft_hubs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.craft_sellers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.craft_seller_submissions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public can read published craft hubs" ON public.craft_hubs;
CREATE POLICY "Public can read published craft hubs"
    ON public.craft_hubs
    FOR SELECT
    USING (is_published = TRUE);

DROP POLICY IF EXISTS "Public can read craft sellers" ON public.craft_sellers;
CREATE POLICY "Public can read craft sellers"
    ON public.craft_sellers
    FOR SELECT
    USING (TRUE);

DROP POLICY IF EXISTS "Authenticated users can submit craft seller suggestions" ON public.craft_seller_submissions;
CREATE POLICY "Authenticated users can submit craft seller suggestions"
    ON public.craft_seller_submissions
    FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() IS NOT NULL);

DROP POLICY IF EXISTS "Users can read own craft seller submissions" ON public.craft_seller_submissions;
CREATE POLICY "Users can read own craft seller submissions"
    ON public.craft_seller_submissions
    FOR SELECT
    TO authenticated
    USING (submitted_by = auth.uid());

GRANT ALL ON public.craft_hubs TO service_role;
GRANT ALL ON public.craft_sellers TO service_role;
GRANT ALL ON public.craft_seller_submissions TO service_role;

