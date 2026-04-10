import 'package:flutter/material.dart';
import 'package:myitihas/pages/map2/widgets/custom_icon_widget.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sizer/sizer.dart';

/// Widget displaying progress for a specific spiritual intent
class IntentProgressCardWidget extends StatelessWidget {
  final String intentName;
  final double progress;
  final int sitesCompleted;
  final int totalSites;
  final Color color;

  const IntentProgressCardWidget({
    super.key,
    required this.intentName,
    required this.progress,
    required this.sitesCompleted,
    required this.totalSites,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 45.w,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: _getIconForIntent(intentName),
                  color: color,
                  size: 24,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  intentName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          LinearPercentIndicator(
            padding: EdgeInsets.zero,
            lineHeight: 1.25.h,
            percent: progress / 100,
            progressColor: color,
            backgroundColor: color.withValues(alpha: 0.2),
            barRadius: const Radius.circular(10),
            animation: true,
            animationDuration: 1000,
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$sitesCompleted / $totalSites sites',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '${progress.toInt()}%',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getIconForIntent(String intent) {
    switch (intent.toLowerCase()) {
      case 'all':
        return 'temple_hindu';
      case 'shaktipeethas':
        return 'self_improvement';
      case 'char_dham':
        return 'landscape';
      case 'jyotirlinga':
        return 'flare';
      case 'unesco':
        return 'account_balance';
      default:
        return 'temple_hindu';
    }
  }
}
