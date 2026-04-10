import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Professional shimmer loading placeholder for images.
///
/// Use in CachedNetworkImage.placeholder or similar to show a
/// smooth loading effect while images load.
class ImageLoadingPlaceholder extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const ImageLoadingPlaceholder({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final baseColor = isDark
        ? colorScheme.surfaceContainerHigh
        : colorScheme.surfaceContainerLow;
    final highlightColor = isDark
        ? colorScheme.surfaceContainerLow
        : colorScheme.surfaceContainerHighest;

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          width: width ?? double.infinity,
          height: height ?? double.infinity,
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: borderRadius ?? BorderRadius.zero,
          ),
        ),
      ),
    );
  }
}
