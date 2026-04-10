-- Fabric catalog tables for map/detail/shop experience.
-- Keeps sacred_locations/site_details untouched.

CREATE TABLE IF NOT EXISTS public.fabric_hubs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    slug TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    region TEXT NOT NULL,
    state TEXT,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    fabric_name TEXT NOT NULL,
    short_description TEXT NOT NULL,
    about_place_and_fabric TEXT NOT NULL,
    history TEXT,
    cultural_significance TEXT,
    weaving_process TEXT,
    motifs_and_design TEXT,
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

CREATE TABLE IF NOT EXISTS public.fabric_sellers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    fabric_hub_id UUID NOT NULL REFERENCES public.fabric_hubs(id) ON DELETE CASCADE,
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

CREATE TABLE IF NOT EXISTS public.fabric_seller_submissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    fabric_hub_id UUID NOT NULL REFERENCES public.fabric_hubs(id) ON DELETE CASCADE,
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

CREATE INDEX IF NOT EXISTS idx_fabric_hubs_published_order
    ON public.fabric_hubs(is_published, sort_order, name);
CREATE INDEX IF NOT EXISTS idx_fabric_hubs_region
    ON public.fabric_hubs(region);
CREATE INDEX IF NOT EXISTS idx_fabric_hubs_discussion_site_id
    ON public.fabric_hubs(discussion_site_id);

CREATE INDEX IF NOT EXISTS idx_fabric_sellers_hub_order
    ON public.fabric_sellers(fabric_hub_id, display_order);
CREATE INDEX IF NOT EXISTS idx_fabric_seller_submissions_status_created
    ON public.fabric_seller_submissions(status, created_at DESC);

CREATE OR REPLACE FUNCTION public.set_updated_at_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_fabric_hubs_updated_at ON public.fabric_hubs;
CREATE TRIGGER trg_fabric_hubs_updated_at
    BEFORE UPDATE ON public.fabric_hubs
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at_timestamp();

DROP TRIGGER IF EXISTS trg_fabric_sellers_updated_at ON public.fabric_sellers;
CREATE TRIGGER trg_fabric_sellers_updated_at
    BEFORE UPDATE ON public.fabric_sellers
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at_timestamp();

DROP TRIGGER IF EXISTS trg_fabric_seller_submissions_updated_at ON public.fabric_seller_submissions;
CREATE TRIGGER trg_fabric_seller_submissions_updated_at
    BEFORE UPDATE ON public.fabric_seller_submissions
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at_timestamp();

ALTER TABLE public.fabric_hubs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fabric_sellers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fabric_seller_submissions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public can read published fabric hubs" ON public.fabric_hubs;
CREATE POLICY "Public can read published fabric hubs"
    ON public.fabric_hubs
    FOR SELECT
    USING (is_published = TRUE);

DROP POLICY IF EXISTS "Public can read fabric sellers" ON public.fabric_sellers;
CREATE POLICY "Public can read fabric sellers"
    ON public.fabric_sellers
    FOR SELECT
    USING (TRUE);

DROP POLICY IF EXISTS "Authenticated users can submit seller suggestions" ON public.fabric_seller_submissions;
CREATE POLICY "Authenticated users can submit seller suggestions"
    ON public.fabric_seller_submissions
    FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() IS NOT NULL);

DROP POLICY IF EXISTS "Users can read own seller submissions" ON public.fabric_seller_submissions;
CREATE POLICY "Users can read own seller submissions"
    ON public.fabric_seller_submissions
    FOR SELECT
    TO authenticated
    USING (submitted_by = auth.uid());

GRANT ALL ON public.fabric_hubs TO service_role;
GRANT ALL ON public.fabric_sellers TO service_role;
GRANT ALL ON public.fabric_seller_submissions TO service_role;

