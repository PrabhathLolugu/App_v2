// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CacheConfig _$CacheConfigFromJson(Map<String, dynamic> json) => _CacheConfig(
  imageCacheSizeBytes:
      (json['imageCacheSizeBytes'] as num?)?.toInt() ?? 500 * 1024 * 1024,
  videoCacheSizeBytes:
      (json['videoCacheSizeBytes'] as num?)?.toInt() ?? 300 * 1024 * 1024,
  audioCacheSizeBytes:
      (json['audioCacheSizeBytes'] as num?)?.toInt() ?? 200 * 1024 * 1024,
  wifiOnlyMode: json['wifiOnlyMode'] as bool? ?? false,
);

Map<String, dynamic> _$CacheConfigToJson(_CacheConfig instance) =>
    <String, dynamic>{
      'imageCacheSizeBytes': instance.imageCacheSizeBytes,
      'videoCacheSizeBytes': instance.videoCacheSizeBytes,
      'audioCacheSizeBytes': instance.audioCacheSizeBytes,
      'wifiOnlyMode': instance.wifiOnlyMode,
    };
