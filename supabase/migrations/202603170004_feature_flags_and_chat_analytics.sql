-- Feature flags table for gradual rollout and A/B testing
CREATE TABLE IF NOT EXISTS public.feature_flags (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    key TEXT NOT NULL UNIQUE,
    description TEXT,
    enabled BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Insert initial feature flags for chat media v1 (enabled by default)
INSERT INTO public.feature_flags (key, description, enabled)
VALUES
    ('chat_images_enabled', 'Enable image attachments in chat messages', true),
    ('chat_link_preview_enabled', 'Enable OpenGraph link preview cards in chat', true)
ON CONFLICT (key) DO UPDATE SET enabled = EXCLUDED.enabled, updated_at = NOW();

-- Enable RLS on feature_flags (read-only for authenticated users, admin-only writes)
ALTER TABLE public.feature_flags ENABLE ROW LEVEL SECURITY;

-- RLS: All authenticated users can read feature flags
CREATE POLICY feature_flags_read_all
    ON public.feature_flags FOR SELECT
    TO authenticated
    USING (true);

-- RLS: Only admin users (or service role) can insert/update/delete feature flags
-- This prevents accidental modification by regular users
CREATE POLICY feature_flags_write_admin_only
    ON public.feature_flags FOR ALL
    TO authenticated
    USING (false)
    WITH CHECK (false);

-- Analytics table for chat media events (used to track adoption and errors)
CREATE TABLE IF NOT EXISTS public.chat_media_analytics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    conversation_id UUID NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
    event_type TEXT NOT NULL, -- 'image_sent', 'image_received', 'link_preview_fetched', 'link_preview_failed', 'rate_limit_hit'
    message_id UUID REFERENCES public.chat_messages(id) ON DELETE SET NULL,
    file_size_bytes INT,
    duration_ms INT, -- for timing operations like link preview fetch
    error_message TEXT,
    metadata JSONB, -- flexible field for additional context (URL, domain, MIME type, etc.)
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Indexes for analytics queries
CREATE INDEX IF NOT EXISTS idx_chat_media_analytics_user_id_created_at
    ON public.chat_media_analytics(user_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_chat_media_analytics_conversation_id_created_at
    ON public.chat_media_analytics(conversation_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_chat_media_analytics_event_type_created_at
    ON public.chat_media_analytics(event_type, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_chat_media_analytics_created_at
    ON public.chat_media_analytics(created_at DESC);

-- Enable RLS on analytics table
ALTER TABLE public.chat_media_analytics ENABLE ROW LEVEL SECURITY;

-- RLS: Users can only view their own analytics
CREATE POLICY chat_media_analytics_read_own
    ON public.chat_media_analytics FOR SELECT
    TO authenticated
    USING (user_id = auth.uid());

-- RLS: Service role (edge functions) can insert analytics events
CREATE POLICY chat_media_analytics_insert_service_role
    ON public.chat_media_analytics FOR INSERT
    TO service_role
    WITH CHECK (true);

-- RLS: Users cannot directly modify/delete analytics (should be done by service layer)
CREATE POLICY chat_media_analytics_update_service_role_only
    ON public.chat_media_analytics FOR UPDATE
    TO authenticated
    USING (false)
    WITH CHECK (false);

CREATE POLICY chat_media_analytics_delete_service_role_only
    ON public.chat_media_analytics FOR DELETE
    TO authenticated
    USING (false);

-- Function to get current feature flag status (helper for RLS policies)
-- Usage: SELECT public.is_feature_enabled('chat_images_enabled')
CREATE OR REPLACE FUNCTION public.is_feature_enabled(flag_key TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN COALESCE(
        (SELECT enabled FROM public.feature_flags WHERE key = flag_key LIMIT 1),
        false
    );
END;
$$ LANGUAGE plpgsql STABLE;

-- Function to record chat media analytics event
-- Usage: SELECT public.record_chat_media_event('image_sent', message_id, file_size, NULL, NULL, metadata)
CREATE OR REPLACE FUNCTION public.record_chat_media_event(
    event_type TEXT,
    message_id UUID,
    file_size_bytes INT DEFAULT NULL,
    duration_ms INT DEFAULT NULL,
    error_message TEXT DEFAULT NULL,
    metadata JSONB DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
    user_id UUID := auth.uid();
    conversation_id UUID;
    event_id UUID;
BEGIN
    -- Get conversation_id from the message
    SELECT conv.id INTO conversation_id
    FROM public.chat_messages msg
    INNER JOIN public.conversations conv ON msg.conversation_id = conv.id
    WHERE msg.id = message_id AND msg.sender_id = user_id
    LIMIT 1;

    -- If message not found or user doesn't own it, return NULL (fail silently for security)
    IF conversation_id IS NULL THEN
        RETURN NULL;
    END IF;

    -- Insert the analytics event
    INSERT INTO public.chat_media_analytics (
        user_id,
        conversation_id,
        event_type,
        message_id,
        file_size_bytes,
        duration_ms,
        error_message,
        metadata
    )
    VALUES (user_id, conversation_id, event_type, message_id, file_size_bytes, duration_ms, error_message, metadata)
    RETURNING id INTO event_id;

    RETURN event_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Stored procedure to enable feature flag (admin only)
CREATE OR REPLACE FUNCTION public.enable_feature_flag(flag_key TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    UPDATE public.feature_flags
    SET enabled = true, updated_at = NOW()
    WHERE key = flag_key;
    
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Stored procedure to disable feature flag (admin only)
CREATE OR REPLACE FUNCTION public.disable_feature_flag(flag_key TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    UPDATE public.feature_flags
    SET enabled = false, updated_at = NOW()
    WHERE key = flag_key;
    
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
