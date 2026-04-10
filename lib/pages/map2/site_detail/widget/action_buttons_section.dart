import 'package:flutter/material.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/pages/map2/widgets/custom_icon_widget.dart';
import 'package:sizer/sizer.dart';

/// Horizontal scrollable action buttons
class ActionButtonsSection extends StatelessWidget {
  final VoidCallback onAddToJourney;
  final VoidCallback onGetDirections;
  final VoidCallback onExploreNearby;
  final VoidCallback onViewInMap;
  final VoidCallback onShare;

  const ActionButtonsSection({
    super.key,
    required this.onAddToJourney,
    required this.onGetDirections,
    required this.onExploreNearby,
    required this.onViewInMap,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 14.h,
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        children: [
          _ActionButton(
            icon: 'add_circle_outline',
            label: t.map.addToJourney,
            onTap: onAddToJourney,
            theme: theme,
          ),
          SizedBox(width: 3.w),
          _ActionButton(
            icon: 'directions',
            label: t.map.getDirections,
            onTap: onGetDirections,
            theme: theme,
          ),
          SizedBox(width: 3.w),
          _ActionButton(
            icon: 'place',
            label: 'Nearby Places',
            onTap: onExploreNearby,
            theme: theme,
          ),
          SizedBox(width: 3.w),
          _ActionButton(
            icon: 'map',
            label: t.map.viewInMap,
            onTap: onViewInMap,
            theme: theme,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  final ThemeData theme;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = colorScheme.primary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 28.w,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              isDark ? const Color(0xFF1A1A1A) : const Color(0xFFFFFFFF),
              isDark ? const Color(0xFF121212) : const Color(0xFFF1F1F1),
            ],
          ),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.08),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(iconName: icon, color: color, size: 24),
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
