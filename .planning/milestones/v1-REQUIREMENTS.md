# Requirements Archive: v1 Offline-First Migration

**Archived:** 2026-01-31
**Status:** ✅ SHIPPED

This is the archived requirements specification for v1.
For current requirements, see `.planning/REQUIREMENTS.md` (created for next milestone).

---

# Requirements: MyItihas Offline-First Migration

**Defined:** 2026-01-28
**Core Value:** Users can browse stories, view generated content, and read their social feed even without internet

## v1 Requirements

### Core Infrastructure

- [x] **INFRA-01**: Add brick_offline_first_with_supabase ^2.1.0 and build dependencies
- [x] **INFRA-02**: Create MyItihasRepository extending OfflineFirstWithSupabaseRepository
- [x] **INFRA-03**: Configure SQLite database with databaseFactory
- [x] **INFRA-04**: Configure offline queue (ignore auth/storage/functions paths)
- [x] **INFRA-05**: Initialize repository in main.dart before runApp
- [x] **INFRA-06**: Remove Hive initialization and cleanup existing data on first launch

### Stories Feature

- [x] **STORY-01**: Create Story.model.dart with @ConnectOfflineFirstWithSupabase
- [x] **STORY-02**: Create StoryAttributes.model.dart for nested story data
- [x] **STORY-03**: Map Story fields to Supabase stories table columns
- [x] **STORY-04**: Update StoryRepository to use Brick repository
- [x] **STORY-05**: Enable offline reading of previously viewed stories
- [x] **STORY-06**: Enable offline browsing of story lists

### Story Generator Feature

- [x] **GEN-01**: Create GeneratedStory.model.dart with @ConnectOfflineFirstWithSupabase
- [x] **GEN-02**: Map GeneratedStory fields to Supabase generated_stories table
- [x] **GEN-03**: Update GeneratedStoryRepository to use Brick
- [x] **GEN-04**: Cache generated story history locally
- [x] **GEN-05**: Show cached generations when offline (generation itself requires online)

### Social Feed Feature

- [x] **SOCIAL-01**: Create Post.model.dart (text posts, image posts)
- [x] **SOCIAL-02**: Create Like.model.dart with user association *(implemented as engagement count field)*
- [x] **SOCIAL-03**: Create Comment.model.dart with user and post associations *(implemented as engagement count field)*
- [x] **SOCIAL-04**: Create Share.model.dart with post association *(implemented as engagement count field)*
- [x] **SOCIAL-05**: Create User.model.dart (profiles for social)
- [x] **SOCIAL-06**: Map all social models to Supabase tables
- [x] **SOCIAL-07**: Update FeedRepository to use Brick
- [x] **SOCIAL-08**: Enable offline browsing of cached feed
- [x] **SOCIAL-09**: Replace existing Supabase Realtime with Brick subscribeToRealtime

### Chat Feature

- [x] **CHAT-01**: Create Conversation.model.dart with user association
- [x] **CHAT-02**: Create Message.model.dart with conversation association
- [x] **CHAT-03**: Map chat models to Supabase tables
- [x] **CHAT-04**: Update ChatRepository to use Brick
- [x] **CHAT-05**: Enable offline viewing of cached messages
- [x] **CHAT-06**: Integrate Brick realtime for new messages

### Media Caching

- [x] **MEDIA-01**: Configure LRU cache with size limit for images
- [x] **MEDIA-02**: Use cached_network_image with persistent cache directory
- [x] **MEDIA-03**: Set maximum cache size (e.g., 500MB)
- [x] **MEDIA-04**: Implement cache eviction when limit reached

### Offline UX

- [x] **UX-01**: Add network connectivity listener
- [x] **UX-02**: Show offline indicator (banner/icon) when disconnected
- [x] **UX-03**: Disable write actions (post, like, comment, send message) when offline
- [x] **UX-04**: Show appropriate feedback when user attempts disabled action

### Sync & Conflict Resolution

- [x] **SYNC-01**: Implement real-time sync when connectivity restored
- [x] **SYNC-02**: Use last-write-wins for any conflicts
- [x] **SYNC-03**: Log sync operations for debugging

### Migration & Cleanup

- [x] **MIGRATE-01**: Detect first launch after migration
- [x] **MIGRATE-02**: Clear all Hive boxes on migration
- [x] **MIGRATE-03**: Remove Hive packages from pubspec.yaml
- [x] **MIGRATE-04**: Remove Hive-related code (HiveService, adapters, registrar)
- [x] **MIGRATE-05**: Update dependency injection configuration

