-- Fix story suggestion notifications: no consecutive/same-day repeats, ensure 6am/6pm IST.
-- 1) Exclude stories already suggested to this user in the last 48 hours (no repeat in a row or same day).
-- 2) Cron is in UTC: 00:30 and 12:30 UTC = 6:00 and 18:00 IST. DB must stay in UTC for correct times.

-- Index for "recent story suggestions per user" lookup
CREATE INDEX IF NOT EXISTS idx_notifications_story_suggestion_recent
  ON notifications (recipient_id, created_at DESC)
  WHERE notification_type = 'story_suggestion' AND entity_id IS NOT NULL;

CREATE OR REPLACE FUNCTION send_story_suggestion_notifications()
RETURNS integer
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  rec RECORD;
  story_rec RECORD;
  sent_count integer := 0;
BEGIN
  -- For each user with an active device, pick one random featured story
  -- that was NOT suggested to this user in the last 48 hours (no same-day or back-to-back repeats).
  FOR rec IN
    SELECT DISTINCT d.user_id AS recipient_id
    FROM user_devices d
    WHERE d.is_active = true
  LOOP
    SELECT s.id, s.title
    INTO story_rec
    FROM stories s
    WHERE s.is_featured = true
      AND s.image_url IS NOT NULL
      AND TRIM(COALESCE(s.title, '')) <> ''
      AND COALESCE(s.title, '') <> 'Untitled Story'
      AND s.user_id IS NOT NULL
      AND s.user_id IS DISTINCT FROM rec.recipient_id
      -- Exclude stories we already suggested to this user in the last 48 hours
      AND NOT EXISTS (
        SELECT 1
        FROM notifications n
        WHERE n.recipient_id = rec.recipient_id
          AND n.notification_type = 'story_suggestion'
          AND n.entity_id = s.id
          AND n.created_at > now() - interval '48 hours'
      )
    ORDER BY random()
    LIMIT 1;

    IF FOUND THEN
      INSERT INTO notifications (
        recipient_id,
        notification_type,
        title,
        body,
        entity_type,
        entity_id,
        action_url
      ) VALUES (
        rec.recipient_id,
        'story_suggestion'::notification_type,
        'Story suggestion',
        COALESCE(story_rec.title, 'A story you might like'),
        'story',
        story_rec.id,
        '/home/stories/' || story_rec.id
      );
      sent_count := sent_count + 1;
    END IF;
  END LOOP;

  RETURN sent_count;
END;
$$;

COMMENT ON FUNCTION send_story_suggestion_notifications() IS
  'Inserts one story_suggestion per user; excludes stories suggested in last 48h. Run at 00:30 and 12:30 UTC (6:00 and 18:00 IST).';

-- Ensure job runs at 6:00 and 18:00 IST (00:30 and 12:30 UTC).
-- Unschedule first so re-running this migration doesn't create a duplicate job.
DO $$
BEGIN
  PERFORM cron.unschedule('story-suggestion-6am-6pm-ist');
EXCEPTION
  WHEN OTHERS THEN NULL;  -- job missing or wrong schema (e.g. extensions.job)
END
$$;
SELECT cron.schedule(
  'story-suggestion-6am-6pm-ist',
  '30 0,12 * * *',
  $$ SELECT send_story_suggestion_notifications(); $$
);
