import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/core/widgets/voice_input/voice_input_button.dart';
import 'package:myitihas/pages/map2/map_navigation.dart';

/// Variant types for the custom app bar
enum CustomAppBarVariant {
  /// Standard app bar with title and optional actions
  standard,

  /// App bar with back button and title
  withBack,

  /// App bar with search functionality
  search,

  /// Transparent app bar for overlay on content (e.g., map view)
  transparent,

  /// App bar with centered title and minimal styling
  centered,
}

/// A custom app bar widget for the spiritual pilgrimage application.
///
/// Implements Sacred Minimalism design with clean geometric layouts and
/// meaningful color symbolism. Supports multiple variants for different
/// screen contexts while maintaining consistent visual language.
///
/// Features:
/// - Multiple variants (standard, withBack, search, transparent, centered)
/// - Platform-adaptive styling
/// - Devotional Contrast color scheme
/// - Smooth transitions and animations
/// - Support for custom actions and leading widgets
/// - Optimized for both light and dark themes
/// - "Return to Map" functionality integration
///
/// Usage:
/// ```dart
/// CustomAppBar(
///   title: 'Sacred Sites',
///   variant: CustomAppBarVariant.withBack,
///   onBackPressed: () => context.pop(),
///   actions: [
///     IconButton(
///       icon: Icon(Icons.search),
///       onPressed: () {},
///     ),
///   ],
/// )
/// ```
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title to display in the app bar
  final String title;

  /// The variant of the app bar
  final CustomAppBarVariant variant;

  /// Callback when back button is pressed (for withBack variant)
  final VoidCallback? onBackPressed;

  /// Custom leading widget (overrides default back button)
  final Widget? leading;

  /// List of action widgets to display on the right
  final List<Widget>? actions;

  /// Whether to show the "Return to Map" action
  final bool showReturnToMap;

  /// Callback when "Return to Map" is pressed
  final VoidCallback? onReturnToMap;

  /// Custom background color (overrides theme)
  final Color? backgroundColor;

  /// Custom foreground color for text and icons (overrides theme)
  final Color? foregroundColor;

  /// Custom elevation (overrides theme)
  final double? elevation;

  /// Whether to center the title
  final bool? centerTitle;

  /// Search controller for search variant
  final TextEditingController? searchController;

  /// Callback when search text changes
  final ValueChanged<String>? onSearchChanged;

  /// Hint text for search field
  final String? searchHint;

  /// Whether to show a bottom border
  final bool showBottomBorder;

  const CustomAppBar({
    super.key,
    required this.title,
    this.variant = CustomAppBarVariant.standard,
    this.onBackPressed,
    this.leading,
    this.actions,
    this.showReturnToMap = false,
    this.onReturnToMap,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.centerTitle,
    this.searchController,
    this.onSearchChanged,
    this.searchHint,
    this.showBottomBorder = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appBarTheme = theme.appBarTheme;
    final gradients = theme.extension<GradientExtension>();

    final isTransparentVariant = variant == CustomAppBarVariant.transparent;

    final effectiveForegroundColor =
        foregroundColor ??
        appBarTheme.foregroundColor ??
        theme.colorScheme.onSurface;

    final shouldCenterTitle =
        centerTitle ??
        (variant == CustomAppBarVariant.centered ||
            variant == CustomAppBarVariant.transparent);

    // Liquid glass for non-transparent variants: blur + translucent fill + border
    final useLiquidGlass = !isTransparentVariant;
    final glassFill = gradients?.glassBackground ??
        theme.colorScheme.surface.withValues(alpha: 0.85);
    final glassBorderColor = gradients?.glassBorder ??
        theme.colorScheme.primary.withValues(alpha: 0.2);
    final topHighlightColor = theme.brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.06)
        : theme.colorScheme.primary.withValues(alpha: 0.06);

    Widget appBarContent = AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: effectiveForegroundColor,
      elevation: 0,
      centerTitle: shouldCenterTitle,
      systemOverlayStyle: _getSystemOverlayStyle(theme, variant),
      leading: _buildLeading(context, effectiveForegroundColor),
      title: _buildTitle(context, theme, effectiveForegroundColor),
      actions: _buildActions(context, effectiveForegroundColor),
    );

    if (useLiquidGlass) {
      appBarContent = ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              color: glassFill,
              border: Border(
                top: BorderSide(color: topHighlightColor, width: 1),
                bottom: BorderSide(
                  color: showBottomBorder ? theme.dividerColor : glassBorderColor,
                  width: showBottomBorder ? 1.0 : 1,
                ),
              ),
            ),
            child: appBarContent,
          ),
        ),
      );
    } else if (showBottomBorder) {
      appBarContent = Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(
            bottom: BorderSide(color: theme.dividerColor, width: 1.0),
          ),
        ),
        child: appBarContent,
      );
    }

    return appBarContent;
  }

  void _handleBackTap(BuildContext context) {
    HapticFeedback.selectionClick();
    if (onBackPressed != null) {
      onBackPressed!();
    } else {
      goBackToMapLanding(context);
    }
  }

  void _handleReturnToMapTap(BuildContext context) {
    HapticFeedback.selectionClick();
    (onReturnToMap ?? () => goBackToMapLanding(context))();
  }

  /// Build the leading widget based on variant
  Widget? _buildLeading(BuildContext context, Color foregroundColor) {
    if (leading != null) return leading;

    switch (variant) {
      case CustomAppBarVariant.withBack:
      case CustomAppBarVariant.search:
        return IconButton(
          icon: const Icon(Icons.arrow_back),
          color: foregroundColor,
          onPressed: () => _handleBackTap(context),
          tooltip: 'Back',
        );
      case CustomAppBarVariant.transparent:
        if (showReturnToMap) {
          return Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.explore),
              color: Colors.white,
              onPressed: () => _handleReturnToMapTap(context),
              tooltip: 'Return to Map',
            ),
          );
        }
        return null;
      default:
        return null;
    }
  }

  /// Build the title widget based on variant
  Widget _buildTitle(
    BuildContext context,
    ThemeData theme,
    Color foregroundColor,
  ) {
    if (variant == CustomAppBarVariant.search) {
      return Align(
        alignment: Alignment.centerLeft,
        child: TextField(
          controller: searchController,
          onChanged: onSearchChanged,
          style: theme.textTheme.bodyLarge?.copyWith(color: foregroundColor),
          decoration: InputDecoration(
            hintText: searchHint ?? 'Search sacred sites...',
            suffixIcon: searchController != null
                ? VoiceInputButton(controller: searchController!, compact: true)
                : null,
            hintStyle: theme.textTheme.bodyLarge?.copyWith(
              color: foregroundColor.withValues(alpha: 0.6),
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          ),
        ),
      );
    }

    return Text(
      title,
      style: theme.appBarTheme.titleTextStyle?.copyWith(color: foregroundColor),
    );
  }

  /// Build the actions list
  List<Widget>? _buildActions(BuildContext context, Color foregroundColor) {
    final actionsList = <Widget>[];

    // Add custom actions
    if (actions != null) {
      actionsList.addAll(actions!);
    }

    // Add "Return to Map" action if needed
    if (showReturnToMap && variant != CustomAppBarVariant.transparent) {
      actionsList.add(
        IconButton(
          icon: const Icon(Icons.explore),
          color: foregroundColor,
          onPressed: () => _handleReturnToMapTap(context),
          tooltip: 'Return to Map',
        ),
      );
    }

    return actionsList.isEmpty ? null : actionsList;
  }

  /// Get system overlay style based on theme and variant
  SystemUiOverlayStyle _getSystemOverlayStyle(
    ThemeData theme,
    CustomAppBarVariant variant,
  ) {
    if (variant == CustomAppBarVariant.transparent) {
      return SystemUiOverlayStyle.light;
    }

    return theme.brightness == Brightness.light
        ? SystemUiOverlayStyle.dark
        : SystemUiOverlayStyle.light;
  }
}

