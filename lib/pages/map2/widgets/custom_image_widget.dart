import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myitihas/core/widgets/image_loading_placeholder/image_loading_placeholder.dart';

extension ImageTypeExtension on String {
  ImageType get imageType {
    if (this.startsWith('http') || this.startsWith('https')) {
      return ImageType.network;
    } else if (this.endsWith('.svg')) {
      return ImageType.svg;
    } else if (this.startsWith('file: //')) {
      return ImageType.file;
    } else {
      return ImageType.png;
    }
  }
}

enum ImageType { svg, png, network, file, unknown }

// ignore_for_file: must_be_immutable
class CustomImageWidget extends StatelessWidget {
  CustomImageWidget({
    this.imageUrl,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
    this.onTap,
    this.radius,
    this.margin,
    this.border,
    this.placeHolder = 'assets/images/no-image.jpg',
    this.errorWidget,
    this.semanticLabel,
    this.useAvatarPlaceholder = false,
    this.useSacredPlaceholder = false,
    this.sacredPlaceholderSeed,
  });

  ///[imageUrl] is required parameter for showing image
  final String? imageUrl;

  final double? height;

  final double? width;

  final BoxFit? fit;

  final String placeHolder;

  final Color? color;

  final Alignment? alignment;

  final VoidCallback? onTap;

  final BorderRadius? radius;

  final EdgeInsetsGeometry? margin;

  final BoxBorder? border;

  /// Optional widget to show when the image fails to load.
  /// If null, a default asset image is shown.
  final Widget? errorWidget;

  /// Semantic label for the image to improve accessibility
  final String? semanticLabel;

  /// When true, error/placeholder shows a neutral person icon instead of no-image asset.
  final bool useAvatarPlaceholder;
  final bool useSacredPlaceholder;
  final String? sacredPlaceholderSeed;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(alignment: alignment!, child: _buildWidget(context))
        : _buildWidget(context);
  }

  Widget _buildWidget(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(onTap: onTap, child: _buildCircleImage(context)),
    );
  }

  ///build the image with border radius
  _buildCircleImage(BuildContext context) {
    if (radius != null) {
      return ClipRRect(
        borderRadius: radius ?? BorderRadius.zero,
        child: _buildImageWithBorder(context),
      );
    } else {
      return _buildImageWithBorder(context);
    }
  }

  ///build the image with border and border radius style
  _buildImageWithBorder(BuildContext context) {
    if (border != null) {
      return Container(
        decoration: BoxDecoration(border: border, borderRadius: radius),
        child: _buildImageView(context),
      );
    } else {
      return _buildImageView(context);
    }
  }

  Widget _buildImageView(BuildContext context) {
    final normalizedUrl = imageUrl?.trim();
    if (normalizedUrl == null || normalizedUrl.isEmpty) {
      return _buildDefaultFallback(context, height, width);
    }

    switch (normalizedUrl.imageType) {
        case ImageType.svg:
          return Container(
            height: height,
            width: width,
            child: SvgPicture.asset(
              normalizedUrl,
              height: height,
              width: width,
              fit: fit ?? BoxFit.contain,
              colorFilter: this.color != null
                  ? ColorFilter.mode(
                      this.color ?? Colors.transparent,
                      BlendMode.srcIn,
                    )
                  : null,
              semanticsLabel: semanticLabel,
            ),
          );
        case ImageType.file:
          return Image.file(
            File(normalizedUrl),
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
            semanticLabel: semanticLabel,
          );
        case ImageType.network:
          return CachedNetworkImage(
            height: height,
            width: width,
            fit: fit,
            imageUrl: normalizedUrl,
            color: color,
            placeholder: (context, url) => ImageLoadingPlaceholder(
              width: width,
              height: height,
              borderRadius: radius,
            ),
            errorWidget: (context, url, error) =>
                errorWidget ?? _buildDefaultFallback(context, height, width),
          );
        case ImageType.png:
        default:
          return Image.asset(
            normalizedUrl,
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
            semanticLabel: semanticLabel,
          );
    }
  }

  Widget _buildDefaultFallback(
    BuildContext context,
    double? h,
    double? w,
  ) {
    if (useAvatarPlaceholder) {
      return _buildAvatarPlaceholder(context, h, w);
    }
    if (useSacredPlaceholder) {
      return _buildSacredPlaceholder(context, h, w);
    }
    return Image.asset(
      placeHolder,
      height: h,
      width: w,
      fit: fit ?? BoxFit.cover,
      semanticLabel: semanticLabel,
    );
  }

  Widget _buildAvatarPlaceholder(
    BuildContext context,
    double? h,
    double? w,
  ) {
    final size = (h != null && w != null) ? (h < w ? h : w) : 48.0;
    return Container(
      width: w ?? size,
      height: h ?? size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7F53AC), Color(0xFF647DEE)],
        ),
      ),
      child: Icon(
        Icons.person_rounded,
        size: size * 0.6,
        color: Colors.white.withValues(alpha: 0.8),
      ),
    );
  }

  Widget _buildSacredPlaceholder(
    BuildContext context,
    double? h,
    double? w,
  ) {
    final gradients = <List<Color>>[
      [const Color(0xFF3A0F2A), const Color(0xFF7A2E0E), const Color(0xFFD18B2A)],
      [const Color(0xFF0E2C3A), const Color(0xFF1A5B6E), const Color(0xFF4EC5D6)],
      [const Color(0xFF2D1A53), const Color(0xFF5630A3), const Color(0xFF9C6CFF)],
      [const Color(0xFF3A2A0F), const Color(0xFF7A5314), const Color(0xFFE1AF43)],
      [const Color(0xFF1B3A15), const Color(0xFF2C6E2A), const Color(0xFF6FCF70)],
      [const Color(0xFF3A1021), const Color(0xFF8A234D), const Color(0xFFE05D8F)],
    ];
    final seed = (sacredPlaceholderSeed?.trim().isNotEmpty ?? false)
        ? sacredPlaceholderSeed!.trim()
        : (semanticLabel?.trim().isNotEmpty ?? false)
        ? semanticLabel!.trim()
        : (imageUrl?.trim().isNotEmpty ?? false)
        ? imageUrl!.trim()
        : 'sacred-site';
    final palette = gradients[seed.hashCode.abs() % gradients.length];
    final size = (h != null && w != null) ? (h < w ? h : w) : 52.0;
    return Container(
      width: w ?? size,
      height: h ?? size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: palette,
        ),
      ),
      child: Icon(
        Icons.temple_hindu_rounded,
        size: size * 0.46,
        color: Colors.white.withValues(alpha: 0.92),
      ),
    );
  }
}
