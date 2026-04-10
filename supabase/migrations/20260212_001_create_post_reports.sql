-- Create post_reports table for moderation reporting in Social feed.
-- Each user can report a given post once, and can update that report later.

CREATE TABLE IF NOT EXISTS public.post_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    post_id UUID NOT NULL REFERENCES public.posts(id) ON DELETE CASCADE,
    reporter_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    reason TEXT NOT NULL CHECK (char_length(trim(reason)) > 0),
    details TEXT,
    status TEXT NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'reviewed', 'resolved', 'dismissed')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (post_id, reporter_id)
);

CREATE INDEX IF NOT EXISTS idx_post_reports_post_id
    ON public.post_reports(post_id);

CREATE INDEX IF NOT EXISTS idx_post_reports_reporter_id
    ON public.post_reports(reporter_id);

CREATE INDEX IF NOT EXISTS idx_post_reports_status_created_at
    ON public.post_reports(status, created_at DESC);

ALTER TABLE public.post_reports ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can view own post reports" ON public.post_reports;
CREATE POLICY "Users can view own post reports"
    ON public.post_reports
    FOR SELECT
    TO authenticated
    USING (auth.uid() = reporter_id);

DROP POLICY IF EXISTS "Users can create own post reports" ON public.post_reports;
CREATE POLICY "Users can create own post reports"
    ON public.post_reports
    FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() = reporter_id);

DROP POLICY IF EXISTS "Users can update own post reports" ON public.post_reports;
CREATE POLICY "Users can update own post reports"
    ON public.post_reports
    FOR UPDATE
    TO authenticated
    USING (auth.uid() = reporter_id)
    WITH CHECK (auth.uid() = reporter_id);

CREATE OR REPLACE FUNCTION public.update_post_reports_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_post_reports_updated_at ON public.post_reports;
CREATE TRIGGER update_post_reports_updated_at
    BEFORE UPDATE ON public.post_reports
    FOR EACH ROW
    EXECUTE FUNCTION public.update_post_reports_updated_at();
