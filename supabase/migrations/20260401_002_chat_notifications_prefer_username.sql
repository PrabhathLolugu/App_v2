-- Migration: Prefer profiles.username in chat notifications
-- Date: 2026-04-01
-- Description:
--   Ensure chat push notification copy uses profiles.username (not email),
--   and include sender_name in notifications.metadata so Edge Function can
--   send it in FCM data payload.

-- DM notification trigger
CREATE OR REPLACE FUNCTION create_dm_notification()
RETURNS TRIGGER AS $$
DECLARE
    conversation_record RECORD;
    recipient_id UUID;
    sender_id UUID;
    sender_name TEXT;
BEGIN
    sender_id := NEW.sender_id;

    SELECT * INTO conversation_record
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
    ORDER BY cm.joined_at ASC NULLS LAST
    LIMIT 1;

    IF recipient_id IS NULL THEN
        RETURN NEW;
    END IF;

    IF are_users_blocked(sender_id, recipient_id) THEN
        RETURN NEW;
    END IF;

    -- Prefer username (handle) first. Fall back to full_name.
    SELECT COALESCE(NULLIF(username, ''), NULLIF(full_name, ''), 'Someone')
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
        jsonb_build_object(
            'conversation_id', NEW.conversation_id,
            'sender_id', sender_id,
            'sender_name', sender_name,
            'is_group', false
        )
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Group message notification trigger
CREATE OR REPLACE FUNCTION create_group_message_notification()
RETURNS TRIGGER AS $$
DECLARE
    conversation_record RECORD;
    member_record RECORD;
    sender_name TEXT;
BEGIN
    SELECT * INTO conversation_record
    FROM public.conversations
    WHERE id = NEW.conversation_id;

    IF conversation_record IS NULL THEN
        RETURN NEW;
    END IF;

    IF conversation_record.is_group = false THEN
        RETURN NEW;
    END IF;

    -- Prefer username (handle) first. Fall back to full_name.
    SELECT COALESCE(NULLIF(username, ''), NULLIF(full_name, ''), 'Someone')
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
                jsonb_build_object(
                    'conversation_id', NEW.conversation_id,
                    'sender_id', NEW.sender_id,
                    'sender_name', sender_name,
                    'is_group', true
                )
            );
        END IF;
    END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

