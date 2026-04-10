import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myitihas/core/widgets/markdown/markdown.dart';
import 'package:myitihas/features/social/domain/entities/comment.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentTile extends StatelessWidget {
  final Comment comment;
  final void Function(String commentId)? onLike;
  final void Function(String commentId, String userName)? onReply;
  final VoidCallback? onDelete;
  final VoidCallback? onProfileTap;
  final bool isCurrentUser;

  const CommentTile({
    super.key,
    required this.comment,
    this.onLike,
    this.onReply,
    this.onDelete,
    this.onProfileTap,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final indent = (comment.depth * 24.0).w;

    return Padding(
      padding: EdgeInsets.only(left: indent),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          border: Border(
            left: comment.depth > 0
                ? BorderSide(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    width: 2,
                  )
                : BorderSide.none,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: onProfileTap,
                  child: CircleAvatar(
                    radius: 16.r,
                    backgroundColor: colorScheme.primaryContainer,
                    backgroundImage: comment.userAvatar.isNotEmpty
                        ? NetworkImage(comment.userAvatar)
                        : null,
                    child: comment.userAvatar.isEmpty
                        ? Icon(
                            Icons.person,
                            size: 16.sp,
                            color: colorScheme.onPrimaryContainer,
                          )
                        : null,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            comment.userName,
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (isCurrentUser) ...[
                            SizedBox(width: 6.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                'You',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onPrimaryContainer,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        timeago.format(comment.timestamp),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCurrentUser && onDelete != null)
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      size: 18.sp,
                      color: Colors.red.withValues(alpha: 0.7),
                    ),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      onDelete!();
                    },
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: 32.w,
                      minHeight: 32.h,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8.h),
            SanitizedMarkdown(data: comment.text),
            SizedBox(height: 8.h),
            Row(
              children: [
                _ActionButton(
                  icon: comment.isLikedByCurrentUser
                      ? Icons.favorite
                      : Icons.favorite_border,
                  label: comment.likeCount > 0
                      ? comment.likeCount.toString()
                      : 'Like',
                  isActive: comment.isLikedByCurrentUser,
                  activeColor: Colors.red,
                  onTap: () => onLike?.call(comment.id),
                ),
                SizedBox(width: 16.w),
                if (comment.depth < 3)
                  _ActionButton(
                    icon: Icons.reply,
                    label: 'Reply',
                    onTap: () => onReply?.call(comment.id, comment.userName),
                  ),
              ],
            ),
            if (comment.replies.isNotEmpty) ...[
              SizedBox(height: 8.h),
              ...comment.replies.map(
                (reply) => CommentTile(
                  comment: reply,
                  onLike: onLike,
                  onReply: onReply,
                  onProfileTap: onProfileTap,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color? activeColor;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.activeColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final color = isActive
        ? (activeColor ?? colorScheme.primary)
        : colorScheme.onSurfaceVariant;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap?.call();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: color),
          SizedBox(width: 4.w),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
