-- Persisted "delete for me" support for chat messages.
-- Each user can hide specific messages only for themselves.

CREATE TABLE IF NOT EXISTS public.user_hidden_messages (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    message_id UUID NOT NULL REFERENCES public.chat_messages(id) ON DELETE CASCADE,
    conversation_id UUID NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
    hidden_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (user_id, message_id)
);

CREATE INDEX IF NOT EXISTS idx_user_hidden_messages_user_conversation
    ON public.user_hidden_messages (user_id, conversation_id, hidden_at DESC);

ALTER TABLE public.user_hidden_messages ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can read own hidden messages" ON public.user_hidden_messages;
CREATE POLICY "Users can read own hidden messages"
    ON public.user_hidden_messages
    FOR SELECT
    USING (
        auth.uid() = user_id
        AND EXISTS (
            SELECT 1
            FROM public.conversation_members cm
            WHERE cm.conversation_id = conversation_id
              AND cm.user_id = auth.uid()
        )
    );

DROP POLICY IF EXISTS "Users can hide own messages in member conversations" ON public.user_hidden_messages;
CREATE POLICY "Users can hide own messages in member conversations"
    ON public.user_hidden_messages
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

DROP POLICY IF EXISTS "Users can unhide own messages" ON public.user_hidden_messages;
CREATE POLICY "Users can unhide own messages"
    ON public.user_hidden_messages
    FOR DELETE
    USING (auth.uid() = user_id);
