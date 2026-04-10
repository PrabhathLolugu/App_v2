-- Add missing SECURITY DEFINER to other counter triggers (likes, shares, and the old comments trigger)
-- because they were stripped in a previous migration.

CREATE OR REPLACE FUNCTION public.update_like_counts() RETURNS TRIGGER AS $$ 
BEGIN 
  IF (TG_OP = 'INSERT') THEN 
    IF NEW.likeable_type = 'post' THEN 
      UPDATE posts SET like_count = like_count + 1 WHERE id = NEW.likeable_id; 
    ELSIF NEW.likeable_type = 'story' THEN 
      UPDATE stories SET likes = likes + 1 WHERE id = NEW.likeable_id; 
    ELSIF NEW.likeable_type = 'comment' THEN 
      UPDATE comments SET like_count = like_count + 1 WHERE id = NEW.likeable_id; 
    END IF; 
    RETURN NEW; 
  ELSIF (TG_OP = 'DELETE') THEN 
    IF OLD.likeable_type = 'post' THEN 
      UPDATE posts SET like_count = GREATEST(0, like_count - 1) WHERE id = OLD.likeable_id; 
    ELSIF OLD.likeable_type = 'story' THEN 
      UPDATE stories SET likes = GREATEST(0, likes - 1) WHERE id = OLD.likeable_id; 
    ELSIF OLD.likeable_type = 'comment' THEN 
      UPDATE comments SET like_count = GREATEST(0, like_count - 1) WHERE id = OLD.likeable_id; 
    END IF; 
    RETURN OLD; 
  END IF; 
  RETURN NULL; 
END; 
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION public.update_comment_counts() RETURNS TRIGGER AS $$ 
BEGIN 
  IF (TG_OP = 'INSERT') THEN 
    IF NEW.commentable_type = 'post' THEN 
      UPDATE posts SET comment_count = comment_count + 1 WHERE id = NEW.commentable_id; 
    ELSIF NEW.commentable_type = 'story' THEN 
      UPDATE stories SET comment_count = comment_count + 1 WHERE id = NEW.commentable_id; 
    END IF; 
    IF NEW.parent_comment_id IS NOT NULL THEN 
      UPDATE comments SET reply_count = reply_count + 1 WHERE id = NEW.parent_comment_id; 
    END IF; 
    RETURN NEW; 
  ELSIF (TG_OP = 'DELETE') THEN 
    IF OLD.commentable_type = 'post' THEN 
      UPDATE posts SET comment_count = GREATEST(0, comment_count - 1) WHERE id = OLD.commentable_id; 
    ELSIF OLD.commentable_type = 'story' THEN 
      UPDATE stories SET comment_count = GREATEST(0, comment_count - 1) WHERE id = OLD.commentable_id; 
    END IF; 
    IF OLD.parent_comment_id IS NOT NULL THEN 
      UPDATE comments SET reply_count = GREATEST(0, reply_count - 1) WHERE id = OLD.parent_comment_id; 
    END IF; 
    RETURN OLD; 
  END IF; 
  RETURN NULL; 
END; 
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION public.update_share_counts() RETURNS TRIGGER AS $$ 
BEGIN 
  IF (TG_OP = 'INSERT') THEN 
    IF NEW.shareable_type = 'post' THEN 
      UPDATE posts SET share_count = share_count + 1 WHERE id = NEW.shareable_id; 
    ELSIF NEW.shareable_type = 'story' THEN 
      UPDATE stories SET share_count = share_count + 1 WHERE id = NEW.shareable_id; 
    END IF; 
    RETURN NEW; 
  ELSIF (TG_OP = 'DELETE') THEN 
    IF OLD.shareable_type = 'post' THEN 
      UPDATE posts SET share_count = GREATEST(0, share_count - 1) WHERE id = OLD.shareable_id; 
    ELSIF OLD.shareable_type = 'story' THEN 
      UPDATE stories SET share_count = GREATEST(0, share_count - 1) WHERE id = OLD.shareable_id; 
    END IF; 
    RETURN OLD; 
  END IF; 
  RETURN NULL; 
END; 
$$ LANGUAGE plpgsql SECURITY DEFINER;
