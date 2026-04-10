-- Moderated pipeline for user-submitted custom sacred sites.
-- Users can generate and submit drafts. Only service-role moderation can approve/reject/publish.

CREATE TABLE IF NOT EXISTS public.custom_site_submissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_by UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    status TEXT NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'approved', 'rejected')),
    temple_name TEXT NOT NULL,
    input_location_text TEXT NOT NULL,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    user_notes TEXT,
    generated_site_details_json JSONB NOT NULL,
    generated_sacred_location_json JSONB NOT NULL,
    chat_primer_json JSONB,
    published_location_id INT,
    moderated_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    moderation_notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_custom_site_submissions_created_by
    ON public.custom_site_submissions(created_by);

CREATE INDEX IF NOT EXISTS idx_custom_site_submissions_status_created_at
    ON public.custom_site_submissions(status, created_at DESC);

ALTER TABLE public.custom_site_submissions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can read own custom site submissions" ON public.custom_site_submissions;
CREATE POLICY "Users can read own custom site submissions"
    ON public.custom_site_submissions
    FOR SELECT
    USING (auth.uid() = created_by);

DROP POLICY IF EXISTS "Users can insert own custom site submissions" ON public.custom_site_submissions;
CREATE POLICY "Users can insert own custom site submissions"
    ON public.custom_site_submissions
    FOR INSERT
    WITH CHECK (auth.uid() = created_by);

-- No UPDATE/DELETE policy for authenticated users.
-- Moderation is intentionally restricted to service-role operations.

GRANT ALL ON public.custom_site_submissions TO service_role;

CREATE OR REPLACE FUNCTION public.update_custom_site_submissions_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_custom_site_submissions_updated_at ON public.custom_site_submissions;
CREATE TRIGGER update_custom_site_submissions_updated_at
    BEFORE UPDATE ON public.custom_site_submissions
    FOR EACH ROW
    EXECUTE FUNCTION public.update_custom_site_submissions_updated_at();

-- Service-role only helper: update moderation status.
CREATE OR REPLACE FUNCTION public.set_custom_site_submission_status(
    p_submission_id UUID,
    p_status TEXT,
    p_moderation_notes TEXT DEFAULT NULL
)
RETURNS public.custom_site_submissions
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_row public.custom_site_submissions;
BEGIN
    IF auth.role() <> 'service_role' THEN
        RAISE EXCEPTION 'Only service role can moderate submissions';
    END IF;

    IF p_status NOT IN ('approved', 'rejected', 'pending') THEN
        RAISE EXCEPTION 'Invalid status %', p_status;
    END IF;

    UPDATE public.custom_site_submissions
    SET
        status = p_status,
        moderation_notes = p_moderation_notes,
        moderated_by = auth.uid(),
        updated_at = NOW()
    WHERE id = p_submission_id
    RETURNING * INTO v_row;

    RETURN v_row;
END;
$$;

GRANT EXECUTE ON FUNCTION public.set_custom_site_submission_status(UUID, TEXT, TEXT) TO service_role;

-- Service-role only publisher: inserts approved submission into canonical tables.
CREATE OR REPLACE FUNCTION public.publish_custom_site_submission(
    p_submission_id UUID,
    p_moderation_notes TEXT DEFAULT NULL
)
RETURNS public.custom_site_submissions
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_submission public.custom_site_submissions;
    v_location_id INT;
BEGIN
    IF auth.role() <> 'service_role' THEN
        RAISE EXCEPTION 'Only service role can publish submissions';
    END IF;

    SELECT *
    INTO v_submission
    FROM public.custom_site_submissions
    WHERE id = p_submission_id
    FOR UPDATE;

    IF v_submission.id IS NULL THEN
        RAISE EXCEPTION 'Submission % not found', p_submission_id;
    END IF;

    IF v_submission.status = 'rejected' THEN
        RAISE EXCEPTION 'Rejected submissions cannot be published';
    END IF;

    IF v_submission.published_location_id IS NOT NULL THEN
        UPDATE public.custom_site_submissions
        SET
            status = 'approved',
            moderation_notes = COALESCE(p_moderation_notes, moderation_notes),
            moderated_by = auth.uid(),
            updated_at = NOW()
        WHERE id = p_submission_id
        RETURNING * INTO v_submission;
        RETURN v_submission;
    END IF;

    INSERT INTO public.sacred_locations (
        name,
        latitude,
        longitude,
        intent,
        type,
        region,
        tradition,
        ref,
        image,
        description
    )
    VALUES (
        COALESCE(v_submission.generated_sacred_location_json->>'name', v_submission.temple_name),
        COALESCE((v_submission.generated_sacred_location_json->>'latitude')::DOUBLE PRECISION, v_submission.latitude, 20.5937),
        COALESCE((v_submission.generated_sacred_location_json->>'longitude')::DOUBLE PRECISION, v_submission.longitude, 78.9629),
        ARRAY['Other']::TEXT[],
        COALESCE(v_submission.generated_sacred_location_json->>'type', 'Other'),
        COALESCE(v_submission.generated_sacred_location_json->>'region', 'Bharat'),
        COALESCE(v_submission.generated_sacred_location_json->>'tradition', 'Sanatan'),
        v_submission.id::TEXT,
        COALESCE(v_submission.generated_sacred_location_json->>'image', ''),
        COALESCE(v_submission.generated_sacred_location_json->>'description', '')
    )
    RETURNING id INTO v_location_id;

    INSERT INTO public.site_details (
        id,
        name,
        location,
        "heroImage",
        "heroImageLabel",
        about,
        history
    )
    VALUES (
        v_location_id,
        COALESCE(v_submission.generated_site_details_json->>'name', v_submission.temple_name),
        COALESCE(v_submission.generated_site_details_json->>'location', v_submission.input_location_text),
        COALESCE(v_submission.generated_site_details_json->>'heroImage', v_submission.generated_sacred_location_json->>'image', ''),
        COALESCE(v_submission.generated_site_details_json->>'heroImageLabel', v_submission.temple_name),
        COALESCE(v_submission.generated_site_details_json->>'about', ''),
        COALESCE(v_submission.generated_site_details_json->>'history', '')
    );

    UPDATE public.custom_site_submissions
    SET
        status = 'approved',
        published_location_id = v_location_id,
        moderation_notes = p_moderation_notes,
        moderated_by = auth.uid(),
        updated_at = NOW()
    WHERE id = p_submission_id
    RETURNING * INTO v_submission;

    RETURN v_submission;
END;
$$;

GRANT EXECUTE ON FUNCTION public.publish_custom_site_submission(UUID, TEXT) TO service_role;
