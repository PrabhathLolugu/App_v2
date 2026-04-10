import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myitihas/core/cache/managers/image_cache_manager.dart';
import 'package:myitihas/pages/map2/widgets/custom_icon_widget.dart';
import 'package:sizer/sizer.dart';

class MapIntentHeroCarousel extends StatefulWidget {
  final List<Map<String, dynamic>> cards;
  final void Function(Map<String, dynamic> card) onCardTap;

  const MapIntentHeroCarousel({
    super.key,
    required this.cards,
    required this.onCardTap,
  });

  @override
  State<MapIntentHeroCarousel> createState() => _MapIntentHeroCarouselState();
}

class _MapIntentHeroCarouselState extends State<MapIntentHeroCarousel>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  /// Drag position in "card widths"; drives stack via [AnimatedBuilder] only (no per-frame setState).
  final ValueNotifier<double> _dragNotifier = ValueNotifier<double>(0.0);
  bool _userDragging = false;
  Timer? _autoTimer;
  String? _lastPrefetchKey;

  late AnimationController _anim;
  late Animation<double> _tweenAnim;
  bool _hasTween = false;

  String _heroImageUrlsKey() {
    return widget.cards
        .map((c) => c['imageUrl']?.toString() ?? '')
        .join('\u0001');
  }

  List<String> _networkHeroImageUrls() {
    final out = <String>[];
    final seen = <String>{};
    for (final c in widget.cards) {
      final raw = c['imageUrl']?.toString();
      if (raw == null || raw.isEmpty) continue;
      if (!raw.startsWith('http://') && !raw.startsWith('https://')) continue;
      if (seen.add(raw)) out.add(raw);
    }
    return out;
  }

  void _scheduleHeroImagePrefetch() {
    final key = _heroImageUrlsKey();
    if (key == _lastPrefetchKey) return;
    _lastPrefetchKey = key;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _prefetchHeroImages();
    });
  }

  Future<void> _prefetchHeroImages() async {
    final urls = _networkHeroImageUrls();
    for (final url in urls) {
      if (!mounted) return;
      try {
        await precacheImage(
          CachedNetworkImageProvider(
            url,
            cacheManager: ImageCacheManager.instance,
          ),
          context,
        );
      } catch (_) {
        // Best-effort prefetch; individual cards still load via CachedNetworkImage.
      }
    }
  }

  void _onAnimStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && mounted) {
      // Avoid one frame where [isAnimating] is false but [_dragNotifier] still
      // holds the pre-snap drag (would make the stack jump).
      _dragNotifier.value = _tweenAnim.value;
    }
  }

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this)..addStatusListener(_onAnimStatus);
    _startAutoScroll();
    _scheduleHeroImagePrefetch();
  }

  @override
  void didUpdateWidget(covariant MapIntentHeroCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scheduleHeroImagePrefetch();
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _anim.removeStatusListener(_onAnimStatus);
    _anim.dispose();
    _dragNotifier.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoTimer?.cancel();
    _autoTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || _userDragging || _anim.isAnimating) return;
      _goForward();
    });
  }

  void _goForward() => _runSnap(-1.0, () {
    _currentIndex = (_currentIndex + 1) % widget.cards.length;
    _dragNotifier.value = 0;
  });

  void _goBack() => _runSnap(1.0, () {
    _currentIndex =
        (_currentIndex - 1 + widget.cards.length) % widget.cards.length;
    _dragNotifier.value = 0;
  });

  void _snapBack() => _runSnap(0, () {});

  void _runSnap(double target, VoidCallback onDone) {
    final start = _dragNotifier.value;
    _tweenAnim = Tween(
      begin: start,
      end: target,
    ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic));
    _hasTween = true;
    _anim.duration = Duration(
      milliseconds: ((target - start).abs() * 520 + 200)
          .clamp(240, 780)
          .toInt(),
    );
    _anim.forward(from: 0).then((_) {
      if (!mounted) return;
      onDone();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        GestureDetector(
          onHorizontalDragStart: (_) {
            _userDragging = true;
            // If a snap animation is in progress (auto or previous swipe),
            // let the user immediately take over instead of ignoring input.
            if (_anim.isAnimating) {
              _anim.stop();
              if (_hasTween) {
                _dragNotifier.value = _tweenAnim.value;
              }
            }
          },
          onHorizontalDragUpdate: (d) {
            if (_anim.isAnimating) {
              // Should be rare (start not delivered), but keep input responsive.
              _anim.stop();
              if (_hasTween) _dragNotifier.value = _tweenAnim.value;
            }
            final w = MediaQuery.of(context).size.width * 0.88;
            final next = (_dragNotifier.value + (d.primaryDelta ?? 0) / w)
                .clamp(-1.3, 1.3);
            _dragNotifier.value = next;
          },
          onHorizontalDragEnd: (d) {
            _userDragging = false;
            final vel = d.primaryVelocity ?? 0;
            final drag = _dragNotifier.value;
            if (drag < -0.22 || vel < -500) {
              _goForward();
            } else if (drag > 0.22 || vel > 500) {
              _goBack();
            } else {
              _snapBack();
            }
          },
          behavior: HitTestBehavior.translucent,
          child: SizedBox(
            height: 52.h,
            child: LayoutBuilder(
              builder: (context, box) {
                return AnimatedBuilder(
                  animation: Listenable.merge([_anim, _dragNotifier]),
                  builder: (context, _) {
                    final drag = _anim.isAnimating
                        ? _tweenAnim.value
                        : _dragNotifier.value;
                    return Stack(
                      clipBehavior: Clip.none,
                      children: _buildStack(box.maxWidth, 52.h, drag),
                    );
                  },
                );
              },
            ),
          ),
        ),
        SizedBox(height: 1.2.h),
        Center(child: _buildDots(theme)),
      ],
    );
  }

  Widget _buildDots(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.cards.length, (i) {
        final active = i == _currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          margin: EdgeInsets.symmetric(horizontal: 0.65.w),
          width: active ? 6.w : 1.6.w,
          height: 0.7.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: active
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withValues(alpha: 0.2),
          ),
        );
      }),
    );
  }

  List<Widget> _buildStack(double parentW, double stackH, double drag) {
    const maxBehind = 3;
    final total = widget.cards.length;
    if (total == 0) return [];

    final entries = <_StackEntry>[];
    final seen = <int>{};

    void add(int idx, double pos) {
      if (seen.add(idx)) entries.add(_StackEntry(index: idx, pos: pos));
    }

    if (drag > 0.01) {
      add((_currentIndex - 1 + total) % total, -1.0 + drag);
    }

    add(_currentIndex, drag);

    for (int i = 1; i <= maxBehind; i++) {
      final pos = i.toDouble() + drag;
      if (pos < -0.5) continue;
      add((_currentIndex + i) % total, pos);
    }

    // Descending sort: largest pos first (painted first = bottom z),
    // smallest pos last (painted last = top z / front).
    entries.sort((a, b) => b.pos.compareTo(a.pos));

    final cardW = parentW * 0.88;
    final pad = parentW * 0.04;

    return entries.map((e) {
      final card = widget.cards[e.index];
      final accent = Color(card['color'] as int);
      final imageUrl = card['imageUrl']?.toString();
      final highlights = (card['highlights'] as List<dynamic>? ?? const [])
          .map((v) => v.toString())
          .toList();
      final p = e.pos;

      double scale, dx, dy;

      if (p <= 0) {
        scale = 1.0;
        dx = pad + p * cardW;
        dy = 0;
      } else {
        scale = (1 - p * 0.04).clamp(0.90, 1.0);
        dx = pad + p * 16;
        dy = p * 8;
      }

      // Do not wrap cards in Opacity: it composites the whole layer with the
      // screen behind and reads as a grey/white slab during transitions,
      // especially on some accent palettes. Depth uses scale/offset only;
      // back cards get an opaque dim overlay inside the card instead.
      final cardKey = card['id']?.toString() ?? 'hero_${e.index}';
      return Positioned(
        key: ValueKey<String>('map_hero_$cardKey'),
        left: dx,
        top: dy,
        width: cardW,
        height: stackH,
        child: RepaintBoundary(
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.topCenter,
            filterQuality: FilterQuality.medium,
            child: GestureDetector(
              onTap: () => widget.onCardTap(card),
              child: _HeroCardSurface(
                accent: accent,
                iconName: card['icon'] as String,
                title: card['title'] as String,
                subtitle: card['subtitle'] as String,
                description: card['description'] as String,
                imageUrl: imageUrl,
                memCacheWidth:
                    (parentW * 0.88 * MediaQuery.devicePixelRatioOf(context))
                        .round(),
                highlights: highlights,
                pageDelta: p,
                stackDepth: p > 0 ? p.clamp(0.0, 3.0) : 0.0,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}

class _StackEntry {
  final int index;
  final double pos;
  _StackEntry({required this.index, required this.pos});
}

class _HeroCardSurface extends StatelessWidget {
  final Color accent;
  final String iconName;
  final String title;
  final String subtitle;
  final String description;
  final String? imageUrl;

  /// Decoded width for memory cache (device pixels).
  final int memCacheWidth;
  final List<String> highlights;
  final double pageDelta;

  /// Depth in the stack (0 = front). Used for an opaque dim on back cards only.
  final double stackDepth;

  const _HeroCardSurface({
    required this.accent,
    required this.iconName,
    required this.title,
    required this.subtitle,
    required this.description,
    this.imageUrl,
    required this.memCacheWidth,
    required this.highlights,
    required this.pageDelta,
    this.stackDepth = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final palette = _HeroPalette.fromAccent(accent: accent, isDark: isDark);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: palette.gradient,
          stops: const [0.0, 0.48, 1.0],
        ),
        border: Border.all(color: palette.border),
        boxShadow: [
          BoxShadow(
            color: palette.shadow,
            blurRadius: 32,
            spreadRadius: -6,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imageUrl != null && imageUrl!.isNotEmpty)
              Positioned.fill(
                child: _HeroNetworkImage(
                  imageUrl: imageUrl!,
                  memCacheWidth: memCacheWidth,
                ),
              ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.06),
                      Colors.black.withValues(alpha: 0.28),
                      Colors.black.withValues(alpha: 0.62),
                    ],
                    stops: const [0.0, 0.45, 1.0],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      accent.withValues(alpha: 0.08),
                      accent.withValues(alpha: 0.03),
                      Colors.black.withValues(alpha: 0.10),
                    ],
                    stops: const [0.0, 0.35, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 18.h,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.12),
                        Colors.white.withValues(alpha: 0.03),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.18, 1.0],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: -28 + (pageDelta * 4),
              right: -26 - (pageDelta * 8),
              child: Container(
                width: 42.w,
                height: 22.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [palette.orb, Colors.transparent],
                  ),
                ),
              ),
            ),
            if (stackDepth > 0.001)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    color: Colors.black.withValues(
                      alpha: (0.06 + stackDepth * 0.05).clamp(0.06, 0.22),
                    ),
                  ),
                ),
              ),
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.fromLTRB(5.5.w, 4.6.h, 5.5.w, 2.6.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.35.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            color: palette.chipBackground,
                            border: Border.all(color: palette.chipBorder),
                          ),
                          child: CustomIconWidget(
                            iconName: iconName,
                            color: palette.icon,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 2.8.w),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.5.w,
                              vertical: 0.55.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999),
                              color: palette.chipBackground,
                              border: Border.all(
                                color: palette.chipBorder,
                              ),
                            ),
                            child: Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: palette.onSurfaceHigh,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.15,
                                fontSize: 15.5.sp,
                                height: 1.25,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Expanded(child: SizedBox.shrink()),
                    Text(
                      title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: palette.onSurfaceHigh,
                        fontWeight: FontWeight.w800,
                        height: 1.12,
                        letterSpacing: -0.35,
                        fontSize: 24.sp,
                      ),
                    ),
                    SizedBox(height: 1.15.h),
                    Text(
                      description,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: palette.onSurfaceLow,
                        height: 1.45,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 1.8.h),
                    if (highlights.isNotEmpty)
                      _AutoHighlightText(
                        lines: highlights,
                        accent: accent,
                        palette: palette,
                      ),
                    SizedBox(height: 1.3.h),
                    Row(
                      children: [
                        Text(
                          'Open now',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: palette.onSurfaceHigh,
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp,
                            height: 1.2,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: EdgeInsets.all(2.1.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: palette.actionBackground,
                            border: Border.all(
                              color: palette.actionBorder,
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            color: palette.onSurfaceHigh,
                            size: 21,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroNetworkImage extends StatelessWidget {
  final String imageUrl;
  final int memCacheWidth;

  const _HeroNetworkImage({
    required this.imageUrl,
    required this.memCacheWidth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNetwork =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

    if (!isNetwork) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.12),
        ),
        child: Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
          ),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      cacheManager: ImageCacheManager.instance,
      fit: BoxFit.cover,
      alignment: Alignment.center,
      memCacheWidth: memCacheWidth,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      filterQuality: FilterQuality.high,
      placeholder: (context, url) => DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surfaceContainerHighest,
              theme.colorScheme.surfaceContainer,
              theme.colorScheme.surfaceContainerHigh,
            ],
          ),
        ),
        child: const Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      errorWidget: (context, url, error) {
        final fallback = theme.colorScheme.primary.withValues(alpha: 0.12);
        return DecoratedBox(
          decoration: BoxDecoration(color: fallback),
          child: Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
            ),
          ),
        );
      },
    );
  }
}

