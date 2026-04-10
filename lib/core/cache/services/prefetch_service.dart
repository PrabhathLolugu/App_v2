import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/cache/managers/image_cache_manager.dart';
import 'package:myitihas/core/cache/repositories/cache_config_repository.dart';
import 'package:myitihas/core/logging/talker_setup.dart';

@lazySingleton
class PrefetchService {
  final CacheConfigRepository _configRepository;

  PrefetchService(this._configRepository);

  /// Prefetch images with WiFi detection and budget limits
  /// Call this after loading list data in BLoCs (feed, stories, etc.)
  Future<void> prefetchImages(
    BuildContext context,
    List<String> imageUrls, {
    int maxPrefetch = 10,  // Default budget: 10 items
  }) async {
    if (imageUrls.isEmpty) return;

    // Load user preferences
    final config = _configRepository.loadConfig();

    // Check WiFi if WiFi-only mode enabled
    if (config.wifiOnlyMode) {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (!context.mounted) return;
      if (!connectivityResult.contains(ConnectivityResult.wifi)) {
        talker.info('Skipping prefetch - WiFi-only mode enabled and no WiFi');
        return;
      }
    }

    if (!context.mounted) return;

    // Apply budget limit and filter for network URLs only
    final urlsToPrefetch = imageUrls
        .where((url) => url.startsWith('http://') || url.startsWith('https://'))
        .take(maxPrefetch);

    talker.debug('Prefetching ${urlsToPrefetch.length} images...');

    int successCount = 0;
    for (final url in urlsToPrefetch) {
      // Stop if the widget was disposed (e.g. user navigated away)
      if (!context.mounted) {
        talker.debug('Prefetch cancelled - widget unmounted');
        break;
      }
      try {
        await precacheImage(
          CachedNetworkImageProvider(
            url,
            cacheManager: ImageCacheManager.instance,
          ),
          context,
        );
        successCount++;
      } catch (e) {
        // Log at debug to avoid noise; context may be deactivated
        if (context.mounted) {
          talker.error('Prefetch failed for $url', e);
        }
        // Continue with remaining images only if still mounted
        if (!context.mounted) break;
      }
    }

    if (context.mounted) {
      talker.debug('Prefetched $successCount/${urlsToPrefetch.length} images');
    }
  }
}
