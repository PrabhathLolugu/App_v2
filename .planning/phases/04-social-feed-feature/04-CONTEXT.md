# Phase 4: Social Feed Feature - Context

**Gathered:** 2026-01-29
**Status:** Ready for planning

<domain>
## Phase Boundary

Enable offline browsing of posts, likes, and comments in the social feed. Users can scroll through previously loaded feed posts, view post details with engagement counts, and see author profiles while offline. Write actions (like, comment, share) require network. Real-time updates via Brick subscriptions when online.

</domain>

<decisions>
## Implementation Decisions

### Data model scope
- Cache posts and author profiles only. Comments and likes load on demand when online.
- Cache all post types equally: story, image, text, video
- First page eager loading on app launch, remaining pages cached as user scrolls
- Engagement counts (likes, comments, shares) cached as part of post data

### Cache freshness policy
- Network first, cache fallback strategy: try server first, use cache if offline
- No freshness indicator: cached data looks identical to fresh data
- Keep cached posts until storage limit reached (LRU eviction)
- Server wins on conflict: replace cached post with server version when syncing

### Offline state behavior
- Show error snackbar when user attempts write actions (like/comment/share) offline
- Snackbar message: "No internet connection. Try again later."
- Pull-to-refresh triggers error snackbar when offline
- Empty state message when no cached posts: "No cached posts. Connect to load feed."

### Real-time sync strategy
- Subscribe to all post tables for live updates via Brick realtime
- Auto-insert new posts at top of feed when they arrive
- Live count updates: engagement counts update in real-time as they change
- Graceful degradation on connection loss: use cached data, re-subscribe when online

### Claude's Discretion
- Brick model structure and adapter implementation details
- SQLite schema design for social entities
- Repository method signatures and query patterns
- Real-time subscription management and lifecycle

</decisions>

<specifics>
## Specific Ideas

- Consistent with Phase 3 patterns: same snackbar style for offline errors
- Follow existing FeedBloc patterns for state management
- Use same InternetConnection package for connectivity tracking
- Brick models should follow established patterns from Stories feature

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 04-social-feed-feature*
*Context gathered: 2026-01-29*