## v2 Requirements (Deferred)

### Deferred to Future

- **QUEUE-01**: Queue write operations when offline (currently disabling instead)
- **VIDEO-01**: Offline video caching (currently images only)
- **CONFLICT-01**: Manual conflict resolution UI (using last-write-wins instead)

## Out of Scope

| Feature | Reason |
|---------|--------|
| Migrating existing Hive data | Clean slate approach, server is source of truth |
| Offline write operations | Clearer UX to disable actions than queue silently |
| Video caching | Storage/bandwidth concerns, stream when online |
| Offline story generation | Requires Edge Function (online only) |
| Offline authentication | Supabase Auth not cacheable |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| INFRA-01 | Phase 1 | ✅ Complete |
| INFRA-02 | Phase 1 | ✅ Complete |
| INFRA-03 | Phase 1 | ✅ Complete |
| INFRA-04 | Phase 1 | ✅ Complete |
| INFRA-05 | Phase 1 | ✅ Complete |
| INFRA-06 | Phase 8 | ✅ Complete |
| STORY-01 | Phase 2 | ✅ Complete |
| STORY-02 | Phase 2 | ✅ Complete |
| STORY-03 | Phase 2 | ✅ Complete |
| STORY-04 | Phase 2 | ✅ Complete |
| STORY-05 | Phase 2 | ✅ Complete |
| STORY-06 | Phase 2 | ✅ Complete |
| GEN-01 | Phase 3 | ✅ Complete |
| GEN-02 | Phase 3 | ✅ Complete |
| GEN-03 | Phase 3 | ✅ Complete |
| GEN-04 | Phase 3 | ✅ Complete |
| GEN-05 | Phase 3 | ✅ Complete |
| SOCIAL-01 | Phase 4 | ✅ Complete |
| SOCIAL-02 | Phase 4 | ✅ Complete (as count field) |
| SOCIAL-03 | Phase 4 | ✅ Complete (as count field) |
| SOCIAL-04 | Phase 4 | ✅ Complete (as count field) |
| SOCIAL-05 | Phase 4 | ✅ Complete |
| SOCIAL-06 | Phase 4 | ✅ Complete |
| SOCIAL-07 | Phase 4 | ✅ Complete |
| SOCIAL-08 | Phase 4 | ✅ Complete |
| SOCIAL-09 | Phase 4 | ✅ Complete |
| CHAT-01 | Phase 5 | ✅ Complete |
| CHAT-02 | Phase 5 | ✅ Complete |
| CHAT-03 | Phase 5 | ✅ Complete |
| CHAT-04 | Phase 5 | ✅ Complete |
| CHAT-05 | Phase 5 | ✅ Complete |
| CHAT-06 | Phase 5 | ✅ Complete |
| MEDIA-01 | Phase 6 | ✅ Complete |
| MEDIA-02 | Phase 6 | ✅ Complete |
| MEDIA-03 | Phase 6 | ✅ Complete |
| MEDIA-04 | Phase 6 | ✅ Complete |
| UX-01 | Phase 7 | ✅ Complete |
| UX-02 | Phase 7 | ✅ Complete |
| UX-03 | Phase 7 | ✅ Complete |
| UX-04 | Phase 7 | ✅ Complete |
| SYNC-01 | Phase 7 | ✅ Complete |
| SYNC-02 | Phase 7 | ✅ Complete |
| SYNC-03 | Phase 7 | ✅ Complete |
| MIGRATE-01 | Phase 8 | ✅ Complete |
| MIGRATE-02 | Phase 8 | ✅ Complete |
| MIGRATE-03 | Phase 8 | ✅ Complete |
| MIGRATE-04 | Phase 8 | ✅ Complete |
| MIGRATE-05 | Phase 8 | ✅ Complete |

**Coverage:**
- v1 requirements: 42 total
- Mapped to phases: 42
- Shipped: 42 ✓

---

## Milestone Summary

**Shipped:** 42 of 42 v1 requirements

**Adjusted during implementation:**
- SOCIAL-02, SOCIAL-03, SOCIAL-04: Implemented as engagement count fields on post models rather than separate Brick models (architectural decision for performance)

**Dropped:** None

---
*Archived: 2026-01-31 as part of v1 milestone completion*
