# Phase 6: Media Caching - Context

**Gathered:** 2026-01-30
**Status:** Ready for planning

<domain>
## Phase Boundary

Smart LRU caching for images, videos, and audio with automatic eviction when storage limits are reached. Covers all media across all features (stories, posts, chat, profiles). Users can configure cache size and download behavior.

</domain>

<decisions>
## Implementation Decisions

### Cache scope
- All media types cached: images, videos, audio
- All features included: stories, social feed, chat, profiles
- Separate storage pools for each media type (images, video, audio)
- Each pool has independent size limits and eviction

### Caching triggers
- Preemptive download when list data is fetched (before user scrolls to item)
- Per-feature defaults for aggressive vs WiFi-only download
- Global user setting to override defaults (WiFi-only toggle)
- Size budget per list load to limit prefetch volume

### Size & eviction
- User-selectable cache size via slider (not presets)
- Separate sliders for images, video, audio pools
- LRU eviction runs both in background (on app launch) and on-demand (when cache full)
- Cache usage displayed in settings (e.g., "Using 450MB of 500MB")
- No notifications for eviction — silent cleanup

### Image quality
- Store both thumbnails and full-size images
- Progressive loading: show thumbnail first, load full-size in background
- Thumbnails generated client-side after downloading full-size (not server transforms)
- When full-size is cached, thumbnail is replaced (not kept alongside)

### Claude's Discretion
- Exact thumbnail dimensions and compression quality
- Background cleanup frequency and timing
- Size budget defaults per list type
- Per-feature defaults for WiFi-only behavior
- Slider min/max values and step increments

</decisions>

<specifics>
## Specific Ideas

No specific product references — open to standard approaches for LRU caching and progressive image loading.

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 06-media-caching*
*Context gathered: 2026-01-30*
