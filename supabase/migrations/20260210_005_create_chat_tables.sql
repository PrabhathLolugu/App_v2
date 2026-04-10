-- Migration: Create chat tables for Krishna guide and heritage site conversations
-- Description: story_chats for story-related chats, map_chats for heritage site guide chats

-- Create story_chats table (used by chat-service edge function)
CREATE TABLE IF NOT EXISTS public.story_chats (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id TEXT NOT NULL, -- Supports both auth.users.id or 'anonymous'
    story_id UUID DEFAULT NULL,
    messages JSONB NOT NULL DEFAULT '[]'::jsonb,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create index for fast lookup by user
CREATE INDEX IF NOT EXISTS idx_story_chats_user_id
    ON public.story_chats(user_id);

-- Create index for story lookup
CREATE INDEX IF NOT EXISTS idx_story_chats_story_id
    ON public.story_chats(story_id)
    WHERE story_id IS NOT NULL;

-- Enable Row Level Security
ALTER TABLE public.story_chats ENABLE ROW LEVEL SECURITY;

-- RLS Policies for story_chats
CREATE POLICY "Users can view own story chats"
    ON public.story_chats
    FOR SELECT
    USING (
        user_id = 'anonymous' OR 
        (auth.uid()::text = user_id)
    );

CREATE POLICY "Users can insert own story chats"
    ON public.story_chats
    FOR INSERT
    WITH CHECK (
        user_id = 'anonymous' OR 
        (auth.uid()::text = user_id)
    );

CREATE POLICY "Users can update own story chats"
    ON public.story_chats
    FOR UPDATE
    USING (
        user_id = 'anonymous' OR 
        (auth.uid()::text = user_id)
    );

CREATE POLICY "Users can delete own story chats"
    ON public.story_chats
    FOR DELETE
    USING (
        user_id = 'anonymous' OR 
        (auth.uid()::text = user_id)
    );

-- Create map_chats table (used by MapGuide for heritage site conversations)
CREATE TABLE IF NOT EXISTS public.map_chats (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    title TEXT NOT NULL DEFAULT 'New Conversation',
    messages JSONB NOT NULL DEFAULT '[]'::jsonb,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create index for fast lookup by user
CREATE INDEX IF NOT EXISTS idx_map_chats_user_id
    ON public.map_chats(user_id);

-- Create index for recent chats
CREATE INDEX IF NOT EXISTS idx_map_chats_updated_at
    ON public.map_chats(updated_at DESC);

-- Enable Row Level Security
ALTER TABLE public.map_chats ENABLE ROW LEVEL SECURITY;

-- RLS Policies for map_chats
CREATE POLICY "Users can view own map chats"
    ON public.map_chats
    FOR SELECT
    USING (auth.uid()::text = user_id::text);

CREATE POLICY "Users can insert own map chats"
    ON public.map_chats
    FOR INSERT
    WITH CHECK (auth.uid()::text = user_id::text);

CREATE POLICY "Users can update own map chats"
    ON public.map_chats
    FOR UPDATE
    USING (auth.uid()::text = user_id::text);

CREATE POLICY "Users can delete own map chats"
    ON public.map_chats
    FOR DELETE
    USING (auth.uid()::text = user_id::text);

-- Function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_chat_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for story_chats
CREATE TRIGGER update_story_chats_updated_at
    BEFORE UPDATE ON public.story_chats
    FOR EACH ROW
    EXECUTE FUNCTION update_chat_updated_at();

-- Trigger for map_chats
CREATE TRIGGER update_map_chats_updated_at
    BEFORE UPDATE ON public.map_chats
    FOR EACH ROW
    EXECUTE FUNCTION update_chat_updated_at();

-- Grant permissions to service role for edge functions
GRANT ALL ON public.story_chats TO service_role;
GRANT ALL ON public.map_chats TO service_role;
