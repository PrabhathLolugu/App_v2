# Phase 2: Stories Feature - Context

**Gathered:** 2026-01-28
**Status:** Ready for planning

<domain>
## Phase Boundary

Add Brick offline caching to the existing Stories feature. Users can browse story lists and view story details offline for previously loaded content. UI is already implemented — this phase focuses on data layer changes only.

**In scope:** Brick models, repository swap, sync configuration, cache management
**Out of scope:** UI changes (existing UI stays), offline indicators (Phase 7), media caching (Phase 6)

</domain>

<decisions>
## Implementation Decisions

### Cache Scope
- Cache all stories from any list the user loads (not just individually viewed)
- No special priority treatment for favorites/bookmarks
- Claude decides: related entities (categories, authors, sources) based on existing models
- Claude decides: eager vs lazy fetching based on existing patterns

### Sync Behavior
- Automatic background sync (Brick handles when online)
- Use Supabase realtime subscriptions for story updates
- Use Brick default offline-first loading strategy
- Show subtle notification when sync fails (not silent, not blocking)

### Cache Freshness
- 7-day TTL for cached story data
- Show stale data immediately + refresh in background when accessed
- Remove deleted stories from cache via realtime notifications

### Cache Limits
- Size-based limit for story cache (Claude decides appropriate size)
- Eviction policy: Claude decides (LRU recommended)
- Add manual "clear cache" option in settings

### Claude's Discretion
- Related entity caching strategy (inline vs separate tables)
- Eager vs lazy detail fetching
- Exact cache size limit (reasonable for text/metadata)
- Eviction algorithm implementation
- Brick model structure based on existing Supabase schema

</decisions>

<specifics>
## Specific Ideas

- Existing UI stays unchanged — this is purely data layer work
- Use Brick's built-in offline-first patterns
- Follow existing Clean Architecture patterns (domain entities, data models, repository impl)

</specifics>

<deferred>
## Deferred Ideas

- Offline visual indicators (grayscale uncached, etc.) — Phase 7
- Image/media caching — Phase 6
- Shimmer loading, empty states — already implemented in existing UI

</deferred>

---

*Phase: 02-stories-feature*
*Context gathered: 2026-01-28*
