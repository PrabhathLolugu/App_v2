# Theming Guide: Material Design 3 in Flutter

## Overview

This guide covers comprehensive theming strategies for Flutter applications using Material Design 3 (Material You). Material 3 is Flutter's default theme as of Flutter 3.16 and provides a modern, adaptive, and accessible design system.

For architecture context, see the [Architecture Guide](architecture.md). For package details, see the [Package Guide](packages.md).

## Material Design 3 Core Concepts

### What's New in Material 3

- **Dynamic Color**: Adaptive color schemes based on user preferences and wallpapers
- **Updated Components**: Refreshed visual design for all Material widgets
- **Enhanced Accessibility**: Improved contrast ratios and touch targets
- **Expressive Typography**: New type scale with better hierarchy
- **Surface Tones**: Subtle elevation through color instead of shadows

### Key Principles

1. **Personalization**: Themes that adapt to user preferences
2. **Accessibility**: Built-in support for high contrast and large text
3. **Consistency**: Unified design language across platforms
4. **Flexibility**: Easy customization while maintaining coherence

## Theme Structure

### Theme Hierarchy

```
MaterialApp
  └── theme: ThemeData
       ├── colorScheme: ColorScheme
       ├── textTheme: TextTheme
       ├── useMaterial3: true
       └── Component Themes
            ├── appBarTheme
            ├── buttonTheme
            ├── cardTheme
            └── ... (30+ component themes)
```

### Theme Data Properties

The `ThemeData` class contains over 30 properties for customizing your app's appearance:

- **colorScheme**: Primary color configuration
- **textTheme**: Typography styles
- **iconTheme**: Icon styling
- **Component-specific themes**: Individual widget customization

## Color Schemes

### Creating Color Schemes

#### From Seed Color (Recommended)

Material 3's most powerful feature is generating entire color schemes from a single seed color:

```dart
import 'package:flutter/material.dart';

ThemeData createTheme(Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4), // Primary brand color
      brightness: brightness,
    ),
  );
}
```

This automatically generates:

- Primary, Secondary, and Tertiary color palettes
- Surface and background colors
- Error colors
- All color variants with proper contrast ratios

#### Custom Color Schemes

For full control, define colors explicitly:

```dart
ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    
    // Primary colors
    primary: Color(0xFF6750A4),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFEADDFF),
    onPrimaryContainer: Color(0xFF21005D),
    
    // Secondary colors
    secondary: Color(0xFF625B71),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFE8DEF8),
    onSecondaryContainer: Color(0xFF1D192B),
    
    // Tertiary colors
    tertiary: Color(0xFF7D5260),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFFD8E4),
    onTertiaryContainer: Color(0xFF31111D),
    
    // Error colors
    error: Color(0xFFB3261E),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFF9DEDC),
    onErrorContainer: Color(0xFF410E0B),
    
    // Surface colors
    surface: Color(0xFFFEF7FF),
    onSurface: Color(0xFF1D1B20),
    surfaceContainerHighest: Color(0xFFE7E0EC),
    
    // Other colors
    outline: Color(0xFF79747E),
    shadow: Color(0xFF000000),
    inverseSurface: Color(0xFF322F35),
    onInverseSurface: Color(0xFFF5EFF7),
    inversePrimary: Color(0xFFD0BCFF),
  ),
);
```

### Color Scheme Roles

Material 3 defines specific roles for colors:

| Role | Usage |
|------|-------|
| **primary** | High-emphasis elements (FABs, prominent buttons) |
| **onPrimary** | Text/icons on primary color |
| **primaryContainer** | Less prominent primary elements |
| **onPrimaryContainer** | Text/icons on primary container |
| **secondary** | Medium-emphasis elements |
| **tertiary** | Contrasting accents |
| **error** | Error states |
| **surface** | Background surfaces (cards, sheets) |
| **outline** | Borders and dividers |
| **inverseSurface** | Surfaces with inverted colors (snackbars) |

### Dynamic Color (Platform-Adaptive)

Enable dynamic color to use system wallpaper colors on Android 12+:

