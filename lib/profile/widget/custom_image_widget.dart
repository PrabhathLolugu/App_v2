import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myitihas/core/widgets/image_loading_placeholder/image_loading_placeholder.dart';

extension ImageTypeExtension on String {
  ImageType get imageType {
    if (startsWith('http') || startsWith('https')) {
      return ImageType.network;
    } else if (endsWith('.svg')) {
      return ImageType.svg;
    } else if (startsWith('file: //')) {
      return ImageType.file;
    } else {
      return ImageType.png;
    }
  }
}

enum ImageType { svg, png, network, file, unknown }

// ignore_for_file: must_be_immutable
class CustomImageWidget extends StatelessWidget {
  const CustomImageWidget({
    super.key,
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
  /// Use for profile/avatar contexts to avoid gendered placeholder images.
  final bool useAvatarPlaceholder;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(alignment: alignment!, child: _buildWidget())
        : _buildWidget();
  }

  Widget _buildWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(onTap: onTap, child: _buildCircleImage()),
    );
  }

  ///build the image with border radius
  _buildCircleImage() {
    if (radius != null) {
      return ClipRRect(
        borderRadius: radius ?? BorderRadius.zero,
        child: _buildImageWithBorder(),
      );
    } else {
      return _buildImageWithBorder();
    }
  }

  ///build the image with border and border radius style
  _buildImageWithBorder() {
    if (border != null) {
      return Container(
        decoration: BoxDecoration(border: border, borderRadius: radius),
        child: _buildImageView(),
      );
    } else {
      return _buildImageView();
    }
  }

  Widget _buildImageView() {
    if (imageUrl != null) {
      switch (imageUrl!.imageType) {
        case ImageType.svg:
          return SizedBox(
            height: height,
            width: width,
            child: SvgPicture.asset(
              imageUrl!,
              height: height,
              width: width,
              fit: fit ?? BoxFit.contain,
              colorFilter: color != null
                  ? ColorFilter.mode(
                      color ?? Colors.transparent,
                      BlendMode.srcIn,
                    )
                  : null,
              semanticsLabel: semanticLabel,
            ),
          );
        case ImageType.file:
          return Image.file(
            File(imageUrl!),
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
            imageUrl: imageUrl!,
            color: color,
            placeholder: (context, url) => ImageLoadingPlaceholder(
              width: width,
              height: height,
              borderRadius: radius,
            ),
            errorWidget: (context, url, error) =>
                errorWidget ??
                (useAvatarPlaceholder
                    ? _buildAvatarPlaceholder(context, height, width)
                    : Image.asset(
                        placeHolder,
                        height: height,
                        width: width,
                        fit: fit ?? BoxFit.cover,
                        semanticLabel: semanticLabel,
                      )),
          );
        case ImageType.png:
        default:
          return Image.asset(
            imageUrl!,
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
            semanticLabel: semanticLabel,
          );
      }
    }
    return SizedBox();
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
}
