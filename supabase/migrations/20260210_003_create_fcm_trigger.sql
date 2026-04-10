-- Migration: Create trigger to invoke FCM edge function on notification insert
-- Description: Automatically sends push notifications when new notifications are created
-- Note: Requires pg_net extension to be enabled in Supabase

-- Enable pg_net extension if not already enabled
CREATE EXTENSION IF NOT EXISTS pg_net WITH SCHEMA extensions;

-- Create app_settings table for FCM configuration
CREATE TABLE IF NOT EXISTS public.app_settings (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Secure the table - only service role can access
ALTER TABLE public.app_settings ENABLE ROW LEVEL SECURITY;
-- No policies = no access for authenticated users, only service role can read

-- Function to trigger FCM push notification via edge function
CREATE OR REPLACE FUNCTION trigger_fcm_on_notification_insert()
RETURNS TRIGGER AS $$
DECLARE
    supabase_url TEXT;
    service_role_key TEXT;
BEGIN
    -- Get Supabase configuration from app_settings table
    SELECT value INTO supabase_url FROM public.app_settings WHERE key = 'supabase_url';
    SELECT value INTO service_role_key FROM public.app_settings WHERE key = 'service_role_key';

    -- Skip if settings are not configured
    IF supabase_url IS NULL OR service_role_key IS NULL THEN
        RAISE WARNING 'FCM trigger: Missing supabase_url or service_role_key in app_settings';
        RETURN NEW;
    END IF;

    -- Make async HTTP request to edge function
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
            'actor_id', NEW.actor_id
        )
    );

    RETURN NEW;
EXCEPTION
    WHEN OTHERS THEN
        -- Log error but don't fail the insert
        RAISE WARNING 'FCM trigger error: %', SQLERRM;
        RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger on notifications table
DROP TRIGGER IF EXISTS fcm_on_notification_insert ON public.notifications;

CREATE TRIGGER fcm_on_notification_insert
    AFTER INSERT ON public.notifications
    FOR EACH ROW
    EXECUTE FUNCTION trigger_fcm_on_notification_insert();

-- Comment on function
COMMENT ON FUNCTION trigger_fcm_on_notification_insert() IS
    'Triggers FCM push notification delivery via edge function when a new notification is inserted';
