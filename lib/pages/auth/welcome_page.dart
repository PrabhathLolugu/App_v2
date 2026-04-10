import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myitihas/i18n/strings.g.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  WelcomePage  — Premium "Editorial Luxury" redesign
//
//  Concept  : cinematic split-layout; large ink-bleed typography; one bold
//             geometric mandala motif that anchors the brand; deliberate
//             negative space; staggered reveal with per-character title anim.
//
//  Theme    : Deep-midnight base → electric violet → cobalt
//             Light variant : warm cream, near-black ink, same geometry
// ─────────────────────────────────────────────────────────────────────────────

// ─── Palette ──────────────────────────────────────────────────────────────────

class _P {
  // Dark
  static const dBg = Color(0xFF0A0A0F);
  static const dSurface = Color(0xFF0F172A);
  static const dViolet = Color(0xFF0088FF);
  static const dCobalt = Color(0xFF1E40AF);
  static const dVioletDim = Color(0xFF0F172A);
  static const dText = Color(0xFFFFFFFF);
  static const dTextMid = Color(0xFF94A3B8);
  static const dGem = Color(0xFF0088FF);

  // Light
  static const lBg = Color(0xFFF8FAFC);
  static const lSurface = Color(0xFFF0F4F8);
  static const lViolet = Color(0xFF0088FF);
  static const lCobalt = Color(0xFF1E40AF);
  static const lText = Color(0xFF0F172A);
  static const lTextMid = Color(0xFF64748B);
  static const lGem = Color(0xFF0088FF);
}

