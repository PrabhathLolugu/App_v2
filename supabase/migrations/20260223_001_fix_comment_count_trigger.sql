-- Fix missing SECURITY DEFINER on the comment count trigger
-- Without it, RLS on posts/stories prevents users from updating counts when they comment

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
$$ LANGUAGE plpgsql SECURITY DEFINER;
