# Phase 6: Media Caching - Research

**Researched:** 2026-01-30
**Domain:** Flutter media caching with LRU eviction
**Confidence:** MEDIUM

## Summary

Flutter media caching requires a multi-library approach: `cached_network_image` (already installed) for images backed by `flutter_cache_manager` for LRU eviction, separate cache managers for video/audio files, `flutter_image_compress` (already installed) for client-side thumbnail generation, and `connectivity_plus` for WiFi-only download detection. The standard pattern uses custom `CacheManager` instances with independent `Config` objects to create separate storage pools for each media type.

The ecosystem heavily relies on `flutter_cache_manager` as the foundation - both `cached_network_image` and video caching solutions depend on it. This library provides built-in LRU eviction based on two factors: object count (`maxNrOfCacheObjects`) and age (`stalePeriod`). However, **critically**, it does NOT support byte-based size limits (no `maxCacheSize` parameter exists), requiring manual size monitoring and custom eviction logic.

**Primary recommendation:** Create three separate `CacheManager` instances (images, video, audio) with independent configurations, implement custom size monitoring using directory traversal, and build a background cleanup service that runs on app launch to enforce byte-based limits via manual eviction.

## Standard Stack

The established libraries/tools for this domain:

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| cached_network_image | 3.4.1+ | Image display with disk/memory caching | De facto standard, 11k+ pub points, backed by flutter_cache_manager |
| flutter_cache_manager | 3.4.1+ | LRU cache foundation for all media types | Powers cached_network_image, provides BaseCacheManager interface |
| flutter_image_compress | 2.3.0+ | Client-side image resizing/compression | Native performance (Obj-C/Kotlin), maintains aspect ratio |
| connectivity_plus | 6.1.0+ | Network type detection (WiFi/cellular) | Official Flutter Community package, cross-platform |
| path_provider | 2.1.5+ | Cache directory paths | Already installed, required for custom CacheManager setup |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| flutter_video_cache | 0.1.0+ | Video caching via proxy server | Transparent caching for video_player (AndroidVideoCache/KTVHTTPCache native libs) |
| just_audio | 0.9.0+ | Audio playback with LockCachingAudioSource | Experimental audio caching via local HTTP proxy |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| flutter_cache_manager | Custom SQLite + file storage | More control but lose battle-tested LRU logic, must implement eviction |
| cached_network_image | flutter_advanced_networkimage | Fewer features, less maintained (last update 2021) |
| flutter_video_cache | Manual download with Dio + video_player | Full control but must implement proxy, caching, and eviction from scratch |

**Installation:**
```bash
flutter pub add flutter_cache_manager connectivity_plus
# cached_network_image, flutter_image_compress, path_provider already installed
# flutter_video_cache optional - evaluate during planning
```

## Architecture Patterns

### Recommended Project Structure
```
lib/
├── core/
│   ├── cache/                    # Cache infrastructure
│   │   ├── managers/             # Custom CacheManager instances
│   │   │   ├── image_cache_manager.dart
│   │   │   ├── video_cache_manager.dart
│   │   │   └── audio_cache_manager.dart
│   │   ├── services/             # Cache operations
│   │   │   ├── cache_size_monitor.dart      # Directory size calculation
│   │   │   ├── cache_cleanup_service.dart   # Manual eviction logic
│   │   │   └── prefetch_service.dart        # Preemptive downloads
│   │   ├── models/               # Cache configuration
│   │   │   └── cache_config.dart            # User preferences (sliders)
│   │   └── repositories/
│   │       └── cache_repository.dart        # Abstract cache operations
├── features/
│   └── settings/
│       └── presentation/
│           └── pages/
│               └── cache_settings_page.dart # UI for sliders, usage display
```

### Pattern 1: Separate Storage Pools via Custom CacheManagers
**What:** Create independent `CacheManager` instances with unique keys and configs for each media type
**When to use:** Always - required for separate size limits and eviction per media type
**Example:**
```dart
// Source: https://pub.dev/packages/flutter_cache_manager
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ImageCacheManager {
  static const key = 'myitihas_image_cache';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 30),  // Don't auto-delete for 30 days
      maxNrOfCacheObjects: 500,                // Max 500 image files
      repo: JsonCacheInfoRepository(databaseName: key),
      fileSystem: IOFileSystem(key),
      fileService: HttpFileService(),
    ),
  );
}

class VideoCacheManager {
  static const key = 'myitihas_video_cache';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 7),   // Videos expire faster
      maxNrOfCacheObjects: 50,                 // Fewer video files
      repo: JsonCacheInfoRepository(databaseName: key),
      fileSystem: IOFileSystem(key),
      fileService: HttpFileService(),
    ),
  );
}

// Usage with cached_network_image
CachedNetworkImage(
  imageUrl: post.imageUrl,
  cacheManager: ImageCacheManager.instance,  // Use custom manager
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

### Pattern 2: Progressive Loading with Thumbnail Placeholder
**What:** Display compressed thumbnail immediately, load full-size in background, replace when ready
**When to use:** For images in lists (feed, stories, chat) to reduce perceived load time
**Example:**
```dart
// Source: https://pub.dev/packages/flutter_image_compress + https://pub.dev/packages/cached_network_image
import 'package:flutter_image_compress/flutter_image_compress.dart';

