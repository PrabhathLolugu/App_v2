-- TEST ONLY: Disable the comment notification trigger to see if comments start working.
-- If comments work after running this, the trigger create_comment_notification was failing
-- (e.g. inserting into notifications without recipient_type).
--
-- Then either:
-- 1. Run 20260216_001_fix_notifications_recipient_type_on_follow.sql so notifications
--    get recipient_type default 'profile', then re-enable the trigger (run the RE-enable block below).
-- 2. Or fix your create_comment_notification() function in Supabase to set recipient_type on insert.
--
-- To RE-ENABLE the trigger after fixing notifications:
--   CREATE TRIGGER trigger_comment_notification
--   AFTER INSERT ON comments FOR EACH ROW
--   EXECUTE FUNCTION create_comment_notification();

DROP TRIGGER IF EXISTS trigger_comment_notification ON public.comments;
