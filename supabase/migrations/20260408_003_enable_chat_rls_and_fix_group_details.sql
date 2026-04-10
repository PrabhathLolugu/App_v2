-- Migration: Enable chat RLS and fix group details schema drift
-- Date: 2026-04-08
--
-- Purpose:
-- 1) Resolve Supabase advisories by enabling RLS on public chat tables.
-- 2) Keep existing chat/group functionality working.
-- 3) Restore/maintain group details data expected by the app.

-- ---------------------------------------------------------------------------
-- Group details support
-- ---------------------------------------------------------------------------

ALTER TABLE IF EXISTS public.conversations
  ADD COLUMN IF NOT EXISTS created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL;

ALTER TABLE IF EXISTS public.conversations
  ADD COLUMN IF NOT EXISTS group_description TEXT;

CREATE OR REPLACE FUNCTION public.set_conversation_created_by()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NEW.created_by IS NULL THEN
    NEW.created_by := auth.uid();
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_set_conversation_created_by ON public.conversations;
CREATE TRIGGER trg_set_conversation_created_by
  BEFORE INSERT ON public.conversations
  FOR EACH ROW
  EXECUTE FUNCTION public.set_conversation_created_by();

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

-- ---------------------------------------------------------------------------
-- RLS helper functions
-- ---------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.is_conversation_member(
  p_conversation_id UUID,
  p_user_id UUID
)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.conversation_members cm
    WHERE cm.conversation_id = p_conversation_id
      AND cm.user_id = p_user_id
  );
$$;

CREATE OR REPLACE FUNCTION public.is_conversation_admin(
  p_conversation_id UUID,
  p_user_id UUID
)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.conversation_members cm
    WHERE cm.conversation_id = p_conversation_id
      AND cm.user_id = p_user_id
      AND lower(coalesce(cm.role, 'member')) IN ('owner', 'admin')
  );
$$;

CREATE OR REPLACE FUNCTION public.conversation_member_count(
  p_conversation_id UUID
)
RETURNS INTEGER
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT count(*)::integer
  FROM public.conversation_members cm
  WHERE cm.conversation_id = p_conversation_id;
$$;

-- ---------------------------------------------------------------------------
-- conversations RLS
-- ---------------------------------------------------------------------------

DO $$
BEGIN
  IF to_regclass('public.conversations') IS NULL THEN
    RAISE NOTICE 'Skipping conversations RLS: table public.conversations not found';
    RETURN;
  END IF;

  ALTER TABLE public.conversations ENABLE ROW LEVEL SECURITY;

  DROP POLICY IF EXISTS "Users can view their conversations" ON public.conversations;
  DROP POLICY IF EXISTS "Admins can update group conversations" ON public.conversations;
  DROP POLICY IF EXISTS users_can_create_conversations ON public.conversations;
  DROP POLICY IF EXISTS conversations_select_member ON public.conversations;
  DROP POLICY IF EXISTS conversations_insert_authenticated ON public.conversations;
  DROP POLICY IF EXISTS conversations_update_member ON public.conversations;

  CREATE POLICY conversations_select_member
    ON public.conversations
    FOR SELECT
    TO authenticated
    USING (public.is_conversation_member(id, auth.uid()));

  CREATE POLICY conversations_insert_authenticated
    ON public.conversations
    FOR INSERT
    TO authenticated
    WITH CHECK (auth.role() = 'authenticated');

  CREATE POLICY conversations_update_member
    ON public.conversations
    FOR UPDATE
    TO authenticated
    USING (public.is_conversation_member(id, auth.uid()))
    WITH CHECK (public.is_conversation_member(id, auth.uid()));
END
$$;

-- ---------------------------------------------------------------------------
-- conversation_members RLS
-- ---------------------------------------------------------------------------

