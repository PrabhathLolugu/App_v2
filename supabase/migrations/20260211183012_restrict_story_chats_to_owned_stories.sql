-- Restrict story discussions to stories owned by the authenticated user.
-- This is implemented as RESTRICTIVE policies so existing ownership policies
-- on story_chats still apply and are combined with these checks.

DROP POLICY IF EXISTS story_chats_select_only_owned_stories ON public.story_chats;
DROP POLICY IF EXISTS story_chats_insert_only_owned_stories ON public.story_chats;
DROP POLICY IF EXISTS story_chats_update_only_owned_stories ON public.story_chats;

CREATE POLICY story_chats_select_only_owned_stories
ON public.story_chats
AS RESTRICTIVE
FOR SELECT
TO authenticated
USING (
  auth.uid() = user_id
  AND (
    story_id IS NULL
    OR EXISTS (
      SELECT 1
      FROM public.stories AS s
      WHERE s.id = story_chats.story_id
        AND (s.user_id = auth.uid() OR s.author_id = auth.uid())
    )
  )
);

CREATE POLICY story_chats_insert_only_owned_stories
ON public.story_chats
AS RESTRICTIVE
FOR INSERT
TO authenticated
WITH CHECK (
  auth.uid() = user_id
  AND (
    story_id IS NULL
    OR EXISTS (
      SELECT 1
      FROM public.stories AS s
      WHERE s.id = story_chats.story_id
        AND (s.user_id = auth.uid() OR s.author_id = auth.uid())
    )
  )
);

CREATE POLICY story_chats_update_only_owned_stories
ON public.story_chats
AS RESTRICTIVE
FOR UPDATE
TO authenticated
USING (
  auth.uid() = user_id
  AND (
    story_id IS NULL
    OR EXISTS (
      SELECT 1
      FROM public.stories AS s
      WHERE s.id = story_chats.story_id
        AND (s.user_id = auth.uid() OR s.author_id = auth.uid())
    )
  )
)
WITH CHECK (
  auth.uid() = user_id
  AND (
    story_id IS NULL
    OR EXISTS (
      SELECT 1
      FROM public.stories AS s
      WHERE s.id = story_chats.story_id
        AND (s.user_id = auth.uid() OR s.author_id = auth.uid())
    )
  )
);;
