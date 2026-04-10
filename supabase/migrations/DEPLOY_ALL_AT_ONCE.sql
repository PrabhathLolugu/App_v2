-- ============================================================================
-- COMPLETE SUPABASE MIGRATION BUNDLE - ALL IN ONE
-- ============================================================================
-- Date: 2026-03-18
-- Description: All 6 migrations combined with error handling
-- How to use: Copy entire file → Paste in Supabase SQL Editor → Click Run
-- ============================================================================

-- Set error level to continue on errors
SET client_min_messages = WARNING;

-- ============================================================================
-- MIGRATION 005: Create Missing Discussion Tables
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.discussions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    author_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    site_id UUID,
    site_name TEXT,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    preview TEXT,
    category TEXT DEFAULT 'general',
    is_pinned BOOLEAN DEFAULT false,
    comment_count INT DEFAULT 0,
    like_count INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now())
);

ALTER TABLE IF EXISTS public.discussions ADD COLUMN IF NOT EXISTS author_id UUID;
ALTER TABLE IF EXISTS public.discussions ADD COLUMN IF NOT EXISTS site_id UUID;
ALTER TABLE IF EXISTS public.discussions ADD COLUMN IF NOT EXISTS site_name TEXT;
ALTER TABLE IF EXISTS public.discussions ADD COLUMN IF NOT EXISTS title TEXT;
ALTER TABLE IF EXISTS public.discussions ADD COLUMN IF NOT EXISTS content TEXT;
ALTER TABLE IF EXISTS public.discussions ADD COLUMN IF NOT EXISTS preview TEXT;
ALTER TABLE IF EXISTS public.discussions ADD COLUMN IF NOT EXISTS category TEXT DEFAULT 'general';
ALTER TABLE IF EXISTS public.discussions ADD COLUMN IF NOT EXISTS is_pinned BOOLEAN DEFAULT false;
ALTER TABLE IF EXISTS public.discussions ADD COLUMN IF NOT EXISTS comment_count INT DEFAULT 0;
ALTER TABLE IF EXISTS public.discussions ADD COLUMN IF NOT EXISTS like_count INT DEFAULT 0;
ALTER TABLE IF EXISTS public.discussions ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now());
ALTER TABLE IF EXISTS public.discussions ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now());

-- ✅ ADD SEARCH OPTIMIZATION COLUMN
ALTER TABLE IF EXISTS public.discussions
ADD COLUMN IF NOT EXISTS search_vector tsvector GENERATED ALWAYS AS (
  to_tsvector('english', COALESCE(title, '') || ' ' || COALESCE(content, ''))
) STORED;

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

-- discussion_comments table
CREATE TABLE IF NOT EXISTS public.discussion_comments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    discussion_id UUID NOT NULL REFERENCES public.discussions(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    like_count INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now())
);

ALTER TABLE IF EXISTS public.discussion_comments ADD COLUMN IF NOT EXISTS discussion_id UUID;
ALTER TABLE IF EXISTS public.discussion_comments ADD COLUMN IF NOT EXISTS user_id UUID;
ALTER TABLE IF EXISTS public.discussion_comments ADD COLUMN IF NOT EXISTS content TEXT;
ALTER TABLE IF EXISTS public.discussion_comments ADD COLUMN IF NOT EXISTS like_count INT DEFAULT 0;
ALTER TABLE IF EXISTS public.discussion_comments ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now());
ALTER TABLE IF EXISTS public.discussion_comments ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now());

CREATE INDEX IF NOT EXISTS idx_discussion_comments_user_id ON public.discussion_comments(user_id);
CREATE INDEX IF NOT EXISTS idx_discussion_comments_discussion_id ON public.discussion_comments(discussion_id);
CREATE INDEX IF NOT EXISTS idx_discussion_comments_created_at ON public.discussion_comments(created_at DESC);

-- discussion_likes table
CREATE TABLE IF NOT EXISTS public.discussion_likes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    discussion_id UUID NOT NULL REFERENCES public.discussions(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()),
    UNIQUE(user_id, discussion_id)
);

