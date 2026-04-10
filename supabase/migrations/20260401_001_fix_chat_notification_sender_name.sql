-- Migration: Prefer full_name for chat notification sender name
-- Date: 2026-04-01
-- Description:
--   Chat push notifications were showing the sender's username/handle (often email-like)
--   instead of their display name. Update notification trigger functions to prefer
--   profiles.full_name, then fallback to username.

-- Function to create notification for direct message.
CREATE OR REPLACE FUNCTION create_dm_notification()
RETURNS TRIGGER AS $$
DECLARE
    conversation_record RECORD;
    recipient_id UUID;
    sender_id UUID;
    sender_name TEXT;
BEGIN
    sender_id := NEW.sender_id;

    -- Get conversation details.
    SELECT * INTO conversation_record
    FROM public.conversations
    WHERE id = NEW.conversation_id;

    IF conversation_record IS NULL THEN
        RETURN NEW;
    END IF;

    -- Only process 1:1 conversations.
    IF conversation_record.is_group = true THEN
        RETURN NEW;
    END IF;

    -- Resolve DM recipient from active members in this conversation.
    SELECT cm.user_id
    INTO recipient_id
    FROM public.conversation_members cm
    WHERE cm.conversation_id = NEW.conversation_id
      AND cm.user_id != sender_id
      AND cm.deleted_at IS NULL
    ORDER BY cm.joined_at ASC NULLS LAST
    LIMIT 1;

    IF recipient_id IS NULL THEN
        RETURN NEW;
    END IF;

    -- Do not notify when blocked.
    IF are_users_blocked(sender_id, recipient_id) THEN
        RETURN NEW;
    END IF;

    -- Prefer full_name over username for notification copy.
    SELECT COALESCE(NULLIF(full_name, ''), NULLIF(username, ''), 'Someone')
    INTO sender_name
    FROM public.profiles
    WHERE id = sender_id;

    INSERT INTO notifications (
        recipient_id,
        actor_id,
        notification_type,
        title,
        body,
        entity_type,
        entity_id
    ) VALUES (
        recipient_id,
        sender_id,
        'message',
        'New message',
        sender_name || ' sent you a message',
        'conversation',
        NEW.conversation_id
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to create notifications for group chat messages.
CREATE OR REPLACE FUNCTION create_group_message_notification()
RETURNS TRIGGER AS $$
DECLARE
    conversation_record RECORD;
    member_record RECORD;
    sender_name TEXT;
BEGIN
    -- Get conversation details.
    SELECT * INTO conversation_record
    FROM public.conversations
    WHERE id = NEW.conversation_id;

    IF conversation_record IS NULL THEN
        RETURN NEW;
    END IF;

    -- Only process group conversations.
    IF conversation_record.is_group = false THEN
        RETURN NEW;
    END IF;

    -- Prefer full_name over username for notification copy.
    SELECT COALESCE(NULLIF(full_name, ''), NULLIF(username, ''), 'Someone')
    INTO sender_name
    FROM public.profiles
    WHERE id = NEW.sender_id;

    FOR member_record IN
        SELECT DISTINCT cm.user_id
        FROM public.conversation_members cm
        WHERE cm.conversation_id = NEW.conversation_id
          AND cm.user_id != NEW.sender_id
          AND cm.deleted_at IS NULL
    LOOP
        IF NOT are_users_blocked(NEW.sender_id, member_record.user_id) THEN
            INSERT INTO notifications (
                recipient_id,
                actor_id,
                notification_type,
                title,
                body,
                entity_type,
                entity_id
            ) VALUES (
                member_record.user_id,
                NEW.sender_id,
                'group_message',
                'New group message',
                sender_name || ' sent a message to your group',
                'conversation',
                NEW.conversation_id
            );
        END IF;
    END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