// ─── WelcomePage ─────────────────────────────────────────────────────────────

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  // slow mandala spin
  late final AnimationController _spinCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 28),
  )..repeat();

  // inner ring counter-spin
  late final AnimationController _innerSpinCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 18),
  )..repeat(reverse: false);

  // gentle breath / scale pulse for the gem
  late final AnimationController _breathCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3600),
  )..repeat(reverse: true);

  // staggered entry reveal
  late final AnimationController _entryCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );

  // floating ambient noise shift
  late final AnimationController _driftCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 12),
  )..repeat(reverse: true);

  bool _btnDown = false;

  // ── entry interval helpers ────────────────────────────────────────────────
  Animation<double> _fade(double b, double e) =>
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _entryCtrl,
          curve: Interval(b, e, curve: Curves.easeOut),
        ),
      );

  Animation<Offset> _slide(
    double b,
    double e, {
    Offset from = const Offset(0, 0.18),
  }) => Tween<Offset>(begin: from, end: Offset.zero).animate(
    CurvedAnimation(
      parent: _entryCtrl,
      curve: Interval(b, e, curve: Curves.easeOutCubic),
    ),
  );

  // staggered entry slots
  late final _f0 = _fade(0.00, 0.45);
  late final _s0 = _slide(0.00, 0.50);
  late final _f1 = _fade(0.18, 0.60);
  late final _s1 = _slide(0.18, 0.62);
  late final _f2 = _fade(0.35, 0.72);
  late final _s2 = _slide(0.35, 0.74);
  late final _f3 = _fade(0.50, 0.85);
  late final _s3 = _slide(0.50, 0.86);
  late final _f4 = _fade(0.65, 1.00);

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) _entryCtrl.forward();
    });
  }

  @override
  void dispose() {
    _spinCtrl.dispose();
    _innerSpinCtrl.dispose();
    _breathCtrl.dispose();
    _entryCtrl.dispose();
    _driftCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final t = Translations.of(context);
    final size = MediaQuery.of(context).size;

    // responsive logo diameter — slightly more compact
    final logoDia = (size.width * 0.38).clamp(128.0, 184.0);

    return Scaffold(
      backgroundColor: isDark ? _P.dBg : _P.lBg,
      body: Stack(
        children: [
          // ── Ambient mesh background ────────────────────────────────────
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _driftCtrl,
              builder: (_, __) => CustomPaint(
                painter: _MeshPainter(t: _driftCtrl.value, isDark: isDark),
              ),
            ),
          ),

          // ── Grain overlay (subtle noise texture) ──────────────────────
          Positioned.fill(
            child: CustomPaint(painter: _GrainPainter(isDark: isDark)),
          ),

          // ── Main content ───────────────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                // top bar: pill indicator
                FadeTransition(
                  opacity: _f0,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: _TopPill(isDark: isDark),
                  ),
                ),

                const Spacer(flex: 1),

                // Mandala / logo centrepiece
                FadeTransition(
                  opacity: _f0,
                  child: SlideTransition(
                    position: _s0,
                    child: _Mandala(
                      spinCtrl: _spinCtrl,
                      innerSpinCtrl: _innerSpinCtrl,
                      breathCtrl: _breathCtrl,
                      diameter: logoDia,
                      isDark: isDark,
                    ),
                  ),
                ),

                const Spacer(flex: 1),

                // Big editorial title
                FadeTransition(
                  opacity: _f1,
                  child: SlideTransition(
                    position: _s1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: _HeroTitle(isDark: isDark),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Subtitle
                FadeTransition(
                  opacity: _f2,
                  child: SlideTransition(
                    position: _s2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36),
                      child: _Subtitle(isDark: isDark),
                    ),
                  ),
                ),

                const Spacer(flex: 3),

                // CTA
                FadeTransition(
                  opacity: _f3,
                  child: SlideTransition(
                    position: _s3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: _PremiumButton(
                        isDark: isDark,
                        onTap: () {
                          if (!mounted) return;
                          context.go('/login');
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Footer note
                FadeTransition(
                  opacity: _f4,
                  child: Text(
                    '${t.app.name} · Your culture-your way',
                    style: GoogleFonts.ibmPlexMono(
                      fontSize: 11,
                      letterSpacing: 0.8,
                      color: isDark
                          ? _P.dTextMid.withValues(alpha: 0.55)
                          : _P.lTextMid.withValues(alpha: 0.55),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Top Pill ─────────────────────────────────────────────────────────────────

class _TopPill extends StatelessWidget {
  final bool isDark;
  const _TopPill({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final fg = isDark ? _P.dGem : _P.lGem;
    final t = Translations.of(context);
    final bg = isDark
        ? _P.dViolet.withValues(alpha: 0.12)
        : _P.lViolet.withValues(alpha: 0.10);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: fg.withValues(alpha: isDark ? 0.22 : 0.18),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: fg,
              boxShadow: [
                BoxShadow(color: fg.withValues(alpha: 0.7), blurRadius: 6),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            t.app.tagline.toUpperCase(),
            style: GoogleFonts.ibmPlexMono(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: fg,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Ambient Mesh Background ─────────────────────────────────────────────────

class _MeshPainter extends CustomPainter {
  final double t;
  final bool isDark;
  _MeshPainter({required this.t, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final blue = isDark ? _P.dViolet : _P.lViolet;
    final s = math.sin;
    final pi = math.pi;

    // blob 1 — top-right (simplified to single blue blob)
    _blob(
      canvas,
      size,
      cx: size.width * (0.82 + 0.07 * s(t * pi)),
      cy: size.height * (0.08 + 0.04 * s(t * pi * 0.7)),
      r: size.width * 0.62,
      color: blue.withValues(alpha: isDark ? 0.08 : 0.06),
    );

    // blob 2 — bottom-left subtle glow
    _blob(
      canvas,
      size,
      cx: size.width * (0.12 + 0.05 * s(t * pi * 1.2)),
      cy: size.height * (0.80 + 0.06 * s(t * pi * 0.9)),
      r: size.width * 0.70,
      color: blue.withValues(alpha: isDark ? 0.05 : 0.03),
    );
  }

  void _blob(
    Canvas canvas,
    Size size, {
    required double cx,
    required double cy,
    required double r,
    required Color color,
  }) {
    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()
        ..shader = RadialGradient(
          colors: [color, Colors.transparent],
          stops: const [0.0, 1.0],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r)),
    );
  }

  @override
  bool shouldRepaint(covariant _MeshPainter o) =>
      o.t != t || o.isDark != isDark;
}

// ─── Grain Painter ────────────────────────────────────────────────────────────

class _GrainPainter extends CustomPainter {
  final bool isDark;
  _GrainPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(314159);
    final dotColor = isDark
        ? Colors.white.withValues(alpha: 0.025)
        : Colors.black.withValues(alpha: 0.018);

    // sparse noise dots — gives a premium film-grain feel
    for (var i = 0; i < 900; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), 0.5, Paint()..color = dotColor);
    }
  }

  @override
  bool shouldRepaint(_) => false; // static — no re-paints
}

// ─── Mandala ──────────────────────────────────────────────────────────────────

class _Mandala extends StatelessWidget {
  final AnimationController spinCtrl;
  final AnimationController innerSpinCtrl;
  final AnimationController breathCtrl;
  final double diameter;
  final bool isDark;

  const _Mandala({
    required this.spinCtrl,
    required this.innerSpinCtrl,
    required this.breathCtrl,
    required this.diameter,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([spinCtrl, innerSpinCtrl, breathCtrl]),
      builder: (_, __) {
        final outerAngle = spinCtrl.value * 2 * math.pi;
        final innerAngle = -innerSpinCtrl.value * 2 * math.pi;
        final breathScale =
            0.975 + 0.025 * math.sin(breathCtrl.value * math.pi);
        final violet = isDark ? _P.dViolet : _P.lViolet;
        final cobalt = isDark ? _P.dCobalt : _P.lCobalt;
        final gem = isDark ? _P.dGem : _P.lGem;

        return SizedBox(
          width: diameter * 1.55,
          height: diameter * 1.55,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // ── Outer rune ring (12 segments) ─────────────────────
              Transform.rotate(
                angle: outerAngle,
                child: CustomPaint(
                  size: Size.square(diameter * 1.50),
                  painter: _RuneRingPainter(
                    segments: 12,
                    color: violet.withValues(alpha: isDark ? 0.22 : 0.18),
                    strokeW: 1.0,
                    gapFraction: 0.30,
                    radiusFactor: 0.75,
                  ),
                ),
              ),

              // ── Mid rune ring (8 segments, counter) ───────────────
              Transform.rotate(
                angle: innerAngle * 0.6,
                child: CustomPaint(
                  size: Size.square(diameter * 1.50),
                  painter: _RuneRingPainter(
                    segments: 8,
                    color: cobalt.withValues(alpha: isDark ? 0.15 : 0.12),
                    strokeW: 1.2,
                    gapFraction: 0.25,
                    radiusFactor: 0.60,
                  ),
                ),
              ),

              // ── Outer dashed orbit ─────────────────────────────────
              Transform.rotate(
                angle: outerAngle * 0.4,
                child: CustomPaint(
                  size: Size.square(diameter * 1.50),
                  painter: _DashedCirclePainter(
                    color: violet.withValues(alpha: isDark ? 0.12 : 0.10),
                    dashCount: 36,
                    strokeW: 0.8,
                    radiusFactor: 0.735,
                    dotRadius: 2.0,
                  ),
                ),
              ),

              // ── Inner dashed orbit ─────────────────────────────────
              Transform.rotate(
                angle: innerAngle * 0.5,
                child: CustomPaint(
                  size: Size.square(diameter * 1.50),
                  painter: _DashedCirclePainter(
                    color: cobalt.withValues(alpha: isDark ? 0.13 : 0.11),
                    dashCount: 24,
                    strokeW: 0.8,
                    radiusFactor: 0.565,
                    dotRadius: 1.5,
                  ),
                ),
              ),

              // ── Halo glow ──────────────────────────────────────────
              Transform.scale(
                scale: breathScale,
                child: Container(
                  width: diameter * 1.12,
                  height: diameter * 1.12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        violet.withValues(alpha: isDark ? 0.12 : 0.08),
                        Colors.transparent,
                      ],
                      stops: const [0.55, 1.0],
                    ),
                  ),
                ),
              ),

              // ── Core circle ────────────────────────────────────────
              Transform.scale(
                scale: breathScale,
                child: Container(
                  width: diameter,
                  height: diameter,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isDark
                        ? RadialGradient(
                            colors: [
                              const Color(0xFF0F172A),
                              const Color(0xFF0F172A).withValues(alpha: 0.95),
                              const Color(0xFF050510),
                            ],
                            stops: const [0.0, 0.55, 1.0],
                          )
                        : RadialGradient(
                            colors: [
                              const Color(0xFFE0F2FE),
                              const Color(0xFFF0F9FF),
                              const Color(0xFFE0F2FE),
                            ],
                            stops: const [0.0, 0.55, 1.0],
                          ),
                    boxShadow: [
                      BoxShadow(
                        color: violet.withValues(alpha: isDark ? 0.40 : 0.20),
                        blurRadius: 48,
                        spreadRadius: 4,
                      ),
                      BoxShadow(
                        color: cobalt.withValues(alpha: isDark ? 0.15 : 0.12),
                        blurRadius: 20,
                        spreadRadius: -4,
                        offset: const Offset(8, 12),
                      ),
                    ],
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : violet.withValues(alpha: 0.16),
                      width: 1,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/logo.png',
                      width: diameter,
                      height: diameter,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (_, __, ___) => Center(
                        child: _FallbackGlyph(
                          diameter: diameter,
                          isDark: isDark,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Fallback Glyph ───────────────────────────────────────────────────────────

class _FallbackGlyph extends StatelessWidget {
  final double diameter;
  final bool isDark;
  const _FallbackGlyph({required this.diameter, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Sanskrit-inspired "M" letterform
        ShaderMask(
          shaderCallback: (rect) => LinearGradient(
            colors: isDark
                ? [_P.dGem, Colors.white.withValues(alpha: 0.9)]
                : [_P.lViolet, _P.lText],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(rect),
          child: Text(
            'मI',
            style: GoogleFonts.tiroDevanagariSanskrit(
              fontSize: diameter * 0.36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Rune Ring Painter ────────────────────────────────────────────────────────

class _RuneRingPainter extends CustomPainter {
  final int segments;
  final Color color;
  final double strokeW;
  final double gapFraction;
  final double radiusFactor;

  _RuneRingPainter({
    required this.segments,
    required this.color,
    required this.strokeW,
    required this.gapFraction,
    required this.radiusFactor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width * 0.5 * radiusFactor;
    final center = Offset(size.width / 2, size.height / 2);
    final segAngle = (2 * math.pi) / segments;
    final gap = segAngle * gapFraction;
    final arc = segAngle - gap;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeW
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < segments; i++) {
      final startAngle = i * segAngle + gap / 2 - math.pi / 2;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: r),
        startAngle,
        arc,
        false,
        paint,
      );

      // tiny tick marks at arc ends
      final tickPaint = Paint()
        ..color = color.withValues(alpha: 0.5)
        ..strokeWidth = strokeW * 0.8
        ..strokeCap = StrokeCap.round;

      for (final angle in [startAngle, startAngle + arc]) {
        final dx = math.cos(angle);
        final dy = math.sin(angle);
        canvas.drawLine(
          Offset(center.dx + dx * (r - 5), center.dy + dy * (r - 5)),
          Offset(center.dx + dx * (r + 5), center.dy + dy * (r + 5)),
          tickPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─── Dashed Circle Painter ────────────────────────────────────────────────────

class _DashedCirclePainter extends CustomPainter {
  final Color color;
  final int dashCount;
  final double strokeW;
  final double radiusFactor;
  final double dotRadius;

  _DashedCirclePainter({
    required this.color,
    required this.dashCount,
    required this.strokeW,
    required this.radiusFactor,
    required this.dotRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width * 0.5 * radiusFactor;
    final center = Offset(size.width / 2, size.height / 2);
    final step = (2 * math.pi) / dashCount;
    final dotPaint = Paint()..color = color;

    for (var i = 0; i < dashCount; i++) {
      final angle = i * step - math.pi / 2;
      canvas.drawCircle(
        Offset(
          center.dx + r * math.cos(angle),
          center.dy + r * math.sin(angle),
        ),
        dotRadius,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─── Hero Title ───────────────────────────────────────────────────────────────

class _HeroTitle extends StatelessWidget {
  final bool isDark;
  const _HeroTitle({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // "My" in large weight
        ShaderMask(
          shaderCallback: (rect) => LinearGradient(
            colors: isDark
                ? [_P.dGem, Colors.white.withValues(alpha: 0.9)]
                : [_P.lViolet, _P.lText],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(rect),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'My',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 70,
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                    height: 0.95,
                    letterSpacing: -1,
                  ),
                ),
                TextSpan(
                  text: 'Itihas',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 70,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 0.95,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),

        // horizontal rule with gem
        _TitleRule(isDark: isDark),
      ],
    );
  }
}

class _TitleRule extends StatelessWidget {
  final bool isDark;
  const _TitleRule({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final v = isDark ? _P.dViolet : _P.lViolet;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            height: 1,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, v.withValues(alpha: 0.4)],
              ),
            ),
          ),
        ),
        // lotus-like 4-point gem
        SizedBox(
          width: 16,
          height: 16,
          child: CustomPaint(painter: _DiamondPainter(v, v)),
        ),
        Expanded(
          child: Container(
            height: 1,
            margin: const EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [v.withValues(alpha: 0.4), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DiamondPainter extends CustomPainter {
  final Color c1, c2;
  _DiamondPainter(this.c1, this.c2);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final path = Path()
      ..moveTo(cx, 0)
      ..lineTo(size.width, cy)
      ..lineTo(cx, size.height)
      ..lineTo(0, cy)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          colors: [c1, c2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─── Subtitle ─────────────────────────────────────────────────────────────────

class _Subtitle extends StatelessWidget {
  final bool isDark;
  const _Subtitle({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final mid = isDark ? _P.dTextMid : _P.lTextMid;
    final hi = isDark ? _P.dGem : _P.lViolet;

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: GoogleFonts.dmSans(
          fontSize: 15.5,
          height: 1.65,
          color: mid,
          fontWeight: FontWeight.w400,
        ),
        children: [
          const TextSpan(text: "India's first holistic AI platform\nfor "),
          TextSpan(
            text: 'Bharatiya heritage & culture',
            style: GoogleFonts.dmSans(
              fontSize: 15.5,
              fontWeight: FontWeight.w600,
              color: hi,
              height: 1.65,
            ),
          ),
          const TextSpan(text: ' - rediscover with us.'),
        ],
      ),
    );
  }
}

// ─── Premium Button ───────────────────────────────────────────────────────────

class _PremiumButton extends StatefulWidget {
  final bool isDark;
  final VoidCallback onTap;
  const _PremiumButton({required this.isDark, required this.onTap});

  @override
  State<_PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<_PremiumButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTapDown: (_) => setState(() => _down = true),
          onTapUp: (_) {
            setState(() => _down = false);
            widget.onTap();
          },
          onTapCancel: () => setState(() => _down = false),
          child: AnimatedScale(
            scale: _down ? 0.975 : 1.0,
            duration: const Duration(milliseconds: 110),
            curve: Curves.easeOutCubic,
            child: Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [const Color(0xFF1E40AF), const Color(0xFF0088FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(
                      0xFF0088FF,
                    ).withValues(alpha: _down ? 0.20 : 0.35),
                    blurRadius: _down ? 12 : 24,
                    offset: Offset(0, _down ? 4 : 8),
                    spreadRadius: _down ? -2 : 0,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // top sheen
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 30,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withValues(alpha: 0.15),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // content
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Begin Your Journey',
                          style: GoogleFonts.dmSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.15),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.22),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // "No account needed" note
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline_rounded,
              size: 12,
              color: (widget.isDark ? _P.dTextMid : _P.lTextMid).withValues(
                alpha: 0.55,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              'Free to explore · Safe and Secure',
              style: GoogleFonts.dmSans(
                fontSize: 12,
                color: (widget.isDark ? _P.dTextMid : _P.lTextMid).withValues(
                  alpha: 0.55,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