ALTER TABLE IF EXISTS public.discussion_likes ADD COLUMN IF NOT EXISTS discussion_id UUID;
ALTER TABLE IF EXISTS public.discussion_likes ADD COLUMN IF NOT EXISTS user_id UUID;
ALTER TABLE IF EXISTS public.discussion_likes ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now());

CREATE INDEX IF NOT EXISTS idx_discussion_likes_user_id ON public.discussion_likes(user_id);
CREATE INDEX IF NOT EXISTS idx_discussion_likes_discussion_id ON public.discussion_likes(discussion_id);

-- ============================================================================
-- MIGRATION 006: Create Missing Map Conversation Tables
-- ============================================================================

-- map_comments table
CREATE TABLE IF NOT EXISTS public.map_comments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    site_id UUID NOT NULL,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now())
);

ALTER TABLE IF EXISTS public.map_comments ADD COLUMN IF NOT EXISTS site_id UUID;
ALTER TABLE IF EXISTS public.map_comments ADD COLUMN IF NOT EXISTS user_id UUID;
ALTER TABLE IF EXISTS public.map_comments ADD COLUMN IF NOT EXISTS content TEXT;
ALTER TABLE IF EXISTS public.map_comments ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now());
ALTER TABLE IF EXISTS public.map_comments ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now());

CREATE INDEX IF NOT EXISTS idx_map_comments_site_id ON public.map_comments(site_id);
CREATE INDEX IF NOT EXISTS idx_map_comments_user_id ON public.map_comments(user_id);
CREATE INDEX IF NOT EXISTS idx_map_comments_created_at ON public.map_comments(created_at DESC);

-- conversation_members table
CREATE TABLE IF NOT EXISTS public.conversation_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    joined_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()),
    left_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now())
);

ALTER TABLE IF EXISTS public.conversation_members ADD COLUMN IF NOT EXISTS conversation_id UUID;
ALTER TABLE IF EXISTS public.conversation_members ADD COLUMN IF NOT EXISTS user_id UUID;
ALTER TABLE IF EXISTS public.conversation_members ADD COLUMN IF NOT EXISTS joined_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now());
ALTER TABLE IF EXISTS public.conversation_members ADD COLUMN IF NOT EXISTS left_at TIMESTAMPTZ;
ALTER TABLE IF EXISTS public.conversation_members ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now());

CREATE INDEX IF NOT EXISTS idx_conversation_members_conversation_id ON public.conversation_members(conversation_id);
CREATE INDEX IF NOT EXISTS idx_conversation_members_user_id ON public.conversation_members(user_id);

-- ============================================================================
-- MIGRATION 007: Create Missing Logging Tables
-- ============================================================================

-- user_roles table
CREATE TABLE IF NOT EXISTS public.user_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    role TEXT NOT NULL,
    assigned_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now()),
    UNIQUE(user_id, role)
);

ALTER TABLE IF EXISTS public.user_roles ADD COLUMN IF NOT EXISTS user_id UUID;
ALTER TABLE IF EXISTS public.user_roles ADD COLUMN IF NOT EXISTS role TEXT;
ALTER TABLE IF EXISTS public.user_roles ADD COLUMN IF NOT EXISTS assigned_by UUID;
ALTER TABLE IF EXISTS public.user_roles ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now());

CREATE INDEX IF NOT EXISTS idx_user_roles_user_id ON public.user_roles(user_id);
CREATE INDEX IF NOT EXISTS idx_user_roles_role ON public.user_roles(role);

-- api_logs table
CREATE TABLE IF NOT EXISTS public.api_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    endpoint TEXT NOT NULL,
    method TEXT NOT NULL,
    status_code INT,
    response_time_ms INT,
    user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    error_message TEXT,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now())
);

ALTER TABLE IF EXISTS public.api_logs ADD COLUMN IF NOT EXISTS user_id UUID;
ALTER TABLE IF EXISTS public.api_logs ADD COLUMN IF NOT EXISTS endpoint TEXT;
ALTER TABLE IF EXISTS public.api_logs ADD COLUMN IF NOT EXISTS method TEXT;
ALTER TABLE IF EXISTS public.api_logs ADD COLUMN IF NOT EXISTS status_code INT;
ALTER TABLE IF EXISTS public.api_logs ADD COLUMN IF NOT EXISTS response_time_ms INT;
ALTER TABLE IF EXISTS public.api_logs ADD COLUMN IF NOT EXISTS error_message TEXT;
ALTER TABLE IF EXISTS public.api_logs ADD COLUMN IF NOT EXISTS metadata JSONB DEFAULT '{}';

