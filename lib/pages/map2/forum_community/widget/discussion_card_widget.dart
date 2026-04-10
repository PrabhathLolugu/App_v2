import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jiffy/jiffy.dart';
import 'package:myitihas/core/widgets/image_loading_placeholder/image_loading_placeholder.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/pages/map2/widgets/custom_icon_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DiscussionCardWidget extends StatelessWidget {
  final Map<String, dynamic> discussion;
  final VoidCallback onTap;
  final VoidCallback onLike;
  final VoidCallback onShare;
  final VoidCallback onReport;
  final VoidCallback onProfileTap;
  final ValueChanged<String>? onHashtagTap;
  final VoidCallback? onDelete; // Add this
  final bool isOwnPost;

  const DiscussionCardWidget({
    super.key,
    required this.discussion,
    required this.onTap,
    required this.onLike,
    required this.onShare,
    required this.onReport,
    required this.onProfileTap,
    this.onHashtagTap,
    this.onDelete,
    this.isOwnPost = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final t = context.t;

    final rawTimestamp = discussion['created_at']?.toString();
    final String timeAgo = rawTimestamp != null
        ? Jiffy.parse(rawTimestamp).fromNow()
        : t.map.discussions.justNow;
    final currentUser = Supabase.instance.client.auth.currentUser;

    final List likes = discussion['discussion_likes'] ?? [];
    final bool isLiked = likes.any(
      (like) => like['user_id'] == currentUser?.id,
    );

    final int replyCount = int.tryParse(
          discussion['replyCount']?.toString() ??
              discussion['reply_count']?.toString() ??
              discussion['comment_count']?.toString() ??
              '0',
        ) ??
        0;
    final hashtags = List<String>.from(discussion['hashtags'] ?? const [])
        .where((tag) => tag.trim().isNotEmpty)
        .take(5)
        .toList();

    return Slidable(
      key: ValueKey(discussion['id']),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onLike(),
            backgroundColor: theme.colorScheme.tertiary,
            foregroundColor: theme.colorScheme.onTertiary,
            icon: Icons.favorite,
            label: t.map.discussions.likeAction,
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),

      child: InkWell(
        onTap: onTap,

        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
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
              Row(
                children: [
                  InkWell(
                    onTap: onProfileTap,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl:
                              discussion['author_avatar']?.toString() ??
                              "https://ui-avatars.com/api/?name=${discussion['author']}&background=random",
                          width: 10.w,
                          height: 10.w,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              ImageLoadingPlaceholder(
                                width: 10.w,
                                height: 10.w,
                                borderRadius: BorderRadius.circular(5.w),
                              ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[800],
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: InkWell(
                      onTap: onProfileTap,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              discussion['author']?.toString() ??
                                  t.map.discussions.anonymous,
                              style: theme.textTheme.titleSmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              timeAgo,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            // Show site name if available
                            if (discussion['site_name'] != null)
                              Text(
                                discussion['site_name'].toString(),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.tertiary,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                (discussion['title'] ?? t.map.discussions.noTitle).toString(),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 1.h),
              Text(
                discussion['preview']?.toString() ?? '',
                style: theme.textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (hashtags.isNotEmpty) ...[
                SizedBox(height: 1.2.h),
                Wrap(
                  spacing: 10,
                  runSpacing: 4,
                  children: [
                    for (final tag in hashtags)
                      onHashtagTap == null
                          ? Text(
                              '#$tag',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : InkWell(
                              onTap: () => onHashtagTap!(tag),
                              borderRadius: BorderRadius.circular(4),
                              child: Text(
                                '#$tag',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                  ],
                ),
              ],
              SizedBox(height: 2.h),
              Row(
                children: [
                  _buildEngagementButton(
                    context,
                    icon: isLiked ? 'favorite' : 'favorite_border',
                    label: '${discussion['like_count'] ?? 0}',
                    color: isLiked
                        ? Colors.red
                        : theme.colorScheme.onSurfaceVariant,
                    onTap: onLike,
                  ),
                  SizedBox(width: 2.w),
                  _buildEngagementButton(
                    context,
                    icon: 'chat_bubble_outline',
                    label: '$replyCount',
                    color: theme.colorScheme.onSurfaceVariant,
                    onTap: onTap,
                  ),

                  SizedBox(width: 4.w),
                  const Spacer(),
                  if (isOwnPost && onDelete != null)
                    InkWell(
                      onTap: onDelete,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: EdgeInsets.all(1.w),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.delete_outline,
                              color: theme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEngagementButton(
    BuildContext context, {
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.all(1.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(iconName: icon, color: color, size: 20),
            SizedBox(width: 1.w),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
