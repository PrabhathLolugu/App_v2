-- Migration: Create user_devices table for FCM token storage
-- Description: Stores FCM tokens per device for push notification delivery

CREATE TABLE IF NOT EXISTS public.user_devices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    fcm_token TEXT NOT NULL,
    device_type TEXT NOT NULL CHECK (device_type IN ('ios', 'android', 'web')),
    device_info JSONB DEFAULT '{}',
    is_active BOOLEAN DEFAULT true,
    last_active_at TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT user_devices_fcm_token_unique UNIQUE(fcm_token),
    CONSTRAINT user_devices_user_token_unique UNIQUE(user_id, fcm_token)
);

-- Create index for fast lookup of active devices by user
CREATE INDEX IF NOT EXISTS idx_user_devices_user_active
    ON public.user_devices(user_id)
    WHERE is_active = true;

-- Create index for token lookup (for token invalidation)
CREATE INDEX IF NOT EXISTS idx_user_devices_fcm_token
    ON public.user_devices(fcm_token);

-- Enable Row Level Security
ALTER TABLE public.user_devices ENABLE ROW LEVEL SECURITY;

-- RLS Policies: Users can only manage their own devices
CREATE POLICY "Users can view own devices"
    ON public.user_devices
    FOR SELECT
    USING (auth.uid()::text = user_id::text);

CREATE POLICY "Users can insert own devices"
    ON public.user_devices
    FOR INSERT
    WITH CHECK (auth.uid()::text = user_id::text);

CREATE POLICY "Users can update own devices"
    ON public.user_devices
    FOR UPDATE
    USING (auth.uid()::text = user_id::text);

CREATE POLICY "Users can delete own devices"
    ON public.user_devices
    FOR DELETE
    USING (auth.uid()::text = user_id::text);

-- Function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_user_devices_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to auto-update updated_at on row changes
CREATE TRIGGER trigger_user_devices_updated_at
    BEFORE UPDATE ON public.user_devices
    FOR EACH ROW
    EXECUTE FUNCTION update_user_devices_updated_at();

-- Grant access to authenticated users
GRANT SELECT, INSERT, UPDATE, DELETE ON public.user_devices TO authenticated;

-- Comment on table
COMMENT ON TABLE public.user_devices IS 'Stores FCM tokens for push notifications per user device';
COMMENT ON COLUMN public.user_devices.device_type IS 'Platform type: ios, android, or web';
COMMENT ON COLUMN public.user_devices.device_info IS 'Optional device metadata (model, OS version, etc.)';
COMMENT ON COLUMN public.user_devices.is_active IS 'Whether this token is still valid for notifications';;
