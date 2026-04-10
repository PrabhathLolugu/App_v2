-- Migration: Normalize notification routing context and metadata
-- Date: 2026-03-20
-- Description:
--   1) Ensure social/chat notifications carry stable routing metadata
--   2) Fix reply notifications to target parent content for navigation
--   3) Forward metadata to push edge function payload

-- ---------------------------------------------------------------------------
-- Social like notifications
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION create_like_notification()
RETURNS TRIGGER AS $$
DECLARE
    content_author_id UUID;
    actor_name TEXT;
    target_entity_type TEXT := NEW.likeable_type::TEXT;
    target_entity_id UUID := NEW.likeable_id;
    resolved_content_type TEXT;
    target_comment_id UUID;
BEGIN
    -- Resolve content owner + navigation target.
    IF NEW.likeable_type = 'post' THEN
        SELECT author_id, post_type::TEXT
          INTO content_author_id, resolved_content_type
          FROM posts
         WHERE id = NEW.likeable_id;
    ELSIF NEW.likeable_type = 'comment' THEN
        SELECT author_id, commentable_type, commentable_id
          INTO content_author_id, target_entity_type, target_entity_id
          FROM comments
         WHERE id = NEW.likeable_id;

        target_comment_id := NEW.likeable_id;

        IF target_entity_type = 'post' THEN
            SELECT post_type::TEXT
              INTO resolved_content_type
              FROM posts
             WHERE id = target_entity_id;
        END IF;
    ELSIF NEW.likeable_type = 'story' THEN
        SELECT user_id
          INTO content_author_id
          FROM stories
         WHERE id = NEW.likeable_id;
    END IF;

    -- Don't notify self
    IF content_author_id IS NOT NULL AND content_author_id != NEW.user_id THEN
        SELECT COALESCE(username, full_name, 'Someone')
          INTO actor_name
          FROM profiles
         WHERE id = NEW.user_id;

        INSERT INTO notifications (
            recipient_id,
            actor_id,
            notification_type,
            title,
            body,
            entity_type,
            entity_id,
            metadata
        ) VALUES (
            content_author_id,
            NEW.user_id,
            'like',
            'New like',
            actor_name || ' liked your ' || NEW.likeable_type,
            target_entity_type,
            target_entity_id,
            jsonb_strip_nulls(
                jsonb_build_object(
                    'source_likeable_type', NEW.likeable_type::TEXT,
                    'source_likeable_id', NEW.likeable_id,
                    'content_type', resolved_content_type,
                    'target_comment_id', target_comment_id,
                    'parent_entity_type', target_entity_type,
                    'parent_entity_id', target_entity_id
                )
            )
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ---------------------------------------------------------------------------
-- Social comment/reply notifications
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION create_comment_notification()
RETURNS TRIGGER AS $$
DECLARE
    content_author_id UUID;
    parent_author_id UUID;
    actor_name TEXT;
    resolved_content_type TEXT;
BEGIN
    SELECT COALESCE(username, full_name, 'Someone')
      INTO actor_name
      FROM profiles
     WHERE id = NEW.author_id;

    IF NEW.commentable_type = 'post' THEN
        SELECT author_id, post_type::TEXT
          INTO content_author_id, resolved_content_type
          FROM posts
         WHERE id = NEW.commentable_id;
    ELSIF NEW.commentable_type = 'story' THEN
        SELECT user_id
          INTO content_author_id
          FROM stories
         WHERE id = NEW.commentable_id;
    END IF;

    -- Notify content author (post/story owner)
    IF content_author_id IS NOT NULL AND content_author_id != NEW.author_id THEN
        INSERT INTO notifications (
            recipient_id,
            actor_id,
            notification_type,
            title,
            body,
            entity_type,
            entity_id,
            metadata
        ) VALUES (
            content_author_id,
            NEW.author_id,
            'comment',
            'New comment',
            actor_name || ' commented on your ' || NEW.commentable_type,
            NEW.commentable_type,
            NEW.commentable_id,
            jsonb_strip_nulls(
                jsonb_build_object(
                    'content_type', resolved_content_type,
                    'target_comment_id', NEW.id,
                    'parent_entity_type', NEW.commentable_type,
                    'parent_entity_id', NEW.commentable_id
                )
            )
        );
    END IF;

    -- Notify parent comment author on reply
    IF NEW.parent_comment_id IS NOT NULL THEN
        SELECT author_id
          INTO parent_author_id
          FROM comments
         WHERE id = NEW.parent_comment_id;

        IF parent_author_id IS NOT NULL
           AND parent_author_id != NEW.author_id
           AND parent_author_id != content_author_id THEN
            INSERT INTO notifications (
                recipient_id,
                actor_id,
                notification_type,
                title,
                body,
                entity_type,
                entity_id,
                metadata
            ) VALUES (
                parent_author_id,
                NEW.author_id,
                'reply',
                'New reply',
                actor_name || ' replied to your comment',
                NEW.commentable_type,
                NEW.commentable_id,
                jsonb_strip_nulls(
                    jsonb_build_object(
                        'content_type', resolved_content_type,
                        'target_comment_id', NEW.parent_comment_id,
                        'reply_comment_id', NEW.id,
                        'parent_entity_type', NEW.commentable_type,
                        'parent_entity_id', NEW.commentable_id
                    )
                )
            );
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ---------------------------------------------------------------------------
-- Chat notifications
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION create_dm_notification()
RETURNS TRIGGER AS $$
DECLARE
    conversation_record RECORD;
    recipient_id UUID;
    sender_id UUID;
    sender_name TEXT;
    sender_avatar_url TEXT;
BEGIN
    sender_id := NEW.sender_id;

    SELECT *
      INTO conversation_record
      FROM public.conversations
     WHERE id = NEW.conversation_id;

    IF conversation_record IS NULL THEN
        RETURN NEW;
    END IF;

    IF conversation_record.is_group = true THEN
        RETURN NEW;
    END IF;

    SELECT cm.user_id
      INTO recipient_id
      FROM public.conversation_members cm
     WHERE cm.conversation_id = NEW.conversation_id
       AND cm.user_id != sender_id
       AND cm.deleted_at IS NULL
     LIMIT 1;

    IF are_users_blocked(sender_id, recipient_id) THEN
        RETURN NEW;
    END IF;

    SELECT COALESCE(username, full_name, 'Someone'), avatar_url
      INTO sender_name, sender_avatar_url
      FROM public.profiles
     WHERE id = sender_id;

    IF recipient_id IS NOT NULL THEN
        INSERT INTO notifications (
            recipient_id,
            actor_id,
            notification_type,
            title,
            body,
            entity_type,
            entity_id,
            metadata
        ) VALUES (
            recipient_id,
            sender_id,
            'message',
            'New message',
            sender_name || ' sent you a message',
            'conversation',
            NEW.conversation_id,
            jsonb_strip_nulls(
                jsonb_build_object(
                    'conversation_id', NEW.conversation_id,
                    'sender_id', sender_id,
                    'sender_name', sender_name,
                    'sender_avatar_url', sender_avatar_url,
                    'is_group', false
                )
            )
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION create_group_message_notification()
RETURNS TRIGGER AS $$
DECLARE
    conversation_record RECORD;
    member_record RECORD;
    sender_name TEXT;
    sender_avatar_url TEXT;
BEGIN
    SELECT *
      INTO conversation_record
      FROM public.conversations
     WHERE id = NEW.conversation_id;

    IF conversation_record IS NULL THEN
        RETURN NEW;
    END IF;

    IF conversation_record.is_group = false THEN
        RETURN NEW;
    END IF;

    SELECT COALESCE(username, full_name, 'Someone'), avatar_url
      INTO sender_name, sender_avatar_url
      FROM public.profiles
     WHERE id = NEW.sender_id;

    FOR member_record IN
        SELECT DISTINCT user_id
          FROM public.conversation_members
         WHERE conversation_id = NEW.conversation_id
           AND user_id != NEW.sender_id
           AND deleted_at IS NULL
    LOOP
        IF NOT are_users_blocked(NEW.sender_id, member_record.user_id) THEN
            INSERT INTO notifications (
                recipient_id,
                actor_id,
                notification_type,
                title,
                body,
                entity_type,
                entity_id,
                metadata
            ) VALUES (
                member_record.user_id,
                NEW.sender_id,
                'group_message',
                'New group message',
                sender_name || ' sent a message to your group',
                'conversation',
                NEW.conversation_id,
                jsonb_strip_nulls(
                    jsonb_build_object(
                        'conversation_id', NEW.conversation_id,
                        'sender_id', NEW.sender_id,
                        'sender_name', sender_name,
                        'sender_avatar_url', sender_avatar_url,
                        'is_group', true,
                        'group_name', COALESCE(
                            to_jsonb(conversation_record)->>'group_name',
                            to_jsonb(conversation_record)->>'title',
                            'Group'
                        )
                    )
                )
            );
        END IF;
    END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ---------------------------------------------------------------------------
-- FCM trigger payload forwarding
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION trigger_fcm_on_notification_insert()
RETURNS TRIGGER AS $$
DECLARE
    supabase_url TEXT;
    service_role_key TEXT;
BEGIN
    SELECT value INTO supabase_url FROM public.app_settings WHERE key = 'supabase_url';
    SELECT value INTO service_role_key FROM public.app_settings WHERE key = 'service_role_key';

    IF supabase_url IS NULL OR service_role_key IS NULL THEN
        RAISE WARNING 'FCM trigger: Missing supabase_url or service_role_key in app_settings';
        RETURN NEW;
    END IF;

    PERFORM net.http_post(
        url := supabase_url || '/functions/v1/send-push-notification',
        headers := jsonb_build_object(
            'Content-Type', 'application/json',
            'Authorization', 'Bearer ' || service_role_key
        ),
        body := jsonb_build_object(
            'notification_id', NEW.id,
            'user_id', NEW.recipient_id,
            'title', COALESCE(NEW.title, 'New Notification'),
            'body', COALESCE(NEW.body, ''),
            'notification_type', NEW.notification_type,
            'entity_type', NEW.entity_type,
            'entity_id', NEW.entity_id,
            'action_url', NEW.action_url,
            'actor_id', NEW.actor_id,
            'metadata', COALESCE(NEW.metadata, '{}'::jsonb)
        )
    );

    RETURN NEW;
EXCEPTION
    WHEN OTHERS THEN
        RAISE WARNING 'FCM trigger error: %', SQLERRM;
        RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION create_like_notification() IS
    'Creates like notifications with navigation metadata for story/post/comment targets';

COMMENT ON FUNCTION create_comment_notification() IS
    'Creates comment/reply notifications targeting parent content with comment anchor metadata';

COMMENT ON FUNCTION create_dm_notification() IS
    'Creates direct message notifications with conversation metadata for reliable deep links';

COMMENT ON FUNCTION create_group_message_notification() IS
    'Creates group message notifications with group conversation metadata for reliable deep links';

COMMENT ON FUNCTION trigger_fcm_on_notification_insert() IS
    'Triggers FCM push notification delivery and forwards notification metadata for client routing';
