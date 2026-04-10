import 'package:flutter/material.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/pages/map2/app_theme.dart';
import 'package:myitihas/pages/map2/widgets/custom_icon_widget.dart';
import 'package:sizer/sizer.dart';

/// Sticky bottom action bar with primary CTA
class BottomActionBar extends StatelessWidget {
  final VoidCallback onAddToJourney;
  final VoidCallback onGetDirections;
  final bool isAddedToJourney;

  const BottomActionBar({
    super.key,
    required this.onAddToJourney,
    required this.onGetDirections,
    this.isAddedToJourney = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: theme.dividerColor, width: 1.0)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Get Directions button
            Expanded(
              flex: 2,
              child: OutlinedButton.icon(
                onPressed: onGetDirections,
                icon: CustomIconWidget(
                  iconName: 'directions',
                  color: AppTheme.navigationOrange,
                  size: 20,
                ),
                label: Text(t.map.directions),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.navigationOrange,
                  side: BorderSide(
                    color: AppTheme.navigationOrange,
                    width: 1.5,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
              ),
            ),
            SizedBox(width: 3.w),

            // Add to Journey button
            Expanded(
              flex: 3,
              child: ElevatedButton.icon(
                onPressed: onAddToJourney,
                icon: CustomIconWidget(
                  iconName: isAddedToJourney
                      ? 'check_circle'
                      : 'add_circle_outline',
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  isAddedToJourney ? t.map.addedToJourney : t.map.addToJourney,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isAddedToJourney
                      ? AppTheme.successGreen
                      : AppTheme.accentPink,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
