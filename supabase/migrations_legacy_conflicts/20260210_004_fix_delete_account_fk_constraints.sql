-- Fix FK constraints that block user account deletion (currently NO ACTION)
-- These must be CASCADE or SET NULL so that deleting from auth.users cascades properly.

-- 1. discussions.author_id → CASCADE (delete user's discussions when account deleted)
ALTER TABLE discussions
  DROP CONSTRAINT IF EXISTS discussions_author_id_fkey,
  ADD CONSTRAINT discussions_author_id_fkey
    FOREIGN KEY (author_id) REFERENCES public.users(id) ON DELETE CASCADE;

-- 2. discussion_comments.user_id → CASCADE (delete user's comments when account deleted)
ALTER TABLE discussion_comments
  DROP CONSTRAINT IF EXISTS discussion_comments_user_id_fkey,
  ADD CONSTRAINT discussion_comments_user_id_fkey
    FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

-- 3. map_comments.user_id → CASCADE (delete user's map comments when account deleted)
ALTER TABLE map_comments
  DROP CONSTRAINT IF EXISTS map_comments_user_id_fkey,
  ADD CONSTRAINT map_comments_user_id_fkey
    FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;

-- 4. teachers.approved_by → SET NULL (approver is not the teacher; keep teacher record)
ALTER TABLE teachers
  DROP CONSTRAINT IF EXISTS teachers_approved_by_fkey,
  ADD CONSTRAINT teachers_approved_by_fkey
    FOREIGN KEY (approved_by) REFERENCES public.users(id) ON DELETE SET NULL;
