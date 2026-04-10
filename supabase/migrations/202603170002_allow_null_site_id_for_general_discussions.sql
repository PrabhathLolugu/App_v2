-- Allow global/general discussions by permitting NULL site_id.
-- This migration is defensive and only changes schema when needed.

DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'discussions'
      AND column_name = 'site_id'
      AND is_nullable = 'NO'
  ) THEN
    ALTER TABLE public.discussions
      ALTER COLUMN site_id DROP NOT NULL;
  END IF;
END $$;
