-- Chat media attachments + link previews for DM and group conversations.
-- Image upload limit is intentionally capped at 5 MB per file.

-- 1) Private storage bucket for chat images.
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
SELECT
    'chat-media',
    'chat-media',
    false,
    5242880,
    ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/gif']
WHERE NOT EXISTS (
    SELECT 1 FROM storage.buckets WHERE id = 'chat-media'
);

-- 2) Attachment metadata table.
CREATE TABLE IF NOT EXISTS public.message_attachments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    message_id UUID NOT NULL REFERENCES public.chat_messages(id) ON DELETE CASCADE,
    conversation_id UUID NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
    uploader_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    bucket TEXT NOT NULL DEFAULT 'chat-media',
    object_path TEXT NOT NULL,
    mime_type TEXT,
    size_bytes BIGINT,
    width INTEGER,
    height INTEGER,
    blurhash TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_message_attachments_message_id
    ON public.message_attachments(message_id);

CREATE INDEX IF NOT EXISTS idx_message_attachments_conversation_created
    ON public.message_attachments(conversation_id, created_at DESC);

-- 3) Link preview metadata table.
CREATE TABLE IF NOT EXISTS public.message_link_previews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    message_id UUID NOT NULL REFERENCES public.chat_messages(id) ON DELETE CASCADE,
    url TEXT NOT NULL,
    normalized_url TEXT,
    domain TEXT,
    title TEXT,
    description TEXT,
    image_url TEXT,
    site_name TEXT,
    fetched_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (message_id)
);

CREATE INDEX IF NOT EXISTS idx_message_link_previews_message_id
    ON public.message_link_previews(message_id);

-- 4) Helpful index for message history reads.
CREATE INDEX IF NOT EXISTS idx_chat_messages_conversation_created_desc
    ON public.chat_messages(conversation_id, created_at DESC);

-- 5) RLS enablement.
ALTER TABLE public.message_attachments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.message_link_previews ENABLE ROW LEVEL SECURITY;

-- 6) Attachments RLS.
DROP POLICY IF EXISTS "Members can read message attachments" ON public.message_attachments;
CREATE POLICY "Members can read message attachments"
    ON public.message_attachments
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1
            FROM public.conversation_members cm
            WHERE cm.conversation_id = message_attachments.conversation_id
              AND cm.user_id = auth.uid()
              AND cm.deleted_at IS NULL
        )
    );

DROP POLICY IF EXISTS "Users can insert own message attachments" ON public.message_attachments;
CREATE POLICY "Users can insert own message attachments"
    ON public.message_attachments
    FOR INSERT
    WITH CHECK (
        uploader_id = auth.uid()
        AND EXISTS (
            SELECT 1
            FROM public.conversation_members cm
            WHERE cm.conversation_id = message_attachments.conversation_id
              AND cm.user_id = auth.uid()
              AND cm.deleted_at IS NULL
        )
    );

DROP POLICY IF EXISTS "Users can delete own message attachments" ON public.message_attachments;
CREATE POLICY "Users can delete own message attachments"
    ON public.message_attachments
    FOR DELETE
    USING (uploader_id = auth.uid());

-- 7) Link preview RLS.
DROP POLICY IF EXISTS "Members can read message link previews" ON public.message_link_previews;
CREATE POLICY "Members can read message link previews"
    ON public.message_link_previews
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1
            FROM public.chat_messages m
            JOIN public.conversation_members cm ON cm.conversation_id = m.conversation_id
            WHERE m.id = message_link_previews.message_id
              AND cm.user_id = auth.uid()
              AND cm.deleted_at IS NULL
        )
    );

DROP POLICY IF EXISTS "Users can insert link previews for own messages" ON public.message_link_previews;
CREATE POLICY "Users can insert link previews for own messages"
    ON public.message_link_previews
    FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1
            FROM public.chat_messages m
            WHERE m.id = message_link_previews.message_id
              AND m.sender_id = auth.uid()
        )
    );

DROP POLICY IF EXISTS "Users can update link previews for own messages" ON public.message_link_previews;
CREATE POLICY "Users can update link previews for own messages"
    ON public.message_link_previews
    FOR UPDATE
    USING (
        EXISTS (
            SELECT 1
            FROM public.chat_messages m
            WHERE m.id = message_link_previews.message_id
              AND m.sender_id = auth.uid()
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1
            FROM public.chat_messages m
            WHERE m.id = message_link_previews.message_id
              AND m.sender_id = auth.uid()
        )
    );

-- 8) Storage object policies for private chat-media bucket.
DROP POLICY IF EXISTS "Users can upload own chat media" ON storage.objects;
CREATE POLICY "Users can upload own chat media"
ON storage.objects FOR INSERT
WITH CHECK (
    bucket_id = 'chat-media'
    AND auth.uid()::text = (storage.foldername(name))[1]
);

DROP POLICY IF EXISTS "Conversation members can view chat media" ON storage.objects;
CREATE POLICY "Conversation members can view chat media"
ON storage.objects FOR SELECT
USING (
    bucket_id = 'chat-media'
    AND EXISTS (
        SELECT 1
        FROM public.conversation_members cm
        WHERE cm.conversation_id::text = (storage.foldername(name))[2]
          AND cm.user_id = auth.uid()
          AND cm.deleted_at IS NULL
    )
);

DROP POLICY IF EXISTS "Users can delete own chat media" ON storage.objects;
CREATE POLICY "Users can delete own chat media"
ON storage.objects FOR DELETE
USING (
    bucket_id = 'chat-media'
    AND auth.uid()::text = (storage.foldername(name))[1]
);

-- 9) Tighten blocked DM behavior for message writes.
DROP POLICY IF EXISTS "dm_message_send_denied_when_blocked" ON public.chat_messages;
CREATE POLICY "dm_message_send_denied_when_blocked"
    ON public.chat_messages
    AS RESTRICTIVE
    FOR INSERT
    WITH CHECK (
        NOT EXISTS (
            SELECT 1
            FROM public.conversations c2
            JOIN public.conversation_members cm_self
              ON cm_self.conversation_id = c2.id
             AND cm_self.user_id = auth.uid()
            JOIN public.conversation_members cm_other
              ON cm_other.conversation_id = c2.id
             AND cm_other.user_id <> auth.uid()
            JOIN public.user_blocks ub
              ON (
                   (ub.blocker_id = auth.uid() AND ub.blocked_id = cm_other.user_id)
                OR (ub.blocker_id = cm_other.user_id AND ub.blocked_id = auth.uid())
              )
            WHERE c2.id = chat_messages.conversation_id
              AND c2.is_group = false
        )
    );