# Supabase Migration Guide (India Block)

Supabase is DNS-blocked at the ISP level in India (`*.supabase.co`). This guide gives you **options from quickest fix to full migration**, plus an inventory of what you have so you can migrate systematically.

---

## Option 1: Quick Fix — Cloudflare Worker Proxy (No Migration)

**Best if:** You want Indian users to work again with **zero backend migration** and minimal code change.

### How it works
- Indian ISPs block `*.supabase.co`. Cloudflare Workers run on `*.workers.dev`, which is **not** blocked.
- You put a small Worker that forwards every request (REST, Auth, Realtime/WebSockets, Storage) to your real Supabase URL.
- Your app keeps using Supabase; only the **base URL** changes (from Supabase URL to Worker URL).

### What you change
1. **Create a Cloudflare Worker** (free tier: 100k requests/day).
2. **In your app:** point `SUPABASE_URL` to the Worker URL instead of `https://<project-ref>.supabase.co`.

### Steps

**1. Create the Worker**

- Cloudflare Dashboard → Workers & Pages → Create Worker → name it e.g. `supabase-proxy`.
- Replace the default code with (use your real project ref):

```javascript
const SUPABASE_ORIGIN = 'https://YOUR_PROJECT_REF.supabase.co';

export default {
  async fetch(request) {
    const url = new URL(request.url);
    const targetUrl = SUPABASE_ORIGIN + url.pathname + url.search;

    const headers = new Headers(request.headers);
    headers.set('Host', new URL(SUPABASE_ORIGIN).host);

    if (request.headers.get('Upgrade') === 'websocket') {
      return fetch(targetUrl, { headers, method: request.method });
    }

    return fetch(targetUrl, {
      method: request.method,
      headers,
      body: ['GET', 'HEAD'].includes(request.method) ? undefined : request.body,
      redirect: 'follow',
    });
  },
};
```

- Deploy and copy the Worker URL: `https://supabase-proxy.<your-subdomain>.workers.dev`

**2. Update your app**

- In your project root, open **`.env`** (copy from `.env.example` if needed). Change only the URL:

```env
# Before (direct Supabase — blocked in India)
SUPABASE_URL=https://YOUR_PROJECT_REF.supabase.co

# After (proxy — use your Worker subdomain)
SUPABASE_URL=https://supabase-proxy.myitihas.workers.dev
```

- **No trailing slash.** Keep `SUPABASE_ANON_KEY` and all other variables unchanged.
- The app uses `Env.supabaseUrl` in `main.dart` for both `SupabaseService.initialize()` and `MyItihasRepository.configure()`, so this one change routes all Supabase traffic via the proxy.
- Run **`dart run build_runner build --delete-conflicting-outputs`** (Envied reads `.env` at build time), then rebuild and run the app. All Supabase calls (auth, database, storage, realtime) will go via the Worker and work in India.

**Pros:** No data migration, no new backend; ~30 minutes.  
**Cons:** Extra hop (slight latency); dependency on Cloudflare; block is a workaround, not a policy fix.

---

## Option 2: Self-Host Supabase (Same Stack, Full Control)

**Best if:** You want to stay on Supabase (Postgres, GoTrue, Storage, Edge Functions) and host in India or any VPS.

### What you get
- Same APIs → **minimal app code changes** (only URL/keys).
- Full control over data location (e.g. India).
- Use your existing migrations, RLS, and Edge Functions (Deploy with Deno/Node on same or another server).

### Inventory you need to migrate

**Database**
- Run all migrations in `supabase/migrations/` on the new Postgres (order by filename).
- Export data from current project (Supabase Dashboard → Database → backup, or `pg_dump`), then restore into self-hosted Postgres.

**Storage buckets** (create same names and RLS-style policies on self-hosted Storage):
- `profile-avatars`
- `post-media`
- `story-images`
- `group_avatar`

**Edge Functions** (in `supabase/functions/`):
- `generate-travel-plan`
- `translation`
- `generate-story`
- `generate-image`
- `interact-with-story`
- `chat-service`
- `delete-user-account`
- `send-push-notification`
- `migrate-base64-images` (one-off, optional)
- `generate-custom-site-details`

**Shared code:** `_shared/` (cors, supabase client, types, openrouter, prompts) is bundled when you deploy each function.

