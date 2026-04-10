import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myitihas/core/cache/managers/image_cache_manager.dart';
import 'package:myitihas/core/widgets/image_loading_placeholder/image_loading_placeholder.dart';

/// Embedded preview for a repost: original media/caption with a short-lived
/// “original author” chip that floats on top (no permanent layout slot).
class RepostedContentCard extends StatefulWidget {
  final String? authorName;
  final String? authorUsername;
  final String? authorAvatarUrl;
  final String? postType;
  final String? mediaUrl;
  final String? thumbnailUrl;
  final String? caption;
  final bool darkOverlay;
  final VoidCallback? onTap;

  const RepostedContentCard({
    super.key,
    this.authorName,
    this.authorUsername,
    this.authorAvatarUrl,
    this.postType,
    this.mediaUrl,
    this.thumbnailUrl,
    this.caption,
    this.darkOverlay = false,
    this.onTap,
  });

  @override
  State<RepostedContentCard> createState() => _RepostedContentCardState();
}

class _RepostedContentCardState extends State<RepostedContentCard> {
  static const _overlayDuration = Duration(seconds: 3);
  static const _fadeDuration = Duration(milliseconds: 280);

  Timer? _hideTimer;
  bool _overlayVisible = true;
  bool _overlayInTree = true;

  @override
  void initState() {
    super.initState();
    _hideTimer = Timer(_overlayDuration, () {
      if (mounted) setState(() => _overlayVisible = false);
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  bool get _hasVisual {
    final visual = _effectiveVisualUrl;
    return visual != null && visual.isNotEmpty;
  }

  String? get _effectiveVisualUrl {
    final normalizedType = widget.postType?.toLowerCase();
    if (normalizedType == 'video') {
      return widget.thumbnailUrl ?? widget.mediaUrl;
    }
    return widget.mediaUrl ?? widget.thumbnailUrl;
  }

  void _onOverlayFadeEnd() {
    if (!_overlayVisible && mounted) {
      setState(() => _overlayInTree = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardColor = widget.darkOverlay
        ? Colors.white.withValues(alpha: 0.1)
        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.55);
    final borderColor = widget.darkOverlay
        ? Colors.white.withValues(alpha: 0.28)
        : colorScheme.outlineVariant;
    final titleColor = widget.darkOverlay ? Colors.white : colorScheme.onSurface;
    final subtitleColor = widget.darkOverlay
        ? Colors.white70
        : colorScheme.onSurfaceVariant;

    final captionText = widget.caption?.trim();
    final hasCaption = captionText != null && captionText.isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_hasVisual)
                _buildVisualSection(theme, colorScheme, subtitleColor),
              if (!_hasVisual && hasCaption)
                _buildTextOnlySection(
                  theme,
                  titleColor,
                  subtitleColor,
                  captionText,
                ),
              if (_hasVisual && hasCaption)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    captionText,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: titleColor,
                      height: 1.3,
                    ),
                  ),
                ),
              if (!_hasVisual && !hasCaption && _overlayInTree)
                AnimatedOpacity(
                  opacity: _overlayVisible ? 1 : 0,
                  duration: _fadeDuration,
                  onEnd: _onOverlayFadeEnd,
                  child: _OriginalAuthorPopup(
                    theme: theme,
                    authorName: widget.authorName,
                    authorUsername: widget.authorUsername,
                    authorAvatarUrl: widget.authorAvatarUrl,
                    darkOverlay: widget.darkOverlay,
                    subtitleColor: subtitleColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVisualSection(
    ThemeData theme,
    ColorScheme colorScheme,
    Color subtitleColor,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          CachedNetworkImage(
            imageUrl: _effectiveVisualUrl!,
            cacheManager: ImageCacheManager.instance,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 160,
            placeholder: (context, _) => const ImageLoadingPlaceholder(
              height: 160,
              width: double.infinity,
            ),
            errorWidget: (context, _, __) => Container(
              height: 160,
              width: double.infinity,
              color: widget.darkOverlay
                  ? Colors.white.withValues(alpha: 0.12)
                  : colorScheme.surfaceContainerHigh,
              child: Icon(
                Icons.broken_image_outlined,
                color: subtitleColor,
              ),
            ),
          ),
          if (widget.postType?.toLowerCase() == 'video')
            Positioned.fill(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          if (_overlayInTree)
            Positioned(
              left: 6,
              right: 6,
              top: 6,
              child: AnimatedOpacity(
                opacity: _overlayVisible ? 1 : 0,
                duration: _fadeDuration,
                onEnd: _onOverlayFadeEnd,
                child: _OriginalAuthorPopup(
                  theme: theme,
                  authorName: widget.authorName,
                  authorUsername: widget.authorUsername,
                  authorAvatarUrl: widget.authorAvatarUrl,
                  darkOverlay: widget.darkOverlay,
                  subtitleColor: subtitleColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextOnlySection(
    ThemeData theme,
    Color titleColor,
    Color subtitleColor,
    String captionText,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedPadding(
          duration: _fadeDuration,
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.only(
            top: _overlayVisible ? 38 : 0,
          ),
          child: Text(
            captionText,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: titleColor,
              height: 1.3,
            ),
          ),
        ),
        if (_overlayInTree)
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: AnimatedOpacity(
              opacity: _overlayVisible ? 1 : 0,
              duration: _fadeDuration,
              onEnd: _onOverlayFadeEnd,
              child: _OriginalAuthorPopup(
                theme: theme,
                authorName: widget.authorName,
                authorUsername: widget.authorUsername,
                authorAvatarUrl: widget.authorAvatarUrl,
                darkOverlay: widget.darkOverlay,
                subtitleColor: subtitleColor,
              ),
            ),
          ),
      ],
    );
  }
}

class _OriginalAuthorPopup extends StatelessWidget {
  const _OriginalAuthorPopup({
    required this.theme,
    required this.authorName,
    required this.authorUsername,
    required this.authorAvatarUrl,
    required this.darkOverlay,
    required this.subtitleColor,
  });

  final ThemeData theme;
  final String? authorName;
  final String? authorUsername;
  final String? authorAvatarUrl;
  final bool darkOverlay;
  final Color subtitleColor;

  @override
  Widget build(BuildContext context) {
    final bg = darkOverlay
        ? Colors.black.withValues(alpha: 0.55)
        : theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.92);
    final border = darkOverlay
        ? Colors.white.withValues(alpha: 0.22)
        : theme.colorScheme.outlineVariant;

    return Material(
      color: Colors.transparent,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: darkOverlay ? 0.35 : 0.12),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: darkOverlay
                    ? Colors.white.withValues(alpha: 0.2)
                    : theme.colorScheme.surfaceContainerHigh,
                backgroundImage:
                    (authorAvatarUrl != null && authorAvatarUrl!.isNotEmpty)
                    ? CachedNetworkImageProvider(authorAvatarUrl!)
                    : null,
                child: (authorAvatarUrl == null || authorAvatarUrl!.isEmpty)
                    ? Icon(
                        Icons.person_outline,
                        size: 14,
                        color: subtitleColor,
                      )
                    : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _authorLabel(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: subtitleColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.repeat_rounded, size: 16, color: subtitleColor),
            ],
          ),
        ),
      ),
    );
  }

  String _authorLabel() {
    final safeName = authorName?.trim().isNotEmpty == true
        ? authorName!.trim()
        : 'Original author';
    final safeUsername = authorUsername?.trim().isNotEmpty == true
        ? authorUsername!.trim()
        : null;
    if (safeUsername == null) {
      return safeName;
    }
    return '$safeName · @$safeUsername';
  }
}
