-- Migration: Create missing forum/discussion tables
-- Date: 2026-03-18  
-- Description: Creates tables for discussions, comments, and likes that were previously missing from version control

-- discussions table - Discussion forum posts for specific sites
CREATE TABLE IF NOT EXISTS public.discussions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    author_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    site_id UUID,
    site_name TEXT, -- Store site name for quick display
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    preview TEXT, -- First 200 chars of content for listing view
    category TEXT DEFAULT 'general', -- 'general' or 'location'
    is_pinned BOOLEAN DEFAULT false,
    comment_count INT DEFAULT 0,
    like_count INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now())
);

-- Add missing columns if discussions table already exists
ALTER TABLE IF EXISTS public.discussions
ADD COLUMN IF NOT EXISTS author_id UUID;

ALTER TABLE IF EXISTS public.discussions
ADD COLUMN IF NOT EXISTS site_id UUID;

ALTER TABLE IF EXISTS public.discussions
ADD COLUMN IF NOT EXISTS site_name TEXT;

ALTER TABLE IF EXISTS public.discussions
ADD COLUMN IF NOT EXISTS title TEXT;

ALTER TABLE IF EXISTS public.discussions
ADD COLUMN IF NOT EXISTS content TEXT;

ALTER TABLE IF EXISTS public.discussions
ADD COLUMN IF NOT EXISTS preview TEXT;

ALTER TABLE IF EXISTS public.discussions
ADD COLUMN IF NOT EXISTS category TEXT DEFAULT 'general';

ALTER TABLE IF EXISTS public.discussions
ADD COLUMN IF NOT EXISTS is_pinned BOOLEAN DEFAULT false;

ALTER TABLE IF EXISTS public.discussions
ADD COLUMN IF NOT EXISTS comment_count INT DEFAULT 0;

ALTER TABLE IF EXISTS public.discussions
ADD COLUMN IF NOT EXISTS like_count INT DEFAULT 0;

-- ✅ ADD SEARCH OPTIMIZATION COLUMNS
ALTER TABLE IF EXISTS public.discussions
ADD COLUMN IF NOT EXISTS search_vector tsvector GENERATED ALWAYS AS (
  to_tsvector('english', COALESCE(title, '') || ' ' || COALESCE(content, ''))
) STORED;

-- Index for discussions
CREATE INDEX IF NOT EXISTS idx_discussions_author_id ON public.discussions(author_id);
CREATE INDEX IF NOT EXISTS idx_discussions_site_id ON public.discussions(site_id);
CREATE INDEX IF NOT EXISTS idx_discussions_created_at ON public.discussions(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_discussions_site_created ON public.discussions(site_id, created_at DESC);

-- ✅ SEARCH INDEXES for better performance
CREATE INDEX IF NOT EXISTS idx_discussions_title_gin ON public.discussions USING gin(to_tsvector('english', title));
CREATE INDEX IF NOT EXISTS idx_discussions_content_gin ON public.discussions USING gin(to_tsvector('english', content));
CREATE INDEX IF NOT EXISTS idx_discussions_search_vector_gin ON public.discussions USING gin(search_vector);

-- ✅ BTREE indexes for prefix/substring searches (LIKE queries)
CREATE INDEX IF NOT EXISTS idx_discussions_title_lower ON public.discussions(LOWER(title));
CREATE INDEX IF NOT EXISTS idx_discussions_content_lower ON public.discussions(LOWER(content));


-- discussion_comments table - Comments on discussions
CREATE TABLE IF NOT EXISTS public.discussion_comments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    discussion_id UUID NOT NULL REFERENCES public.discussions(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    like_count INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now())
);

-- Add missing columns if discussion_comments table already exists
ALTER TABLE IF EXISTS public.discussion_comments
ADD COLUMN IF NOT EXISTS user_id UUID;

ALTER TABLE IF EXISTS public.discussion_comments
ADD COLUMN IF NOT EXISTS discussion_id UUID;

ALTER TABLE IF EXISTS public.discussion_comments
ADD COLUMN IF NOT EXISTS content TEXT;

ALTER TABLE IF EXISTS public.discussion_comments
ADD COLUMN IF NOT EXISTS like_count INT DEFAULT 0;

-- Index for discussion comments
CREATE INDEX IF NOT EXISTS idx_discussion_comments_user_id ON public.discussion_comments(user_id);
CREATE INDEX IF NOT EXISTS idx_discussion_comments_discussion_id ON public.discussion_comments(discussion_id);
CREATE INDEX IF NOT EXISTS idx_discussion_comments_created_at ON public.discussion_comments(created_at DESC);

-- discussion_likes table - Tracks likes on discussion posts
CREATE TABLE IF NOT EXISTS public.discussion_likes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    discussion_id UUID NOT NULL REFERENCES public.discussions(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()),
    UNIQUE(user_id, discussion_id)
);

-- Index for discussion likes
CREATE INDEX IF NOT EXISTS idx_discussion_likes_user_id ON public.discussion_likes(user_id);
CREATE INDEX IF NOT EXISTS idx_discussion_likes_discussion_id ON public.discussion_likes(discussion_id);
