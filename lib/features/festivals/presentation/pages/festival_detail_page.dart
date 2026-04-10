import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/features/festivals/domain/entities/hindu_festival.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import 'package:myitihas/features/story_generator/domain/entities/generator_options.dart';
import 'package:myitihas/features/story_generator/domain/entities/story_prompt.dart';
import 'package:myitihas/features/story_generator/domain/repositories/story_generator_repository.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/pages/map2/widgets/custom_image_widget.dart';
import 'package:myitihas/pages/map2/map_guide.dart';

// Festival-themed accent (saffron / deep orange)
const _festivalGradientSoft = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFE65100), Color(0xFFFF9800)],
);

/// Premium festival detail: hero, header, icon-led sections, sticky actions.
class FestivalDetailPage extends StatefulWidget {
  final HinduFestival festival;

  const FestivalDetailPage({super.key, required this.festival});

  @override
  State<FestivalDetailPage> createState() => _FestivalDetailPageState();
}

class _FestivalDetailPageState extends State<FestivalDetailPage> {
  final ScrollController _scrollController = ScrollController();
  static const _heroHeight = 320.0;
  static const _horizontalPadding = 20.0;
  static const _sectionSpacing = 12.0;

  bool _aboutExpanded = true;
  bool _whenExpanded = false;
  bool _whereExpanded = false;
  bool _howExpanded = false;
  bool _historyExpanded = false;
  bool _significanceExpanded = false;
  bool _scripturesExpanded = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String? _text(dynamic value) {
    if (value == null) return null;
    final s = value.toString().trim();
    return s.isEmpty ? null : s;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final gradientExt = theme.extension<GradientExtension>();
    final f = widget.festival;
    final imageUrl = f.imageUrl ?? '';

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: gradientExt?.screenBackgroundGradient ??
              LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  colorScheme.surface,
                  colorScheme.primary.withValues(alpha: 0.05),
                  colorScheme.surface,
                ],
                transform: const GradientRotation(3.14 / 1.5),
              ),
        ),
        child: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                _buildHero(context, imageUrl, f.name),
                SliverToBoxAdapter(
                  child: _buildHeaderCard(context, f),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        _horizontalPadding, 24, _horizontalPadding, 0),
                    child: Text(
                      'About the festival',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
                _buildContentSection(
                  context,
                  icon: Icons.info_outline_rounded,
                  title: 'About',
                  content: _text(f.shortDescription) ?? _text(f.description),
                  isExpanded: _aboutExpanded,
                  onToggle: () =>
                      setState(() => _aboutExpanded = !_aboutExpanded),
                ),
                _buildContentSection(
                  context,
                  icon: Icons.calendar_today_rounded,
                  title: 'When',
                  content: [
                    if (f.whenCelebrated != null) f.whenCelebrated!,
                    if (f.whenDetails != null) '\n${f.whenDetails!}',
                  ].join().trim().isEmpty
                      ? null
                      : [f.whenCelebrated, f.whenDetails]
                          .whereType<String>()
                          .join('\n'),
                  isExpanded: _whenExpanded,
                  onToggle: () => setState(() => _whenExpanded = !_whenExpanded),
                ),
                _buildContentSection(
                  context,
                  icon: Icons.place_rounded,
                  title: 'Where celebrated',
                  content: _text(f.whereCelebrated),
                  isExpanded: _whereExpanded,
                  onToggle: () =>
                      setState(() => _whereExpanded = !_whereExpanded),
                ),
                _buildContentSection(
                  context,
                  icon: Icons.celebration_rounded,
                  title: 'How celebrated',
                  content: _text(f.howCelebrated),
                  isExpanded: _howExpanded,
                  onToggle: () => setState(() => _howExpanded = !_howExpanded),
                ),
                _buildContentSection(
                  context,
                  icon: Icons.history_edu_rounded,
                  title: 'History',
                  content: _text(f.history),
                  isExpanded: _historyExpanded,
                  onToggle: () =>
                      setState(() => _historyExpanded = !_historyExpanded),
                ),
                _buildContentSection(
                  context,
                  icon: Icons.auto_awesome_rounded,
                  title: 'Significance',
                  content: _text(f.significance),
                  isExpanded: _significanceExpanded,
                  onToggle: () => setState(
                      () => _significanceExpanded = !_significanceExpanded),
                ),
                _buildContentSection(
                  context,
                  icon: Icons.menu_book_rounded,
                  title: 'Scriptures',
                  content: _text(f.scripturesRelated),
                  isExpanded: _scripturesExpanded,
                  onToggle: () => setState(
                      () => _scripturesExpanded = !_scripturesExpanded),
                ),
                // Space for sticky actions + home indicator (avoid iOS bottom crop)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: _stickyActionsScrollExtent(context),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: _buildSafeBackButton(context),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildStickyActions(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context, String imageUrl, String name) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: SizedBox(
        height: _heroHeight,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomImageWidget(
              imageUrl: imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              useSacredPlaceholder: true,
              sacredPlaceholderSeed: name,
              semanticLabel: name,
            ),
            // Gradient overlay for readability
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.2),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.85),
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
            // Festival name at bottom
            Positioned(
              left: _horizontalPadding,
              right: _horizontalPadding,
              bottom: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                      letterSpacing: -0.5,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 12,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafeBackButton(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            Material(
              color: Colors.black.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  Navigator.of(context).pop();
                },
                borderRadius: BorderRadius.circular(14),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.arrow_back_rounded,
                      color: Colors.white, size: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, HinduFestival f) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(_horizontalPadding, 20, _horizontalPadding, 0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: isDark ? 0.15 : 0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.surfaceContainerHigh,
            colorScheme.surface,
          ],
        ),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: _festivalGradientSoft,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF9800).withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.celebration_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sanatan Festival',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  f.whenCelebrated ?? 'Celebrated across India',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildContentSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String? content,
    required bool isExpanded,
    required VoidCallback onToggle,
  }) {
    if (content == null || content.trim().isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(
            top: _sectionSpacing, left: _horizontalPadding, right: _horizontalPadding),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow.withValues(
                alpha: isDark ? 0.4 : 0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.06),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticFeedback.selectionClick();
                onToggle();
              },
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            icon,
                            size: 22,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                        AnimatedRotation(
                          turns: isExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutCubic,
                          child: Icon(
                            Icons.expand_more_rounded,
                            color: colorScheme.onSurfaceVariant,
                            size: 26,
                          ),
                        ),
                      ],
                    ),
                    AnimatedCrossFade(
                      firstChild: const SizedBox.shrink(),
                      secondChild: Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: Text(
                          content,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                            height: 1.55,
                          ),
                        ),
                      ),
                      crossFadeState: isExpanded
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 220),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Vertical space the sticky bar occupies (single safe-area inset; no double padding).
  double _stickyActionsScrollExtent(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    // ~32 vertical padding + ~50 action row + buffer so last section clears the bar
    return 120 + bottom;
  }

  Widget _buildStickyActions(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: SafeArea(
          top: false,
          maintainBottomViewPadding: true,
          child: Container(
            padding: const EdgeInsets.fromLTRB(
              _horizontalPadding,
              16,
              _horizontalPadding,
              16,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(alpha: isDark ? 0.92 : 0.96),
              border: Border(
                top: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    label: 'Chat',
                    icon: Icons.chat_bubble_outline_rounded,
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary,
                        colorScheme.tertiary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    onPressed: _openChat,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: _ActionButton(
                    label: Translations.of(context).festivals.tellStory,
                    icon: Icons.auto_stories_rounded,
                    gradient: _festivalGradientSoft,
                    onPressed: _generateFestivalStory,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openChat() {
    HapticFeedback.selectionClick();
    final f = widget.festival;
    final storyContent = [
      if (f.description != null) f.description,
      if (f.history != null) f.history,
      if (f.significance != null) f.significance,
    ].whereType<String>().join('\n\n');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MapGuide(
          initialLocation: {
            'name': f.name,
            'title': f.name,
            'story_content': storyContent.isNotEmpty
                ? storyContent
                : f.shortDescription ?? 'Sanatan festival',
            'moral': f.significance ?? f.shortDescription ?? '',
          },
        ),
      ),
    );
  }

  Future<void> _generateFestivalStory() async {
    HapticFeedback.selectionClick();
    await _FestivalStoryGenerator.run(
      context: context,
      festivalName: widget.festival.name,
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.gradient,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 22),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

class _FestivalStoryGenerator {
  static Future<void> run({
    required BuildContext context,
    required String festivalName,
  }) async {
    if (!context.mounted) return;
    final repository = getIt<StoryGeneratorRepository>();
    final prompt = StoryPrompt(
      rawPrompt: 'Tell the story of the Sanatan festival "$festivalName": its origin and why it is celebrated. '
          'If there is a scriptural tale (from Puranas, epics, or regional lore), include it. '
          'If the festival is mainly cultural, harvest, or solar (e.g. linked to seasons, sun, or agriculture), '
          'weave a narrative from tradition, symbolism, and how it is observed—without inventing scripture. '
          'Keep it engaging, educational, and suitable for all ages. Write in a narrative story format.',
      isRawPrompt: true,
    );
    const options = GeneratorOptions(
      language: StoryLanguage.english,
      format: StoryFormat.narrative,
      length: StoryLength.medium,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Generating the story of the festival...'),
              ],
            ),
          ),
        ),
      ),
    );

    final result = await repository.generateStory(
      prompt: prompt,
      options: options,
    );

    if (!context.mounted) return;
    Navigator.of(context).pop();

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Could not generate story: ${failure.message}')),
        );
      },
      (Story story) {
        GeneratedStoryResultRoute($extra: story).go(context);
      },
    );
  }
}
