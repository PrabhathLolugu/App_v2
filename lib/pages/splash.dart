import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/core/presentation/bloc/connectivity_bloc.dart';
import 'package:myitihas/core/presentation/bloc/connectivity_state.dart';
import 'package:myitihas/services/supabase_service.dart';

// ═══════════════════════════════════════════════════════════════════════════
//  SplashScreen — MyItihas  │  "LIVING COSMOS" Edition
//
//  Brand gradient: glass blue / cobalt / indigo
//
//  DARK  theme: midnight blue glass — cobalt nebula — blue glow
//  LIGHT theme: frosted glass blue — cobalt ink — blue shimmer
//
//  Animation Choreography (2 900 ms):
//   0.00–0.22  Background blooms from center — nebula gradient expands
//   0.10–0.45  Sacred Yantra geometry draws itself stroke-by-stroke
//   0.18–0.50  280-particle galaxy-arm cloud settles
//   0.25–0.62  Ouroboros triple ring expands (violet / blue / periwinkle)
//   0.30–0.62  Logo implodes from scattered light → solid form
//   0.40–0.72  14 language orbs spiral in from scatter → stable orbit
//   0.58–0.78  App name — ink-bleed character reveal  [GLASS BLUE]
//   0.72–0.88  Ornamental lotus divider scribes outward
//   0.83–0.97  Tagline words bloom in one-by-one       [GLASS BLUE]
//   0.88–1.00  Final glow and handoff to route
//
//  Continuous: logo heartbeat, orbital drift, nebula shimmer, grain flicker
// ═══════════════════════════════════════════════════════════════════════════

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Controllers ──────────────────────────────────────────────────────────
  late final AnimationController _masterC;
  late final AnimationController _breatheC;
  late final AnimationController _orbitC;
  late final AnimationController _nebulaC;
  late final AnimationController _pulseC;
  late final AnimationController _grainC;
  late final AnimationController _exitC;

  // ── Master timeline ───────────────────────────────────────────────────────
  late final Animation<double> _nebulaBirth;
  late final Animation<double> _yantriDraw;
  late final Animation<double> _particleSettle;
  late final Animation<double> _ringExpand;
  late final Animation<double> _logoAssemble;
  late final Animation<double> _logoFade;
  late final Animation<double> _orbStabilize;
  late final Animation<double> _titleRise;
  late final Animation<double> _dividerScribe;
  late final Animation<double> _taglineBloom;
  late final Animation<double> _finaleGlow;

  // ── Continuous ────────────────────────────────────────────────────────────
  late final Animation<double> _breathe;
  late final Animation<double> _ringPulse;
  late final Animation<double> _exitFade;

  bool _animDone = false;
  bool _navigating = false;

  // ════════════════════════════════════════════════════════════════════════
  //  SPLASH PALETTE  — glass blue on midnight/frosted backdrops
  // ════════════════════════════════════════════════════════════════════════

  // Core glass-blue tones (theme-independent)
  static const Color brandViolet = Color(0xFF1E40AF);
  static const Color brandBlue = Color(0xFF0088FF);
  static const Color brandMid = Color(0xFF38BDF8);
  static const Color brandLavender = Color(0xFF93C5FD);
  static const Color brandSky = Color(0xFF60A5FA);
  static const Color brandPeriwink = Color(0xFFCFE8FF);

  // ── Glass blue palette (title / tagline / loader) ─────────────────────
  static const Color glassBlueLight = Color(0xFFEAF7FF);
  static const Color glassBlue = Color(0xFFD6F0FA);
  static const Color glassBlueMid = Color(0xFF93C5FD);
  static const Color glassBlueDeep = Color(0xFF1D4ED8);
  static const Color glassBlueGlow = Color(0xFFBAE6FD);

  // ── DARK theme ────────────────────────────────────────────────────────────
  static const Color dkBg = Color(0xFF0A0A0F);
  static const Color dkSurface = Color(0xFF101010);
  static const Color dkPrimary = Color(0xFFE5E5E5);
  static const Color dkPrimaryBright = Color(0xFFF2F2F2);
  static const Color dkPrimaryDim = Color(0xFF3C3C3C);
  static const Color dkSecondary = Color(0xFFCDCDCD);
  static const Color dkSecBright = Color(0xFFEAEAEA);
  static const Color dkSecDim = Color(0xFF2E2E2E);
  static const Color dkAccent = Color(0xFFC2C2C2);
  static const Color dkWhite = Color(0xFFF4F4F4);
  static const Color dkMuted = Color(0xFF9C9C9C);

  // ── LIGHT theme ───────────────────────────────────────────────────────────
  static const Color ltBg = Color(0xFFF8FAFC);
  static const Color ltSurface = Color(0xFFF3F3F3);
  static const Color ltPrimary = Color(0xFF2A2A2A);
  static const Color ltPrimaryBright = Color(0xFF555555);
  static const Color ltSecondary = Color(0xFF424242);
  static const Color ltSecBright = Color(0xFF696969);
  static const Color ltAccent = Color(0xFF7A7A7A);
  static const Color ltInk = Color(0xFF141414);
  static const Color ltMuted = Color(0xFF8A8A8A);

  Animation<double> _iv(double s, double e, [Curve c = Curves.easeOut]) =>
      CurvedAnimation(
        parent: _masterC,
        curve: Interval(s, e, curve: c),
      );

  @override
  void initState() {
    super.initState();

    _masterC = AnimationController(
      duration: const Duration(milliseconds: 3200),
      vsync: this,
    );

    _nebulaBirth = _iv(0.00, 0.22, Curves.easeOutCubic);
    _yantriDraw = _iv(0.10, 0.45, Curves.easeInOutCubic);
    _particleSettle = _iv(0.18, 0.50, Curves.easeOutQuart);
    _ringExpand = _iv(0.25, 0.62, Curves.easeOutExpo);
    _logoAssemble = _iv(0.30, 0.62, Curves.easeOutQuart);
    _logoFade = _iv(0.32, 0.58, Curves.easeOut);
    _orbStabilize = _iv(0.40, 0.72, Curves.easeOutCubic);
    _titleRise = _iv(0.58, 0.78, Curves.easeOutExpo);
    _dividerScribe = _iv(0.72, 0.88, Curves.easeOut);
    _taglineBloom = _iv(0.83, 0.97, Curves.easeOut);
    _finaleGlow = _iv(0.88, 1.00, Curves.easeIn);

    _breatheC = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    _breathe = CurvedAnimation(parent: _breatheC, curve: Curves.easeInOut);

    _pulseC = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    )..repeat(reverse: true);
    _ringPulse = CurvedAnimation(parent: _pulseC, curve: Curves.easeInOut);

    _orbitC = AnimationController(
      duration: const Duration(seconds: 14),
      vsync: this,
    )..repeat();

    _nebulaC = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();

    _grainC = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    )..repeat();

    _exitC = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _exitFade = CurvedAnimation(parent: _exitC, curve: Curves.easeInCubic);

    _masterC.forward().then((_) {
      if (mounted) {
        _animDone = true;
        _checkAndNavigate();
      }
    });
  }

  void _checkAndNavigate() {
    if (!mounted || !_animDone || _navigating) return;
    final online = context.read<ConnectivityBloc>().state.maybeWhen(
      online: () => true,
      orElse: () => false,
    );
    if (!online) return;
    _navigating = true;
    _exitC.forward().then((_) {
      if (!mounted) return;
      // Router redirect keeps splash for unauthenticated users only.
      const WelcomeRoute().go(context);
    });
  }

  @override
  void dispose() {
    _masterC.dispose();
    _breatheC.dispose();
    _pulseC.dispose();
    _orbitC.dispose();
    _nebulaC.dispose();
    _grainC.dispose();
    _exitC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final logo = mq.shortestSide * 0.28;
    final bgColor = isDark ? dkBg : ltBg;

    return Scaffold(
      backgroundColor: bgColor,
      body: BlocListener<ConnectivityBloc, ConnectivityState>(
        listenWhen: (p, c) => p.runtimeType != c.runtimeType,
        listener: (_, s) => s.whenOrNull(online: _checkAndNavigate),
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _masterC,
            _breatheC,
            _pulseC,
            _orbitC,
            _nebulaC,
            _grainC,
            _exitC,
          ]),
          builder: (ctx, _) => Stack(
            children: [
              // 0 ── Gradient nebula background ─────────────────────────────
              Positioned.fill(
                child: CustomPaint(
                  painter: _NebulaBgPainter(
                    t: _nebulaBirth.value,
                    grain: _grainC.value,
                    isDark: isDark,
                  ),
                ),
              ),

              // 1 ── Sacred Yantra geometry ──────────────────────────────────
              Positioned.fill(
                child: CustomPaint(
                  painter: _YantraPainter(
                    t: _yantriDraw.value,
                    pulse: _ringPulse.value,
                    isDark: isDark,
                  ),
                ),
              ),

              // 2 ── Particle cloud ──────────────────────────────────────────
              Positioned.fill(
                child: CustomPaint(
                  painter: _NebulaPainter(
                    settle: _particleSettle.value,
                    drift: _nebulaC.value,
                    isDark: isDark,
                  ),
                ),
              ),

              // 3 ── Ouroboros rings ─────────────────────────────────────────
              Positioned.fill(
                child: CustomPaint(
                  painter: _OuroborosPainter(
                    expand: _ringExpand.value,
                    pulse: _ringPulse.value,
                    rotation: _orbitC.value,
                    logoR: logo / 2,
                    isDark: isDark,
                  ),
                ),
              ),

              // 4 ── Language script orbs ────────────────────────────────────
              Positioned.fill(
                child: CustomPaint(
                  painter: _LanguageOrbPainter(
                    stabilize: _orbStabilize.value,
                    rotation: _orbitC.value,
                    pulse: _ringPulse.value,
                    logoR: logo / 2,
                    isDark: isDark,
                  ),
                ),
              ),

              // 5 ── Light scatter imploding into logo ───────────────────────
              Positioned.fill(
                child: CustomPaint(
                  painter: _LightScatterPainter(
                    t: _logoAssemble.value,
                    isDark: isDark,
                  ),
                ),
              ),

              // 6 ── Logo with glow + heartbeat ──────────────────────────────
              Center(
                child: Transform.translate(
                  offset: Offset(0, -6 + _breathe.value * 5.0),
                  child: Opacity(
                    opacity: _logoFade.value.clamp(0.0, 1.0),
                    child: Transform.scale(
                      scale: lerpDouble(0.55, 1.0, _logoAssemble.value)!,
                      child: _PremiumLogo(
                        size: logo,
                        glow: _ringExpand.value,
                        breathe: _breathe.value,
                        isDark: isDark,
                      ),
                    ),
                  ),
                ),
              ),

              // 7 ── Brand text ──────────────────────────────────────────────
              Align(
                alignment: const Alignment(0, 0.62),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _InkBleedTitle(
                      text: 'MyItihas',
                      progress: _titleRise.value,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 18),
                    _OrnamentalDivider(
                      progress: _dividerScribe.value,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 14),
                    _WordBloomTagline(
                      progress: _taglineBloom.value,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              // 8 ── Connectivity hint ───────────────────────────────────────
              _ConnectivityHint(finaleAlpha: _finaleGlow.value, isDark: isDark),

              // 9 ── Exit veil ──────────────────────────────────────────────
              if (_exitFade.value > 0)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      color: bgColor.withOpacity(
                        _exitFade.value.clamp(0.0, 1.0),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  NEBULA BACKGROUND
// ═══════════════════════════════════════════════════════════════════════════
class _NebulaBgPainter extends CustomPainter {
  final double t;
  final double grain;
  final bool isDark;
  const _NebulaBgPainter({
    required this.t,
    required this.grain,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final w = size.width;
    final h = size.height;
    final blue = _SplashScreenState.brandBlue;
    final meshBlue = isDark
      ? _SplashScreenState.brandSky
      : _SplashScreenState.brandViolet;
    final s = math.sin;
    final pi = math.pi;

    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [
                  Color(0xFF0E1628),
                  Color(0xFF13243A),
                  Color(0xFF1A2E46),
                  Color(0xFF0F1D33),
                ]
              : const [
                  Color(0xFFF8FAFC),
                  Color(0xFFF0F7FE),
                  Color(0xFFE5F1FB),
                  Color(0xFFDCEBFA),
                ],
          stops: const [0.0, 0.34, 0.68, 1.0],
        ).createShader(rect),
    );

    _blob(
      canvas,
      size,
      cx: w * (0.82 + 0.07 * s(t * pi)),
      cy: h * (0.08 + 0.04 * s(t * pi * 0.7)),
      r: w * 0.62,
      color: blue.withOpacity(isDark ? 0.18 : 0.09),
    );

    _blob(
      canvas,
      size,
      cx: w * (0.12 + 0.05 * s(t * pi * 1.2)),
      cy: h * (0.80 + 0.06 * s(t * pi * 0.9)),
      r: w * 0.70,
      color: meshBlue.withOpacity(isDark ? 0.14 : 0.06),
    );

    if (isDark) {
      canvas.drawRect(
        rect,
        Paint()..color = _SplashScreenState.brandBlue.withOpacity(0.06),
      );
    }

    if (t > 0.10) {
      canvas.drawRect(
        rect,
        Paint()
          ..shader = RadialGradient(
            center: const Alignment(0.0, -0.16),
            radius: 0.82 * t + 0.08,
            colors: [
              _SplashScreenState.brandBlue.withOpacity((isDark ? 0.18 : 0.10) * t),
              _SplashScreenState.brandSky.withOpacity((isDark ? 0.10 : 0.05) * t),
              Colors.transparent,
            ],
            stops: const [0.0, 0.48, 1.0],
          ).createShader(rect),
      );
    }

    if (t > 0.10) {
      final rng = math.Random((grain * 1000).toInt());
      final grainA = isDark ? 0.020 : 0.012;
      for (int i = 0; i < 550; i++) {
        canvas.drawCircle(
          Offset(rng.nextDouble() * w, rng.nextDouble() * h),
          rng.nextDouble() * 0.75 + 0.2,
          Paint()
            ..color = (isDark ? Colors.white : Colors.black)
                .withOpacity(grainA * rng.nextDouble()),
        );
      }
    }
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
  bool shouldRepaint(_NebulaBgPainter o) => o.t != t || o.grain != grain;
}

// ═══════════════════════════════════════════════════════════════════════════
//  SACRED YANTRA GEOMETRY
// ═══════════════════════════════════════════════════════════════════════════
class _YantraPainter extends CustomPainter {
  final double t;
  final double pulse;
  final bool isDark;
  const _YantraPainter({
    required this.t,
    required this.pulse,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (t <= 0.02) return;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final base = size.shortestSide * 0.42;
    final a = (t * 1.5).clamp(0.0, 1.0);

    final violetStroke =
        (isDark
                ? _SplashScreenState.brandLavender
                : _SplashScreenState.brandViolet)
            .withOpacity(a * 0.25);
    final blueStroke =
        (isDark
                ? _SplashScreenState.dkSecBright
                : _SplashScreenState.ltSecondary)
            .withOpacity(a * 0.20);

    final pV = Paint()
      ..color = violetStroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.75;
    final pB = Paint()
      ..color = blueStroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.55;

    for (int i = 3; i >= 1; i--) {
      final ct = ((t - (3 - i) * 0.08) * 2).clamp(0.0, 1.0);
      if (ct <= 0) continue;
      canvas.drawArc(
        Rect.fromCircle(
          center: Offset(cx, cy),
          radius: base * (0.82 + i * 0.08),
        ),
        -math.pi / 2,
        math.pi * 2 * ct,
        false,
        Paint()
          ..color = (i == 2 ? violetStroke : blueStroke)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.6,
      );
    }

    if (t > 0.15) {
      final triT = ((t - 0.15) / 0.70).clamp(0.0, 1.0);

      void drawTri(double r, double rot, Paint paint) {
        final path = Path();
        for (int v = 0; v <= 3; v++) {
          final ang = rot + (v / 3) * 2 * math.pi - math.pi / 2;
          final x = cx + math.cos(ang) * r;
          final y = cy + math.sin(ang) * r;
          v == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
        }
        for (final pm in path.computeMetrics()) {
          canvas.drawPath(pm.extractPath(0, pm.length * triT), paint);
        }
      }

      drawTri(base * 0.55, 0, pV);
      drawTri(base * 0.55, math.pi, pV);
      drawTri(base * 0.38, math.pi / 6, pB);
      drawTri(base * 0.38, -math.pi / 6, pB);

      if (t > 0.50) {
        final pt = ((t - 0.50) / 0.40).clamp(0.0, 1.0);
        for (int i = 0; i < 8; i++) {
          final ang = (i / 8) * 2 * math.pi + pulse * 0.05;
          canvas.drawCircle(
            Offset(
              cx + math.cos(ang) * base * 0.25,
              cy + math.sin(ang) * base * 0.25,
            ),
            base * 0.018,
            Paint()
              ..color = (i.isEven ? violetStroke : blueStroke).withOpacity(
                0.35 * pt,
              ),
          );
        }
      }

      if (t > 0.70) {
        canvas.drawCircle(
          Offset(cx, cy),
          3.0,
          Paint()
            ..color =
                (isDark
                        ? _SplashScreenState.brandLavender
                        : _SplashScreenState.brandViolet)
                    .withOpacity(0.65 * ((t - 0.70) / 0.30).clamp(0.0, 1.0)),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_YantraPainter o) => o.t != t || o.pulse != pulse;
}

// ═══════════════════════════════════════════════════════════════════════════
//  NEBULA PARTICLE CLOUD
// ═══════════════════════════════════════════════════════════════════════════
class _NebulaPainter extends CustomPainter {
  final double settle;
  final double drift;
  final bool isDark;
  const _NebulaPainter({
    required this.settle,
    required this.drift,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (settle < 0.05) return;
    final rng = math.Random(42);
    final cx = size.width / 2;
    final cy = size.height / 2;
    final maxR = size.shortestSide * 0.52;

    final darkColors = [
      _SplashScreenState.brandViolet,
      _SplashScreenState.brandLavender,
      _SplashScreenState.brandMid,
      _SplashScreenState.brandBlue,
      _SplashScreenState.brandSky,
      _SplashScreenState.brandPeriwink,
      _SplashScreenState.dkAccent,
      _SplashScreenState.dkWhite,
    ];
    final lightColors = [
      _SplashScreenState.brandViolet,
      _SplashScreenState.ltPrimaryBright,
      _SplashScreenState.brandMid,
      _SplashScreenState.brandBlue,
      _SplashScreenState.ltSecBright,
      _SplashScreenState.brandPeriwink,
      _SplashScreenState.ltAccent,
    ];
    final colors = isDark ? darkColors : lightColors;

    for (int i = 0; i < 280; i++) {
      final arm = i % 3;
      final armAngle = (i / 280) * 4 * math.pi + arm * (2 * math.pi / 3);
      final r = (i / 280) * maxR * (0.5 + rng.nextDouble() * 0.5);
      final scatter = rng.nextDouble() * 0.18 * maxR;
      final driftOff = drift * math.pi * 2 * (0.3 + rng.nextDouble() * 0.2);
      final angle = armAngle + driftOff;
      final px = cx + math.cos(angle) * r + (rng.nextDouble() - 0.5) * scatter;
      final py =
          cy + math.sin(angle) * r * 0.7 + (rng.nextDouble() - 0.5) * scatter;
      final distFrac = (r / maxR).clamp(0.0, 1.0);
      final baseA =
          (0.12 + distFrac * 0.22) *
          settle.clamp(0.0, 1.0) *
          (isDark ? 1.0 : 0.55);
      canvas.drawCircle(
        Offset(px, py),
        0.5 + rng.nextDouble() * 1.2 * (1.0 - distFrac * 0.5),
        Paint()
          ..color = colors[rng.nextInt(colors.length)].withOpacity(
            baseA * (0.4 + rng.nextDouble() * 0.6),
          ),
      );
    }
  }

  @override
  bool shouldRepaint(_NebulaPainter o) =>
      o.settle != settle || o.drift != drift;
}

// ═══════════════════════════════════════════════════════════════════════════
//  OUROBOROS TRIPLE RING
// ═══════════════════════════════════════════════════════════════════════════
class _OuroborosPainter extends CustomPainter {
  final double expand;
  final double pulse;
  final double rotation;
  final double logoR;
  final bool isDark;
  const _OuroborosPainter({
    required this.expand,
    required this.pulse,
    required this.rotation,
    required this.logoR,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (expand <= 0.02) return;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final t = expand;
    final ringStrokeScale = size.shortestSide < 380 ? 0.90 : 1.0;

    final colorV = isDark
        ? _SplashScreenState.brandLavender
        : _SplashScreenState.brandViolet;
    final colorB = isDark
        ? _SplashScreenState.dkSecBright
        : _SplashScreenState.brandBlue;
    final colorP = isDark
        ? _SplashScreenState.brandPeriwink
        : _SplashScreenState.ltPrimaryBright;

    final rings = [
      (1.60 + pulse * 0.04, colorV, 1.2, 0.55, 16.0, 1.0),
      (1.38 + pulse * 0.03, colorB, 0.7, 0.45, 8.0, -0.75),
      (1.18 + pulse * 0.02, colorP, 0.5, 0.35, 4.0, 1.4),
    ];

    for (int r = 0; r < rings.length; r++) {
      final (radMul, color, width, alphaFactor, blurR, rotMul) = rings[r];
      final rad = logoR * radMul;
      final rot = rotation * 2 * math.pi * rotMul;
      final rect = Rect.fromCircle(center: Offset(cx, cy), radius: rad);
      final start = rot - math.pi / 2;
      final sweepEnd = math.pi * 2 * t;

      canvas.drawArc(
        rect,
        start,
        sweepEnd,
        false,
        Paint()
          ..color = color.withOpacity(alphaFactor * t * 0.50)
          ..style = PaintingStyle.stroke
          ..strokeWidth = width * 3 * ringStrokeScale
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurR),
      );
      canvas.drawArc(
        rect,
        start,
        sweepEnd,
        false,
        Paint()
          ..shader = SweepGradient(
            colors: [
              Colors.transparent,
              colorV.withOpacity(t * alphaFactor * 0.7),
              colorB.withOpacity(t * alphaFactor),
              color.withOpacity(t * alphaFactor * 0.8),
              Colors.transparent,
            ],
            stops: const [0.0, 0.25, 0.55, 0.80, 1.0],
            transform: GradientRotation(start),
          ).createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeWidth = width * ringStrokeScale
          ..strokeCap = StrokeCap.round,
      );

      if (t > 0.28) {
        final headA = start + sweepEnd;
        final hx = cx + math.cos(headA) * rad;
        final hy = cy + math.sin(headA) * rad;
        canvas.drawCircle(
          Offset(hx, hy),
          width * 2.8,
          Paint()
            ..color = color.withOpacity(t)
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurR * 0.45),
        );
        canvas.drawCircle(
          Offset(hx, hy),
          width * 1.2,
          Paint()..color = Colors.white.withOpacity(t * 0.90),
        );
      }
    }

    canvas.drawCircle(
      Offset(cx, cy),
      logoR * (1.45 + pulse * 0.06),
      Paint()
        ..shader =
            RadialGradient(
              colors: [
                colorV.withOpacity(0.10 * t),
                colorB.withOpacity(0.05 * t),
                Colors.transparent,
              ],
              stops: const [0.0, 0.6, 1.0],
            ).createShader(
              Rect.fromCircle(center: Offset(cx, cy), radius: logoR * 1.5),
            )
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 44),
    );
  }

  @override
  bool shouldRepaint(_OuroborosPainter o) =>
      o.expand != expand || o.pulse != pulse || o.rotation != rotation;
}

// ═══════════════════════════════════════════════════════════════════════════
//  LANGUAGE SCRIPT ORB DATA
// ═══════════════════════════════════════════════════════════════════════════
class _LangOrb {
  final Color core;
  final Color highlight;
  final String glyph;
  const _LangOrb(this.core, this.highlight, this.glyph);
}

class _LanguageOrbPainter extends CustomPainter {
  final double stabilize;
  final double rotation;
  final double pulse;
  final double logoR;
  final bool isDark;

  static const _orbs = [
    _LangOrb(Color(0xFF5500CC), Color(0xFF9966FF), 'A'),
    _LangOrb(Color(0xFF0055EE), Color(0xFF4499FF), 'अ'),
    _LangOrb(Color(0xFF7711BB), Color(0xFFBB77FF), 'அ'),
    _LangOrb(Color(0xFF3300AA), Color(0xFF7755EE), 'అ'),
    _LangOrb(Color(0xFF0077DD), Color(0xFF55BBFF), 'অ'),
    _LangOrb(Color(0xFF6622AA), Color(0xFFAA66EE), 'म'),
    _LangOrb(Color(0xFF0044CC), Color(0xFF4488FF), 'અ'),
    _LangOrb(Color(0xFF4400BB), Color(0xFF8844FF), 'ಅ'),
    _LangOrb(Color(0xFF0066CC), Color(0xFF44AAFF), 'അ'),
    _LangOrb(Color(0xFF5511BB), Color(0xFF9966EE), 'ਅ'),
    _LangOrb(Color(0xFF2233CC), Color(0xFF6677FF), 'ଅ'),
    _LangOrb(Color(0xFF330088), Color(0xFF7744CC), 'ا'),
    _LangOrb(Color(0xFF8800BB), Color(0xFFCC55EE), 'ॐ'),
    _LangOrb(Color(0xFF0099EE), Color(0xFF44CCFF), 'আ'),
  ];

  const _LanguageOrbPainter({
    required this.stabilize,
    required this.rotation,
    required this.pulse,
    required this.logoR,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (stabilize <= 0.02) return;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final n = _orbs.length;
    final t = stabilize.clamp(0.0, 1.0);
    // Keep language orbs exactly on the same circular ring as the outer orbit.
    final orbitR = logoR * (1.60 + pulse * 0.04);
    final isCompact = size.shortestSide < 380;

    for (int i = 0; i < n; i++) {
      final orb = _orbs[i];
      final baseAngle = rotation * 2 * math.pi + (i / n) * 2 * math.pi;
      final spiralIn = 1.0 - t;
      final rng = math.Random(i * 13 + 7);
      final scatter = spiralIn * logoR * 2.5;

      final px =
          cx +
          math.cos(baseAngle) * orbitR +
          (rng.nextDouble() - 0.5) * scatter * 2;
      final py =
          cy +
          math.sin(baseAngle) * orbitR +
          (rng.nextDouble() - 0.5) * scatter * 2;
      final orbR = logoR * (isCompact ? 0.20 : 0.22);

      canvas.drawCircle(
        Offset(px, py),
        orbR * 2.8,
        Paint()
          ..color = orb.core.withOpacity((isDark ? 0.40 : 0.22) * t)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18),
      );

      canvas.drawCircle(
        Offset(px, py),
        orbR,
        Paint()
          ..shader = RadialGradient(
            center: const Alignment(-0.35, -0.45),
            radius: 1.0,
            colors: [
              Colors.white.withOpacity((isDark ? 0.40 : 0.55) * t),
              orb.highlight.withOpacity(0.90 * t),
              orb.core.withOpacity(1.0 * t),
              orb.core.withOpacity(0.65 * t),
            ],
            stops: const [0.0, 0.30, 0.65, 1.0],
          ).createShader(Rect.fromCircle(center: Offset(px, py), radius: orbR)),
      );

      canvas.drawCircle(
        Offset(px, py),
        orbR,
        Paint()
          ..color = Colors.white.withOpacity(0.15 * t)
          ..style = PaintingStyle.stroke
          ..strokeWidth = isCompact ? 0.65 : 0.75,
      );

      canvas.drawCircle(
        Offset(px - orbR * 0.28, py - orbR * 0.30),
        orbR * 0.25,
        Paint()
          ..color = Colors.white.withOpacity(0.50 * t)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );

      if (t > 0.28) {
        final tp = TextPainter(
          text: TextSpan(
            text: orb.glyph,
            style: TextStyle(
              color: Colors.white.withOpacity((t * 1.1).clamp(0.0, 1.0)),
              fontSize: orbR * 1.05,
              fontWeight: FontWeight.w700,
              fontFamilyFallback: const [
                'Noto Sans',
                'Noto Sans Devanagari',
                'Noto Sans Tamil',
                'Noto Sans Telugu',
                'Noto Sans Bengali',
                'Noto Sans Gurmukhi',
                'Noto Sans Gujarati',
                'Noto Sans Kannada',
                'Noto Sans Malayalam',
                'Noto Sans Oriya',
                'Noto Sans Arabic',
              ],
              shadows: const [Shadow(color: Color(0x99000000), blurRadius: 4)],
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(px, py) - Offset(tp.width / 2, tp.height / 2));
      }
    }

    if (stabilize > 0.50) {
      final innerT = ((stabilize - 0.50) / 0.50).clamp(0.0, 1.0);
      final innerR = logoR * (1.55 + pulse * 0.03);
      final innerA = -rotation * 1.6 * 2 * math.pi;
      for (int i = 0; i < n; i++) {
        final ang = innerA + (i / n) * 2 * math.pi;
        canvas.drawCircle(
          Offset(cx + math.cos(ang) * innerR, cy + math.sin(ang) * innerR),
          2.2,
          Paint()..color = _orbs[i].highlight.withOpacity(0.65 * innerT),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_LanguageOrbPainter o) =>
      o.stabilize != stabilize || o.rotation != rotation || o.pulse != pulse;
}

// ═══════════════════════════════════════════════════════════════════════════
//  LIGHT SCATTER
// ═══════════════════════════════════════════════════════════════════════════
class _LightScatterPainter extends CustomPainter {
  final double t;
  final bool isDark;
  const _LightScatterPainter({required this.t, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    if (t >= 0.95 || t <= 0.01) return;
    final opacity = (t < 0.5 ? t * 1.8 : (1.0 - t) * 2.5).clamp(0.0, 1.0);
    if (opacity <= 0) return;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final rng = math.Random(99);
    final maxR = size.shortestSide * 0.55;

    final colors = isDark
        ? [
            _SplashScreenState.brandLavender,
            _SplashScreenState.brandBlue,
            _SplashScreenState.brandSky,
            _SplashScreenState.dkAccent,
          ]
        : [
            _SplashScreenState.brandViolet,
            _SplashScreenState.brandBlue,
            _SplashScreenState.brandMid,
            _SplashScreenState.ltAccent,
          ];

    for (int i = 0; i < 80; i++) {
      final angle = rng.nextDouble() * 2 * math.pi;
      final curR = lerpDouble(
        maxR * (0.8 + rng.nextDouble() * 0.5),
        maxR * 0.05,
        t,
      )!;
      final sz = lerpDouble(2.5, 0.5, t)!;
      canvas.drawCircle(
        Offset(cx + math.cos(angle) * curR, cy + math.sin(angle) * curR),
        sz,
        Paint()
          ..color = colors[i % colors.length].withOpacity(
            opacity * (0.5 + rng.nextDouble() * 0.5),
          )
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, sz * 2),
      );
    }
  }

  @override
  bool shouldRepaint(_LightScatterPainter o) => o.t != t;
}

// ═══════════════════════════════════════════════════════════════════════════
//  PREMIUM LOGO
// ═══════════════════════════════════════════════════════════════════════════
class _PremiumLogo extends StatelessWidget {
  final double size;
  final double glow;
  final double breathe;
  final bool isDark;
  const _PremiumLogo({
    required this.size,
    required this.glow,
    required this.breathe,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final primaryGlow = isDark
        ? _SplashScreenState.brandLavender
        : _SplashScreenState.brandViolet;
    final secondaryGlow = isDark
        ? _SplashScreenState.brandBlue
        : _SplashScreenState.ltSecBright;

    return SizedBox(
      width: size * 1.8,
      height: size * 1.8,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size * 1.8,
            height: size * 1.8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  primaryGlow.withOpacity(0.14 * glow),
                  secondaryGlow.withOpacity(0.06 * glow),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.55, 1.0],
              ),
            ),
          ),
          Container(
            width: size * (1.05 + breathe * 0.06),
            height: size * (1.05 + breathe * 0.06),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  primaryGlow.withOpacity(
                    0.26 * glow * (0.65 + breathe * 0.35),
                  ),
                  secondaryGlow.withOpacity(0.10 * glow),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.60, 1.0],
              ),
            ),
          ),
          ClipOval(
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryGlow.withOpacity(0.40 * glow),
                    blurRadius: 28,
                    spreadRadius: 3,
                  ),
                  BoxShadow(
                    color: secondaryGlow.withOpacity(0.20 * glow),
                    blurRadius: 48,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: Image.asset(
                'assets/logo.png',
                width: size,
                height: size,
                filterQuality: FilterQuality.high,
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (glow > 0.30)
            CustomPaint(
              size: Size(size * 1.13, size * 1.13),
              painter: _BrandRingPainter(
                alpha: ((glow - 0.30) / 0.70).clamp(0.0, 1.0),
                isDark: isDark,
              ),
            ),
        ],
      ),
    );
  }
}

class _BrandRingPainter extends CustomPainter {
  final double alpha;
  final bool isDark;
  const _BrandRingPainter({required this.alpha, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = cx - 0.5;
    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r);
    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()
        ..shader = SweepGradient(
          colors: [
            _SplashScreenState.brandViolet.withOpacity(0.65 * alpha),
            _SplashScreenState.brandBlue.withOpacity(0.85 * alpha),
            _SplashScreenState.brandLavender.withOpacity(0.50 * alpha),
            _SplashScreenState.brandViolet.withOpacity(0.65 * alpha),
          ],
          stops: const [0.0, 0.40, 0.75, 1.0],
        ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  @override
  bool shouldRepaint(_BrandRingPainter o) => o.alpha != alpha;
}

// ═══════════════════════════════════════════════════════════════════════════
//  INK-BLEED TITLE  ── GLASS BLUE
// ═══════════════════════════════════════════════════════════════════════════
class _InkBleedTitle extends StatelessWidget {
  final String text;
  final double progress;
  final bool isDark;
  const _InkBleedTitle({
    required this.text,
    required this.progress,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final chars = text.split('');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: chars.asMap().entries.map((e) {
        final i = e.key;
        final ch = e.value;
        final delay = i / (chars.length - 1) * 0.55;
        final charP = ((progress - delay) / 0.55).clamp(0.0, 1.0);
        return Opacity(
          opacity: charP,
          child: Transform.scale(
            scale: lerpDouble(1.38, 1.0, charP)!,
            child: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (b) =>
                  (isDark
                          // Dark: icy glass blue highlight → core glass blue → deeper
                          ? const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFFD6F0F8), // icy white-blue highlight
                                Color(0xFF7EC8E3), // glass blue core
                                Color(0xFF4AACCF), // deeper glass blue
                              ],
                              stops: [0.0, 0.45, 1.0],
                            )
                          // Light: deep glass blue ink → mid → bright
                          : const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF1A6A85), // deep glass blue ink
                                Color(0xFF2A8FAF), // mid glass blue
                                Color(0xFF4AACCF), // bright glass blue
                              ],
                              stops: [0.0, 0.48, 1.0],
                            ))
                      .createShader(Rect.fromLTWH(0, 0, b.width, b.height)),
              child: Text(
                ch,
                style: const TextStyle(
                  fontSize: 46,
                  fontWeight: FontWeight.w200,
                  letterSpacing: 10.0,
                  height: 1.0,
                  fontFamilyFallback: ['Georgia', 'Palatino', 'serif'],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  ORNAMENTAL LOTUS DIVIDER
// ═══════════════════════════════════════════════════════════════════════════
class _OrnamentalDivider extends StatelessWidget {
  final double progress;
  final bool isDark;
  const _OrnamentalDivider({required this.progress, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(260, 20),
      painter: _OrnamentalPainter(p: progress, isDark: isDark),
    );
  }
}

class _OrnamentalPainter extends CustomPainter {
  final double p;
  final bool isDark;
  const _OrnamentalPainter({required this.p, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    if (p <= 0) return;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final violet = isDark
        ? _SplashScreenState.brandLavender
        : _SplashScreenState.brandViolet;
    final blue = isDark
        ? _SplashScreenState.dkSecBright
        : _SplashScreenState.brandBlue;
    final len = cx * 0.80 * p;

    if (len > 2) {
      canvas.drawLine(
        Offset(cx - len, cy),
        Offset(cx - 14, cy),
        Paint()
          ..shader = LinearGradient(
            colors: [violet.withOpacity(0.0), violet.withOpacity(0.70)],
          ).createShader(Rect.fromLTWH(cx - len, cy - 1, len, 2))
          ..strokeWidth = 0.8,
      );
      canvas.drawLine(
        Offset(cx + 14, cy),
        Offset(cx + len, cy),
        Paint()
          ..shader = LinearGradient(
            colors: [blue.withOpacity(0.70), blue.withOpacity(0.0)],
          ).createShader(Rect.fromLTWH(cx + 14, cy - 1, len, 2))
          ..strokeWidth = 0.8,
      );
    }

    if (p > 0.45) {
      final lt = ((p - 0.45) / 0.55).clamp(0.0, 1.0);
      for (int i = 0; i < 6; i++) {
        final ang = (i / 6) * 2 * math.pi;
        final pr = 6.0 * lt;
        final frac = i / 6;
        final petal = Color.lerp(violet, blue, frac)!;
        canvas.drawCircle(
          Offset(cx + math.cos(ang) * pr, cy + math.sin(ang) * pr * 0.65),
          2.8 * lt,
          Paint()
            ..color = petal.withOpacity(0.75 * lt)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
        );
      }
      canvas.drawCircle(
        Offset(cx, cy),
        2.4 * lt,
        Paint()..color = violet.withOpacity(0.90 * lt),
      );
      if (p > 0.70) {
        final dt = ((p - 0.70) / 0.30).clamp(0.0, 1.0);
        for (final xOff in [-26.0, 26.0]) {
          canvas.save();
          canvas.translate(cx + xOff, cy);
          canvas.rotate(math.pi / 4);
          canvas.drawRect(
            Rect.fromCenter(center: Offset.zero, width: 4 * dt, height: 4 * dt),
            Paint()..color = blue.withOpacity(0.65 * dt),
          );
          canvas.restore();
        }
      }
    }
  }

  @override
  bool shouldRepaint(_OrnamentalPainter o) => o.p != p;
}

// ═══════════════════════════════════════════════════════════════════════════
//  WORD-BLOOM TAGLINE  ── GLASS BLUE
// ═══════════════════════════════════════════════════════════════════════════
class _WordBloomTagline extends StatelessWidget {
  final double progress;
  final bool isDark;
  const _WordBloomTagline({required this.progress, required this.isDark});

  @override
  Widget build(BuildContext context) {
    const words = ['YOUR', 'CULTURE', '·', 'YOUR', 'WAY'];

    // Glass blue replaces previous violet/muted text and brandSky/brandBlue accent
    final textColor = isDark
        ? _SplashScreenState
              .glassBlue // core glass blue on dark
        : _SplashScreenState.glassBlueDeep; // deep glass blue on light
    final accentColor = isDark
        ? _SplashScreenState
              .glassBlueLight // icy highlight for centre dot
        : _SplashScreenState.glassBlueMid; // mid glass blue accent on light

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: words.asMap().entries.map((e) {
        final i = e.key;
        final word = e.value;
        final wordP = ((progress - i / words.length * 0.60) / 0.50).clamp(
          0.0,
          1.0,
        );
        return Opacity(
          opacity: wordP,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.5),
            child: Transform.translate(
              offset: Offset(0, 6 * (1 - wordP)),
              child: Text(
                word,
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 3.5,
                  color: (word == '·' ? accentColor : textColor).withOpacity(
                    wordP,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ═══════════════════════════════════════════════════════════════════════════
//  CONNECTIVITY HINT
// ═══════════════════════════════════════════════════════════════════════════
class _ConnectivityHint extends StatelessWidget {
  final double finaleAlpha;
  final bool isDark;
  const _ConnectivityHint({required this.finaleAlpha, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      builder: (ctx, state) {
        final offline = state.maybeWhen(
          offline: () => true,
          orElse: () => false,
        );
        if (!offline) return const SizedBox.shrink();

        final color =
            (isDark ? _SplashScreenState.dkMuted : _SplashScreenState.ltMuted)
                .withOpacity(finaleAlpha * 0.85);

        return Align(
          alignment: const Alignment(0, 0.97),
          child: Opacity(
            opacity: finaleAlpha.clamp(0.0, 1.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.wifi_off_rounded, size: 11, color: color),
                const SizedBox(width: 5),
                Text(
                  'Waiting for connection…',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1.8,
                    color: color,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