```dart
import 'package:dynamic_color/dynamic_color.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;
        
        if (lightDynamic != null && darkDynamic != null) {
          // Use dynamic colors
          lightColorScheme = lightDynamic.harmonized();
          darkColorScheme = darkDynamic.harmonized();
        } else {
          // Fallback to custom colors
          lightColorScheme = ColorScheme.fromSeed(
            seedColor: const Color(0xFF6750A4),
          );
          darkColorScheme = ColorScheme.fromSeed(
            seedColor: const Color(0xFF6750A4),
            brightness: Brightness.dark,
          );
        }
        
        return MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightColorScheme,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkColorScheme,
          ),
          themeMode: ThemeMode.system,
          home: const HomePage(),
        );
      },
    );
  }
}
```

## Typography & Text Themes

### Material 3 Type Scale

Material 3 provides 15 text styles organized by role:

| Style | Usage | Default Size |
|-------|-------|--------------|
| **displayLarge** | Hero text, largest display | 57sp |
| **displayMedium** | Large display text | 45sp |
| **displaySmall** | Smallest display text | 36sp |
| **headlineLarge** | High-emphasis, short text | 32sp |
| **headlineMedium** | Headlines | 28sp |
| **headlineSmall** | Smaller headlines | 24sp |
| **titleLarge** | Primary titles | 22sp |
| **titleMedium** | Secondary titles | 16sp |
| **titleSmall** | Smaller titles | 14sp |
| **bodyLarge** | Long-form writing | 16sp |
| **bodyMedium** | Default body text | 14sp |
| **bodySmall** | Supplemental text | 12sp |
| **labelLarge** | Buttons, prominent labels | 14sp |
| **labelMedium** | Labels | 12sp |
| **labelSmall** | Small labels | 11sp |

### Configuring Text Theme

```dart
import 'package:google_fonts/google_fonts.dart';

ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
  
  textTheme: TextTheme(
    // Display styles (hero text)
    displayLarge: GoogleFonts.roboto(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
    ),
    displayMedium: GoogleFonts.roboto(
      fontSize: 45,
      fontWeight: FontWeight.w400,
    ),
    displaySmall: GoogleFonts.roboto(
      fontSize: 36,
      fontWeight: FontWeight.w400,
    ),
    
    // Headline styles (high emphasis)
    headlineLarge: GoogleFonts.roboto(
      fontSize: 32,
      fontWeight: FontWeight.w400,
    ),
    headlineMedium: GoogleFonts.roboto(
      fontSize: 28,
      fontWeight: FontWeight.w400,
    ),
    headlineSmall: GoogleFonts.roboto(
      fontSize: 24,
      fontWeight: FontWeight.w400,
    ),
    
    // Title styles (medium emphasis)
    titleLarge: GoogleFonts.roboto(
      fontSize: 22,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
    ),
    titleSmall: GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    
    // Body styles (plain text)
    bodyLarge: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
    ),
    bodyMedium: GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
    bodySmall: GoogleFonts.roboto(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
    ),
    
    // Label styles (buttons, tabs)
    labelLarge: GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    labelMedium: GoogleFonts.roboto(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
    labelSmall: GoogleFonts.roboto(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
  ),
);
```

### Using Google Fonts

The `google_fonts` package provides easy access to 1000+ fonts:

```dart
dependencies:
  google_fonts: ^6.2.1
```

#### Apply to Entire Theme

```dart
import 'package:google_fonts/google_fonts.dart';

ThemeData(
  useMaterial3: true,
  textTheme: GoogleFonts.robotoTextTheme(
    Theme.of(context).textTheme,
  ),
);
```

#### Mix Different Fonts

```dart
textTheme: TextTheme(
  displayLarge: GoogleFonts.playfairDisplay(
    fontSize: 57,
    fontWeight: FontWeight.bold,
  ),
  headlineMedium: GoogleFonts.oswald(
    fontSize: 28,
  ),
  bodyMedium: GoogleFonts.merriweather(
    fontSize: 14,
  ),
  labelLarge: GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  ),
);
```

#### Using Individual Fonts

```dart
Text(
  'Display Text',
  style: GoogleFonts.playfairDisplay(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).colorScheme.primary,
  ),
);
```

### Variable Fonts

Variable fonts allow dynamic adjustment of font properties:

```dart
import 'package:flutter/widgets.dart';

Text(
  'Variable Font',
  style: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 32,
    fontVariations: const [
      FontVariation('wght', 700), // Weight
      FontVariation('wdth', 100), // Width
      FontVariation('slnt', -10), // Slant
    ],
  ),
);
```

## Component Themes

### AppBar Theme

