import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myitihas/i18n/strings.g.dart';

// ──────────────────────────────────────────────────────────────────────────────
//  HeroGenerateButton2  —  Explore Heritage CTA
//  Theme: ancient cartography meets modern glow
//  Colour: deep emerald-teal (#0A2A1F → #0E5C3A → #16A34A) + gold accents
//
//  Animations:
//    • Breathing glow + scale idle pulse
//    • Floating map-pin particles (circles + tiny cross markers)
//    • Diagonal parchment shimmer sweep
//    • Spinning compass rose (top-right, CustomPainter)
//    • Expanding ripple rings beneath the card
//    • Tap burst — radial emerald explosion
//    • Animated route path drawing across the card
// ──────────────────────────────────────────────────────────────────────────────

class HeroGenerateButton2 extends StatefulWidget {
  final VoidCallback onTap;

  const HeroGenerateButton2({super.key, required this.onTap});

  @override
  State<HeroGenerateButton2> createState() => _HeroGenerateButton2State();
}

class _HeroGenerateButton2State extends State<HeroGenerateButton2>
    with TickerProviderStateMixin {
  // Press
  late final AnimationController _pressCtrl;
  late final Animation<double> _pressScale;

  // Idle breathe
  late final AnimationController _breatheCtrl;
  late final Animation<double> _breathe;

  // Particles
  late final AnimationController _particleCtrl;

  // Shimmer sweep
  late final AnimationController _shimmerCtrl;
  late final Animation<double> _shimmer;

  // Compass rose spin
  late final AnimationController _compassCtrl;
  late final Animation<double> _compassAngle;

  // Tap burst
  late final AnimationController _burstCtrl;
  late final Animation<double> _burstScale;
  late final Animation<double> _burstOpacity;

  // Ripple rings beneath card
  late final AnimationController _rippleCtrl;

  // Animated route path draw
  late final AnimationController _routeCtrl;
  late final Animation<double> _routeDraw;

  @override
  void initState() {
    super.initState();

    _pressCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 140));
    _pressScale = Tween(begin: 1.0, end: 0.965).animate(
        CurvedAnimation(parent: _pressCtrl, curve: Curves.easeOutCubic));

    _breatheCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000))
      ..repeat(reverse: true);
    _breathe = CurvedAnimation(parent: _breatheCtrl, curve: Curves.easeInOut);

    _particleCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 5500))
      ..repeat();

    _shimmerCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3600))
      ..repeat();
    _shimmer = CurvedAnimation(parent: _shimmerCtrl, curve: Curves.linear);

    _compassCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 14000))
      ..repeat();
    _compassAngle =
        Tween(begin: 0.0, end: 2 * math.pi).animate(_compassCtrl);

    _burstCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 650));
    _burstScale = Tween(begin: 0.5, end: 2.0).animate(
        CurvedAnimation(parent: _burstCtrl, curve: Curves.easeOut));
    _burstOpacity = Tween(begin: 0.50, end: 0.0).animate(
        CurvedAnimation(parent: _burstCtrl, curve: Curves.easeIn));

    _rippleCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2400))
      ..repeat();

    // Route path draws itself over 2.8 s then resets
    _routeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2800))
      ..repeat();
    _routeDraw = CurvedAnimation(parent: _routeCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    _breatheCtrl.dispose();
    _particleCtrl.dispose();
    _shimmerCtrl.dispose();
    _compassCtrl.dispose();
    _burstCtrl.dispose();
    _rippleCtrl.dispose();
    _routeCtrl.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    _pressCtrl.forward();
    HapticFeedback.mediumImpact();
  }

  void _onTapUp(TapUpDetails _) {
    _pressCtrl.reverse();
    _burstCtrl
      ..reset()
      ..forward();
    widget.onTap();
  }

  void _onTapCancel() => _pressCtrl.reverse();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _pressCtrl,
            _breatheCtrl,
            _particleCtrl,
            _shimmerCtrl,
            _compassCtrl,
            _burstCtrl,
            _rippleCtrl,
            _routeCtrl,
          ]),
          builder: (context, _) {
            final breatheVal = _breathe.value;
            final glowRadius = 26.0 + breatheVal * 16.0;
            final glowAlpha = 0.32 + breatheVal * 0.20;

            return Transform.scale(
              scale: _pressScale.value,
              child: SizedBox(
                height: 108.h,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // ── Ripple rings beneath ──────────────────────────────
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _RippleRingsPainter(
                          progress: _rippleCtrl.value,
                          isDark: isDark,
                        ),
                      ),
                    ),

                    // ── Tap burst ─────────────────────────────────────────
                    if (_burstCtrl.isAnimating || _burstCtrl.value > 0)
                      Positioned.fill(
                        child: Transform.scale(
                          scale: _burstScale.value,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28.r),
                              gradient: RadialGradient(
                                colors: [
                                  const Color(0xFF34D399).withValues(
                                      alpha: _burstOpacity.value),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                    // ── Main card ─────────────────────────────────────────
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(26.r),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [0.0, 0.45, 1.0],
                            colors: [
                              Color(0xFF0A2A1F), // deep forest night
                              Color(0xFF0E5C3A), // ancient moss
                              Color(0xFF166534), // heritage green
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF15803D)
                                  .withValues(alpha: glowAlpha),
                              blurRadius: glowRadius,
                              spreadRadius: -4,
                              offset: const Offset(0, 12),
                            ),
                            BoxShadow(
                              color: const Color(0xFF34D399)
                                  .withValues(alpha: 0.14),
                              blurRadius: 18,
                              spreadRadius: -8,
                              offset: const Offset(0, -2),
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.32),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(26.r),
                          child: Stack(
                            children: [
                              // ── Parchment cross-diagonal tint ──────────
                              Positioned.fill(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        const Color(0xFFFBBF24)
                                            .withValues(alpha: 0.06),
                                        Colors.transparent,
                                        const Color(0xFF34D399)
                                            .withValues(alpha: 0.08),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // ── Map grid dots ──────────────────────────
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: _MapGridPainter(),
                                ),
                              ),

                              // ── Animated route path ────────────────────
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: _RoutePathPainter(
                                    drawProgress: _routeDraw.value,
                                  ),
                                ),
                              ),

                              // ── Floating pin particles ─────────────────
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: _MapParticlePainter(
                                    progress: _particleCtrl.value,
                                  ),
                                ),
                              ),

                              // ── Parchment shimmer sweep ────────────────
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: _ParchmentSweepPainter(
                                    progress: _shimmer.value,
                                  ),
                                ),
                              ),

                              // ── Spinning compass (top-right) ───────────
                              Positioned(
                                top: -28.h,
                                right: -28.w,
                                child: SizedBox(
                                  width: 106.w,
                                  height: 106.w,
                                  child: CustomPaint(
                                    painter: _CompassRosePainter(
                                      angle: _compassAngle.value,
                                      breathe: breatheVal,
                                    ),
                                  ),
                                ),
                              ),

                              // ── Bottom-left gold orb ───────────────────
                              Positioned(
                                bottom: -44.h,
                                left: -30.w,
                                child: Container(
                                  width: 110.w,
                                  height: 110.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        const Color(0xFFFBBF24).withValues(
                                            alpha: 0.10 + breatheVal * 0.07),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // ── Top glass highlight ────────────────────
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                height: 46.h,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.white.withValues(alpha: 0.10),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // ── Bottom vignette ────────────────────────
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                height: 48.h,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withValues(alpha: 0.22),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // ── CONTENT ────────────────────────────────
                              Positioned.fill(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Icon with glowing pin ring
                                      _MapIconBox(
                                        breathe: breatheVal,
                                        child: FaIcon(
                                          FontAwesomeIcons.mapLocationDot,
                                          size: 24.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 16.w),

                                      // Text
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              t.homeScreen.exploreHeritageTitle,
                                              style: theme.textTheme.titleLarge
                                                  ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 19.sp,
                                                letterSpacing: -0.3,
                                                shadows: [
                                                  Shadow(
                                                    color:
                                                        const Color(0xFF34D399)
                                                            .withValues(
                                                                alpha: 0.50),
                                                    blurRadius: 12,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 3.h),
                                            Row(
                                              children: [
                                                // Animated gold pin dot
                                                Container(
                                                  width: 5.w,
                                                  height: 5.w,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: const Color(
                                                            0xFFFBBF24)
                                                        .withValues(
                                                            alpha: 0.70 +
                                                                breatheVal *
                                                                    0.30),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: const Color(
                                                                0xFFFBBF24)
                                                            .withValues(
                                                                alpha: 0.55),
                                                        blurRadius: 6,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 6.w),
                                                Text(
                                                  t.homeScreen.exploreHeritageDesc,
                                                  style: theme
                                                      .textTheme.bodySmall
                                                      ?.copyWith(
                                                    color: Colors.white
                                                        .withValues(
                                                            alpha: 0.72),
                                                    fontSize: 12.sp,
                                                    letterSpacing: 0.1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Animated arrow
                                      _MapArrow(breathe: breatheVal),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
//  Map Icon Box  — icon with pulsing location-pin ring
// ──────────────────────────────────────────────────────────────────────────────

class _MapIconBox extends StatelessWidget {
  final double breathe;
  final Widget child;

  const _MapIconBox({required this.breathe, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow ring
        Container(
          width: 58.w,
          height: 58.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                const Color(0xFF34D399)
                    .withValues(alpha: 0.16 + breathe * 0.12),
                Colors.transparent,
              ],
            ),
          ),
        ),
        // Icon box
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.20 + breathe * 0.06),
                const Color(0xFF34D399).withValues(alpha: 0.12),
              ],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25 + breathe * 0.10),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6EE7B7)
                    .withValues(alpha: 0.30 + breathe * 0.18),
                blurRadius: 14,
                spreadRadius: -2,
              ),
            ],
          ),
          child: child,
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
//  Map Arrow  — arrow in a pulsing circle
// ──────────────────────────────────────────────────────────────────────────────

class _MapArrow extends StatelessWidget {
  final double breathe;

  const _MapArrow({required this.breathe});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 36.w + breathe * 4.w,
          height: 36.w + breathe * 4.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.06 + breathe * 0.04),
            border: Border.all(
              color: const Color(0xFF34D399)
                  .withValues(alpha: 0.28 + breathe * 0.14),
              width: 1.0,
            ),
          ),
        ),
        FaIcon(
          FontAwesomeIcons.arrowRight,
          color: Colors.white.withValues(alpha: 0.90),
          size: 15.sp,
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
//  Ripple Rings Painter  — oval rings expanding below the card
// ──────────────────────────────────────────────────────────────────────────────

class _RippleRingsPainter extends CustomPainter {
  final double progress;
  final bool isDark;

  const _RippleRingsPainter({required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    for (var i = 0; i < 2; i++) {
      final t = (progress + i * 0.5) % 1.0;
      final radiusW = size.width * 0.44 + t * size.width * 0.24;
      final radiusH = radiusW * 0.26;
      final alpha = (1.0 - t) * (isDark ? 0.16 : 0.09);

      canvas.drawOval(
        Rect.fromCenter(
            center: Offset(cx, cy),
            width: radiusW * 2,
            height: radiusH * 2),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..color = const Color(0xFF34D399).withValues(alpha: alpha),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RippleRingsPainter old) =>
      old.progress != progress;
}

// ──────────────────────────────────────────────────────────────────────────────
//  Map Grid Painter  — faint dot grid for cartography feel
// ──────────────────────────────────────────────────────────────────────────────

class _MapGridPainter extends CustomPainter {
  const _MapGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.045)
      ..style = PaintingStyle.fill;

    const spacing = 18.0;
    for (double x = spacing; x < size.width - 4; x += spacing) {
      for (double y = spacing; y < size.height - 4; y += spacing) {
        canvas.drawCircle(Offset(x, y), 0.85, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MapGridPainter old) => false;
}

// ──────────────────────────────────────────────────────────────────────────────
//  Route Path Painter  — animated dashed path between three "sites"
// ──────────────────────────────────────────────────────────────────────────────

class _RoutePathPainter extends CustomPainter {
  final double drawProgress;

  const _RoutePathPainter({required this.drawProgress});

  @override
  void paint(Canvas canvas, Size size) {
    // Three waypoints along the card
    final p0 = Offset(size.width * 0.12, size.height * 0.72);
    final p1 = Offset(size.width * 0.42, size.height * 0.30);
    final p2 = Offset(size.width * 0.72, size.height * 0.65);

    // Build full path length approximation
    final fullPath = Path()
      ..moveTo(p0.dx, p0.dy)
      ..lineTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy);

    // Use PathMetrics to draw only the animated portion
    final metrics = fullPath.computeMetrics().toList();
    for (final metric in metrics) {
      final drawn = metric.extractPath(0, metric.length * drawProgress);
      canvas.drawPath(
        drawn,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0
          ..color = const Color(0xFF6EE7B7).withValues(alpha: 0.35)
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }

    // Draw pin dots at waypoints that have been reached
    final pins = [p0, p1, p2];
    final thresholds = [0.0, 0.50, 1.0];
    for (var i = 0; i < pins.length; i++) {
      if (drawProgress >= thresholds[i]) {
        final opacity = ((drawProgress - thresholds[i]) * 3).clamp(0.0, 1.0);
        // Outer ring
        canvas.drawCircle(
          pins[i],
          5.5,
          Paint()
            ..color =
                const Color(0xFF34D399).withValues(alpha: opacity * 0.22),
        );
        // Pin body
        canvas.drawCircle(
          pins[i],
          2.8,
          Paint()
            ..color = const Color(0xFF34D399).withValues(alpha: opacity * 0.80),
        );
        // Gold highlight
        canvas.drawCircle(
          pins[i],
          1.2,
          Paint()
            ..color = const Color(0xFFFBBF24).withValues(alpha: opacity * 0.90),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RoutePathPainter old) =>
      old.drawProgress != drawProgress;
}

// ──────────────────────────────────────────────────────────────────────────────
//  Map Particle Painter  — floating location pins + dots
// ──────────────────────────────────────────────────────────────────────────────

class _MapParticlePainter extends CustomPainter {
  final double progress;

  const _MapParticlePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(31);

    for (var i = 0; i < 20; i++) {
      final baseX = rng.nextDouble() * size.width;
      final baseY = rng.nextDouble() * size.height;
      final speed = 0.12 + rng.nextDouble() * 0.50;
      final phase = rng.nextDouble();
      final t = (progress * speed + phase) % 1.0;

      final x = baseX + math.sin(t * 2 * math.pi + phase * 2) * 6.0;
      final y = baseY - t * size.height * 0.70;
      final opacity =
          (math.sin(t * math.pi) * 0.48 * (0.35 + rng.nextDouble() * 0.65))
              .clamp(0.0, 0.48);
      final radius = 0.7 + rng.nextDouble() * 1.8;

      final colors = [
        const Color(0xFF34D399),
        const Color(0xFF6EE7B7),
        const Color(0xFFFBBF24), // gold accent particles
        const Color(0xFFA7F3D0),
      ];
      final color = colors[i % colors.length];

      // 20% as tiny cross/plus markers (map pin feel)
      if (i % 5 == 0) {
        _drawCross(canvas, Offset(x, y), radius * 1.6,
            Paint()
              ..color = color.withValues(alpha: opacity)
              ..strokeWidth = 0.8
              ..style = PaintingStyle.stroke
              ..strokeCap = StrokeCap.round);
      } else {
        canvas.drawCircle(
          Offset(x, y),
          radius,
          Paint()..color = color.withValues(alpha: opacity),
        );
      }
    }
  }

  void _drawCross(Canvas canvas, Offset center, double r, Paint paint) {
    canvas.drawLine(
        Offset(center.dx - r, center.dy), Offset(center.dx + r, center.dy), paint);
    canvas.drawLine(
        Offset(center.dx, center.dy - r), Offset(center.dx, center.dy + r), paint);
  }

  @override
  bool shouldRepaint(covariant _MapParticlePainter old) =>
      old.progress != progress;
}

// ──────────────────────────────────────────────────────────────────────────────
//  Parchment Sweep Painter  — warm gold-tinted shimmer band
// ──────────────────────────────────────────────────────────────────────────────

class _ParchmentSweepPainter extends CustomPainter {
  final double progress;

  const _ParchmentSweepPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final shimmerX = -size.width * 0.5 + (size.width * 2.0) * progress;

    // Warm gold-tinted shimmer
    final shimmerPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.transparent,
          const Color(0xFFFBBF24).withValues(alpha: 0.04),
          const Color(0xFFA7F3D0).withValues(alpha: 0.10),
          const Color(0xFFFBBF24).withValues(alpha: 0.04),
          Colors.transparent,
        ],
        stops: const [0.0, 0.30, 0.50, 0.70, 1.0],
        transform: const GradientRotation(0.30),
      ).createShader(Rect.fromLTWH(
          shimmerX - size.width * 0.28, 0, size.width * 0.56, size.height));

    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), shimmerPaint);

    // Secondary cooler sweep (opposite direction, slower)
    final coolX =
        size.width * 1.1 - (size.width * 2.0) * ((progress * 0.55) % 1.0);
    final coolPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.transparent,
          const Color(0xFF6EE7B7).withValues(alpha: 0.06),
          Colors.transparent,
        ],
        stops: const [0.0, 0.50, 1.0],
        transform: const GradientRotation(-0.18),
      ).createShader(Rect.fromLTWH(
          coolX - size.width * 0.20, 0, size.width * 0.40, size.height));

    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), coolPaint);
  }

  @override
  bool shouldRepaint(covariant _ParchmentSweepPainter old) =>
      old.progress != progress;
}