CREATE INDEX IF NOT EXISTS idx_api_logs_endpoint ON public.api_logs(endpoint);
CREATE INDEX IF NOT EXISTS idx_api_logs_created_at ON public.api_logs(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_api_logs_status_code ON public.api_logs(status_code);

-- user_warnings table
CREATE TABLE IF NOT EXISTS public.user_warnings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    warning_type TEXT NOT NULL,
    reason TEXT,
    severity TEXT DEFAULT 'low',
    resolved BOOLEAN DEFAULT false,
    resolved_at TIMESTAMPTZ,
    issued_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now())
);

ALTER TABLE IF EXISTS public.user_warnings ADD COLUMN IF NOT EXISTS user_id UUID;
ALTER TABLE IF EXISTS public.user_warnings ADD COLUMN IF NOT EXISTS warning_type TEXT;
ALTER TABLE IF EXISTS public.user_warnings ADD COLUMN IF NOT EXISTS reason TEXT;
ALTER TABLE IF EXISTS public.user_warnings ADD COLUMN IF NOT EXISTS severity TEXT DEFAULT 'low';
ALTER TABLE IF EXISTS public.user_warnings ADD COLUMN IF NOT EXISTS resolved BOOLEAN DEFAULT false;
ALTER TABLE IF EXISTS public.user_warnings ADD COLUMN IF NOT EXISTS resolved_at TIMESTAMPTZ;
ALTER TABLE IF EXISTS public.user_warnings ADD COLUMN IF NOT EXISTS issued_by UUID;

CREATE INDEX IF NOT EXISTS idx_user_warnings_user_id ON public.user_warnings(user_id);
CREATE INDEX IF NOT EXISTS idx_user_warnings_created_at ON public.user_warnings(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_user_warnings_resolved ON public.user_warnings(resolved);

-- epistemic_logs table
CREATE TABLE IF NOT EXISTS public.epistemic_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_type TEXT NOT NULL,
    user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    content_id UUID,
    content_type TEXT,
    data JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now())
);

ALTER TABLE IF EXISTS public.epistemic_logs ADD COLUMN IF NOT EXISTS user_id UUID;
ALTER TABLE IF EXISTS public.epistemic_logs ADD COLUMN IF NOT EXISTS event_type TEXT;
ALTER TABLE IF EXISTS public.epistemic_logs ADD COLUMN IF NOT EXISTS content_id UUID;
ALTER TABLE IF EXISTS public.epistemic_logs ADD COLUMN IF NOT EXISTS content_type TEXT;
ALTER TABLE IF EXISTS public.epistemic_logs ADD COLUMN IF NOT EXISTS data JSONB DEFAULT '{}';

CREATE INDEX IF NOT EXISTS idx_epistemic_logs_event_type ON public.epistemic_logs(event_type);
CREATE INDEX IF NOT EXISTS idx_epistemic_logs_created_at ON public.epistemic_logs(created_at DESC);

-- audit_log table
CREATE TABLE IF NOT EXISTS public.audit_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    action TEXT NOT NULL,
    user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    table_name TEXT,
    record_id UUID,
    old_values JSONB,
    new_values JSONB,
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now())
);

ALTER TABLE IF EXISTS public.audit_log ADD COLUMN IF NOT EXISTS action TEXT;
ALTER TABLE IF EXISTS public.audit_log ADD COLUMN IF NOT EXISTS user_id UUID;
ALTER TABLE IF EXISTS public.audit_log ADD COLUMN IF NOT EXISTS table_name TEXT;
ALTER TABLE IF EXISTS public.audit_log ADD COLUMN IF NOT EXISTS record_id UUID;
ALTER TABLE IF EXISTS public.audit_log ADD COLUMN IF NOT EXISTS old_values JSONB;
ALTER TABLE IF EXISTS public.audit_log ADD COLUMN IF NOT EXISTS new_values JSONB;

