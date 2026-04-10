-- Add scheduling fields and cron-based publisher for posts
-- All timestamps are stored in UTC. The app is responsible for converting
-- user-selected IST times to UTC when writing scheduled_at.

-- 1) Extend posts table with scheduling columns
ALTER TABLE posts
  ADD COLUMN IF NOT EXISTS scheduled_at TIMESTAMPTZ NULL,
  ADD COLUMN IF NOT EXISTS published_at TIMESTAMPTZ NULL,
  ADD COLUMN IF NOT EXISTS status TEXT
    CHECK (status IN ('draft', 'scheduled', 'published', 'cancelled'));

-- Backfill status for existing rows and set a default.
UPDATE posts
SET status = COALESCE(status, 'published');

ALTER TABLE posts
  ALTER COLUMN status SET DEFAULT 'published',
  ALTER COLUMN status SET NOT NULL;

-- Index to efficiently find due scheduled posts
CREATE INDEX IF NOT EXISTS idx_posts_status_scheduled_at
  ON posts (status, scheduled_at);

-- 2) Function to publish due scheduled posts
CREATE OR REPLACE FUNCTION publish_scheduled_posts()
RETURNS integer
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  updated_count integer := 0;
BEGIN
  -- Promote all due scheduled posts to published.
  -- We keep everything in UTC; the app must write scheduled_at as UTC.
  UPDATE posts
  SET
    status = 'published',
    published_at = now(),
    -- Optionally bump created_at so newly published posts appear fresh in feeds.
    created_at = GREATEST(created_at, now())
  WHERE
    status = 'scheduled'
    AND scheduled_at IS NOT NULL
    AND scheduled_at <= now();

  GET DIAGNOSTICS updated_count = ROW_COUNT;

  RETURN updated_count;
END;
$$;

COMMENT ON FUNCTION publish_scheduled_posts() IS
  'Publishes posts where status = scheduled and scheduled_at <= now(); all times are UTC, app converts IST to UTC.';

-- 3) Cron job to run publisher frequently
-- We schedule every minute so posts go live close to their scheduled time.
-- Cron uses UTC; IST (UTC+5:30) conversion happens in the app when writing scheduled_at.
DO $$
BEGIN
  PERFORM cron.unschedule('publish-scheduled-posts-every-minute');
EXCEPTION
  WHEN OTHERS THEN NULL; -- job may not exist yet
END
$$;

SELECT cron.schedule(
  'publish-scheduled-posts-every-minute',
  '* * * * *',
  $$ SELECT publish_scheduled_posts(); $$
);

