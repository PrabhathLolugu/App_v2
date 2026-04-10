# Supabase Table Migration Audit

**Audit Date:** March 18, 2026  
**Scope:** supabase/migrations/ and supabase/migrations_legacy_conflicts/  
**Target Tables:** 13 specific tables

---

## Executive Summary

**Status:** ⚠️ **CRITICAL FINDING** - All 13 tables exist in the database but **NONE have CREATE TABLE statements in migration files**.

- ✅ **13/13 tables exist** (confirmed via Supabase_errors.json security linter report)
- ❌ **0/13 have CREATE TABLE statements** in migrations/migrations_legacy_conflicts
- ✅ All 13 have RLS policies defined (in 20260318_004_fix_supabase_security_advisories.sql)
- ✅ Some have ALTER TABLE statements modifying structure
- ⚠️ Table definitions are likely managed directly in Supabase cloud (not version-controlled)

---

## Detailed Table Analysis

### 1. ✅ CONVERSATION_MEMBERS
**Status:** EXISTS - Missing CREATE TABLE statement  
**Last Modified In:** Multiple migrations

**Confirmed via:**
- [20260318_004_fix_supabase_security_advisories.sql](20260318_004_fix_supabase_security_advisories.sql#L26) - Line 26: `ALTER TABLE public.conversation_members ENABLE ROW LEVEL SECURITY;`
- [add_deleted_at_to_conversation_members.sql](add_deleted_at_to_conversation_members.sql) - ALTER TABLE adding `deleted_at` column
- [Supabase_errors.json](Supabase_errors.json) - Security linter confirming table exists

**Known Columns/Structure:**
- FK: `conversation_id` (references conversations)
- FK: `participant_id` (identified in trigger query, line 100 of 20260318_003_create_chat_message_notification_triggers.sql)
- Column: `user_id` (from add_deleted_at_to_conversation_members.sql index)
- Column: `deleted_at` (TIMESTAMP WITH TIME ZONE, soft delete support)

**Indexes:**
- `idx_conversation_members_deleted_at` - ON (user_id, deleted_at)

**RLS Policies (6 total):**
- "Admins can add members to group"
- "Admins can remove members"
- "Admins can update member roles"
- "Users can leave group"
- "cm_insert_self"
- "cm_select_via_conversations"

**No CREATE TABLE statement found** ❌

---

### 2. ✅ DISCUSSIONS
**Status:** EXISTS - Missing CREATE TABLE statement  
**Last Modified In:** Multiple migrations

**Confirmed via:**
- [20260318_004_fix_supabase_security_advisories.sql](20260318_004_fix_supabase_security_advisories.sql#L310) - Line 310: `ALTER TABLE public.discussions ENABLE ROW LEVEL SECURITY;`
- [202603170002_allow_null_site_id_for_general_discussions.sql](202603170002_allow_null_site_id_for_general_discussions.sql) - ALTER TABLE constraint modification
- [20260210_004_fix_delete_account_fk_constraints.sql](20260210_004_fix_delete_account_fk_constraints.sql#L5-L8) - ALTER TABLE FK constraint

**Known Columns/Structure:**
- Column: `author_id` (UUID, FK to public.users, ON DELETE CASCADE)
- Column: `site_id` (can be NULL for general discussions)
- Implied: `id`, `title`, `content`, `created_at`, `updated_at`

**Foreign Keys:**
- `author_id` → public.users (ON DELETE CASCADE)
- `site_id` → public.sites (implied, nullable)

**RLS Policies (5 total):**
- "Authenticated users can view discussions"
- "Users can create discussions"
- "Service role can manage discussions"
- "Users can update own discussions"
- "Users can delete own discussions"

**No CREATE TABLE statement found** ❌

---

### 3. ✅ DISCUSSION_COMMENTS
**Status:** EXISTS - Missing CREATE TABLE statement  
**Last Modified In:** Multiple migrations

**Confirmed via:**
- [20260318_004_fix_supabase_security_advisories.sql](20260318_004_fix_supabase_security_advisories.sql#L281) - Line 281: `ALTER TABLE public.discussion_comments ENABLE ROW LEVEL SECURITY;`
- [20260210_004_fix_delete_account_fk_constraints.sql](20260210_004_fix_delete_account_fk_constraints.sql#L11-L14) - ALTER TABLE FK constraint

**Known Columns/Structure:**
- Column: `user_id` (UUID, FK to public.users, ON DELETE CASCADE)
- Column: `author_id` (referenced in notification trigger, 20260318_001_reenable_comment_notification_trigger.sql)
- Implied: `id`, `discussion_id`, `content`, `parent_comment_id`, `created_at`, `updated_at`

**Foreign Keys:**
- `user_id` → public.users (ON DELETE CASCADE)
- `discussion_id` → public.discussions (implied)

**RLS Policies (5 total):**
- "Authenticated users can view discussion comments"
- "Users can create discussion comments"
- "Service role can manage discussion comments"
- "Users can update own comments"
- "Users can delete own comments"

**No CREATE TABLE statement found** ❌

---

### 4. ✅ MAP_COMMENTS
**Status:** EXISTS - Missing CREATE TABLE statement  
**Last Modified In:** Multiple migrations

**Confirmed via:**
- [20260318_004_fix_supabase_security_advisories.sql](20260318_004_fix_supabase_security_advisories.sql#L229) - Line 229: `ALTER TABLE public.map_comments ENABLE ROW LEVEL SECURITY;`
- [20260210_004_fix_delete_account_fk_constraints.sql](20260210_004_fix_delete_account_fk_constraints.sql#L17-L20) - ALTER TABLE FK constraint
- [Supabase_errors.json](Supabase_errors.json) - Security linter report

**Known Columns/Structure:**
- Column: `user_id` (UUID, FK to public.users, ON DELETE CASCADE)
- Column: `site_id` (implied, FK)
- Column: `content`
- Implied: `id`, `created_at`, `updated_at`

**Foreign Keys:**
- `user_id` → public.users (ON DELETE CASCADE)
- `site_id` → public.sites (implied)

**Related Objects:**
- View: `map_comments_with_profiles` (SECURITY_INVOKER) - Joins with profiles table
- Columns in view: id, site_id, user_id, content, created_at, updated_at, full_name, avatar_url, username

**RLS Policies (5 total):**
- "Authenticated users can view map comments"
- "Users can create map comments"
- "Service role can manage map comments"
- "Users can update own map comments"
- "Users can delete own map comments"

**No CREATE TABLE statement found** ❌

---

### 5. ✅ DISCUSSION_LIKES
**Status:** EXISTS - Missing CREATE TABLE statement  
**Last Modified In:** 20260318_004_fix_supabase_security_advisories.sql only

**Confirmed via:**
- [20260318_004_fix_supabase_security_advisories.sql](20260318_004_fix_supabase_security_advisories.sql#L201) - Line 201: `ALTER TABLE public.discussion_likes ENABLE ROW LEVEL SECURITY;`
- [Supabase_errors.json](Supabase_errors.json) - Security linter report

**Known Columns/Structure:**
- Column: `user_id` (UUID, FK to public.users)
- Implied: `id`, `discussion_id`, `created_at`

**RLS Policies (5 total):**
- "Authenticated users can view likes"
- "Service role can view all likes"
- "Users can create own likes"
- "Service role can manage likes"
- "Users can delete own likes"

**No CREATE TABLE statement found** ❌

---

### 6. ✅ USER_ROLES
**Status:** EXISTS - Missing CREATE TABLE statement  
**Last Modified In:** 20260318_004_fix_supabase_security_advisories.sql only

**Confirmed via:**
- [20260318_004_fix_supabase_security_advisories.sql](20260318_004_fix_supabase_security_advisories.sql#L57) - Line 57: `ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;`
- [Supabase_errors.json](Supabase_errors.json) - Security linter report

**Purpose:** User role assignments

**Known Columns/Structure:**
- Implied: `id`, `user_id`, `role`, `created_at`

**RLS Policies (4 total):**
- "Service role and admins can read user_roles"
- "Service role can write user_roles"
- "Service role can update user_roles"
- "Service role can delete user_roles"

**Access Control:** Service role + admin only

**No CREATE TABLE statement found** ❌

---

### 7. ✅ API_LOGS
**Status:** EXISTS - Missing CREATE TABLE statement  
**Last Modified In:** 20260318_004_fix_supabase_security_advisories.sql only

**Confirmed via:**
- [20260318_004_fix_supabase_security_advisories.sql](20260318_004_fix_supabase_security_advisories.sql#L84) - Line 84: `ALTER TABLE public.api_logs ENABLE ROW LEVEL SECURITY;`
- [Supabase_errors.json](Supabase_errors.json) - Security linter report

**Purpose:** API call logging

**Known Columns/Structure:**
- Implied: `id`, `endpoint`, `method`, `status_code`, `user_id`, `timestamp`, `request_body`, `response_body`

**RLS Policies (2 total):**
- "Service role and admins can read api_logs"
- "Service role can write api_logs"

**Access Control:** Service role + admin only

**No CREATE TABLE statement found** ❌

---

### 8. ✅ USER_WARNINGS
**Status:** EXISTS - Missing CREATE TABLE statement  
**Last Modified In:** 20260318_004_fix_supabase_security_advisories.sql only

**Confirmed via:**
- [20260318_004_fix_supabase_security_advisories.sql](20260318_004_fix_supabase_security_advisories.sql#L100) - Line 100: `ALTER TABLE public.user_warnings ENABLE ROW LEVEL SECURITY;`
- [Supabase_errors.json](Supabase_errors.json) - Security linter report

**Purpose:** User violation warnings

**Known Columns/Structure:**
- Implied: `id`, `user_id`, `warning_type`, `reason`, `severity`, `created_at`, `admin_id`

**RLS Policies (3 total):**
- "Service role and admins can read user_warnings"
- "Service role can write user_warnings"
- "Service role can update user_warnings"

**Access Control:** Service role + admin only

**No CREATE TABLE statement found** ❌

---

### 9. ✅ EPISTEMIC_LOGS
**Status:** EXISTS - Missing CREATE TABLE statement  
**Last Modified In:** 20260318_004_fix_supabase_security_advisories.sql only

**Confirmed via:**
- [20260318_004_fix_supabase_security_advisories.sql](20260318_004_fix_supabase_security_advisories.sql#L122) - Line 122: `ALTER TABLE public.epistemic_logs ENABLE ROW LEVEL SECURITY;`
- [Supabase_errors.json](Supabase_errors.json) - Security linter report

**Purpose:** Epistemic tracking (confidence/trust metrics)

**Known Columns/Structure:**
- Implied: `id`, `entity_id`, `entity_type`, `epistemic_status`, `timestamp`, `notes`

**RLS Policies (2 total):**
- "Service role and admins can read epistemic_logs"
- "Service role can write epistemic_logs"

**Access Control:** Service role + admin only

**No CREATE TABLE statement found** ❌

---

### 10. ✅ AUDIT_LOG
**Status:** EXISTS - Missing CREATE TABLE statement  
**Last Modified In:** 20260318_004_fix_supabase_security_advisories.sql only

**Confirmed via:**
- [20260318_004_fix_supabase_security_advisories.sql](20260318_004_fix_supabase_security_advisories.sql#L138) - Line 138: `ALTER TABLE public.audit_log ENABLE ROW LEVEL SECURITY;`
- [Supabase_errors.json](Supabase_errors.json) - Security linter report

**Purpose:** Audit trail for security and compliance

**Known Columns/Structure:**
- Implied: `id`, `action`, `user_id`, `resource_type`, `resource_id`, `changes`, `timestamp`

**RLS Policies (2 total):**
- "Service role and admins can read audit_log"
- "Service role can write audit_log"

**Access Control:** Service role + admin only

**No CREATE TABLE statement found** ❌

---

### 11. ✅ USER_ACTIVITY
**Status:** EXISTS - Missing CREATE TABLE statement  
**Last Modified In:** 20260318_004_fix_supabase_security_advisories.sql only

**Confirmed via:**
- [20260318_004_fix_supabase_security_advisories.sql](20260318_004_fix_supabase_security_advisories.sql#L159) - Line 159: `ALTER TABLE public.user_activity ENABLE ROW LEVEL SECURITY;`
- [Supabase_errors.json](Supabase_errors.json) - Security linter report

**Purpose:** User activity tracking

**Known Columns/Structure:**
- Column: `user_id` (UUID, FK to public.users)
- Implied: `id`, `activity_type`, `resource_id`, `timestamp`, `metadata`

**RLS Policies (3 total):**
- "Users can view own activity"
- "Service role can view all activity"
- "Service role can record activity"

**Access Control:** User-specific + service role

**No CREATE TABLE statement found** ❌

---

### 12. ✅ MESSAGE_DELETES
**Status:** EXISTS - Missing CREATE TABLE statement  
**Last Modified In:** 20260318_004_fix_supabase_security_advisories.sql only

**Confirmed via:**
- [20260318_004_fix_supabase_security_advisories.sql](20260318_004_fix_supabase_security_advisories.sql#L177) - Line 177: `ALTER TABLE public.message_deletes ENABLE ROW LEVEL SECURITY;`
- [Supabase_errors.json](Supabase_errors.json) - Security linter report

**Purpose:** Track deleted messages

**Known Columns/Structure:**
- Column: `user_id` (UUID, FK to public.users)
- Implied: `id`, `message_id`, `conversation_id`, `deleted_at`

**RLS Policies (4 total):**
- "Users can view own message deletes"
- "Service role can view all message deletes"
- "Users can delete own messages"
- (implied INSERT permission)

**Access Control:** User-specific + service role

**No CREATE TABLE statement found** ❌

---

### 13. ✅ STORY_REPORTS
**Status:** EXISTS - Missing CREATE TABLE statement  
**Last Modified In:** 20260318_004_fix_supabase_security_advisories.sql only

**Confirmed via:**
- [20260318_004_fix_supabase_security_advisories.sql](20260318_004_fix_supabase_security_advisories.sql#L258) - Line 258: `ALTER TABLE public.story_reports ENABLE ROW LEVEL SECURITY;`
- [Supabase_errors.json](Supabase_errors.json) - Security linter report

**Purpose:** Report generated stories

**Known Columns/Structure:**
- Column: `user_id` (UUID, FK to public.users)
- Implied: `id`, `story_id`, `report_reason`, `created_at`

**RLS Policies (4 total):**
- "Authenticated users can view story reports"
- "Users can create story reports"
- "Service role can manage story reports"
- "Users can delete own story reports"

**Access Control:** Authenticated users + service role

**No CREATE TABLE statement found** ❌

---

## Summary Table

| # | Table Name | EXISTS | CREATE TABLE | ALTER TABLE | RLS Enabled | Foreign Keys | Status |
|---|---|---|---|---|---|---|---|
| 1 | conversation_members | ✅ | ❌ MISSING | ✅ Yes | ✅ Yes | ✅ Yes | ⚠️ Partial |
| 2 | discussions | ✅ | ❌ MISSING | ✅ Yes | ✅ Yes | ✅ Yes | ⚠️ Partial |
| 3 | discussion_comments | ✅ | ❌ MISSING | ✅ Yes | ✅ Yes | ✅ Yes | ⚠️ Partial |
| 4 | map_comments | ✅ | ❌ MISSING | ✅ Yes | ✅ Yes | ✅ Yes | ⚠️ Partial |
| 5 | discussion_likes | ✅ | ❌ MISSING | ✅ Yes | ✅ Yes | ❓ Unknown | ⚠️ Minimal |
| 6 | user_roles | ✅ | ❌ MISSING | ✅ Yes | ✅ Yes | ❓ Unknown | ⚠️ Minimal |
| 7 | api_logs | ✅ | ❌ MISSING | ✅ Yes | ✅ Yes | ❓ Unknown | ⚠️ Minimal |
| 8 | user_warnings | ✅ | ❌ MISSING | ✅ Yes | ✅ Yes | ❓ Unknown | ⚠️ Minimal |
| 9 | epistemic_logs | ✅ | ❌ MISSING | ✅ Yes | ✅ Yes | ❓ Unknown | ⚠️ Minimal |
| 10 | audit_log | ✅ | ❌ MISSING | ✅ Yes | ✅ Yes | ❓ Unknown | ⚠️ Minimal |
| 11 | user_activity | ✅ | ❌ MISSING | ✅ Yes | ✅ Yes | ❓ Unknown | ⚠️ Minimal |
| 12 | message_deletes | ✅ | ❌ MISSING | ✅ Yes | ✅ Yes | ❓ Unknown | ⚠️ Minimal |
| 13 | story_reports | ✅ | ❌ MISSING | ✅ Yes | ✅ Yes | ❓ Unknown | ⚠️ Minimal |

**Overall Status:** ❌ **CRITICAL** - 0% CREATE TABLE coverage

---

## Key Migration Files Referenced

| File | Purpose | Tables Modified |
|---|---|---|
| [20260318_004_fix_supabase_security_advisories.sql](20260318_004_fix_supabase_security_advisories.sql) | Enable RLS + create security policies | ALL 13 tables |
| [20260210_004_fix_delete_account_fk_constraints.sql](20260210_004_fix_delete_account_fk_constraints.sql) | Fix FK cascades on user deletion | discussions, discussion_comments, map_comments |
| [202603170002_allow_null_site_id_for_general_discussions.sql](202603170002_allow_null_site_id_for_general_discussions.sql) | Allow general discussions without site_id | discussions |
| [add_deleted_at_to_conversation_members.sql](add_deleted_at_to_conversation_members.sql) | Add soft-delete support | conversation_members |
| [20260318_003_create_chat_message_notification_triggers.sql](20260318_003_create_chat_message_notification_triggers.sql) | Chat notification triggers | conversation_members (references) |

---

## Missing Information

### CREATE TABLE Statements Required For:
❌ conversation_members  
❌ discussions  
❌ discussion_comments  
❌ map_comments  
❌ discussion_likes  
❌ user_roles  
❌ api_logs  
❌ user_warnings  
❌ epistemic_logs  
❌ audit_log  
❌ user_activity  
❌ message_deletes  
❌ story_reports  

### Likely Causes:
1. **Tables created directly in Supabase cloud UI** (not through migrations)
2. **Initial database dump not version-controlled** (common for bootstrapped projects)
3. **Deleted migration files** (may have been removed during refactoring)
4. **Replicated from external database** (manual import process)

---

## Recommendations

### 🔴 PRIORITY: HIGH

1. **Capture existing table definitions:**
   ```sql
   -- Export current schema from Supabase:
   pg_dump --schema-only -t "conversation_members" -t "discussions" ... > existing_schema.sql
   ```

2. **Create missing migration files:**
   - Create 13 new migration files with CREATE TABLE statements
   - Extract column definitions from Supabase database directly
   - Include all indexes, constraints, and comments

3. **Version control database state:**
   - Add migrations for all table definitions
   - Ensure reproducible deployments

4. **Prevent future issues:**
   - Enforce policy: **All tables must have CREATE TABLE migrations**
   - Add pre-deployment validation

---

## Notes

- All tables confirmed to exist via [Supabase_errors.json](Supabase_errors.json) (generated by Supabase Database Linter)
- All 13 tables now have RLS enabled as of 2026-03-18
- No additional table definition sources found in:
  - supabase/scripts/ 
  - supabase/.temp/
  - Root level SQL files
  - Package.json or build configuration files
