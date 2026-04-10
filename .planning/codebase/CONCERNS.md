# Codebase Concerns

**Analysis Date:** 2026-01-28

## Tech Debt

**Deprecated Theme System:**
- Issue: Legacy theme implementation in `lib/utils/theme.dart` and `lib/utils/constants.dart` marked as deprecated but still in use
- Files: `lib/utils/theme.dart`, `lib/utils/constants.dart`, `lib/pages/home_page.dart`
- Impact: Conflicting theme systems - old ThemeBloc coexists with new Material 3 theme in `lib/config/theme/app_theme.dart`, causing maintenance overhead and potential styling inconsistencies
- Fix approach: Complete migration to Material 3 ColorScheme and GradientExtension, remove deprecated files, update all references

**Inverted Theme Logic:**
- Issue: Theme initialization logic is inverted in `lib/utils/theme.dart` line 77: `isDark = (storage.getString('isDark')) != "true" ? true : false;` defaults to dark when storage says "not true"
- Files: `lib/utils/theme.dart`
- Impact: Confusing boolean logic that makes theme state unpredictable
- Fix approach: Simplify to `isDark = storage.getString('isDark') == "true"`

**Incomplete Settings Implementation:**
- Issue: Settings page has 7 TODOs for unimplemented features (upgrade plan, customize, settings, notifications, password & security, FAQ, contact us)
- Files: `lib/pages/settings_page.dart` (lines 83, 92, 101, 110, 119, 136, 145)
- Impact: Non-functional UI elements mislead users, appear as incomplete features
- Fix approach: Either implement functionality or remove/disable menu items until ready

**Placeholder Featured Stories:**
- Issue: Featured stories use hardcoded placeholder data instead of repository fetch
- Files: `lib/features/home/presentation/bloc/home_bloc.dart` (line 139)
- Impact: Users see fake/static data instead of real curated content
- Fix approach: Implement actual repository method to fetch featured stories from Supabase

**Missing Backend Support for Post Interactions:**
- Issue: Comments and shares not implemented for image/text posts, only stories
- Files: `lib/features/social/presentation/bloc/feed_bloc.dart` (lines 336, 354)
- Impact: Incomplete social features for non-story content types
- Fix approach: Extend backend schema and repository methods to support comments/shares on all content types

**Random Data for Error States:**
- Issue: When social data fetch fails, random numbers used as fallback (like count: 0-500, share count: 0-100)
- Files: `lib/features/social/presentation/bloc/feed_bloc.dart` (lines 479-504)
- Impact: Misleading engagement metrics shown to users when API fails
- Fix approach: Return zero or cached values on failure, don't fabricate data

**Incomplete API Client:**
- Issue: API client placeholder URL and missing auth token interceptor
- Files: `lib/core/network/api_client.dart` (lines 15, 41)
- Impact: External API integrations won't work without auth
- Fix approach: Configure actual API base URL via environment variable and implement token injection

**Notification Navigation Issue:**
- Issue: Chat notification navigation requires conversation ID but it's commented as not available
- Files: `lib/features/social/presentation/pages/notification_page.dart` (line 154)
- Impact: Users can't navigate to chat from notifications
- Fix approach: Include conversation_id in notification payload from backend

**User Selector Stubs:**
- Issue: Share/mention user selector dialogs not implemented in feed (4 instances)
- Files: `lib/features/social/presentation/pages/social_feed_page.dart` (lines 384, 592, 758, 882, 1022)
- Impact: Cannot tag users or share to specific people
- Fix approach: Implement user picker dialog component

## Known Bugs

**Large File Complexity:**
- Symptoms: `generated_story_detail_page.dart` is 2050 lines, difficult to maintain
- Files: `lib/features/story_generator/presentation/pages/generated_story_detail_page.dart`
- Trigger: Any modification to story detail UI becomes error-prone
- Workaround: None - requires refactoring

