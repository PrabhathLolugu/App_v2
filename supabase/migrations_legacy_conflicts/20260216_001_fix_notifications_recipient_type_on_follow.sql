-- Migration: Fix notifications.recipient_type NOT NULL violation on follow
-- Description: Follow trigger (or app) inserts into notifications but does not set
-- recipient_type. Setting a default ensures new rows get a value; backfill existing nulls.

-- Set default so any INSERT that omits recipient_type gets 'profile'
ALTER TABLE public.notifications
  ALTER COLUMN recipient_type SET DEFAULT 'profile';

-- Backfill existing rows where recipient_type is null (e.g. from follow notifications)
UPDATE public.notifications
SET recipient_type = 'profile'
WHERE recipient_type IS NULL;
