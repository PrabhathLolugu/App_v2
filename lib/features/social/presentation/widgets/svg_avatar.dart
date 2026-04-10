import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:myitihas/core/cache/managers/image_cache_manager.dart';
import 'package:myitihas/core/widgets/image_loading_placeholder/image_loading_placeholder.dart';
import 'package:sizer/sizer.dart';

class SvgAvatar extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final String? fallbackText;

  const SvgAvatar({
    super.key,
    required this.imageUrl,
    this.radius = 20,
    this.fallbackText,
  });

  @override
  Widget build(BuildContext context) {
    final borderThickness = 0.5.w;
    final avatarDiameter = radius * 2;
    final totalDiameter = avatarDiameter + (borderThickness * 2);

    // If no URL, show fallback avatar
    if (imageUrl.isEmpty) {
      return _buildFallbackAvatar(context, borderThickness, totalDiameter);
    }

    // Show image from URL with caching
    return SizedBox(
      width: totalDiameter,
      height: totalDiameter,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF00E5FF), Color(0xFF2979FF), Color(0xFF00B0FF)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        padding: EdgeInsets.all(borderThickness),
        child: ClipOval(
          child: SizedBox(
            width: avatarDiameter,
            height: avatarDiameter,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              cacheManager: ImageCacheManager.instance,
              memCacheWidth: 200,
              memCacheHeight: 200,
              fit: BoxFit.cover,
              placeholder: (context, url) => ImageLoadingPlaceholder(
                width: avatarDiameter,
                height: avatarDiameter,
                borderRadius: BorderRadius.circular(radius),
              ),
              errorWidget: (context, url, error) =>
                  _buildFallbackAvatar(context, borderThickness, totalDiameter),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackAvatar(
    BuildContext context,
    double borderThickness,
    double totalDiameter,
  ) {
    return SizedBox(
      width: totalDiameter,
      height: totalDiameter,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF00E5FF), Color(0xFF2979FF), Color(0xFF00B0FF)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        padding: EdgeInsets.all(borderThickness),
        child: CircleAvatar(
          radius: radius,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(Icons.person_rounded, size: radius),
        ),
      ),
    );
  }
}