```dart
appBarTheme: const AppBarTheme(
  centerTitle: true,
  elevation: 0,
  scrolledUnderElevation: 3,
  backgroundColor: Colors.transparent,
  foregroundColor: null, // Uses colorScheme.onSurface
  titleTextStyle: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
  ),
);
```

### Button Themes

```dart
// Elevated Button
elevatedButtonTheme: ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    elevation: 1,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),
),

// Filled Button (Material 3)
filledButtonTheme: FilledButtonThemeData(
  style: FilledButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),
),

// Text Button
textButtonTheme: TextButtonThemeData(
  style: TextButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  ),
),

// Outlined Button
outlinedButtonTheme: OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    side: BorderSide(
      width: 1,
      color: Theme.of(context).colorScheme.outline,
    ),
  ),
),
```

### Card Theme

```dart
cardTheme: CardTheme(
  elevation: 1,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  clipBehavior: Clip.antiAlias,
  margin: const EdgeInsets.all(8),
);
```

### Input Decoration Theme

```dart
inputDecorationTheme: InputDecorationTheme(
  filled: true,
  fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide.none,
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(
      color: Theme.of(context).colorScheme.outline,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(
      color: Theme.of(context).colorScheme.primary,
      width: 2,
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(
      color: Theme.of(context).colorScheme.error,
    ),
  ),
  contentPadding: const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 16,
  ),
);
```

### Floating Action Button Theme

```dart
floatingActionButtonTheme: const FloatingActionButtonThemeData(
  elevation: 3,
  focusElevation: 4,
  hoverElevation: 4,
  highlightElevation: 6,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(16)),
  ),
);
```

### Navigation Bar Theme

```dart
navigationBarTheme: NavigationBarThemeData(
  height: 80,
  elevation: 3,
  indicatorColor: Theme.of(context).colorScheme.secondaryContainer,
  labelTextStyle: WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.selected)) {
      return const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      );
    }
    return const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
    );
  }),
);
```

### Bottom Sheet Theme

```dart
bottomSheetTheme: const BottomSheetThemeData(
  elevation: 3,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(28),
    ),
  ),
  clipBehavior: Clip.antiAlias,
);
```

### Dialog Theme

```dart
dialogTheme: DialogTheme(
  elevation: 3,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(28),
  ),
  titleTextStyle: GoogleFonts.roboto(
    fontSize: 24,
    fontWeight: FontWeight.w400,
  ),
);
```

### Chip Theme

```dart
chipTheme: ChipThemeData(
  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
  deleteIconColor: Theme.of(context).colorScheme.onSurfaceVariant,
  selectedColor: Theme.of(context).colorScheme.secondaryContainer,
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
);
```

## Complete Theme Configuration

### Project Structure

```
lib/
├── config/
│   ├── theme/
│   │   ├── app_theme.dart           # Main theme configuration
│   │   ├── color_schemes.dart       # Color scheme definitions
│   │   ├── text_theme.dart          # Typography configuration
│   │   └── component_themes.dart    # Individual component themes
│   └── routes.dart
└── main.dart
```

### Color Schemes Configuration

