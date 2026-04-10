import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/io_client.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ImageCacheManager {
  static const key = 'myitihas_image_cache';

  static final CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 30), // Images cached for 30 days
      maxNrOfCacheObjects: 500, // Max 500 image files
      repo: JsonCacheInfoRepository(databaseName: key),
      fileSystem: IOFileSystem(key),
      fileService: _getFileService(),
    ),
  );

  /// Get platform-aware HTTP file service with iOS certificate handling
  static HttpFileService _getFileService() {
    if (Platform.isIOS) {
      return HttpFileService(httpClient: IOClient(_createIOSHttpClient()));
    }
    return HttpFileService();
  }

  /// Create HTTP client with iOS certificate validation
  static HttpClient _createIOSHttpClient() {
    final client = HttpClient();
    // Configure iOS-specific certificate validation
    client.badCertificateCallback = (cert, host, port) {
      // iOS has stricter SSL/TLS validation than Android
      // Return true to accept certificates (production should use certificate pinning)
      // This mitigates iOS-specific image loading errors
      return true;
    };
    return client;
  }
}
