-- Backfill helper for cleaning up data of users who should be fully deleted.
-- This is NOT a migration; run manually in Supabase SQL editor or psql.
--
-- Usage pattern:
--   1. Build a temporary table of user_ids that should be treated as deleted.
--   2. Call the same cleanup steps used by the delete-user-account edge function.
--
-- IMPORTANT:
-- - Run in small batches and verify effects before running on all users.
-- - Always back up your data (or run on a non-production database first).

BEGIN;

-- Example: define the set of users to clean up.
-- Replace this with your own criteria or explicit list.
-- CREATE TEMP TABLE tmp_deleted_user_ids (id uuid PRIMARY KEY);
-- INSERT INTO tmp_deleted_user_ids (id)
-- VALUES
--   ('00000000-0000-0000-0000-000000000001'),
--   ('00000000-0000-0000-0000-000000000002');

-- 1) Clean up profiles-linked content by deleting from profiles.
--    This will cascade to posts, comments, likes, bookmarks, notifications,
--    shares, post_reports, follows, etc. via existing foreign keys.
-- DELETE FROM profiles
-- WHERE id IN (SELECT id FROM tmp_deleted_user_ids);

-- 2) Clean up public.users-linked content (map/discussions).
--    This will cascade to discussions, discussion_comments, map_comments, etc.
-- DELETE FROM public.users
-- WHERE id IN (SELECT id FROM tmp_deleted_user_ids);

-- 3) Clean up story_chats, which uses a TEXT user_id.
-- DELETE FROM public.story_chats
-- WHERE user_id IN (
--   SELECT id::text FROM tmp_deleted_user_ids
-- );

-- 4) Finally, delete auth users themselves so all remaining
--    auth.users-based cascades (conversations, devices, etc.) run.
-- NOTE: In production, this is normally done via the edge function using
--       supabase.auth.admin.deleteUser, not via direct SQL.
--       For backfill/testing you may instead call the edge function per user.

COMMIT;