```dart
// lib/config/theme/color_schemes.dart
import 'package:flutter/material.dart';

class AppColorSchemes {
  // Light theme colors
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF6750A4),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFEADDFF),
    onPrimaryContainer: Color(0xFF21005D),
    secondary: Color(0xFF625B71),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFE8DEF8),
    onSecondaryContainer: Color(0xFF1D192B),
    tertiary: Color(0xFF7D5260),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFFD8E4),
    onTertiaryContainer: Color(0xFF31111D),
    error: Color(0xFFB3261E),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFF9DEDC),
    onErrorContainer: Color(0xFF410E0B),
    surface: Color(0xFFFEF7FF),
    onSurface: Color(0xFF1D1B20),
    surfaceContainerHighest: Color(0xFFE7E0EC),
    outline: Color(0xFF79747E),
    shadow: Color(0xFF000000),
    inverseSurface: Color(0xFF322F35),
    onInverseSurface: Color(0xFFF5EFF7),
    inversePrimary: Color(0xFFD0BCFF),
  );
  
  // Dark theme colors
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFD0BCFF),
    onPrimary: Color(0xFF381E72),
    primaryContainer: Color(0xFF4F378B),
    onPrimaryContainer: Color(0xFFEADDFF),
    secondary: Color(0xFFCCC2DC),
    onSecondary: Color(0xFF332D41),
    secondaryContainer: Color(0xFF4A4458),
    onSecondaryContainer: Color(0xFFE8DEF8),
    tertiary: Color(0xFFEFB8C8),
    onTertiary: Color(0xFF492532),
    tertiaryContainer: Color(0xFF633B48),
    onTertiaryContainer: Color(0xFFFFD8E4),
    error: Color(0xFFF2B8B5),
    onError: Color(0xFF601410),
    errorContainer: Color(0xFF8C1D18),
    onErrorContainer: Color(0xFFF9DEDC),
    surface: Color(0xFF141218),
    onSurface: Color(0xFFE6E0E9),
    surfaceContainerHighest: Color(0xFF36343B),
    outline: Color(0xFF938F99),
    shadow: Color(0xFF000000),
    inverseSurface: Color(0xFFE6E0E9),
    onInverseSurface: Color(0xFF322F35),
    inversePrimary: Color(0xFF6750A4),
  );
  
  // Alternative: Generate from seed color
  static ColorScheme lightFromSeed({Color seedColor = const Color(0xFF6750A4)}) {
    return ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    );
  }
  
  static ColorScheme darkFromSeed({Color seedColor = const Color(0xFF6750A4)}) {
    return ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );
  }
}
```

### Text Theme Configuration

```dart
// lib/config/theme/text_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextTheme {
  static TextTheme get textTheme {
    return TextTheme(
      displayLarge: GoogleFonts.roboto(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: GoogleFonts.roboto(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        height: 1.16,
      ),
      displaySmall: GoogleFonts.roboto(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        height: 1.22,
      ),
      headlineLarge: GoogleFonts.roboto(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.roboto(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        height: 1.29,
      ),
      headlineSmall: GoogleFonts.roboto(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        height: 1.33,
      ),
      titleLarge: GoogleFonts.roboto(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        height: 1.27,
      ),
      titleMedium: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        height: 1.50,
      ),
      titleSmall: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      bodyLarge: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.50,
      ),
      bodyMedium: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
      ),
      labelLarge: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      labelMedium: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: GoogleFonts.roboto(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }
  
  // Alternative with mixed fonts
  static TextTheme get mixedTextTheme {
    return TextTheme(
      // Displays use Playfair Display (serif, elegant)
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        fontSize: 45,
        fontWeight: FontWeight.w400,
      ),
      displaySmall: GoogleFonts.playfairDisplay(
        fontSize: 36,
        fontWeight: FontWeight.w400,
      ),
      
      // Headlines use Oswald (condensed, modern)
      headlineLarge: GoogleFonts.oswald(
        fontSize: 32,
        fontWeight: FontWeight.w500,
      ),
      headlineMedium: GoogleFonts.oswald(
        fontSize: 28,
        fontWeight: FontWeight.w500,
      ),
      headlineSmall: GoogleFonts.oswald(
        fontSize: 24,
        fontWeight: FontWeight.w500,
      ),
      
      // Body text uses Merriweather (readable serif)
      bodyLarge: GoogleFonts.merriweather(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
      bodyMedium: GoogleFonts.merriweather(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.merriweather(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
      
      // UI elements use Roboto (clean, versatile)
      titleLarge: GoogleFonts.roboto(
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      labelLarge: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.roboto(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
    );
  }
}
```

### Component Themes Configuration

