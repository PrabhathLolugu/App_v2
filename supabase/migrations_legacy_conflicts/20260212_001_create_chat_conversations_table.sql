-- Migration: Create chat_conversations table for storing Krishna chatbot conversations
-- This replaces/supplements story_chats with a more flexible structure using app_section

CREATE TABLE IF NOT EXISTS public.chat_conversations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    title TEXT DEFAULT NULL,
    messages JSONB NOT NULL DEFAULT '[]'::jsonb,
    app_section TEXT NOT NULL, -- 'krishna_chat', 'map_guide', etc.
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- Create indexes for fast lookups
CREATE INDEX IF NOT EXISTS idx_chat_conversations_user_id
    ON public.chat_conversations(user_id);

CREATE INDEX IF NOT EXISTS idx_chat_conversations_app_section
    ON public.chat_conversations(app_section);

CREATE INDEX IF NOT EXISTS idx_chat_conversations_user_app_section
    ON public.chat_conversations(user_id, app_section);

CREATE INDEX IF NOT EXISTS idx_chat_conversations_updated_at
    ON public.chat_conversations(updated_at DESC);

-- Enable Row Level Security
ALTER TABLE public.chat_conversations ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view own conversations"
    ON public.chat_conversations
    FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own conversations"
    ON public.chat_conversations
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own conversations"
    ON public.chat_conversations
    FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own conversations"
    ON public.chat_conversations
    FOR DELETE
    USING (auth.uid() = user_id);

-- Add trigger to auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_chat_conversations_updated_at
    BEFORE UPDATE ON public.chat_conversations
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Comment for documentation
COMMENT ON TABLE public.chat_conversations IS 'Stores all chat conversations across different app sections';
COMMENT ON COLUMN public.chat_conversations.app_section IS 'Identifies which app section owns this conversation (e.g., krishna_chat, map_guide)';
