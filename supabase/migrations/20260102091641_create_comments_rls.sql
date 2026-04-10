-- Enable RLS on comments
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;

-- Anyone can view non-hidden comments
CREATE POLICY "Comments are viewable by everyone"
ON comments FOR SELECT
USING (is_hidden = false);

-- Authors can see their own hidden comments
CREATE POLICY "Authors can view own hidden comments"
ON comments FOR SELECT
USING (author_id = auth.uid());

-- Authenticated users can create comments
CREATE POLICY "Authenticated users can comment"
ON comments FOR INSERT
WITH CHECK (author_id = auth.uid());

-- Users can update their own comments
CREATE POLICY "Users can update own comments"
ON comments FOR UPDATE
USING (author_id = auth.uid())
WITH CHECK (author_id = auth.uid());

-- Users can delete their own comments
CREATE POLICY "Users can delete own comments"
ON comments FOR DELETE
USING (author_id = auth.uid());;
