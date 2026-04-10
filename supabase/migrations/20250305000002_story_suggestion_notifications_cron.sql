-- Migration: Daily story suggestion notifications at 6am and 6pm IST
-- Sends one push per user with a suggested featured story (other-user-generated, has image, not untitled).
-- Existing trigger on notifications invokes send-push-notification for each insert.
-- IST = UTC+5:30, so 6:00 IST = 00:30 UTC and 18:00 IST = 12:30 UTC.

CREATE EXTENSION IF NOT EXISTS pg_cron WITH SCHEMA extensions;

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
  -- For each user with an active device, pick one random featured story (other-user-generated)
  FOR rec IN
    SELECT DISTINCT d.user_id AS recipient_id
    FROM user_devices d
    WHERE d.is_active = true
  LOOP
    -- Pick one random featured story that is NOT by this user (other-user-generated)
    SELECT s.id, s.title
    INTO story_rec
    FROM stories s
    WHERE s.is_featured = true
      AND s.image_url IS NOT NULL
      AND TRIM(COALESCE(s.title, '')) <> ''
      AND COALESCE(s.title, '') <> 'Untitled Story'
      AND s.user_id IS NOT NULL
      AND s.user_id IS DISTINCT FROM rec.recipient_id
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
  'Inserts one story_suggestion notification per user with an active device; trigger sends FCM. Run at 6:00 and 18:00 IST.';

-- Schedule at 6:00 and 18:00 IST daily (00:30 and 12:30 UTC).
-- If you previously had 'story-suggestion-6am-6pm' (UTC), remove it in Dashboard:
-- Database > Extensions > pg_cron, or run: SELECT cron.unschedule('story-suggestion-6am-6pm'); as superuser.
SELECT cron.schedule(
  'story-suggestion-6am-6pm-ist',
  '30 0,12 * * *',
  $$ SELECT send_story_suggestion_notifications(); $$
);
