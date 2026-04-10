---
phase: 07-offline-ux
plan: 02
subsystem: core-presentation
tags: [offline-ux, buttons, widgets, bloc-consumer, connectivity]
requires: [07-01-connectivity-management]
provides: [offline-aware-button-components, greyscale-disabled-state, offline-feedback-snackbars]
affects: [07-03-feature-integration, social-feed-offline-ui, chat-offline-ui]
tech-stack:
  added: []
  patterns: [offline-aware-widget-wrappers, bloc-builder-connectivity-checks]
decisions: []
key-files:
  created:
    - lib/core/presentation/widgets/offline_aware_button.dart
    - lib/core/presentation/widgets/offline_aware_icon_button.dart
  modified: []
metrics:
  duration: 1.5min
  completed: 2026-01-30
---

# Phase 07 Plan 02: Offline-Aware Button Widgets Summary

**One-liner:** Reusable OfflineAwareButton and OfflineAwareIconButton widgets with greyscale styling, reduced opacity when offline, and error SnackBar feedback on tap

## What Was Built

Created reusable button wrapper widgets that automatically disable when offline and provide clear visual + interactive feedback to users attempting write actions without connectivity.

### Key Components

**1. OfflineAwareButton (ElevatedButton Wrapper)**
- Wraps ElevatedButton with BlocBuilder<ConnectivityBloc, ConnectivityState>
- Visual feedback when offline:
  - backgroundColor: Colors.grey.withValues(alpha: 0.5)
  - foregroundColor: Colors.grey.shade700
  - Opacity widget wrapping child: 0.5
- Interactive feedback when tapped offline:
  - Shows SnackBar with error color
  - Customizable message via offlineMessage parameter (default: 'Not available offline')
  - 2-second duration
- Parameters:
  - required VoidCallback? onPressed
  - required Widget child
  - String offlineMessage (default: 'Not available offline')
  - ButtonStyle? style (merged with offline styling)

**2. OfflineAwareIconButton (IconButton Wrapper)**
- Wraps IconButton with BlocBuilder<ConnectivityBloc, ConnectivityState>
- Visual feedback when offline:
  - color: Colors.grey (overrides provided color)
  - Opacity widget wrapping icon: 0.5
- Interactive feedback when tapped offline:
  - Shows SnackBar with error color (same as button)
  - Customizable message via offlineMessage parameter (default: 'Offline mode')
  - 2-second duration
- Parameters:
  - required VoidCallback? onPressed
  - required Widget icon
  - String offlineMessage (default: 'Offline mode')
  - Color? color (optional, becomes grey when offline)
  - double? iconSize (optional)

### Design Pattern

**Reactive Connectivity Checks:**
```dart
return BlocBuilder<ConnectivityBloc, ConnectivityState>(
  builder: (context, state) {
    final isOnline = state is ConnectivityOnline;
    // Apply offline styling and disable interactions
  },
);
```

**Offline Tap Handler:**
```dart
onPressed: isOnline
    ? onPressed
    : (onPressed != null ? () => _showOfflineSnackBar(context) : null),
```

This pattern ensures:
- Disabled buttons (onPressed == null originally) remain disabled offline
- Active buttons show helpful feedback when tapped offline
- Online buttons work normally

## Technical Decisions

### Style Merging vs Override
**Decision:** OfflineAwareButton merges provided ButtonStyle with offline styling using copyWith
**Rationale:** Preserves developer customizations (padding, shape, elevation) while applying offline colors
**Implementation:** `effectiveStyle = style ?? const ButtonStyle(); effectiveStyle.copyWith(...)`

### Opacity on Child vs Icon Widget
**Decision:** Wrap child/icon in Opacity widget rather than using alpha channel on colors
**Rationale:** More consistent cross-platform rendering, works with any widget type
**Tradeoff:** Additional widget in tree, but negligible performance impact

### Separate Icon Button Widget
**Decision:** Create OfflineAwareIconButton instead of single unified widget
**Rationale:** IconButton and ElevatedButton have incompatible APIs (icon vs child, no style param on IconButton)
**Alternative Considered:** Builder function parameter → rejected for type safety and API clarity

