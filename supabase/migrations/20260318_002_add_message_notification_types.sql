-- Migration: Add message and group_message notification types
-- Date: 2026-03-18
-- Description: Adds new notification types for direct messages and group chat messages.
--              These types are used to notify users when they receive messages in DMs or group chats.

DO $$
BEGIN
  -- Add 'message' type for direct messages
  IF NOT EXISTS (
    SELECT 1 FROM pg_enum
    WHERE enumlabel = 'message'
      AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'notification_type')
  ) THEN
    ALTER TYPE notification_type ADD VALUE 'message';
  END IF;

  -- Add 'group_message' type for group chat messages
  IF NOT EXISTS (
    SELECT 1 FROM pg_enum
    WHERE enumlabel = 'group_message'
      AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'notification_type')
  ) THEN
    ALTER TYPE notification_type ADD VALUE 'group_message';
  END IF;
END
$$;
