import 'package:flutter/material.dart';
import 'package:myitihas/pages/map2/widgets/custom_icon_widget.dart';
import 'package:myitihas/pages/map2/widgets/custom_image_widget.dart';
import 'package:sizer/sizer.dart';

/// Hero image section with parallax effect and overlay controls
class HeroImageSection extends StatelessWidget {
  final String imageUrl;
  final String semanticLabel;
  final VoidCallback onBackPressed;
  final ScrollController scrollController;
  final VoidCallback? onCreatePost;
  final VoidCallback? onShare;
  final VoidCallback? onAudioTap;
  final bool showAudioButton;
  final bool isAudioPlaying;
  final String? audioTooltip;

  const HeroImageSection({
    super.key,
    required this.imageUrl,
    required this.semanticLabel,
    required this.onBackPressed,
    required this.scrollController,
    this.onCreatePost,
    this.onShare,
    this.onAudioTap,
    this.showAudioButton = false,
    this.isAudioPlaying = false,
    this.audioTooltip,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35.h,
      child: Stack(
        children: [
          // Hero image with parallax effect
          Positioned.fill(
            child: CustomImageWidget(
              imageUrl: imageUrl,
              width: double.infinity,
              height: 35.h,
              fit: BoxFit.cover,
              useSacredPlaceholder: true,
              sacredPlaceholderSeed: semanticLabel,
              semanticLabel: semanticLabel,
            ),
          ),

          // Gradient overlay for better text visibility
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.5),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Top controls in safe area
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: CustomIconWidget(
                        iconName: 'arrow_back',
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: onBackPressed,
                      tooltip: 'Back',
                    ),
                  ),
                  Row(
                    children: [
                      if (showAudioButton && onAudioTap != null)
                        Container(
                          margin: EdgeInsets.only(right: 2.w),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: Icon(
                              isAudioPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                            onPressed: onAudioTap,
                            tooltip:
                                audioTooltip ??
                                (isAudioPlaying
                                    ? 'Pause narration'
                                    : 'Play narration'),
                          ),
                        ),
                      if (onShare != null)
                        Container(
                          margin: EdgeInsets.only(right: 2.w),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.share_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                            onPressed: onShare,
                            tooltip: 'Share',
                          ),
                        ),
                      if (onCreatePost != null)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.78),
                            border: Border.all(color: Colors.white24, width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                            onPressed: onCreatePost,
                            tooltip: 'Post about this site',
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
}
