-- Enable RLS on likes
ALTER TABLE likes ENABLE ROW LEVEL SECURITY;

-- Anyone can view likes
CREATE POLICY "Likes are viewable by everyone"
ON likes FOR SELECT
USING (true);

-- Users can create their own likes
CREATE POLICY "Users can create own likes"
ON likes FOR INSERT
WITH CHECK (user_id = auth.uid());

-- Users can delete their own likes (unlike)
CREATE POLICY "Users can delete own likes"
ON likes FOR DELETE
USING (user_id = auth.uid());;
