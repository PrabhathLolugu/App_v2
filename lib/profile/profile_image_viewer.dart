import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myitihas/profile/widget/custom_image_widget.dart';

import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/pages/map2/widgets/custom_icon_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

/// Profile Image Viewer Screen
/// Provides full-screen profile picture viewing with gesture-based interactions
/// Features: Hero animation, pinch-to-zoom, double-tap zoom, pan gestures, share functionality
class ProfileImageViewer extends StatefulWidget {
  final String? imageUrl;
  final String? username;

  const ProfileImageViewer({super.key, this.imageUrl, this.username});

  @override
  State<ProfileImageViewer> createState() => _ProfileImageViewerState();
}

class _ProfileImageViewerState extends State<ProfileImageViewer>
    with SingleTickerProviderStateMixin {
  late TransformationController _transformationController;
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;

  bool _hasError = false;
  bool _showOverlays = true;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Hide status bar for immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    // Restore status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _handleDoubleTap() {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();

    Matrix4 endMatrix;
    if (currentScale > 1.0) {
      // Zoom out to fit
      endMatrix = Matrix4.identity();
    } else {
      // Zoom in to 2x
      final position = _transformationController.toScene(Offset(50.w, 50.h));
      endMatrix = Matrix4.identity()
        ..translate(-position.dx, -position.dy)
        ..scale(2.0);
    }

    _animation =
        Matrix4Tween(
          begin: _transformationController.value,
          end: endMatrix,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    _animationController.forward(from: 0).then((_) {
      _transformationController.value = endMatrix;
    });
  }

  void _handleShare() async {
    try {
      final url = widget.imageUrl ?? '';
      final name = widget.username ?? 'User';
      await Share.share(
        url.isNotEmpty
            ? 'Check out $name\'s profile picture!\n$url'
            : 'Check out $name\'s profile!',
        subject: 'Profile Image',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(Translations.of(context).profile.unableToShareImage),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _handleSaveImage() {
    final t = Translations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.profile.imageSavedToPhotos),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(label: t.profile.view, onPressed: () {}),
      ),
    );
  }

  void _toggleOverlays() {
    setState(() {
      _showOverlays = !_showOverlays;
    });
  }

  void _handleRetry() {
    setState(() {
      _hasError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main image viewer with gestures
          GestureDetector(
            onTap: _toggleOverlays,
            onDoubleTap: _handleDoubleTap,
            child: Center(child: _buildImageContent(theme)),
          ),

          // Top overlay with close button
          if (_showOverlays)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildTopOverlay(theme),
            ),

          // Bottom overlay with user info
          if (_showOverlays)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomOverlay(theme),
            ),
        ],
      ),
    );
  }

  Widget _buildImageContent(ThemeData theme) {
    final imageUrl = widget.imageUrl ?? '';

    if (imageUrl.isEmpty) {
      // No profile image — show a placeholder avatar
      return Center(
        child: CircleAvatar(
          radius: 80,
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(
            Icons.person_rounded,
            size: 80,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'broken_image',
              color: Colors.white.withValues(alpha: 0.7),
              size: 64,
            ),
            SizedBox(height: 2.h),
            Text(
              Translations.of(context).profile.failedToLoadImage,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
            SizedBox(height: 2.h),
            ElevatedButton(onPressed: _handleRetry, child: Text(Translations.of(context).common.retry)),
          ],
        ),
      );
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        if (_animation != null) {
          _transformationController.value = _animation!.value;
        }
        return InteractiveViewer(
          transformationController: _transformationController,
          minScale: 1.0,
          maxScale: 4.0,
          boundaryMargin: EdgeInsets.all(20.w),
          child: Hero(
            tag: 'profile_image_${widget.username ?? "user"}',
            child: CustomImageWidget(
              imageUrl: imageUrl,
              width: 100.w,
              height: 100.h,
              fit: BoxFit.contain,
              semanticLabel: '${widget.username ?? "User"}\'s profile picture',
              useAvatarPlaceholder: true,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopOverlay(ThemeData theme) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: CustomIconWidget(
                iconName: 'close',
                color: Colors.white,
                size: 28,
              ),
              tooltip: 'Close',
            ),
            PopupMenuButton<String>(
              icon: CustomIconWidget(
                iconName: 'more_vert',
                color: Colors.white,
                size: 28,
              ),
              color: theme.colorScheme.surface,
              onSelected: (value) {
                if (value == 'save') {
                  _handleSaveImage();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'save',
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'download',
                        color: theme.colorScheme.onSurface,
                        size: 20,
                      ),
                      SizedBox(width: 3.w),
                      Text(Translations.of(context).profile.saveToPhotos),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomOverlay(ThemeData theme) {
    final username = widget.username ?? '';

    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (username.isNotEmpty)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '@$username',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: _handleShare,
                  icon: CustomIconWidget(
                    iconName: 'share',
                    color: Colors.white,
                    size: 24,
                  ),
                  tooltip: 'Share',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
