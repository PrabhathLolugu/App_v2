import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Reusable wrapper that provides consistent haptic feedback and scale
/// animation on tap for improved UX and user retention.
class HapticTapScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleDown;
  final HapticFeedbackType hapticType;
  final Duration duration;

  const HapticTapScale({
    super.key,
    required this.child,
    this.onTap,
    this.scaleDown = 0.97,
    this.hapticType = HapticFeedbackType.medium,
    this.duration = const Duration(milliseconds: 120),
  });

  @override
  State<HapticTapScale> createState() => _HapticTapScaleState();
}

enum HapticFeedbackType { light, medium, heavy, selection }

class _HapticTapScaleState extends State<HapticTapScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _scale = Tween<double>(begin: 1.0, end: widget.scaleDown).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _triggerHaptic() {
    switch (widget.hapticType) {
      case HapticFeedbackType.light:
        HapticFeedback.lightImpact();
        break;
      case HapticFeedbackType.medium:
        HapticFeedback.mediumImpact();
        break;
      case HapticFeedbackType.heavy:
        HapticFeedback.heavyImpact();
        break;
      case HapticFeedbackType.selection:
        HapticFeedback.selectionClick();
        break;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onTap == null) return widget.child;

    return GestureDetector(
      onTapDown: (_) {
        _controller.forward();
        _triggerHaptic();
      },
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}
