# MyItihas: Offline-First Migration

## What This Is

MyItihas is a Flutter mobile app for cultural/historical stories from Indian scriptures with offline-first architecture. The app now uses Brick with SQLite + Supabase sync for true offline capability across all features.

## Core Value

Users can browse stories, view generated content, and read their social feed even without internet. When they reconnect, everything syncs automatically without data loss.

## Current State (v1 Shipped)

**Version:** v1 Offline-First Migration — Shipped 2026-01-31

**Key Capabilities:**
- 81,247 lines of Dart code
- Brick offline-first with SQLite + Supabase auto-sync
- All features work offline (Stories, Generator, Feed, Chat)
- Smart LRU media caching (500MB default, configurable)
- Comprehensive offline UX with connectivity awareness
- Complete Hive removal

**Architecture:**
- **Data layer**: Brick models with @ConnectOfflineFirstWithSupabase
- **Domain layer**: Unchanged (entities, repositories, usecases)
- **Presentation layer**: BLoC with connectivity awareness

## Requirements

### Validated

<!-- Shipped in v1 -->

- ✓ Brick offline-first infrastructure — v1
- ✓ Offline story browsing and detail viewing — v1
- ✓ Offline story generator history — v1
- ✓ Offline social feed browsing — v1
- ✓ Offline chat history viewing — v1
- ✓ Smart LRU media caching — v1
- ✓ Offline UX with disabled write actions — v1
- ✓ Hive to Brick migration — v1

<!-- Existing capabilities preserved -->

- ✓ Stories browsing and detail view — existing
- ✓ AI story generation with Gemini — existing
- ✓ Social feed with posts, likes, comments — existing
- ✓ Real-time chat with Supabase channels — existing
- ✓ User authentication via Supabase Auth — existing
- ✓ Clean Architecture + DDD structure — existing

### Active

<!-- Next milestone scope - TBD -->

(No active requirements — define in next milestone)

### Out of Scope

- **Offline write operations** — Actions disabled when offline (not queued) — clearer UX
- **Video caching** — Images only, videos stream when online — storage concerns
- **Manual conflict resolution UI** — Using last-write-wins — acceptable for social app
- **Offline story generation** — Requires Edge Function (online only)
- **Offline authentication** — Supabase Auth not cacheable

## Context

### Tech Stack

- **Flutter** with Dart (81K+ LOC)
- **Brick** offline-first with SQLite + Supabase
- **Supabase** backend (Auth, Database, Realtime, Storage, Edge Functions)
- **BLoC** state management with connectivity awareness
- **flutter_cache_manager** for media caching

### Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Brick over Hive | First-class Supabase support, built-in sync, query capabilities | ✓ Good |
| Clean slate migration | Simpler than data migration, server is source of truth | ✓ Good |
| Last-write-wins | Avoids conflict UI complexity, acceptable for social app | ✓ Good |
| Disable offline writes | Clearer UX than silent queuing, prevents expectation mismatch | ✓ Good |
| Smart LRU media cache | Balance storage use vs. offline availability | ✓ Good |
| Cache counts not associations | Fast display, load Like/Comment/Share details on demand | ✓ Good |
| UI-level write guards | Sufficient for MVP, BLoC guards deferred | ⚠️ Revisit |

### Known Tech Debt

- getOrCreateConversation() requires Supabase RPC function deployment
- pruneOldMessages() stubbed for future implementation
- Client-side pagination in ChatRepositoryImpl
- 3 write operations have UI-level guards only (not BLoC-level)

## Constraints

- **Package**: `brick_offline_first_with_supabase: ^2.1.0`
- **Architecture**: Must maintain Clean Architecture + DDD patterns
- **Backend**: Existing Supabase schema unchanged
- **Compatibility**: Must work with existing auth flow and deep links

---
*Last updated: 2026-01-31 after v1 milestone*
