-- Social feed comments: for projects that do NOT yet have public.comments.
-- If you already have public.comments in Supabase, run 20260216_002_comments_rls_only.sql instead.

CREATE TABLE IF NOT EXISTS public.comments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    author_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    commentable_type TEXT NOT NULL,
    commentable_id UUID NOT NULL,
    content TEXT NOT NULL CHECK (char_length(trim(content)) > 0),
    parent_comment_id UUID REFERENCES public.comments(id) ON DELETE CASCADE,
    depth INT NOT NULL DEFAULT 0 CHECK (depth >= 0 AND depth <= 3),
    root_comment_id UUID REFERENCES public.comments(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    reply_count INT NOT NULL DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_comments_commentable
    ON public.comments(commentable_type, commentable_id);
CREATE INDEX IF NOT EXISTS idx_comments_parent
    ON public.comments(parent_comment_id);
CREATE INDEX IF NOT EXISTS idx_comments_root
    ON public.comments(root_comment_id);
CREATE INDEX IF NOT EXISTS idx_comments_created_at
    ON public.comments(created_at DESC);

CREATE OR REPLACE FUNCTION public.comments_update_reply_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' AND NEW.parent_comment_id IS NOT NULL THEN
        UPDATE public.comments
        SET reply_count = reply_count + 1
        WHERE id = NEW.parent_comment_id;
    ELSIF TG_OP = 'DELETE' AND OLD.parent_comment_id IS NOT NULL THEN
        UPDATE public.comments
        SET reply_count = GREATEST(0, reply_count - 1)
        WHERE id = OLD.parent_comment_id;
    END IF;
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS comments_reply_count_trigger ON public.comments;
CREATE TRIGGER comments_reply_count_trigger
    AFTER INSERT OR DELETE ON public.comments
    FOR EACH ROW
    EXECUTE FUNCTION public.comments_update_reply_count();

ALTER TABLE public.comments ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Comments are viewable by authenticated" ON public.comments;
CREATE POLICY "Comments are viewable by authenticated"
    ON public.comments FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "Users can insert own comments" ON public.comments;
CREATE POLICY "Users can insert own comments"
    ON public.comments FOR INSERT TO authenticated
    WITH CHECK (auth.uid() = author_id);

DROP POLICY IF EXISTS "Users can update own comments" ON public.comments;
CREATE POLICY "Users can update own comments"
    ON public.comments FOR UPDATE TO authenticated
    USING (auth.uid() = author_id) WITH CHECK (auth.uid() = author_id);

DROP POLICY IF EXISTS "Users can delete own comments" ON public.comments;
CREATE POLICY "Users can delete own comments"
    ON public.comments FOR DELETE TO authenticated
    USING (auth.uid() = author_id);
