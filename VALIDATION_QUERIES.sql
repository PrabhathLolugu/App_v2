-- ============================================================================
-- SUPABASE MIGRATION VALIDATION & REPAIR SCRIPT
-- ============================================================================
-- Run this BEFORE deploying the security migrations to identify issues

-- ==============================================================================
-- SECTION 1: PRE-DEPLOYMENT CHECKS
-- ==============================================================================

-- Check 1: Verify auth.users table exists
SELECT COUNT(*) as auth_users_count FROM auth.users;
-- Expected: Should return a number (even if 0)

-- Check 2: Verify profiles table has is_admin column
SELECT column_name FROM information_schema.columns 
WHERE table_name = 'profiles' AND column_name = 'is_admin';
-- Expected: is_admin should exist

-- Check 3: Verify conversations table exists (required for chat)
SELECT 1 FROM pg_tables WHERE tablename='conversations' AND schemaname='public';
-- Expected: 1 row

-- Check 4: Verify users table exists (for FK constraints)
SELECT 1 FROM pg_tables WHERE tablename='users' AND schemaname='public';
-- Expected: 1 row

-- ==============================================================================
-- SECTION 2: TABLE EXISTENCE PRE-CHECK
-- ==============================================================================

-- Before running migrations, these tables should NOT exist yet:
SELECT tablename FROM pg_tables 
WHERE schemaname='public' 
AND tablename IN (
  'discussions', 'discussion_comments', 'discussion_likes',
  'map_comments', 'conversation_members',
  'user_roles', 'api_logs', 'user_warnings', 'epistemic_logs', 'audit_log',
  'user_activity', 'message_deletes', 'story_reports'
);
-- Expected: If they exist, that's OK (migrations handle with IF NOT EXISTS)

-- ==============================================================================
-- SECTION 3: POST-DEPLOYMENT VALIDATION
-- ==============================================================================

-- Run AFTER migrations complete to verify success

-- Validation 1: All 13 tables created
SELECT COUNT(*) as tables_created FROM pg_tables 
WHERE schemaname='public' 
AND tablename IN (
  'discussions', 'discussion_comments', 'discussion_likes',
  'map_comments', 'conversation_members',
  'user_roles', 'api_logs', 'user_warnings', 'epistemic_logs', 'audit_log',
  'user_activity', 'message_deletes', 'story_reports'
);
-- Expected: 13

-- Validation 2: RLS status for all tables
SELECT 
  tablename,
  rowsecurity,
  CASE 
    WHEN tablename = 'conversation_members' THEN 'DISABLED (temp workaround)'
    WHEN rowsecurity = true THEN '✅ ENABLED'
    ELSE '❌ DISABLED'
  END as rls_status
FROM pg_tables
WHERE schemaname='public' 
AND tablename IN (
  'discussions', 'discussion_comments', 'discussion_likes',
  'map_comments', 'conversation_members',
  'user_roles', 'api_logs', 'user_warnings', 'epistemic_logs', 'audit_log',
  'user_activity', 'message_deletes', 'story_reports'
)
ORDER BY tablename;
-- Expected: All show true EXCEPT conversation_members = false

-- Validation 3: Helper function exists
SELECT proname, lanname FROM pg_proc 
WHERE proname = 'is_admin' AND pg_get_function_result(oid) = 'boolean'
LIMIT 1;
-- Expected: 1 row (proname='is_admin', lanname='plpgsql')

-- Validation 4: Trigger exists
SELECT trigger_name FROM information_schema.triggers
WHERE trigger_schema='public' AND trigger_name='trigger_auto_fill_discussion_preview';
-- Expected: 1 row

-- Validation 5: Key indexes created
SELECT 
  schemaname, tablename, indexname
FROM pg_indexes
WHERE schemaname='public' 
AND indexname IN (
  'idx_discussions_category',
  'idx_discussions_site_name',
  'idx_user_roles_user_id',
  'idx_api_logs_endpoint',
  'idx_user_warnings_user_id'
);
-- Expected: At least 5 rows

-- Validation 6: Discuss table structure
SELECT 
  column_name, 
  data_type, 
  is_nullable
FROM information_schema.columns
WHERE table_name='discussions' 
ORDER BY ordinal_position;
-- Expected: Should include site_name, preview, category, content, title, author_id

-- Validation 7: Check view conversion
SELECT 
  table_schema,
  table_name,
  table_type
FROM information_schema.tables
WHERE table_name = 'map_comments_with_profiles';
-- Expected: VIEW

-- ==============================================================================
-- SECTION 4: EMERGENCY DIAGNOSTIC QUERIES
-- ==============================================================================

-- Diagnostic 1: List all RLS policies (if policies aren't working)
SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  cmd
FROM pg_policies
WHERE schemaname='public' 
AND tablename IN (
  'discussions', 'discussion_comments', 'discussion_likes',
  'user_roles', 'api_logs', 'user_warnings', 'user_activity'
)
ORDER BY tablename, policyname;

-- Diagnostic 2: Check for foreign key constraint issues
SELECT constraint_name, table_name, column_name 
FROM information_schema.key_column_usage 
WHERE constraint_type='FOREIGN KEY' 
AND table_schema='public' 
AND table_name IN (
  'discussions', 'discussion_comments', 'discussion_likes',
  'map_comments', 'conversation_members',
  'user_roles', 'api_logs', 'user_warnings', 'epistemic_logs', 'audit_log',
  'user_activity', 'message_deletes', 'story_reports'
);

-- Diagnostic 3: Find any remaining NULL values that shouldn't be
SELECT tablename FROM pg_tables 
WHERE schemaname='public' AND rowsecurity = false
AND tablename IN (
  'discussions', 'discussion_comments', 'discussion_likes',
  'map_comments', 'conversation_members',
  'user_roles', 'api_logs', 'user_warnings', 'epistemic_logs', 'audit_log',
  'user_activity', 'message_deletes', 'story_reports'
);
-- Expected: Only 'conversation_members' in this list

-- ==============================================================================
-- SECTION 5: QUICK FIX - IF SOMETHING BROKE
-- ==============================================================================

-- If chats won't load - this is already disabled:
-- SELECT rowsecurity FROM pg_tables 
-- WHERE tablename='conversation_members' AND schemaname='public';

-- If discussions won't display - check if table populated:
-- SELECT COUNT(*) FROM public.discussions;

-- Check for row limit issues (preview, category, content):
-- SELECT COUNT(*) as missing_preview FROM public.discussions 
-- WHERE preview IS NULL OR preview = '';

-- ==============================================================================
-- SECTION 6: SAMPLE DATA VALIDATION
-- ==============================================================================

-- After deploying, insert sample data to test RLS:
-- INSERT INTO public.discussions (
--   author_id, title, content, preview, category
-- ) VALUES (
--   (SELECT id FROM auth.users LIMIT 1),
--   'Test Discussion',
--   'This is test content for a discussion post',
--   'This is test content for a discussion post',
--   'general'
-- );

-- Verify as authenticated user:
-- SELECT id, title, category FROM public.discussions ORDER BY created_at DESC LIMIT 1;
-- Expected: Should return the inserted row (with RLS allowing read access)
