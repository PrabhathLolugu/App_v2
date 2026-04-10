import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/pages/map2/Model/sacred_location.dart';
import 'package:myitihas/pages/map2/widgets/custom_image_widget.dart';
import 'package:shimmer/shimmer.dart';

/// Section displaying "Where to Visit" - sacred locations with image cards
class WhereToVisitSection extends StatelessWidget {
  final List<SacredLocation> locations;
  final bool isLoading;
  final void Function(SacredLocation location)? onLocationTap;
  final VoidCallback? onViewAll;

  const WhereToVisitSection({
    super.key,
    required this.locations,
    this.isLoading = false,
    this.onLocationTap,
    this.onViewAll,
  });

  static const int _initialVisibleCount = 6;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final t = Translations.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isTabletUp = screenWidth >= 600;
    final sectionHeight = isTabletUp ? 260.0 : 230.h;
    final sectionHorizontalPadding = isTabletUp ? 24.0 : 20.w;
    final cardSpacing = isTabletUp ? 14.0 : 12.w;
    final cardWidth = isTabletUp ? 240.0 : 180.w;
    final cardImageHeight = isTabletUp ? 120.0 : 100.h;

    if (isLoading) {
      return _buildShimmer(context, isDark);
    }

    if (locations.isEmpty) {
      return const SizedBox.shrink();
    }

    final displayLocations = locations.take(_initialVisibleCount).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF38ef7d,
                            ).withValues(alpha: 0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.mapLocationDot,
                        size: 15.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        t.homeScreen.whereToVisit,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              if (locations.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onViewAll?.call();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      t.homeScreen.seeAll,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: sectionHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: sectionHorizontalPadding),
            itemCount: displayLocations.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: cardSpacing),
                child: _LocationCard(
                  location: displayLocations[index],
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onLocationTap?.call(displayLocations[index]);
                  },
                  isDark: isDark,
                  cardWidth: cardWidth,
                  imageHeight: cardImageHeight,
                  isTabletUp: isTabletUp,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildShimmer(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isTabletUp = screenWidth >= 600;
    final sectionHeight = isTabletUp ? 260.0 : 230.h;
    final sectionHorizontalPadding = isTabletUp ? 24.0 : 20.w;
    final cardSpacing = isTabletUp ? 14.0 : 12.w;
    final shimmerCardWidth = isTabletUp ? 220.0 : 160.w;
    final baseColor = isDark
        ? colorScheme.surfaceContainerHigh
        : colorScheme.surfaceContainerLow;
    final highlightColor = isDark
        ? colorScheme.surfaceContainerLow
        : colorScheme.surfaceContainerHighest;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              width: 200.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: sectionHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: sectionHorizontalPadding),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: cardSpacing),
                child: Shimmer.fromColors(
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  child: Container(
                    width: shimmerCardWidth,
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _LocationCard extends StatelessWidget {
  final SacredLocation location;
  final VoidCallback onTap;
  final bool isDark;
  final double cardWidth;
  final double imageHeight;
  final bool isTabletUp;

  const _LocationCard({
    required this.location,
    required this.onTap,
    required this.isDark,
    required this.cardWidth,
    required this.imageHeight,
    required this.isTabletUp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        clipBehavior: Clip.antiAlias,
        child: Container(
          width: cardWidth,
          decoration: BoxDecoration(
            color: isDark
                ? colorScheme.surfaceContainerHigh
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                child: CustomImageWidget(
                  imageUrl: location.image,
                  width: double.infinity,
                  height: imageHeight,
                  fit: BoxFit.cover,
                  semanticLabel: location.name,
                ),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.all(isTabletUp ? 12.0 : 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        location.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: isTabletUp ? 6 : 4.h),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              location.ref ?? 'Ancient Text Source',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (location.type != null &&
                              location.type!.isNotEmpty)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isTabletUp ? 8.0 : 6.w,
                                vertical: isTabletUp ? 3.0 : 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.2,
                                ),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                location.type!,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: isTabletUp ? 6 : 4.h),
                      Flexible(
                        child: Text(
                          location.description ??
                              'Explore the history and spiritual significance of this sacred site.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
