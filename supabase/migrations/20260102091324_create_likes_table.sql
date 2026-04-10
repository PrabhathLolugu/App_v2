-- Create polymorphic likes table
CREATE TABLE likes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    
    -- Polymorphic reference
    likeable_type likeable_type NOT NULL,
    likeable_id UUID NOT NULL,
    
    created_at TIMESTAMPTZ DEFAULT now(),
    
    UNIQUE(user_id, likeable_type, likeable_id)
);

-- Indexes for performance
CREATE INDEX idx_likes_user ON likes(user_id);
CREATE INDEX idx_likes_target ON likes(likeable_type, likeable_id);
CREATE INDEX idx_likes_created ON likes(created_at DESC);;
