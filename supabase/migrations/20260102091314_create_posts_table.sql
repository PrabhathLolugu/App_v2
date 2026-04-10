-- Create posts table for all post types
CREATE TABLE posts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    author_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    post_type post_type NOT NULL,
    
    -- Core content
    title TEXT,
    content TEXT,
    
    -- Media (for image/video posts)
    media_urls TEXT[] DEFAULT '{}',
    thumbnail_url TEXT,
    video_duration_seconds INTEGER,
    
    -- Story share (for resharing stories)
    shared_story_id UUID REFERENCES stories(id) ON DELETE SET NULL,
    
    -- Metadata
    metadata JSONB DEFAULT '{}',
    
    -- Privacy & moderation
    visibility TEXT DEFAULT 'public' CHECK (visibility IN ('public', 'followers', 'private')),
    is_comments_disabled BOOLEAN DEFAULT false,
    is_hidden BOOLEAN DEFAULT false,
    
    -- Counters (denormalized for performance)
    like_count INTEGER DEFAULT 0,
    comment_count INTEGER DEFAULT 0,
    share_count INTEGER DEFAULT 0,
    bookmark_count INTEGER DEFAULT 0,
    view_count INTEGER DEFAULT 0,
    
    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Indexes for performance
CREATE INDEX idx_posts_author_id ON posts(author_id);
CREATE INDEX idx_posts_created_at ON posts(created_at DESC);
CREATE INDEX idx_posts_type ON posts(post_type);
CREATE INDEX idx_posts_visibility ON posts(visibility);
CREATE INDEX idx_posts_author_created ON posts(author_id, created_at DESC);;
