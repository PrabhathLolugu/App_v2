# RLS Policy Logic Guide

## Understanding the Security Model

All Row Level Security (RLS) policies follow these principles:

1. **service_role always wins** - Backend can always read/write for functionality
2. **Users can see their own data** - Privacy for personal information
3. **Community content is public** - Authenticated users can read shared content
4. **Admin override** - Admins can manage violations and warnings
5. **Prevent privilege escalation** - Users cannot modify roles or system logs

---

## Policy Categories Explained

### Category 1: Service-Role Only Tables ⚙️

**Tables:** `user_roles`, `api_logs`, `user_warnings`, `epistemic_logs`, `audit_log`

**Purpose:** System information that should never be directly accessible to users

**Policy Logic:**
```
SELECT: service_role OR (authenticated AND is_admin=true)
INSERT: service_role ONLY
UPDATE: service_role ONLY
DELETE: service_role ONLY
```

**Why?**
- Users shouldn't modify their own roles
- API logs are for backend debugging
- User warnings are for admins to issue
- Epistemic logs track data quality (backend)
- Audit logs must be immutable

**Example: user_roles**
```
SELECT: User can read user_roles IF they're admin
        Service role can always read
INSERT: Only the backend (service_role) can assign roles
UPDATE: Backend can modify assignments
DELETE: Backend can revoke roles
```

---

### Category 2: User-Owned Data 👤

**Tables:** `user_activity`, `message_deletes`

**Purpose:** User-specific records that should only be visible to that user

**Policy Logic:**
```
SELECT: auth.uid() = user_id OR service_role = true
INSERT: service_role ONLY (backend records actions)
UPDATE: service_role ONLY
DELETE: service_role ONLY
```

**Why?**
- Only YOU should see your activity history
- Only YOU should see messages you deleted
- Backend needs to record these automatically
- Users cannot fake activity logs

**Example: user_activity**
```
-- User A queries own activity (ALLOWED ✅)
SELECT * FROM user_activity WHERE user_id = 'user-a-uuid'

-- User A queries User B's activity (DENIED ❌)
SELECT * FROM user_activity WHERE user_id = 'user-b-uuid'

-- Backend records activity (ALLOWED ✅)
INSERT INTO user_activity (user_id, activity_type) VALUES ('user-a-uuid', 'viewed_story')
```

---

### Category 3: Community Content 🤝

**Tables:** `discussions`, `discussion_comments`, `discussion_likes`, `map_comments`, `story_reports`

**Purpose:** Shared public content where authenticated users collaborate

**Policy Logic:**

#### READ (Everyone authenticated can view)
```
SELECT: auth.role() = 'authenticated' OR service_role = true
```

#### WRITE (Users create but cannot edit/delete others)
```
INSERT: auth.uid() = user_id OR service_role = true
UPDATE: auth.uid() = owner_id OR service_role = true OR (is_admin() AND service_role)
DELETE: auth.uid() = owner_id OR service_role = true OR (is_admin() && service_role)
```

**Why?**
- Discussions are meant for community
- Everyone should see all discussions/comments
- Only authors should modify their own posts
- Admins can moderate (delete spam)
- Backend can do admin tasks

**Example: discussions**
```
-- User A views all discussions (ALLOWED ✅)
SELECT * FROM discussions

-- User A creates a discussion (ALLOWED ✅)
INSERT INTO discussions (author_id, content) VALUES ('user-a-uuid', '...')

-- User A edits own discussion (ALLOWED ✅)
UPDATE discussions SET content = '...' WHERE id = discussion-id AND author_id = 'user-a-uuid'

-- User A tries to edit User B's discussion (DENIED ❌)
UPDATE discussions SET content = '...' WHERE id = discussion-id AND author_id = 'user-b-uuid'

-- Admin deletes spam discussion (ALLOWED ✅)
DELETE FROM discussions WHERE id = spam-discussion-id
```

---

### Category 4: Special Cases 🔧

#### conversation_members (Already had policies!)
**What was wrong:** 6 RLS policies existed but `ALTER TABLE ENABLE ROW LEVEL SECURITY` was never run

**Fix:** Simply run `ALTER TABLE conversation_members ENABLE ROW LEVEL SECURITY`

**Existing Policies:**
- Admins can add members to group
- Admins can remove members
- Admins can update member roles
- Users can leave group (update deleted_at)
- cm_insert_self (users can join)
- cm_select_via_conversations (view members)