CREATE INDEX IF NOT EXISTS idx_audit_log_user_id ON public.audit_log(user_id);
CREATE INDEX IF NOT EXISTS idx_audit_log_table_name ON public.audit_log(table_name);
CREATE INDEX IF NOT EXISTS idx_audit_log_created_at ON public.audit_log(created_at DESC);

-- ============================================================================
-- MIGRATION 008: Create Missing Activity Reporting Tables
-- ============================================================================

-- user_activity table
CREATE TABLE IF NOT EXISTS public.user_activity (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    activity_type TEXT NOT NULL,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now())
);

ALTER TABLE IF EXISTS public.user_activity ADD COLUMN IF NOT EXISTS user_id UUID;
ALTER TABLE IF EXISTS public.user_activity ADD COLUMN IF NOT EXISTS activity_type TEXT;
ALTER TABLE IF EXISTS public.user_activity ADD COLUMN IF NOT EXISTS metadata JSONB DEFAULT '{}';

CREATE INDEX IF NOT EXISTS idx_user_activity_user_id ON public.user_activity(user_id);
CREATE INDEX IF NOT EXISTS idx_user_activity_created_at ON public.user_activity(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_user_activity_type ON public.user_activity(activity_type);

-- message_deletes table
CREATE TABLE IF NOT EXISTS public.message_deletes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    message_id UUID NOT NULL,
    deletion_reason TEXT,
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now())
);

ALTER TABLE IF EXISTS public.message_deletes ADD COLUMN IF NOT EXISTS user_id UUID;
ALTER TABLE IF EXISTS public.message_deletes ADD COLUMN IF NOT EXISTS message_id UUID;
ALTER TABLE IF EXISTS public.message_deletes ADD COLUMN IF NOT EXISTS deletion_reason TEXT;

CREATE INDEX IF NOT EXISTS idx_message_deletes_user_id ON public.message_deletes(user_id);
CREATE INDEX IF NOT EXISTS idx_message_deletes_message_id ON public.message_deletes(message_id);
CREATE INDEX IF NOT EXISTS idx_message_deletes_created_at ON public.message_deletes(created_at DESC);

-- story_reports table
CREATE TABLE IF NOT EXISTS public.story_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    story_id UUID,
    report_reason TEXT,
    report_details TEXT,
    status TEXT DEFAULT 'pending',
    created_at TIMESTAMPTZ DEFAULT timezone('utc'::text, now())
);

ALTER TABLE IF EXISTS public.story_reports ADD COLUMN IF NOT EXISTS user_id UUID;
ALTER TABLE IF EXISTS public.story_reports ADD COLUMN IF NOT EXISTS story_id UUID;
ALTER TABLE IF EXISTS public.story_reports ADD COLUMN IF NOT EXISTS report_reason TEXT;
ALTER TABLE IF EXISTS public.story_reports ADD COLUMN IF NOT EXISTS report_details TEXT;
ALTER TABLE IF EXISTS public.story_reports ADD COLUMN IF NOT EXISTS status TEXT DEFAULT 'pending';

CREATE INDEX IF NOT EXISTS idx_story_reports_user_id ON public.story_reports(user_id);
CREATE INDEX IF NOT EXISTS idx_story_reports_status ON public.story_reports(status);
CREATE INDEX IF NOT EXISTS idx_story_reports_created_at ON public.story_reports(created_at DESC);

-- ============================================================================
-- MIGRATION 009: Enhance Discussions Table
-- ============================================================================

ALTER TABLE IF EXISTS public.discussions ADD COLUMN IF NOT EXISTS site_name TEXT;
ALTER TABLE IF EXISTS public.discussions ADD COLUMN IF NOT EXISTS preview TEXT;
ALTER TABLE IF EXISTS public.discussions ADD COLUMN IF NOT EXISTS category TEXT DEFAULT 'general';

CREATE INDEX IF NOT EXISTS idx_discussions_category ON public.discussions(category);
CREATE INDEX IF NOT EXISTS idx_discussions_site_name ON public.discussions(site_name);

-- Function to auto-fill preview from content
CREATE OR REPLACE FUNCTION auto_fill_discussion_preview()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.content IS NOT NULL AND (NEW.preview IS NULL OR NEW.preview = '') THEN
        NEW.preview := CASE
            WHEN LENGTH(NEW.content) > 200 THEN SUBSTRING(NEW.content, 1, 200) || '...'
            ELSE NEW.content
        END;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger if it doesn't exist
