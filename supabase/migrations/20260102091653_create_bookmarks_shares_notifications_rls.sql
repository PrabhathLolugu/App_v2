-- Enable RLS on bookmarks
ALTER TABLE bookmarks ENABLE ROW LEVEL SECURITY;

-- Users can view their own bookmarks only
CREATE POLICY "Users can view own bookmarks"
ON bookmarks FOR SELECT
USING (user_id = auth.uid());

-- Users can create their own bookmarks
CREATE POLICY "Users can create bookmarks"
ON bookmarks FOR INSERT
WITH CHECK (user_id = auth.uid());

-- Users can delete their own bookmarks
CREATE POLICY "Users can delete own bookmarks"
ON bookmarks FOR DELETE
USING (user_id = auth.uid());

-- Enable RLS on shares
ALTER TABLE shares ENABLE ROW LEVEL SECURITY;

-- Anyone can view shares (for analytics)
CREATE POLICY "Shares are viewable by everyone"
ON shares FOR SELECT
USING (true);

-- Users can create shares
CREATE POLICY "Users can create shares"
ON shares FOR INSERT
WITH CHECK (user_id = auth.uid());

-- Enable RLS on notifications
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Users can only view their own notifications
CREATE POLICY "Users can view own notifications"
ON notifications FOR SELECT
USING (recipient_id = auth.uid());

-- Users can update (mark as read) their own notifications
CREATE POLICY "Users can update own notifications"
ON notifications FOR UPDATE
USING (recipient_id = auth.uid())
WITH CHECK (recipient_id = auth.uid());

-- Users can delete their own notifications
CREATE POLICY "Users can delete own notifications"
ON notifications FOR DELETE
USING (recipient_id = auth.uid());;
