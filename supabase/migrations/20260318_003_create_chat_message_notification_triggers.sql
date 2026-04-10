-- Migration: Create chat message notification triggers
-- Date: 2026-03-18
-- Description: Triggers notifications when messages are sent in direct messages and group chats.
--              - DM trigger: Notifies the recipient when a message is received
--              - Group trigger: Notifies all group members except the sender

-- Helper: Check if two users have blocked each other
CREATE OR REPLACE FUNCTION are_users_blocked(user_a UUID, user_b UUID)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS(
        SELECT 1 FROM public.user_blocks
        WHERE (blocker_id = user_a AND blocked_id = user_b)
           OR (blocker_id = user_b AND blocked_id = user_a)
    );
END;
$$ LANGUAGE plpgsql STABLE;

-- Function to create notification for direct message
CREATE OR REPLACE FUNCTION create_dm_notification()
RETURNS TRIGGER AS $$
DECLARE
    conversation_record RECORD;
    recipient_id UUID;
    sender_id UUID;
    sender_name TEXT;
BEGIN
    sender_id := NEW.sender_id;
    
    -- Get conversation details
    SELECT * INTO conversation_record FROM public.conversations WHERE id = NEW.conversation_id;
    
    IF conversation_record IS NULL THEN
        RETURN NEW;
    END IF;
    
    -- Only process 1:1 conversations (not groups)
    IF conversation_record.is_group = true THEN
        RETURN NEW;
    END IF;
    
    -- Determine recipient from active members in 1:1 conversation.
    SELECT cm.user_id INTO recipient_id
    FROM public.conversation_members cm
    WHERE cm.conversation_id = NEW.conversation_id
      AND cm.user_id != sender_id
      AND cm.deleted_at IS NULL
    LIMIT 1;
    
    -- Don't notify if users are blocked
    IF are_users_blocked(sender_id, recipient_id) THEN
        RETURN NEW;
    END IF;
    
    -- Get sender name
    SELECT COALESCE(username, full_name, 'Someone') INTO sender_name 
    FROM public.profiles WHERE id = sender_id;
    
    -- Insert notification
    IF recipient_id IS NOT NULL THEN
        INSERT INTO notifications (
            recipient_id, actor_id, notification_type,
            title, body, entity_type, entity_id
        ) VALUES (
            recipient_id, sender_id, 'message',
            'New message', sender_name || ' sent you a message',
            'conversation', NEW.conversation_id
        );
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to create notifications for group chat messages
CREATE OR REPLACE FUNCTION create_group_message_notification()
RETURNS TRIGGER AS $$
DECLARE
    conversation_record RECORD;
    member_record RECORD;
    sender_name TEXT;
BEGIN
    -- Get conversation details
    SELECT * INTO conversation_record FROM public.conversations WHERE id = NEW.conversation_id;
    
    IF conversation_record IS NULL THEN
        RETURN NEW;
    END IF;
    
    -- Only process group conversations
    IF conversation_record.is_group = false THEN
        RETURN NEW;
    END IF;
    
    -- Get sender name
    SELECT COALESCE(username, full_name, 'Someone') INTO sender_name 
    FROM public.profiles WHERE id = NEW.sender_id;
    
    -- Notify all active group members except the sender
    FOR member_record IN 
        SELECT DISTINCT user_id FROM public.conversation_members
        WHERE conversation_id = NEW.conversation_id
          AND user_id != NEW.sender_id
          AND deleted_at IS NULL
    LOOP
        -- Don't notify if users are blocked
        IF NOT are_users_blocked(NEW.sender_id, member_record.user_id) THEN
            INSERT INTO notifications (
                recipient_id, actor_id, notification_type,
                title, body, entity_type, entity_id
            ) VALUES (
                member_record.user_id, NEW.sender_id, 'group_message',
                'New group message', sender_name || ' sent a message to your group',
                'conversation', NEW.conversation_id
            );
        END IF;
    END LOOP;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger for DM notifications
DROP TRIGGER IF EXISTS trigger_dm_message_notification ON public.chat_messages;

CREATE TRIGGER trigger_dm_message_notification
AFTER INSERT ON public.chat_messages
FOR EACH ROW
EXECUTE FUNCTION create_dm_notification();

-- Create trigger for group message notifications
DROP TRIGGER IF EXISTS trigger_group_message_notification ON public.chat_messages;

CREATE TRIGGER trigger_group_message_notification
AFTER INSERT ON public.chat_messages
FOR EACH ROW
EXECUTE FUNCTION create_group_message_notification();

-- Comments on functions and triggers
COMMENT ON FUNCTION are_users_blocked(UUID, UUID) IS
    'Helper function to check if two users have blocked each other';

COMMENT ON FUNCTION create_dm_notification() IS
    'Creates a notification when a message is sent in a direct message conversation';

COMMENT ON FUNCTION create_group_message_notification() IS
    'Creates notifications for all active group members when a message is sent in a group conversation';

COMMENT ON TRIGGER trigger_dm_message_notification ON public.chat_messages IS
    'Triggers dm notifications when a message is inserted in a 1:1 conversation';

COMMENT ON TRIGGER trigger_group_message_notification ON public.chat_messages IS
    'Triggers group notifications when a message is inserted in a group conversation';
