-- Migration: Update RLS policies for message_requests and group_invite_requests
-- - Allow senders to revoke their own message requests
-- - Allow inviters and group owners/admins to manage group invite requests

-- ─────────────────────────────────────────────────────────────────────────────
-- message_requests RLS updates
-- ─────────────────────────────────────────────────────────────────────────────

-- Existing policies (from 20260218_001_message_and_group_requests.sql):
--  - "Recipients can view own message requests" (SELECT)
--  - "Recipients can update own message requests" (UPDATE)
--  - "Senders can insert message requests" (INSERT)

-- Allow senders to UPDATE their own requests (e.g., mark as revoked).
DROP POLICY IF EXISTS "Senders can update own message requests" ON public.message_requests;
CREATE POLICY "Senders can update own message requests"
    ON public.message_requests FOR UPDATE
    USING (auth.uid() = sender_id)
    WITH CHECK (auth.uid() = sender_id);


-- ─────────────────────────────────────────────────────────────────────────────
-- group_invite_requests RLS updates
-- ─────────────────────────────────────────────────────────────────────────────

-- Existing policies (from 20260218_001_message_and_group_requests.sql):
--  - "Invitees can view own group invite requests" (SELECT)
--  - "Invitees can update own group invite requests" (UPDATE)
--  - "Inviters can insert group invite requests" (INSERT)

-- Allow inviters to UPDATE their own group invites (e.g., mark as revoked).
DROP POLICY IF EXISTS "Inviters can update own group invite requests" ON public.group_invite_requests;
CREATE POLICY "Inviters can update own group invite requests"
    ON public.group_invite_requests FOR UPDATE
    USING (auth.uid() = inviter_id)
    WITH CHECK (auth.uid() = inviter_id);

-- Allow group owners/admins to SELECT all invites for their conversation.
DROP POLICY IF EXISTS "Group owners and admins can view group invite requests" ON public.group_invite_requests;
CREATE POLICY "Group owners and admins can view group invite requests"
    ON public.group_invite_requests FOR SELECT
    USING (
      EXISTS (
        SELECT 1
        FROM public.conversation_members cm
        WHERE cm.conversation_id = group_invite_requests.conversation_id
          AND cm.user_id = auth.uid()
          AND cm.role IN ('owner', 'admin')
      )
    );

-- Optionally, allow group owners/admins to UPDATE group invites (e.g., revoke on behalf of inviter).
DROP POLICY IF EXISTS "Group owners and admins can update group invite requests" ON public.group_invite_requests;
CREATE POLICY "Group owners and admins can update group invite requests"
    ON public.group_invite_requests FOR UPDATE
    USING (
      EXISTS (
        SELECT 1
        FROM public.conversation_members cm
        WHERE cm.conversation_id = group_invite_requests.conversation_id
          AND cm.user_id = auth.uid()
          AND cm.role IN ('owner', 'admin')
      )
    );

