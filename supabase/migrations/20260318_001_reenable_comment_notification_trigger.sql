-- Migration: Re-enable comment notification trigger
-- Date: 2026-03-18
-- Description: The comment notification trigger was disabled on 2026-02-16 for testing but never re-enabled.
--              This migration re-enables the trigger so users receive notifications for comments on their posts/stories.
--              The underlying issue with recipient_type has been fixed in previous migrations.

-- Recreate the comment notification function (if it doesn't exist)
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

-- Re-create the trigger on comments table
DROP TRIGGER IF EXISTS trigger_comment_notification ON public.comments;

CREATE TRIGGER trigger_comment_notification
AFTER INSERT ON comments
FOR EACH ROW EXECUTE FUNCTION create_comment_notification();

-- Comment on the trigger
COMMENT ON TRIGGER trigger_comment_notification ON public.comments IS
    'Sends notifications when a comment is created on a post or story, and also for replies to comments';
