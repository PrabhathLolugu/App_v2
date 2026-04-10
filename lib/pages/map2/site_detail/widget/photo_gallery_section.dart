import 'package:flutter/material.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/pages/map2/app_theme.dart';
import 'package:myitihas/pages/map2/widgets/custom_icon_widget.dart';
import 'package:myitihas/pages/map2/widgets/custom_image_widget.dart';
import 'package:sizer/sizer.dart';

/// Horizontal scrollable photo gallery with lightbox
class PhotoGallerySection extends StatelessWidget {
  final List<Map<String, String>> photos;
  final VoidCallback onViewAll;

  const PhotoGallerySection({
    super.key,
    required this.photos,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.map.photoGallery,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: onViewAll,
                  child: Text(
                    t.map.viewAll,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.navigationOrange,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 1.h),
          SizedBox(
            height: 20.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: photos.length,
              itemBuilder: (context, index) {
                final photo = photos[index];
                return GestureDetector(
                  onTap: () => _showLightbox(context, photo),
                  onLongPress: () => _saveToGallery(context, photo),
                  child: Container(
                    width: 35.w,
                    margin: EdgeInsets.only(right: 3.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.dividerColor, width: 1.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CustomImageWidget(
                        imageUrl: photo['url'] ?? '',
                        width: 35.w,
                        height: 20.h,
                        fit: BoxFit.cover,
                        useSacredPlaceholder: true,
                        sacredPlaceholderSeed:
                            '${photo['semanticLabel'] ?? 'gallery'}-$index',
                        semanticLabel:
                            photo['semanticLabel'] ?? 'Gallery photo',
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showLightbox(BuildContext context, Map<String, String> photo) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Center(
              child: CustomImageWidget(
                imageUrl: photo['url'] ?? '',
                width: 90.w,
                height: 70.h,
                fit: BoxFit.contain,
                useSacredPlaceholder: true,
                sacredPlaceholderSeed: photo['semanticLabel'] ?? photo['url'],
                semanticLabel: photo['semanticLabel'] ?? 'Gallery photo',
              ),
            ),
            Positioned(
              top: 2.h,
              right: 2.w,
              child: IconButton(
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveToGallery(BuildContext context, Map<String, String> photo) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.map.photoSavedToGallery),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
