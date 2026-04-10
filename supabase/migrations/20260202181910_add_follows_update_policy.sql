CREATE POLICY "Users can update their follows" ON public.follows FOR UPDATE USING (auth.uid() = follower_id) WITH CHECK (auth.uid() = follower_id);;
