-- Migration: Add story_suggestion to notification_type enum
-- Used for daily 6am/6pm story suggestion push notifications

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_enum
    WHERE enumlabel = 'story_suggestion'
      AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'notification_type')
  ) THEN
    ALTER TYPE notification_type ADD VALUE 'story_suggestion';
  END IF;
END
$$;
