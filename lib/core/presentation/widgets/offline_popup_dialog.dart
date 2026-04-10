import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/core/widgets/glass/glass_background.dart';

class OfflinePopupDialog extends StatefulWidget {
  final VoidCallback onRetry;
  final VoidCallback onGoToDownloads;

  const OfflinePopupDialog({
    super.key,
    required this.onRetry,
    required this.onGoToDownloads,
  });

  @override
  State<OfflinePopupDialog> createState() => _OfflinePopupDialogState();
}

class _OfflinePopupDialogState extends State<OfflinePopupDialog>
    with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late AnimationController _entryController;
  late AnimationController _waveController;
  late AnimationController _orbitController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _floatingController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _entryController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 800),
    )..forward();

    _waveController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 2400),
    )..repeat();

    _orbitController = AnimationController(
      vsync: this, duration: const Duration(seconds: 4),
    )..repeat();

    _scaleAnimation = CurvedAnimation(parent: _entryController, curve: Curves.elasticOut);
    _fadeAnimation = CurvedAnimation(parent: _entryController, curve: const Interval(0.0, 0.5, curve: Curves.easeIn));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _pulseController.dispose();
    _entryController.dispose();
    _waveController.dispose();
    _orbitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final gradients = theme.extension<GradientExtension>();
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: GlassBackground(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(36),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(36),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isDark
                                  ? [colorScheme.surface.withOpacity(0.85), colorScheme.surface.withOpacity(0.65)]
                                  : [Colors.white.withOpacity(0.92), Colors.white.withOpacity(0.72)],
                            ),
                            border: Border.all(color: colorScheme.primary.withOpacity(0.15), width: 1.2),
                            boxShadow: [
                              BoxShadow(color: colorScheme.primary.withOpacity(0.08), blurRadius: 60, offset: const Offset(0, 20)),
                              BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 40, offset: const Offset(0, 10)),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(32, 48, 32, 40),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildHeroIllustration(colorScheme),
                                const SizedBox(height: 36),
                                _buildStatusChip(colorScheme, textTheme),
                                const SizedBox(height: 20),
                                Text(
                                  'No Connection',
                                  style: textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -1.0,
                                    height: 1.1,
                                    foreground: Paint()
                                      ..shader = LinearGradient(
                                        colors: [colorScheme.primary, colorScheme.tertiary],
                                      ).createShader(const Rect.fromLTWH(0, 0, 240, 40)),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Your internet connection appears to be\noffline. Check your network and try again.',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurface.withOpacity(0.55),
                                    height: 1.6,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 40),
                                _buildDivider(colorScheme),
                                const SizedBox(height: 32),
                                _buildPrimaryButton(gradients, colorScheme, textTheme),
                                const SizedBox(height: 14),
                                _buildSecondaryButton(colorScheme, textTheme),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroIllustration(ColorScheme colorScheme) {
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ripple
          AnimatedBuilder(
            animation: _waveController,
            builder: (_, __) {
              final t = _waveController.value;
              return Opacity(
                opacity: (1 - t) * 0.3,
                child: Transform.scale(
                  scale: 0.5 + t * 0.8,
                  child: Container(
                    width: 160, height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: colorScheme.primary, width: 1.5),
                    ),
                  ),
                ),
              );
            },
          ),
          // Mid ripple
          AnimatedBuilder(
            animation: _waveController,
            builder: (_, __) {
              final t = (_waveController.value + 0.4) % 1.0;
              return Opacity(
                opacity: (1 - t) * 0.2,
                child: Transform.scale(
                  scale: 0.5 + t * 0.8,
                  child: Container(
                    width: 160, height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: colorScheme.tertiary, width: 1),
                    ),
                  ),
                ),
              );
            },
          ),
          // Pulse glow
          AnimatedBuilder(
            animation: _pulseController,
            builder: (_, __) => Container(
              width: 110 + 10 * _pulseController.value,
              height: 110 + 10 * _pulseController.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  colorScheme.primary.withOpacity(0.18 * _pulseController.value),
                  colorScheme.primary.withOpacity(0),
                ]),
              ),
            ),
          ),
          // Orbiting dots
          AnimatedBuilder(
            animation: _orbitController,
            builder: (_, __) {
              return SizedBox(
                width: 130, height: 130,
                child: Stack(
                  alignment: Alignment.center,
                  children: List.generate(3, (i) {
                    final angle = _orbitController.value * 2 * math.pi + (i * 2 * math.pi / 3);
                    const radius = 58.0;
                    return Transform.translate(
                      offset: Offset(math.cos(angle) * radius, math.sin(angle) * radius),
                      child: Container(
                        width: i == 0 ? 8 : (i == 1 ? 5 : 6),
                        height: i == 0 ? 8 : (i == 1 ? 5 : 6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.primary.withOpacity(i == 0 ? 0.9 : (i == 1 ? 0.5 : 0.7)),
                        ),
                      ),
                    );
                  }),
                ),
              );
            },
          ),
          // Floating icon
          AnimatedBuilder(
            animation: _floatingController,
            builder: (_, child) => Transform.translate(offset: Offset(0, -6 * _floatingController.value), child: child),
            child: Container(
              width: 90, height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [colorScheme.primary.withOpacity(0.15), colorScheme.tertiary.withOpacity(0.1)],
                ),
                border: Border.all(color: colorScheme.primary.withOpacity(0.25), width: 1.5),
                boxShadow: [BoxShadow(color: colorScheme.primary.withOpacity(0.2), blurRadius: 24, spreadRadius: 2)],
              ),
              child: Icon(Iconsax.cloud_cross, size: 44, color: colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(ColorScheme colorScheme, TextTheme textTheme) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (_, __) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.red.withOpacity(0.08),
          border: Border.all(color: Colors.red.withOpacity(0.2 + 0.1 * _pulseController.value)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7, height: 7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.redAccent.withOpacity(0.7 + 0.3 * _pulseController.value),
              ),
            ),
            const SizedBox(width: 8),
            Text('Offline', style: textTheme.labelSmall?.copyWith(color: Colors.redAccent, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(child: Container(height: 1, decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.transparent, colorScheme.outline.withOpacity(0.15)])))),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Icon(Iconsax.wifi, size: 14, color: colorScheme.outline.withOpacity(0.3))),
        Expanded(child: Container(height: 1, decoration: BoxDecoration(gradient: LinearGradient(colors: [colorScheme.outline.withOpacity(0.15), Colors.transparent])))),
      ],
    );
  }

  Widget _buildPrimaryButton(GradientExtension? gradients, ColorScheme colorScheme, TextTheme textTheme) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (_, child) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: gradients?.primaryButtonGradient ?? LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [colorScheme.primary, colorScheme.tertiary]),
          boxShadow: [BoxShadow(color: colorScheme.primary.withOpacity(0.3 + 0.1 * _pulseController.value), blurRadius: 24 + 8 * _pulseController.value, offset: const Offset(0, 8))],
        ),
        child: child,
      ),
      child: ElevatedButton.icon(
        onPressed: widget.onRetry,
        icon: const Icon(Iconsax.refresh, color: Colors.white, size: 20),
        label: Text('Try Again', style: textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(ColorScheme colorScheme, TextTheme textTheme) {
    return TextButton(
      onPressed: widget.onGoToDownloads,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: colorScheme.outline.withOpacity(0.18), width: 1.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.folder_favorite, size: 18, color: colorScheme.primary.withOpacity(0.85)),
          const SizedBox(width: 10),
          Text('Browse Downloads', style: textTheme.titleSmall?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w600, letterSpacing: 0.2)),
          const SizedBox(width: 6),
          Icon(Iconsax.arrow_right_3, size: 15, color: colorScheme.primary.withOpacity(0.6)),
        ],
      ),
    );
  }
}