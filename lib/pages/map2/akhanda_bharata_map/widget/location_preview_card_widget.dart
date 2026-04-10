import 'package:flutter/material.dart';
import 'package:myitihas/pages/map2/Model/sacred_location.dart';
import 'package:myitihas/pages/map2/app_theme.dart';
import 'package:myitihas/pages/map2/widgets/custom_icon_widget.dart';
import 'package:myitihas/pages/map2/widgets/custom_image_widget.dart';
import 'package:sizer/sizer.dart';

class LocationPreviewCardWidget extends StatelessWidget {
  final SacredLocation location; // Changed from Map to SacredLocation
  final bool isVisited; // Pass these explicitly from BLoC state
  final bool isFavorite; // Pass these explicitly from BLoC state
  final VoidCallback onClose;
  final VoidCallback onNavigate;
  final VoidCallback onNavigate_chat;
  final VoidCallback onToggleFavorite;

  const LocationPreviewCardWidget({
    super.key,
    required this.location,
    required this.isVisited,
    required this.isFavorite,
    required this.onClose,
    required this.onNavigate,
    required this.onNavigate_chat,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      constraints: BoxConstraints(
        maxHeight: 40.h,
        maxWidth: 90.w,
      ),
      decoration: BoxDecoration(
        color: isDark ? Colors.black.withOpacity(0.85) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.55),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
                child: CustomImageWidget(
                  imageUrl: location.image,
                  width: double.infinity,
                  height: 11.h,
                  fit: BoxFit.cover,
                  useSacredPlaceholder: true,
                  sacredPlaceholderSeed: '${location.id}-${location.name}',
                  semanticLabel: location.name,
                ),
              ),
              Positioned(
                top: 2.w,
                right: 2.w,
                child: Row(
                  children: [
                    _buildCircleActionButton(
                      onPressed: onToggleFavorite,
                      iconName: isFavorite ? 'favorite' : 'favorite_border',
                      iconColor: isFavorite
                          ? AppTheme.accentPink
                          : AppTheme.containerWhite,
                    ),
                    SizedBox(width: 2.w),
                    _buildCircleActionButton(
                      onPressed: onClose,
                      iconName: 'close',
                      iconColor: AppTheme.containerWhite,
                    ),
                  ],
                ),
              ),
              if (isVisited)
                Positioned(
                  top: 2.w,
                  left: 2.w,
                  child: _buildVisitedBadge(theme),
                ),
            ],
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(3.5.w, 3.w, 3.5.w, 3.2.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.4.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          location.ref ?? "Ancient Text Source",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (location.type != null)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: 0.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.10,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            location.type!,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 0.55.h),
                  Text(
                    location.description ??
                        "Explore the history and spiritual significance of this sacred site.",
                    style: theme.textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.55.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 0.45.h,
                    children: [
                      if (location.region != null)
                        _metaChip(
                          context,
                          icon: Icons.public,
                          label: location.region!,
                        ),
                      if (location.tradition != null)
                        _metaChip(
                          context,
                          icon: Icons.auto_stories_outlined,
                          label: location.tradition!,
                        ),
                    ],
                  ),
                  SizedBox(height: 0.8.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDetailsButton(
                          context,
                          isDark,
                          'View Details',
                          onNavigate,
                          Icon(
                            Icons.open_in_new,
                            color: Colors.white,
                            size: 16.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 2.2.w),
                      Expanded(
                        child: _buildDetailsButton(
                          context,
                          isDark,
                          "Discussion",
                          onNavigate_chat,
                          Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.white,
                            size: 16.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper UI Builders ---

  Widget _buildCircleActionButton({
    required VoidCallback onPressed,
    required String iconName,
    required Color iconColor,
  }) {
    return Container(
      height: 27.sp,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: CustomIconWidget(
          iconName: iconName,
          color: iconColor,
          size: 18.sp,
        ),
        padding: EdgeInsets.all(2.w),
      ),
    );
  }

  Widget _buildVisitedBadge(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: AppTheme.successGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomIconWidget(
            iconName: 'check_circle',
            color: AppTheme.containerWhite,
            size: 16,
          ),
          SizedBox(width: 1.w),
          Text(
            'Visited',
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppTheme.containerWhite,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsButton(
    BuildContext context,
    bool isDark,
    String txt,
    VoidCallback onPressed,
    Widget icon,
  ) {
    return Container(
      height: 5.5.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF505050),
            Color(0xFF121212),
          ],
        ),
        border: Border.all(
          color: Colors.white24,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(horizontal: 2.2.w, vertical: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        icon: icon,
        label: Text(
          txt,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }

  Widget _metaChip(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.4.w, vertical: 0.6.h),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colorScheme.primary),
          SizedBox(width: 1.w),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
