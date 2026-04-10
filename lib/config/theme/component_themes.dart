import 'package:flutter/material.dart';

class ComponentThemes {
  static AppBarTheme appBarTheme(ColorScheme colorScheme) => AppBarTheme(
    centerTitle: false,
    elevation: 0,
    scrolledUnderElevation: 4,
    backgroundColor: colorScheme.surface.withValues(alpha: 0.85),
    foregroundColor: colorScheme.onSurface,
    surfaceTintColor: Colors.transparent,
  );

  static CardThemeData cardTheme(ColorScheme colorScheme) => CardThemeData(
    elevation: 2,
    shadowColor: colorScheme.shadow.withValues(alpha: 0.08),
    color: colorScheme.surface.withValues(alpha: 0.7),
    surfaceTintColor: colorScheme.primary.withValues(alpha: 0.08),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(
        color: colorScheme.primary.withValues(alpha: 0.12),
        width: 1,
      ),
    ),
    clipBehavior: Clip.antiAlias,
  );

  static ElevatedButtonThemeData elevatedButtonTheme(ColorScheme colorScheme) =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

  static FilledButtonThemeData filledButtonTheme(ColorScheme colorScheme) =>
      FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

  static OutlinedButtonThemeData outlinedButtonTheme(ColorScheme colorScheme) =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

  static TextButtonThemeData textButtonTheme(ColorScheme colorScheme) =>
      TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

  static InputDecorationTheme inputDecorationTheme(ColorScheme colorScheme) =>
      InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.85),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      );

  static FloatingActionButtonThemeData floatingActionButtonTheme(
    ColorScheme colorScheme,
  ) => FloatingActionButtonThemeData(
    elevation: 3,
    highlightElevation: 8,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );

  static NavigationBarThemeData navigationBarTheme(ColorScheme colorScheme) =>
      NavigationBarThemeData(
        elevation: 3,
        height: 80,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      );

  static DialogThemeData dialogTheme(ColorScheme colorScheme) =>
      DialogThemeData(
        elevation: 0,
        backgroundColor: colorScheme.surface.withValues(alpha: 0.88),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: colorScheme.primary.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
      );

  static BottomSheetThemeData bottomSheetTheme(ColorScheme colorScheme) =>
      BottomSheetThemeData(
        elevation: 0,
        backgroundColor: colorScheme.surface.withValues(alpha: 0.9),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          side: BorderSide(
            color: colorScheme.primary.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
      );

  static ChipThemeData chipTheme(ColorScheme colorScheme) => ChipThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  );

  static SwitchThemeData switchTheme(ColorScheme colorScheme) =>
      const SwitchThemeData();

  static CheckboxThemeData checkboxTheme(ColorScheme colorScheme) =>
      CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      );

  static RadioThemeData radioTheme(ColorScheme colorScheme) =>
      const RadioThemeData();

  static SliderThemeData sliderTheme(ColorScheme colorScheme) =>
      const SliderThemeData();

  static SnackBarThemeData snackBarTheme(ColorScheme colorScheme) =>
      SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      );

  static ProgressIndicatorThemeData progressIndicatorTheme(
    ColorScheme colorScheme,
  ) => ProgressIndicatorThemeData(
    color: colorScheme.onSurface,
    circularTrackColor: colorScheme.onSurface.withValues(alpha: 0.2),
    linearTrackColor: colorScheme.onSurface.withValues(alpha: 0.2),
  );
}
