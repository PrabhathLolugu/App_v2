-- Chat message metadata (poll question/options, location lat/lng) + poll votes.
-- Polls: 2–4 options; votes stored per message (WhatsApp-style; user may change vote).

ALTER TABLE public.chat_messages
    ADD COLUMN IF NOT EXISTS metadata JSONB NOT NULL DEFAULT '{}'::jsonb;

CREATE INDEX IF NOT EXISTS idx_chat_messages_metadata_poll
    ON public.chat_messages (conversation_id, created_at DESC)
    WHERE type = 'poll';

INSERT INTO public.feature_flags (key, description, enabled)
VALUES
    ('chat_polls_enabled', 'Enable polls in DM and group chat', true),
    ('chat_location_enabled', 'Enable sharing current location in chat', true)
ON CONFLICT (key) DO UPDATE SET
    description = EXCLUDED.description,
    updated_at = NOW();

CREATE TABLE IF NOT EXISTS public.chat_message_poll_votes (
    message_id UUID NOT NULL REFERENCES public.chat_messages(id) ON DELETE CASCADE,
    conversation_id UUID NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    option_index SMALLINT NOT NULL CHECK (option_index BETWEEN 0 AND 3),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (message_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_chat_message_poll_votes_conversation_id
    ON public.chat_message_poll_votes (conversation_id);

CREATE INDEX IF NOT EXISTS idx_chat_message_poll_votes_message_id
    ON public.chat_message_poll_votes (message_id);

ALTER TABLE public.chat_message_poll_votes ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Members can read chat poll votes" ON public.chat_message_poll_votes;
CREATE POLICY "Members can read chat poll votes"
    ON public.chat_message_poll_votes
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1
            FROM public.conversation_members cm
            WHERE cm.conversation_id = chat_message_poll_votes.conversation_id
              AND cm.user_id = auth.uid()
              AND cm.deleted_at IS NULL
        )
    );

-- No direct INSERT/UPDATE/DELETE for clients; use submit_chat_poll_vote RPC.

CREATE OR REPLACE FUNCTION public.submit_chat_poll_vote(
    p_message_id UUID,
    p_option_index INTEGER
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_user_id UUID;
    v_msg RECORD;
    v_options JSONB;
    v_option_count INTEGER;
    v_blocked BOOLEAN;
BEGIN
    v_user_id := auth.uid();
    IF v_user_id IS NULL THEN
        RAISE EXCEPTION 'Authentication required';
    END IF;

    SELECT
        m.id,
        m.conversation_id,
        m.type,
        m.metadata,
        c.is_group
    INTO v_msg
    FROM public.chat_messages m
    JOIN public.conversations c ON c.id = m.conversation_id
    WHERE m.id = p_message_id;

    IF v_msg.id IS NULL THEN
        RAISE EXCEPTION 'Message not found';
    END IF;

    IF v_msg.type IS DISTINCT FROM 'poll' THEN
        RAISE EXCEPTION 'Not a poll message';
    END IF;

    v_options := v_msg.metadata -> 'options';
    IF v_options IS NULL OR jsonb_typeof(v_options) <> 'array' THEN
        RAISE EXCEPTION 'Poll options are not configured';
    END IF;

    v_option_count := jsonb_array_length(v_options);
    IF v_option_count < 2 OR v_option_count > 4 THEN
        RAISE EXCEPTION 'Invalid poll configuration';
    END IF;

    IF p_option_index < 0 OR p_option_index >= v_option_count THEN
        RAISE EXCEPTION 'Invalid poll option';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM public.conversation_members cm
        WHERE cm.conversation_id = v_msg.conversation_id
          AND cm.user_id = v_user_id
          AND cm.deleted_at IS NULL
    ) THEN
        RAISE EXCEPTION 'Not a member of this conversation';
    END IF;

    -- Blocked 1:1: mirror chat_messages restrictive policy
    IF v_msg.is_group = false THEN
        SELECT EXISTS (
            SELECT 1
            FROM public.conversations c2
            JOIN public.conversation_members cm_self
              ON cm_self.conversation_id = c2.id
             AND cm_self.user_id = v_user_id
            JOIN public.conversation_members cm_other
              ON cm_other.conversation_id = c2.id
             AND cm_other.user_id <> v_user_id
            JOIN public.user_blocks ub
              ON (
                   (ub.blocker_id = v_user_id AND ub.blocked_id = cm_other.user_id)
                OR (ub.blocker_id = cm_other.user_id AND ub.blocked_id = v_user_id)
              )
            WHERE c2.id = v_msg.conversation_id
              AND c2.is_group = false
        ) INTO v_blocked;
        IF v_blocked THEN
            RAISE EXCEPTION 'Cannot vote in this conversation';
        END IF;
    END IF;

    INSERT INTO public.chat_message_poll_votes (
        message_id,
        conversation_id,
        user_id,
        option_index,
        updated_at
    )
    VALUES (
        p_message_id,
        v_msg.conversation_id,
        v_user_id,
        p_option_index,
        NOW()
    )
    ON CONFLICT (message_id, user_id)
    DO UPDATE SET
        option_index = EXCLUDED.option_index,
        updated_at = NOW();
