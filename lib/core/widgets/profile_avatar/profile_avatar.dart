import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/core/cache/managers/image_cache_manager.dart';
import 'package:myitihas/core/widgets/image_loading_placeholder/image_loading_placeholder.dart';

/// Reusable profile avatar with CachedNetworkImage.
/// - Shows image when avatarUrl is set (from Google, user upload, or group)
/// - Shows person icon when no image (users)
/// - Shows group icon when no image (groups)
/// Uniform throughout the app.
class ProfileAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String displayName;
  final double radius;
  final String? userId;
  final Color? backgroundColor;
  final bool isGroup;

  const ProfileAvatar({
    super.key,
    this.avatarUrl,
    required this.displayName,
    this.radius = 24,
    this.userId,
    this.backgroundColor,
    this.isGroup = false,
  });

  bool get _hasRealAvatar =>
      avatarUrl != null && avatarUrl!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ??
        theme.colorScheme.primaryContainer.withValues(alpha: 0.3);

    Widget avatar = ClipOval(
      child: _hasRealAvatar
          ? CachedNetworkImage(
              imageUrl: avatarUrl!,
              cacheManager: ImageCacheManager.instance,
              memCacheWidth: 200,
              memCacheHeight: 200,
              width: radius * 2,
              height: radius * 2,
              fit: BoxFit.cover,
              placeholder: (context, url) => ImageLoadingPlaceholder(
                width: radius * 2,
                height: radius * 2,
                borderRadius: BorderRadius.circular(radius),
              ),
              errorWidget: (context, url, error) => _buildProfileIconPlaceholder(context, bgColor),
            )
          : _buildProfileIconPlaceholder(context, bgColor),
    );

    final normalizedUserId = userId?.trim();
    if (normalizedUserId != null && normalizedUserId.isNotEmpty) {
      return GestureDetector(
        onTap: () => ProfileRoute(userId: normalizedUserId).push(context),
        child: avatar,
        behavior: HitTestBehavior.opaque,
      );
    }

    return avatar;
  }

  static const _kProfilePlaceholderGradients = [
    [Color(0xFF7F53AC), Color(0xFF647DEE)], // Purple → Indigo
    [Color(0xFFf7971e), Color(0xFFffd200)], // Amber → Gold
    [Color(0xFF11998e), Color(0xFF38ef7d)], // Teal → Mint
    [Color(0xFFc94b4b), Color(0xFF4b134f)], // Crimson → Plum
    [Color(0xFF1a1a2e), Color(0xFF16213e)], // Deep Navy
    [Color(0xFF0f3443), Color(0xFF34e89e)], // Dark Teal → Emerald
  ];

  List<Color> get _gradientColors {
    final key = (userId != null && userId!.isNotEmpty) 
        ? userId! 
        : (displayName.isNotEmpty ? displayName : 'default_avatar');
    final hash = key.hashCode.abs();
    return _kProfilePlaceholderGradients[hash % _kProfilePlaceholderGradients.length];
  }

  Widget _buildProfileIconPlaceholder(BuildContext context, Color bgColor) {
    final useGradient = backgroundColor == null;
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: useGradient ? null : bgColor,
        gradient: useGradient
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _gradientColors,
              )
            : null,
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          isGroup ? Icons.people_rounded : Icons.person_rounded,
          size: radius * 1.0,
          color: useGradient
              ? Colors.white.withValues(alpha: 0.8)
              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
