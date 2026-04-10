-- Add Twitter/WhatsApp-style polls for text posts.
-- Poll options are stored in posts.metadata->poll->options (2-4 labels).
-- Votes are stored in a dedicated table for concurrency-safe tallies.

CREATE TABLE IF NOT EXISTS public.post_poll_votes (
    post_id UUID NOT NULL REFERENCES public.posts(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    option_index SMALLINT NOT NULL CHECK (option_index BETWEEN 0 AND 3),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (post_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_post_poll_votes_post_id
    ON public.post_poll_votes(post_id);

ALTER TABLE public.post_poll_votes ENABLE ROW LEVEL SECURITY;

-- Keep direct table reads/writes blocked for client roles.
DROP POLICY IF EXISTS "Authenticated users can read own poll votes" ON public.post_poll_votes;
DROP POLICY IF EXISTS "Authenticated users can insert own poll votes" ON public.post_poll_votes;

CREATE OR REPLACE FUNCTION public.submit_post_poll_vote(
    p_post_id UUID,
    p_option_index INTEGER
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_user_id UUID;
    v_post_record public.posts%ROWTYPE;
    v_options JSONB;
    v_option_count INTEGER;
    v_inserted_rows INTEGER;
BEGIN
    v_user_id := auth.uid();
    IF v_user_id IS NULL THEN
        RAISE EXCEPTION 'Authentication required';
    END IF;

    SELECT *
    INTO v_post_record
    FROM public.posts
    WHERE id = p_post_id;

    IF v_post_record.id IS NULL THEN
        RAISE EXCEPTION 'Post not found';
    END IF;

    IF v_post_record.post_type <> 'text' THEN
        RAISE EXCEPTION 'Polls are only available on text posts';
    END IF;

    v_options := v_post_record.metadata -> 'poll' -> 'options';
    IF v_options IS NULL OR jsonb_typeof(v_options) <> 'array' THEN
        RAISE EXCEPTION 'Poll options are not configured for this post';
    END IF;

    v_option_count := jsonb_array_length(v_options);
    IF v_option_count < 2 OR v_option_count > 4 THEN
        RAISE EXCEPTION 'Invalid poll configuration';
    END IF;

    IF p_option_index < 0 OR p_option_index >= v_option_count THEN
        RAISE EXCEPTION 'Invalid poll option';
    END IF;

    INSERT INTO public.post_poll_votes (post_id, user_id, option_index)
    VALUES (p_post_id, v_user_id, p_option_index)
    ON CONFLICT (post_id, user_id) DO NOTHING;

    GET DIAGNOSTICS v_inserted_rows = ROW_COUNT;
    IF v_inserted_rows = 0 THEN
        RAISE EXCEPTION 'You have already voted on this poll';
    END IF;
END;
$$;

REVOKE ALL ON FUNCTION public.submit_post_poll_vote(UUID, INTEGER) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.submit_post_poll_vote(UUID, INTEGER) FROM anon;
GRANT EXECUTE ON FUNCTION public.submit_post_poll_vote(UUID, INTEGER) TO authenticated;

CREATE OR REPLACE FUNCTION public.get_post_poll_summaries(
    p_post_ids UUID[]
)
RETURNS TABLE (
    post_id UUID,
    counts INTEGER[],
    total_votes INTEGER,
    my_option INTEGER
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    RETURN QUERY
    WITH requested_posts AS (
        SELECT DISTINCT unnest(COALESCE(p_post_ids, ARRAY[]::UUID[])) AS post_id
    ),
    polls AS (
        SELECT
            p.id AS post_id,
            p.metadata -> 'poll' -> 'options' AS options
        FROM public.posts p
        INNER JOIN requested_posts r ON r.post_id = p.id
        WHERE p.post_type = 'text'
          AND jsonb_typeof(p.metadata -> 'poll' -> 'options') = 'array'
          AND jsonb_array_length(p.metadata -> 'poll' -> 'options') BETWEEN 2 AND 4
    ),
    vote_totals AS (
        SELECT
            v.post_id,
            SUM(CASE WHEN v.option_index = 0 THEN 1 ELSE 0 END)::INTEGER AS c0,
            SUM(CASE WHEN v.option_index = 1 THEN 1 ELSE 0 END)::INTEGER AS c1,
            SUM(CASE WHEN v.option_index = 2 THEN 1 ELSE 0 END)::INTEGER AS c2,
            SUM(CASE WHEN v.option_index = 3 THEN 1 ELSE 0 END)::INTEGER AS c3,
            COUNT(*)::INTEGER AS total_votes
        FROM public.post_poll_votes v
        INNER JOIN polls p ON p.post_id = v.post_id
        GROUP BY v.post_id
    ),
    my_votes AS (
        SELECT
            v.post_id,
            v.option_index::INTEGER AS my_option
        FROM public.post_poll_votes v
        INNER JOIN polls p ON p.post_id = v.post_id
        WHERE v.user_id = auth.uid()
    )
    SELECT
        p.post_id,
        ARRAY[
            COALESCE(vt.c0, 0),
            COALESCE(vt.c1, 0),
            COALESCE(vt.c2, 0),
            COALESCE(vt.c3, 0)
        ]::INTEGER[] AS counts,
        COALESCE(vt.total_votes, 0)::INTEGER AS total_votes,
        mv.my_option
    FROM polls p
    LEFT JOIN vote_totals vt ON vt.post_id = p.post_id
    LEFT JOIN my_votes mv ON mv.post_id = p.post_id;
END;
$$;

REVOKE ALL ON FUNCTION public.get_post_poll_summaries(UUID[]) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.get_post_poll_summaries(UUID[]) FROM anon;
GRANT EXECUTE ON FUNCTION public.get_post_poll_summaries(UUID[]) TO authenticated;
