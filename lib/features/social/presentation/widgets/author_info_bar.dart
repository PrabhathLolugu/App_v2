import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/core/widgets/profile_avatar/profile_avatar.dart';
import 'package:myitihas/features/social/domain/entities/user.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/utils/constants.dart';
import 'package:timeago/timeago.dart' as timeago;

class AuthorInfoBar extends StatelessWidget {
  final User author;
  final DateTime? createdAt;
  final String? postTitle;
  final VoidCallback? onProfileTap;
  final VoidCallback? onFollowTap;
  final VoidCallback? onMoreTap;
  final bool isFollowLoading;
  final bool showFollowButton;
  final bool showFollowBackLabel;
  final bool compact;
  final bool darkOverlay;

  const AuthorInfoBar({
    super.key,
    required this.author,
    this.createdAt,
    this.postTitle,
    this.onProfileTap,
    this.onFollowTap,
    this.onMoreTap,
    this.isFollowLoading = false,
    this.showFollowButton = true,
    this.showFollowBackLabel = false,
    this.compact = false,
    this.darkOverlay = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradients = theme.extension<GradientExtension>();
    final colorScheme = theme.colorScheme;

    return Semantics(
      label:
          '${author.displayName}, @${author.username}, ${_formatFollowerCount(author.followerCount)} ${t.profile.followers}',
      button: onProfileTap != null,
      child: InkWell(
        onTap: onProfileTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: compact ? 4 : 8,
            horizontal: 4,
          ),
          child: Row(
            children: [
              Semantics(
                image: true,
                label: '${author.displayName} profile picture',
                child: ProfileAvatar(
                  avatarUrl: author.avatarUrl,
                  displayName: author.displayName,
                  radius: compact ? 16 : 20,
                  userId: author.id,
                ),
              ),
              SizedBox(width: compact ? 8 : 12),
              // Name and username
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            author.displayName,
                            style:
                                (compact
                                        ? theme.textTheme.labelLarge
                                        : theme.textTheme.titleSmall)
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: darkOverlay
                                          ? Colors.white
                                          : colorScheme.onSurface,
                                    ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!compact) ...[
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '@${author.username}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: darkOverlay
                                    ? Colors.white70
                                    : colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (!compact) ...[
                      const SizedBox(height: 2),
                      Semantics(
                        label:
                            '${author.followerCount} ${t.profile.followers}, ${author.followingCount} ${t.profile.following}',
                        child: Text(
                          '${_formatFollowerCount(author.followerCount)} ${t.profile.followers}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: darkOverlay
                                ? Colors.white70
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                    if (createdAt != null ||
                        (postTitle != null && postTitle!.trim().isNotEmpty))
                      _PostMetaCarousel(
                        createdAt: createdAt,
                        postTitle: postTitle,
                        darkOverlay: darkOverlay,
                      ),
                  ],
                ),
              ),
              if (showFollowButton && !author.isCurrentUser) ...[
                const SizedBox(width: 8),
                _FollowButton(
                  isFollowing: author.isFollowing,
                  showFollowBackLabel: showFollowBackLabel,
                  isLoading: isFollowLoading,
                  onTap: onFollowTap,
                  gradients: gradients,
                  colorScheme: colorScheme,
                  compact: compact,
                  darkOverlay: darkOverlay,
                ),
              ],
              if (onMoreTap != null)
                IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    onMoreTap?.call();
                  },
                  icon: Icon(
                    Icons.more_vert,
                    color: darkOverlay
                        ? Colors.white70
                        : colorScheme.onSurfaceVariant,
                    size: compact ? 18 : 20,
                  ),
                  visualDensity: VisualDensity.compact,
                  tooltip: 'More options',
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatFollowerCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}

class _FollowButton extends StatefulWidget {
  final bool isFollowing;
  final bool showFollowBackLabel;
  final bool isLoading;
  final VoidCallback? onTap;
  final GradientExtension? gradients;
  final ColorScheme colorScheme;
  final bool compact;
  final bool darkOverlay;

  const _FollowButton({
    required this.isFollowing,
    required this.showFollowBackLabel,
    required this.isLoading,
    this.onTap,
    this.gradients,
    required this.colorScheme,
    required this.compact,
    this.darkOverlay = false,
  });

  @override
  State<_FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<_FollowButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(_FollowButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFollowing != oldWidget.isFollowing) {
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelColor = widget.darkOverlay
        ? Colors.white
        : widget.colorScheme.onSurface;
    return Semantics(
      button: true,
      label: widget.isFollowing
          ? t.profile.unfollow
          : widget.showFollowBackLabel
          ? 'Follow back'
          : t.profile.follow,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isLoading
              ? null
              : () {
                  HapticFeedback.lightImpact();
                  widget.onTap?.call();
                },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: widget.compact ? 10 : 14,
              vertical: widget.compact ? 7 : 9,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: widget.isFollowing
                  ? GradientBoxBorder(
                      width: 1.5,
                      gradient:
                          widget.gradients?.primaryButtonGradient ??
                          LinearGradient(
                            colors: [
                              widget.colorScheme.primary,
                              widget.colorScheme.secondary,
                            ],
                          ),
                    )
                  : Border.all(
                      color: widget.darkOverlay
                          ? Colors.white.withValues(alpha: 0.85)
                          : DarkColors.accentPrimary,
                      width: 1.5,
                    ),
            ),
            child: widget.isLoading
                ? SizedBox(
                    width: widget.compact ? 12 : 16,
                    height: widget.compact ? 12 : 16,
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(labelColor),
                    ),
                  )
                : FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.isFollowing
                          ? t.profile.following
                          : widget.showFollowBackLabel
                          ? 'Follow back'
                          : t.profile.follow,
                      style:
                          (widget.compact
                                  ? theme.textTheme.labelSmall
                                  : theme.textTheme.labelMedium)
                              ?.copyWith(
                                color: labelColor,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _PostMetaCarousel extends StatefulWidget {
  final DateTime? createdAt;
  final String? postTitle;
  final bool darkOverlay;

  const _PostMetaCarousel({
    required this.createdAt,
    required this.postTitle,
    required this.darkOverlay,
  });

  @override
  State<_PostMetaCarousel> createState() => _PostMetaCarouselState();
}

class _PostMetaCarouselState extends State<_PostMetaCarousel> {
  static const _advanceInterval = Duration(seconds: 3);
  static const _transitionDuration = Duration(milliseconds: 280);

  Timer? _timer;
  bool _showTitle = true;

  @override
  void initState() {
    super.initState();
    _maybeStartTimer();
  }

  @override
  void didUpdateWidget(_PostMetaCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    final hadBoth = _hasBoth(oldWidget);
    final hasBoth = _hasBoth(widget);
    if (hadBoth != hasBoth) {
      _timer?.cancel();
      _timer = null;
      _showTitle = true;
      _maybeStartTimer();
    }
  }

  bool _hasBoth(_PostMetaCarousel w) {
    final t = w.postTitle?.trim();
    return t != null && t.isNotEmpty && w.createdAt != null;
  }

  void _maybeStartTimer() {
    if (!_hasBoth(widget)) return;
    if (!mounted) return;
    _timer = Timer.periodic(_advanceInterval, (_) {
      if (!mounted) return;
      setState(() => _showTitle = !_showTitle);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _flip() {
    if (!_hasBoth(widget)) return;
    HapticFeedback.selectionClick();
    setState(() => _showTitle = !_showTitle);
  }

  @override
  Widget build(BuildContext context) {
    final trimmedTitle = widget.postTitle?.trim();
    final hasTitle = trimmedTitle != null && trimmedTitle.isNotEmpty;
    final hasDate = widget.createdAt != null;
    final theme = Theme.of(context);
    final style = theme.textTheme.labelSmall?.copyWith(
      height: 1.25,
      color: widget.darkOverlay
          ? Colors.white70
          : theme.colorScheme.onSurfaceVariant,
    );

    if (!hasTitle && !hasDate) return const SizedBox.shrink();

    if (!hasTitle && hasDate) {
      return Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            timeago.format(widget.createdAt!),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textHeightBehavior: const TextHeightBehavior(
              applyHeightToFirstAscent: false,
              applyHeightToLastDescent: true,
            ),
            style: style,
          ),
        ),
      );
    }
    if (hasTitle && !hasDate) {
      return Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            trimmedTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textHeightBehavior: const TextHeightBehavior(
              applyHeightToFirstAscent: false,
              applyHeightToLastDescent: true,
            ),
            style: style,
          ),
        ),
      );
    }

    // Both title and date: [trimmedTitle] is non-null (see early returns above).
    final title = trimmedTitle!;

    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (reduceMotion) {
      return Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style,
            ),
            Text(
              timeago.format(widget.createdAt!),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style,
            ),
          ],
        ),
      );
    }

