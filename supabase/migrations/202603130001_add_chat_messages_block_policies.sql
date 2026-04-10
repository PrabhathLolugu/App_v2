-- Enforce that users cannot see chat messages in 1:1 DMs
-- when a block exists between the viewer and the other participant.
--
-- This policy only affects SELECT access; inserts/updates/deletes are
-- still governed by existing policies on chat_messages and
-- conversation_members.

create policy "dm_messages_hidden_when_blocked"
on public.chat_messages
for select
using (
  -- Ensure the viewer is the message sender or a member of the
  -- conversation via conversation_members (existing membership checks
  -- should already enforce this; we add them here defensively).
  exists (
    select 1
    from public.conversation_members cm
    join public.conversations c
      on c.id = cm.conversation_id
    where cm.conversation_id = chat_messages.conversation_id
      and cm.user_id = auth.uid()
      and c.is_group = false
  )
  and not exists (
    -- If the viewer is in a 1:1 DM where either side has blocked
    -- the other, deny visibility of all messages.
    select 1
    from public.conversations c2
    join public.conversation_members cm_self
      on cm_self.conversation_id = c2.id
    join public.conversation_members cm_other
      on cm_other.conversation_id = c2.id
    join public.user_blocks ub
      on (
        (ub.blocker_id = cm_self.user_id and ub.blocked_id = cm_other.user_id)
        or
        (ub.blocker_id = cm_other.user_id and ub.blocked_id = cm_self.user_id)
      )
    where c2.id = chat_messages.conversation_id
      and c2.is_group = false
      and cm_self.user_id = auth.uid()
      and cm_other.user_id <> auth.uid()
  )
);

