import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/cache/models/cache_config.dart';
import 'package:myitihas/core/cache/repositories/cache_config_repository.dart';
import 'package:myitihas/core/cache/services/cache_size_monitor.dart';
import 'package:myitihas/core/cache/services/cache_cleanup_service.dart';
import 'package:myitihas/core/cache/managers/image_cache_manager.dart' as app_image;
import 'package:myitihas/core/cache/managers/video_cache_manager.dart' as app_video;
import 'package:myitihas/core/cache/managers/audio_cache_manager.dart' as app_audio;
import 'package:myitihas/core/logging/talker_setup.dart';
import 'cache_settings_event.dart';
import 'cache_settings_state.dart';

@injectable
class CacheSettingsBloc extends Bloc<CacheSettingsEvent, CacheSettingsState> {
  final CacheConfigRepository _configRepository;
  final CacheSizeMonitor _sizeMonitor;
  final CacheCleanupService _cleanupService;

  CacheSettingsBloc(
    this._configRepository,
    this._sizeMonitor,
    this._cleanupService,
  ) : super(CacheSettingsState.initial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<UpdateImageCacheSizeEvent>(_onUpdateImageCacheSize);
    on<UpdateVideoCacheSizeEvent>(_onUpdateVideoCacheSize);
    on<UpdateAudioCacheSizeEvent>(_onUpdateAudioCacheSize);
    on<ToggleWifiOnlyEvent>(_onToggleWifiOnly);
    on<ClearCacheEvent>(_onClearCache);
    on<RefreshUsageEvent>(_onRefreshUsage);
  }

  Future<void> _onLoadSettings(LoadSettingsEvent event, Emitter<CacheSettingsState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      final config = _configRepository.loadConfig();
      await _refreshUsage(emit, config);
    } catch (e) {
      talker.error('Failed to load cache settings', e);
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdateImageCacheSize(UpdateImageCacheSizeEvent event, Emitter<CacheSettingsState> emit) async {
    await _updateConfig(emit, state.config.copyWith(imageCacheSizeBytes: event.sizeBytes));
  }

  Future<void> _onUpdateVideoCacheSize(UpdateVideoCacheSizeEvent event, Emitter<CacheSettingsState> emit) async {
    await _updateConfig(emit, state.config.copyWith(videoCacheSizeBytes: event.sizeBytes));
  }

  Future<void> _onUpdateAudioCacheSize(UpdateAudioCacheSizeEvent event, Emitter<CacheSettingsState> emit) async {
    await _updateConfig(emit, state.config.copyWith(audioCacheSizeBytes: event.sizeBytes));
  }

  Future<void> _onToggleWifiOnly(ToggleWifiOnlyEvent event, Emitter<CacheSettingsState> emit) async {
    await _updateConfig(emit, state.config.copyWith(wifiOnlyMode: event.enabled));
  }

  Future<void> _onClearCache(ClearCacheEvent event, Emitter<CacheSettingsState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      await app_image.ImageCacheManager.instance.emptyCache();
      await app_video.VideoCacheManager.instance.emptyCache();
      await app_audio.AudioCacheManager.instance.emptyCache();

      talker.info('Cache cleared successfully');
      await _refreshUsage(emit, state.config);
    } catch (e) {
      talker.error('Failed to clear cache', e);
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onRefreshUsage(RefreshUsageEvent event, Emitter<CacheSettingsState> emit) async {
    await _refreshUsage(emit, state.config);
  }

  Future<void> _updateConfig(Emitter<CacheSettingsState> emit, CacheConfig newConfig) async {
    try {
      await _configRepository.saveConfig(newConfig);
      emit(state.copyWith(config: newConfig));

      // Run cleanup to enforce new limits
      await _cleanupService.runCleanup();
      await _refreshUsage(emit, newConfig);
    } catch (e) {
      talker.error('Failed to update cache config', e);
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _refreshUsage(Emitter<CacheSettingsState> emit, CacheConfig config) async {
    try {
      final imageDir = await _sizeMonitor.getCacheDirectory(app_image.ImageCacheManager.key);
      final videoDir = await _sizeMonitor.getCacheDirectory(app_video.VideoCacheManager.key);
      final audioDir = await _sizeMonitor.getCacheDirectory(app_audio.AudioCacheManager.key);

      final imageUsage = await _sizeMonitor.calculateCacheSize(imageDir);
      final videoUsage = await _sizeMonitor.calculateCacheSize(videoDir);
      final audioUsage = await _sizeMonitor.calculateCacheSize(audioDir);

      emit(state.copyWith(
        config: config,
        imageUsageBytes: imageUsage,
        videoUsageBytes: videoUsage,
        audioUsageBytes: audioUsage,
        isLoading: false,
        errorMessage: null,
      ));
    } catch (e) {
      talker.error('Failed to refresh cache usage', e);
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