```dart
// lib/config/theme/component_themes.dart
import 'package:flutter/material.dart';

class AppComponentThemes {
  static AppBarTheme appBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 3,
      backgroundColor: Colors.transparent,
      surfaceTintColor: colorScheme.surfaceTint,
      foregroundColor: colorScheme.onSurface,
    );
  }
  
  static ElevatedButtonThemeData elevatedButtonTheme(ColorScheme colorScheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 1,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
  
  static FilledButtonThemeData filledButtonTheme(ColorScheme colorScheme) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
  
  static TextButtonThemeData textButtonTheme(ColorScheme colorScheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
  
  static OutlinedButtonThemeData outlinedButtonTheme(ColorScheme colorScheme) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        side: BorderSide(width: 1, color: colorScheme.outline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
  
  static CardTheme cardTheme(ColorScheme colorScheme) {
    return CardTheme(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(8),
    );
  }
  
  static InputDecorationTheme inputDecorationTheme(ColorScheme colorScheme) {
    return InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.error),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
    );
  }
  
  static FloatingActionButtonThemeData fabTheme(ColorScheme colorScheme) {
    return const FloatingActionButtonThemeData(
      elevation: 3,
      focusElevation: 4,
      hoverElevation: 4,
      highlightElevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    );
  }
  
  static NavigationBarThemeData navigationBarTheme(ColorScheme colorScheme) {
    return NavigationBarThemeData(
      height: 80,
      elevation: 3,
      indicatorColor: colorScheme.secondaryContainer,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          );
        }
        return const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        );
      }),
    );
  }
  
  static BottomSheetThemeData bottomSheetTheme(ColorScheme colorScheme) {
    return const BottomSheetThemeData(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      clipBehavior: Clip.antiAlias,
    );
  }
  
  static DialogTheme dialogTheme(ColorScheme colorScheme) {
    return DialogTheme(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
    );
  }
  
  static ChipThemeData chipTheme(ColorScheme colorScheme) {
    return ChipThemeData(
      backgroundColor: colorScheme.surfaceContainerHighest,
      deleteIconColor: colorScheme.onSurfaceVariant,
      selectedColor: colorScheme.secondaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
```

### Main Theme Configuration

```dart
// lib/config/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'color_schemes.dart';
import 'text_theme.dart';
import 'component_themes.dart';

class AppTheme {
  // Light theme
  static ThemeData get lightTheme {
    final ColorScheme colorScheme = AppColorSchemes.lightColorScheme;
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: AppTextTheme.textTheme,
      
      // Component themes
      appBarTheme: AppComponentThemes.appBarTheme(colorScheme),
      elevatedButtonTheme: AppComponentThemes.elevatedButtonTheme(colorScheme),
      filledButtonTheme: AppComponentThemes.filledButtonTheme(colorScheme),
      textButtonTheme: AppComponentThemes.textButtonTheme(colorScheme),
      outlinedButtonTheme: AppComponentThemes.outlinedButtonTheme(colorScheme),
      cardTheme: AppComponentThemes.cardTheme(colorScheme),
      inputDecorationTheme: AppComponentThemes.inputDecorationTheme(colorScheme),
      floatingActionButtonTheme: AppComponentThemes.fabTheme(colorScheme),
      navigationBarTheme: AppComponentThemes.navigationBarTheme(colorScheme),
      bottomSheetTheme: AppComponentThemes.bottomSheetTheme(colorScheme),
      dialogTheme: AppComponentThemes.dialogTheme(colorScheme),
      chipTheme: AppComponentThemes.chipTheme(colorScheme),
      
      // Additional properties
      scaffoldBackgroundColor: colorScheme.surface,
      dividerTheme: DividerThemeData(
        color: colorScheme.outline,
        thickness: 1,
      ),
    );
  }
  
  // Dark theme
  static ThemeData get darkTheme {
    final ColorScheme colorScheme = AppColorSchemes.darkColorScheme;
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: AppTextTheme.textTheme,
      
      // Component themes
      appBarTheme: AppComponentThemes.appBarTheme(colorScheme),
      elevatedButtonTheme: AppComponentThemes.elevatedButtonTheme(colorScheme),
      filledButtonTheme: AppComponentThemes.filledButtonTheme(colorScheme),
      textButtonTheme: AppComponentThemes.textButtonTheme(colorScheme),
      outlinedButtonTheme: AppComponentThemes.outlinedButtonTheme(colorScheme),
      cardTheme: AppComponentThemes.cardTheme(colorScheme),
      inputDecorationTheme: AppComponentThemes.inputDecorationTheme(colorScheme),
      floatingActionButtonTheme: AppComponentThemes.fabTheme(colorScheme),
      navigationBarTheme: AppComponentThemes.navigationBarTheme(colorScheme),
      bottomSheetTheme: AppComponentThemes.bottomSheetTheme(colorScheme),
      dialogTheme: AppComponentThemes.dialogTheme(colorScheme),
      chipTheme: AppComponentThemes.chipTheme(colorScheme),
      
      // Additional properties
      scaffoldBackgroundColor: colorScheme.surface,
      dividerTheme: DividerThemeData(
        color: colorScheme.outline,
        thickness: 1,
      ),
    );
  }
}
```

