-- Fix BG_05: Comment reaction count displayed twice.
-- Two triggers were updating comments.like_count on INSERT/DELETE to likes:
-- 1. trigger_like_counts -> update_like_counts() (updates comments when likeable_type = 'comment')
-- 2. comments_like_count_trigger -> comments_sync_like_count()
-- So each like caused like_count to increase by 2. Drop the duplicate trigger so only
-- update_like_counts() handles comment like counts.

DROP TRIGGER IF EXISTS comments_like_count_trigger ON public.likes;

-- One-time correction: recalculate comment like_count from likes table so existing
-- inflated counts are fixed.
UPDATE public.comments c
SET like_count = (
  SELECT count(*)::int
  FROM public.likes l
  WHERE l.likeable_type = 'comment' AND l.likeable_id = c.id
);
