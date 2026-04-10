import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/pages/map2/forum_community/discussion_ui_constants.dart';
import 'package:myitihas/utils/constants.dart'; // Ensure access to DarkColors/LightColors
import 'package:sizer/sizer.dart';

class CategoryFilterWidget extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategoryFilterWidget({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final t = context.t;

    final categories = [
      DiscussionFeedFilter.all,
      DiscussionFeedFilter.myActivity,
    ];

    return Container(
      height: 5.h,
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: categories.length,
        separatorBuilder: (context, index) => SizedBox(width: 2.w),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;
          final label = category == DiscussionFeedFilter.all
              ? t.map.allDiscussions
              : t.map.myActivity;

          return InkWell(
            onTap: () => onCategorySelected(category),
            borderRadius: BorderRadius.circular(
              25,
            ), // Matched to your tab design
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.2.h),
              decoration: BoxDecoration(
                // Applied the requested gradient logic
                gradient: isSelected
                    ? (isDark
                          ? DarkColors.messageUserGradient
                          : LightColors.messageUserGradient)
                    : null,
                color: isSelected ? null : Colors.transparent,
                // Border only shows for unselected to keep it clean
                border: isSelected
                    ? null
                    : Border.all(
                        color: isDark
                            ? DarkColors.textSecondary.withValues(alpha: 0.3)
                            : LightColors.textSecondary.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    // Matched font style
                    fontSize: 14.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : (isDark
                              ? DarkColors.textSecondary
                              : LightColors.textSecondary),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
