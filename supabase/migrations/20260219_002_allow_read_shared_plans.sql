-- Allow users to read saved_travel_plans that were shared with them via chat.
-- A plan is "shared" when it appears in a chat_message with type='travelPlan'
-- and the current user is a member of that conversation.
CREATE POLICY "Users can view plans shared with them"
    ON public.saved_travel_plans FOR SELECT
    USING (
        auth.uid() = user_id
        OR EXISTS (
            SELECT 1
            FROM chat_messages cm
            JOIN conversation_members cmem ON cmem.conversation_id = cm.conversation_id
            WHERE cm.shared_content_id = saved_travel_plans.id
            AND cm.type = 'travelPlan'
            AND cmem.user_id = auth.uid()
        )
    );
