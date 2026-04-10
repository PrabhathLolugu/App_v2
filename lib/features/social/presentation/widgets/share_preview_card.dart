import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myitihas/core/widgets/image_loading_placeholder/image_loading_placeholder.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/core/cache/managers/image_cache_manager.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import 'package:myitihas/i18n/strings.g.dart';

class SharePreviewCard extends StatelessWidget {
  final Story story;
  final SharePreviewFormat format;
  final GlobalKey? repaintKey;

  const SharePreviewCard({
    super.key,
    required this.story,
    this.format = SharePreviewFormat.openGraph,
    this.repaintKey,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradients = theme.extension<GradientExtension>();
    final colorScheme = theme.colorScheme;

    final size = format.size;

    return RepaintBoundary(
      key: repaintKey,
      child: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            if (story.imageUrl != null && story.imageUrl!.isNotEmpty)
              CachedNetworkImage(
                imageUrl: story.imageUrl!,
                cacheManager: ImageCacheManager.instance,
                memCacheWidth: 1200,
                memCacheHeight: 1200,
                fit: BoxFit.cover,
                color: Colors.black.withValues(alpha: 0.5),
                colorBlendMode: BlendMode.darken,
                placeholder: (context, url) => const ImageLoadingPlaceholder(),
                errorWidget: (context, url, error) =>
                    Container(color: colorScheme.surfaceContainerHighest),
              )
            else
              Container(
                decoration: BoxDecoration(
                  gradient:
                      gradients?.heroBackgroundGradient ??
                      LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorScheme.primary.withValues(alpha: 0.8),
                          colorScheme.secondary.withValues(alpha: 0.8),
                        ],
                      ),
                ),
              ),

            // Dark overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(
                format == SharePreviewFormat.story ? 48 : 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        width: format == SharePreviewFormat.story ? 48 : 36,
                        height: format == SharePreviewFormat.story ? 48 : 36,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        t.app.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: format == SharePreviewFormat.story
                              ? 28
                              : 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      story.scripture,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: format == SharePreviewFormat.story ? 16 : 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: format == SharePreviewFormat.story ? 16 : 12,
                  ),

                  Text(
                    story.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: format == SharePreviewFormat.story ? 42 : 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: format == SharePreviewFormat.story ? 4 : 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: format == SharePreviewFormat.story ? 24 : 16,
                  ),

                  if (story.quotes.isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(
                        format == SharePreviewFormat.story ? 20 : 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border(
                          left: BorderSide(
                            color: Colors.white.withValues(alpha: 0.8),
                            width: 3,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '"',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: format == SharePreviewFormat.story
                                  ? 36
                                  : 28,
                              fontWeight: FontWeight.bold,
                              height: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            story.quotes,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.95),
                              fontSize: format == SharePreviewFormat.story
                                  ? 20
                                  : 16,
                              fontStyle: FontStyle.italic,
                              height: 1.4,
                            ),
                            maxLines: format == SharePreviewFormat.story
                                ? 5
                                : 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                  const Spacer(),

                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: format == SharePreviewFormat.story ? 24 : 20,
                      vertical: format == SharePreviewFormat.story ? 14 : 10,
                    ),
                    decoration: BoxDecoration(
                      gradient:
                          gradients?.primaryButtonGradient ??
                          const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF44009F),
                              Color(0xFF0088FF),
                            ],
                          ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      t.common.readFullStory,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: format == SharePreviewFormat.story ? 18 : 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum SharePreviewFormat { openGraph, story }

extension SharePreviewFormatExtension on SharePreviewFormat {
  Size get size {
    switch (this) {
      case SharePreviewFormat.openGraph:
        return const Size(1200, 630);
      case SharePreviewFormat.story:
        return const Size(1080, 1920);
    }
  }

  double get aspectRatio {
    final s = size;
    return s.width / s.height;
  }
}
