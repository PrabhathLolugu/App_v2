# External Integrations

**Analysis Date:** 2026-01-28

## APIs & External Services

**Google Gemini AI:**
- Service: Google Generative AI (Gemini)
- Purpose: AI story generation from Indian scripture prompts
- SDK/Client: `npm:@google/generative-ai@^0.21.0` (Edge Function)
- Model: `gemini-3-flash-preview`
- Auth: `GEMINI_API_KEY` environment variable (Supabase secrets)
- Location: `supabase/functions/generate-story/index.ts`
- Endpoint: Invoked via Supabase Edge Function

**Google Fonts:**
- Service: Google Fonts API
- Purpose: Custom typography
- SDK/Client: `google_fonts ^6.3.3`
- Auth: None required (public API)

**DiceBear Avatars:**
- Service: DiceBear Avatar API
- Purpose: Default user avatar generation
- Endpoint: `https://api.dicebear.com/7.x/avataaars/svg?seed={username}`
- Auth: None required
- Location: `lib/services/auth_service.dart` line 307

## Data Storage

**Databases:**

**Primary - Supabase PostgreSQL:**
- Type: Cloud PostgreSQL with Realtime
- Connection: Hardcoded in `lib/main.dart`
  - URL: `https://xmbygaeixvzlyhbtkbnp.supabase.co`
  - Anon Key: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`
- Client: `supabase_flutter ^2.5.6`
- Tables: `users`, `profiles`, `stories`, `likes`, `comments`, `bookmarks`, `shares`, `conversations`, `messages`, `notifications`
- Features: Row Level Security (RLS), real-time subscriptions
- Initialization: `lib/services/supabase_service.dart`

**Local - Hive CE:**
- Type: NoSQL key-value database (offline-first)
- Connection: Local filesystem via `path_provider`
- Client: `hive_ce ^2.15.1`, `hive_ce_flutter ^2.3.3`
- Boxes: `stories_box`, `user_preferences_box`, `chat_history_box`, `generated_stories_box`, `users_box`, `conversations_box`, `messages_box`, `comments_box`, `likes_box`, `shares_box`, `notifications_box`
- Purpose: Offline data persistence, caching
- Initialization: `lib/core/storage/hive_service.dart`

**Secondary - SQLite:**
- Type: Embedded relational database
- Client: `sqflite ^2.4.2`
- Purpose: Structured local data (limited usage)

**File Storage:**
- Local filesystem via `path_provider ^2.1.5`
- Image caching via `cached_network_image ^3.4.1`
- Supabase Storage (inferred from backend setup, not directly used in code yet)

**Caching:**
- In-memory image cache via `cached_network_image`
- Hive for persistent data cache

## Authentication & Identity

**Auth Provider:**
- Service: Supabase Auth
- Implementation: Email/password + OAuth
- Provider: `supabase_flutter` Auth module
- Supported Methods:
  - Email/Password signup/signin
  - Google OAuth (`OAuthProvider.google`)
  - Password reset via email with deep links
- Deep Links: `myitihas://` scheme
  - `myitihas://login-callback` - OAuth callback
  - `myitihas://reset-password` - Password reset flow
- Session Management: Automatic persistence via Supabase (Hive on mobile, localStorage on web)
- Auth Service: `lib/services/auth_service.dart`
- User Metadata: `display_name`, `full_name` stored in `user_metadata`

## Monitoring & Observability

**Error Tracking:**
- Service: None (custom logging only)

**Logs:**
- Framework: Talker ^5.1.9
- Destinations: Console + in-app log viewer (`talker_flutter`)
- Interceptors:
  - BLoC events/states (`talker_bloc_logger`)
  - HTTP requests/responses (`talker_dio_logger`)
- Global instance: `lib/core/logging/talker_setup.dart`

## CI/CD & Deployment

**Hosting:**
- Mobile: Not configured (manual build/release via Flutter)
- Backend: Supabase Cloud (project ref: `xmbygaeixvzlyhbtkbnp`)

**CI Pipeline:**
- Service: None detected (no GitHub Actions, GitLab CI, etc.)

**Edge Functions Deployment:**
```bash
supabase functions deploy generate-story
```

## Environment Configuration

**Required env vars:**

**Flutter App:**
- `API_BASE_URL` (optional, default: https://api.myitihas.com)
- Supabase credentials hardcoded in `main.dart` (should be moved to env)

**Supabase Edge Functions:**
- `GEMINI_API_KEY` - Google Gemini API key (required)
- `SUPABASE_URL` - Auto-populated by Supabase
- `SUPABASE_SERVICE_ROLE_KEY` - Auto-populated by Supabase

**Secrets location:**
- Supabase Secrets Manager (for Edge Functions)
- No `.env` files in repository
- SharedPreferences for user preferences (not secrets)

## Webhooks & Callbacks

**Incoming:**
- Deep link callbacks via `app_links ^6.4.1`
  - `myitihas://login-callback` - OAuth callback handling
  - `myitihas://reset-password` - Password reset deep link
- Handler: `lib/services/auth_service.dart` `_handleDeepLink()`

**Outgoing:**
- None detected

## Realtime Features

**Supabase Realtime Channels:**
- Service: Supabase Realtime (WebSocket-based)
- Purpose: Live updates for social interactions
- Channels:
  - `public:likes` - Like inserts/deletes
  - `public:comments` - Comment inserts/deletes
  - `public:bookmarks` - Bookmark inserts/deletes
  - `public:shares` - Share inserts
- Implementation: `lib/services/realtime_service.dart`
- Events: `PostgresChangeEvent.insert`, `PostgresChangeEvent.delete`
- Broadcast: `StreamController<SocialCountUpdate>` for app-wide updates

## Third-Party SDKs

**Media:**
- Image picker - Device camera/gallery access
- Video player - Native video playback
- Flutter TTS - Platform text-to-speech engines

**Sharing:**
- `share_plus ^12.0.1` - Native share sheet integration

**Permissions:**
- `permission_handler ^12.0.1` - Runtime permission requests

**UI Libraries:**
- Smooth Sheets (GitHub: `fujidaiti/smooth_sheets`) - Custom bottom sheet library

## External APIs (Direct HTTP)

**Dio HTTP Client:**
- Base URL: `https://api.myitihas.com` (not currently used, placeholder)
- Timeout: 30s (connect/receive/send)
- Interceptors: TalkerDioLogger, custom auth header injection (TODO)
- Configuration: `lib/core/network/api_client.dart`

## Development Tools

**Code Generation:**
- Freezed (forked): `github.com/AmanSikarwar/freezed` (custom fork)
- Injectable, JSON Serializable, Go Router Builder, Slang, Hive Generator

**Asset Sources:**
- Local `assets/` directory
- Remote images via CDN (cached locally)

---

*Integration audit: 2026-01-28*
