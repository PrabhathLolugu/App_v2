import 'package:flutter/material.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';

class ReadingProgressIndicator extends StatefulWidget {
  final ScrollController scrollController;
  final double height;
  final bool showPercentageOnLongPress;

  const ReadingProgressIndicator({
    super.key,
    required this.scrollController,
    this.height = 3,
    this.showPercentageOnLongPress = true,
  });

  @override
  State<ReadingProgressIndicator> createState() =>
      _ReadingProgressIndicatorState();
}

class _ReadingProgressIndicatorState extends State<ReadingProgressIndicator> {
  double _progress = 0.0;
  bool _showPercentage = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_updateProgress);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateProgress();
    });
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_updateProgress);
    super.dispose();
  }

  void _updateProgress() {
    if (!widget.scrollController.hasClients) return;

    final maxScroll = widget.scrollController.position.maxScrollExtent;
    final currentScroll = widget.scrollController.position.pixels;

    if (maxScroll > 0) {
      setState(() {
        _progress = (currentScroll / maxScroll).clamp(0.0, 1.0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradients = theme.extension<GradientExtension>();
    final colorScheme = theme.colorScheme;
    final percentage = (_progress * 100).round();

    return Semantics(
      label: 'Reading progress: $percentage percent',
      value: '$percentage%',
      child: GestureDetector(
        onLongPressStart: widget.showPercentageOnLongPress
            ? (_) => setState(() => _showPercentage = true)
            : null,
        onLongPressEnd: widget.showPercentageOnLongPress
            ? (_) => setState(() => _showPercentage = false)
            : null,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Background track
            Container(
              height: widget.height,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
                borderRadius: BorderRadius.circular(widget.height / 2),
              ),
            ),
            // Progress fill with gradient
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              height: widget.height,
              width: double.infinity,
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _progress,
                child: Container(
                  decoration: BoxDecoration(
                    gradient:
                        gradients?.primaryButtonGradient ??
                        LinearGradient(
                          colors: [colorScheme.primary, colorScheme.secondary],
                        ),
                    borderRadius: BorderRadius.circular(widget.height / 2),
                  ),
                ),
              ),
            ),
            // Percentage tooltip
            if (_showPercentage)
              Positioned(
                left: _progress * MediaQuery.of(context).size.width - 20,
                top: -28,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.inverseSurface,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '$percentage%',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onInverseSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SimpleProgressIndicator extends StatelessWidget {
  final double progress;
  final double height;

  const SimpleProgressIndicator({
    super.key,
    required this.progress,
    this.height = 3,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradients = theme.extension<GradientExtension>();
    final colorScheme = theme.colorScheme;
    final percentage = (progress * 100).round();

    return Semantics(
      label: 'Progress: $percentage percent',
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(height / 2),
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: progress.clamp(0.0, 1.0),
          child: Container(
            decoration: BoxDecoration(
              gradient:
                  gradients?.primaryButtonGradient ??
                  LinearGradient(
                    colors: [colorScheme.primary, colorScheme.secondary],
                  ),
              borderRadius: BorderRadius.circular(height / 2),
            ),
          ),
        ),
      ),
    );
  }
}
