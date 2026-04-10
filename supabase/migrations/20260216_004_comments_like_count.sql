-- Add like_count to comments and keep it in sync with the likes table.
-- The app reads comment like_count for display; without this column it shows 0.

ALTER TABLE public.comments
  ADD COLUMN IF NOT EXISTS like_count INT NOT NULL DEFAULT 0;

-- Backfill existing comment like counts
UPDATE public.comments c
SET like_count = (
  SELECT count(*)::int
  FROM public.likes l
  WHERE l.likeable_type = 'comment' AND l.likeable_id = c.id
);

CREATE OR REPLACE FUNCTION public.comments_sync_like_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' AND NEW.likeable_type = 'comment' THEN
    UPDATE public.comments
    SET like_count = like_count + 1
    WHERE id = NEW.likeable_id;
  ELSIF TG_OP = 'DELETE' AND OLD.likeable_type = 'comment' THEN
    UPDATE public.comments
    SET like_count = GREATEST(0, like_count - 1)
    WHERE id = OLD.likeable_id;
  END IF;
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS comments_like_count_trigger ON public.likes;
CREATE TRIGGER comments_like_count_trigger
  AFTER INSERT OR DELETE ON public.likes
  FOR EACH ROW
  EXECUTE FUNCTION public.comments_sync_like_count();
