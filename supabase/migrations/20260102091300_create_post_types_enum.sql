-- Create enum types for social features
CREATE TYPE post_type AS ENUM ('text', 'image', 'video', 'story_share');
CREATE TYPE likeable_type AS ENUM ('post', 'comment', 'story');
CREATE TYPE share_type AS ENUM ('repost', 'direct_message', 'external');
CREATE TYPE notification_type AS ENUM (
    'like', 'comment', 'reply', 'follow', 'mention',
    'share', 'repost', 'new_post'
);;
