import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AudioCacheManager {
  static const key = 'myitihas_audio_cache';

  static final CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 14), // Audio cached for 2 weeks
      maxNrOfCacheObjects: 100, // Moderate number of audio files
      repo: JsonCacheInfoRepository(databaseName: key),
      fileSystem: IOFileSystem(key),
      fileService: HttpFileService(),
    ),
  );
}
