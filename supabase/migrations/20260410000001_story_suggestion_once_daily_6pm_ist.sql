-- Enforce story suggestion notifications once daily at 6:00 PM IST only.
-- 1) Keep existing 48-hour anti-repeat story logic.
-- 2) Add per-user per-IST-day guard to prevent duplicate sends from duplicate cron jobs.
-- 3) Ensure only one cron job exists at 12:30 UTC (18:00 IST).

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
  -- For each user with an active device, send at most one suggestion per IST day.
  FOR rec IN
    SELECT DISTINCT d.user_id AS recipient_id
    FROM user_devices d
    WHERE d.is_active = true
      AND NOT EXISTS (
        SELECT 1
        FROM notifications n
        WHERE n.recipient_id = d.user_id
          AND n.notification_type = 'story_suggestion'
          AND (n.created_at AT TIME ZONE 'Asia/Kolkata')::date =
              (now() AT TIME ZONE 'Asia/Kolkata')::date
      )
  LOOP
    -- Pick one random featured story not suggested to this user in the last 48h.
    SELECT s.id, s.title
    INTO story_rec
    FROM stories s
    WHERE s.is_featured = true
      AND s.image_url IS NOT NULL
      AND TRIM(COALESCE(s.title, '')) <> ''
      AND COALESCE(s.title, '') <> 'Untitled Story'
      AND s.user_id IS NOT NULL
      AND s.user_id IS DISTINCT FROM rec.recipient_id
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
  'Inserts one story_suggestion per user; max once per IST day and excludes stories suggested in last 48h. Runs at 12:30 UTC (18:00 IST).';

-- Remove legacy jobs first (best-effort), then schedule exactly one daily 6 PM IST job.
DO $$
BEGIN
  BEGIN
    PERFORM cron.unschedule('story-suggestion-6am-6pm-ist');
  EXCEPTION
    WHEN OTHERS THEN NULL;
  END;

  BEGIN
    PERFORM cron.unschedule('story-suggestion-6am-6pm');
  EXCEPTION
    WHEN OTHERS THEN NULL;
  END;

  BEGIN
    PERFORM cron.unschedule('story-suggestion-6pm-ist');
  EXCEPTION
    WHEN OTHERS THEN NULL;
  END;
END
$$;

SELECT cron.schedule(
  'story-suggestion-6pm-ist',
  '30 12 * * *',
  $$ SELECT send_story_suggestion_notifications(); $$
);
