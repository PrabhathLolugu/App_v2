import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myitihas/i18n/strings.g.dart';

// ──────────────────────────────────────────────────────────────────────────────
//  HeroGenerateButton
//  A premium, richly animated CTA button with:
//    • Floating sacred ink particles (CustomPainter)
//    • Pulsing concentric aura rings
//    • Diagonal aurora shimmer sweep
//    • Animated spinning mandala ring (top-right corner)
//    • Multi-layer press with spring scale + glow burst
//    • Idle breathing glow cycle
// ──────────────────────────────────────────────────────────────────────────────

class HeroGenerateButton extends StatefulWidget {
  final VoidCallback onTap;

  const HeroGenerateButton({super.key, required this.onTap});

  @override
  State<HeroGenerateButton> createState() => _HeroGenerateButtonState();
}

class _HeroGenerateButtonState extends State<HeroGenerateButton>
    with TickerProviderStateMixin {
  // ── Press scale ───────────────────────────────────────────────────────────
  late final AnimationController _pressCtrl;
  late final Animation<double> _pressScale;

  // ── Idle breathing glow ───────────────────────────────────────────────────
  late final AnimationController _breatheCtrl;
  late final Animation<double> _breathe;

  // ── Floating particles ────────────────────────────────────────────────────
  late final AnimationController _particleCtrl;

  // ── Shimmer sweep ─────────────────────────────────────────────────────────
  late final AnimationController _shimmerCtrl;
  late final Animation<double> _shimmer;

  // ── Mandala spin ──────────────────────────────────────────────────────────
  late final AnimationController _mandalaCtrl;
  late final Animation<double> _mandalaAngle;

  // ── Tap burst (one-shot) ──────────────────────────────────────────────────
  late final AnimationController _burstCtrl;
  late final Animation<double> _burstScale;
  late final Animation<double> _burstOpacity;

  // ── Aura rings pulse ──────────────────────────────────────────────────────
  late final AnimationController _auraCtrl;

  @override
  void initState() {
    super.initState();

    // Press
    _pressCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 140));
    _pressScale = Tween(begin: 1.0, end: 0.965).animate(
        CurvedAnimation(parent: _pressCtrl, curve: Curves.easeOutCubic));

    // Breathe (2.8 s cycle)
    _breatheCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2800))
      ..repeat(reverse: true);
    _breathe = CurvedAnimation(parent: _breatheCtrl, curve: Curves.easeInOut);

    // Particles (5 s loop)
    _particleCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 5000))
      ..repeat();

    // Shimmer (3.2 s loop)
    _shimmerCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3200))
      ..repeat();
    _shimmer = CurvedAnimation(parent: _shimmerCtrl, curve: Curves.linear);

    // Mandala slow spin (12 s per full rotation)
    _mandalaCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 12000))
      ..repeat();
    _mandalaAngle =
        Tween(begin: 0.0, end: 2 * math.pi).animate(_mandalaCtrl);

    // Burst
    _burstCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _burstScale = Tween(begin: 0.6, end: 1.8).animate(
        CurvedAnimation(parent: _burstCtrl, curve: Curves.easeOut));
    _burstOpacity = Tween(begin: 0.55, end: 0.0).animate(
        CurvedAnimation(parent: _burstCtrl, curve: Curves.easeIn));

    // Aura rings (2.2 s)
    _auraCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2200))
      ..repeat();
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    _breatheCtrl.dispose();
    _particleCtrl.dispose();
    _shimmerCtrl.dispose();
    _mandalaCtrl.dispose();
    _burstCtrl.dispose();
    _auraCtrl.dispose();
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
            _mandalaCtrl,
            _burstCtrl,
            _auraCtrl,
          ]),
          builder: (context, _) {
            final breatheVal = _breathe.value;
            final glowRadius = 28.0 + breatheVal * 18.0;
            final glowAlpha = 0.38 + breatheVal * 0.22;

            return Transform.scale(
              scale: _pressScale.value,
              child: SizedBox(
                height: 108.h,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // ── Aura rings (behind card) ──────────────────────────
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _AuraRingsPainter(
                          progress: _auraCtrl.value,
                          isDark: isDark,
                        ),
                      ),
                    ),

                    // ── Tap burst overlay ─────────────────────────────────
                    if (_burstCtrl.isAnimating || _burstCtrl.value > 0)
                      Positioned.fill(
                        child: Transform.scale(
                          scale: _burstScale.value,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28.r),
                              gradient: RadialGradient(
                                colors: [
                                  const Color(0xFFA78BFA).withValues(
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
                              Color(0xFF2D0E6B), // deep sacred violet
                              Color(0xFF5B21B6), // rich amethyst
                              Color(0xFF7C3AED), // electric violet
                            ],
                          ),
                          boxShadow: [
                            // Primary depth shadow
                            BoxShadow(
                              color: const Color(0xFF6D28D9)
                                  .withValues(alpha: glowAlpha),
                              blurRadius: glowRadius,
                              spreadRadius: -4,
                              offset: const Offset(0, 12),
                            ),
                            // Cool-tone upper rim
                            BoxShadow(
                              color: const Color(0xFFA78BFA)
                                  .withValues(alpha: 0.18),
                              blurRadius: 20,
                              spreadRadius: -8,
                              offset: const Offset(0, -2),
                            ),
                            // Dark base shadow
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.30),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(26.r),
                          child: Stack(
                            children: [
                              // ── Deep base diagonal tint ────────────────
                              Positioned.fill(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        const Color(0xFFF0ABFC)
                                            .withValues(alpha: 0.06),
                                        Colors.transparent,
                                        const Color(0xFF4338CA)
                                            .withValues(alpha: 0.12),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // ── Floating particles ─────────────────────
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: _SacredParticlePainter(
                                    progress: _particleCtrl.value,
                                  ),
                                ),
                              ),

                              // ── Aurora shimmer sweep ───────────────────
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: _AuroraSweepPainter(
                                    progress: _shimmer.value,
                                  ),
                                ),
                              ),

                              // ── Spinning mandala (top-right) ───────────
                              Positioned(
                                top: -32.h,
                                right: -32.w,
                                child: SizedBox(
                                  width: 110.w,
                                  height: 110.w,
                                  child: CustomPaint(
                                    painter: _MandalaPainter(
                                      angle: _mandalaAngle.value,
                                      breathe: breatheVal,
                                    ),
                                  ),
                                ),
                              ),

                              // ── Bottom-left secondary orb ──────────────
                              Positioned(
                                bottom: -40.h,
                                left: -28.w,
                                child: Container(
                                  width: 120.w,
                                  height: 120.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        const Color(0xFFC084FC).withValues(
                                            alpha: 0.14 + breatheVal * 0.08),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // ── Top glass edge highlight ───────────────
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                height: 48.h,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.white.withValues(alpha: 0.12),
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
                                height: 50.h,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withValues(alpha: 0.18),
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
                                      // Icon container with inner glow
                                      _AnimatedIconBox(
                                        breathe: breatheVal,
                                        child: FaIcon(
                                          FontAwesomeIcons.wandMagicSparkles,
                                          size: 24.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 16.w),

                                      // Text block
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              t.homeScreen.generateStory,
                                              style: theme.textTheme.titleLarge
                                                  ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 19.sp,
                                                letterSpacing: -0.3,
                                                shadows: [
                                                  Shadow(
                                                    color:
                                                        const Color(0xFFA78BFA)
                                                            .withValues(
                                                                alpha: 0.55),
                                                    blurRadius: 12,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 3.h),
                                            Row(
                                              children: [
                                                Container(
                                                  width: 5.w,
                                                  height: 5.w,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: const Color(
                                                            0xFFC084FC)
                                                        .withValues(
                                                            alpha: 0.70 +
                                                                breatheVal *
                                                                    0.30),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: const Color(
                                                                0xFFC084FC)
                                                            .withValues(
                                                                alpha: 0.55),
                                                        blurRadius: 6,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 6.w),
                                                Text(
                                                  'Create your scriptural tale',
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

                                      // Arrow with animated pulse ring
                                      _AnimatedArrow(breathe: breatheVal),
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
//  Animated Icon Box  — inner glow ring that breathes
// ──────────────────────────────────────────────────────────────────────────────

class _AnimatedIconBox extends StatelessWidget {
  final double breathe;
  final Widget child;

  const _AnimatedIconBox({required this.breathe, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer soft glow ring
        Container(
          width: 58.w,
          height: 58.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                const Color(0xFFA78BFA)
                    .withValues(alpha: 0.18 + breathe * 0.14),
                Colors.transparent,
              ],
            ),
          ),
        ),
        // Main box
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.22 + breathe * 0.06),
                const Color(0xFFA78BFA).withValues(alpha: 0.15),
              ],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.28 + breathe * 0.10),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFDDD6FE)
                    .withValues(alpha: 0.35 + breathe * 0.20),
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
//  Animated Arrow  — pulsing concentric ring around chevron
// ──────────────────────────────────────────────────────────────────────────────

class _AnimatedArrow extends StatelessWidget {
  final double breathe;

  const _AnimatedArrow({required this.breathe});

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
            color:
                Colors.white.withValues(alpha: 0.06 + breathe * 0.04),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.18 + breathe * 0.10),
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
//  Aura Rings Painter  — two expanding rings beneath the card
// ──────────────────────────────────────────────────────────────────────────────

class _AuraRingsPainter extends CustomPainter {
  final double progress;
  final bool isDark;

  const _AuraRingsPainter({required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    for (var i = 0; i < 2; i++) {
      final t = (progress + i * 0.5) % 1.0;
      final radius = (size.width * 0.42) + t * size.width * 0.22;
      final alpha = (1.0 - t) * (isDark ? 0.18 : 0.10);

      canvas.drawOval(
        Rect.fromCenter(
            center: Offset(cx, cy),
            width: radius * 2.2,
            height: radius * 0.55),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = const Color(0xFFA78BFA).withValues(alpha: alpha),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AuraRingsPainter old) =>
      old.progress != progress;
}

// ──────────────────────────────────────────────────────────────────────────────
//  Sacred Particle Painter  — floating ink dots with sacred geometry feel
// ──────────────────────────────────────────────────────────────────────────────

class _SacredParticlePainter extends CustomPainter {
  final double progress;

  const _SacredParticlePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(17);

    for (var i = 0; i < 22; i++) {
      final baseX = rng.nextDouble() * size.width;
      final baseY = rng.nextDouble() * size.height;
      final speed = 0.15 + rng.nextDouble() * 0.55;
      final phase = rng.nextDouble();
      final t = (progress * speed + phase) % 1.0;

      final x = baseX + math.sin(t * 2 * math.pi + phase * 3) * 8.0;
      final y = baseY - t * size.height * 0.80;
      final opacity =
          (math.sin(t * math.pi) * 0.55 * (0.35 + rng.nextDouble() * 0.65))
              .clamp(0.0, 0.55);
      final radius = 0.8 + rng.nextDouble() * 2.0;

      // Alternate between violet family colours
      final colors = [
        const Color(0xFFC084FC),
        const Color(0xFFA78BFA),
        const Color(0xFFE9D5FF),
        const Color(0xFFF0ABFC),
      ];
      final color = colors[i % colors.length];

      // Draw particle — 80 % circles, 20 % tiny diamond shapes for variety
      if (i % 5 == 0) {
        _drawDiamond(canvas, Offset(x, y), radius * 1.4,
            Paint()..color = color.withValues(alpha: opacity));
      } else {
        canvas.drawCircle(
          Offset(x, y),
          radius,
          Paint()..color = color.withValues(alpha: opacity),
        );
      }
    }
  }

  void _drawDiamond(Canvas canvas, Offset center, double r, Paint paint) {
    final path = Path()
      ..moveTo(center.dx, center.dy - r)
      ..lineTo(center.dx + r * 0.7, center.dy)
      ..lineTo(center.dx, center.dy + r)
      ..lineTo(center.dx - r * 0.7, center.dy)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SacredParticlePainter old) =>
      old.progress != progress;
}

// ──────────────────────────────────────────────────────────────────────────────
//  Aurora Sweep Painter  — diagonal shimmer + colour-shift aurora band
// ──────────────────────────────────────────────────────────────────────────────

class _AuroraSweepPainter extends CustomPainter {
  final double progress;

  const _AuroraSweepPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // Main shimmer band
    final shimmerX =
        -size.width * 0.5 + (size.width * 2.0) * progress;

    final shimmerPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.transparent,
          const Color(0xFFE9D5FF).withValues(alpha: 0.06),
          const Color(0xFFF0ABFC).withValues(alpha: 0.13),
          const Color(0xFFE9D5FF).withValues(alpha: 0.06),
          Colors.transparent,
        ],
        stops: const [0.0, 0.30, 0.50, 0.70, 1.0],
        transform: const GradientRotation(0.35),
      ).createShader(Rect.fromLTWH(
          shimmerX - size.width * 0.30, 0, size.width * 0.60, size.height));

    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), shimmerPaint);

    // Secondary slower aurora tint (opposite direction)
    final auroraX =
        size.width * 1.2 - (size.width * 2.0) * (progress * 0.6 % 1.0);
    final auroraPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.transparent,
          const Color(0xFF818CF8).withValues(alpha: 0.07),
          Colors.transparent,
        ],
        stops: const [0.0, 0.50, 1.0],
        transform: const GradientRotation(-0.20),
      ).createShader(Rect.fromLTWH(
          auroraX - size.width * 0.22, 0, size.width * 0.44, size.height));

    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), auroraPaint);
  }

  @override
  bool shouldRepaint(covariant _AuroraSweepPainter old) =>
      old.progress != progress;
}

