---
phase: 04-social-feed-feature
plan: 01
subsystem: database
tags: [brick, offline-first, supabase, sqlite, posts, profiles, social-feed]

# Dependency graph
requires:
  - phase: 01-core-infrastructure
    provides: Brick repository initialization and offline-first infrastructure
  - phase: 02-stories-feature
    provides: Brick model patterns with @ConnectOfflineFirstWithSupabase
  - phase: 03-story-generator-feature
    provides: JSONB metadata serialization patterns
provides:
  - Brick models for social posts (ImagePost, TextPost, VideoPost)
  - UserModel for author profile caching
  - Foreign key associations between posts and authors
  - Offline cache for feed browsing without network
affects: [04-social-feed-feature, 05-social-engagement]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Post models share posts table via content_type discrimination"
    - "Engagement counts cached as fields for instant display"
    - "metadata JSONB for post-type-specific fields (tags, styling, duration)"
    - "Foreign key associations with nullable author for cache miss handling"
    - "Local-only fields with @Supabase(ignore: true) @Sqlite() for client state"

key-files:
  created:
    - lib/features/social/data/models/image_post.model.dart
    - lib/features/social/data/models/text_post.model.dart
    - lib/features/social/data/models/video_post.model.dart
    - lib/features/social/data/models/user.model.dart
    - lib/brick/adapters/image_post_model_adapter.g.dart
    - lib/brick/adapters/text_post_model_adapter.g.dart
    - lib/brick/adapters/video_post_model_adapter.g.dart
    - lib/brick/adapters/user_model_adapter.g.dart
    - lib/brick/db/20260129150730.migration.dart
  modified:
    - lib/brick/brick.g.dart
    - lib/brick/db/schema.g.dart

key-decisions:
  - "Remove defaultValue from @Supabase annotations - use constructor defaults instead"
  - "Cache engagement counts as fields not associations for instant display"
  - "Nullable author field for graceful cache miss handling"
  - "Store tags/styling/duration in metadata JSONB for flexibility"
  - "Local-only fields for client state (isLikedByCurrentUser, isFollowing)"

patterns-established:
  - "Constructor defaults over annotation defaultValue for Brick compatibility"
  - "Metadata JSONB pattern for post-type-specific fields"
  - "Foreign key associations with nullable for cache resilience"

# Metrics
duration: 9min
completed: 2026-01-29
---

# Phase 04 Plan 01: Brick Models for Social Feed Summary

**Offline-first post caching with ImagePost, TextPost, VideoPost, and UserModel using Brick with Supabase sync and SQLite storage**

## Performance

- **Duration:** 9 min
- **Started:** 2026-01-29T15:01:50Z
- **Completed:** 2026-01-29T15:10:23Z
- **Tasks:** 4
- **Files modified:** 11

## Accomplishments
- Created four Brick models (ImagePost, TextPost, VideoPost, User) with bidirectional domain conversion
- Generated SQLite adapters for offline storage and Supabase sync
- Established metadata JSONB pattern for post-type-specific fields (tags, styling, video duration)
- Implemented foreign key associations between posts and author profiles

## Task Commits

Each task was committed atomically:

1. **Task 1: Create ImagePostModel with Brick annotations** - `622bb42` (feat)
2. **Task 2: Create TextPostModel and VideoPostModel with Brick annotations** - `8b6b1d3` (feat)
3. **Task 3: Create UserModel with Brick annotations** - `573b77d` (feat)
4. **Task 4: Generate Brick adapters for post and user models** - `28819cd` (feat)

## Files Created/Modified

