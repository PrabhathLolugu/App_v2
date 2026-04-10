-- Per-message emoji reactions for chat messages.
-- Each user can have at most one active reaction per message.

CREATE TABLE IF NOT EXISTS public.message_reactions (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    message_id UUID NOT NULL REFERENCES public.chat_messages(id) ON DELETE CASCADE,
    conversation_id UUID NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    emoji TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (message_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_message_reactions_conversation_message
    ON public.message_reactions (conversation_id, message_id);

CREATE INDEX IF NOT EXISTS idx_message_reactions_message_emoji
    ON public.message_reactions (message_id, emoji);

ALTER TABLE public.message_reactions ENABLE ROW LEVEL SECURITY;

-- Allow members of a conversation to see all reactions in that conversation.
DROP POLICY IF EXISTS "Members can read message reactions" ON public.message_reactions;
CREATE POLICY "Members can read message reactions"
    ON public.message_reactions
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1
            FROM public.conversation_members cm
            WHERE cm.conversation_id = conversation_id
              AND cm.user_id = auth.uid()
        )
    );

-- Allow users to add/update their own reactions in conversations they are part of.
DROP POLICY IF EXISTS "Users can react in member conversations" ON public.message_reactions;
CREATE POLICY "Users can react in member conversations"
    ON public.message_reactions
    FOR INSERT
    WITH CHECK (
        auth.uid() = user_id
        AND EXISTS (
            SELECT 1
            FROM public.conversation_members cm
            WHERE cm.conversation_id = conversation_id
              AND cm.user_id = auth.uid()
        )
    );

-- Allow users to remove their own reactions.
DROP POLICY IF EXISTS "Users can remove own reactions" ON public.message_reactions;
CREATE POLICY "Users can remove own reactions"
    ON public.message_reactions
    FOR DELETE
    USING (auth.uid() = user_id);

