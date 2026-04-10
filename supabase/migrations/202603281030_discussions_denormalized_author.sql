-- Denormalized author fields for discussion list cards (match Flutter insert payload).
ALTER TABLE public.discussions
ADD COLUMN IF NOT EXISTS author TEXT;

ALTER TABLE public.discussions
ADD COLUMN IF NOT EXISTS author_avatar TEXT;
