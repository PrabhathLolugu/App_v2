# Milestone v1: Offline-First Migration

**Status:** ✅ SHIPPED 2026-01-31
**Phases:** 1-8
**Total Plans:** 22

## Overview

Migration from Hive-based local storage to Brick offline-first architecture. This delivers true offline-first capability across all features, allowing users to browse stories, view generated content, and read their social feed without internet. The migration proceeds feature-by-feature, starting with core infrastructure and ending with complete cleanup of legacy code.

## Phases

### Phase 1: Core Infrastructure

**Goal**: Brick repository and SQLite database are initialized and ready for model integration
**Depends on**: Nothing (first phase)
**Requirements**: INFRA-01, INFRA-02, INFRA-03, INFRA-04, INFRA-05
**Success Criteria** (what must be TRUE):
  1. Brick package and build dependencies are installed without conflicts
  2. MyItihasRepository singleton is configured and accessible throughout the app
  3. SQLite database is created and persists locally
  4. Offline queue is initialized with correct path exclusions (auth, storage, functions)
  5. App starts successfully with Brick repository initialized before runApp
**Plans**: 1 plan

Plans:
- [x] 01-01-PLAN.md — Install Brick packages, create repository singleton, initialize in main.dart

### Phase 2: Stories Feature

**Goal**: Users can browse stories and view story details while offline (for previously loaded content)
**Depends on**: Phase 1
**Requirements**: STORY-01, STORY-02, STORY-03, STORY-04, STORY-05, STORY-06
**Success Criteria** (what must be TRUE):
  1. User can view previously loaded story lists without internet connection
  2. User can open and read story details for any cached story while offline
  3. Story data syncs automatically from Supabase when online
  4. Stories persist in SQLite across app restarts
**Plans**: 2 plans

Plans:
- [x] 02-01-PLAN.md — Create Brick models, update repository to use Brick queries, generate adapters
- [x] 02-02-PLAN.md — Fix verification gaps: add fromDomain() factories and Supabase unique constraints

### Phase 3: Story Generator Feature

**Goal**: Users can view their generated story history while offline (generation requires online)
**Depends on**: Phase 2
**Requirements**: GEN-01, GEN-02, GEN-03, GEN-04, GEN-05
**Success Criteria** (what must be TRUE):
  1. User can view list of previously generated stories without internet
  2. User can read full content of any cached generated story while offline
  3. Generated stories sync automatically from Supabase when online
  4. Story generation correctly requires online connection (appropriate feedback shown)
**Plans**: 2 plans

Plans:
- [x] 03-01-PLAN.md — Extend StoryAttributes model, create StoryChatConversation model, update repository with Brick caching
- [x] 03-02-PLAN.md — Add network-aware BLoC state, disable generate button offline, show snackbar for uncached stories

### Phase 4: Social Feed Feature

**Goal**: Users can browse their social feed, view posts, likes, and comments while offline
**Depends on**: Phase 3
**Requirements**: SOCIAL-01, SOCIAL-02, SOCIAL-03, SOCIAL-04, SOCIAL-05, SOCIAL-06, SOCIAL-07, SOCIAL-08, SOCIAL-09
**Success Criteria** (what must be TRUE):
  1. User can scroll through previously loaded feed posts without internet
  2. User can view post details including likes and comments while offline
  3. User profiles display correctly in cached posts
  4. Feed updates in real-time when online using Brick realtime subscriptions
  5. Like counts, comment counts, and share counts display accurately from cached data
**Plans**: 3 plans in 2 waves

Plans:
- [x] 04-01-PLAN.md — Create Brick models for ImagePost, TextPost, VideoPost, User with adapters (Wave 1)
- [x] 04-02-PLAN.md — Add network awareness and realtime subscriptions to FeedBloc (Wave 1)
- [x] 04-03-PLAN.md — Update PostRepositoryImpl to use Brick caching with alwaysHydrate (Wave 2)

### Phase 5: Chat Feature

**Goal**: Users can view their conversations and read message history while offline
**Depends on**: Phase 4
**Requirements**: CHAT-01, CHAT-02, CHAT-03, CHAT-04, CHAT-05, CHAT-06
**Success Criteria** (what must be TRUE):
  1. User can see list of conversations without internet connection
  2. User can read cached messages in any conversation while offline
  3. New messages appear in real-time when online via Brick realtime
  4. Message history persists correctly across app restarts
**Plans**: 3 plans in 2 waves

Plans:
- [x] 05-01-PLAN.md — Create ConversationModel and MessageModel with Brick annotations (Wave 1)
- [x] 05-02-PLAN.md — Update ChatRepositoryImpl with lazy caching and participant loading (Wave 1)
- [x] 05-03-PLAN.md — Add realtime subscriptions to BLoCs and generate adapters (Wave 2)

### Phase 6: Media Caching

