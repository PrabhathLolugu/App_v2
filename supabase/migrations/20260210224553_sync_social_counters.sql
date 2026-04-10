-- Step 1: Fix mistyped comments (commentable_type='story' but actually referencing posts)
UPDATE comments
SET commentable_type = 'post'
WHERE commentable_type = 'story'
  AND commentable_id IN (
    SELECT c.commentable_id
    FROM comments c
    WHERE c.commentable_type = 'story'
      AND EXISTS (SELECT 1 FROM posts p WHERE p.id = c.commentable_id)
      AND NOT EXISTS (SELECT 1 FROM stories s WHERE s.id = c.commentable_id)
  );

-- Step 2: Clean up orphan likes (referencing non-existent content)
DELETE FROM likes
WHERE likeable_type IN ('post', 'story')
  AND NOT EXISTS (SELECT 1 FROM posts p WHERE p.id = likes.likeable_id AND likes.likeable_type = 'post')
  AND NOT EXISTS (SELECT 1 FROM stories s WHERE s.id = likes.likeable_id AND likes.likeable_type = 'story')
  AND likeable_type != 'comment';

-- Step 2b: Clean up orphan comments (referencing non-existent content)
DELETE FROM comments
WHERE commentable_type IN ('post', 'story')
  AND NOT EXISTS (SELECT 1 FROM posts p WHERE p.id = comments.commentable_id AND comments.commentable_type = 'post')
  AND NOT EXISTS (SELECT 1 FROM stories s WHERE s.id = comments.commentable_id AND comments.commentable_type = 'story');

-- Step 3: Sync all denormalized counters from actual data

-- Sync post like_count
UPDATE posts SET like_count = (
  SELECT count(*) FROM likes
  WHERE likeable_type = 'post' AND likeable_id = posts.id
);

-- Sync post comment_count
UPDATE posts SET comment_count = (
  SELECT count(*) FROM comments
  WHERE commentable_type = 'post' AND commentable_id = posts.id
    AND parent_comment_id IS NULL
);

-- Sync post share_count
UPDATE posts SET share_count = (
  SELECT count(*) FROM shares
  WHERE shareable_type = 'post' AND shareable_id = posts.id
);

-- Sync story likes
UPDATE stories SET likes = (
  SELECT count(*) FROM likes
  WHERE likeable_type = 'story' AND likeable_id = stories.id
);

-- Sync story comment_count
UPDATE stories SET comment_count = (
  SELECT count(*) FROM comments
  WHERE commentable_type = 'story' AND commentable_id = stories.id
    AND parent_comment_id IS NULL
);

-- Sync story share_count
UPDATE stories SET share_count = (
  SELECT count(*) FROM shares
  WHERE shareable_type = 'story' AND shareable_id = stories.id
);

-- Sync comment reply_count
UPDATE comments SET reply_count = (
  SELECT count(*) FROM comments AS c2
  WHERE c2.parent_comment_id = comments.id
);;