### Error Color for SnackBar
**Decision:** Use Theme.of(context).colorScheme.error for offline SnackBar background
**Rationale:** Consistent with app error messaging, respects theme (light/dark mode)
**Accessibility:** Error color ensures sufficient contrast for text visibility

## Integration Points

### With ConnectivityBloc
- Reactive state via BlocBuilder<ConnectivityBloc, ConnectivityState>
- Check `state is ConnectivityOnline` for binary online/offline decision
- No direct event dispatching (read-only consumption)

### With Scaffold Messenger
- ScaffoldMessenger.of(context).showSnackBar() for feedback
- Requires widget to be in Scaffold context hierarchy
- Auto-dismisses after 2 seconds

### Usage Pattern for Features
```dart
// Replace standard ElevatedButton
OfflineAwareButton(
  onPressed: () => context.read<PostBloc>().add(CreatePost()),
  child: Text('Submit Post'),
  offlineMessage: 'Cannot create posts offline',
)

// Replace standard IconButton for write actions
OfflineAwareIconButton(
  onPressed: () => context.read<PostBloc>().add(LikePost()),
  icon: Icon(Icons.favorite),
  color: Colors.red,
  offlineMessage: 'Likes require internet',
)
```

## Files Created

### Core Widgets
- `lib/core/presentation/widgets/offline_aware_button.dart` (82 lines)
  - OfflineAwareButton class
  - BlocBuilder integration
  - Greyscale styling logic
  - SnackBar feedback helper

- `lib/core/presentation/widgets/offline_aware_icon_button.dart` (76 lines)
  - OfflineAwareIconButton class
  - BlocBuilder integration
  - Color override logic
  - SnackBar feedback helper

## Verification Results

### Code Analysis
```bash
flutter analyze lib/core/presentation/widgets/
# Result: No issues found
```

### Manual Testing Checklist (Plan 03 Integration)
- [ ] OfflineAwareButton appears normal when online, onPressed works
- [ ] Enable airplane mode → button greyscale with opacity 0.5
- [ ] Tap offline button → red SnackBar shows with custom message
- [ ] OfflineAwareIconButton shows grey icon when offline
- [ ] Tap offline icon → SnackBar appears

## Dependencies Added

None - uses existing dependencies:
- flutter/material (standard Flutter)
- flutter_bloc (already in project)
- ConnectivityBloc (from 07-01)

## Known Issues

None

## Next Phase Readiness

### Enables 07-03 (Feature Integration)
- OfflineAwareButton ready for use in create post, comment forms
- OfflineAwareIconButton ready for like, share, bookmark actions
- Standardized offline UX across all write actions
- No additional offline checks needed in feature BLoCs (handled by widgets)

### Provides
- **Standardized offline button UX:** Greyscale + opacity visual feedback
- **Helpful error messaging:** Snackbar explains why action unavailable
- **Zero boilerplate:** Drop-in replacement for ElevatedButton/IconButton
- **Reactive connectivity:** Automatic re-enabling when online

### Technical Patterns Established
1. **BlocBuilder for connectivity:** All offline-aware widgets use same pattern
2. **Snackbar for feedback:** Consistent error messaging approach
3. **Opacity + greyscale combo:** Visual standard for disabled state
4. **Customizable messages:** Each button can explain its specific constraint

## Deviations from Plan

None - plan executed exactly as written.

## Commits

| Task | Commit | Message |
|------|--------|---------|
| 1 | 3196bcb | feat(07-02): create OfflineAwareButton widget |
| 2 | a82c4c0 | feat(07-02): create OfflineAwareIconButton widget |

## Performance Notes

**Execution Time:** 1.5 minutes
**Widget Performance:** Minimal - single BlocBuilder per button, O(1) state check
**Build Cost:** No code generation required (pure widgets, no freezed/injectable)

## Future Enhancements

1. **Tooltip when offline:** Show tooltip on hover explaining why disabled
2. **Loading state support:** Add isLoading parameter to show progress indicator
3. **Retry action:** Allow buttons to trigger connectivity check on tap
4. **Custom disabled styling:** Allow per-button override of greyscale colors
5. **Accessibility labels:** Add semantics for screen readers ("Disabled - offline")
6. **Animation on state change:** Subtle fade when transitioning online/offline
