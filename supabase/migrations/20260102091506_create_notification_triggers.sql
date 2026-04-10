-- Function to create notification on like
CREATE OR REPLACE FUNCTION create_like_notification()
RETURNS TRIGGER AS $$
DECLARE
    content_author_id UUID;
    actor_name TEXT;
BEGIN
    -- Get the author of the liked content
    IF NEW.likeable_type = 'post' THEN
        SELECT author_id INTO content_author_id FROM posts WHERE id = NEW.likeable_id;
    ELSIF NEW.likeable_type = 'comment' THEN
        SELECT author_id INTO content_author_id FROM comments WHERE id = NEW.likeable_id;
    ELSIF NEW.likeable_type = 'story' THEN
        SELECT user_id INTO content_author_id FROM stories WHERE id = NEW.likeable_id;
    END IF;
    
    -- Don't notify self
    IF content_author_id IS NOT NULL AND content_author_id != NEW.user_id THEN
        SELECT COALESCE(username, full_name, 'Someone') INTO actor_name FROM profiles WHERE id = NEW.user_id;
        
        INSERT INTO notifications (
            recipient_id, actor_id, notification_type, 
            title, body, entity_type, entity_id
        ) VALUES (
            content_author_id, NEW.user_id, 'like',
            'New like', actor_name || ' liked your ' || NEW.likeable_type,
            NEW.likeable_type::TEXT, NEW.likeable_id
        );
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trigger_like_notification
AFTER INSERT ON likes
FOR EACH ROW EXECUTE FUNCTION create_like_notification();

-- Function to create notification on comment
CREATE OR REPLACE FUNCTION create_comment_notification()
RETURNS TRIGGER AS $$
DECLARE
    content_author_id UUID;
    parent_author_id UUID;
    actor_name TEXT;
BEGIN
    SELECT COALESCE(username, full_name, 'Someone') INTO actor_name FROM profiles WHERE id = NEW.author_id;
    
    -- Notify content author (post or story)
    IF NEW.commentable_type = 'post' THEN
        SELECT author_id INTO content_author_id FROM posts WHERE id = NEW.commentable_id;
    ELSIF NEW.commentable_type = 'story' THEN
        SELECT user_id INTO content_author_id FROM stories WHERE id = NEW.commentable_id;
    END IF;
    
    -- Don't notify self
    IF content_author_id IS NOT NULL AND content_author_id != NEW.author_id THEN
        INSERT INTO notifications (
            recipient_id, actor_id, notification_type,
            title, body, entity_type, entity_id
        ) VALUES (
            content_author_id, NEW.author_id, 'comment',
            'New comment', actor_name || ' commented on your ' || NEW.commentable_type,
            NEW.commentable_type, NEW.commentable_id
        );
    END IF;
    
    -- If this is a reply, also notify parent comment author
    IF NEW.parent_comment_id IS NOT NULL THEN
        SELECT author_id INTO parent_author_id FROM comments WHERE id = NEW.parent_comment_id;
        
        IF parent_author_id IS NOT NULL AND parent_author_id != NEW.author_id AND parent_author_id != content_author_id THEN
            INSERT INTO notifications (
                recipient_id, actor_id, notification_type,
                title, body, entity_type, entity_id
            ) VALUES (
                parent_author_id, NEW.author_id, 'reply',
                'New reply', actor_name || ' replied to your comment',
                'comment', NEW.id
            );
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trigger_comment_notification
AFTER INSERT ON comments
FOR EACH ROW EXECUTE FUNCTION create_comment_notification();

-- Function to create notification on follow
CREATE OR REPLACE FUNCTION create_follow_notification()
RETURNS TRIGGER AS $$
DECLARE
    actor_name TEXT;
BEGIN
    SELECT COALESCE(username, full_name, 'Someone') INTO actor_name FROM profiles WHERE id = NEW.follower_id;
    
    INSERT INTO notifications (
        recipient_id, actor_id, notification_type,
        title, body, entity_type, entity_id
    ) VALUES (
        NEW.following_id, NEW.follower_id, 'follow',
        'New follower', actor_name || ' started following you',
        'profile', NEW.follower_id
    );
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trigger_follow_notification
AFTER INSERT ON follows
FOR EACH ROW EXECUTE FUNCTION create_follow_notification();;
