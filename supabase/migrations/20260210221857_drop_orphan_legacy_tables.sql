-- Drop orphan/legacy tables that have been replaced by polymorphic tables
-- (likes, comments, shares, bookmarks) and new chat tables
-- (conversations, chat_messages, conversation_members).
-- All tables have 0 rows and are not referenced anywhere in the codebase.

-- Drop tables with FK dependencies first (children before parents)
DROP TABLE IF EXISTS message_attachments CASCADE;
DROP TABLE IF EXISTS typing_status CASCADE;
DROP TABLE IF EXISTS story_comment_likes CASCADE;

-- Drop remaining orphan tables
DROP TABLE IF EXISTS messages CASCADE;
DROP TABLE IF EXISTS connections CASCADE;
DROP TABLE IF EXISTS blocked_users CASCADE;
DROP TABLE IF EXISTS chat_users CASCADE;
DROP TABLE IF EXISTS notification_settings CASCADE;
DROP TABLE IF EXISTS user_follows CASCADE;
DROP TABLE IF EXISTS user_reports CASCADE;
DROP TABLE IF EXISTS story_likes CASCADE;
DROP TABLE IF EXISTS story_comments CASCADE;
DROP TABLE IF EXISTS story_shares CASCADE;
DROP TABLE IF EXISTS story_favorites CASCADE;
DROP TABLE IF EXISTS community_stories CASCADE;

-- Drop orphan functions that only referenced the dropped tables
DROP FUNCTION IF EXISTS check_blocked_before_message() CASCADE;
DROP FUNCTION IF EXISTS get_connection_stats(uuid) CASCADE;;
