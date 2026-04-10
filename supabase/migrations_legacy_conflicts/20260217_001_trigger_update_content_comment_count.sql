-- Trigger to update comment_count on stories and posts when comments are inserted or deleted.
-- The comments table has commentable_type ('story' | 'post') and commentable_id.

CREATE OR REPLACE FUNCTION public.update_comment_counts_on_content()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    IF NEW.commentable_type = 'story' THEN
      UPDATE public.stories
      SET comment_count = COALESCE(comment_count, 0) + 1
      WHERE id = NEW.commentable_id;
    ELSIF NEW.commentable_type = 'post' THEN
      UPDATE public.posts
      SET comment_count = COALESCE(comment_count, 0) + 1
      WHERE id = NEW.commentable_id;
    END IF;
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    IF OLD.commentable_type = 'story' THEN
      UPDATE public.stories
      SET comment_count = GREATEST(0, COALESCE(comment_count, 0) - 1)
      WHERE id = OLD.commentable_id;
    ELSIF OLD.commentable_type = 'post' THEN
      UPDATE public.posts
      SET comment_count = GREATEST(0, COALESCE(comment_count, 0) - 1)
      WHERE id = OLD.commentable_id;
    END IF;
    RETURN OLD;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_update_content_comment_count ON public.comments;
CREATE TRIGGER trigger_update_content_comment_count
  AFTER INSERT OR DELETE ON public.comments
  FOR EACH ROW
  EXECUTE FUNCTION public.update_comment_counts_on_content();
