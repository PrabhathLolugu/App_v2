-- Drop the delete_auth_user_direct function since it cannot be used
-- (Supabase auth.users is protected by platform and cannot be directly deleted)

DROP FUNCTION IF EXISTS public.delete_auth_user_direct(UUID);