**Goal**: Images are cached intelligently with automatic eviction when storage limits are reached
**Depends on**: Phase 5
**Requirements**: MEDIA-01, MEDIA-02, MEDIA-03, MEDIA-04
**Success Criteria** (what must be TRUE):
  1. Previously viewed images display immediately from cache when offline
  2. Cache respects configured size limit (e.g., 500MB)
  3. Least recently used images are evicted automatically when cache is full
  4. Cache persists across app restarts
**Plans**: 5 plans in 3 waves

Plans:
- [x] 06-01-PLAN.md — Install dependencies and create custom CacheManager instances for separate media pools (Wave 1)
- [x] 06-02-PLAN.md — Implement size monitoring and manual LRU eviction with byte limits (Wave 2)
- [x] 06-03-PLAN.md — Create prefetch service with WiFi detection and cache config model (Wave 2)
- [x] 06-04-PLAN.md — Update CachedNetworkImage widgets and integrate prefetch in BLoCs (Wave 3)
- [x] 06-05-PLAN.md — Create cache settings UI with sliders and usage display (Wave 3)

### Phase 7: Offline UX

**Goal**: Users receive clear feedback about connectivity status and disabled actions when offline
**Depends on**: Phase 6
**Requirements**: UX-01, UX-02, UX-03, UX-04, SYNC-01, SYNC-02, SYNC-03
**Success Criteria** (what must be TRUE):
  1. User sees visual indicator (banner or icon) when device is offline
  2. Write actions (post, like, comment, send message) are disabled when offline
  3. User receives helpful feedback when attempting disabled actions while offline
  4. Data syncs automatically when connectivity is restored
  5. Sync operations are logged for debugging purposes
**Plans**: 4 plans in 3 waves

Plans:
- [x] 07-01-PLAN.md — Global ConnectivityBloc and OfflineBanner widget (Wave 1)
- [x] 07-02-PLAN.md — OfflineAwareButton and OfflineAwareIconButton widgets (Wave 2)
- [x] 07-03-PLAN.md — Extend write-disabled pattern to all BLoCs (Wave 2)
- [x] 07-04-PLAN.md — Pull-to-refresh and sync indicators in UI (Wave 3)

### Phase 8: Migration & Cleanup

**Goal**: Hive is completely removed and users transition cleanly to Brick-based storage
**Depends on**: Phase 7
**Requirements**: INFRA-06, MIGRATE-01, MIGRATE-02, MIGRATE-03, MIGRATE-04, MIGRATE-05
**Success Criteria** (what must be TRUE):
  1. App detects first launch after migration and clears Hive data
  2. All Hive boxes are deleted on migration
  3. Hive packages are removed from pubspec.yaml
  4. Hive-related code (HiveService, adapters, registrar) is deleted
  5. Dependency injection configuration no longer references Hive
  6. App functions correctly without any Hive dependencies
**Plans**: 2 plans in 2 waves

Plans:
- [x] 08-01-PLAN.md — Create HiveMigrationService and integrate in main.dart
- [x] 08-02-PLAN.md — Remove Hive annotations, delete HiveService, remove packages

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3 → 4 → 5 → 6 → 7 → 8

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Core Infrastructure | 1/1 | ✓ Complete | 2026-01-28 |
| 2. Stories Feature | 2/2 | ✓ Complete | 2026-01-29 |
| 3. Story Generator Feature | 2/2 | ✓ Complete | 2026-01-29 |
| 4. Social Feed Feature | 3/3 | ✓ Complete | 2026-01-30 |
| 5. Chat Feature | 3/3 | ✓ Complete | 2026-01-30 |
| 6. Media Caching | 5/5 | ✓ Complete | 2026-01-30 |
| 7. Offline UX | 4/4 | ✓ Complete | 2026-01-31 |
| 8. Migration & Cleanup | 2/2 | ✓ Complete | 2026-01-31 |

---

## Milestone Summary

**Decimal Phases:** None (no urgent insertions required)

**Key Decisions:**
- Brick over Hive for offline-first storage (built-in Supabase sync)
- Clean slate migration (wipe Hive data, fresh sync from server)
- Last-write-wins for conflict resolution (avoids complex UI)
- Disable offline writes (clearer UX than silent queuing)
- Cache engagement counts as fields (not full Like/Comment/Share models)
- LRU media caching with configurable limits
- 3-second debounce for offline state transitions

**Issues Resolved:**
- Hive dependency completely removed
- All features work offline with automatic sync
- Media cache respects storage limits
- Clear UX feedback for offline state

**Issues Deferred:**
- Offline write queuing (v2)
- Video caching (v2)
- Manual conflict resolution UI (v2)
- BLoC-level guards for toggleBookmark/addComment/shareContent (UI guards sufficient)

**Technical Debt Incurred:**
- getOrCreateConversation() requires Supabase RPC function deployment
- pruneOldMessages() stubbed for future implementation
- Client-side pagination in ChatRepositoryImpl (works but less efficient)
- 3 write operations have UI-level guards only (not BLoC-level)

---

*For current project status, see .planning/MILESTONES.md*

---
*Archived: 2026-01-31 as part of v1 milestone completion*
