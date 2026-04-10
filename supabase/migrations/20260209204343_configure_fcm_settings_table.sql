-- Create a settings table for FCM configuration
CREATE TABLE IF NOT EXISTS public.app_settings (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Insert FCM settings
INSERT INTO public.app_settings (key, value) VALUES
    ('supabase_url', 'https://xmbygaeixvzlyhbtkbnp.supabase.co'),
    ('service_role_key', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhtYnlnYWVpeHZ6bHloYnRrYm5wIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MTU0MDM4MCwiZXhwIjoyMDc3MTE2MzgwfQ.CvrKfYD97CWSQrVzvYiFLwXGLswY5mo4hAoC1tXNK9o')
ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value, updated_at = NOW();

-- Secure the table - only service role can access
ALTER TABLE public.app_settings ENABLE ROW LEVEL SECURITY;

-- No policies = no access for authenticated users, only service role can read;
