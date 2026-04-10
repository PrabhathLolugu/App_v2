import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/core/presentation/bloc/connectivity_bloc.dart';
import 'package:myitihas/core/presentation/bloc/connectivity_state.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/utils/constants.dart';

/// Engagement bar with Like, Comment, Share, Bookmark buttons and Continue Reading CTA
class EngagementBar extends StatelessWidget {
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final bool isLiked;
  final bool isBookmarked;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onBookmark;
  final VoidCallback? onContinueReading;
  final bool vertical;

  const EngagementBar({
    super.key,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    this.isLiked = false,
    this.isBookmarked = false,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onBookmark,
    this.onContinueReading,
    this.vertical = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradients = theme.extension<GradientExtension>();
    final colorScheme = theme.colorScheme;

    if (vertical) {
      return _buildVerticalLayout(context, theme, gradients, colorScheme);
    }

    return _buildHorizontalLayout(context, theme, gradients, colorScheme);
  }

  Widget _buildHorizontalLayout(
    BuildContext context,
    ThemeData theme,
    GradientExtension? gradients,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        _EngagementButton(
          icon: isLiked ? Icons.favorite : Icons.favorite_border,
          label: _formatCount(likeCount),
          color: isLiked ? Colors.red : colorScheme.onSurface,
          onTap: () {
            HapticFeedback.lightImpact();
            onLike?.call();
          },
          semanticLabel: isLiked
              ? t.feed.unlike(count: likeCount)
              : t.feed.like(count: likeCount),
        ),
        const SizedBox(width: 16),
        _EngagementButton(
          icon: Icons.chat_bubble_outline,
          label: _formatCount(commentCount),
          color: colorScheme.onSurface,
          onTap: onComment,
          semanticLabel: t.feed.commentCount(count: commentCount),
        ),
        const SizedBox(width: 16),
        _EngagementButton(
          icon: Icons.share_outlined,
          label: _formatCount(shareCount),
          color: colorScheme.onSurface,
          onTap: () {
            HapticFeedback.lightImpact();
            onShare?.call();
          },
          semanticLabel: t.feed.shareCount(count: shareCount),
        ),
        const SizedBox(width: 16),
        _EngagementButton(
          icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
          label: '',
          color: isBookmarked ? colorScheme.primary : colorScheme.onSurface,
          onTap: () {
            HapticFeedback.lightImpact();
            onBookmark?.call();
          },
          semanticLabel: isBookmarked
              ? t.feed.removeBookmark
              : t.feed.addBookmark,
        ),
      ],
    );
  }

  Widget _buildVerticalLayout(
    BuildContext context,
    ThemeData theme,
    GradientExtension? gradients,
    ColorScheme colorScheme,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _EngagementButton(
          icon: isLiked ? Icons.favorite : Icons.favorite_border,
          label: _formatCount(likeCount),
          color: isLiked ? Colors.red : Colors.white,
          onTap: () {
            HapticFeedback.lightImpact();
            onLike?.call();
          },
          semanticLabel: isLiked
              ? t.feed.unlike(count: likeCount)
              : t.feed.like(count: likeCount),
          vertical: true,
          iconSize: 32,
        ),
        const SizedBox(height: 20),
        _EngagementButton(
          icon: Icons.chat_bubble_outline,
          label: _formatCount(commentCount),
          color: Colors.white,
          onTap: onComment,
          semanticLabel: t.feed.commentCount(count: commentCount),
          vertical: true,
          iconSize: 32,
        ),
        const SizedBox(height: 20),
        _EngagementButton(
          icon: Icons.share_outlined,
          label: _formatCount(shareCount),
          color: Colors.white,
          onTap: () {
            HapticFeedback.lightImpact();
            onShare?.call();
          },
          semanticLabel: t.feed.shareCount(count: shareCount),
          vertical: true,
          iconSize: 32,
        ),
        const SizedBox(height: 20),
        _EngagementButton(
          icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
          label: '',
          color: isBookmarked ? colorScheme.primary : Colors.white,
          onTap: () {
            HapticFeedback.lightImpact();
            onBookmark?.call();
          },
          semanticLabel: isBookmarked
              ? t.feed.removeBookmark
              : t.feed.addBookmark,
          vertical: true,
          iconSize: 32,
        ),
      ],
    );
  }

  static String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}

class _EngagementButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final String semanticLabel;
  final bool vertical;
  final double iconSize;

  const _EngagementButton({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
    required this.semanticLabel,
    this.vertical = false,
    this.iconSize = 24,
  });

  @override
  State<_EngagementButton> createState() => _EngagementButtonState();
}

class _EngagementButtonState extends State<_EngagementButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    widget.onTap?.call();
  }

  void _showOfflineSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.social.engagement.offlineMode),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      builder: (context, state) {
        final isOnline = state is ConnectivityOnline;

        return Semantics(
          button: true,
          label: widget.semanticLabel,
          child: GestureDetector(
            onTap: isOnline
                ? _handleTap
                : (widget.onTap != null
                      ? () => _showOfflineSnackBar(context)
                      : null),
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Opacity(
                opacity: isOnline ? 1.0 : 0.5,
                child: widget.vertical
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.icon,
                            color: isOnline ? widget.color : Colors.grey,
                            size: widget.iconSize,
                            shadows: [
                              BoxShadow(
                                color: theme.brightness == Brightness.dark
                                    ? DarkColors.textPrimary.withValues(
                                        alpha: 0.5,
                                      )
                                    : LightColors.textPrimary.withValues(
                                        alpha: 0.5,
                                      ),
                                blurRadius: 100,
                                spreadRadius: 20,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                          if (widget.label.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              transitionBuilder: (child, animation) {
                                return ScaleTransition(
                                  scale: animation,
                                  child: child,
                                );
                              },
                              child: Text(
                                widget.label,
                                key: ValueKey(widget.label),
                                style: TextStyle(
                                  color: isOnline ? widget.color : Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.icon,
                            color: isOnline ? widget.color : Colors.grey,
                            size: widget.iconSize,
                          ),
                          if (widget.label.isNotEmpty) ...[
                            const SizedBox(width: 4),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              transitionBuilder: (child, animation) {
                                return ScaleTransition(
                                  scale: animation,
                                  child: child,
                                );
                              },
                              child: Text(
                                widget.label,
                                key: ValueKey(widget.label),
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: isOnline ? widget.color : Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
