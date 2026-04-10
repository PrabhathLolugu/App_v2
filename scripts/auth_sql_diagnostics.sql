-- Auth/signup SQL diagnostics

-- 1) Core table existence
select table_schema, table_name
from information_schema.tables
where table_schema = 'public' and table_name in ('users', 'profiles')
order by table_name;

-- 2) Unique constraints on public.users
select c.conname as constraint_name,
       pg_get_constraintdef(c.oid) as definition
from pg_constraint c
join pg_class t on t.oid = c.conrelid
join pg_namespace n on n.oid = t.relnamespace
where n.nspname = 'public'
  and t.relname = 'users'
  and c.contype = 'u'
order by c.conname;

-- 3) Detect duplicate emails in public.users (case-insensitive)
select lower(email) as email_norm, count(*) as cnt
from public.users
group by lower(email)
having count(*) > 1
order by cnt desc, email_norm
limit 50;

-- 4) RLS enabled status
select n.nspname as schema_name,
       c.relname as table_name,
       c.relrowsecurity as rls_enabled,
       c.relforcerowsecurity as rls_forced
from pg_class c
join pg_namespace n on n.oid = c.relnamespace
where n.nspname = 'public'
  and c.relname in ('users', 'profiles')
  and c.relkind = 'r'
order by c.relname;

-- 5) Policies for users/profiles
select schemaname,
       tablename,
       policyname,
       cmd,
       roles,
       qual,
       with_check
from pg_policies
where schemaname = 'public'
  and tablename in ('users', 'profiles')
order by tablename, policyname;

-- 6) Recent auth users: did Supabase mark them as confirmed already?
select id,
       email,
       created_at,
       email_confirmed_at,
       last_sign_in_at,
       case
         when email_confirmed_at is null then 'pending_verification'
         else 'confirmed'
       end as verification_state
from auth.users
order by created_at desc
limit 50;

-- 7) Recent users confirmed immediately at/near creation (potential auto-confirm signal)
select id,
       email,
       created_at,
       email_confirmed_at,
       extract(epoch from (email_confirmed_at - created_at)) as seconds_to_confirm
from auth.users
where email_confirmed_at is not null
  and created_at > now() - interval '30 days'
order by created_at desc
limit 50;

-- 8) Non-internal triggers on auth.users (should typically be empty)
select t.tgname as trigger_name,
       n.nspname as table_schema,
       c.relname as table_name,
       p.proname as function_name,
       pg_get_triggerdef(t.oid) as trigger_definition
from pg_trigger t
join pg_class c on c.oid = t.tgrelid
join pg_namespace n on n.oid = c.relnamespace
join pg_proc p on p.oid = t.tgfoid
where n.nspname = 'auth'
  and c.relname = 'users'
  and not t.tgisinternal
order by t.tgname;

-- 9) Functions that reference email_confirmed_at / confirmed_at across schemas
select n.nspname as schema_name,
       p.proname as function_name,
       pg_get_function_identity_arguments(p.oid) as args
from pg_proc p
join pg_namespace n on n.oid = p.pronamespace
where pg_get_functiondef(p.oid) ilike '%email_confirmed_at%'
   or pg_get_functiondef(p.oid) ilike '%confirmed_at%'
order by n.nspname, p.proname;

-- 10) Cross-check latest app users vs auth users state
select au.id,
       au.email,
       au.created_at as auth_created_at,
       au.email_confirmed_at,
       pu.id is not null as exists_in_public_users,
       pu.created_at as public_users_created_at
from auth.users au
left join public.users pu on pu.id = au.id
order by au.created_at desc
limit 50;

