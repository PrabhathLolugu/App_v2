import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:myitihas/profile/widget/custom_image_widget.dart';
import 'package:myitihas/pages/map2/widgets/custom_icon_widget.dart';
import 'package:myitihas/utils/constants.dart';
import 'package:sizer/sizer.dart';

class PostCardWidget extends StatefulWidget {
  final Map<String, dynamic> post;
  final VoidCallback onLike;
  final VoidCallback onSave;
  final VoidCallback onComment;
  final VoidCallback onShare;

  const PostCardWidget({
    super.key,
    required this.post,
    required this.onLike,
    required this.onSave,
    required this.onComment,
    required this.onShare,
  });

  @override
  State<PostCardWidget> createState() => _PostCardWidgetState();
}

class _PostCardWidgetState extends State<PostCardWidget>
    with SingleTickerProviderStateMixin {
  int _currentImageIndex = 0;
  bool _showHeartAnimation = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    if (!(widget.post["isLiked"] as bool)) {
      widget.onLike();
      setState(() => _showHeartAnimation = true);
      _animationController.forward().then((_) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            _animationController.reverse().then((_) {
              if (mounted) {
                setState(() => _showHeartAnimation = false);
              }
            });
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final images = widget.post["images"] as List<dynamic>;
    final hasMultipleImages = images.length > 1;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      // color: theme.scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPostHeader(theme),
          _buildPostImages(theme, images, hasMultipleImages),
          _buildPostActions(theme),
          _buildPostInfo(theme),
        ],
      ),
    );
  }

  Widget _buildPostHeader(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF00E5FF),
                  Color(0xFF2979FF),
                  Color(0xFF00B0FF),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            padding: EdgeInsets.all(0.5.w),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.scaffoldBackgroundColor,
              ),
              padding: EdgeInsets.all(0.3.w),
              child: ClipOval(
                child: CustomImageWidget(
                  imageUrl: widget.post["avatar"] as String,
                  width: 10.w,
                  height: 10.w,
                  fit: BoxFit.cover,
                  semanticLabel: widget.post["avatarSemanticLabel"] as String,
                  useAvatarPlaceholder: true,
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.post["username"] as String,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.post["timestamp"] as String,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: theme.colorScheme.primary,
              size: 24,
            ),
            padding: EdgeInsets.all(1.w),
            constraints: BoxConstraints(minWidth: 10.w, minHeight: 5.h),
          ),
        ],
      ),
    );
  }

  Widget _buildPostImages(
    ThemeData theme,
    List<dynamic> images,
    bool hasMultipleImages,
  ) {
    return GestureDetector(
      onDoubleTap: _handleDoubleTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          hasMultipleImages
              ? CarouselSlider.builder(
                  itemCount: images.length,
                  itemBuilder: (context, index, realIndex) {
                    final image = images[index] as Map<String, dynamic>;
                    return CustomImageWidget(
                      imageUrl: image["url"] as String,
                      width: 100.w,
                      height: 100.w,
                      fit: BoxFit.cover,
                      semanticLabel: image["semanticLabel"] as String,
                    );
                  },
                  options: CarouselOptions(
                    height: 100.w,
                    viewportFraction: 1.0,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      setState(() => _currentImageIndex = index);
                    },
                  ),
                )
              : CustomImageWidget(
                  imageUrl:
                      (images[0] as Map<String, dynamic>)["url"] as String,
                  width: 100.w,
                  height: 100.w,
                  fit: BoxFit.cover,
                  semanticLabel:
                      (images[0] as Map<String, dynamic>)["semanticLabel"]
                          as String,
                ),
          if (hasMultipleImages)
            Positioned(
              bottom: 2.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (index) => Container(
                    width: 1.5.w,
                    height: 1.5.w,
                    margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentImageIndex == index
                          ? theme.colorScheme.secondary
                          : Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            ),
          if (_showHeartAnimation)
            ScaleTransition(
              scale: _scaleAnimation,
              child: CustomIconWidget(
                iconName: 'favorite',
                color: Colors.white,
                size: 80,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPostActions(ThemeData theme) {
    final isLiked = widget.post["isLiked"] as bool;
    final isSaved = widget.post["isSaved"] as bool;
    final isDark = theme.brightness == Brightness.dark;
    Color textColor = isDark ? DarkColors.textPrimary : LightColors.textPrimary;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          IconButton(
            onPressed: widget.onLike,
            icon: CustomIconWidget(
              iconName: isLiked ? 'favorite' : 'favorite_outline',
              color: isLiked ? Colors.red : textColor,
              size: 28,
            ),
            padding: EdgeInsets.all(1.w),
            constraints: BoxConstraints(minWidth: 12.w, minHeight: 6.h),
          ),
          SizedBox(width: 2.w),
          IconButton(
            onPressed: widget.onComment,
            icon: CustomIconWidget(
              iconName: 'chat_bubble_outline',
              color: textColor,
              size: 26,
            ),
            padding: EdgeInsets.all(1.w),
            constraints: BoxConstraints(minWidth: 12.w, minHeight: 6.h),
          ),
          SizedBox(width: 2.w),
          IconButton(
            onPressed: widget.onShare,
            icon: CustomIconWidget(
              iconName: 'send',
              color: textColor,
              size: 26,
            ),
            padding: EdgeInsets.all(1.w),
            constraints: BoxConstraints(minWidth: 12.w, minHeight: 6.h),
          ),
          const Spacer(),
          IconButton(
            onPressed: widget.onSave,
            icon: CustomIconWidget(
              iconName: isSaved ? 'bookmark' : 'bookmark_outline',
              color: textColor,
              size: 26,
            ),
            padding: EdgeInsets.all(1.w),
            constraints: BoxConstraints(minWidth: 12.w, minHeight: 6.h),
          ),
        ],
      ),
    );
  }

  Widget _buildPostInfo(ThemeData theme) {
    final likes = widget.post["likes"] as int;
    final caption = widget.post["caption"] as String;
    final commentCount = widget.post["commentCount"] as int;
    final username = widget.post["username"] as String;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${likes.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} likes',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 0.5.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$username ',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
                TextSpan(
                  text: caption,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (commentCount > 0) ...[
            SizedBox(height: 0.5.h),
            GestureDetector(
              onTap: widget.onComment,
              child: Text(
                'View all $commentCount comments',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
          SizedBox(height: 1.h),
        ],
      ),
    );
  }
}