// ──────────────────────────────────────────────────────────────────────────────
//  Compass Rose Painter  — 8-point compass with spinning cardinal arms
// ──────────────────────────────────────────────────────────────────────────────

class _CompassRosePainter extends CustomPainter {
  final double angle;
  final double breathe;

  const _CompassRosePainter({required this.angle, required this.breathe});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.36;

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF34D399)
          .withValues(alpha: 0.28 + breathe * 0.14);

    // Outer dashed ring
    const dashCount = 16;
    for (var i = 0; i < dashCount; i++) {
      final a = angle + (2 * math.pi / dashCount) * i;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        a,
        (2 * math.pi / dashCount) * 0.55,
        false,
        strokePaint..strokeWidth = 0.8,
      );
    }

    // 8 cardinal + inter-cardinal arms
    const arms = 8;
    for (var i = 0; i < arms; i++) {
      final a = angle + (2 * math.pi / arms) * i;
      final isCardinal = i % 2 == 0;
      final armLen = isCardinal ? r * 0.78 : r * 0.52;
      final innerR = r * 0.18;

      canvas.drawLine(
        Offset(cx + innerR * math.cos(a), cy + innerR * math.sin(a)),
        Offset(cx + armLen * math.cos(a), cy + armLen * math.sin(a)),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = isCardinal ? 1.1 : 0.6
          ..strokeCap = StrokeCap.round
          ..color = (isCardinal
                  ? const Color(0xFF6EE7B7)
                  : const Color(0xFF34D399))
              .withValues(alpha: isCardinal ? 0.40 + breathe * 0.16 : 0.22),
      );

      // Arrow tip on cardinal arms
      if (isCardinal) {
        final tipX = cx + armLen * math.cos(a);
        final tipY = cy + armLen * math.sin(a);
        final perpA = a + math.pi / 2;
        final tipSize = 3.5;
        final path = Path()
          ..moveTo(tipX, tipY)
          ..lineTo(
              tipX - tipSize * math.cos(a) + tipSize * 0.5 * math.cos(perpA),
              tipY - tipSize * math.sin(a) + tipSize * 0.5 * math.sin(perpA))
          ..lineTo(
              tipX - tipSize * math.cos(a) - tipSize * 0.5 * math.cos(perpA),
              tipY - tipSize * math.sin(a) - tipSize * 0.5 * math.sin(perpA))
          ..close();
        canvas.drawPath(
          path,
          Paint()
            ..style = PaintingStyle.fill
            ..color = const Color(0xFFFBBF24)
                .withValues(alpha: 0.55 + breathe * 0.25),
        );
      }
    }

    // Centre circle
    canvas.drawCircle(
      Offset(cx, cy),
      3.0 + breathe * 1.2,
      Paint()
        ..color = const Color(0xFF6EE7B7)
            .withValues(alpha: 0.55 + breathe * 0.30),
    );
    // Centre gold dot
    canvas.drawCircle(
      Offset(cx, cy),
      1.3,
      Paint()
        ..color = const Color(0xFFFBBF24).withValues(alpha: 0.80),
    );
  }

  @override
  bool shouldRepaint(covariant _CompassRosePainter old) =>
      old.angle != angle || old.breathe != breathe;
}