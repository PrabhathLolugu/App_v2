-- Speed up hashtag filter: metadata @> {"tags":["tag"]}
CREATE INDEX IF NOT EXISTS idx_posts_metadata_tags_gin
  ON public.posts USING GIN ((metadata->'tags'));
