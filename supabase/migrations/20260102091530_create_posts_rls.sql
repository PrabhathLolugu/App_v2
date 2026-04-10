-- Enable RLS on posts
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;

-- Anyone can read public posts
CREATE POLICY "Public posts are viewable by everyone"
ON posts FOR SELECT
USING (visibility = 'public' AND is_hidden = false);

-- Followers can see follower-only posts
CREATE POLICY "Followers can view follower-only posts"
ON posts FOR SELECT
USING (
    visibility = 'followers' AND is_hidden = false AND (
        author_id = auth.uid() OR
        EXISTS (
            SELECT 1 FROM follows 
            WHERE follower_id = auth.uid() AND following_id = posts.author_id
        )
    )
);

-- Authors can see their own posts (including private/hidden)
CREATE POLICY "Users can view own posts"
ON posts FOR SELECT
USING (author_id = auth.uid());

-- Users can create their own posts
CREATE POLICY "Users can create own posts"
ON posts FOR INSERT
WITH CHECK (author_id = auth.uid());

-- Users can update their own posts
CREATE POLICY "Users can update own posts"
ON posts FOR UPDATE
USING (author_id = auth.uid())
WITH CHECK (author_id = auth.uid());

-- Users can delete their own posts
CREATE POLICY "Users can delete own posts"
ON posts FOR DELETE
USING (author_id = auth.uid());;
