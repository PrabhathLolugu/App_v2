import 'package:freezed_annotation/freezed_annotation.dart';

part 'cache_settings_event.freezed.dart';

@freezed
sealed class CacheSettingsEvent with _$CacheSettingsEvent {
  const factory CacheSettingsEvent.loadSettings() = LoadSettingsEvent;
  const factory CacheSettingsEvent.updateImageCacheSize(int sizeBytes) = UpdateImageCacheSizeEvent;
  const factory CacheSettingsEvent.updateVideoCacheSize(int sizeBytes) = UpdateVideoCacheSizeEvent;
  const factory CacheSettingsEvent.updateAudioCacheSize(int sizeBytes) = UpdateAudioCacheSizeEvent;
  const factory CacheSettingsEvent.toggleWifiOnly(bool enabled) = ToggleWifiOnlyEvent;
  const factory CacheSettingsEvent.clearCache() = ClearCacheEvent;
  const factory CacheSettingsEvent.refreshUsage() = RefreshUsageEvent;
}
