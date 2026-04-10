-- Add profile-level preferred call-name for reuse across future chats
ALTER TABLE public.profiles
ADD COLUMN IF NOT EXISTS preferred_call_name TEXT;

COMMENT ON COLUMN public.profiles.preferred_call_name IS
  'Optional user preferred call-name used by chat assistants across conversations.';
