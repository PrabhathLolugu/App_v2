import 'package:flutter/material.dart';
import 'package:myitihas/pages/map2/app_theme.dart';
import 'package:myitihas/pages/map2/widgets/custom_icon_widget.dart';
import 'package:sizer/sizer.dart';

/// User reviews section
class ReviewsSection extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;
  final VoidCallback onViewAllReviews;

  const ReviewsSection({
    super.key,
    required this.reviews,
    required this.onViewAllReviews,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor, width: 1.0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'User Reviews',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.accentPink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: onViewAllReviews,
                  child: Text(
                    'View All',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.navigationOrange,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: theme.dividerColor),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reviews.length > 3 ? 3 : reviews.length,
            separatorBuilder: (context, index) =>
                Divider(height: 1, color: theme.dividerColor),
            itemBuilder: (context, index) {
              final review = reviews[index];
              return _ReviewItem(review: review, theme: theme);
            },
          ),
        ],
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final Map<String, dynamic> review;
  final ThemeData theme;

  const _ReviewItem({required this.review, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                child: Text(
                  (review['userName'] as String).substring(0, 1).toUpperCase(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['userName'] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return CustomIconWidget(
                            iconName: index < (review['rating'] as int)
                                ? 'star'
                                : 'star_border',
                            color: AppTheme.warningAmber,
                            size: 14,
                          );
                        }),
                        SizedBox(width: 2.w),
                        Text(
                          review['date'] as String,
                          style: theme.textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            review['comment'] as String,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
