import 'package:flutter/material.dart';
import 'package:myitihas/pages/map2/app_theme.dart';
import 'package:myitihas/pages/map2/widgets/custom_icon_widget.dart';
import 'package:sizer/sizer.dart';

class FilterChipsWidget extends StatelessWidget {
  final List<String> activeFilters;
  final ValueChanged<String> onRemoveFilter;

  const FilterChipsWidget({
    super.key,
    required this.activeFilters,
    required this.onRemoveFilter,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.symmetric(vertical: 1.h),

      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...activeFilters.map((filter) {
              return Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: Chip(
                  label: Text(filter),
                  labelStyle: theme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.containerWhite,
                  ),
                  backgroundColor: theme.colorScheme.primary,
                  deleteIcon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.containerWhite,
                    size: 18,
                  ),
                  onDeleted: () => onRemoveFilter(filter),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
