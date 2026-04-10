-- Mention notifications when a published post includes metadata.mentions (resolved user ids).
-- Fires on immediate publish (INSERT published) and when scheduled posts become published (UPDATE).

CREATE OR REPLACE FUNCTION public.notify_post_mentions()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  mention jsonb;
  mention_uid uuid;
  actor_name text;
  content_t text;
BEGIN
  IF NEW.status IS DISTINCT FROM 'published' THEN
    RETURN NEW;
  END IF;

  -- Edits after publish: do not re-notify.
  IF TG_OP = 'UPDATE' AND OLD.status = 'published' AND NEW.status = 'published' THEN
    RETURN NEW;
  END IF;

  IF NEW.metadata IS NULL OR NEW.metadata->'mentions' IS NULL THEN
    RETURN NEW;
  END IF;

  IF jsonb_typeof(NEW.metadata->'mentions') <> 'array' THEN
    RETURN NEW;
  END IF;

  SELECT COALESCE(username, full_name, 'Someone')
    INTO actor_name
    FROM profiles
   WHERE id = NEW.author_id;

  content_t := NEW.post_type::text;

  FOR mention IN
    SELECT * FROM jsonb_array_elements(NEW.metadata->'mentions')
  LOOP
    mention_uid := NULL;
    IF mention ? 'user_id' THEN
      BEGIN
        mention_uid := (mention->>'user_id')::uuid;
      EXCEPTION
        WHEN invalid_text_representation THEN
          mention_uid := NULL;
      END;
    END IF;

    IF mention_uid IS NULL OR mention_uid = NEW.author_id THEN
      CONTINUE;
    END IF;

    INSERT INTO public.notifications (
      recipient_id,
      actor_id,
      notification_type,
      title,
      body,
      entity_type,
      entity_id,
      metadata
    ) VALUES (
      mention_uid,
      NEW.author_id,
      'mention',
      'Mention',
      COALESCE(actor_name, 'Someone') || ' mentioned you in a post',
      'post',
      NEW.id,
      jsonb_strip_nulls(
        jsonb_build_object(
          'content_type', content_t,
          'parent_entity_type', 'post',
          'parent_entity_id', NEW.id
        )
      )
    );
  END LOOP;

  RETURN NEW;
END;
$$;

COMMENT ON FUNCTION public.notify_post_mentions() IS
  'Inserts mention notifications for metadata.mentions when a post is published (insert or scheduled->published).';

DROP TRIGGER IF EXISTS trigger_notify_post_mentions_insert ON public.posts;

CREATE TRIGGER trigger_notify_post_mentions_insert
  AFTER INSERT ON public.posts
  FOR EACH ROW
  EXECUTE FUNCTION public.notify_post_mentions();

DROP TRIGGER IF EXISTS trigger_notify_post_mentions_update ON public.posts;

CREATE TRIGGER trigger_notify_post_mentions_update
  AFTER UPDATE OF status ON public.posts
  FOR EACH ROW
  EXECUTE FUNCTION public.notify_post_mentions();
