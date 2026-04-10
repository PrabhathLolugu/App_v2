import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/pages/map2/map_navigation.dart';
import 'package:sizer/sizer.dart';

/// Tab definitions for the map section.
enum MapTab {
  map,
  journey,
  discussions,
  plan;

  String get label {
    switch (this) {
      case MapTab.map:
        return 'Map';
      case MapTab.journey:
        return 'Journey';
      case MapTab.discussions:
        return 'Discussions';
      case MapTab.plan:
        return 'Plan';
    }
  }

  String get route {
    switch (this) {
      case MapTab.map:
        return '/home?tab=3&map=akhanda';
      case MapTab.journey:
        return '/home?tab=3&map=journey';
      case MapTab.discussions:
        return '/home?tab=3&map=discussions';
      case MapTab.plan:
        return '/home?tab=3&map=plan';
    }
  }
}

/// A two-row app-bar that mirrors the ChatItihas pill-tab style.
///
/// Row 1 — title area with a back-to-landing arrow and screen label.
/// Row 2 — animated pill tabs: Map | Journey | Discussions | Plan
///
/// Use as `appBar:` on each Scaffold. Because we use GoRouter every tab
/// navigates to its own route instead of using a PageController.
class MapTabHeader extends StatelessWidget implements PreferredSizeWidget {
  const MapTabHeader({
    super.key,
    required this.currentIndex,
    this.actions,
  });

  final int currentIndex;
  final List<Widget>? actions;

  static const double _tabBarHeight = 52.0;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + _tabBarHeight + 4);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final gradients = theme.extension<GradientExtension>();
    final t = Translations.of(context);

    final glassFill = gradients?.glassBackground ??
        (isDark
            ? colorScheme.surface.withValues(alpha: 0.85)
            : colorScheme.surface.withValues(alpha: 0.92));
    final glassBorderColor =
        gradients?.glassBorder ?? colorScheme.primary.withValues(alpha: 0.18);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: BoxDecoration(
            color: glassFill,
            border: Border(
              bottom: BorderSide(color: glassBorderColor, width: 1),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── ROW 1: back button + section title + actions ──────────
                SizedBox(
                  height: kToolbarHeight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Row(
                      children: [
                        // Back to map landing
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          tooltip: 'Back',
                          onPressed: () {
                            HapticFeedback.selectionClick();
                            goBackToMapLanding(context);
                          },
                        ),
                        Text(
                          t.map.title,
                          style: GoogleFonts.inter(
                            fontSize: 21.sp,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const Spacer(),
                        if (actions != null) ...actions!,
                      ],
                    ),
                  ),
                ),

                // ── ROW 2: pill tab bar ────────────────────────────────────
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 4),
                  child: _buildPillTabBar(
                      context, colorScheme, isDark, gradients),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPillTabBar(
    BuildContext context,
    ColorScheme colorScheme,
    bool isDark,
    GradientExtension? gradients,
  ) {
    final tabs = MapTab.values;
    // Glass container for the whole pill row
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: isDark
                ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.55)
                : colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: colorScheme.onSurface.withValues(alpha: 0.12),
              width: 1,
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
            child: Row(
              children: List.generate(tabs.length, (index) {
                final tab = tabs[index];
                final isSelected = currentIndex == index;

                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (currentIndex == index) return;
                      HapticFeedback.selectionClick();
                      _navigateTo(context, tab, index);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: isSelected
                          ? BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Color(0xFF2C2C2C), Color(0xFF121212)],
                              ),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.24),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            )
                          : null,
                      child: Center(
                          child: Text(
                          _localizedLabel(context, tab),
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  String _localizedLabel(BuildContext context, MapTab tab) {
    final t = Translations.of(context);
    switch (tab) {
      case MapTab.map:
        return t.navigation.map;
      case MapTab.journey:
        return t.map.journeyTab;
      case MapTab.discussions:
        return t.map.discussionTab;
      case MapTab.plan:
        return t.plan.planTab;
    }
  }

  void _navigateTo(BuildContext context, MapTab tab, int index) {
    switch (index) {
      case 0:
        goToMapWithSavedState(context);
        break;
      default:
        context.go(tab.route);
    }
  }
}
