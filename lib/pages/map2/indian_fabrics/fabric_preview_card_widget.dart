import 'package:flutter/material.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/pages/map2/indian_fabrics/fabric_hub.dart';
import 'package:myitihas/pages/map2/widgets/custom_icon_widget.dart';
import 'package:myitihas/pages/map2/widgets/custom_image_widget.dart';
import 'package:sizer/sizer.dart';

/// Bottom sheet preview for a fabric hub (mirrors sacred [LocationPreviewCardWidget]
/// layout without favorites / visited).
class FabricPreviewCardWidget extends StatelessWidget {
  const FabricPreviewCardWidget({
    super.key,
    required this.hub,
    required this.onClose,
    required this.onDetails,
    required this.onDiscussion,
  });

  final FabricHub hub;
  final VoidCallback onClose;
  final VoidCallback onDetails;
  final VoidCallback onDiscussion;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final t = Translations.of(context);

    return Container(
      constraints: BoxConstraints(maxHeight: 40.h, maxWidth: 90.w),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? Colors.black.withValues(alpha: 0.85)
            : Colors.white,
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
                  imageUrl: hub.imageUrl,
                  width: double.infinity,
                  height: 11.h,
                  fit: BoxFit.cover,
                  useSacredPlaceholder: true,
                  sacredPlaceholderSeed: '${hub.id}-${hub.name}',
                  semanticLabel: hub.name,
                ),
              ),
              Positioned(
                top: 2.w,
                right: 2.w,
                child: _circleButton(
                  onPressed: onClose,
                  iconName: 'close',
                  iconColor: Colors.white,
                ),
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
                    hub.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.4.h),
                  Text(
                    hub.fabricName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.55.h),
                  Text(
                    hub.shortDescription,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.55.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 0.45.h,
                    children: [
                      _metaChip(context, icon: Icons.public, label: hub.region),
                      if ((hub.state ?? '').isNotEmpty)
                        _metaChip(
                          context,
                          icon: Icons.location_city_outlined,
                          label: hub.state!,
                        ),
                      _metaChip(
                        context,
                        icon: Icons.palette_outlined,
                        label: t.map.fabricMap.fabricLabel,
                      ),
                      if (hub.governmentSellers.isNotEmpty)
                        _metaChip(
                          context,
                          icon: Icons.verified_outlined,
                          label: '${hub.governmentSellers.length} sellers',
                        ),
                    ],
                  ),
                  SizedBox(height: 0.8.h),
                  Row(
                    children: [
                      Expanded(
                        child: _actionButton(
                          context,
                          t.map.viewDetails,
                          onDetails,
                          Icon(
                            Icons.open_in_new,
                            color: Colors.white,
                            size: 16.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 2.2.w),
                      Expanded(
                        child: _actionButton(
                          context,
                          t.map.discussionTab,
                          onDiscussion,
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

  Widget _circleButton({
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

  Widget _actionButton(
    BuildContext context,
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
          colors: [Color(0xFF44009F), Color(0xFF0088FF)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 8,
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
