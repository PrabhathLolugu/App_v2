-- Prevent duplicate accounts: ensure at most one public.users row per email.
-- The app already checks registration via the forgot-password Edge Function before
-- signup; this constraint is a safety net so duplicate inserts are rejected by the DB.
-- If you have existing duplicate emails, resolve them before applying this migration.

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint c
    JOIN pg_class t ON t.oid = c.conrelid
    JOIN pg_namespace n ON n.oid = t.relnamespace
    WHERE n.nspname = 'public'
      AND t.relname = 'users'
      AND c.contype = 'u'
      AND pg_get_constraintdef(c.oid) = 'UNIQUE (email)'
  ) THEN
    ALTER TABLE public.users
      ADD CONSTRAINT users_email_unique UNIQUE (email);
  END IF;
END $$;
