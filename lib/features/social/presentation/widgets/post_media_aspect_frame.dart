import 'package:flutter/material.dart';

/// Instagram-like media frame:
/// - Uses the post's aspectRatio when available
/// - Clamps to a sane in-feed range (portrait max 4:5, landscape min 1.91:1)
/// - Sizes itself based on available width (no fixed-height stretching)
class PostMediaAspectFrame extends StatelessWidget {
  const PostMediaAspectFrame({
    super.key,
    required this.child,
    required this.aspectRatio,
    this.minAspectRatio = 1 / 1.91,
    this.maxAspectRatio = 4 / 5,
    this.borderRadius,
    this.backgroundColor = Colors.black,
  });

  /// Width / height.
  final double? aspectRatio;

  /// Minimum allowed width/height ratio (i.e., very tall images clamp to 4:5).
  /// Default corresponds to max feed height of \(width / (4/5) = 1.25 * width\).
  final double maxAspectRatio;

  /// Maximum allowed height/width ratio (i.e., very wide images clamp to ~1.91:1).
  /// Default corresponds to min feed height of \(width / (1.91) \approx 0.52 * width\).
  final double minAspectRatio;

  final Widget child;
  final BorderRadius? borderRadius;
  final Color backgroundColor;

  double _clampRatio(double r) {
    if (!r.isFinite || r <= 0) return 1.0;
    // r is width/height. For tall images, r is small.
    return r.clamp(minAspectRatio, 1 / maxAspectRatio);
  }

  @override
  Widget build(BuildContext context) {
    final r = _clampRatio(aspectRatio ?? 1.0);

    final framed = LayoutBuilder(
      builder: (context, box) {
        final width = box.maxWidth.isFinite ? box.maxWidth : MediaQuery.sizeOf(context).width;
        final height = (width / r).clamp(220.0, 560.0);
        return SizedBox(
          width: width,
          height: height,
          child: child,
        );
      },
    );

    if (borderRadius == null) {
      return ColoredBox(color: backgroundColor, child: framed);
    }

    return ClipRRect(
      borderRadius: borderRadius!,
      child: ColoredBox(color: backgroundColor, child: framed),
    );
  }
}