class _AutoHighlightText extends StatefulWidget {
  final List<String> lines;
  final Color accent;
  final _HeroPalette palette;

  const _AutoHighlightText({
    required this.lines,
    required this.accent,
    required this.palette,
  });

  @override
  State<_AutoHighlightText> createState() => _AutoHighlightTextState();
}

class _AutoHighlightTextState extends State<_AutoHighlightText> {
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 2200), (_) {
      if (!mounted) return;
      setState(() => _index = (_index + 1) % widget.lines.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.lines[_index];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: widget.palette.chipBackground,
        border: Border.all(color: widget.palette.chipBorder),
      ),
      child: Row(
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            color: widget.palette.icon,
            size: 20,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 450),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.25),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Text(
                text,
                key: ValueKey(text),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: widget.palette.onSurfaceHigh,
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                  height: 1.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroPalette {
  final List<Color> gradient;
  final Color border;
  final Color shadow;
  final Color orb;
  final Color chipBackground;
  final Color chipBorder;
  final Color actionBackground;
  final Color actionBorder;
  final Color onSurfaceHigh;
  final Color onSurfaceLow;
  final Color icon;

  const _HeroPalette({
    required this.gradient,
    required this.border,
    required this.shadow,
    required this.orb,
    required this.chipBackground,
    required this.chipBorder,
    required this.actionBackground,
    required this.actionBorder,
    required this.onSurfaceHigh,
    required this.onSurfaceLow,
    required this.icon,
  });

  static _HeroPalette fromAccent({
    required Color accent,
    required bool isDark,
  }) {
    final hsl = HSLColor.fromColor(accent);
    final deepA = hsl.withLightness(isDark ? 0.22 : 0.70).toColor();
    final deepB = hsl
        .withSaturation((hsl.saturation * (isDark ? 1.0 : 0.6)).clamp(0.0, 1.0))
        .withLightness(isDark ? 0.14 : 0.55)
        .toColor();
    final deepC = isDark
        ? const Color(0xFF051126)
        : hsl
              .withSaturation((hsl.saturation * 0.35).clamp(0.0, 1.0))
              .withLightness(0.40)
              .toColor();

    if (isDark) {
      return _HeroPalette(
        gradient: [deepA, deepB, deepC],
        border: Colors.white.withValues(alpha: 0.20),
        shadow: accent.withValues(alpha: 0.36),
        orb: Colors.white.withValues(alpha: 0.20),
        chipBackground: Colors.white.withValues(alpha: 0.12),
        chipBorder: Colors.white.withValues(alpha: 0.22),
        actionBackground: Colors.white.withValues(alpha: 0.14),
        actionBorder: Colors.white.withValues(alpha: 0.26),
        onSurfaceHigh: Colors.white.withValues(alpha: 0.96),
        onSurfaceLow: Colors.white.withValues(alpha: 0.82),
        icon: Colors.white,
      );
    }

    return _HeroPalette(
      gradient: [deepA, deepB, deepC],
      border: Colors.white.withValues(alpha: 0.40),
      shadow: accent.withValues(alpha: 0.28),
      orb: Colors.white.withValues(alpha: 0.26),
      chipBackground: Colors.white.withValues(alpha: 0.28),
      chipBorder: Colors.white.withValues(alpha: 0.45),
      actionBackground: Colors.white.withValues(alpha: 0.30),
      actionBorder: Colors.white.withValues(alpha: 0.52),
      onSurfaceHigh: Colors.white,
      onSurfaceLow: Colors.white.withValues(alpha: 0.88),
      icon: Colors.white,
    );
  }
}
