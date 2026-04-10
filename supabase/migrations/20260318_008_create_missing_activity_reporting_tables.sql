-- Migration: Create missing user tracking and reporting tables
-- Date: 2026-03-18
-- Description: Creates tables for user activity tracking, message deletion records, and story reports

-- user_activity table - Track user engagement and activities
CREATE TABLE IF NOT EXISTS public.user_activity (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    activity_type TEXT NOT NULL,
    content_id UUID,
    content_type TEXT,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now())
);

-- Add missing columns if user_activity table already exists
ALTER TABLE IF EXISTS public.user_activity
ADD COLUMN IF NOT EXISTS user_id UUID;

ALTER TABLE IF EXISTS public.user_activity
ADD COLUMN IF NOT EXISTS activity_type TEXT;

ALTER TABLE IF EXISTS public.user_activity
ADD COLUMN IF NOT EXISTS content_id UUID;

ALTER TABLE IF EXISTS public.user_activity
ADD COLUMN IF NOT EXISTS content_type TEXT;

ALTER TABLE IF EXISTS public.user_activity
ADD COLUMN IF NOT EXISTS metadata JSONB DEFAULT '{}';

-- Index for user activity
CREATE INDEX IF NOT EXISTS idx_user_activity_user_id ON public.user_activity(user_id);
CREATE INDEX IF NOT EXISTS idx_user_activity_type ON public.user_activity(activity_type);
CREATE INDEX IF NOT EXISTS idx_user_activity_created_at ON public.user_activity(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_user_activity_user_created ON public.user_activity(user_id, created_at DESC);

-- message_deletes table - Track message deletions (for recovery and audit)
CREATE TABLE IF NOT EXISTS public.message_deletes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    message_id UUID NOT NULL,
    conversation_id UUID NOT NULL,
    deleted_for_everyone BOOLEAN DEFAULT false,
    deletion_reason TEXT,
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now())
);

-- Add missing columns if message_deletes table already exists
ALTER TABLE IF EXISTS public.message_deletes
ADD COLUMN IF NOT EXISTS user_id UUID;

ALTER TABLE IF EXISTS public.message_deletes
ADD COLUMN IF NOT EXISTS message_id UUID;

ALTER TABLE IF EXISTS public.message_deletes
ADD COLUMN IF NOT EXISTS conversation_id UUID;

ALTER TABLE IF EXISTS public.message_deletes
ADD COLUMN IF NOT EXISTS deleted_for_everyone BOOLEAN DEFAULT false;

ALTER TABLE IF EXISTS public.message_deletes
ADD COLUMN IF NOT EXISTS deletion_reason TEXT;

-- Index for message deletes
CREATE INDEX IF NOT EXISTS idx_message_deletes_user_id ON public.message_deletes(user_id);
CREATE INDEX IF NOT EXISTS idx_message_deletes_message_id ON public.message_deletes(message_id);
CREATE INDEX IF NOT EXISTS idx_message_deletes_conversation_id ON public.message_deletes(conversation_id);
CREATE INDEX IF NOT EXISTS idx_message_deletes_created_at ON public.message_deletes(created_at DESC);

-- story_reports table - Track AI-generated story reports
CREATE TABLE IF NOT EXISTS public.story_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    story_id UUID,
    report_type TEXT NOT NULL,
    reason TEXT,
    status TEXT DEFAULT 'open',
    resolved_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now())
);

-- Add missing columns if story_reports table already exists
ALTER TABLE IF EXISTS public.story_reports
ADD COLUMN IF NOT EXISTS user_id UUID;

ALTER TABLE IF EXISTS public.story_reports
ADD COLUMN IF NOT EXISTS story_id UUID;

ALTER TABLE IF EXISTS public.story_reports
ADD COLUMN IF NOT EXISTS report_type TEXT;

ALTER TABLE IF EXISTS public.story_reports
ADD COLUMN IF NOT EXISTS reason TEXT;

ALTER TABLE IF EXISTS public.story_reports
ADD COLUMN IF NOT EXISTS status TEXT DEFAULT 'open';

ALTER TABLE IF EXISTS public.story_reports
ADD COLUMN IF NOT EXISTS resolved_at TIMESTAMPTZ;

-- Index for story reports
CREATE INDEX IF NOT EXISTS idx_story_reports_user_id ON public.story_reports(user_id);
CREATE INDEX IF NOT EXISTS idx_story_reports_story_id ON public.story_reports(story_id);
CREATE INDEX IF NOT EXISTS idx_story_reports_status ON public.story_reports(status);
CREATE INDEX IF NOT EXISTS idx_story_reports_created_at ON public.story_reports(created_at DESC);
