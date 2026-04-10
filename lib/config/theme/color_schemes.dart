import 'package:flutter/material.dart';

class AppColorSchemes {
  /// Shared accent for heritage/map CTAs (Explore Heritage card, map FAB). Aligns with map2.
  static const Color accentOrange = Color(0xFFFF8C42);

  /// Light color scheme - vibrant purple to cyan gradient
  static ColorScheme get lightColorScheme => const ColorScheme(
    brightness: Brightness.light,

    primary: Color(0xFF0088FF),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFCCE7FF),
    onPrimaryContainer: Color(0xFF002952),
    secondary: Color(0xFF44009F),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFE6CCFF),
    onSecondaryContainer: Color(0xFF22004F),
    tertiary: Color(0xFF6633CC),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFEBD9FF),
    onTertiaryContainer: Color(0xFF331966),
    error: Color(0xFFDC2626),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    surface: Color(0xFFF8FAFC),
    onSurface: Color(0xFF0F172A),
    surfaceContainerHighest: Color(0xFFF1F5F9),
    surfaceContainerHigh: Color(0xFFE2E8F0),
    surfaceContainer: Color(0xFFE2E8F0),
    surfaceContainerLow: Color(0xFFF1F5F9),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    onSurfaceVariant: Color(0xFF475569),
    outline: Color(0xFFCBD5E1),
    outlineVariant: Color(0xFFE2E8F0),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),

    inverseSurface: Color(0xFF1E1B4B),
    onInverseSurface: Color(0xFFF1F5F9),
    inversePrimary: Color(0xFF66B3FF),
    surfaceTint: Color(0xFF0088FF),
  );

  /// Dark color scheme - vibrant purple to cyan gradient on dark
  static ColorScheme get darkColorScheme => const ColorScheme(
    brightness: Brightness.dark,

    primary: Color(0xFF0088FF),
    onPrimary: Color(0xFF001F3D),
    primaryContainer: Color(0xFF003D7A),
    onPrimaryContainer: Color(0xFFCCE7FF),
    secondary: Color(0xFF8855FF),
    onSecondary: Color(0xFF2B0066),
    secondaryContainer: Color(0xFF44009F),
    onSecondaryContainer: Color(0xFFE6CCFF),
    tertiary: Color(0xFF9966FF),
    onTertiary: Color(0xFF331966),
    tertiaryContainer: Color(0xFF552599),
    onTertiaryContainer: Color(0xFFEBD9FF),
    error: Color(0xFFEF4444),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF0A0A0F),
    onSurface: Color(0xFFE2E8F0),
    surfaceContainerHighest: Color(0xFF0D0D12),
    surfaceContainerHigh: Color(0xFF0D0D12),
    surfaceContainer: Color(0xFF0D0D12),
    surfaceContainerLow: Color(0xFF0A0A0F),
    surfaceContainerLowest: Color(0xFF08080C),
    onSurfaceVariant: Color(0xFF94A3B8),
    outline: Color(0xFF334155),
    outlineVariant: Color(0xFF1E293B),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),

    inverseSurface: Color(0xFFE2E8F0),
    onInverseSurface: Color(0xFF1E1B4B),
    inversePrimary: Color(0xFF0066CC),
    surfaceTint: Color(0xFF0088FF),
  );
}
