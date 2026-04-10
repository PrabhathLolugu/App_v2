-- Migration: Extend message_requests status values and add expiry handling
-- - Adds new statuses: expired, revoked
-- - Adds expires_at / expired_at columns
-- - Adds a cron-based expiry function to automatically expire old requests

-- Allow new statuses on message_requests.status
ALTER TABLE public.message_requests
    DROP CONSTRAINT IF EXISTS message_requests_status_check;

ALTER TABLE public.message_requests
    ADD CONSTRAINT message_requests_status_check
    CHECK (status IN ('pending', 'accepted', 'rejected', 'expired', 'revoked'));


-- Add expiry metadata columns
ALTER TABLE public.message_requests
    ADD COLUMN IF NOT EXISTS expires_at TIMESTAMPTZ;

ALTER TABLE public.message_requests
    ADD COLUMN IF NOT EXISTS expired_at TIMESTAMPTZ;

-- Backfill expires_at for existing rows where it is NULL.
-- Default TTL is 48 hours from creation.
UPDATE public.message_requests
SET expires_at = created_at + INTERVAL '48 hours'
WHERE expires_at IS NULL;

-- Set default TTL for new rows.
ALTER TABLE public.message_requests
    ALTER COLUMN expires_at SET DEFAULT (NOW() + INTERVAL '48 hours');

-- Enforce NOT NULL on expires_at now that it has been backfilled.
ALTER TABLE public.message_requests
    ALTER COLUMN expires_at SET NOT NULL;


-- Function to expire old message requests
CREATE OR REPLACE FUNCTION public.expire_old_message_requests()
RETURNS integer
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  expired_count integer;
BEGIN
  UPDATE public.message_requests
  SET status = 'expired',
      expired_at = NOW()
  WHERE status = 'pending'
    AND expires_at <= NOW();

  GET DIAGNOSTICS expired_count = ROW_COUNT;
  RETURN expired_count;
END;
$$;

COMMENT ON FUNCTION public.expire_old_message_requests() IS
  'Marks pending message_requests as expired when expires_at has passed. Returns number of rows updated.';


-- Ensure pg_cron extension is available
CREATE EXTENSION IF NOT EXISTS pg_cron WITH SCHEMA extensions;

-- Schedule the expiry job to run every 30 minutes
SELECT cron.schedule(
  'expire-message-requests-every-30-min',
  '*/30 * * * *',
  $$ SELECT public.expire_old_message_requests(); $$
);

