-- Create bookmarks table
CREATE TABLE bookmarks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    
    -- Polymorphic reference
    bookmarkable_type TEXT NOT NULL CHECK (bookmarkable_type IN ('post', 'story')),
    bookmarkable_id UUID NOT NULL,
    
    -- Optional organization
    collection_name TEXT,
    
    created_at TIMESTAMPTZ DEFAULT now(),
    
    UNIQUE(user_id, bookmarkable_type, bookmarkable_id)
);

-- Indexes for performance
CREATE INDEX idx_bookmarks_user ON bookmarks(user_id);
CREATE INDEX idx_bookmarks_user_created ON bookmarks(user_id, created_at DESC);
CREATE INDEX idx_bookmarks_target ON bookmarks(bookmarkable_type, bookmarkable_id);;
