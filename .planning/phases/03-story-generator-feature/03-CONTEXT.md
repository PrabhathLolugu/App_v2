# Phase 3: Story Generator Feature - Context

**Gathered:** 2026-01-29
**Status:** Ready for planning

<domain>
## Phase Boundary

Cache generated story history for offline viewing. Users can browse and read their previously generated stories without internet. Story generation itself requires online connection. Related data (translations, chat conversations, character details) should also be accessible offline.

</domain>

<decisions>
## Implementation Decisions

### Caching scope
- Cache everything related: story content, translations, chat history, character details
- Cache immediately after story generation completes (not on view)
- Cache all user's generated stories (no limit on count)

### History list behavior
- Show cache immediately, sync from network in background (alwaysHydrate pattern)
- Empty state: Friendly illustration + "Generate your first story!" CTA

### Offline unavailability handling
- Stories appear normal in the list (no preemptive badge for cached/uncached)
- When user taps a story that isn't cached while offline, show snackbar warning
- Snackbar message: "Story not available offline. Connect to internet to view."

### Generation-blocked feedback
- Disable the Generate button when offline
- Show hint text below button: "Requires internet connection"
- Tooltip/popup appears when user taps the disabled button (explains why)

### Claude's Discretion
- Related data caching timing (character details, chat conversations) — cache on access vs. with story
- History list item content (current design shows title, scripture, thumbnail, timestamp)
- Missing thumbnail placeholder style
- Whether to show a persistent offline banner on generator page

</decisions>

<specifics>
## Specific Ideas

- Same Brick patterns as Phase 2: @ConnectOfflineFirstWithSupabase, toDomain()/fromDomain(), alwaysHydrate for lists
- Generated stories use the existing Story entity (already has Brick model from Phase 2)
- Story chat conversations and translations need their own Brick models

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 03-story-generator-feature*
*Context gathered: 2026-01-29*
