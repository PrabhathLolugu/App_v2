import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';

/// Card with glassmorphism effect - blur + semi-transparent background
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.blurSigma = 12,
    this.padding,
    this.margin,
    this.borderWidth = 1,
    this.onTap,
  });

  final Widget child;
  final double borderRadius;
  final double blurSigma;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderWidth;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradients = theme.extension<GradientExtension>();

    final bg = gradients?.glassCardBackground ??
        theme.colorScheme.surface.withValues(alpha: 0.7);
    final border = gradients?.glassCardBorder ??
        theme.colorScheme.primary.withValues(alpha: 0.15);

    final content = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: border, width: borderWidth),
            boxShadow: [
              BoxShadow(
                color: (gradients?.electricGlow ?? theme.colorScheme.primary)
                    .withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: padding,
          child: onTap != null
              ? GestureDetector(
                  onTap: onTap,
                  behavior: HitTestBehavior.opaque,
                  child: child,
                )
              : child,
        ),
      ),
    );

    if (margin != null) {
      return Padding(padding: margin!, child: content);
    }
    return content;
  }
}
