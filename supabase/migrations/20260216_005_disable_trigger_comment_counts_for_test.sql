-- If comments are not saving to the database, the trigger_comment_counts
-- (which runs update_comment_counts() after each INSERT/DELETE on comments)
-- may be failing and rolling back the transaction.
--
-- Run this migration to temporarily disable that trigger and test.
-- If comments start saving, fix update_comment_counts() (e.g. ensure it
-- updates the correct table/column and handles missing rows), then
-- re-enable with:
--
--   CREATE TRIGGER trigger_comment_counts
--   AFTER INSERT OR DELETE ON comments FOR EACH ROW
--   EXECUTE FUNCTION update_comment_counts();

DROP TRIGGER IF EXISTS trigger_comment_counts ON public.comments;
