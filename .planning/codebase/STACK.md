# Technology Stack

**Analysis Date:** 2026-01-28

## Languages

**Primary:**
- Dart ^3.10.0 - Application code, domain logic, UI
- TypeScript - Supabase Edge Functions

**Secondary:**
- Kotlin - Android native code (JVM Toolchain 17)
- SQL - Database schema and queries

## Runtime

**Environment:**
- Flutter SDK (latest stable) - Cross-platform UI framework
- Deno - Serverless runtime for Supabase Edge Functions

**Package Manager:**
- pub (Flutter) - Dart dependency management via `pubspec.yaml`
- npm - Deno dependencies in Edge Functions

**Lockfile:**
- `pubspec.lock` - Present and tracked

## Frameworks

**Core:**
- Flutter (SDK) - Mobile UI framework for iOS/Android
- Bloc ^9.1.0 - State management pattern
- Flutter BLoC ^9.1.1 - Flutter integration for BLoC

**Routing:**
- go_router ^17.0.1 - Declarative routing
- go_router_builder ^4.1.3 - Code generation for type-safe routes

**State Management:**
- bloc ^9.1.0 - Business logic component pattern
- flutter_bloc ^9.1.1 - BLoC Flutter integration
- equatable ^2.0.7 - Value equality without boilerplate

**Testing:**
- flutter_test (SDK) - Widget and unit testing
- flutter_lints ^6.0.0 - Recommended lint rules

**Build/Dev:**
- build_runner ^2.10.4 - Code generation orchestrator
- freezed (git) - Immutable data classes and unions
- json_serializable ^6.11.3 - JSON serialization code gen
- injectable_generator ^2.12.0 - Dependency injection code gen
- slang_build_runner ^4.11.0 - i18n code generation
- hive_ce_generator ^1.10.1 - Local storage type adapters

## Key Dependencies

**Critical:**
- supabase_flutter ^2.5.6 - Backend-as-a-Service client, authentication, database, realtime
- hive_ce ^2.15.1 - Offline-first local NoSQL database
- hive_ce_flutter ^2.3.3 - Flutter integration for Hive
- dio ^5.9.0 - HTTP client for REST APIs
- fpdart ^1.2.0 - Functional programming (Either, Option types)
- get_it ^9.2.0 - Service locator for dependency injection
- injectable ^2.7.1 - Compile-time dependency injection annotations

**UI/UX:**
- flutter_screenutil ^5.9.3 - Responsive UI scaling
- sizer ^3.1.3 - Responsive sizing utilities
- google_fonts ^6.3.3 - Google Fonts integration
- cached_network_image ^3.4.1 - Image caching and loading
- flutter_svg ^2.0.10+1 - SVG rendering
- shimmer ^3.0.0 - Shimmer loading effects
- animations ^2.1.1 - Pre-built animation widgets
- smooth_page_indicator ^2.0.1 - Page indicators
- getwidget ^7.0.0 - Pre-built UI components
- font_awesome_flutter ^10.12.0 - Icon set
- gradient_borders ^1.0.2 - Gradient border widgets
- rich_readmore ^1.1.1 - Expandable text widget
- readmore ^3.0.0 - Text expansion widget
- smooth_sheets (git) - Custom bottom sheets

**Internationalization:**
- slang ^4.11.1 - Type-safe i18n framework
- slang_flutter ^4.11.0 - Flutter integration
- intl ^0.20.2 - Internationalization utilities

**Logging/Debugging:**
- talker ^5.1.9 - Logging framework
- talker_flutter ^5.1.9 - Flutter UI for logs
- talker_bloc_logger ^5.1.9 - BLoC event/state logging
- talker_dio_logger ^5.1.9 - HTTP request/response logging

**Device Integration:**
- shared_preferences ^2.5.4 - Key-value storage
- path_provider ^2.1.5 - File system paths
- app_links ^6.4.1 - Deep linking support
- permission_handler ^12.0.1 - Runtime permissions
- image_picker - Image selection from gallery/camera
- flutter_image_compress ^2.3.0 - Image compression
- video_player ^2.10.1 - Video playback
- flutter_tts ^4.2.3 - Text-to-speech
- share_plus ^12.0.1 - Native share sheet
- flutter_file_dialog ^3.0.3 - File picker dialogs

**Infrastructure:**
- sqflite ^2.4.2 - SQLite database (used alongside Hive)
- internet_connection_checker_plus ^2.9.1 - Network connectivity detection
- timeago ^3.7.1 - Relative time formatting

**Legacy/Compatibility:**
- dartz ^0.10.0 - Functional programming (older patterns)
- get ^4.7.3 - State management/routing (limited usage)
- cupertino_icons ^1.0.8 - iOS-style icons

## Configuration

**Environment:**
- Hardcoded Supabase credentials in `lib/main.dart` (lines 37-41)
- API_BASE_URL available via `--dart-define` (default: https://api.myitihas.com)
- No `.env` file pattern detected

**Build:**
- `pubspec.yaml` - Dependency manifest
- `analysis_options.yaml` - Dart analyzer configuration (flutter_lints)
- `slang.yaml` - i18n configuration (4 locales: en, hi, ta, te)
- `android/app/build.gradle.kts` - Android build config (Kotlin DSL)

**Code Generation:**
```bash
dart run build_runner build --delete-conflicting-outputs  # Full rebuild
dart run build_runner watch --delete-conflicting-outputs  # Watch mode
dart run slang                                             # i18n only
```

**Assets:**
- `assets/` - General assets
- `assets/images/` - Image assets
- `assets/data/` - Data files
- `docs/dataset.json` - Dataset reference

## Platform Requirements

**Development:**
- Flutter SDK ^3.10.0
- Dart SDK ^3.10.0
- Android Studio / Xcode for platform builds
- JDK 17 (Android)

**Production:**
- Android: minSdk 21+ (from flutter.minSdkVersion)
- Android: targetSdk 35+ (from flutter.targetSdkVersion)
- Android: compileSdk 35 (from flutter.compileSdkVersion)
- iOS: Deployment target TBD (check ios/Podfile)
- Package ID: `com.example.myitihas`

**Edge Functions:**
- Deno runtime
- npm packages via esm.sh

---

*Stack analysis: 2026-01-28*
