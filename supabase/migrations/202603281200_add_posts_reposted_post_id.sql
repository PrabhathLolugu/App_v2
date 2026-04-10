-- Add self-reference to support reposted feed items.
ALTER TABLE public.posts
ADD COLUMN IF NOT EXISTS reposted_post_id UUID REFERENCES public.posts(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_posts_reposted_post_id
  ON public.posts (reposted_post_id);

ALTER TABLE public.posts
  DROP CONSTRAINT IF EXISTS posts_reposted_post_id_not_self;

ALTER TABLE public.posts
  ADD CONSTRAINT posts_reposted_post_id_not_self
  CHECK (reposted_post_id IS NULL OR reposted_post_id <> id);