// ──────────────────────────────────────────────────────────────────────────────
//  Mandala Painter  — sacred geometry ring (partial arcs + petal dots)
// ──────────────────────────────────────────────────────────────────────────────

class _MandalaPainter extends CustomPainter {
  final double angle;
  final double breathe;

  const _MandalaPainter({required this.angle, required this.breathe});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final baseR = size.width * 0.34;

    // Outer ring — dashed arcs
    final outerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9
      ..color = const Color(0xFFC084FC).withValues(alpha: 0.35 + breathe * 0.15)
      ..strokeCap = StrokeCap.round;

    const segments = 12;
    for (var i = 0; i < segments; i++) {
      final startAngle = angle + (2 * math.pi / segments) * i;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: baseR),
        startAngle,
        (2 * math.pi / segments) * 0.6,
        false,
        outerPaint,
      );
    }

    // Inner ring — small dots at petal tips
    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFA78BFA).withValues(alpha: 0.45 + breathe * 0.20);

    const petals = 8;
    for (var i = 0; i < petals; i++) {
      final a = -angle * 0.7 + (2 * math.pi / petals) * i;
      final r = baseR * 0.62;
      canvas.drawCircle(
        Offset(cx + r * math.cos(a), cy + r * math.sin(a)),
        1.4,
        dotPaint,
      );
    }

    // Centre tiny circle
    canvas.drawCircle(
      Offset(cx, cy),
      2.2 + breathe * 1.0,
      Paint()
        ..color = const Color(0xFFE9D5FF).withValues(alpha: 0.50 + breathe * 0.30),
    );
  }

  @override
  bool shouldRepaint(covariant _MandalaPainter old) =>
      old.angle != angle || old.breathe != breathe;
}