DROP TRIGGER IF EXISTS trigger_auto_fill_discussion_preview ON public.discussions;
CREATE TRIGGER trigger_auto_fill_discussion_preview
    BEFORE INSERT OR UPDATE ON public.discussions
    FOR EACH ROW
    EXECUTE FUNCTION auto_fill_discussion_preview();

-- Backfill preview for existing discussions
UPDATE public.discussions
SET preview = CASE
    WHEN LENGTH(content) > 200 THEN SUBSTRING(content, 1, 200) || '...'
    ELSE content
END
WHERE preview IS NULL OR preview = '';

-- Set default category for existing rows
UPDATE public.discussions
SET category = 'general'
WHERE category IS NULL;

-- ============================================================================
-- MIGRATION 004: Helper Function + RLS Setup
-- ============================================================================

-- Helper function to check if current user is admin
CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS(
        SELECT 1 FROM public.profiles
        WHERE id = auth.uid() AND is_admin = true
    );
END;
$$ LANGUAGE plpgsql STABLE;

-- Fix map_comments_with_profiles view
DROP VIEW IF EXISTS public.map_comments_with_profiles CASCADE;
CREATE OR REPLACE VIEW public.map_comments_with_profiles WITH (SECURITY_INVOKER = true)
AS SELECT
    mc.id,
    mc.site_id,
    mc.user_id,
    mc.created_at,
    p.full_name,
    p.avatar_url,
    p.username
FROM public.map_comments mc
LEFT JOIN public.profiles p ON mc.user_id = p.id;

-- ============================================================================
-- ENABLE RLS AND CREATE SECURITY POLICIES
-- ============================================================================

-- Discussions table RLS
ALTER TABLE IF EXISTS public.discussions DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.discussions ENABLE ROW LEVEL SECURITY;

-- Drop existing policies to avoid conflicts
DROP POLICY IF EXISTS "Authenticated users can read discussions" ON public.discussions;
DROP POLICY IF EXISTS "Users can insert own discussions" ON public.discussions;
DROP POLICY IF EXISTS "Users can update own discussions" ON public.discussions;
DROP POLICY IF EXISTS "Users can delete own discussions" ON public.discussions;

CREATE POLICY "Authenticated users can read discussions"
    ON public.discussions FOR SELECT
    USING (auth.role() = 'authenticated');

CREATE POLICY "Users can insert own discussions"
    ON public.discussions FOR INSERT
    WITH CHECK (auth.uid()::text = author_id::text);

CREATE POLICY "Users can update own discussions"
    ON public.discussions FOR UPDATE
    USING (auth.uid()::text = author_id::text)
    WITH CHECK (auth.uid()::text = author_id::text);

CREATE POLICY "Users can delete own discussions"
    ON public.discussions FOR DELETE
    USING (auth.uid()::text = author_id::text);

-- Discussion comments RLS
ALTER TABLE IF EXISTS public.discussion_comments DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.discussion_comments ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Authenticated users can read discussion comments" ON public.discussion_comments;
DROP POLICY IF EXISTS "Users can insert own comments" ON public.discussion_comments;
DROP POLICY IF EXISTS "Users can update own comments" ON public.discussion_comments;
DROP POLICY IF EXISTS "Users can delete own comments" ON public.discussion_comments;

CREATE POLICY "Authenticated users can read discussion comments"
    ON public.discussion_comments FOR SELECT
    USING (auth.role() = 'authenticated');

CREATE POLICY "Users can insert own comments"
    ON public.discussion_comments FOR INSERT
    WITH CHECK (auth.uid()::text = user_id::text);

CREATE POLICY "Users can update own comments"
    ON public.discussion_comments FOR UPDATE
    USING (auth.uid()::text = user_id::text)
    WITH CHECK (auth.uid()::text = user_id::text);

CREATE POLICY "Users can delete own comments"
    ON public.discussion_comments FOR DELETE
    USING (auth.uid()::text = user_id::text);

