-- Ensure scheduled/draft/cancelled posts are not visible to others.
-- Authors still see all their own posts via "Users can view own posts".

DROP POLICY IF EXISTS "Public posts are viewable by everyone" ON posts;
CREATE POLICY "Public posts are viewable by everyone"
ON posts FOR SELECT
USING (visibility = 'public' AND is_hidden = false AND status = 'published');

DROP POLICY IF EXISTS "Followers can view follower-only posts" ON posts;
CREATE POLICY "Followers can view follower-only posts"
ON posts FOR SELECT
USING (
    visibility = 'followers' AND is_hidden = false AND status = 'published' AND (
        author_id = auth.uid() OR
        EXISTS (
            SELECT 1 FROM follows
            WHERE follower_id = auth.uid() AND following_id = posts.author_id
        )
    )
);
