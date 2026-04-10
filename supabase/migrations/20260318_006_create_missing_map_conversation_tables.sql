-- Migration: Create missing map and conversation tables
-- Date: 2026-03-18
-- Description: Creates tables for map comments and conversation members
--              If tables exist, adds missing columns

-- map_comments table - Comments on heritage site map locations
CREATE TABLE IF NOT EXISTS public.map_comments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    site_id UUID,
    content TEXT NOT NULL,
    rating INT,
    is_helpful BOOLEAN DEFAULT false,
    helpful_count INT DEFAULT 0,
    unhelpful_count INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now())
);

-- Add missing columns if map_comments table already exists
ALTER TABLE IF EXISTS public.map_comments
ADD COLUMN IF NOT EXISTS user_id UUID;

ALTER TABLE IF EXISTS public.map_comments
ADD COLUMN IF NOT EXISTS site_id UUID;

ALTER TABLE IF EXISTS public.map_comments
ADD COLUMN IF NOT EXISTS content TEXT;

ALTER TABLE IF EXISTS public.map_comments
ADD COLUMN IF NOT EXISTS rating INT;

ALTER TABLE IF EXISTS public.map_comments
ADD COLUMN IF NOT EXISTS is_helpful BOOLEAN DEFAULT false;

ALTER TABLE IF EXISTS public.map_comments
ADD COLUMN IF NOT EXISTS helpful_count INT DEFAULT 0;

ALTER TABLE IF EXISTS public.map_comments
ADD COLUMN IF NOT EXISTS unhelpful_count INT DEFAULT 0;

-- Index for map comments
CREATE INDEX IF NOT EXISTS idx_map_comments_user_id ON public.map_comments(user_id);
CREATE INDEX IF NOT EXISTS idx_map_comments_site_id ON public.map_comments(site_id);
CREATE INDEX IF NOT EXISTS idx_map_comments_created_at ON public.map_comments(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_map_comments_site_created ON public.map_comments(site_id, created_at DESC);

-- conversation_members table - Junction table for group chat participants
CREATE TABLE IF NOT EXISTS public.conversation_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    role TEXT DEFAULT 'member',
    last_read_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()),
    joined_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()),
    deleted_at TIMESTAMPTZ DEFAULT NULL,
    UNIQUE(conversation_id, user_id)
);

-- Add missing columns if conversation_members table already exists
ALTER TABLE IF EXISTS public.conversation_members
ADD COLUMN IF NOT EXISTS conversation_id UUID;

ALTER TABLE IF EXISTS public.conversation_members
ADD COLUMN IF NOT EXISTS user_id UUID;

ALTER TABLE IF EXISTS public.conversation_members
ADD COLUMN IF NOT EXISTS role TEXT DEFAULT 'member';

ALTER TABLE IF EXISTS public.conversation_members
ADD COLUMN IF NOT EXISTS last_read_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now());

ALTER TABLE IF EXISTS public.conversation_members
ADD COLUMN IF NOT EXISTS joined_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now());

ALTER TABLE IF EXISTS public.conversation_members
ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMPTZ DEFAULT NULL;

-- Index for conversation members
CREATE INDEX IF NOT EXISTS idx_conversation_members_conversation_id ON public.conversation_members(conversation_id);
CREATE INDEX IF NOT EXISTS idx_conversation_members_user_id ON public.conversation_members(user_id);
CREATE INDEX IF NOT EXISTS idx_conversation_members_deleted_at ON public.conversation_members(user_id, deleted_at) WHERE deleted_at IS NOT NULL;
