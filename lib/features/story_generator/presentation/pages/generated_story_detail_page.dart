// ignore_for_file: unused_element, unused_field

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/core/cache/widgets/story_image.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/core/logging/talker_setup.dart';
import 'package:myitihas/core/theme/chat_message_typography.dart';
import 'package:myitihas/core/utils/language_voice_resolver.dart';
import 'package:myitihas/core/widgets/markdown/markdown.dart';
import 'package:myitihas/core/widgets/voice_input/voice_input_button.dart';
import 'package:myitihas/features/social/presentation/widgets/share_to_feed_dialog.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import 'package:myitihas/features/story_generator/domain/entities/generator_options.dart';
import 'package:myitihas/features/story_generator/presentation/bloc/story_detail_bloc.dart';
import 'package:myitihas/features/story_generator/presentation/widgets/generating_overlay.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/pages/Chat/Widget/share_to_conversation_sheet.dart';
import 'package:myitihas/services/chat_service.dart';
import 'package:myitihas/services/downloaded_stories_service.dart';
import 'package:myitihas/services/supabase_service.dart';
import 'package:share_plus/share_plus.dart';

class GeneratedStoryDetailPage extends StatefulWidget {
  final Story story;

  const GeneratedStoryDetailPage({super.key, required this.story});

  @override
  State<GeneratedStoryDetailPage> createState() =>
      _GeneratedStoryDetailPageState();
}

class _GeneratedStoryDetailPageState extends State<GeneratedStoryDetailPage> {
  late final StoryDetailBloc _detailBloc;
  int _likes = 0;
  bool _isLiked = false;

  String? selectedCharacter;
  late final TextEditingController selectedCharacterController;

  final List<Map<String, String>> languages = StoryLanguage.values.map((lang) {
    return {
      'name': "${lang.name[0].toUpperCase()}${lang.name.substring(1)}",
      'code': lang.code,
    };
  }).toList();

  @override
  void initState() {
    super.initState();
    _detailBloc = getIt<StoryDetailBloc>()
      ..add(StoryDetailStarted(widget.story));
    selectedCharacterController = TextEditingController();
    _likes = widget.story.likes;
    _isLiked = widget.story.isLikedByCurrentUser;
  }

  bool _isStoryOwnedByCurrentUser(Story story) {
    final currentUserId = SupabaseService.client.auth.currentUser?.id;
    if (currentUserId == null || currentUserId.isEmpty) {
      return false;
    }
    return story.authorId == currentUserId ||
        story.authorUser?.id == currentUserId;
  }

  String _resolveStoryTitle(Story story, StoryDetailState state) {
    final selectedCode = LanguageVoiceResolver.languageCodeFromAny(
      state.selectedLanguage,
    );
    return story.attributes.translations[selectedCode]?.title ?? story.title;
  }

  String _resolveStoryMoral(Story story, StoryDetailState state) {
    final selectedCode = LanguageVoiceResolver.languageCodeFromAny(
      state.selectedLanguage,
    );
    final translatedMoral = story.attributes.translations[selectedCode]?.moral;
    if (translatedMoral != null && translatedMoral.trim().isNotEmpty) {
      return translatedMoral;
    }
    return story.lesson;
  }

  Future<void> _toggleLike() async {
    final prevLiked = _isLiked;
    final prevLikes = _likes;
    setState(() {
      _isLiked = !_isLiked;
      _likes = _isLiked ? _likes + 1 : _likes - 1;
    });
    try {
      if (_isLiked) {
        await SupabaseService.client.rpc(
          'increment_story_likes',
          params: {'story_id': widget.story.id},
        );
      } else {
        await SupabaseService.client.rpc(
          'decrement_story_likes',
          params: {'story_id': widget.story.id},
        );
      }
    } catch (e) {
      setState(() {
        _isLiked = prevLiked;
        _likes = prevLikes;
      });
      talker.error('Error toggling like', e);
    }
  }

  void _showReportDialog(Story story) {
    if (_isStoryOwnedByCurrentUser(story)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You cannot report your own story.')),
      );
      return;
    }

