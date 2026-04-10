-- Migration: Message requests and group invite requests for consent-based chat
-- message_requests: DM must be accepted by recipient before conversation is created
-- group_invite_requests: User must accept before being added to conversation_members

-- message_requests: one row per pending request from sender to recipient
CREATE TABLE IF NOT EXISTS public.message_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sender_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    recipient_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Only one pending message request per (sender, recipient)
CREATE UNIQUE INDEX IF NOT EXISTS idx_message_requests_pending_unique
    ON public.message_requests(sender_id, recipient_id)
    WHERE status = 'pending';

CREATE INDEX IF NOT EXISTS idx_message_requests_recipient_status
    ON public.message_requests(recipient_id, status);

CREATE INDEX IF NOT EXISTS idx_message_requests_sender_status
    ON public.message_requests(sender_id, status);

ALTER TABLE public.message_requests ENABLE ROW LEVEL SECURITY;

-- Recipient can SELECT and UPDATE (accept/reject) their incoming requests
DROP POLICY IF EXISTS "Recipients can view own message requests" ON public.message_requests;
CREATE POLICY "Recipients can view own message requests"
    ON public.message_requests FOR SELECT
    USING (auth.uid() = recipient_id OR auth.uid() = sender_id);

DROP POLICY IF EXISTS "Recipients can update own message requests" ON public.message_requests;
CREATE POLICY "Recipients can update own message requests"
    ON public.message_requests FOR UPDATE
    USING (auth.uid() = recipient_id);

-- Sender can INSERT (as themselves) and SELECT their sent requests
DROP POLICY IF EXISTS "Senders can insert message requests" ON public.message_requests;
CREATE POLICY "Senders can insert message requests"
    ON public.message_requests FOR INSERT
    WITH CHECK (auth.uid() = sender_id);

-- group_invite_requests: one row per pending group invite
CREATE TABLE IF NOT EXISTS public.group_invite_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
    inviter_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    invitee_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Only one pending group invite per (conversation, invitee)
CREATE UNIQUE INDEX IF NOT EXISTS idx_group_invite_requests_pending_unique
    ON public.group_invite_requests(conversation_id, invitee_id)
    WHERE status = 'pending';

CREATE INDEX IF NOT EXISTS idx_group_invite_requests_invitee_status
    ON public.group_invite_requests(invitee_id, status);

ALTER TABLE public.group_invite_requests ENABLE ROW LEVEL SECURITY;

-- Invitee can SELECT and UPDATE their incoming group invites
DROP POLICY IF EXISTS "Invitees can view own group invite requests" ON public.group_invite_requests;
CREATE POLICY "Invitees can view own group invite requests"
    ON public.group_invite_requests FOR SELECT
    USING (auth.uid() = invitee_id OR auth.uid() = inviter_id);

DROP POLICY IF EXISTS "Invitees can update own group invite requests" ON public.group_invite_requests;
CREATE POLICY "Invitees can update own group invite requests"
    ON public.group_invite_requests FOR UPDATE
    USING (auth.uid() = invitee_id);

-- Inviter can INSERT (as themselves)
DROP POLICY IF EXISTS "Inviters can insert group invite requests" ON public.group_invite_requests;
CREATE POLICY "Inviters can insert group invite requests"
    ON public.group_invite_requests FOR INSERT
    WITH CHECK (auth.uid() = inviter_id);

COMMENT ON TABLE public.message_requests IS 'Pending/accepted/rejected DM requests; DM created only on accept';
COMMENT ON TABLE public.group_invite_requests IS 'Pending/accepted/rejected group invites; member added only on accept';
