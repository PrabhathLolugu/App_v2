import 'package:flutter/material.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/pages/map2/widgets/custom_icon_widget.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sizer/sizer.dart';

/// Widget displaying overall journey progress overview
class ProgressOverviewWidget extends StatelessWidget {
  final double completionPercentage;
  final int visitedSitesCount;
  final int badgesEarned;
  final int totalSites;

  const ProgressOverviewWidget({
    super.key,
    required this.completionPercentage,
    required this.visitedSitesCount,
    required this.badgesEarned,
    required this.totalSites,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surfaceContainerHigh.withValues(
              alpha: isDark ? 0.2 : 0.5,
            ),
            theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: isDark ? 0.3 : 0.85,
            ),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Journey Progress',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              // Circular Progress Indicator
              CircularPercentIndicator(
                radius: 15.w,
                lineWidth: 3.w,
                percent: completionPercentage / 100,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${completionPercentage.toInt()}%',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Complete',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                progressColor: theme.colorScheme.primary,
                backgroundColor: theme.colorScheme.primary.withValues(
                  alpha: 0.2,
                ),
                circularStrokeCap: CircularStrokeCap.round,
                animation: true,
                animationDuration: 1200,
              ),
              SizedBox(width: 6.w),
              // Stats Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatRow(
                      context,
                      icon: 'place',
                      label: Translations.of(context).map.sitesVisited,
                      value: '$visitedSitesCount / $totalSites',
                    ),
                    SizedBox(height: 2.h),
                    _buildStatRow(
                      context,
                      icon: 'emoji_events',
                      label: 'Badges Earned',
                      value: badgesEarned.toString(),
                    ),
                    SizedBox(height: 2.h),
                    _buildStatRow(
                      context,
                      icon: 'trending_up',
                      label: Translations.of(context).map.completionRate,
                      value:
                          '${(completionPercentage / 100 * totalSites).toInt()} sites',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context, {
    required String icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: theme.colorScheme.primary,
          size: 20,
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
