-- Migration: Group invite links with in-app preview and direct join flow
-- - Adds public.group_invite_links for owner/admin managed invite links
-- - Adds RPC for link preview (for non-members)
-- - Adds RPC for direct join via invite code

CREATE TABLE IF NOT EXISTS public.group_invite_links (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
    invite_code TEXT NOT NULL UNIQUE,
    created_by UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    expires_at TIMESTAMPTZ NOT NULL DEFAULT (NOW() + INTERVAL '30 days'),
    revoked_at TIMESTAMPTZ
);

-- Single active link per group. Regenerating should revoke/replace the previous one.
CREATE UNIQUE INDEX IF NOT EXISTS idx_group_invite_links_single_active
    ON public.group_invite_links(conversation_id)
    WHERE revoked_at IS NULL;

CREATE INDEX IF NOT EXISTS idx_group_invite_links_code_active
    ON public.group_invite_links(invite_code)
    WHERE revoked_at IS NULL;

ALTER TABLE public.group_invite_links ENABLE ROW LEVEL SECURITY;

-- Owners/admins of a group can view/manage its links.
DROP POLICY IF EXISTS "Group owners/admins can view invite links" ON public.group_invite_links;
CREATE POLICY "Group owners/admins can view invite links"
    ON public.group_invite_links FOR SELECT
    USING (
      EXISTS (
        SELECT 1
        FROM public.conversation_members cm
        WHERE cm.conversation_id = group_invite_links.conversation_id
          AND cm.user_id = auth.uid()
          AND cm.role IN ('owner', 'admin')
      )
    );

DROP POLICY IF EXISTS "Group owners/admins can insert invite links" ON public.group_invite_links;
CREATE POLICY "Group owners/admins can insert invite links"
    ON public.group_invite_links FOR INSERT
    WITH CHECK (
      auth.uid() = created_by
      AND EXISTS (
        SELECT 1
        FROM public.conversation_members cm
        WHERE cm.conversation_id = group_invite_links.conversation_id
          AND cm.user_id = auth.uid()
          AND cm.role IN ('owner', 'admin')
      )
    );

DROP POLICY IF EXISTS "Group owners/admins can update invite links" ON public.group_invite_links;
CREATE POLICY "Group owners/admins can update invite links"
    ON public.group_invite_links FOR UPDATE
    USING (
      EXISTS (
        SELECT 1
        FROM public.conversation_members cm
        WHERE cm.conversation_id = group_invite_links.conversation_id
          AND cm.user_id = auth.uid()
          AND cm.role IN ('owner', 'admin')
      )
    )
    WITH CHECK (
      EXISTS (
        SELECT 1
        FROM public.conversation_members cm
        WHERE cm.conversation_id = group_invite_links.conversation_id
          AND cm.user_id = auth.uid()
          AND cm.role IN ('owner', 'admin')
      )
    );

DROP POLICY IF EXISTS "Group owners/admins can delete invite links" ON public.group_invite_links;
CREATE POLICY "Group owners/admins can delete invite links"
    ON public.group_invite_links FOR DELETE
    USING (
      EXISTS (
        SELECT 1
        FROM public.conversation_members cm
        WHERE cm.conversation_id = group_invite_links.conversation_id
          AND cm.user_id = auth.uid()
          AND cm.role IN ('owner', 'admin')
      )
    );

