-- Create shares table for tracking content sharing
CREATE TABLE shares (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    
    -- What was shared
    shareable_type TEXT NOT NULL CHECK (shareable_type IN ('post', 'story')),
    shareable_id UUID NOT NULL,
    
    -- How it was shared
    share_type share_type NOT NULL,
    
    -- Optional: recipient for DM shares
    recipient_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
    
    -- Repost-specific fields (creates a new post)
    repost_id UUID REFERENCES posts(id) ON DELETE SET NULL,
    
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Indexes for performance
CREATE INDEX idx_shares_user ON shares(user_id);
CREATE INDEX idx_shares_target ON shares(shareable_type, shareable_id);
CREATE INDEX idx_shares_recipient ON shares(recipient_id) WHERE recipient_id IS NOT NULL;;
