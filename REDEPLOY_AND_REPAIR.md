# Supabase Migrations - Redeploy & Repair Guide

## ⚠️ CRITICAL: Steps to Redeploy All Security Migrations

### Prerequisites
Ensure these exist in Supabase:
- ✅ `auth.users` table
- ✅ `profiles` table with `is_admin` BOOLEAN column
- ✅ `conversations` table
- ✅ All existing tables (up to migration 20260318_003)

---

## 🔄 Redeploy Order (EXACT SEQUENCE)

Run migrations in **THIS EXACT ORDER** via Supabase SQL Editor:

### Step 1: Create Missing Tables (Run First)
```
1. 20260318_005_create_missing_discussion_tables.sql
2. 20260318_006_create_missing_map_conversation_tables.sql
3. 20260318_007_create_missing_logging_tables.sql
4. 20260318_008_create_missing_activity_reporting_tables.sql
```

### Step 2: Create Enhancement Triggers (Run After Tables Exist)
```
5. 20260318_009_enhance_discussions_table.sql
```

### Step 3: Enable RLS & Security Policies (Run Last)
```
6. 20260318_004_fix_supabase_security_advisories.sql
```

**WHY THIS ORDER?**
- Steps 1-4 create table structures tables
- Step 5 adds triggers that reference created tables
- Step 6 enables RLS on top of complete schema

---

## 🛠️ How to Deploy via Supabase Dashboard

1. Open [Supabase Dashboard](https://app.supabase.com) → Your Project
2. Go to **SQL Editor**
3. Click **New Query**
4. Copy entire file content from: `supabase/migrations/20260318_005_...sql`
5. Paste into editor
6. Click **Run** (bottom right)
7. Wait for ✅ (green checkmark = success)
8. Check for errors (red warning = failure - scroll down to see error message)
9. Repeat for each file in order above

---

## 🐛 Common Issues & Fixes

### Issue 1: Foreign Key Constraint Failures
**Error:** `REFERENCES public.conversations(id)` - conversations table doesn't exist

**Fix:** Ensure `conversations` table exists before running 006, 007, 008
```sql
-- Check if table exists
SELECT tablename FROM pg_tables WHERE tablename='conversations';
```

### Issue 2: Column Already Exists
**Error:** `column "author_id" of relation "discussions" already exists`

**Fix:** This is OK! The migrations use `ADD COLUMN IF NOT EXISTS` so they're idempotent

### Issue 3: RLS Policies Fail After Enable  
**Error:** Chats/discussions not loading, policy failures

**Reason:** `conversation_members` has RLS disabled (temporary fix)

**Actions:**
1. Keep RLS disabled for now
2. Test chats load properly
3. Once working, re-enable and debug

### Issue 4: UUID Type Mismatch
**Error:** `operator does not exist: uuid = text`

**Fix:** Already applied! All comparisons use `::text` casting:
```sql
-- ✅ Correct
auth.uid()::text = user_id::text

-- ❌ Wrong
auth.uid() = user_id
```

### Issue 5: View Creation Fails
**Error:** CASCADE when dropping view fails

**Fix:** Already applied! Uses `DROP VIEW IF EXISTS ... CASCADE`

---

## ✅ Verification Steps

After all deployments complete:

### 1. Check All Tables Created
```sql
SELECT tablename FROM pg_tables 
WHERE schemaname='public' 
AND tablename IN (
  'discussions', 'discussion_comments', 'discussion_likes',
  'map_comments', 'conversation_members',
  'user_roles', 'api_logs', 'user_warnings', 'epistemic_logs', 'audit_log',
  'user_activity', 'message_deletes', 'story_reports'
)
ORDER BY tablename;
```

**Expected:** 13 rows

### 2. Check RLS Status  
```sql
SELECT tablename, rowsecurity FROM pg_tables
WHERE schemaname='public' 
AND tablename LIKE '%discussion%' OR tablename LIKE '%user_%' OR tablename LIKE '%activity%'
ORDER BY tablename;
```

**Expected Output:**
- All show `rowsecurity = t` (TRUE) EXCEPT
- `conversation_members` shows `rowsecurity = f` (FALSE - temporary)

### 3. Check Helper Function Exists
```sql
SELECT proname FROM pg_proc WHERE proname='is_admin';
```

**Expected:** 1 row

### 4. Check Trigger Exists
```sql
SELECT trigger_name FROM information_schema.triggers
WHERE trigger_schema='public' AND trigger_name='auto_fill_discussion_preview';
```

**Expected:** 1 row

### 5. Test RLS (Must be authenticated)
```sql
-- As authenticated user:
SELECT * FROM discussions LIMIT 1;

-- Should work (not blocked by policy)
```

### 6. Supabase Linter Check
Dashboard → Database → Errors → Run Linter

**Expected:** All 15 previous errors cleared ✅

---

## 🚀 Post-Deployment Testing

### 1. Test Chats Load
- App: Navigate to chat screen
- Expected: Messages load, no SQL errors
- If fails: Check conversation_members RLS status

### 2. Test Discussions
- App: Go to map → forum/community tab
- Create new discussion
- Expected: Shows category toggle (General/Location)
- Expected: Site name appears on post
- Expected: Preview text auto-generates

### 3. Test Likes & Comments
- Like a discussion
- Add a comment
- Expected: Works without errors

### 4. Check Firebase/Supabase Logs
Dashboard → Database Activity/Logs

**Look for:** No ERROR level messages about RLS or policies

---

## 🔧 Emergency Rollback

If deployment breaks everything:

```sql
-- Disable RLS on all tables to restore temporary functionality
ALTER TABLE public.discussions DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.discussion_comments DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.discussion_likes DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_activity DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.message_deletes DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.story_reports DISABLE ROW LEVEL SECURITY;

-- Then investigate root cause and re-enable one at a time
```

---

## 📋 Troubleshooting Checklist

- [ ] All 6 migrations run in correct order
- [ ] No SQL syntax errors in Supabase logs
- [ ] All 13 tables exist in pg_tables
- [ ] RLS status verified for each table  
- [ ] is_admin() function exists
- [ ] auto_fill_discussion_preview() trigger exists
- [ ] Chats load without errors
- [ ] Discussions show all new features (site_name, category, preview)
- [ ] Supabase linter shows 0 errors
- [ ] No ERROR messages in database activity logs

---

## 📞 If Still Having Issues

Provide:
1. **Exact error message** from Supabase SQL Editor or app logs
2. **Which migration** is failing (004-009)
3. **When does it fail** (during deploy or at runtime)
4. **What functionality is broken** (chats, discussions, etc.)