-- Discussion likes RLS
ALTER TABLE IF EXISTS public.discussion_likes DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.discussion_likes ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Authenticated users can read likes" ON public.discussion_likes;
DROP POLICY IF EXISTS "Users can insert own likes" ON public.discussion_likes;
DROP POLICY IF EXISTS "Users can delete own likes" ON public.discussion_likes;

CREATE POLICY "Authenticated users can read likes"
    ON public.discussion_likes FOR SELECT
    USING (auth.role() = 'authenticated');

CREATE POLICY "Users can insert own likes"
    ON public.discussion_likes FOR INSERT
    WITH CHECK (auth.uid()::text = user_id::text);

CREATE POLICY "Users can delete own likes"
    ON public.discussion_likes FOR DELETE
    USING (auth.uid()::text = user_id::text);

-- Map comments RLS
ALTER TABLE IF EXISTS public.map_comments DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.map_comments ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Authenticated users can read map comments" ON public.map_comments;
DROP POLICY IF EXISTS "Users can insert map comments" ON public.map_comments;
DROP POLICY IF EXISTS "Users can update own map comments" ON public.map_comments;
DROP POLICY IF EXISTS "Users can delete own map comments" ON public.map_comments;

CREATE POLICY "Authenticated users can read map comments"
    ON public.map_comments FOR SELECT
    USING (auth.role() = 'authenticated');

CREATE POLICY "Users can insert map comments"
    ON public.map_comments FOR INSERT
    WITH CHECK (auth.uid()::text = user_id::text);

CREATE POLICY "Users can update own map comments"
    ON public.map_comments FOR UPDATE
    USING (auth.uid()::text = user_id::text)
    WITH CHECK (auth.uid()::text = user_id::text);

CREATE POLICY "Users can delete own map comments"
    ON public.map_comments FOR DELETE
    USING (auth.uid()::text = user_id::text);

-- User activity RLS
ALTER TABLE IF EXISTS public.user_activity DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.user_activity ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can read own activity" ON public.user_activity;
DROP POLICY IF EXISTS "Service role can insert activity" ON public.user_activity;

CREATE POLICY "Users can read own activity"
    ON public.user_activity FOR SELECT
    USING (auth.uid()::text = user_id::text OR is_admin());

CREATE POLICY "Service role can insert activity"
    ON public.user_activity FOR INSERT
    WITH CHECK (auth.role() = 'service_role');

-- Message deletes RLS
ALTER TABLE IF EXISTS public.message_deletes DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.message_deletes ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can read own deletes" ON public.message_deletes;
DROP POLICY IF EXISTS "Users can record own deletes" ON public.message_deletes;

CREATE POLICY "Users can read own deletes"
    ON public.message_deletes FOR SELECT
    USING (auth.uid()::text = user_id::text OR is_admin());

CREATE POLICY "Users can record own deletes"
    ON public.message_deletes FOR INSERT
    WITH CHECK (auth.uid()::text = user_id::text);

-- Story reports RLS
ALTER TABLE IF EXISTS public.story_reports DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.story_reports ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can read own reports" ON public.story_reports;
DROP POLICY IF EXISTS "Users can create reports" ON public.story_reports;

CREATE POLICY "Users can read own reports"
    ON public.story_reports FOR SELECT
    USING (auth.uid()::text = user_id::text OR is_admin());

CREATE POLICY "Users can create reports"
    ON public.story_reports FOR INSERT
    WITH CHECK (auth.uid()::text = user_id::text);

-- Admin tables RLS (service_role + admins only)
ALTER TABLE IF EXISTS public.user_roles DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.user_roles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Service role and admins can read user_roles" ON public.user_roles;
DROP POLICY IF EXISTS "Service role can write user_roles" ON public.user_roles;
DROP POLICY IF EXISTS "Service role can update user_roles" ON public.user_roles;
DROP POLICY IF EXISTS "Service role can delete user_roles" ON public.user_roles;

CREATE POLICY "Service role and admins can read user_roles"
    ON public.user_roles
    FOR SELECT
    USING (auth.role() = 'service_role' OR (auth.role() = 'authenticated' AND is_admin()));

CREATE POLICY "Service role can write user_roles"
    ON public.user_roles
    FOR INSERT
    WITH CHECK (auth.role() = 'service_role');

