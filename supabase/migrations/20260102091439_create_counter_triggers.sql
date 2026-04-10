-- Function to update post/comment like count
CREATE OR REPLACE FUNCTION update_like_counts()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        IF NEW.likeable_type = 'post' THEN
            UPDATE posts SET like_count = like_count + 1 WHERE id = NEW.likeable_id;
        ELSIF NEW.likeable_type = 'comment' THEN
            UPDATE comments SET like_count = like_count + 1 WHERE id = NEW.likeable_id;
        END IF;
        RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
        IF OLD.likeable_type = 'post' THEN
            UPDATE posts SET like_count = GREATEST(0, like_count - 1) WHERE id = OLD.likeable_id;
        ELSIF OLD.likeable_type = 'comment' THEN
            UPDATE comments SET like_count = GREATEST(0, like_count - 1) WHERE id = OLD.likeable_id;
        END IF;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trigger_like_counts
AFTER INSERT OR DELETE ON likes
FOR EACH ROW EXECUTE FUNCTION update_like_counts();

-- Function to update post comment count
CREATE OR REPLACE FUNCTION update_comment_counts()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        IF NEW.commentable_type = 'post' THEN
            UPDATE posts SET comment_count = comment_count + 1 WHERE id = NEW.commentable_id;
        END IF;
        -- Update parent comment reply count
        IF NEW.parent_comment_id IS NOT NULL THEN
            UPDATE comments SET reply_count = reply_count + 1 WHERE id = NEW.parent_comment_id;
        END IF;
        RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
        IF OLD.commentable_type = 'post' THEN
            UPDATE posts SET comment_count = GREATEST(0, comment_count - 1) WHERE id = OLD.commentable_id;
        END IF;
        IF OLD.parent_comment_id IS NOT NULL THEN
            UPDATE comments SET reply_count = GREATEST(0, reply_count - 1) WHERE id = OLD.parent_comment_id;
        END IF;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trigger_comment_counts
AFTER INSERT OR DELETE ON comments
FOR EACH ROW EXECUTE FUNCTION update_comment_counts();

-- Function to update post bookmark count
CREATE OR REPLACE FUNCTION update_bookmark_counts()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        IF NEW.bookmarkable_type = 'post' THEN
            UPDATE posts SET bookmark_count = bookmark_count + 1 WHERE id = NEW.bookmarkable_id;
        END IF;
        RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
        IF OLD.bookmarkable_type = 'post' THEN
            UPDATE posts SET bookmark_count = GREATEST(0, bookmark_count - 1) WHERE id = OLD.bookmarkable_id;
        END IF;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trigger_bookmark_counts
AFTER INSERT OR DELETE ON bookmarks
FOR EACH ROW EXECUTE FUNCTION update_bookmark_counts();

-- Function to update post share count
CREATE OR REPLACE FUNCTION update_share_counts()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        IF NEW.shareable_type = 'post' THEN
            UPDATE posts SET share_count = share_count + 1 WHERE id = NEW.shareable_id;
        END IF;
        RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
        IF OLD.shareable_type = 'post' THEN
            UPDATE posts SET share_count = GREATEST(0, share_count - 1) WHERE id = OLD.shareable_id;
        END IF;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trigger_share_counts
AFTER INSERT OR DELETE ON shares
FOR EACH ROW EXECUTE FUNCTION update_share_counts();;
