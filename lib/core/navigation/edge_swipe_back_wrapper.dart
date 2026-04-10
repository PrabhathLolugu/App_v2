import 'package:flutter/material.dart';

/// Provides iOS-style edge swipe back gesture (left edge -> right swipe).
class EdgeSwipeBackWrapper extends StatefulWidget {
  const EdgeSwipeBackWrapper({
    super.key,
    required this.child,
    required this.onBack,
    this.edgeWidth = 24,
    this.triggerDistance = 72,
    this.minFlingVelocity = 900,
  });

  final Widget child;
  final VoidCallback onBack;
  final double edgeWidth;
  final double triggerDistance;
  final double minFlingVelocity;

  @override
  State<EdgeSwipeBackWrapper> createState() => _EdgeSwipeBackWrapperState();
}

class _EdgeSwipeBackWrapperState extends State<EdgeSwipeBackWrapper> {
  bool _tracking = false;
  double _dragDistance = 0;
  bool _fired = false;

  void _reset() {
    _tracking = false;
    _dragDistance = 0;
    _fired = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragStart: (details) {
        _tracking = details.globalPosition.dx <= widget.edgeWidth;
        _dragDistance = 0;
        _fired = false;
      },
      onHorizontalDragUpdate: (details) {
        if (!_tracking || _fired) return;
        _dragDistance += details.delta.dx;
      },
      onHorizontalDragEnd: (details) {
        if (!_tracking || _fired) {
          _reset();
          return;
        }

        final velocity = details.primaryVelocity ?? 0;
        final shouldBack = _dragDistance >= widget.triggerDistance ||
            velocity >= widget.minFlingVelocity;
        if (shouldBack) {
          _fired = true;
          widget.onBack();
        }
        _reset();
      },
      onHorizontalDragCancel: _reset,
      child: widget.child,
    );
  }
}