END;
$$;

REVOKE ALL ON FUNCTION public.submit_chat_poll_vote(UUID, INTEGER) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.submit_chat_poll_vote(UUID, INTEGER) FROM anon;
GRANT EXECUTE ON FUNCTION public.submit_chat_poll_vote(UUID, INTEGER) TO authenticated;

CREATE OR REPLACE FUNCTION public.get_chat_poll_summaries(
    p_message_ids UUID[]
)
RETURNS TABLE (
    message_id UUID,
    counts INTEGER[],
    total_votes INTEGER,
    my_option INTEGER
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
STABLE
AS $$
BEGIN
    RETURN QUERY
    WITH requested AS (
        SELECT DISTINCT unnest(COALESCE(p_message_ids, ARRAY[]::UUID[])) AS message_id
    ),
    polls AS (
        SELECT
            m.id AS message_id,
            m.conversation_id,
            m.metadata -> 'options' AS options
        FROM public.chat_messages m
        INNER JOIN requested r ON r.message_id = m.id
        WHERE m.type = 'poll'
          AND jsonb_typeof(m.metadata -> 'options') = 'array'
          AND jsonb_array_length(m.metadata -> 'options') BETWEEN 2 AND 4
          AND EXISTS (
              SELECT 1
              FROM public.conversation_members cm
              WHERE cm.conversation_id = m.conversation_id
                AND cm.user_id = auth.uid()
                AND cm.deleted_at IS NULL
          )
    ),
    vote_totals AS (
        SELECT
            v.message_id,
            SUM(CASE WHEN v.option_index = 0 THEN 1 ELSE 0 END)::INTEGER AS c0,
            SUM(CASE WHEN v.option_index = 1 THEN 1 ELSE 0 END)::INTEGER AS c1,
            SUM(CASE WHEN v.option_index = 2 THEN 1 ELSE 0 END)::INTEGER AS c2,
            SUM(CASE WHEN v.option_index = 3 THEN 1 ELSE 0 END)::INTEGER AS c3,
            COUNT(*)::INTEGER AS total_votes
        FROM public.chat_message_poll_votes v
        INNER JOIN polls p ON p.message_id = v.message_id
        GROUP BY v.message_id
    ),
    my_votes AS (
        SELECT
            v.message_id,
            v.option_index::INTEGER AS my_option
        FROM public.chat_message_poll_votes v
        INNER JOIN polls p ON p.message_id = v.message_id
        WHERE v.user_id = auth.uid()
    )
    SELECT
        p.message_id,
        ARRAY[
            COALESCE(vt.c0, 0),
            COALESCE(vt.c1, 0),
            COALESCE(vt.c2, 0),
            COALESCE(vt.c3, 0)
        ]::INTEGER[] AS counts,
        COALESCE(vt.total_votes, 0)::INTEGER AS total_votes,
        mv.my_option
    FROM polls p
    LEFT JOIN vote_totals vt ON vt.message_id = p.message_id
    LEFT JOIN my_votes mv ON mv.message_id = p.message_id;
END;
$$;

REVOKE ALL ON FUNCTION public.get_chat_poll_summaries(UUID[]) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.get_chat_poll_summaries(UUID[]) FROM anon;
GRANT EXECUTE ON FUNCTION public.get_chat_poll_summaries(UUID[]) TO authenticated;

-- Realtime: other users' votes do not update chat_messages row
DO $pub$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_publication_tables
        WHERE pubname = 'supabase_realtime'
          AND schemaname = 'public'
          AND tablename = 'chat_message_poll_votes'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.chat_message_poll_votes;
    END IF;
END
$pub$;
