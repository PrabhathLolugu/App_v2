import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:myitihas/core/logging/talker_setup.dart';

@lazySingleton
class CacheSizeMonitor {
  /// Calculate total size of cache directory in bytes
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

  /// Get cache directory for a specific cache key
  Future<Directory> getCacheDirectory(String cacheKey) async {
    final tempDir = await getTemporaryDirectory();
    return Directory(path.join(tempDir.path, cacheKey));
  }

  /// Format bytes for human-readable display in settings
  String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}
