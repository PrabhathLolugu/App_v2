import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/features/home/data/datasources/activity_local_datasource.dart';
import 'package:myitihas/features/home/domain/entities/activity_item.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Activity History page showing user's story reading and generation history
class ActivityHistoryPage extends StatefulWidget {
  const ActivityHistoryPage({super.key});

  @override
  State<ActivityHistoryPage> createState() => _ActivityHistoryPageState();
}

class _ActivityHistoryPageState extends State<ActivityHistoryPage> {
  late Future<Map<DateTime, List<ActivityItem>>> _activitiesFuture;

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  void _loadActivities() {
    final datasource = getIt<ActivityLocalDataSource>();
    _activitiesFuture = datasource.getActivitiesGroupedByDate();
  }

  String _getDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final thisWeekStart = today.subtract(Duration(days: today.weekday - 1));

    if (date == today) {
      return 'Today';
    } else if (date == yesterday) {
      return 'Yesterday';
    } else if (date.isAfter(thisWeekStart)) {
      return 'This Week';
    } else {
      return 'Earlier';
    }
  }

  IconData _getActivityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.storyRead:
        return Icons.menu_book_rounded;
      case ActivityType.storyGenerated:
        return Icons.auto_awesome_rounded;
      case ActivityType.storyBookmarked:
        return Icons.bookmark_rounded;
      case ActivityType.storyShared:
        return Icons.share_rounded;
      case ActivityType.storyCompleted:
        return Icons.check_circle_rounded;
    }
  }

  Color _getActivityColor(ActivityType type, ColorScheme colorScheme) {
    switch (type) {
      case ActivityType.storyRead:
        return colorScheme.primary;
      case ActivityType.storyGenerated:
        return colorScheme.tertiary;
      case ActivityType.storyBookmarked:
        return colorScheme.secondary;
      case ActivityType.storyShared:
        return const Color(0xFF10B981);
      case ActivityType.storyCompleted:
        return const Color(0xFF22C55E);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final t = Translations.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          t.homeScreen.activityHistory,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<DateTime, List<ActivityItem>>>(
        future: _activitiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmer(context, isDark);
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 48.sp,
                    color: colorScheme.error,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    t.homeScreen.failedToLoadActivity,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _loadActivities();
                      });
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(t.common.retry),
                  ),
                ],
              ),
            );
          }

          final groupedActivities = snapshot.data ?? {};

          if (groupedActivities.isEmpty) {
            return _buildEmptyState(context);
          }

          // Sort dates in descending order
          final sortedDates = groupedActivities.keys.toList()
            ..sort((a, b) => b.compareTo(a));

          // Group by label (Today, Yesterday, This Week, Earlier)
          final labelGroups = <String, List<ActivityItem>>{};
          for (final date in sortedDates) {
            final label = _getDateLabel(date);
            labelGroups.putIfAbsent(label, () => []);
            labelGroups[label]!.addAll(groupedActivities[date]!);
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _loadActivities();
              });
            },
            color: colorScheme.primary,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              itemCount: labelGroups.length,
              itemBuilder: (context, index) {
                final label = labelGroups.keys.elementAt(index);
                final activities = labelGroups[label]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date group header
                    Padding(
                      padding: EdgeInsets.only(
                        top: index == 0 ? 0 : 24.h,
                        bottom: 12.h,
                      ),
                      child: Text(
                        label,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),

                    // Activity items
                    ...activities.map(
                      (activity) => _ActivityItemCard(
                        activity: activity,
                        icon: _getActivityIcon(activity.type),
                        color: _getActivityColor(activity.type, colorScheme),
                        onTap: () {
                          context.push('/home/stories/${activity.storyId}');
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final t = Translations.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.history_rounded,
                size: 64.sp,
                color: colorScheme.primary,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              t.homeScreen.noActivityYet,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              t.homeScreen.startReadingOrGenerating,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 24.h),
            FilledButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.explore_rounded),
              label: Text(t.homeScreen.exploreStoriesLabel),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer(BuildContext context, bool isDark) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
            highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
            child: Container(
              width: 80.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          ...List.generate(
            5,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Shimmer.fromColors(
                baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
                child: Container(
                  height: 72.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual activity item card
class _ActivityItemCard extends StatelessWidget {
  final ActivityItem activity;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _ActivityItemCard({
    required this.activity,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              children: [
                // Activity icon
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(icon, size: 20.sp, color: color),
                ),

                SizedBox(width: 12.w),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.storyTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Text(
                            activity.actionDescription,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '•',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            timeago.format(activity.timestamp),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arrow
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20.sp,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