Created:
- `lib/features/social/data/models/image_post.model.dart` - Brick model for image posts with aspect ratio and location
- `lib/features/social/data/models/text_post.model.dart` - Brick model for text posts with styling metadata (backgroundColor, textColor, fontSize, fontFamily)
- `lib/features/social/data/models/video_post.model.dart` - Brick model for video posts with duration, viewCount, and thumbnail
- `lib/features/social/data/models/user.model.dart` - Brick model for user profiles from profiles table with follower counts
- `lib/brick/adapters/image_post_model_adapter.g.dart` - Generated SQLite adapter for ImagePostModel
- `lib/brick/adapters/text_post_model_adapter.g.dart` - Generated SQLite adapter for TextPostModel
- `lib/brick/adapters/video_post_model_adapter.g.dart` - Generated SQLite adapter for VideoPostModel
- `lib/brick/adapters/user_model_adapter.g.dart` - Generated SQLite adapter for UserModel
- `lib/brick/db/20260129150730.migration.dart` - SQLite schema migration for new tables

Modified:
- `lib/brick/brick.g.dart` - Registered new model adapters in Brick repository
- `lib/brick/db/schema.g.dart` - Updated SQLite schema with posts and profiles tables

## Decisions Made

**1. Remove defaultValue from @Supabase annotations**
- Initial implementation used `@Supabase(name: 'likes_count', defaultValue: 0)` which caused build_runner errors
- Brick code generator couldn't resolve annotations with defaultValue parameters
- Solution: Use constructor defaults instead (`this.likes = 0`)
- Consistent with Phase 2-3 patterns (StoryModel, StoryChatConversationModel)

**2. Metadata JSONB for post-type-specific fields**
- ImagePostModel: stores tags in metadata
- TextPostModel: stores backgroundColor, textColor, fontSize, fontFamily, tags
- VideoPostModel: stores location, durationSeconds, viewCount, tags
- Rationale: Flexible storage for varying post types sharing posts table

**3. Nullable author field for cache resilience**
- Foreign key `@Supabase(foreignKey: 'author_id') final UserModel? author`
- Nullable because author profile may not be in cache
- toDomain() converts with `author?.toDomain()` for graceful handling

**4. Local-only fields with @Supabase(ignore: true) @Sqlite()**
- Posts: isLikedByCurrentUser, isFavorite
- User: isFollowing, isCurrentUser, savedStories
- These are computed client-side and not synced to Supabase

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Removed defaultValue from Brick annotations**
- **Found during:** Task 4 (Generate Brick adapters)
- **Issue:** build_runner failed with "Could not resolve annotation for `int followerCount`" and similar errors for fields with `@Supabase(defaultValue: X)`
- **Fix:** Removed defaultValue parameter from all @Supabase annotations, used constructor defaults instead
- **Files modified:**
  - lib/features/social/data/models/image_post.model.dart
  - lib/features/social/data/models/text_post.model.dart
  - lib/features/social/data/models/video_post.model.dart
  - lib/features/social/data/models/user.model.dart
- **Verification:** build_runner succeeded, all adapters generated without errors
- **Committed in:** 28819cd (Task 4 commit)

---

**Total deviations:** 1 auto-fixed (1 blocking)
**Impact on plan:** Fix necessary for code generation to succeed. Aligns with established patterns from Phase 2-3.

## Issues Encountered

**Build_runner annotation resolution error:** Initial models used `@Supabase(defaultValue: X)` which Brick's annotation finder couldn't parse. Error manifested as "Could not resolve annotation for `<field>`" for aspectRatio, followerCount, and engagement count fields. Resolved by removing defaultValue from annotations and using constructor parameter defaults instead, matching the pattern used in StoryModel and StoryChatConversationModel.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

**Ready for:**
- Repository implementation using OfflineFirstWithSupabaseRepository
- Feed datasources (local via Brick, remote via Supabase)
- Post caching with optimisticLocal policy for instant feed loading
- User profile caching for author display in feed

**Notes:**
- Per CONTEXT.md: Comments, Likes, Shares are NOT cached (load on demand when online)
- Post models include cached engagement counts for display without JOIN queries
- Migration 20260129150730 will run on next app launch to create tables

---
*Phase: 04-social-feed-feature*
*Completed: 2026-01-29*