**StreamController Not Disposed:**
- Symptoms: Late-initialized StreamControllers in services may leak memory
- Files: `lib/services/chat_service.dart` (line 602), `lib/services/notification_service.dart` (line 228)
- Trigger: Service lifecycle not properly managed, streams created dynamically
- Workaround: Ensure proper disposal when streams complete

## Security Considerations

**Direct Supabase Client Usage in Features:**
- Risk: 36 direct references to `supabase.auth.currentUser` bypass service layer abstraction
- Files: Throughout `lib/services/` and some data sources in `lib/features/social/data/datasources/`
- Current mitigation: Data sources use SupabaseClient but not consistently through service layer
- Recommendations: Centralize all auth checks through `AuthService`, enforce architectural boundary between features and Supabase SDK

**No Environment Variable Validation:**
- Risk: Missing or invalid Supabase keys could fail silently at runtime
- Files: `lib/core/network/api_client.dart`, Supabase initialization in main
- Current mitigation: None
- Recommendations: Add startup validation for required environment variables (SUPABASE_URL, SUPABASE_ANON_KEY, API_BASE_URL)

**Gemini API Key in Edge Function:**
- Risk: Edge function requires GEMINI_API_KEY as secret, no validation code visible
- Files: `supabase/functions/generate-story/`
- Current mitigation: Stored as Supabase secret
- Recommendations: Add key rotation policy, implement rate limiting to prevent abuse

## Performance Bottlenecks

**N+1 Query Pattern in Social Enrichment:**
- Problem: Each story enrichment makes 5 separate repository calls (isLiked, likeCount, comments, shareCount, users)
- Files: `lib/features/social/presentation/bloc/feed_bloc.dart` (_enrichStoryWithSocialData method, lines 472-515)
- Cause: Sequential async calls not batched, happens for every story in feed
- Improvement path: Create single repository method to fetch all social data in one query, or use Supabase's nested select syntax

**Excessive Logging in Production:**
- Problem: Debug-level logging enabled throughout services (60+ logger.debug calls)
- Files: `lib/services/chat_service.dart`, `lib/services/post_service.dart`, `lib/services/notification_service.dart`, etc.
- Cause: Logger configured with LogLevel.verbose in debug mode but no filtering in release
- Improvement path: Use conditional compilation or log level configuration to disable verbose logs in production builds

**Generated Files Bloat:**
- Problem: 66 generated files (.g.dart, .freezed.dart) add significant build time
- Files: All features use freezed/json_serializable
- Cause: Code generation for every entity, model, event, state
- Improvement path: Consider build_runner watch mode during development, evaluate if all classes need freezed

## Fragile Areas

**Realtime Subscription Management:**
- Files: `lib/services/chat_service.dart`, `lib/services/realtime_service.dart`, `lib/features/social/presentation/bloc/feed_bloc.dart`
- Why fragile: Manual channel subscription/unsubscription, race conditions possible during rapid navigation
- Safe modification: Always pair subscribe with unsubscribe in same lifecycle (initState/dispose), use unique channel names
- Test coverage: Minimal - only widget_test.dart exists

**BLoC State Emit Guards:**
- Files: Multiple BLoCs use `if (!emit.isDone)` checks before emitting
- Why fragile: BLoC can be closed during async operations, emitting after close causes exceptions
- Safe modification: Always check emit.isDone before state emission in async handlers
- Test coverage: No BLoC unit tests found

**Deep Link Handling:**
- Files: `lib/services/auth_service.dart` (app_links integration)
- Why fragile: Deep link parsing for auth redirects depends on exact URL format
- Safe modification: Validate all URL parameters before using, handle malformed links gracefully
- Test coverage: None visible

**Custom Freezed Fork:**
- Files: `pubspec.yaml` uses forked freezed from GitHub (line 82)
- Why fragile: Dependency on custom fork at https://github.com/AmanSikarwar/freezed.git instead of pub.dev
- Safe modification: Document reason for fork, ensure fork stays updated with upstream
- Test coverage: Risk of incompatibility with other packages

