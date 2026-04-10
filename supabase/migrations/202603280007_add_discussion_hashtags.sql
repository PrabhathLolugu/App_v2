-- Migration: Add hashtag support to global discussions
-- Date: 2026-03-28
-- Description: Adds normalized hashtag storage and indexing for discussion discovery.

ALTER TABLE IF EXISTS public.discussions
ADD COLUMN IF NOT EXISTS hashtags TEXT[] NOT NULL DEFAULT '{}';

ALTER TABLE IF EXISTS public.discussions
DROP CONSTRAINT IF EXISTS discussions_hashtags_limit;

ALTER TABLE IF EXISTS public.discussions
ADD CONSTRAINT discussions_hashtags_limit
CHECK (cardinality(hashtags) <= 5);

ALTER TABLE IF EXISTS public.discussions
DROP CONSTRAINT IF EXISTS discussions_hashtags_item_limit;

CREATE OR REPLACE FUNCTION public.discussion_hashtags_items_within_limit(
  tags TEXT[],
  max_len INT DEFAULT 64
)
RETURNS BOOLEAN
LANGUAGE plpgsql
IMMUTABLE
AS $$
DECLARE
  tag TEXT;
BEGIN
  IF tags IS NULL THEN
    RETURN TRUE;
  END IF;

  FOREACH tag IN ARRAY tags LOOP
    IF length(tag) > max_len THEN
      RETURN FALSE;
    END IF;
  END LOOP;

  RETURN TRUE;
END;
$$;

ALTER TABLE IF EXISTS public.discussions
ADD CONSTRAINT discussions_hashtags_item_limit
CHECK (public.discussion_hashtags_items_within_limit(hashtags, 64));

CREATE INDEX IF NOT EXISTS idx_discussions_hashtags_gin
ON public.discussions USING gin (hashtags);
