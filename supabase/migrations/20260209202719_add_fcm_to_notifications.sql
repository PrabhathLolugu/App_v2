-- Migration: Add FCM tracking columns to notifications table
-- Description: Track push notification delivery status

-- Add FCM tracking columns
ALTER TABLE public.notifications
ADD COLUMN IF NOT EXISTS fcm_sent BOOLEAN DEFAULT false,
ADD COLUMN IF NOT EXISTS fcm_sent_at TIMESTAMPTZ,
ADD COLUMN IF NOT EXISTS fcm_message_id TEXT;

-- Create index for tracking unsent notifications (for retry logic)
CREATE INDEX IF NOT EXISTS idx_notifications_fcm_unsent
    ON public.notifications(id)
    WHERE fcm_sent = false;

-- Comment on columns
COMMENT ON COLUMN public.notifications.fcm_sent IS 'Whether push notification was successfully sent';
COMMENT ON COLUMN public.notifications.fcm_sent_at IS 'Timestamp when push notification was sent';
COMMENT ON COLUMN public.notifications.fcm_message_id IS 'FCM message ID for tracking delivery';;