### High-level steps
1. **VPS:** e.g. AWS (Mumbai), DigitalOcean, or any India-friendly provider; minimum ~4GB RAM, 2 CPU, 50GB disk (see [Supabase self-hosting](https://supabase.com/docs/guides/self-hosting)).
2. **Deploy Supabase:** Use [Supabase Docker self-hosting](https://supabase.com/docs/guides/self-hosting/docker); configure `.env` (Postgres, JWT secret, API URL, etc.).
3. **Database:** Apply all migrations, then restore a dump from current Supabase DB.
4. **Storage:** Recreate buckets and policies; copy objects (e.g. with `rclone` or a small script using Supabase Storage API).
5. **Edge Functions:** Deploy to your own Deno/Node runtime (or use Supabase’s self-hosted “Functions” if you follow their self-host docs). Set same env (e.g. `OPENROUTER_API_KEY`, `FIREBASE_*`).
6. **App:** Set `SUPABASE_URL` and `SUPABASE_ANON_KEY` to the new self-hosted instance.

**Pros:** No Supabase-in-India block; same stack and APIs.  
**Cons:** You maintain server, backups, and scaling.

---

## Option 3: Move to Another BaaS (Full Migration)

Use this if you prefer a managed service that is not blocked in India and are okay with more migration work.

### A. Nuvix (India-focused)

- **Site:** [nuvix.in](https://www.nuvix.in/)
- **Offers:** Postgres-like DB, Auth, file storage, APIs.
- **Good for:** India-first, compliant hosting.
- **Migration:** Manual: recreate schema (from your migrations), move data (export/import or ETL), reimplement auth and storage in app against Nuvix SDK/APIs. No automatic “Supabase → Nuvix” tool.

### B. Appwrite

- **Site:** [appwrite.io](https://appwrite.io)
- **Offers:** Database (MariaDB/NoSQL-style API), Auth, Storage, Functions.
- **Migration:** Official [“Migrate from Supabase”](https://appwrite.io/docs/advanced/migrations/supabase) (DB + Storage; Auth may need re-setup). **Caveat:** Appwrite DB is not PostgreSQL — you’ll need to adapt queries and possibly some app logic.
- **Flutter:** Good SDK support; you’d replace `supabase_flutter` with Appwrite client and refactor services (auth, DB, storage).

### C. Neon (Postgres) + Auth + Storage

- **Neon:** Serverless Postgres ([neon.tech](https://neon.tech)), not blocked in India in practice.
- **Gap:** Neon is DB only. You’d add:
  - **Auth:** e.g. Clerk, Auth0, or self-hosted GoTrue.
  - **Storage:** e.g. Cloudflare R2, S3, or Backblaze B2.
  - **Serverless:** Vercel/Cloudflare Workers for your current Edge Function logic.
- **Migration:** Apply your migrations to Neon; export/import data; rewire Flutter app to new Auth + Storage + API endpoints. Most app code change.

---

## Your Supabase Inventory (Checklist)

Use this when migrating to self-hosted or another platform.

### Tables (from codebase and migrations)
- `users`, `profiles`
- `posts`, `likes`, `comments`, `shares`, `bookmarks`, `notifications`
- `post_reports`, `user_reports`, `user_blocks`
- `follows`
- `stories`, `story_reports`, `bookmarks` (for stories)
- `conversations`, `conversation_members`, `chat_messages`, `user_hidden_messages`
- `message_requests`, `group_invite_requests`
- `chat_conversations` (if used)
- `discussions`, `discussion_likes`
- `map_chats`, `map_comments`
- `saved_travel_plans`
- `user_devices` (FCM)
- `sacred_locations`, `site_details`, `hindu_festivals`
- `custom_site_submissions`
- FCM/settings-related tables
- Enums: e.g. `post_type`

### Storage buckets
- `profile-avatars`
- `post-media`
- `story-images`
- `group_avatar`

### Edge Functions
- `generate-travel-plan`
- `translation`
- `generate-story`
- `generate-image`
- `interact-with-story`
- `chat-service`
- `delete-user-account`
- `send-push-notification`
- `generate-custom-site-details`
- `migrate-base64-images` (optional)

### Auth
- Supabase Auth (GoTrue) with email and Google OAuth.

---

## Recommendation Summary

| Goal                         | Option                          |
|-----------------------------|----------------------------------|
| Unblock India fast, no migration | **Option 1: Cloudflare Worker proxy** |
| Stay on Supabase, India host     | **Option 2: Self-host Supabase**     |
| Managed BaaS in India            | **Option 3: Nuvix or Appwrite**      |
| Postgres + pick Auth/Storage     | **Option 3: Neon + Auth + R2/S3**    |

**Practical order:** Try **Option 1** first (same day). If you want to reduce dependence on Supabase or need data in India, plan **Option 2** or **Option 3** using the inventory above.
