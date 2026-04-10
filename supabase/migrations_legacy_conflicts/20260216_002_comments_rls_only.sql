-- RLS for public.comments when the table already exists (e.g. in Supabase).
-- Run this so authenticated users can read comments and insert/update/delete their own.
-- Safe to run multiple times (policies are dropped then recreated).

ALTER TABLE public.comments ENABLE ROW LEVEL SECURITY;

-- Authenticated users can read all comments.
DROP POLICY IF EXISTS "Comments are viewable by authenticated" ON public.comments;
CREATE POLICY "Comments are viewable by authenticated"
    ON public.comments
    FOR SELECT
    TO authenticated
    USING (true);

-- Users can insert comments as themselves.
DROP POLICY IF EXISTS "Users can insert own comments" ON public.comments;
CREATE POLICY "Users can insert own comments"
    ON public.comments
    FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() = author_id);

-- Users can update only their own comments.
DROP POLICY IF EXISTS "Users can update own comments" ON public.comments;
CREATE POLICY "Users can update own comments"
    ON public.comments
    FOR UPDATE
    TO authenticated
    USING (auth.uid() = author_id)
    WITH CHECK (auth.uid() = author_id);

-- Users can delete only their own comments.
DROP POLICY IF EXISTS "Users can delete own comments" ON public.comments;
CREATE POLICY "Users can delete own comments"
    ON public.comments
    FOR DELETE
    TO authenticated
    USING (auth.uid() = author_id);
