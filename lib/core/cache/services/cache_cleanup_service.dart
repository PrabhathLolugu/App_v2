import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/cache/services/cache_size_monitor.dart';
import 'package:myitihas/core/cache/repositories/cache_config_repository.dart';
import 'package:myitihas/core/cache/managers/image_cache_manager.dart' as app_image;
import 'package:myitihas/core/cache/managers/video_cache_manager.dart' as app_video;
import 'package:myitihas/core/cache/managers/audio_cache_manager.dart' as app_audio;
import 'package:myitihas/core/logging/talker_setup.dart';

@lazySingleton
class CacheCleanupService {
  final CacheSizeMonitor _sizeMonitor;
  final CacheConfigRepository _configRepository;

  CacheCleanupService(this._sizeMonitor, this._configRepository);

  /// Run cleanup for all cache pools
  /// Called on app launch in main.dart
  Future<void> runCleanup() async {
    talker.info('Starting cache cleanup...');

    // Load user-configured byte limits
    final config = _configRepository.loadConfig();

    await _enforceByteLimit(
      app_image.ImageCacheManager.instance,
      app_image.ImageCacheManager.key,
      config.imageCacheSizeBytes,
    );

    await _enforceByteLimit(
      app_video.VideoCacheManager.instance,
      app_video.VideoCacheManager.key,
      config.videoCacheSizeBytes,
    );

    await _enforceByteLimit(
      app_audio.AudioCacheManager.instance,
      app_audio.AudioCacheManager.key,
      config.audioCacheSizeBytes,
    );

    talker.info('Cache cleanup completed');
  }

  /// Evict oldest files until cache size is under limit
  Future<void> _enforceByteLimit(
    CacheManager cacheManager,
    String cacheKey,
    int maxBytes,
  ) async {
    final cacheDir = await _sizeMonitor.getCacheDirectory(cacheKey);
    final currentSize = await _sizeMonitor.calculateCacheSize(cacheDir);

    if (currentSize <= maxBytes) {
      talker.debug(
        '$cacheKey: ${_sizeMonitor.formatBytes(currentSize)} / ${_sizeMonitor.formatBytes(maxBytes)}',
      );
      return;
    }

    talker.info(
      '$cacheKey exceeded limit: ${_sizeMonitor.formatBytes(currentSize)} / ${_sizeMonitor.formatBytes(maxBytes)}',
    );

    // Get all cached files with metadata
    final files = <FileInfo>[];
    try {
      await for (final fileInfo in cacheManager.getFileStream('', withProgress: false)) {
        if (fileInfo is FileInfo) files.add(fileInfo);
      }
    } catch (e) {
      talker.error('Failed to list cache files for $cacheKey', e);
      return;
    }

    // Sort by validTill (LRU - oldest first)
    files.sort((a, b) => a.validTill.compareTo(b.validTill));

    int bytesToFree = currentSize - maxBytes;
    int filesEvicted = 0;

    for (final fileInfo in files) {
      if (bytesToFree <= 0) break;

      try {
        final file = fileInfo.file;
        final fileSize = await file.length();

        await cacheManager.removeFile(fileInfo.originalUrl);
        bytesToFree -= fileSize;
        filesEvicted++;

        talker.debug('Evicted: ${fileInfo.originalUrl} (${_sizeMonitor.formatBytes(fileSize)})');
      } catch (e) {
        talker.error('Failed to evict file: ${fileInfo.originalUrl}', e);
      }
    }

    talker.info('$cacheKey: Evicted $filesEvicted files');
  }
}