### Using in MaterialApp

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'config/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyItihas',
      
      // Apply themes
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // or ThemeMode.light, ThemeMode.dark
      
      home: const HomePage(),
    );
  }
}
```

## Using Themes in Widgets

### Accessing Theme Colors

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      color: colorScheme.primary,
      child: Text(
        'Primary Color Text',
        style: TextStyle(color: colorScheme.onPrimary),
      ),
    );
  }
}
```

### Accessing Text Styles

```dart
class MyTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Display Large',
          style: textTheme.displayLarge,
        ),
        Text(
          'Headline Medium',
          style: textTheme.headlineMedium,
        ),
        Text(
          'Body Text',
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}
```

### Modifying Theme Styles

```dart
Text(
  'Custom Style',
  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
    color: Theme.of(context).colorScheme.primary,
    fontWeight: FontWeight.bold,
    fontSize: 18,
  ),
);
```

### Override Theme Locally

```dart
Theme(
  data: Theme.of(context).copyWith(
    colorScheme: Theme.of(context).colorScheme.copyWith(
      primary: Colors.green,
    ),
  ),
  child: ElevatedButton(
    onPressed: () {},
    child: const Text('Green Button'),
  ),
);
```

## Advanced Theming Techniques

### Theme Extensions

Create custom theme properties beyond standard ThemeData:

```dart
// Custom theme extension
@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.success,
    required this.warning,
    required this.info,
  });
  
  final Color success;
  final Color warning;
  final Color info;
  
  @override
  CustomColors copyWith({
    Color? success,
    Color? warning,
    Color? info,
  }) {
    return CustomColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
    );
  }
  
  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    
    return CustomColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
    );
  }
}

// Add to theme
ThemeData(
  useMaterial3: true,
  extensions: const <ThemeExtension<dynamic>>[
    CustomColors(
      success: Color(0xFF4CAF50),
      warning: Color(0xFFFFC107),
      info: Color(0xFF2196F3),
    ),
  ],
);

// Usage
final customColors = Theme.of(context).extension<CustomColors>()!;
Container(color: customColors.success);
```

### Responsive Theming

Adapt theme based on screen size:

```dart
import 'package:flutter/material.dart';

class ResponsiveTheme {
  static ThemeData getTheme(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final baseTheme = AppTheme.lightTheme;
    
    if (screenWidth < 600) {
      // Mobile
      return baseTheme.copyWith(
        textTheme: baseTheme.textTheme.copyWith(
          displayLarge: baseTheme.textTheme.displayLarge?.copyWith(
            fontSize: 45,
          ),
        ),
      );
    } else if (screenWidth < 1200) {
      // Tablet
      return baseTheme.copyWith(
        textTheme: baseTheme.textTheme.copyWith(
          displayLarge: baseTheme.textTheme.displayLarge?.copyWith(
            fontSize: 57,
          ),
        ),
      );
    } else {
      // Desktop
      return baseTheme.copyWith(
        textTheme: baseTheme.textTheme.copyWith(
          displayLarge: baseTheme.textTheme.displayLarge?.copyWith(
            fontSize: 72,
          ),
        ),
      );
    }
  }
}
```

### Theme Persistence

Save and restore user's theme preference:

```dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  
  ThemeMode get themeMode => _themeMode;
  
  ThemeProvider() {
    _loadThemeMode();
  }
  
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString('themeMode') ?? 'system';
    
    _themeMode = ThemeMode.values.firstWhere(
      (mode) => mode.toString() == 'ThemeMode.$themeModeString',
      orElse: () => ThemeMode.system,
    );
    
    notifyListeners();
  }
  
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', mode.toString().split('.').last);
  }
}

// Usage with provider
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
```

### Animated Theme Transitions

Smooth transitions between themes:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      
      // Animated theme switching
      builder: (context, child) {
        return AnimatedTheme(
          data: Theme.of(context),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: child!,
        );
      },
      
      home: const HomePage(),
    );
  }
}
```

## Testing Themes

### Widget Tests with Themes

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Widget uses correct theme colors', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const MyWidget(),
      ),
    );
    
    // Find widget and check color
    final container = tester.widget<Container>(
      find.byType(Container),
    );
    
    expect(
      container.color,
      AppTheme.lightTheme.colorScheme.primary,
    );
  });
  
  testWidgets('Widget adapts to dark theme', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const MyWidget(),
      ),
    );
    
    // Verify dark theme colors
    final text = tester.widget<Text>(find.byType(Text));
    expect(
      text.style?.color,
      AppTheme.darkTheme.colorScheme.onSurface,
    );
  });
}
```