-- Returns preview data for in-app invite screen.
CREATE OR REPLACE FUNCTION public.get_group_invite_link_preview(p_invite_code TEXT)
RETURNS TABLE (
  conversation_id UUID,
  group_name TEXT,
  group_avatar_url TEXT,
  group_description TEXT,
  member_count BIGINT,
  admin_name TEXT,
  expires_at TIMESTAMPTZ,
  is_member BOOLEAN
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_uid UUID;
BEGIN
  v_uid := auth.uid();
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'AUTH_REQUIRED';
  END IF;

  RETURN QUERY
  SELECT
    c.id,
    COALESCE(c.group_name, 'Group') AS group_name,
    c.group_avatar_url,
    c.group_description,
    (
      SELECT COUNT(*)::BIGINT
      FROM public.conversation_members cmc
      WHERE cmc.conversation_id = c.id
    ) AS member_count,
    COALESCE(
      (
        SELECT COALESCE(p.full_name, p.username, 'Group admin')
        FROM public.conversation_members cma
        LEFT JOIN public.profiles p ON p.id = cma.user_id
        WHERE cma.conversation_id = c.id
          AND cma.role IN ('owner', 'admin')
        ORDER BY CASE WHEN cma.role = 'owner' THEN 0 ELSE 1 END, cma.joined_at ASC
        LIMIT 1
      ),
      'Group admin'
    ) AS admin_name,
    gil.expires_at,
    EXISTS (
      SELECT 1
      FROM public.conversation_members cm
      WHERE cm.conversation_id = c.id
        AND cm.user_id = v_uid
    ) AS is_member
  FROM public.group_invite_links gil
  JOIN public.conversations c ON c.id = gil.conversation_id
  WHERE gil.invite_code = p_invite_code
    AND gil.revoked_at IS NULL
    AND gil.expires_at > NOW()
    AND c.is_group = TRUE
  LIMIT 1;
END;
$$;

-- Joins current user to the group directly via a valid invite code.
-- Returns one of: joined | already_member | invalid_or_expired | blocked
CREATE OR REPLACE FUNCTION public.join_group_via_invite_link(p_invite_code TEXT)
RETURNS TEXT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_uid UUID;
  v_conversation_id UUID;
  v_created_by UUID;
BEGIN
  v_uid := auth.uid();
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'AUTH_REQUIRED';
  END IF;

  SELECT gil.conversation_id, gil.created_by
  INTO v_conversation_id, v_created_by
  FROM public.group_invite_links gil
  JOIN public.conversations c ON c.id = gil.conversation_id
  WHERE gil.invite_code = p_invite_code
    AND gil.revoked_at IS NULL
    AND gil.expires_at > NOW()
    AND c.is_group = TRUE
  LIMIT 1;

  IF v_conversation_id IS NULL THEN
    RETURN 'invalid_or_expired';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM public.user_blocks ub
    WHERE (ub.blocker_id = v_uid AND ub.blocked_id = v_created_by)
       OR (ub.blocker_id = v_created_by AND ub.blocked_id = v_uid)
  ) THEN
    RETURN 'blocked';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM public.conversation_members cm
    WHERE cm.conversation_id = v_conversation_id
      AND cm.user_id = v_uid
  ) THEN
    RETURN 'already_member';
  END IF;

  INSERT INTO public.conversation_members (
    conversation_id,
    user_id,
    role,
    joined_at,
    last_read_at
  )
  VALUES (
    v_conversation_id,
    v_uid,
    'member',
    NOW(),
    NOW()
  )
  ON CONFLICT (conversation_id, user_id) DO NOTHING;

  IF EXISTS (
    SELECT 1
    FROM public.conversation_members cm
    WHERE cm.conversation_id = v_conversation_id
      AND cm.user_id = v_uid
  ) THEN
    RETURN 'joined';
  END IF;

  RETURN 'invalid_or_expired';
END;
$$;

REVOKE ALL ON FUNCTION public.get_group_invite_link_preview(TEXT) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.join_group_via_invite_link(TEXT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_group_invite_link_preview(TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.join_group_via_invite_link(TEXT) TO authenticated;

COMMENT ON TABLE public.group_invite_links IS 'Owner/admin managed invite links used to join groups via code';
COMMENT ON FUNCTION public.get_group_invite_link_preview(TEXT) IS 'Returns invite preview data for a valid, non-revoked group invite link';
COMMENT ON FUNCTION public.join_group_via_invite_link(TEXT) IS 'Adds current user to group via valid invite code and returns join status';
