import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';

/// Navigation item configuration for the bottom navigation bar
enum CustomBottomBarItem { map, journey, community, plan }

/// Extension to provide navigation details for each bottom bar item
extension CustomBottomBarItemExtension on CustomBottomBarItem {
  String get label {
    switch (this) {
      case CustomBottomBarItem.map:
        return 'Map';
      case CustomBottomBarItem.journey:
        return 'Journey';
      case CustomBottomBarItem.community:
        return 'Discussions';
      case CustomBottomBarItem.plan:
        return 'Plan';
    }
  }

  IconData get icon {
    switch (this) {
      case CustomBottomBarItem.map:
        return Icons.explore_outlined;
      case CustomBottomBarItem.journey:
        return Icons.route_outlined;
      case CustomBottomBarItem.community:
        return Icons.people_outline;
      case CustomBottomBarItem.plan:
        return Icons.calendar_today_outlined;
    }
  }

  IconData get activeIcon {
    switch (this) {
      case CustomBottomBarItem.map:
        return Icons.explore;
      case CustomBottomBarItem.journey:
        return Icons.route;
      case CustomBottomBarItem.community:
        return Icons.people;
      case CustomBottomBarItem.plan:
        return Icons.calendar_today;
    }
  }

  String get route {
    switch (this) {
      case CustomBottomBarItem.map:
        return '/akhanda-bharata-map';
      case CustomBottomBarItem.journey:
        return '/my-journey';
      case CustomBottomBarItem.community:
        return '/forum-community/general';
      case CustomBottomBarItem.plan:
        return '/plan';
    }
  }
}

/// A custom bottom navigation bar widget for the spiritual pilgrimage application.
///
/// Implements bottom-heavy interaction zone design pattern with thumb-friendly
/// touch targets (minimum 48dp) and 8dp spacing between elements.
///
/// Features:
/// - Platform-adaptive navigation following Material Design
/// - Sacred Minimalism design with clean geometric layouts
/// - Devotional Contrast color scheme with vibrant accent colors
/// - Smooth 200ms ease-out transitions with subtle scale animation
/// - Badge notifications support for achievements and community activity
/// - Persistent access to core pilgrimage functions
///
/// Usage:
/// ```dart
/// CustomBottomBar(
///   currentIndex: 0,
///   onTap: (index) {
///     // Handle navigation
///   },
/// )
/// ```
class CustomBottomBar extends StatelessWidget {
  /// The index of the currently selected navigation item
  final int currentIndex;

  /// Callback function when a navigation item is tapped
  final Function(int) onTap;

  /// Optional badge counts for each navigation item
  /// Map key corresponds to the item index
  final Map<int, int>? badges;

  /// Whether to show labels for navigation items
  final bool showLabels;

  /// Custom elevation for the bottom bar
  final double? elevation;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.badges,
    this.showLabels = true,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final gradients = theme.extension<GradientExtension>();
    final isDark = theme.brightness == Brightness.dark;

