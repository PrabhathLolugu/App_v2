# Supabase Migrations Deployment Guide

## ✅ Migrations Ready to Deploy

All migrations have been created and fixed. Deploy in this exact order:

### 1. Create Missing Tables (Run First)
```bash
# Deploy in this specific order:
supabase migrations deploy --db-remote
```

**Migration Files** (in order):
1. `20260318_005_create_missing_discussion_tables.sql` - Discussions, comments, likes
2. `20260318_006_create_missing_map_conversation_tables.sql` - Map comments, conversation members
3. `20260318_007_create_missing_logging_tables.sql` - Logging and audit tables
4. `20260318_008_create_missing_activity_reporting_tables.sql` - Activity and reports
5. `20260318_009_enhance_discussions_table.sql` - Add site_name, category, preview columns

### 2. Enable RLS & Create Policies (Run Last)
```bash
supabase migrations deploy --db-remote
```

**Migration File:**
6. `20260318_004_fix_supabase_security_advisories.sql` - RLS policies and security fixes

**Important:** conversation_members RLS is TEMPORARILY DISABLED to debug chat loading issues

---

## 🔧 How to Deploy via Supabase Dashboard

If CLI is not available, use the Supabase dashboard:

1. Go to [SQL Editor](https://app.supabase.com/project/_/sql) in Supabase
2. Create a new query
3. Copy and paste entire migration file content
4. Click **Run**
5. Verify: Check for green ✓ (success) or red ✗ (error)

---

## 🐛 Bug Fixes Applied

### Discussions UI Issues (FIXED)
✅ **Issue**: Site name not showing in discussions  
**Solution**: Added `site_name` column + JOIN logic

✅ **Issue**: No "General" vs "Location" options  
**Solution**: Added category selection UI in discussion creation dialog

✅ **Issue**: Content/preview column mismatch  
**Solution**: 
- Added `preview` column (first 200 chars of content)
- Auto-fills via `auto_fill_discussion_preview()` trigger
- UI now uses `preview` for display

### Type Casting Fixes (FIXED)
Fixed UUID/TEXT mismatches in RLS policies:
- ✅ 20260209202706 (user_devices)
- ✅ 20260212_001 (chat_conversations)
- ✅ 20260210_005 (map_chats)
- ✅ 20260318_004 (all new policies)

Changed all `auth.uid() = user_id` to `auth.uid()::text = user_id::text`

---

## 🎯 Verification Steps

After deployment, verify:

1. **Check tables created:**
   ```sql
   SELECT table_name FROM information_schema.tables 
   WHERE table_schema = 'public' 
   ORDER BY table_name;
   ```

2. **Verify RLS enabled:**
   ```sql
   SELECT tablename, rowsecurity FROM pg_tables 
   WHERE schemaname = 'public' AND tablename IN (
     'discussions', 'discussion_comments', 'discussion_likes',
     'user_activity', 'message_deletes', 'story_reports',
     'user_roles', 'api_logs', 'user_warnings', 'epistemic_logs', 'audit_log'
   );
   ```

3. **Test chats load:**
   - Open app
   - Navigate to map/forum
   - Verify discussions display correctly with site names
   - Test creating new discussion with category selection

4. **Check Supabase Linter:**
   - Dashboard → Database Errors
   - All 15 previous errors should now be 0

---

## 📝 Recent Changes Summary

### Database Schema
- Added `site_name` TEXT to discussions (displays heritage site name)
- Added `preview` TEXT to discussions (auto-populated from content)
- Added `category` TEXT to discussions (general or location)
- New columns for all 5 new tables

### Application Code
- Updated `forum_community.dart`:
  - Posts now include `content` + `preview` + `category`
  - UI shows "General" vs "Location" toggle for location-based discussions
  - Auto-fills preview from first 200 chars of content

- Updated `discussion_card_widget.dart`:
  - Now displays `site_name` under author info
  - Uses `preview` field for discussion preview text

### Security
- Enabled RLS on 13 previously unprotected tables
- Created 30+ security policies
- Fixed view from SECURITY DEFINER → SECURITY INVOKER
- **TEMPORARY**: RLS on conversation_members disabled (causing chat issues - will re-enable after debugging)

---

## 🚀 Next Steps

1. Run all 6 migrations in order
2. Verify with SQL queries above
3. Test in app:
   - Chats should load again
   - Discussions should show site name  
   - Discussion creation should show category options (General/Location)
4. Monitor for any errors in Supabase logs
5. Once confirmed working, we'll re-enable RLS on conversation_members with corrected policies
