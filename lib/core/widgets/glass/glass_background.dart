import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';

/// Full-screen glass gradient background using theme extension.
/// Use as base layer for screens - futuristic techno/electric themed.
class GlassBackground extends StatelessWidget {
  const GlassBackground({
    super.key,
    this.child,
    this.blendOpacity = 1.0,
  });

  final Widget? child;
  final double blendOpacity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradients = theme.extension<GradientExtension>();
    final gradient = gradients?.screenBackgroundGradient ??
        LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surfaceContainerHigh,
          ],
        );

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: gradient,
      ),
      child: child,
    );
  }
}

/// Glass overlay with blur - use for cards, nav bars, sheets
class GlassOverlay extends StatelessWidget {
  const GlassOverlay({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.blurSigma = 10,
    this.borderWidth = 1,
  });

  final Widget child;
  final double borderRadius;
  final double blurSigma;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradients = theme.extension<GradientExtension>();

    final bg = gradients?.glassBackground ??
        theme.colorScheme.surface.withValues(alpha: 0.7);
    final border = gradients?.glassBorder ??
        theme.colorScheme.primary.withValues(alpha: 0.15);

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: border, width: borderWidth),
          ),
          child: child,
        ),
      ),
    );
  }
}