DO $$
BEGIN
  IF to_regclass('public.conversation_members') IS NULL THEN
    RAISE NOTICE 'Skipping conversation_members RLS: table public.conversation_members not found';
    RETURN;
  END IF;

  ALTER TABLE public.conversation_members ENABLE ROW LEVEL SECURITY;

  DROP POLICY IF EXISTS "Admins can add members to group" ON public.conversation_members;
  DROP POLICY IF EXISTS "Admins can remove members" ON public.conversation_members;
  DROP POLICY IF EXISTS "Admins can update member roles" ON public.conversation_members;
  DROP POLICY IF EXISTS "Users can leave group" ON public.conversation_members;
  DROP POLICY IF EXISTS cm_insert_self ON public.conversation_members;
  DROP POLICY IF EXISTS cm_select_via_conversations ON public.conversation_members;
  DROP POLICY IF EXISTS cm_select_member_visibility ON public.conversation_members;
  DROP POLICY IF EXISTS cm_insert_self_seed_or_invite ON public.conversation_members;
  DROP POLICY IF EXISTS cm_insert_admin_or_dm_bootstrap ON public.conversation_members;
  DROP POLICY IF EXISTS cm_update_self_or_admin ON public.conversation_members;
  DROP POLICY IF EXISTS cm_delete_self_or_admin ON public.conversation_members;

  CREATE POLICY cm_select_member_visibility
    ON public.conversation_members
    FOR SELECT
    TO authenticated
    USING (public.is_conversation_member(conversation_id, auth.uid()));

  CREATE POLICY cm_insert_self_seed_or_invite
    ON public.conversation_members
    FOR INSERT
    TO authenticated
    WITH CHECK (
      user_id = auth.uid()
      AND (
        public.conversation_member_count(conversation_id) = 0
        OR EXISTS (
          SELECT 1
          FROM public.group_invite_requests gir
          WHERE gir.conversation_id = conversation_members.conversation_id
            AND gir.invitee_id = auth.uid()
            AND gir.status IN ('pending', 'accepted')
        )
      )
    );

  CREATE POLICY cm_insert_admin_or_dm_bootstrap
    ON public.conversation_members
    FOR INSERT
    TO authenticated
    WITH CHECK (
      user_id <> auth.uid()
      AND (
        public.is_conversation_admin(conversation_id, auth.uid())
        OR (
          EXISTS (
            SELECT 1
            FROM public.conversations c
            WHERE c.id = conversation_members.conversation_id
              AND coalesce(c.is_group, false) = false
          )
          AND public.is_conversation_member(conversation_id, auth.uid())
          AND public.conversation_member_count(conversation_id) < 2
        )
      )
    );

  CREATE POLICY cm_update_self_or_admin
    ON public.conversation_members
    FOR UPDATE
    TO authenticated
    USING (
      user_id = auth.uid()
      OR public.is_conversation_admin(conversation_id, auth.uid())
    )
    WITH CHECK (
      user_id = auth.uid()
      OR public.is_conversation_admin(conversation_id, auth.uid())
    );

  CREATE POLICY cm_delete_self_or_admin
    ON public.conversation_members
    FOR DELETE
    TO authenticated
    USING (
      user_id = auth.uid()
      OR public.is_conversation_admin(conversation_id, auth.uid())
    );
END
$$;

-- ---------------------------------------------------------------------------
-- content_categories RLS
-- ---------------------------------------------------------------------------

DO $$
BEGIN
  IF to_regclass('public.content_categories') IS NULL THEN
    RAISE NOTICE 'Skipping content_categories RLS: table public.content_categories not found';
    RETURN;
  END IF;

  ALTER TABLE public.content_categories ENABLE ROW LEVEL SECURITY;

  DROP POLICY IF EXISTS content_categories_public_read ON public.content_categories;
  DROP POLICY IF EXISTS content_categories_service_manage ON public.content_categories;

  CREATE POLICY content_categories_public_read
    ON public.content_categories
    FOR SELECT
    TO anon, authenticated, service_role
    USING (true);

  CREATE POLICY content_categories_service_manage
    ON public.content_categories
    FOR ALL
    TO service_role
    USING (true)
    WITH CHECK (true);
END
$$;

COMMENT ON FUNCTION public.set_conversation_created_by() IS
  'Backfills conversations.created_by from the request user when inserting new conversations.';
COMMENT ON FUNCTION public.is_conversation_member(UUID, UUID) IS
  'RLS helper: checks whether a user is a member of a conversation.';
COMMENT ON FUNCTION public.is_conversation_admin(UUID, UUID) IS
  'RLS helper: checks whether a user is owner/admin in a conversation.';
COMMENT ON FUNCTION public.conversation_member_count(UUID) IS
  'RLS helper: current member row count for a conversation.';
