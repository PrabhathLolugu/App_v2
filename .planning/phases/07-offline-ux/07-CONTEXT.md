# Phase 7: Offline UX - Context

**Gathered:** 2026-01-30
**Status:** Ready for planning

<domain>
## Phase Boundary

Users receive clear feedback about connectivity status and disabled actions when offline. Data syncs automatically when connectivity is restored, with user feedback.

</domain>

<decisions>
## Implementation Decisions

### Connectivity indicator
- **Display:** Banner (full-width bar)
- **Position:** Top (below app bar), pushing content down
- **Dismissibility:** Persistent (stays until back online)
- **Visual Style:** Warning style (Red/orange background, high contrast)

### Disabled action feedback
- **Button Behavior:** Visually disabled (looks disabled)
- **Visual State:** Greyscale + Opacity
- **On Tap:** Show explanation toast/snackbar
- **Message Tone:** Short & Tech (e.g., "Offline mode", "Not available offline")

### Transition handling
- **Going Offline:** Silent UI update (Banner appears, no intrusive alert)
- **Going Online:** Success toast ("Back online")
- **Flakiness:** Debounce offline state (wait 2-3s before showing offline UI)
- **Sync Priority:** Smart/Visible first (sync current screen content, then background)

### Sync visibility
- **Progress:** Subtle indeterminate line (e.g., linear progress indicator at top)
- **Completion:** Passive timestamp (e.g., "Last updated: just now")
- **Error Handling:** Toast + Retry button for failed syncs
- **Manual Trigger:** Pull-to-refresh on lists triggers sync

### Claude's Discretion
- Exact color palette for warning banner (matches app warning/error colors)
- Animation curves for banner appearance/disappearance
- Specific wording of error messages

</decisions>

<specifics>
## Specific Ideas

- "I want it to feel like linear's offline mode - clear but not annoying" (Inferred from "Silent UI update" + "Persistent")
- Debouncing is critical to avoid "strobe light" effect on bad connections

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 07-offline-ux*
*Context gathered: 2026-01-30*
