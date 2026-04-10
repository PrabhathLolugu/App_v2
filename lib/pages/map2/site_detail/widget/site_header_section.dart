import 'package:flutter/material.dart';
import 'package:myitihas/pages/map2/widgets/custom_icon_widget.dart';
import 'package:sizer/sizer.dart';

/// Site header with name and location
class SiteHeaderSection extends StatelessWidget {
  final String siteName;
  final String location;

  const SiteHeaderSection({
    super.key,
    required this.siteName,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(left: 4.w, right: 4.w, top: 2.h, bottom: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isDark ? const Color(0xFF1A1A1A) : const Color(0xFFFFFFFF),
            isDark ? const Color(0xFF111111) : const Color(0xFFF2F2F2),
          ],
        ),
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.16),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.26 : 0.10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            siteName,
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              height: 1.25,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),

          // Location subtitle
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'location_on',
                  color: colorScheme.onSurface,
                  size: 16,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  location,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
