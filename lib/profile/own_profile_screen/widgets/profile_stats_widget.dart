import 'package:flutter/material.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:sizer/sizer.dart';

class ProfileStatsWidget extends StatelessWidget {
  final int posts;
  final int followers;
  final int following;

  const ProfileStatsWidget({
    super.key,
    required this.posts,
    required this.followers,
    required this.following,
  });

  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            context,
            _formatCount(posts),
            t.community.posts,
            theme,
          ),
          Container(
            width: 1,
            height: 6.h,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
          ),
          _buildStatItem(
            context,
            _formatCount(followers),
            t.profile.followers,
            theme,
          ),
          Container(
            width: 1,
            height: 6.h,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
          ),
          _buildStatItem(
            context,
            _formatCount(following),
            t.profile.following,
            theme,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String count,
    String label,
    ThemeData theme,
  ) {
    return Column(
      children: [
        Text(
          count,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
