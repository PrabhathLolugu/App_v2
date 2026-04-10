import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:myitihas/i18n/strings.g.dart';

/// Horizontal scroll of engaging action chips to encourage exploration.
class ExploreMoreStrip extends StatelessWidget {
  const ExploreMoreStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final items = [
      _ExploreItem(
        icon: Icons.trending_up_rounded,
        label: t.community.trending,
        onTap: () {
          HapticFeedback.mediumImpact();
          context.push('/home/stories');
        },
      ),
      _ExploreItem(
        icon: Icons.explore_rounded,
        label: t.navigation.map,
        onTap: () {
          HapticFeedback.mediumImpact();
          context.push('/intent-choice');
        },
      ),
      _ExploreItem(
        icon: Icons.auto_awesome_rounded,
        label: t.homeScreen.generateStory,
        onTap: () {
          HapticFeedback.mediumImpact();
          context.push('/story-generator');
        },
      ),
      _ExploreItem(
        icon: Icons.groups_rounded,
        label: t.navigation.community,
        onTap: () {
          HapticFeedback.mediumImpact();
          context.go('/home?tab=2');
        },
      ),
      _ExploreItem(
        icon: Icons.chat_bubble_rounded,
        label: t.navigation.chat,
        onTap: () {
          HapticFeedback.mediumImpact();
          context.push('/chatbot');
        },
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            t.homeScreen.exploreMore,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 48.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => SizedBox(width: 10.w),
            itemBuilder: (context, index) {
              final item = items[index];
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: item.onTap,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: isDark
                          ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.6)
                          : colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item.icon,
                          size: 20.sp,
                          color: colorScheme.primary,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ExploreItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  _ExploreItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}