    final reasonController = TextEditingController();
    String selectedReason = 'Inappropriate content';
    final List<String> presetReasons = [
      'Inappropriate content',
      'Spam or misleading',
      'Plagiarism or copyright issue',
      'Hate speech or harassment',
      'Other',
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Report Story'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Please select a reason for reporting:'),
                  const SizedBox(height: 8),
                  ...presetReasons.map((reason) {
                    return RadioListTile<String>(
                      title: Text(reason),
                      value: reason,
                      groupValue: selectedReason,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() => selectedReason = value);
                        }
                      },
                    );
                  }),
                  if (selectedReason == 'Other') ...[
                    const SizedBox(height: 8),
                    TextField(
                      controller: reasonController,
                      decoration: const InputDecoration(
                        hintText: 'Please provide details...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  final finalReason = selectedReason == 'Other'
                      ? reasonController.text.trim()
                      : selectedReason;

                  if (selectedReason == 'Other' && finalReason.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please provide details for the report'),
                      ),
                    );
                    return;
                  }

                  Navigator.pop(context);
                  try {
                    await SupabaseService.client.from('story_reports').insert({
                      'story_id': story.id,
                      'reporter_id':
                          SupabaseService.client.auth.currentUser?.id,
                      'reason': finalReason,
                    });
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Report submitted successfully'),
                        ),
                      );
                    }
                  } catch (e) {
                    talker.error('Error reporting story', e);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to submit report'),
                        ),
                      );
                    }
                  }
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    selectedCharacterController.dispose();
    _detailBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocConsumer<StoryDetailBloc, StoryDetailState>(
      bloc: _detailBloc,
      listenWhen: (prev, curr) => prev.errorMessage != curr.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: theme.colorScheme.error,
              action: SnackBarAction(
                label: Translations.of(context).common.dismiss,
                textColor: theme.colorScheme.onError,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final story = state.story;

        if (story == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final canUseStoryInsights = _isStoryOwnedByCurrentUser(story);

        return Scaffold(
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    gradient:
                        theme
                            .extension<GradientExtension>()
                            ?.screenBackgroundGradient ??
                        LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDark
                              ? [
                                  theme.colorScheme.surface,
                                  theme.colorScheme.surface.withValues(
                                    alpha: 0.95,
                                  ),
                                  theme.colorScheme.surfaceContainerHigh,
                                ]
                              : [
                                  theme.colorScheme.surface,
                                  theme.colorScheme.surfaceContainerLow
                                      .withValues(alpha: 0.5),
                                  theme.colorScheme.surfaceContainerHigh,
                                ],
                          stops: const [0.0, 0.4, 1.0],
                        ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header — solid bar (no gradient) so it stays sharp above the image
                      SafeArea(
                        bottom: false,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            border: Border(
                              bottom: BorderSide(
                                color: theme.colorScheme.outlineVariant
                                    .withValues(alpha: 0.35),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios_rounded,
                                  color: theme.colorScheme.onSurface,
                                ),
                                onPressed: () => context.pop(),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: Icon(
                                  Icons.auto_awesome,
                                  color: theme.colorScheme.onSurface,
                                ),
                                tooltip: Translations.of(
                                  context,
                                ).storyGenerator.title,
                                onPressed: () {
                                  StoryGeneratorRoute().push(context);
                                },
                              ),
                              if (!_isStoryOwnedByCurrentUser(story))
                                IconButton(
                                  icon: Icon(
                                    Icons.report_problem_outlined,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                  onPressed: () => _showReportDialog(story),
                                ),
                              IconButton(
                                icon: Icon(
                                  story.isFavorite
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color: theme.colorScheme.onSurface,
                                ),
                                tooltip: Translations.of(
                                  context,
                                ).storyGenerator.saveStory,
                                onPressed: () => _detailBloc.add(
                                  const StoryDetailToggleFavorite(),
                                ),
                              ),
                              PopupMenuButton<String>(
                                icon: Icon(
                                  Icons.share,
                                  color: theme.colorScheme.onSurface,
                                ),
                                tooltip: Translations.of(
                                  context,
                                ).storyGenerator.shareStory,
                                onSelected: (value) async {
                                  if (value == 'share_to_feed') {
                                    showShareToFeedDialog(
                                      context: context,
                                      story: story,
                                      selectedLanguage: state.selectedLanguage,
                                    );
                                  } else if (value == 'share_to_chat') {
                                    await _shareStoryToChat(story, state);
                                  } else if (value == 'share_outside') {
                                    _shareStory(story, state);
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'share_to_feed',
                                    child: Row(
                                      children: [
                                        const Icon(Icons.feed_outlined),
                                        const SizedBox(width: 12),
                                        Text(
                                          Translations.of(
                                            context,
                                          ).homeScreen.shareToFeed,
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'share_to_chat',
                                    child: Row(
                                      children: [
                                        const Icon(Icons.send_rounded),
                                        const SizedBox(width: 12),
                                        Text('Share to chat'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'share_outside',
                                    child: Row(
                                      children: [
                                        const Icon(Icons.share_outlined),
                                        const SizedBox(width: 12),
                                        Text('Share outside the app'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Story image with overlay
                      Stack(
                        children: [
                          Container(
                            width: screenSize.width,
                            height: screenSize.height * 0.4,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  blurRadius: 100,
                                  spreadRadius: 0,
                                  offset: const Offset(0, -6),
                                ),
                              ],
                            ),
                            child: _buildStoryImage(story, state),
                          ),
                          Container(
                            width: screenSize.width,
                            height: screenSize.height * 0.4,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.9),
                                  Colors.black.withValues(alpha: 0.4),
                                  Colors.transparent,
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: _buildStoryMetadata(
                              story,
                              screenSize,
                              theme,
                              isDark,
                              state,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: screenSize.height * 0.024),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Divider(
                          color: theme.colorScheme.outlineVariant.withValues(
                            alpha: 0.5,
                          ),
                          thickness: 1,
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.02),

                      // Story content (Chapters)
                      _buildStoryContent(state, screenSize, theme),

                      SizedBox(height: screenSize.height * 0.02),

                      // Language/Translation selector - only for self-generated stories
                      if (canUseStoryInsights) ...[
                        _buildLanguageSelector(state, theme, isDark),
                        SizedBox(height: screenSize.height * 0.02),
                      ],

                      // Story Insights & Interactions
                      if (canUseStoryInsights) ...[
                        _buildStoryInsightsSection(
                          context,
                          state,
                          theme,
                          isDark,
                          screenSize,
                        ),
                        SizedBox(height: screenSize.height * 0.12),
                      ] else
                        SizedBox(height: screenSize.height * 0.06),
                    ],
                  ),
                ),
              ),
              if (!(state.isRegenerating || state.isTranslating))
                Positioned(
                  bottom: 15,
                  left: 0,
                  right: 0,
                  child: _buildBottomActionButtons(state, story, theme, isDark),
                ),
              if (state.isRegenerating)
                const GeneratingOverlay(message: "Regenerating your story..."),
              if (state.isTranslating)
                const GeneratingOverlay(message: "Translating your story..."),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStoryImage(Story story, StoryDetailState state) {
    if (state.isGeneratingImage) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text(
              "Painting your story...",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    // Natively use StoryImage which will render the shimmer gradient if imageUrl is null
    return StoryImage(
      imageUrl: story.imageUrl,
      fit: BoxFit.cover,
      memCacheWidth: 1200,
      memCacheHeight: 1200,
    );
  }

  Widget _buildStoryMetadata(
    Story story,
    Size screenSize,
    ThemeData theme,
    bool isDark,
    StoryDetailState state,
  ) {
    return Container(
      width: screenSize.width,
      constraints: BoxConstraints(minHeight: screenSize.height * 0.35),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (story.attributes.storyType.isNotEmpty)
                Chip(
                  label: Text(story.attributes.storyType),
                  labelStyle: theme.textTheme.labelSmall,
                  visualDensity: VisualDensity.compact,
                  color: WidgetStatePropertyAll(
                    isDark ? const Color(0xFF111111) : const Color(0xFFF5F5F5),
                  ),
                ),
              SizedBox(width: screenSize.width * 0.02),
              if (story.attributes.theme.isNotEmpty)
                Chip(
                  label: Text(story.attributes.theme),
                  labelStyle: theme.textTheme.labelSmall,
                  visualDensity: VisualDensity.compact,
                  color: WidgetStatePropertyAll(
                    isDark ? const Color(0xFF111111) : const Color(0xFFF5F5F5),
                  ),
                ),
            ],
          ),
          Text(
            _resolveStoryTitle(story, state),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: (theme.textTheme.headlineMedium?.fontSize ?? 28) * 0.88,
            ),
          ),
          SizedBox(height: screenSize.height * 0.005),
          if (story.scripture.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.15)
                    : Colors.black.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.menu_book_rounded,
                    size: 16,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      story.scripture,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (story.scripture.isNotEmpty)
            SizedBox(height: screenSize.height * 0.005),
          SizedBox(height: screenSize.height * 0.005),
          if ((story.authorUser?.id ?? story.authorId) != null)
            GestureDetector(
              onTap: () {
                final userId = story.authorUser?.id ?? story.authorId;
                if (userId != null) ProfileRoute(userId: userId).push(context);
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  Text(
                    "By ${story.authorUser?.displayName ?? story.author ?? 'MyItihas AI'}",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          else
            Row(
              children: [
                Text(
                  "By ${story.authorUser?.displayName ?? story.author ?? 'MyItihas AI'}",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStoryContent(
    StoryDetailState state,
    Size screenSize,
    ThemeData theme,
  ) {
    final story = state.story!;
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final contentBg = isDark ? const Color(0xFF131313) : const Color(0xFFFFFFFF);
    final contentBorder = isDark
      ? const Color(0xFF2C2C2C)
      : const Color(0xFFE1E1E1);
    final chaptersToShow = state.chapters.take(state.visibleChapters).toList();
    final selectedCode = LanguageVoiceResolver.languageCodeFromAny(
      state.selectedLanguage,
    );
    final translatedTrivia =
        story.attributes.translations[selectedCode]?.trivia;
    final displayTrivia =
        (translatedTrivia != null && translatedTrivia.isNotEmpty)
        ? translatedTrivia
        : story.trivia;
    final displayMoral = _resolveStoryMoral(story, state);

    return Column(
      children: [
        // Chapters list - story content area
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < chaptersToShow.length; i++) ...[
                _buildChapterCard(
                  chapter: chaptersToShow[i],
                  theme: theme,
                  contentBg: contentBg,
                  contentBorder: contentBorder,
                  isLastVisible: i == chaptersToShow.length - 1,
                  canReadMore: true,
                  numberOfChapters: state.chapters.length,
                ),
                SizedBox(height: screenSize.height * 0.024),
              ],
            ],
          ),
        ),

        // Trivia section (use translated trivia when available)
        if (displayTrivia.isNotEmpty) ...[
          SizedBox(height: screenSize.height * 0.028),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              decoration: BoxDecoration(
                color: contentBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: contentBorder, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.lightbulb_outline_rounded,
                          size: 22,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Trivia',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  AppMarkdownBody(
                    data: displayTrivia,
                    selectable: true,
                  ),
                ],
              ),
            ),
          ),
        ],

        // Lesson section
        if (displayMoral.isNotEmpty) ...[
          SizedBox(height: screenSize.height * 0.028),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              decoration: BoxDecoration(
                color: contentBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: contentBorder, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.school_rounded,
                          size: 22,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Moral',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  AppMarkdownBody(
                    data: displayMoral,
                    selectable: true,
                  ),
                ],
              ),
            ),
          ),
        ],

        if (story.attributes.references.isNotEmpty) ...[
          SizedBox(height: screenSize.height * 0.024),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Divider(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              thickness: 1,
            ),
          ),
          SizedBox(height: screenSize.height * 0.016),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: story.attributes.references[0],
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],

        SizedBox(height: screenSize.height * 0.028),
      ],
    );
  }

  Widget _buildChapterCard({
    required StoryChapter chapter,
    required ThemeData theme,
    required Color contentBg,
    required Color contentBorder,
    required bool isLastVisible,
    required bool canReadMore,
    required int numberOfChapters,
  }) {
    final screenSize = MediaQuery.of(context).size;
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: BoxDecoration(
        color: contentBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: contentBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (numberOfChapters > 1) ...[
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.auto_stories_rounded,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    chapter.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenSize.height * 0.016),
          ],
          if (numberOfChapters == 1)
            ExpandableMarkdown(
              data: chapter.content,
              maxCollapsedLength: 500,
              showDropCap: false,
              readMoreText: 'read more',
              readLessText: 'read less',
              selectable: true,
              styleSheetOverride: ChatMessageTypography.storyChapterBodyMarkdown(
                colorScheme,
              ),
              toggleButtonStyle: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          if (numberOfChapters != 1)
            ExpandableMarkdown(
              data: chapter.content,
              maxCollapsedLength: 500,
              showDropCap: false,
              readMoreText: 'read more',
              readLessText: 'read less',
              selectable: true,
              styleSheetOverride: ChatMessageTypography.storyChapterBodyMarkdown(
                colorScheme,
              ),
              toggleButtonStyle: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(
    StoryDetailState state,
    ThemeData theme,
    bool isDark,
  ) {
    final gradients = theme.extension<GradientExtension>();
    final colorScheme = theme.colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color:
            gradients?.glassCardBackground ??
            colorScheme.surface.withValues(alpha: isDark ? 0.6 : 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              gradients?.glassCardBorder ??
              colorScheme.primary.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.translate, size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Text(
                'Translation',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          DropdownButton<String>(
            value: state.selectedLanguage,
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: theme.colorScheme.primary,
            ),
            underline: const SizedBox(),
            borderRadius: BorderRadius.circular(15),
            dropdownColor: isDark ? const Color(0xFF111111) : Colors.white,
            items: languages.map((lang) {
              return DropdownMenuItem<String>(
                value: lang['name'],
                child: Text(lang['name']!, style: theme.textTheme.bodyMedium),
              );
            }).toList(),
            onChanged: state.isTranslating
                ? null
                : (String? newValue) {
                    if (newValue != null) {
                      _detailBloc.add(StoryDetailLanguageChanged(newValue));
                    }
                  },
          ),
        ],
      ),
    );
  }

  Widget _buildStoryInsightsSection(
    BuildContext context,
    StoryDetailState state,
    ThemeData theme,
    bool isDark,
    Size screenSize,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111111) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : const Color(0xFFE2E8F0),
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withValues(alpha: 0.2),
        //     blurRadius: 20,
        //     offset: const Offset(0, 10),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Story Insights & Interactions',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenSize.height * 0.02),
          _buildInsightCard(
            theme: theme,
            isDark: isDark,
            icon: Icons.zoom_out_map_rounded,
            title: 'Expand Story',
            description:
                'Continue the narrative with the next chapter of your tale',
            buttonText: state.isExpanding ? 'Continuing...' : 'Continue Story',
            onTap: state.isExpanding
                ? null
                : () => _detailBloc.add(const StoryDetailReadMorePressed()),
            screenSize: screenSize,
          ),
          SizedBox(height: screenSize.height * 0.02),
          _buildCharacterDetailsCard(
            state: state,
            theme: theme,
            isDark: isDark,
            screenSize: screenSize,
            context: context,
          ),
          SizedBox(height: screenSize.height * 0.02),
          _buildInsightCard(
            theme: theme,
            isDark: isDark,
            icon: Icons.forum_rounded,
            title: 'Discuss Story',
            description: 'Chat about themes, meanings, and interpretations',
            buttonText: 'Start Discussion',
            onTap: () => _openDiscussStoryBottomSheet(
              context,
              theme: theme,
              isDark: isDark,
            ),
            screenSize: screenSize,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard({
    required ThemeData theme,
    required bool isDark,
    required IconData icon,
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback? onTap,
    required Size screenSize,
    bool showDropdown = false,
  }) {
    final story = _detailBloc.state.story;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF020617).withValues(alpha: 0.5)
            : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 32, color: const Color(0xFFA78BFA)),
          SizedBox(height: screenSize.height * 0.01),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenSize.height * 0.005),
          Text(
            description,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.5)
                  : Colors.black.withValues(alpha: 0.5),
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: screenSize.height * 0.01),
          if (showDropdown && story != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: isDark ? Colors.black26 : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.1),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text(
                    'Select character',
                    style: theme.textTheme.bodySmall,
                  ),
                  iconSize: 18,
                  value: null,
                  items: story.attributes.characters.map((char) {
                    return DropdownMenuItem<String>(
                      value: char,
                      child: Text(char, style: theme.textTheme.bodySmall),
                    );
                  }).toList(),
                  onChanged: (_) {},
                ),
              ),
            ),
            SizedBox(height: screenSize.height * 0.01),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              height: screenSize.height * 0.05,
              decoration: BoxDecoration(
                color: isDark ? Colors.black26 : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.1),
                ),
              ),
              alignment: Alignment.center,
              child: TextField(
                decoration: InputDecoration(
                  fillColor: Colors.transparent,
                  hintText: 'Or enter character',
                  hintStyle: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                  border: InputBorder.none,
                  isDense: true,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                ),
                style: theme.textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 12),
          ],
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00B4DB), Color(0xFF9055FF)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: Text(
                buttonText,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterDetailsCard({
    required BuildContext context,
    required StoryDetailState state,
    required ThemeData theme,
    required bool isDark,
    required Size screenSize,
  }) {
    final story = state.story;
    final characters = story?.attributes.characters ?? const <String>[];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF020617).withValues(alpha: 0.5)
            : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.person_pin_rounded,
            size: 32,
            color: Color(0xFFA78BFA),
          ),
          SizedBox(height: screenSize.height * 0.005),
          Text(
            'Character Details',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: screenSize.height * 0.01),
          Text(
            'Explore the personalities and roles of story characters',
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.5)
                  : Colors.black.withValues(alpha: 0.5),
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: screenSize.height * 0.01),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: isDark ? Colors.black26 : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.1),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: Text(
                  'Select character',
                  style: theme.textTheme.bodySmall,
                ),
                iconSize: 18,
                value: selectedCharacter,
                items: characters.map((char) {
                  return DropdownMenuItem<String>(
                    value: char,
                    child: Text(char, style: theme.textTheme.bodySmall),
                  );
                }).toList(),
                onChanged: (char) {
                  setState(() {
                    selectedCharacter = char;
                    selectedCharacterController.text = char ?? '';
                  });
                },
              ),
            ),
          ),
          SizedBox(height: screenSize.height * 0.01),
          Container(
            height: screenSize.height * 0.06,
            decoration: BoxDecoration(
              color: isDark ? Colors.black26 : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.1),
              ),
            ),
            alignment: Alignment.center,
            child: TextField(
              controller: selectedCharacterController,
              decoration: InputDecoration(
                fillColor: Colors.transparent,
                hintText: 'Or enter character',
                suffixIcon: VoiceInputButton(
                  controller: selectedCharacterController,
                  compact: true,
                ),
                hintStyle: theme.textTheme.bodySmall,
                border: InputBorder.none,
                isDense: true,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
              ),
              autofocus: false,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.left,
              textAlignVertical: TextAlignVertical.center,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00B4DB), Color(0xFF9055FF)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ElevatedButton(
              onPressed:
                  (selectedCharacter != null ||
                      selectedCharacterController.text.isNotEmpty)
                  ? () => _openCharacterDetailsBottomSheet(
                      context,
                      characterName:
                          selectedCharacter ?? selectedCharacterController.text,
                      theme: theme,
                      isDark: isDark,
                    )
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: Text(
                'Get Character Details',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openCharacterDetailsBottomSheet(
    BuildContext context, {
    required String characterName,
    required ThemeData theme,
    required bool isDark,
  }) async {
    final story = _detailBloc.state.story;
    if (story == null || !_isStoryOwnedByCurrentUser(story)) return;
    HapticFeedback.lightImpact();
    _detailBloc.add(StoryDetailCharacterDetailsRequested(characterName));

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return BlocProvider.value(
          value: _detailBloc,
          child: _CharacterDetailsBottomSheet(isDark: isDark, theme: theme),
        );
      },
    );

    if (mounted) {
      _detailBloc.add(const StoryDetailCharacterDetailsClosed());
    }
  }

  Future<void> _openDiscussStoryBottomSheet(
    BuildContext context, {
    required ThemeData theme,
    required bool isDark,
  }) async {
    final story = _detailBloc.state.story;
    if (story == null || !_isStoryOwnedByCurrentUser(story)) return;
    HapticFeedback.lightImpact();
    _detailBloc.add(const StoryDetailChatOpened());

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return BlocProvider.value(
          value: _detailBloc,
          child: _DiscussStoryBottomSheet(isDark: isDark, theme: theme),
        );
      },
    );

    if (mounted) {
      _detailBloc.add(const StoryDetailChatClosed());
    }
  }

  Widget _buildBottomActionButtons(
    StoryDetailState state,
    Story story,
    ThemeData theme,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF0B1220).withValues(alpha: 0.85)
              : Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.12)
                : Colors.black.withValues(alpha: 0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionButton(
              "Regenerate story",
              Icons.refresh_rounded,
              () => _detailBloc.add(const StoryDetailRegenerateRequested()),
              isDark,
              isSelected: state.isRegenerating,
            ),
            _buildActionButton("Copy story", Icons.content_copy_rounded, () {
              final completeStory =
                  '''
${story.title}

${story.story}

---
${story.quotes}

Generated with MyItihas - Discover Indian Scriptures
                ''';
              Clipboard.setData(ClipboardData(text: completeStory));
            }, isDark),
            _buildActionButton(
              "Download story",
              Icons.download_rounded,
              () async {
                if (state.isDownloading) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Downloading for offline...')),
                );
                await DownloadedStoriesService().saveStory(story);
                if (mounted) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Story downloaded to your device!'),
                    ),
                  );
                }
              },
              isDark,
            ),
            _buildActionButton(
              _isLiked ? "Unlike story" : "Like story",
              _isLiked
                  ? Icons.favorite_rounded
                  : Icons.favorite_outline_rounded,
              _toggleLike,
              isDark,
              isSelected: _isLiked,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String buttonName,
    IconData icon,
    VoidCallback onTap,
    bool isDark, {
    bool isSelected = false,
  }) {
    return Tooltip(
      message: buttonName,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark
                      ? Colors.white.withValues(alpha: 0.15)
                      : Colors.black.withValues(alpha: 0.1))
                : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.3),
            ),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  void _shareStory(Story story, StoryDetailState state) {
    HapticFeedback.lightImpact();
    final shareTitle = _resolveStoryTitle(story, state);
    final fullContent = state.chapters.isNotEmpty
        ? state.chapters
              .map(
                (c) =>
                    (state.chapters.length > 1 ? '${c.title}\n\n' : '') +
                    c.content,
              )
              .join('\n\n')
        : story.story;
    final shareText =
        '''
$shareTitle

$fullContent

---
${story.quotes}

Generated with MyItihas - Discover Indian Scriptures
''';

    SharePlus.instance.share(ShareParams(text: shareText, title: shareTitle));
  }

  Future<void> _shareStoryToChat(Story story, StoryDetailState state) async {
    if (!mounted) return;
    final conversationId = await ShareToConversationSheet.show(context);
    if (conversationId == null || !mounted) return;

    final shareTitle = _resolveStoryTitle(story, state);

    final chatService = getIt<ChatService>();
    try {
      await chatService.sendMessage(
        conversationId: conversationId,
        content: 'Shared a story: $shareTitle',
        type: 'story',
        sharedContentId: story.id,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Story shared to chat'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to share story: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

class _CharacterDetailsBottomSheet extends StatelessWidget {
  final bool isDark;
  final ThemeData theme;

  const _CharacterDetailsBottomSheet({
    required this.isDark,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xFF0B1220) : Colors.white;
    final Size screenSize = MediaQuery.of(context).size;

    return DraggableScrollableSheet(
      initialChildSize: 0.78,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.08),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 25,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: BlocBuilder<StoryDetailBloc, StoryDetailState>(
            builder: (context, state) {
              final details = state.selectedCharacterDetails;
              final title =
                  (details?['name'] ??
                          state.selectedCharacterName ??
                          'Character')
                      .toString();

              return Column(
                children: [
                  SizedBox(height: screenSize.height * 0.015),
                  Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.2)
                          : Colors.black.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.015),
                  Text(
                    "$title's Character Details",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF00B4DB),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenSize.height * 0.02),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: _buildBody(
                        context,
                        state,
                        details,
                        scrollController,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    StoryDetailState state,
    Map<String, dynamic>? details,
    ScrollController scrollController,
  ) {
    final Size screenSize = MediaQuery.of(context).size;
    if (state.isFetchingCharacter) {
      return Center(
        child: Column(
          children: [
            SizedBox(height: screenSize.height * 0.2),
            Center(child: CircularProgressIndicator()),
            SizedBox(height: screenSize.height * 0.05),
            Center(child: Text('Loading character details...')),
          ],
        ),
      );
    }

    if ((details == null) || (details.length == 2)) {
      return Center(
        child: Column(
          children: [
            Text(
              state.errorMessage ?? 'Select a character to view details.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final appearance = (details['appearance'] ?? '').toString();
    final role = (details['role'] ?? '').toString();
    final scripture = (details['scripture_background'] ?? '').toString();

    final traits =
        (details['personality_traits'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
        const <String>[];
    final actions =
        (details['key_actions'] as List?)?.map((e) => e.toString()).toList() ??
        const <String>[];
    final divine =
        (details['divine_attributes'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
        const <String>[];
    final relationships =
        (details['relationships'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
        const <String>[];

    return ListView(
      controller: scrollController,
      children: [
        if (appearance.isNotEmpty)
          _InfoCard(
            isDark: isDark,
            theme: theme,
            icon: Icons.remove_red_eye_outlined,
            title: 'Appearance',
            child: Text(appearance, style: theme.textTheme.bodyMedium),
          ),
        SizedBox(height: screenSize.height * 0.01),
        if (traits.isNotEmpty)
          _ListCard(
            isDark: isDark,
            theme: theme,
            icon: Icons.favorite_rounded,
            title: 'Personality Traits',
            items: traits,
          ),
        if (traits.isNotEmpty) SizedBox(height: screenSize.height * 0.01),
        if (actions.isNotEmpty)
          _ListCard(
            isDark: isDark,
            theme: theme,
            icon: Icons.star_rounded,
            title: 'Key Actions in the Story',
            items: actions,
          ),
        if (actions.isNotEmpty) SizedBox(height: screenSize.height * 0.01),
        if (role.isNotEmpty)
          _InfoCard(
            isDark: isDark,
            theme: theme,
            icon: Icons.theater_comedy_rounded,
            title: 'Role in the Narrative',
            child: Text(role, style: theme.textTheme.bodyMedium),
          ),
        if (role.isNotEmpty) SizedBox(height: screenSize.height * 0.01),
        if (scripture.isNotEmpty)
          _InfoCard(
            isDark: isDark,
            theme: theme,
            icon: Icons.menu_book_rounded,
            title: 'Scripture Background',
            child: Text(scripture, style: theme.textTheme.bodyMedium),
          ),
        if (scripture.isNotEmpty) SizedBox(height: screenSize.height * 0.01),
        if (divine.isNotEmpty)
          _ListCard(
            isDark: isDark,
            theme: theme,
            icon: Icons.auto_awesome_rounded,
            title: 'Divine Attributes',
            items: divine,
          ),
        if (divine.isNotEmpty) SizedBox(height: screenSize.height * 0.01),
        if (relationships.isNotEmpty)
          _ListCard(
            isDark: isDark,
            theme: theme,
            icon: Icons.link_rounded,
            title: 'Relationships',
            items: relationships,
          ),
        SizedBox(height: screenSize.height * 0.02),
      ],
    );
  }
}

class _DiscussStoryBottomSheet extends StatefulWidget {
  final bool isDark;
  final ThemeData theme;

  const _DiscussStoryBottomSheet({required this.isDark, required this.theme});

  @override
  State<_DiscussStoryBottomSheet> createState() =>
      _DiscussStoryBottomSheetState();
}

class _DiscussStoryBottomSheetState extends State<_DiscussStoryBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _send(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    context.read<StoryDetailBloc>().add(StoryDetailChatMessageSubmitted(text));
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final Color bg = widget.isDark ? const Color(0xFF0B1220) : Colors.white;
    final Size screenSize = MediaQuery.of(context).size;
    return DraggableScrollableSheet(
      initialChildSize: 0.78,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            border: Border.all(
              color: widget.isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.08),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 25,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            child: BlocBuilder<StoryDetailBloc, StoryDetailState>(
              builder: (context, state) {
                final conv = state.chatConversation;
                final messages = conv?.messages ?? const [];

                return Column(
                  children: [
                    SizedBox(height: screenSize.height * 0.015),
                    Container(
                      width: 42,
                      height: 5,
                      decoration: BoxDecoration(
                        color: widget.isDark
                            ? Colors.white.withValues(alpha: 0.2)
                            : Colors.black.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.015),
                    Text(
                      'Discuss Story',
                      style: widget.theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF00B4DB),
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.02),

                    if (state.chatError != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: _ChatErrorBanner(
                          isDark: widget.isDark,
                          theme: widget.theme,
                          text: state.chatError!,
                        ),
                      ),

                    Expanded(
                      child: state.isChatLoading && conv == null
                          ? ListView(
                              controller: scrollController,
                              children: [
                                SizedBox(height: screenSize.height * 0.2),
                                Center(child: CircularProgressIndicator()),
                                SizedBox(height: screenSize.height * 0.05),
                                Center(child: Text('Loading discussion...')),
                              ],
                            )
                          : ListView.builder(
                              controller: scrollController,
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              itemCount:
                                  messages.length +
                                  (state.isChatSending ? 1 : 0),
                              itemBuilder: (context, index) {
                                // typing indicator
                                if (state.isChatSending &&
                                    index == messages.length) {
                                  return _ChatBubble(
                                    isDark: widget.isDark,
                                    theme: widget.theme,
                                    isUser: false,
                                    text: '...',
                                    isTyping: true,
                                  );
                                }

                                final m = messages[index];
                                final isUser = m.sender.toLowerCase() == 'user';
                                return _ChatBubble(
                                  isDark: widget.isDark,
                                  theme: widget.theme,
                                  isUser: isUser,
                                  text: m.text,
                                );
                              },
                            ),
                    ),

                    _ChatComposer(
                      isDark: widget.isDark,
                      theme: widget.theme,
                      controller: _controller,
                      focusNode: _focusNode,
                      isSending: state.isChatSending,
                      onSend: () => _send(context),
                      onSubmitted: () => _send(context),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _ChatComposer extends StatelessWidget {
  final bool isDark;
  final ThemeData theme;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isSending;
  final VoidCallback onSend;
  final VoidCallback onSubmitted;

  const _ChatComposer({
    required this.isDark,
    required this.theme,
    required this.controller,
    required this.focusNode,
    required this.isSending,
    required this.onSend,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final border = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.08);

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      top: false,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: border)),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 6,
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    textInputAction: TextInputAction.send,
                    minLines: 1,
                    maxLines: 4,
                    onSubmitted: (_) => onSubmitted(),

                    scrollPadding: EdgeInsets.only(bottom: bottomInset + 80),

                    decoration: InputDecoration(
                      hintText: 'Ask about the story...',
                      suffixIcon: VoiceInputButton(
                        controller: controller,
                        compact: true,
                      ),
                      hintStyle: theme.textTheme.bodySmall?.copyWith(
                        color: theme.secondaryHeaderColor,
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.zero),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.zero),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.zero),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  width: 50,
                  child: GestureDetector(
                    onTap: isSending ? null : onSend,
                    child: Container(
                      height: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00B4DB), Color(0xFF9055FF)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: isSending
                            ? const SizedBox(
                                width: 23,
                                height: 23,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 23,
                              ),
                      ),
                    ),
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

class _ChatBubble extends StatelessWidget {
  final bool isDark;
  final ThemeData theme;
  final bool isUser;
  final String text;
  final bool isTyping;

  const _ChatBubble({
    required this.isDark,
    required this.theme,
    required this.isUser,
    required this.text,
    this.isTyping = false,
  });

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.78;

    final userGradient = const LinearGradient(
      colors: [Color(0xFF00B4DB), Color(0xFF9055FF)],
    );

    final botColor = isDark ? const Color(0xFF111C33) : const Color(0xFFF1F5F9);

    final bubble = Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: isUser ? userGradient : null,
        color: isUser ? null : botColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isUser
              ? Colors.white.withValues(alpha: 0.10)
              : (isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.black.withValues(alpha: 0.06)),
        ),
      ),
      child: isTyping
          ? Text(
              text,
              style: ChatMessageTypography.bodyStyle(
                color: isUser
                    ? Colors.white
                    : (isDark
                          ? const Color(0xFFB8C0D4)
                          : theme.colorScheme.onSurfaceVariant),
              ).copyWith(fontStyle: FontStyle.italic),
            )
          : isUser
          ? SanitizedMarkdown(
              data: text,
              selectable: true,
              styleSheetOverride:
                  ChatMessageTypography.storyUserBubbleMarkdownGradient(),
            )
          : AppMarkdownBody(
              data: text,
              selectable: true,
              styleSheetOverride:
                  ChatMessageTypography.storyBotBubbleMarkdown(isDark: isDark),
            ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: bubble,
      ),
    );
  }
}

class _ChatErrorBanner extends StatelessWidget {
  final bool isDark;
  final ThemeData theme;
  final String text;

  const _ChatErrorBanner({
    required this.isDark,
    required this.theme,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.red.withValues(alpha: 0.12)
            : Colors.red.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.red.withValues(alpha: 0.25)
              : Colors.red.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, size: 18, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark ? Colors.red[200] : Colors.red[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final bool isDark;
  final ThemeData theme;
  final IconData icon;
  final String title;
  final Widget child;

  const _InfoCard({
    required this.isDark,
    required this.theme,
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111111) : const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF00B4DB)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF00B4DB),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenSize.height * 0.01),
          child,
        ],
      ),
    );
  }
}

class _ListCard extends StatelessWidget {
  final bool isDark;
  final ThemeData theme;
  final IconData icon;
  final String title;
  final List<String> items;

  const _ListCard({
    required this.isDark,
    required this.theme,
    required this.icon,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      isDark: isDark,
      theme: theme,
      icon: icon,
      title: title,
      child: Column(
        children: [
          for (final item in items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Icon(
                    Icons.chevron_right_rounded,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(item, style: theme.textTheme.bodyMedium),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

int estimateReadingTimeMinutes(String text, {int wordsPerMinute = 150}) {
  if (text.trim().isEmpty || wordsPerMinute <= 0) {
    return 0;
  }

  final words = text.trim().split(RegExp(r'\s+'));
  final wordCount = words.length;

  return (wordCount / wordsPerMinute).ceil();
}