    final glassFill = gradients?.glassBackground ??
        (isDark
            ? colorScheme.surface.withValues(alpha: 0.85)
            : colorScheme.surface.withValues(alpha: 0.75));
    final glassBorderColor = gradients?.glassBorder ??
        colorScheme.primary.withValues(alpha: 0.2);

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          decoration: BoxDecoration(
            color: glassFill,
            border: Border(
              top: BorderSide(
                color: (isDark ? Colors.white : colorScheme.primary)
                    .withValues(alpha: 0.06),
                width: 1,
              ),
              left: BorderSide(color: glassBorderColor, width: 1),
              right: BorderSide(color: glassBorderColor, width: 1),
              bottom: BorderSide(color: glassBorderColor, width: 1),
            ),
          ),
          child: SafeArea(
            child: SizedBox(
              height: 64,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:
                    CustomBottomBarItem.values.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isSelected = currentIndex == index;
                  final badgeCount = badges?[index];

                  final selectedColor = colorScheme.primary;
                  final unselectedColor =
                      colorScheme.onSurface.withValues(alpha: 0.55);
                  return Expanded(
                    child: _NavigationItem(
                      item: item,
                      isSelected: isSelected,
                      onTap: () => onTap(index),
                      badgeCount: badgeCount,
                      showLabel: showLabels,
                      selectedColor: selectedColor,
                      unselectedColor: unselectedColor,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Floating glass-style bottom bar for map section. Use inside a Stack with
/// Positioned(bottom: 12, left: 16, right: 16, child: FloatingMapBottomBar(...)).
const double _kFloatingBarHeight = 52;
const double _kFloatingIconSize = 22;
const double _kFloatingLabelFontSize = 11;

class FloatingMapBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final Map<int, int>? badges;

  const FloatingMapBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.badges,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final gradients = theme.extension<GradientExtension>();
    final selectedColor = theme.colorScheme.primary;
    final unselectedColor = Colors.white.withValues(alpha: 0.55);

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.12),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: CustomBottomBarItem.values.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = currentIndex == index;
              final badgeCount = badges?[index];
              final color = isSelected ? selectedColor : unselectedColor;
              return Expanded(
                child: InkWell(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onTap(index);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          padding: EdgeInsets.symmetric(
                            horizontal: isSelected ? 14 : 6,
                            vertical: isSelected ? 6 : 4,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colorScheme.primary.withValues(alpha: 0.12)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Icon(
                                isSelected ? item.activeIcon : item.icon,
                                color: color,
                                size: _kFloatingIconSize,
                              ),
                              if (badgeCount != null && badgeCount > 0)
                                Positioned(
                                  right: -6,
                                  top: -2,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: colorScheme.error,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 14,
                                      minHeight: 14,
                                    ),
                                    child: Center(
                                      child: Text(
                                        badgeCount > 99
                                            ? '99+'
                                            : badgeCount.toString(),
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                              color: colorScheme.onError,
                                              fontSize: 8,
                                              fontWeight: FontWeight.w600,
                                              height: 1.0,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.label,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: color,
                            fontSize: _kFloatingLabelFontSize,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

/// Internal widget for individual navigation items
class _NavigationItem extends StatefulWidget {
  final CustomBottomBarItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final int? badgeCount;
  final bool showLabel;
  final Color selectedColor;
  final Color unselectedColor;

  const _NavigationItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
    this.badgeCount,
    required this.showLabel,
    required this.selectedColor,
    required this.unselectedColor,
  });

  @override
  State<_NavigationItem> createState() => _NavigationItemState();
}

class _NavigationItemState extends State<_NavigationItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    if (widget.isSelected) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(_NavigationItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isSelected
        ? widget.selectedColor
        : widget.unselectedColor;
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        widget.onTap();
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    widget.isSelected
                        ? widget.item.activeIcon
                        : widget.item.icon,
                    color: color,
                    size: 28,
                  ),
                  if (widget.badgeCount != null && widget.badgeCount! > 0)
                    Positioned(
                      right: -8,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                theme
                                    .bottomNavigationBarTheme
                                    .backgroundColor ??
                                theme.colorScheme.surface,
                            width: 2,
                          ),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Center(
                          child: Text(
                            widget.badgeCount! > 99
                                ? '99+'
                                : widget.badgeCount.toString(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onError,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              height: 1.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              if (widget.showLabel) ...[
                const SizedBox(height: 4),
                Text(
                  widget.item.label,
                  style: theme.bottomNavigationBarTheme.selectedLabelStyle
                      ?.copyWith(color: color, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Extension to easily navigate using CustomBottomBar
extension CustomBottomBarNavigation on BuildContext {
  /// Navigate to a specific bottom bar item
  void navigateToBottomBarItem(CustomBottomBarItem item) {
    go(item.route);
  }

  /// Navigate to a bottom bar item by index
  void navigateToBottomBarIndex(int index) {
    if (index >= 0 && index < CustomBottomBarItem.values.length) {
      final item = CustomBottomBarItem.values[index];
      go(item.route);
    }
  }
}
