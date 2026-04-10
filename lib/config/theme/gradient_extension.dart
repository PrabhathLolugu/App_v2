import 'package:flutter/material.dart';

class GradientExtension extends ThemeExtension<GradientExtension> {
  final Gradient primaryButtonGradient;
  final Gradient brandTextGradient;
  final Gradient heroBackgroundGradient;
  final Gradient screenBackgroundGradient;
  final Gradient heritageCardGradient;
  final Color glassBackground;
  final Color glassBorder;
  final Color glassCardBackground;
  final Color glassCardBorder;
  final Color glassBlackSurface;
  final Color electricGlow;

  const GradientExtension({
    required this.primaryButtonGradient,
    required this.brandTextGradient,
    required this.heroBackgroundGradient,
    required this.screenBackgroundGradient,
    required this.heritageCardGradient,
    required this.glassBackground,
    required this.glassBorder,
    required this.glassCardBackground,
    required this.glassCardBorder,
    required this.glassBlackSurface,
    required this.electricGlow,
  });

  /// Light theme - vibrant purple to cyan gradient
  static final GradientExtension light = GradientExtension(
    primaryButtonGradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF44009F), Color(0xFF0088FF)],
    ),
    brandTextGradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF44009F), Color(0xFF0088FF)],
    ),
    heroBackgroundGradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFFFFFFF), Color(0xFFF8F8F8), Color(0xFFEEEEEE)],
      stops: [0.0, 0.5, 1.0],
    ),
    screenBackgroundGradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFFFFFFF),
        Color(0xFFF7F7F7),
        Color(0xFFF0F0F0),
        Color(0xFFE8E8E8),
      ],
      stops: [0.0, 0.35, 0.7, 1.0],
    ),
    heritageCardGradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFFAB40), Color(0xFFFF8C42), Color(0xFFE65100)],
      stops: [0.0, 0.5, 1.0],
    ),
    glassBackground: const Color(0xFFFFFFFF).withValues(alpha: 0.75),
    glassBorder: const Color(0xFF0088FF).withValues(alpha: 0.25),
    glassCardBackground: const Color(0xFFF5F0FF).withValues(alpha: 0.8),
    glassCardBorder: const Color(0xFF44009F).withValues(alpha: 0.2),
    glassBlackSurface: const Color(0xFF0A0A0F),
    electricGlow: const Color(0xFF0088FF).withValues(alpha: 0.2),
  );

  /// Dark theme - vibrant purple to cyan gradient on dark
  static final GradientExtension dark = GradientExtension(
    primaryButtonGradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF8855FF), Color(0xFF0088FF)],
    ),
    brandTextGradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF8855FF), Color(0xFF66B3FF)],
    ),
    heroBackgroundGradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF070707), Color(0xFF0D0D0D), Color(0xFF080808)],
      stops: [0.0, 0.5, 1.0],
    ),
    screenBackgroundGradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF050505),
        Color(0xFF0A0A0A),
        Color(0xFF0F0F0F),
        Color(0xFF080808),
      ],
      stops: [0.0, 0.35, 0.7, 1.0],
    ),
    heritageCardGradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFFAB40), Color(0xFFFF8C42), Color(0xFFE65100)],
      stops: [0.0, 0.5, 1.0],
    ),
    glassBackground: const Color(0xFF0E0E0E).withValues(alpha: 0.85),
    glassBorder: const Color(0xFF0088FF).withValues(alpha: 0.3),
    glassCardBackground: const Color(0xFF15121F).withValues(alpha: 0.7),
    glassCardBorder: const Color(0xFF8855FF).withValues(alpha: 0.15),
    glassBlackSurface: const Color(0xFF080808),
    electricGlow: const Color(0xFF0088FF).withValues(alpha: 0.15),
  );

  @override
  ThemeExtension<GradientExtension> copyWith({
    Gradient? primaryButtonGradient,
    Gradient? brandTextGradient,
    Gradient? heroBackgroundGradient,
    Gradient? screenBackgroundGradient,
    Gradient? heritageCardGradient,
    Color? glassBackground,
    Color? glassBorder,
    Color? glassCardBackground,
    Color? glassCardBorder,
    Color? glassBlackSurface,
    Color? electricGlow,
  }) {
    return GradientExtension(
      primaryButtonGradient:
          primaryButtonGradient ?? this.primaryButtonGradient,
      brandTextGradient: brandTextGradient ?? this.brandTextGradient,
      heroBackgroundGradient:
          heroBackgroundGradient ?? this.heroBackgroundGradient,
      screenBackgroundGradient:
          screenBackgroundGradient ?? this.screenBackgroundGradient,
      heritageCardGradient:
          heritageCardGradient ?? this.heritageCardGradient,
      glassBackground: glassBackground ?? this.glassBackground,
      glassBorder: glassBorder ?? this.glassBorder,
      glassCardBackground: glassCardBackground ?? this.glassCardBackground,
      glassCardBorder: glassCardBorder ?? this.glassCardBorder,
      glassBlackSurface: glassBlackSurface ?? this.glassBlackSurface,
      electricGlow: electricGlow ?? this.electricGlow,
    );
  }

  @override
  ThemeExtension<GradientExtension> lerp(
    covariant ThemeExtension<GradientExtension>? other,
    double t,
  ) {
    if (other is! GradientExtension) return this;

    return GradientExtension(
      primaryButtonGradient: Gradient.lerp(
        primaryButtonGradient,
        other.primaryButtonGradient,
        t,
      )!,
      brandTextGradient: Gradient.lerp(
        brandTextGradient,
        other.brandTextGradient,
        t,
      )!,
      heroBackgroundGradient: Gradient.lerp(
        heroBackgroundGradient,
        other.heroBackgroundGradient,
        t,
      )!,
      screenBackgroundGradient: Gradient.lerp(
        screenBackgroundGradient,
        other.screenBackgroundGradient,
        t,
      )!,
      heritageCardGradient: Gradient.lerp(
        heritageCardGradient,
        other.heritageCardGradient,
        t,
      )!,
      glassBackground: Color.lerp(glassBackground, other.glassBackground, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      glassCardBackground:
          Color.lerp(glassCardBackground, other.glassCardBackground, t)!,
      glassCardBorder: Color.lerp(glassCardBorder, other.glassCardBorder, t)!,
      glassBlackSurface:
          Color.lerp(glassBlackSurface, other.glassBlackSurface, t)!,
      electricGlow: Color.lerp(electricGlow, other.electricGlow, t)!,
    );
  }
}
