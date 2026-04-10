import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'color_schemes.dart';
import 'text_theme.dart';
import 'component_themes.dart';
import 'gradient_extension.dart';

class AppTheme {
  /// Light theme
  static ThemeData get lightTheme {
    final colorScheme = AppColorSchemes.lightColorScheme;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: AppTextTheme.textTheme,
      extensions: <ThemeExtension<dynamic>>[GradientExtension.light],

      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: ComponentThemes.appBarTheme(colorScheme),
      cardTheme: ComponentThemes.cardTheme(colorScheme),

      elevatedButtonTheme: ComponentThemes.elevatedButtonTheme(colorScheme),
      filledButtonTheme: ComponentThemes.filledButtonTheme(colorScheme),
      outlinedButtonTheme: ComponentThemes.outlinedButtonTheme(colorScheme),
      textButtonTheme: ComponentThemes.textButtonTheme(colorScheme),

      inputDecorationTheme: ComponentThemes.inputDecorationTheme(colorScheme),

      floatingActionButtonTheme: ComponentThemes.floatingActionButtonTheme(
        colorScheme,
      ),

      navigationBarTheme: ComponentThemes.navigationBarTheme(colorScheme),

      dialogTheme: ComponentThemes.dialogTheme(colorScheme),
      bottomSheetTheme: ComponentThemes.bottomSheetTheme(colorScheme),

      chipTheme: ComponentThemes.chipTheme(colorScheme),

      switchTheme: ComponentThemes.switchTheme(colorScheme),
      checkboxTheme: ComponentThemes.checkboxTheme(colorScheme),
      radioTheme: ComponentThemes.radioTheme(colorScheme),
      sliderTheme: ComponentThemes.sliderTheme(colorScheme),

      snackBarTheme: ComponentThemes.snackBarTheme(colorScheme),
      progressIndicatorTheme: ComponentThemes.progressIndicatorTheme(
        colorScheme,
      ),

      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  /// Dark theme
  static ThemeData get darkTheme {
    final colorScheme = AppColorSchemes.darkColorScheme;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: AppTextTheme.textTheme,
      extensions: <ThemeExtension<dynamic>>[GradientExtension.dark],

      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: ComponentThemes.appBarTheme(colorScheme),
      cardTheme: ComponentThemes.cardTheme(colorScheme),

      elevatedButtonTheme: ComponentThemes.elevatedButtonTheme(colorScheme),
      filledButtonTheme: ComponentThemes.filledButtonTheme(colorScheme),
      outlinedButtonTheme: ComponentThemes.outlinedButtonTheme(colorScheme),
      textButtonTheme: ComponentThemes.textButtonTheme(colorScheme),

      inputDecorationTheme: ComponentThemes.inputDecorationTheme(colorScheme),

      floatingActionButtonTheme: ComponentThemes.floatingActionButtonTheme(
        colorScheme,
      ),

      navigationBarTheme: ComponentThemes.navigationBarTheme(colorScheme),

      dialogTheme: ComponentThemes.dialogTheme(colorScheme),
      bottomSheetTheme: ComponentThemes.bottomSheetTheme(colorScheme),

      chipTheme: ComponentThemes.chipTheme(colorScheme),

      switchTheme: ComponentThemes.switchTheme(colorScheme),
      checkboxTheme: ComponentThemes.checkboxTheme(colorScheme),
      radioTheme: ComponentThemes.radioTheme(colorScheme),
      sliderTheme: ComponentThemes.sliderTheme(colorScheme),
      snackBarTheme: ComponentThemes.snackBarTheme(colorScheme),
      progressIndicatorTheme: ComponentThemes.progressIndicatorTheme(
        colorScheme,
      ),

      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