## Best Practices

### 1. Always Use Material 3

```dart
ThemeData(
  useMaterial3: true, // Required for Material 3
  // ... rest of theme
);
```

### 2. Use ColorScheme, Not Individual Colors

❌ **Don't:**

```dart
ThemeData(
  primaryColor: Colors.purple,
  accentColor: Colors.amber,
);
```

✅ **Do:**

```dart
ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
);
```

### 3. Use Theme.of(context) in Widgets

❌ **Don't:**

```dart
Container(color: Colors.blue);
```

✅ **Do:**

```dart
Container(color: Theme.of(context).colorScheme.primary);
```

### 4. Use Text Theme for Typography

❌ **Don't:**

```dart
Text(
  'Title',
  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
);
```

✅ **Do:**

```dart
Text(
  'Title',
  style: Theme.of(context).textTheme.headlineMedium,
);
```

### 5. Organize Theme Files

Keep theme configuration organized:

```
config/
└── theme/
    ├── app_theme.dart          # Main theme
    ├── color_schemes.dart      # Colors
    ├── text_theme.dart         # Typography
    └── component_themes.dart   # Components
```

### 6. Use Semantic Color Names

Use color roles (primary, secondary) instead of color values:

```dart
// Good: Semantic
color: colorScheme.primary
color: colorScheme.onSurface

// Bad: Hardcoded
color: Colors.purple
color: Color(0xFF6750A4)
```

### 7. Test Both Light and Dark Themes

Always test your UI in both themes:

```dart
themeMode: ThemeMode.system, // Respects user preference
```

### 8. Support Platform Conventions

Use platform-specific behaviors:

```dart
import 'dart:io';

ThemeData buildTheme() {
  if (Platform.isIOS) {
    // iOS-specific adjustments
  } else {
    // Android Material theme
  }
}
```

### 9. Optimize Font Loading

Preload Google Fonts to avoid layout shifts:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  GoogleFonts.config.allowRuntimeFetching = false;
  
  runApp(const MyApp());
}
```

### 10. Use Theme Extensions for Custom Properties

For properties not in ThemeData:

```dart
extensions: <ThemeExtension<dynamic>>[
  CustomColors(...),
  CustomSpacing(...),
]
```

## Common Pitfalls

### 1. Not Using Material 3

Material 2 is deprecated. Always set `useMaterial3: true`.

### 2. Hardcoding Colors

Avoid hardcoding colors; use theme colors for consistency.

### 3. Ignoring Accessibility

Ensure sufficient contrast ratios (WCAG AA: 4.5:1 for text).

### 4. Inconsistent Typography

Use TextTheme styles consistently throughout the app.

### 5. Not Testing Dark Mode

Many users prefer dark mode; test thoroughly.

### 6. Over-Customizing

Don't fight Material Design; work with it.

### 7. Font Loading Issues

Handle font loading errors gracefully.

## Resources

- [Material Design 3](https://m3.material.io/)
- [Material Theme Builder](https://m3.material.io/theme-builder)
- [Flutter ThemeData Documentation](https://api.flutter.dev/flutter/material/ThemeData-class.html)
- [ColorScheme Documentation](https://api.flutter.dev/flutter/material/ColorScheme-class.html)
- [Google Fonts Package](https://pub.dev/packages/google_fonts)
- [Dynamic Color Package](https://pub.dev/packages/dynamic_color)
- [Flutter Typography Guide](https://docs.flutter.dev/ui/design/text/typography)

## Conclusion

Material Design 3 theming in Flutter provides:

- **Consistency**: Unified design language
- **Flexibility**: Easy customization
- **Accessibility**: Built-in accessibility features
- **Adaptability**: Dynamic color and dark mode support
- **Maintainability**: Centralized theme management

By following this guide and best practices, you can create beautiful, accessible, and maintainable Flutter applications with professional theming.

For integration with project architecture, see:

- [Architecture Guide](architecture.md) - Theme integration in Clean Architecture
- [Package Guide](packages.md) - Theming-related packages
- [Internationalization Guide](intl.md) - Combining themes with i18n