#### map_comments_with_profiles (View)
**What was wrong:** Created with `SECURITY DEFINER` which is a security anti-pattern

**The Problem:**
```
-- With SECURITY DEFINER, view returns data based on VIEW CREATOR's permissions
-- Not the querying user's permissions!
-- Example: if admin creates view, everyone can see sensitive data via view
```

**Fix:** Recreate as `SECURITY INVOKER` (standard & secure)
```
-- With SECURITY INVOKER, view respects each user's RLS policies
-- Each user only sees data they have permission to see
-- Much more secure ✅
```

---

## Policy Decision Tree

Use this to understand why a specific policy exists:

```
Is this table system/admin only?
├─ YES → service_role + admin read, service_role write only
│        Example: api_logs, audit_log, user_warnings
└─ NO → Is this data per-user?
        ├─ YES → Only that user can read, service_role can write
        │        Example: user_activity, message_deletes
        └─ NO → Is this shared community content?
               ├─ YES → Authenticated users can read, owner/admin can write
               │        Example: discussions, map_comments, story_reports
               └─ NO → Custom policy (check code for business logic)
```

---

## Security Guarantees

After applying these policies:

✅ **Users cannot...**
- See other users' private activity
- Modify discussions they didn't write (unless admin)
- Access system logs or warnings about themselves
- Change their own roles
- View other users' message delete history

✅ **Admins can...**
- Read all logs and audit trails
- Moderate community content (delete spam)
- View user warnings they issued
- Manage user roles

✅ **Service role (backend) can...**
- Always read/write everything (business logic enforcement)
- Record user actions for logging
- Auto-assign roles or issue warnings
- Query full dataset for analytics

✅ **Everyone else...**
- Reads: PUBLIC community content they have permission for
- Writes: Only their own content (discussions, comments)
- Updates: Only their own records

---

## Common Questions

### Q: Can a user bypass RLS by changing their auth.uid()?
**A:** No. `auth.uid()` is controlled by Supabase auth, not modifiable by client.

### Q: What if I need to show someone else's profile?
**A:** Profiles likely have their own RLS allowing public read + owner edit. Use that table.

### Q: Can service_role bypass RLS?
**A:** Yes! That's the point. It's used for backend logic (triggers, functions, API calls).

### Q: What if I need to query across users (like showing activity feed)?
**A:** Create a database VIEW with proper RLS, or use a service_role backend function.

### Q: Why can users delete their own discussions/comments?
**A:** For user autonomy. If you want permanent deletion prevention, add business logic trigger.

---

## Modification Guide

If you need to change policies:

### To make content more public:
```sql
-- Before: Only author can read
CREATE POLICY "Own posts only" ON posts FOR SELECT USING (auth.uid() = user_id);

-- After: Authenticated users can read
CREATE POLICY "Public read" ON posts FOR SELECT USING (auth.role() = 'authenticated');
```

### To make content more private:
```sql
-- Before: Authenticated users can write
CREATE POLICY "Create post" ON posts FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- After: Only approved users can write
CREATE POLICY "Create if verified" ON posts FOR INSERT 
WITH CHECK (EXISTS(SELECT 1 FROM profiles WHERE id = auth.uid() AND verified = true));
```

### To add role-based access:
```sql
CREATE POLICY "Moderators can delete" ON posts FOR DELETE 
USING (
  auth.role() = 'service_role' OR 
  (auth.role() = 'authenticated' AND is_admin())
);
```

---

## Testing Your Policies

```sql
-- Test as specific user
set request.jwt.claims = '{"sub":"<user-id>", "role":"authenticated"}';

-- Can you read?
SELECT COUNT(*) FROM discussions;

-- Can you modify others' content?
UPDATE discussions SET content = '...' WHERE author_id != '<user-id>';
-- Should fail with: "new row violates row-level security policy"

-- Switch to service role
set request.jwt.claims = '{"role":"service_role"}';

-- Now everything works
UPDATE discussions SET content = '...' WHERE author_id != '<user-id>';
-- Should succeed ✅
```

---

## Architecture Principles Used

1. **Principle of Least Privilege** - Each role gets minimum necessary access
2. **Defense in Depth** - Policies stack (service_role check + admin check + user check)
3. **Immutable Audit Trail** - Audit logs cannot be modified, only appended
4. **User Autonomy** - Users control their own data with exceptions
5. **Backend Control** - Service role always has final say for business logic

---

**Remember:** Good security = Good user experience 🔒