    final timeText = timeago.format(widget.createdAt!);
    final displayText = _showTitle ? title : timeText;

    // AnimatedSwitcher defaults to a Stack with Alignment.center, which centers
    // the outgoing/incoming text during the transition then snaps to the column's
    // start — looks like a glitch. Pin transitions to top-start and fixed height.
    final fontSize = style?.fontSize ?? 12;
    final lineHeightPx = fontSize * (style?.height ?? 1.25);

    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _flip,
        child: ClipRect(
          child: SizedBox(
            width: double.infinity,
            height: lineHeightPx,
            child: AnimatedSwitcher(
              duration: _transitionDuration,
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              layoutBuilder: (currentChild, previousChildren) {
                return Stack(
                  alignment: Alignment.topLeft,
                  fit: StackFit.passthrough,
                  clipBehavior: Clip.hardEdge,
                  children: <Widget>[
                    ...previousChildren,
                    if (currentChild != null) currentChild,
                  ],
                );
              },
              transitionBuilder: (child, animation) {
                final curved = CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                );
                return FadeTransition(
                  opacity: curved,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.07),
                      end: Offset.zero,
                    ).animate(curved),
                    child: child,
                  ),
                );
              },
              child: Text(
                key: ValueKey<String>(displayText),
                displayText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                textHeightBehavior: const TextHeightBehavior(
                  applyHeightToFirstAscent: false,
                  applyHeightToLastDescent: true,
                ),
                style: style,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
