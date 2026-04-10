-- Migration: Ensure notification delivery triggers are active
-- Date: 2026-03-20
-- Description:
--   Rebind trigger definitions to their latest function implementations so
--   notification inserts always invoke push delivery and chat events continue
--   creating message notifications.

DO $$
BEGIN
    IF to_regprocedure('public.trigger_fcm_on_notification_insert()') IS NOT NULL THEN
        DROP TRIGGER IF EXISTS fcm_on_notification_insert ON public.notifications;

        CREATE TRIGGER fcm_on_notification_insert
            AFTER INSERT ON public.notifications
            FOR EACH ROW
            EXECUTE FUNCTION public.trigger_fcm_on_notification_insert();
    ELSE
        RAISE WARNING 'Function public.trigger_fcm_on_notification_insert() not found. Skipping fcm_on_notification_insert trigger creation.';
    END IF;
END
$$;

DO $$
BEGIN
    IF to_regprocedure('public.create_dm_notification()') IS NOT NULL THEN
        DROP TRIGGER IF EXISTS trigger_dm_message_notification ON public.chat_messages;

        CREATE TRIGGER trigger_dm_message_notification
            AFTER INSERT ON public.chat_messages
            FOR EACH ROW
            EXECUTE FUNCTION public.create_dm_notification();
    ELSE
        RAISE WARNING 'Function public.create_dm_notification() not found. Skipping DM notification trigger creation.';
    END IF;
END
$$;

DO $$
BEGIN
    IF to_regprocedure('public.create_group_message_notification()') IS NOT NULL THEN
        DROP TRIGGER IF EXISTS trigger_group_message_notification ON public.chat_messages;

        CREATE TRIGGER trigger_group_message_notification
            AFTER INSERT ON public.chat_messages
            FOR EACH ROW
            EXECUTE FUNCTION public.create_group_message_notification();
    ELSE
        RAISE WARNING 'Function public.create_group_message_notification() not found. Skipping group notification trigger creation.';
    END IF;
END
$$;

COMMENT ON TRIGGER fcm_on_notification_insert ON public.notifications IS
    'Ensures each inserted notification invokes push delivery function';

COMMENT ON TRIGGER trigger_dm_message_notification ON public.chat_messages IS
    'Ensures DM message inserts create message notifications';

COMMENT ON TRIGGER trigger_group_message_notification ON public.chat_messages IS
    'Ensures group message inserts create group message notifications';
