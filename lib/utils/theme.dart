import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:myitihas/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Deprecated('Use AppTheme from lib/config/theme/app_theme.dart instead')
class MyItihasTheme {
  MyItihasTheme._();

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: DarkColors.bgColor,
    primaryColor: Color(0xFFE0E0E0),
    colorScheme: ColorScheme.dark(
      primary: Color(0xFFE0E0E0),
      secondary: Color(0xFFBDBDBD),
      background: DarkColors.bgColor,
      error: DarkColors.dangerColor,
    ),
    textTheme: TextTheme(
      displayMedium: TextStyle(color: DarkColors.textPrimary),
      bodyMedium: TextStyle(color: DarkColors.textPrimary),
    ),
    secondaryHeaderColor: DarkColors.textSecondary,
    cardColor: DarkColors.glassBg,
    hoverColor: DarkColors.glowPrimary,
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: LightColors.bgColor,
    primaryColor: Color(0xFF2E2E2E),
    colorScheme: ColorScheme.light(
      primary: Color(0xFF2E2E2E),
      secondary: Color(0xFF4A4A4A),
      background: LightColors.bgColor,
      error: LightColors.dangerColor,
    ),
    textTheme: TextTheme(
      displayMedium: TextStyle(color: LightColors.textPrimary),
      bodyMedium: TextStyle(color: LightColors.textPrimary),
    ),
    secondaryHeaderColor: LightColors.textSecondary,
    cardColor: LightColors.cardBg,
    hoverColor: LightColors.glowPrimary,
  );
}

// Events
abstract class ThemeEvent {}

class ToggleTheme extends ThemeEvent {
  final bool? isDark;
  ToggleTheme([this.isDark]);
}

class SetThemeMode extends ThemeEvent {
  final ThemeMode mode;
  SetThemeMode(this.mode);
}

class InitializeTheme extends ThemeEvent {}

// States
class ThemeState {
  final bool isDark;
  final bool followSystem;

  ThemeState({required this.isDark, required this.followSystem});
}

// BLoC
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _themeModeKey = 'theme_mode';
  final SharedPreferences storage;

  ThemeBloc({required this.storage})
      : super(ThemeState(isDark: false, followSystem: true)) {
    on<SetThemeMode>((event, emit) async {
      if (event.mode == ThemeMode.system) {
        await storage.remove(_themeModeKey);
        emit(ThemeState(isDark: false, followSystem: true));
        return;
      }

      final isDark = event.mode == ThemeMode.dark;
      await storage.setString(
        _themeModeKey,
        isDark ? ThemeMode.dark.name : ThemeMode.light.name,
      );
      emit(ThemeState(isDark: isDark, followSystem: false));
    });

    on<ToggleTheme>((event, emit) async {
      final newIsDark = event.isDark ?? !state.isDark;
      await storage.setString(
        _themeModeKey,
        newIsDark ? ThemeMode.dark.name : ThemeMode.light.name,
      );
      emit(ThemeState(isDark: newIsDark, followSystem: false));
    });

    on<InitializeTheme>((event, emit) async {
      try {
        final savedThemeMode = storage.getString(_themeModeKey);

        if (savedThemeMode == ThemeMode.dark.name) {
          emit(ThemeState(isDark: true, followSystem: false));
          return;
        }

        if (savedThemeMode == ThemeMode.light.name) {
          emit(ThemeState(isDark: false, followSystem: false));
          return;
        }
      } catch (e) {
        await storage.clear();
      }
      emit(ThemeState(isDark: false, followSystem: true));
    });
  }

  void loadSavedTheme() {
    add(InitializeTheme());
  }
}