// Step 1: Generate thumbnail client-side after downloading full-size
Future<Uint8List?> createThumbnail(File fullSizeImage) async {
  return await FlutterImageCompress.compressWithFile(
    fullSizeImage.absolute.path,
    minWidth: 400,   // Thumbnail width
    minHeight: 400,  // Thumbnail height
    quality: 70,     // Lower quality for smaller size
  );
}

// Step 2: Use CachedNetworkImage with memCacheWidth for thumbnails
CachedNetworkImage(
  imageUrl: post.imageUrl,
  cacheManager: ImageCacheManager.instance,
  memCacheWidth: 400,  // Resize for in-memory cache (faster)
  maxWidthDiskCache: 1200,  // Resize before disk storage (saves space)
  maxHeightDiskCache: 1200,
  placeholder: (context, url) => Container(
    color: Colors.grey[300],
    child: Center(child: CircularProgressIndicator()),
  ),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

### Pattern 3: WiFi-Only Download Check
**What:** Check network type before triggering preemptive downloads
**When to use:** Before batch prefetch operations, respect user's data preferences
**Example:**
```dart
// Source: https://pub.dev/packages/connectivity_plus
import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> isWiFiAvailable() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult.contains(ConnectivityResult.wifi);
}

// Usage in prefetch service
Future<void> prefetchImages(List<String> urls, {required bool wifiOnlyMode}) async {
  if (wifiOnlyMode) {
    final hasWifi = await isWiFiAvailable();
    if (!hasWifi) {
      talker.info('Skipping prefetch - WiFi-only mode enabled and no WiFi');
      return;
    }
  }

  for (final url in urls) {
    await ImageCacheManager.instance.downloadFile(url);
  }
}
```

### Pattern 4: Preemptive Caching with Budget
**What:** Prefetch images when list data loads, limit number to avoid excessive downloads
**When to use:** After fetching feed/stories/chat data, before user scrolls to items
**Example:**
```dart
// Source: Flutter API https://api.flutter.dev/flutter/widgets/precacheImage.html
import 'package:flutter/widgets.dart';

Future<void> prefetchFeedImages(
  BuildContext context,
  List<Post> posts,
  {int maxPrefetch = 10}  // Budget: only first 10 items
) async {
  final imagesToPrefetch = posts
      .take(maxPrefetch)
      .map((post) => post.imageUrl)
      .where((url) => url.isNotEmpty)
      .toList();

  for (final url in imagesToPrefetch) {
    try {
      await precacheImage(
        CachedNetworkImageProvider(
          url,
          cacheManager: ImageCacheManager.instance,
        ),
        context,
      );
    } catch (e) {
      talker.error('Prefetch failed for $url', e);
      // Continue with other images
    }
  }
}
```

### Anti-Patterns to Avoid
- **Creating multiple CacheManager instances with same key:** Violates library contract, causes cache corruption and data loss. Always use unique keys per pool.
- **Prefetching without budget limits:** Can pin excessive images in memory, leading to out-of-memory crashes on Android. Always limit batch size (10-20 items max).
- **Assuming connectivity_plus guarantees internet access:** It only detects connection type, not actual internet availability. Always handle download failures gracefully.
- **Using flutter_cache_manager's maxNrOfCacheObjects for size control:** This limits object count, not bytes. A few large videos can still exceed storage limits.

## Don't Hand-Roll

Problems that look simple but have existing solutions:

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Image caching with disk persistence | Custom image downloader + file storage | cached_network_image + flutter_cache_manager | Handles memory cache, disk cache, eviction, loading states, error handling, image resolution switching |
| LRU eviction logic | Custom LRU tracking with timestamps | flutter_cache_manager's built-in LRU | Battle-tested across thousands of apps, handles stalePeriod + maxNrOfCacheObjects automatically |
| Video download proxy for caching | Dio downloads + manual video_player file management | flutter_video_cache | Provides transparent proxy (AndroidVideoCache/KTVHTTPCache), handles simultaneous play-and-cache |
| Network type detection | Platform channels for iOS/Android connectivity APIs | connectivity_plus | Official Flutter Community package, handles WiFi/cellular/ethernet/VPN/Bluetooth detection cross-platform |
| Image compression/resizing | Dart image processing libraries | flutter_image_compress | Native implementation (Obj-C/Kotlin) is 10-50x faster, maintains aspect ratio, supports EXIF rotation |

**Key insight:** Media caching looks deceptively simple ("just download and save files"), but production-ready solutions require: memory pressure handling, concurrent download coordination, atomic file writes, corruption recovery, cache key collision handling, and platform-specific optimizations. The established libraries have solved these problems through years of bug reports and edge cases.

## Common Pitfalls

### Pitfall 1: Assuming flutter_cache_manager Has Byte-Based Size Limits
**What goes wrong:** You configure `maxNrOfCacheObjects: 100` expecting 500MB limit, but 50 large videos fill 2GB of storage because the library only counts objects, not bytes.
**Why it happens:** Documentation mentions "cache size" ambiguously - it means object count, not disk space. There is no `maxCacheSize` parameter in the Config class.
**How to avoid:** Implement custom size monitoring by traversing cache directory and calculating total bytes, then manually trigger eviction via `removeFile()` when threshold exceeded.
**Warning signs:** User reports app consuming excessive storage despite low `maxNrOfCacheObjects` value.

### Pitfall 2: Creating Shared CacheManager Instances Across Isolates
**What goes wrong:** Multiple isolates create separate `CacheManager` instances with the same key, leading to SQLite database locks, corrupted cache metadata, and random download failures.
**Why it happens:** `CacheManager` is not isolate-safe - each instance creates its own SQLite connection and file system watcher.
**How to avoid:** Use singleton pattern with `static final instance` per media type, ensure all code paths use the same instance reference.
**Warning signs:** Intermittent SQLite errors in logs: "database is locked", "UNIQUE constraint failed".

### Pitfall 3: Prefetching Without Memory Budget Awareness
**What goes wrong:** App prefetches 50 high-res images on feed load, causing 200MB+ memory spike that triggers Android's Low Memory Killer, killing the app.
**Why it happens:** `precacheImage()` loads images into Dart's in-memory `ImageCache`. The Flutter docs warn: "Callers should be cautious about pinning large images or a large number of images in memory."
**How to avoid:** Limit prefetch batch size to 10-20 items, use `memCacheWidth`/`memCacheHeight` to reduce memory footprint, clear `ImageCache` after prefetch completes.
**Warning signs:** App crashes on low-end Android devices when loading feeds, no crash logs (process killed by OS).

### Pitfall 4: Ignoring Platform-Specific Cleartext Traffic Requirements for Caching Proxies
**What goes wrong:** Video/audio caching via `flutter_video_cache` or `just_audio` fails silently on Android 9+ because the local HTTP proxy uses `http://127.0.0.1:PORT` (cleartext), which is blocked by default.
**Why it happens:** Both libraries implement caching via local HTTP proxy servers. Android 9+ blocks cleartext (non-HTTPS) traffic unless explicitly allowed in `AndroidManifest.xml` via `android:usesCleartextTraffic="true"` or network security config.
**How to avoid:** If using video/audio caching proxies, add cleartext config to `android/app/src/main/AndroidManifest.xml` and iOS `Info.plist`. Document why cleartext is needed (local proxy only).
**Warning signs:** Videos/audio play directly from URLs but fail when wrapped in caching proxy, no network error messages.

### Pitfall 5: Not Handling Cache Directory Migration Across App Updates
**What goes wrong:** After app update, cache keys or directory structure changes, orphaning 500MB+ of cached files that are never cleaned up, wasting user storage permanently.
**Why it happens:** `flutter_cache_manager` stores files in `{cacheDir}/{key}/`, changing the key breaks the reference. Old directory persists indefinitely.
**How to avoid:** Use stable, version-agnostic cache keys (`myitihas_image_cache`, not `image_cache_v2`). If migration needed, implement manual cleanup of old directories on first launch after update.
**Warning signs:** User storage consumption grows after updates but cache settings show lower usage, discrepancy between displayed vs actual disk usage.

### Pitfall 6: Separate Thumbnail Storage Consuming Excessive Space
**What goes wrong:** Implementation stores both full-size (2MB) and thumbnail (200KB) for every image, doubling storage use and defeating the purpose of size limits.
**Why it happens:** Decision context specified "thumbnails generated client-side after downloading full-size" but didn't clarify storage strategy.
**How to avoid:** Per CONTEXT.md decision: "When full-size is cached, thumbnail is replaced (not kept alongside)". Generate thumbnails on-demand from cached full-size images, don't persist separately.
**Warning signs:** Cache directory grows faster than expected, multiple files per URL in cache (e.g., `image.jpg` and `image_thumb.jpg`).

## Code Examples

Verified patterns from official sources:

### Custom CacheManager Configuration
```dart
// Source: https://pub.dev/packages/flutter_cache_manager
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImageCacheManager {
  static const key = 'myitihas_image_cache';

  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 500,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileSystem: IOFileSystem(key),
      fileService: HttpFileService(),
    ),
  );
}

// Get cache directory for size monitoring
Future<Directory> getImageCacheDirectory() async {
  final cacheDir = await getTemporaryDirectory();
  return Directory(path.join(cacheDir.path, ImageCacheManager.key));
}
```

### Manual Cache Size Calculation
```dart
// Calculate total size of cache directory in bytes
Future<int> calculateCacheSize(Directory cacheDir) async {
  int totalSize = 0;

  try {
    if (!await cacheDir.exists()) return 0;

    await for (final entity in cacheDir.list(recursive: true)) {
      if (entity is File) {
        totalSize += await entity.length();
      }
    }
  } catch (e) {
    talker.error('Failed to calculate cache size', e);
  }

  return totalSize;
}

// Format bytes for display in settings
String formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
  return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
}
```

### Manual LRU Eviction to Enforce Byte Limit
```dart
// Evict oldest files until cache size is under limit
Future<void> enforceByteLimit(
  CacheManager cacheManager,
  Directory cacheDir,
  int maxBytes,
) async {
  final currentSize = await calculateCacheSize(cacheDir);

  if (currentSize <= maxBytes) return;

  // Get all cached files with metadata
  final files = <FileInfo>[];
  await for (final fileInfo in cacheManager.getFileStream('', withProgress: false)) {
    if (fileInfo is FileInfo) files.add(fileInfo);
  }

  // Sort by last access time (oldest first)
  files.sort((a, b) => a.validTill.compareTo(b.validTill));

  int bytesToFree = currentSize - maxBytes;

  for (final fileInfo in files) {
    if (bytesToFree <= 0) break;

    final file = fileInfo.file;
    final fileSize = await file.length();

    await cacheManager.removeFile(fileInfo.originalUrl);
    bytesToFree -= fileSize;

    talker.debug('Evicted ${fileInfo.originalUrl} (${formatBytes(fileSize)})');
  }
}
```

### Preemptive Image Prefetch with WiFi Check
```dart
// Source: https://api.flutter.dev/flutter/widgets/precacheImage.html + https://pub.dev/packages/connectivity_plus
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';

Future<void> prefetchImagesIfWiFi(
  BuildContext context,
  List<String> imageUrls,
  {required bool wifiOnlyMode, int maxPrefetch = 10}
) async {
  if (wifiOnlyMode) {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (!connectivityResult.contains(ConnectivityResult.wifi)) {
      talker.info('Skipping prefetch - WiFi-only mode and no WiFi');
      return;
    }
  }

  final urlsToPrefetch = imageUrls.take(maxPrefetch);

  for (final url in urlsToPrefetch) {
    try {
      await precacheImage(
        CachedNetworkImageProvider(
          url,
          cacheManager: ImageCacheManager.instance,
        ),
        context,
      );
    } catch (e) {
      talker.error('Prefetch failed for $url', e);
      // Continue with remaining images
    }
  }
}
```

### Client-Side Thumbnail Generation
```dart
// Source: https://pub.dev/packages/flutter_image_compress
import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<Uint8List?> generateThumbnail(
  File fullSizeImage,
  {int maxWidth = 400, int maxHeight = 400, int quality = 70}
) async {
  return await FlutterImageCompress.compressWithFile(
    fullSizeImage.absolute.path,
    minWidth: maxWidth,
    minHeight: maxHeight,
    quality: quality,
  );
}
```

### Video Caching Setup
```dart
// Source: https://context7.com/linxunfeng/flutter_video_cache/llms.txt
import 'package:video_cache/video_cache.dart';
import 'package:video_player/video_player.dart';

Future<VideoPlayerController> createCachedVideoPlayer(String url) async {
  String cachedUrl = url;

  try {
    cachedUrl = await VideoCache().convertToCacheProxyUrl(url);
    talker.info('Using cached video URL: $cachedUrl');
  } catch (e) {
    talker.error('Video cache conversion failed, using original URL', e);
  }

  final controller = VideoPlayerController.networkUrl(Uri.parse(cachedUrl));
  await controller.initialize();
  return controller;
}
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| extended_image for caching | cached_network_image + flutter_cache_manager | 2020-2021 | cached_network_image became standard due to simpler API and better maintenance |
| Manual file downloads with Dio | Specialized cache managers per media type | 2021-2022 | Dedicated libraries handle edge cases (memory pressure, corruption, concurrent access) |
| Server-side thumbnail generation | Client-side with flutter_image_compress | 2022+ | Reduces server costs, works offline, faster (no network round-trip) |
| Single global cache for all media | Separate pools per media type | 2023+ | Independent size limits prevent video files from starving image cache |

**Deprecated/outdated:**
- **flutter_advanced_networkimage**: Last updated 2021, use cached_network_image instead
- **ImageCache.maximumSize and ImageCache.maximumSizeBytes manual tuning**: Flutter now auto-adjusts based on device memory since Flutter 2.5
- **Manual SQLite database for cache metadata**: flutter_cache_manager's JsonCacheInfoRepository is the standard

## Open Questions

Things that couldn't be fully resolved:

1. **Byte-based size limits in flutter_cache_manager**
   - What we know: Library only supports `maxNrOfCacheObjects` (count-based), not byte-based limits
   - What's unclear: Whether there's an undocumented parameter or planned feature for `maxCacheSize`
   - Recommendation: Implement custom size monitoring + manual eviction as shown in code examples. Mark as LOW confidence - verify with flutter_cache_manager GitHub issues/roadmap during planning.

2. **flutter_video_cache production readiness**
   - What we know: Library exists, has 14 code snippets in Context7, uses native caching libs (AndroidVideoCache/KTVHTTPCache)
   - What's unclear: Pub.dev score, last update date, active maintenance status, user reviews
   - Recommendation: During planning, check pub.dev page for version history and health score. May need fallback to manual Dio downloads + video_player if unmaintained.

3. **just_audio LockCachingAudioSource stability**
   - What we know: Feature is marked "experimental" in official docs, requires cleartext traffic config
   - What's unclear: Whether it's production-ready or still has known issues
   - Recommendation: Test on real devices during implementation. Consider simpler approach: download audio files with Dio + flutter_cache_manager, play from local file paths.

4. **Background cleanup timing**
   - What we know: Should run "on app launch" and "when cache full" per CONTEXT.md
   - What's unclear: Optimal frequency for background checks, whether to use WorkManager for periodic cleanup
   - Recommendation: Start with on-launch cleanup only. Monitor user feedback for storage issues. Add periodic cleanup if needed. Avoid WorkManager unless battery impact is acceptable.

## Sources

### Primary (HIGH confidence)
- Context7: `/websites/pub_dev-cached_network_image` - Cache configuration, eviction, progressive loading
- Context7: `/websites/pub_dev_video_player` - Video playback integration
- Context7: `/linxunfeng/flutter_video_cache` - Video caching proxy patterns
- Official docs: https://pub.dev/packages/flutter_cache_manager - Custom CacheManager config, LRU behavior
- Official docs: https://pub.dev/packages/connectivity_plus - WiFi/cellular detection
- Official docs: https://pub.dev/packages/just_audio - Audio caching with LockCachingAudioSource
- Official docs: https://pub.dev/packages/flutter_image_compress - Thumbnail generation
- Flutter API: https://api.flutter.dev/flutter/widgets/precacheImage.html - Prefetch patterns

### Secondary (MEDIUM confidence)
- WebFetch findings verified against multiple official package pages
- Existing codebase usage of cached_network_image in `lib/features/social/presentation/widgets/image_post_card.dart`

### Tertiary (LOW confidence)
- WebSearch results for Flutter caching patterns (no direct authoritative sources returned, rely on official docs instead)

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - All libraries verified via Context7 or official pub.dev documentation
- Architecture: MEDIUM - Patterns confirmed in official docs, but separate pools architecture is inferred from combining multiple sources
- Pitfalls: MEDIUM - Based on official documentation warnings and common Flutter community knowledge, not first-hand production data
- Byte-based size limits: LOW - Confirmed flutter_cache_manager lacks this feature, but custom implementation approach is untested

**Research date:** 2026-01-30
**Valid until:** 2026-02-28 (30 days - ecosystem is mature and stable)
