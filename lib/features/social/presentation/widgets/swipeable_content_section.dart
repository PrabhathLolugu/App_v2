import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart'
    show MarkdownStyleSheet;
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/core/widgets/markdown/markdown.dart';

class ContentSection {
  final String title;
  final String content;
  final IconData icon;

  const ContentSection({
    required this.title,
    required this.content,
    required this.icon,
  });
}

class SwipeableContentSection extends StatefulWidget {
  final String storyExcerpt;
  final String trivia;
  final String lesson;
  final String activity;
  final int maxLines;
  final ValueChanged<int>? onPageChanged;
  final bool darkOverlay;
  final VoidCallback? onContinueReadingTap;

  const SwipeableContentSection({
    super.key,
    required this.storyExcerpt,
    required this.trivia,
    required this.lesson,
    required this.activity,
    required this.onContinueReadingTap,
    this.maxLines = 6,
    this.onPageChanged,
    this.darkOverlay = false,
  });

  @override
  State<SwipeableContentSection> createState() =>
      _SwipeableContentSectionState();
}

class _SwipeableContentSectionState extends State<SwipeableContentSection> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<ContentSection> get _sections => [
    ContentSection(
      title: 'Story',
      content: widget.storyExcerpt,
      icon: Icons.auto_stories,
    ),
    if (widget.trivia.isNotEmpty)
      ContentSection(
        title: 'Trivia',
        content: widget.trivia,
        icon: Icons.lightbulb_outline,
      ),
    if (widget.lesson.isNotEmpty)
      ContentSection(
        title: 'Lesson',
        content: widget.lesson,
        icon: Icons.school_outlined,
      ),
    if (widget.activity.isNotEmpty)
      ContentSection(
        title: 'Activity',
        content: widget.activity,
        icon: Icons.play_circle_outline,
      ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradients = theme.extension<GradientExtension>();
    final colorScheme = theme.colorScheme;
    final sections = _sections;

    if (sections.isEmpty) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: widget.onContinueReadingTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: _calculateHeight(context),
            child: PageView.builder(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              itemCount: sections.length,
              onPageChanged: (index) {
                HapticFeedback.selectionClick();
                setState(() => _currentPage = index);
                widget.onPageChanged?.call(index);
              },
              itemBuilder: (context, index) {
                final section = sections[index];
                return Semantics(
                  label: '${section.title}: ${section.content}',
                  child: _ContentPage(
                    section: section,
                    maxLines: widget.maxLines,
                    colorScheme: colorScheme,
                    theme: theme,
                    darkOverlay: widget.darkOverlay,
                  ),
                );
              },
            ),
          ),
          // const SizedBox(height: 8),
          // ElevatedButton(
          //   onPressed: widget.onContinueReadingTap,
          //   style:
          //       ElevatedButton.styleFrom(
          //         padding: const EdgeInsets.symmetric(
          //           horizontal: 24,
          //           vertical: 8,
          //         ),
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(20),
          //         ),
          //         backgroundColor: widget.darkOverlay
          //             ? Colors.white.withValues(alpha: 0.2)
          //             : (gradients?.primaryButtonGradient != null
          //                   ? null
          //                   : colorScheme.primary),
          //       ).copyWith(
          //         elevation: WidgetStateProperty.all(0),
          //         backgroundColor: gradients?.primaryButtonGradient != null
          //             ? WidgetStateProperty.all(Colors.transparent)
          //             : null,
          //       ),
          //   child: Text(
          //     'Continue Reading',
          //     style: theme.textTheme.labelMedium?.copyWith(
          //       color: widget.darkOverlay ? Colors.white : Colors.white,
          //       fontWeight: FontWeight.w600,
          //     ),
          //   ),
          // ),
          const SizedBox(height: 10),
          if (sections.length > 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: List.generate(sections.length, (index) {
                final isActive = index == _currentPage;
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    height: 6,
                    width: isActive ? 16 : 6,
                    decoration: BoxDecoration(
                      gradient: isActive
                          ? gradients?.primaryButtonGradient
                          : null,
                      color: isActive
                          ? null
                          : widget.darkOverlay
                          ? Colors.white.withValues(alpha: 0.4)
                          : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }

  double _calculateHeight(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context);
    final lineHeight = textScale.scale(15) * 1.5;
    return (widget.maxLines * lineHeight) + 56;
  }
}

class _ContentPage extends StatelessWidget {
  final ContentSection section;
  final int maxLines;
  final ColorScheme colorScheme;
  final ThemeData theme;
  final bool darkOverlay;

  const _ContentPage({
    required this.section,
    required this.maxLines,
    required this.colorScheme,
    required this.theme,
    this.darkOverlay = false,
  });

  @override
  Widget build(BuildContext context) {
    final gradients = theme.extension<GradientExtension>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        decoration: BoxDecoration(
          color: darkOverlay
              ? Colors.white.withValues(alpha: 0.08)
              : (gradients?.glassCardBackground ??
                  colorScheme.surface.withValues(alpha: 0.7)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: darkOverlay
                ? Colors.white.withValues(alpha: 0.12)
                : (gradients?.glassCardBorder ??
                    colorScheme.primary.withValues(alpha: 0.12)),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  section.icon,
                  size: 18,
                  color: darkOverlay ? Colors.white : colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Text(
                  section.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: darkOverlay ? Colors.white : colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Colors.white, Colors.transparent],
                      stops: const [0.0, 0.7, 1.0],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: SanitizedMarkdown(
                        data: section.content,
                        selectable: false,
                        styleSheetOverride: MarkdownStyleSheet(
                          p: theme.textTheme.bodyMedium?.copyWith(
                            color: darkOverlay
                                ? Colors.white.withValues(alpha: 0.92)
                                : colorScheme.onSurface.withValues(alpha: 0.9),
                            height: 1.5,
                          ),
                          strong: theme.textTheme.bodySmall?.copyWith(
                            color: darkOverlay
                                ? Colors.white.withValues(alpha: 0.9)
                                : colorScheme.onSurface.withValues(alpha: 0.9),
                            fontWeight: FontWeight.bold,
                          ),
                          em: theme.textTheme.bodySmall?.copyWith(
                            color: darkOverlay
                                ? Colors.white.withValues(alpha: 0.9)
                                : colorScheme.onSurface.withValues(alpha: 0.9),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
    );
  }
}

class ContentPageIndicator extends StatelessWidget {
  final PageController controller;
  final int count;

  const ContentPageIndicator({
    super.key,
    required this.controller,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final currentPage = controller.hasClients
            ? (controller.page ?? 0).round()
            : 0;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(count, (index) {
            final isActive = index == currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 6,
              width: isActive ? 18 : 6,
              decoration: BoxDecoration(
                color: isActive
                    ? colorScheme.primary
                    : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        );
      },
    );
  }
}
