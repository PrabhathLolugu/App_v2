import 'dart:async';

import 'package:flutter/material.dart';

/// Minimal repost line: slides in from the right, then wipes closed left→right
/// (with fade). No background chip — text only.
class RepostSourceToast extends StatefulWidget {
  const RepostSourceToast({
    super.key,
    this.authorName,
    this.authorUsername,
    this.darkOverlay = false,
    this.onTap,
    this.visibleDuration = const Duration(seconds: 3),
    this.fadeDuration = const Duration(milliseconds: 280),
  });

  final String? authorName;
  final String? authorUsername;
  final bool darkOverlay;
  final VoidCallback? onTap;
  /// Time the line stays **after** the enter animation finishes.
  final Duration visibleDuration;
  final Duration fadeDuration;

  @override
  State<RepostSourceToast> createState() => _RepostSourceToastState();
}

class _RepostSourceToastState extends State<RepostSourceToast>
    with TickerProviderStateMixin {
  Timer? _holdTimer;

  late final AnimationController _enterController;
  late final AnimationController _exitController;
  late final Animation<double> _enterFade;

  bool _enterComplete = false;
  bool _inTree = true;

  Animation<Offset>? _cachedEnterSlide;
  bool? _cachedSlideRtl;

  static const double _fontSize = 14.5;

  @override
  void initState() {
    super.initState();

    _enterController = AnimationController(
      vsync: this,
      duration: widget.fadeDuration,
    );
    _exitController = AnimationController(
      vsync: this,
      duration: widget.fadeDuration,
    );

    _enterFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _enterController,
        curve: const Interval(0, 0.7, curve: Curves.easeOut),
      ),
    );

    _enterController.addStatusListener(_onEnterStatus);
    _exitController.addStatusListener(_onExitStatus);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _enterController.forward();
    });
  }

  void _onEnterStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || !mounted) return;
    setState(() => _enterComplete = true);
    _holdTimer?.cancel();
    _holdTimer = Timer(widget.visibleDuration, () {
      if (mounted) _exitController.forward();
    });
  }

  void _onExitStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && mounted) {
      setState(() => _inTree = false);
    }
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    _enterController.removeStatusListener(_onEnterStatus);
    _exitController.removeStatusListener(_onExitStatus);
    _enterController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  String get _line {
    final user = widget.authorUsername?.trim();
    if (user != null && user.isNotEmpty) {
      return 'Reposted from @$user';
    }
    final name = widget.authorName?.trim();
    if (name != null && name.isNotEmpty) {
      return 'Reposted from $name';
    }
    return 'Reposted post';
  }

  Animation<Offset> _enterSlideAnimation(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    if (_cachedEnterSlide != null && _cachedSlideRtl == rtl) {
      return _cachedEnterSlide!;
    }
    _cachedSlideRtl = rtl;
    _cachedEnterSlide = Tween<Offset>(
      begin: rtl ? const Offset(-1.0, 0) : const Offset(1.0, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _enterController, curve: Curves.easeOutCubic),
    );
    return _cachedEnterSlide!;
  }

  TextStyle _textStyle(ThemeData theme, Color fg) {
    return TextStyle(
      color: fg,
      fontSize: _fontSize,
      fontWeight: FontWeight.w600,
      height: 1.25,
      shadows: widget.darkOverlay
          ? [
              Shadow(
                color: Colors.black.withValues(alpha: 0.85),
                blurRadius: 8,
                offset: const Offset(0, 1),
              ),
              Shadow(
                color: Colors.black.withValues(alpha: 0.55),
                blurRadius: 3,
                offset: const Offset(0, 0),
              ),
            ]
          : [
              Shadow(
                color: theme.colorScheme.surface.withValues(alpha: 0.9),
                blurRadius: 6,
                offset: const Offset(0, 0),
              ),
            ],
    );
  }

  Widget _buildLine(ThemeData theme, Color fg) {
    final text = Text(
      _line,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.end,
      style: _textStyle(theme, fg),
    );

    Widget row = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: text,
        ),
        if (widget.onTap != null) ...[
          const SizedBox(width: 5),
          Icon(
            Icons.open_in_new_rounded,
            size: 16,
            color: fg.withValues(alpha: 0.9),
            shadows: widget.darkOverlay
                ? [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.8),
                      blurRadius: 6,
                    ),
                  ]
                : null,
          ),
        ],
      ],
    );

    if (widget.onTap != null) {
      row = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
            child: row,
          ),
        ),
      );
    }

    return row;
  }

  /// LTR: anchor right, width shrinks from the left → “closes” left-to-right.
  Widget _exitWipe(BuildContext context, Widget child) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return AnimatedBuilder(
      animation: _exitController,
      builder: (context, ch) {
        final t = Curves.easeInCubic.transform(_exitController.value);
        if (t <= 0) return ch!;
        final widthFactor = (1.0 - t).clamp(0.0, 1.0);
        final opacity = (1.0 - t * 0.92).clamp(0.0, 1.0);
        return Opacity(
          opacity: opacity,
          child: ClipRect(
            child: Align(
              alignment: rtl ? Alignment.centerLeft : Alignment.centerRight,
              widthFactor: widthFactor,
              child: ch,
            ),
          ),
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_inTree) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final fg = widget.darkOverlay
        ? Colors.white.withValues(alpha: 0.96)
        : theme.colorScheme.onSurface;

    final line = _buildLine(theme, fg);

    if (!_enterComplete) {
      return SlideTransition(
        position: _enterSlideAnimation(context),
        child: FadeTransition(
          opacity: _enterFade,
          child: line,
        ),
      );
    }

    return _exitWipe(context, line);
  }
}
