-- Migration: Allow senders to delete their own message requests
-- This enables the "Delete from list" action in the Chat Itihas
-- > Requests tab to permanently remove outgoing (expired/revoked)
-- message requests for the sender.

-- RLS policy: senders can DELETE their own message_requests rows.
DROP POLICY IF EXISTS "Senders can delete own message requests" ON public.message_requests;
CREATE POLICY "Senders can delete own message requests"
  ON public.message_requests
  FOR DELETE
  USING (auth.uid() = sender_id);