/// Extension to easily create CustomAppBar instances
extension CustomAppBarBuilder on BuildContext {
  /// Create a standard app bar
  CustomAppBar standardAppBar({
    required String title,
    List<Widget>? actions,
    bool showReturnToMap = false,
  }) {
    return CustomAppBar(
      title: title,
      variant: CustomAppBarVariant.standard,
      actions: actions,
      showReturnToMap: showReturnToMap,
    );
  }

  /// Create an app bar with back button
  CustomAppBar appBarWithBack({
    required String title,
    VoidCallback? onBackPressed,
    List<Widget>? actions,
    bool showReturnToMap = false,
  }) {
    return CustomAppBar(
      title: title,
      variant: CustomAppBarVariant.withBack,
      onBackPressed: onBackPressed,
      actions: actions,
      showReturnToMap: showReturnToMap,
    );
  }

  /// Create a search app bar
  CustomAppBar searchAppBar({
    required TextEditingController searchController,
    required ValueChanged<String> onSearchChanged,
    String? searchHint,
    VoidCallback? onBackPressed,
  }) {
    return CustomAppBar(
      title: '',
      variant: CustomAppBarVariant.search,
      searchController: searchController,
      onSearchChanged: onSearchChanged,
      searchHint: searchHint,
      onBackPressed: onBackPressed,
    );
  }

  /// Create a transparent app bar (for overlays)
  CustomAppBar transparentAppBar({
    required String title,
    bool showReturnToMap = true,
    VoidCallback? onReturnToMap,
  }) {
    return CustomAppBar(
      title: title,
      variant: CustomAppBarVariant.transparent,
      showReturnToMap: showReturnToMap,
      onReturnToMap: onReturnToMap,
    );
  }

  /// Create a centered app bar
  CustomAppBar centeredAppBar({required String title, List<Widget>? actions}) {
    return CustomAppBar(
      title: title,
      variant: CustomAppBarVariant.centered,
      actions: actions,
    );
  }
}