## Scaling Limits

**Hive Local Storage:**
- Current capacity: No pagination for local data, all boxes loaded into memory
- Limit: Large local datasets (thousands of stories, messages) will cause memory issues
- Scaling path: Implement lazy loading for Hive boxes, add pagination to local data sources, consider SQLite for larger datasets

**Feed Pagination:**
- Current capacity: Fixed page size of 10 items, offset-based pagination
- Limit: Offset pagination breaks with real-time data insertion, inefficient at high offsets
- Scaling path: Migrate to cursor-based pagination using Supabase range queries

**Image Upload Without Compression Config:**
- Current capacity: Uses flutter_image_compress but no visible size/quality limits
- Limit: Users uploading large images could exhaust Supabase storage quota
- Scaling path: Enforce max file size (e.g., 5MB), implement progressive quality reduction

## Dependencies at Risk

**Custom Freezed Fork:**
- Risk: Using forked version instead of official pub.dev package
- Impact: May not receive security updates, incompatible with future Flutter SDK
- Migration plan: Identify reason for fork (check commit history), merge changes upstream or migrate back to official package

**Deprecated Dependencies:**
- Risk: `dartz` package used alongside `fpdart` (both functional programming libraries)
- Impact: Mixing two FP libraries is confusing, dartz is less actively maintained
- Migration plan: Standardize on fpdart (already primary choice), remove dartz, update all Either/Option imports

**Git Dependency for smooth_sheets:**
- Risk: Depends on GitHub URL not stable pub.dev version
- Impact: Broken if repository deleted, no semantic versioning guarantees
- Migration plan: Monitor for official pub.dev release, pin to specific git commit hash

## Missing Critical Features

**No Offline Error Recovery:**
- Problem: Network errors return failures but no offline queue or retry mechanism
- Blocks: Users losing data when network drops during post creation or chat send
- Priority: High - affects data integrity

**Missing Analytics/Crash Reporting:**
- Problem: No error tracking service (Sentry, Firebase Crashlytics) integrated
- Blocks: Cannot diagnose production crashes or monitor app health
- Priority: High - needed before production release

**No Media Caching Strategy:**
- Problem: CachedNetworkImage used but no cache size limits or eviction policy
- Blocks: App storage can grow unbounded
- Priority: Medium - impacts user device storage

**No Localization for Supabase Content:**
- Problem: i18n supports 4 languages (en, hi, ta, te) but Supabase story content not localized
- Blocks: Non-English users see English stories despite app localization
- Priority: Medium - core to user experience in non-English regions

## Test Coverage Gaps

**No BLoC/Cubit Tests:**
- What's not tested: All 15+ BLoCs and Cubits (feed_bloc, home_bloc, chat_detail_bloc, etc.)
- Files: `lib/features/*/presentation/bloc/*`
- Risk: Business logic changes can break functionality undetected
- Priority: High

**No Repository Tests:**
- What's not tested: All repository implementations in data layer
- Files: `lib/features/*/data/repositories/*_repository_impl.dart`
- Risk: Data transformation bugs, API contract changes undetected
- Priority: High

**No Service Layer Tests:**
- What's not tested: 11 services in `lib/services/` directory
- Files: All files in `lib/services/` except supabase_service.dart
- Risk: Critical functionality like chat, notifications, auth logic untested
- Priority: High

**No Integration Tests:**
- What's not tested: Full user flows (login → create post → like → comment)
- Files: No test/integration/ directory exists
- Risk: E2E scenarios can fail even if unit tests pass
- Priority: Medium

**No Widget Tests Beyond Boilerplate:**
- What's not tested: Only `test/widget_test.dart` exists (boilerplate)
- Files: No tests for complex widgets like feed cards, story detail pages
- Risk: UI regressions go unnoticed
- Priority: Medium

---

*Concerns audit: 2026-01-28*