CREATE POLICY "Service role can update user_roles"
    ON public.user_roles
    FOR UPDATE
    USING (auth.role() = 'service_role')
    WITH CHECK (auth.role() = 'service_role');

CREATE POLICY "Service role can delete user_roles"
    ON public.user_roles
    FOR DELETE
    USING (auth.role() = 'service_role');

-- API logs RLS
ALTER TABLE IF EXISTS public.api_logs DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.api_logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Service role and admins can read api_logs" ON public.api_logs;
DROP POLICY IF EXISTS "Service role can write api_logs" ON public.api_logs;

CREATE POLICY "Service role and admins can read api_logs"
    ON public.api_logs
    FOR SELECT
    USING (auth.role() = 'service_role' OR (auth.role() = 'authenticated' AND is_admin()));

CREATE POLICY "Service role can write api_logs"
    ON public.api_logs
    FOR INSERT
    WITH CHECK (auth.role() = 'service_role');

-- User warnings RLS
ALTER TABLE IF EXISTS public.user_warnings DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.user_warnings ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Service role and admins can read user_warnings" ON public.user_warnings;
DROP POLICY IF EXISTS "Service role can write user_warnings" ON public.user_warnings;
DROP POLICY IF EXISTS "Service role can update user_warnings" ON public.user_warnings;

CREATE POLICY "Service role and admins can read user_warnings"
    ON public.user_warnings
    FOR SELECT
    USING (auth.role() = 'service_role' OR (auth.role() = 'authenticated' AND is_admin()));

CREATE POLICY "Service role can write user_warnings"
    ON public.user_warnings
    FOR INSERT
    WITH CHECK (auth.role() = 'service_role');

CREATE POLICY "Service role can update user_warnings"
    ON public.user_warnings
    FOR UPDATE
    USING (auth.role() = 'service_role')
    WITH CHECK (auth.role() = 'service_role');

-- Epistemic logs RLS
ALTER TABLE IF EXISTS public.epistemic_logs DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.epistemic_logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Service role and admins can read epistemic_logs" ON public.epistemic_logs;
DROP POLICY IF EXISTS "Service role can write epistemic_logs" ON public.epistemic_logs;

CREATE POLICY "Service role and admins can read epistemic_logs"
    ON public.epistemic_logs
    FOR SELECT
    USING (auth.role() = 'service_role' OR (auth.role() = 'authenticated' AND is_admin()));

CREATE POLICY "Service role can write epistemic_logs"
    ON public.epistemic_logs
    FOR INSERT
    WITH CHECK (auth.role() = 'service_role');

-- Audit log RLS
ALTER TABLE IF EXISTS public.audit_log DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.audit_log ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Service role and admins can read audit log" ON public.audit_log;
DROP POLICY IF EXISTS "Service role can write audit log" ON public.audit_log;

CREATE POLICY "Service role and admins can read audit log"
    ON public.audit_log
    FOR SELECT
    USING (auth.role() = 'service_role' OR (auth.role() = 'authenticated' AND is_admin()));

CREATE POLICY "Service role can write audit log"
    ON public.audit_log
    FOR INSERT
    WITH CHECK (auth.role() = 'service_role');

-- Conversation members (RLS DISABLED TEMPORARILY - for debugging chat)
ALTER TABLE public.conversation_members DISABLE ROW LEVEL SECURITY;

-- ============================================================================
-- DEPLOYMENT VERIFICATION
-- ============================================================================

SELECT 
    'DEPLOYMENT COMPLETE - Check results below:' as status,
    (SELECT COUNT(*) FROM pg_tables WHERE schemaname='public' AND tablename IN (
        'discussions', 'discussion_comments', 'discussion_likes',
        'map_comments', 'conversation_members',
        'user_roles', 'api_logs', 'user_warnings', 'epistemic_logs', 'audit_log',
        'user_activity', 'message_deletes', 'story_reports'
    )) as tables_created,
    (SELECT COUNT(*) FROM pg_proc WHERE proname='is_admin') as helper_functions,
    (SELECT COUNT(*) FROM information_schema.triggers WHERE trigger_name='trigger_auto_fill_discussion_preview') as triggers_created;
