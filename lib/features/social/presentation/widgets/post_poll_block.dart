import 'package:flutter/material.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/features/social/domain/entities/post_poll.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/services/post_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostPollBlock extends StatefulWidget {
  const PostPollBlock({
    super.key,
    required this.postId,
    required this.poll,
    this.darkOverlay = false,
  });

  final String postId;
  final PostPoll poll;
  final bool darkOverlay;

  @override
  State<PostPollBlock> createState() => _PostPollBlockState();
}

class _PostPollBlockState extends State<PostPollBlock> {
  late PostPoll _poll;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _poll = widget.poll;
  }

  @override
  void didUpdateWidget(covariant PostPollBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.poll != widget.poll && !_isSubmitting) {
      _poll = widget.poll;
    }
  }

  Future<void> _onVote(int optionIndex) async {
    if (_isSubmitting || _poll.hasVoted) return;
    final currentUser = Supabase.instance.client.auth.currentUser;
    if (currentUser == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.social.poll.signInToVote)),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await getIt<PostService>().voteOnPoll(
        postId: widget.postId,
        optionIndex: optionIndex,
      );

      final counts = [..._poll.voteCounts];
      while (counts.length < 4) {
        counts.add(0);
      }
      counts[optionIndex] = counts[optionIndex] + 1;

      setState(() {
        _poll = _poll.copyWith(
          voteCounts: counts,
          totalVotes: _poll.totalVotes + 1,
          mySelectedIndex: optionIndex,
        );
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.social.poll.voteFailed)),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final options = _poll.options;
    final showResults = _poll.hasVoted;
    final counts = _poll.countsForVisibleOptions;
    final totalVotes = _poll.totalVotes;

    final backgroundColor = widget.darkOverlay
        ? Colors.white.withValues(alpha: 0.08)
        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.7);
    final borderColor = widget.darkOverlay
        ? Colors.white.withValues(alpha: 0.2)
        : colorScheme.outline.withValues(alpha: 0.25);
    final textColor = widget.darkOverlay ? Colors.white : colorScheme.onSurface;
    final subTextColor = widget.darkOverlay
        ? Colors.white70
        : colorScheme.onSurfaceVariant;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.social.poll.title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          for (int i = 0; i < options.length; i++) ...[
            _PollOptionTile(
              label: options[i],
              textColor: textColor,
              subTextColor: subTextColor,
              borderColor: borderColor,
              progressColor: colorScheme.primary.withValues(
                alpha: widget.darkOverlay ? 0.32 : 0.18,
              ),
              isSelected: _poll.mySelectedIndex == i,
              showResults: showResults,
              percentage: totalVotes > 0
                  ? ((counts[i] / totalVotes) * 100).round()
                  : 0,
              onTap: () => _onVote(i),
              isDisabled: _isSubmitting || _poll.hasVoted,
            ),
            if (i < options.length - 1) const SizedBox(height: 8),
          ],
          const SizedBox(height: 10),
          Text(
            showResults
                ? t.social.poll.votes(
                    count: _formatCompactVotes(totalVotes),
                  )
                : t.social.poll.tapToVote,
            style: theme.textTheme.labelMedium?.copyWith(
              color: subTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCompactVotes(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    }
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}

class _PollOptionTile extends StatelessWidget {
  const _PollOptionTile({
    required this.label,
    required this.textColor,
    required this.subTextColor,
    required this.borderColor,
    required this.progressColor,
    required this.isSelected,
    required this.showResults,
    required this.percentage,
    required this.onTap,
    required this.isDisabled,
  });

  final String label;
  final Color textColor;
  final Color subTextColor;
  final Color borderColor;
  final Color progressColor;
  final bool isSelected;
  final bool showResults;
  final int percentage;
  final VoidCallback onTap;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tileBorderColor = isSelected
        ? borderColor.withValues(alpha: 0.95)
        : borderColor.withValues(alpha: 0.7);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isDisabled ? null : onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: tileBorderColor),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: Stack(
              children: [
                if (showResults)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: (percentage / 100).clamp(0.0, 1.0),
                        child: Container(color: progressColor),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: textColor,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w600,
                          ),
                        ),
                      ),
                      if (showResults)
                        Text(
                          '$percentage%',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: subTextColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
