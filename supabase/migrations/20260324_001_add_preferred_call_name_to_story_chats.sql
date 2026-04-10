-- Add per-chat preferred call-name for assistant personalization
ALTER TABLE public.story_chats
ADD COLUMN IF NOT EXISTS preferred_call_name TEXT;

COMMENT ON COLUMN public.story_chats.preferred_call_name IS
  'Optional user preferred call-name for this specific story chat conversation.';
