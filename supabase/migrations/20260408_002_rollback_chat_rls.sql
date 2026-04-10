-- Migration: Roll back chat RLS changes that broke existing functionality
-- Date: 2026-04-08
--
-- This intentionally restores the previous behavior by disabling the new
-- RLS configuration and removing the helper functions/policies introduced
-- by 20260408_001_fix_chat_rls_conversations_members.sql.

-- Revert conversation_members to the previous temporary state.
ALTER TABLE IF EXISTS public.conversation_members DISABLE ROW LEVEL SECURITY;

-- Revert conversations to the previous state if this migration enabled it.
ALTER TABLE IF EXISTS public.conversations DISABLE ROW LEVEL SECURITY;

-- Restore group detail columns expected by the app UI.
ALTER TABLE IF EXISTS public.conversations
  ADD COLUMN IF NOT EXISTS created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL;

ALTER TABLE IF EXISTS public.conversations
  ADD COLUMN IF NOT EXISTS group_description TEXT;

-- Backfill created_by from existing owner rows when available.
WITH owner_rows AS (
  SELECT DISTINCT ON (cm.conversation_id)
    cm.conversation_id,
    cm.user_id
  FROM public.conversation_members cm
  WHERE lower(coalesce(cm.role, 'member')) = 'owner'
  ORDER BY cm.conversation_id, cm.joined_at ASC, cm.created_at ASC, cm.user_id ASC
), fallback_rows AS (
  SELECT DISTINCT ON (cm.conversation_id)
    cm.conversation_id,
    cm.user_id
  FROM public.conversation_members cm
  ORDER BY cm.conversation_id, cm.joined_at ASC, cm.created_at ASC, cm.user_id ASC
), chosen_rows AS (
  SELECT conversation_id, user_id FROM owner_rows
  UNION ALL
  SELECT f.conversation_id, f.user_id
  FROM fallback_rows f
  WHERE NOT EXISTS (
    SELECT 1 FROM owner_rows o WHERE o.conversation_id = f.conversation_id
  )
)
UPDATE public.conversations c
SET created_by = chosen_rows.user_id
FROM chosen_rows
WHERE c.id = chosen_rows.conversation_id
  AND c.created_by IS NULL;

-- Revert content_categories to the previous state if this migration enabled it.
ALTER TABLE IF EXISTS public.content_categories DISABLE ROW LEVEL SECURITY;

-- Remove policies introduced by the failed migration.
DROP POLICY IF EXISTS conversations_select_member ON public.conversations;
DROP POLICY IF EXISTS conversations_insert_authenticated ON public.conversations;
DROP POLICY IF EXISTS conversations_update_member ON public.conversations;

DROP POLICY IF EXISTS cm_select_member_visibility ON public.conversation_members;
DROP POLICY IF EXISTS cm_insert_self_seed_or_invite ON public.conversation_members;
DROP POLICY IF EXISTS cm_insert_admin_or_dm_bootstrap ON public.conversation_members;
DROP POLICY IF EXISTS cm_update_self_or_admin ON public.conversation_members;
DROP POLICY IF EXISTS cm_delete_self_or_admin ON public.conversation_members;

DROP POLICY IF EXISTS content_categories_public_read ON public.content_categories;
DROP POLICY IF EXISTS content_categories_service_manage ON public.content_categories;

-- Remove helper functions introduced for RLS recursion avoidance.
DROP FUNCTION IF EXISTS public.is_conversation_member(UUID, UUID);
DROP FUNCTION IF EXISTS public.is_conversation_admin(UUID, UUID);
DROP FUNCTION IF EXISTS public.conversation_member_count(UUID);

COMMENT ON TABLE public.conversation_members IS
  'Rollback applied: RLS disabled to restore chat functionality.';
