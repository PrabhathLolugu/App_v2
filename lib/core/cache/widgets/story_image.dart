import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../managers/image_cache_manager.dart';

/// A widget that displays an image from either a URL or base64 data.
///
/// This widget automatically detects whether the image source is a URL or
/// base64-encoded data and renders it appropriately using CachedNetworkImage
/// for URLs (with caching) or Image.memory for base64 data.
///
/// Usage:
/// ```dart
/// StoryImage(
///   imageUrl: story.imageUrl,
///   fit: BoxFit.cover,
///   placeholder: (context) => ShimmerWidget(),
/// )
/// ```
class StoryImage extends StatelessWidget {
  /// The image URL or base64 data string.
  final String? imageUrl;

  /// How to inscribe the image into the space allocated during layout.
  final BoxFit fit;

  /// Widget width (optional).
  final double? width;

  /// Widget height (optional).
  final double? height;

  /// Builder for the placeholder widget while loading.
  final Widget Function(BuildContext context)? placeholder;

  /// Builder for the error widget when loading fails.
  final Widget Function(BuildContext context, dynamic error)? errorWidget;

  /// Memory cache width for CachedNetworkImage.
  final int? memCacheWidth;

  /// Memory cache height for CachedNetworkImage.
  final int? memCacheHeight;

  /// Color to apply to the image.
  final Color? color;

  /// Blend mode for the color.
  final BlendMode? colorBlendMode;

  /// Index for randomizing fallback gradients
  final int? fallbackIndex;

  const StoryImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
    this.memCacheWidth,
    this.memCacheHeight,
    this.color,
    this.colorBlendMode,
    this.fallbackIndex,
  });

  /// Check if the string is a base64 data URL.
  bool get _isBase64 =>
      imageUrl != null &&
      (imageUrl!.startsWith('data:image') || _isRawBase64(imageUrl!));

  /// Check if the string looks like raw base64 image data (PNG, JPEG, GIF, WebP).
  bool _isRawBase64(String data) {
    final trimmed = data.trim();
    return trimmed.startsWith('iVBORw0KGgo') || // PNG
        trimmed.startsWith('/9j/') || // JPEG
        trimmed.startsWith('R0lGOD') || // GIF
        trimmed.startsWith('UklGR'); // WebP
  }

  /// Check if the string is a valid network URL.
  bool get _isNetworkUrl =>
      imageUrl != null &&
      (imageUrl!.startsWith('http://') || imageUrl!.startsWith('https://'));

  /// Decode base64 image data.
  Uint8List? _decodeBase64() {
    if (imageUrl == null) return null;
    try {
      String base64Data;

      if (imageUrl!.startsWith('data:image')) {
        // Handle data URL format: data:image/png;base64,xxxxx
        final parts = imageUrl!.split(',');
        base64Data = parts.length > 1 ? parts[1] : parts[0];
      } else {
        // Raw base64 data
        base64Data = imageUrl!;
      }

      return base64Decode(base64Data);
    } catch (e) {
      debugPrint('Failed to decode base64 image: $e');
      return null;
    }
  }

  static const _kStoryPlaceholderGradients = [
    [Color(0xFFf093fb), Color(0xFFf5576c)], // Pink → Red
    [Color(0xFF4facfe), Color(0xFF00f2fe)], // Sky → Cyan
    [Color(0xFF43e97b), Color(0xFF38f9d7)], // Green → Aqua
    [Color(0xFFfa709a), Color(0xFFfee140)], // Rose → Gold
    [Color(0xFFa18cd1), Color(0xFFfbc2eb)], // Lavender → Blush
    [Color(0xFFfd7442), Color(0xFFffcb5b)], // Orange → Amber
  ];

  List<Color> get _gradientColors {
    if (fallbackIndex != null) {
      return _kStoryPlaceholderGradients[fallbackIndex! % _kStoryPlaceholderGradients.length];
    }
    final key = imageUrl ?? 'default_story';
    final hash = key.codeUnits.fold(0, (prev, curr) => prev + curr);
    return _kStoryPlaceholderGradients[hash % _kStoryPlaceholderGradients.length];
  }

  Widget _buildPlaceholder(BuildContext context) {
    if (placeholder != null) {
      return placeholder!(context);
    }
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _gradientColors,
        ),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.transparent,
        highlightColor: Colors.white.withValues(alpha: 0.3),
        period: const Duration(milliseconds: 1500),
        child: Container(color: Colors.white),
      ),
    );
  }

  Widget _buildError(BuildContext context, [dynamic error]) {
    if (errorWidget != null) {
      return errorWidget!(context, error);
    }
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _gradientColors,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.transparent,
            highlightColor: Colors.white.withValues(alpha: 0.3),
            period: const Duration(milliseconds: 1500),
            child: Container(color: Colors.white),
          ),
          Center(
            child: Icon(
              Icons.auto_stories_rounded,
              color: Colors.white.withValues(alpha: 0.6),
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Handle null or empty imageUrl
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildPlaceholder(context);
    }

    // Handle base64 encoded images
    if (_isBase64) {
      final bytes = _decodeBase64();
      if (bytes == null) {
        return _buildError(context, 'Failed to decode base64');
      }
      return Image.memory(
        bytes,
        key: ValueKey<String>(imageUrl!),
        fit: fit,
        width: width,
        height: height,
        color: color,
        colorBlendMode: colorBlendMode,
        errorBuilder: (context, error, stackTrace) => _buildError(context, error),
      );
    }

    // Handle network URLs with caching
    if (_isNetworkUrl) {
      return CachedNetworkImage(
        // New identity when URL changes (e.g. null → signed URL) so the loader
        // retries instead of staying on placeholder/error from a prior build.
        key: ValueKey<String>(imageUrl!),
        imageUrl: imageUrl!,
        cacheManager: ImageCacheManager.instance,
        fit: fit,
        width: width,
        height: height,
        memCacheWidth: memCacheWidth,
        memCacheHeight: memCacheHeight,
        color: color,
        colorBlendMode: colorBlendMode,
        placeholder: (context, url) => _buildPlaceholder(context),
        errorWidget: (context, url, error) => _buildError(context, error),
      );
    }

    // Unknown format - show error
    return _buildError(context, 'Invalid image URL format');
  }
}
