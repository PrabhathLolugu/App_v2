-- Richer in-app notification bodies for poll, location, and image chat messages.

CREATE OR REPLACE FUNCTION create_dm_notification()
RETURNS TRIGGER AS $$
DECLARE
    conversation_record RECORD;
    recipient_id UUID;
    sender_id UUID;
    sender_name TEXT;
    body_text TEXT;
    msg_type TEXT;
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

    SELECT COALESCE(username, full_name, 'Someone')
    INTO sender_name
    FROM public.profiles
    WHERE id = sender_id;

    msg_type := lower(trim(coalesce(NEW.type, 'text')));

    body_text := CASE msg_type
        WHEN 'poll' THEN sender_name || ' sent a poll'
        WHEN 'location' THEN sender_name || ' shared a location'
        WHEN 'image' THEN sender_name || ' sent a photo'
        ELSE sender_name || ' sent you a message'
    END;

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
        body_text,
        'conversation',
        NEW.conversation_id
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION create_group_message_notification()
RETURNS TRIGGER AS $$
DECLARE
    conversation_record RECORD;
    member_record RECORD;
    sender_name TEXT;
    body_text TEXT;
    msg_type TEXT;
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

    SELECT COALESCE(username, full_name, 'Someone')
    INTO sender_name
    FROM public.profiles
    WHERE id = NEW.sender_id;

    msg_type := lower(trim(coalesce(NEW.type, 'text')));

    body_text := CASE msg_type
        WHEN 'poll' THEN sender_name || ' sent a poll'
        WHEN 'location' THEN sender_name || ' shared a location'
        WHEN 'image' THEN sender_name || ' sent a photo'
        ELSE sender_name || ' sent a message to your group'
    END;

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
                body_text,
                'conversation',
                NEW.conversation_id
            );
        END IF;
    END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
