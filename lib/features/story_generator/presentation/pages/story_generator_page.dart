import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/core/navigation/home_back_stack.dart';
import 'package:myitihas/core/presentation/widgets/require_online_or_notify.dart';
import 'package:myitihas/features/story_generator/domain/entities/generator_options.dart';
import 'package:myitihas/features/story_generator/domain/entities/quick_prompt.dart';
import 'package:myitihas/features/story_generator/presentation/bloc/story_generator_bloc.dart';
import 'package:myitihas/features/story_generator/presentation/widgets/history_bottom_sheet.dart';
import 'package:myitihas/features/story_generator/presentation/widgets/widgets.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/utils/constants.dart';

/// Main page for the Story Generator feature
class StoryGeneratorPage extends StatelessWidget {
  final String? initialPrompt;
  final String? initialLanguageCode;

  const StoryGeneratorPage({
    super.key,
    this.initialPrompt,
    this.initialLanguageCode,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = getIt<StoryGeneratorBloc>()
          ..add(StoryGeneratorEvent.initialize(initialPrompt: initialPrompt));
        if (initialLanguageCode != null) {
          final lang = StoryLanguage.values.cast<StoryLanguage?>().firstWhere(
            (l) => l!.code == initialLanguageCode,
            orElse: () => null,
          );
          if (lang != null) {
            bloc.add(
              StoryGeneratorEvent.updateGeneratorOptions(
                language: lang,
                format: null,
                length: null,
              ),
            );
          }
        }
        return bloc;
      },
      child: _StoryGeneratorView(
        initialPrompt: initialPrompt,
        initialLanguageCode: initialLanguageCode,
      ),
    );
  }
}

class _StoryGeneratorView extends StatefulWidget {
  final String? initialPrompt;
  final String? initialLanguageCode;

  const _StoryGeneratorView({this.initialPrompt, this.initialLanguageCode});

  @override
  State<_StoryGeneratorView> createState() => _StoryGeneratorViewState();
}

class _StoryGeneratorViewState extends State<_StoryGeneratorView> {
  late List<QuickPrompt> _quickPrompts;
  int _carouselRefreshKey = 0;
  final FocusNode _rawPromptFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Shuffle and select 5 random prompts only once when page loads
    _quickPrompts = (List.of(
      QuickPrompt.defaultPrompts,
    )..shuffle()).take(5).toList();

    if (widget.initialPrompt != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _rawPromptFocusNode.requestFocus();
        }
      });
    }
  }

  @override
  void dispose() {
    _rawPromptFocusNode.dispose();
    super.dispose();
  }

  void _onSwitchToKeyboard() {
    final bloc = context.read<StoryGeneratorBloc>();
    final state = bloc.state;
    if (!state.isRawPromptMode) {
      bloc.add(const StoryGeneratorEvent.togglePromptType(isRawPrompt: true));
    }
    Future.microtask(() => _rawPromptFocusNode.requestFocus());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final t = Translations.of(context);

    return BlocConsumer<StoryGeneratorBloc, StoryGeneratorState>(
      listener: (context, state) {
        // Navigate to generated story page when story is ready
        if (state.generatedStory != null && !state.isGenerating) {
          // Schedule navigation after the current build cycle completes
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              GeneratedStoryResultRoute($extra: state.generatedStory!).go(context);
            }
          });
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.primary.withValues(alpha: 0.15),
                              colorScheme.secondary.withValues(alpha: 0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.auto_stories_rounded,
                          size: 18.sp,
                          color: colorScheme.primary,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        t.storyGenerator.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: colorScheme.onSurface,
                          fontSize: 18.sp,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                  centerTitle: true,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_rounded),
                    onPressed: () => HomeBackStack.goBackOrHome(context),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.history_rounded),
                      tooltip: 'History',
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        HistoryBottomSheet.show(context);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.refresh_rounded),
                      tooltip: 'Reset',
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        setState(() {
                          _quickPrompts = (List.of(
                            QuickPrompt.defaultPrompts,
                          )..shuffle()).take(5).toList();
                          _carouselRefreshKey++;
                        });
                        context.read<StoryGeneratorBloc>().add(
                          const StoryGeneratorEvent.reset(),
                        );
                      },
                    ),
                  ],
                ),
                body: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: isDark
                          ? [DarkColors.bgColor, DarkColors.bgColor]
                          : [
                              Colors.white,
                              colorScheme.primaryContainer.withValues(
                                alpha: 0.05,
                              ),
                            ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8.h),
                              // Quick prompts carousel
                              QuickPromptsCarousel(
                                key: ValueKey(_carouselRefreshKey),
                                prompts: _quickPrompts,
                                currentIndex: state.currentQuickPromptIndex,
                                onPromptSelected: (prompt) {
                                  context.read<StoryGeneratorBloc>().add(
                                    StoryGeneratorEvent.applyQuickPrompt(
                                      quickPrompt: prompt,
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 16.h),
                              // Prompt type toggle
                              PromptTypeToggle(
                                isRawPrompt: state.isRawPromptMode,
                                onToggle: (isRaw) {
                                  context.read<StoryGeneratorBloc>().add(
                                    StoryGeneratorEvent.togglePromptType(
                                      isRawPrompt: isRaw,
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 16.h),
                              // Interactive or Raw prompt view
                              if (state.isRawPromptMode)
                                RawPromptView(
                                  prompt: state.rawPrompt,
                                  focusNode: _rawPromptFocusNode,
                                  onPromptChanged: (text) {
                                    context.read<StoryGeneratorBloc>().add(
                                      StoryGeneratorEvent.updateRawPrompt(
                                        text: text,
                                      ),
                                    );
                                  },
                                  onScriptureTap: () => _showOptionSheet(
                                    context,
                                    'Select Scripture',
                                    'scripture',
                                    state.rawPrompt.scripture,
                                  ),
                                  onStoryTypeTap: () => _showOptionSheet(
                                    context,
                                    'Select Story Type',
                                    'storyType',
                                    state.rawPrompt.storyType,
                                  ),
                                  onThemeTap: () => _showOptionSheet(
                                    context,
                                    'Select Theme',
                                    'theme',
                                    state.rawPrompt.theme,
                                  ),
                                  onMainCharacterTap: () => _showOptionSheet(
                                    context,
                                    'Select Main Character',
                                    'mainCharacter',
                                    state.rawPrompt.mainCharacter,
                                  ),
                                  onSettingTap: () => _showOptionSheet(
                                    context,
                                    'Select Setting',
                                    'setting',
                                    state.rawPrompt.setting,
                                  ),
                                )
                              else
                                InteractivePromptView(
                                  prompt: state.interactivePrompt,
                                  isLoading: state.isLoadingOptions,
                                  onSpeakOptions: null,
                                  onScriptureTap: () => _showOptionSheet(
                                    context,
                                    'Select Scripture',
                                    'scripture',
                                    state.interactivePrompt.scripture,
                                  ),
                                  onStoryTypeTap: () => _showOptionSheet(
                                    context,
                                    'Select Story Type',
                                    'storyType',
                                    state.interactivePrompt.storyType,
                                  ),
                                  onThemeTap: () => _showOptionSheet(
                                    context,
                                    'Select Theme',
                                    'theme',
                                    state.interactivePrompt.theme,
                                  ),
                                  onMainCharacterTap: () => _showOptionSheet(
                                    context,
                                    'Select Main Character',
                                    'mainCharacter',
                                    state.interactivePrompt.mainCharacter,
                                  ),
                                  onSettingTap: () => _showOptionSheet(
                                    context,
                                    'Select Setting',
                                    'setting',
                                    state.interactivePrompt.setting,
                                  ),
                                  onRandomize: () {
                                    context.read<StoryGeneratorBloc>().add(
                                      const StoryGeneratorEvent.randomize(),
                                    );
                                  },
                                ),
                              SizedBox(height: 12.h),
                              // More options button
                              _MoreOptionsButton(
                                options: state.options,
                                onTap: () async {
                                  final result =
                                      await MoreOptionsBottomSheet.show(
                                        context: context,
                                        currentOptions: state.options,
                                      );
                                  if (result != null && context.mounted) {
                                    context.read<StoryGeneratorBloc>().add(
                                      StoryGeneratorEvent.updateGeneratorOptions(
                                        language: result.language,
                                        format: result.format,
                                        length: result.length,
                                      ),
                                    );
                                  }
                                },
                              ),
                              SizedBox(height: 16.h),
                              // Settings summary chips
                              _SettingsSummaryChips(options: state.options),
                              SizedBox(height: 12.h),
                              // AI disclaimer
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                child: Text(
                                  t.storyGenerator.aiDisclaimer,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant
                                        .withValues(alpha: 0.6),
                                    fontSize: 11.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: 100.h),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottomSheet: _GenerateButton(
                  canGenerate: state.canGenerate,
                  onGenerate: () {
                    HapticFeedback.heavyImpact();
                    requireOnlineOrNotify(
                      context,
                      () => context.read<StoryGeneratorBloc>().add(
                        const StoryGeneratorEvent.generate(),
                      ),
                      message: t.storyGenerator.requiresInternet,
                    );
                  },
                ),
              ),
              // Generating overlay
              if (state.isGenerating)
                GeneratingOverlay(message: state.generatingMessage),

              // Voice Input Overlay
              VoiceInputOverlay(onSwitchToKeyboard: _onSwitchToKeyboard),
            ],
          ),
        );
      },
    );
  }
}

Future<void> _showOptionSheet(
  BuildContext context,
  String title,
  String category,
  String? currentValue,
) async {
  final result = await OptionSelectionBottomSheet.show(
    context: context,
    title: title,
    category: category,
    selectedValue: currentValue,
  );

  if (result != null && context.mounted) {
    context.read<StoryGeneratorBloc>().add(
      StoryGeneratorEvent.selectOption(
        category: category,
        value: result['value']!,
        parentValue: result['parent'],
      ),
    );
  }
}

/// Shows individual setting chips below the More Options button
class _SettingsSummaryChips extends StatelessWidget {
  final dynamic options;

  const _SettingsSummaryChips({required this.options});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          _SettingChip(
            icon: Icons.translate_rounded,
            label: options.language.displayName,
            colorScheme: colorScheme,
          ),
          SizedBox(width: 8.w),
          _SettingChip(
            icon: Icons.article_rounded,
            label: options.format.displayName,
            colorScheme: colorScheme,
          ),
          SizedBox(width: 8.w),
          _SettingChip(
            icon: Icons.straighten_rounded,
            label: options.length.displayName,
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }
}

class _SettingChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme colorScheme;

  const _SettingChip({
    required this.icon,
    required this.label,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: colorScheme.primary),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MoreOptionsButton extends StatefulWidget {
  final dynamic options;
  final VoidCallback onTap;

  const _MoreOptionsButton({required this.options, required this.onTap});

  @override
  State<_MoreOptionsButton> createState() => _MoreOptionsButtonState();
}

class _MoreOptionsButtonState extends State<_MoreOptionsButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) => _scaleController.reverse(),
      onTapCancel: () => _scaleController.reverse(),
      onTap: () {
        HapticFeedback.selectionClick();
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      colorScheme.surfaceContainerHighest,
                      colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.7,
                      ),
                    ]
                  : [
                      colorScheme.primaryContainer.withValues(alpha: 0.6),
                      colorScheme.secondaryContainer.withValues(alpha: 0.3),
                    ],
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.12),
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.15),
                      colorScheme.secondary.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.tune_rounded,
                  size: 20.sp,
                  color: colorScheme.primary,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Story Settings',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Language, format & length',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14.sp,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GenerateButton extends StatelessWidget {
  final bool canGenerate;
  final VoidCallback onGenerate;

  const _GenerateButton({required this.canGenerate, required this.onGenerate});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final t = Translations.of(context);

    return BlocBuilder<StoryGeneratorBloc, StoryGeneratorState>(
      builder: (context, state) {
        final isOnline = state.isOnline;
        final isEnabled = canGenerate && isOnline;
        final foregroundColor = isEnabled
            ? Colors.white
            : colorScheme.onSurface.withValues(alpha: 0.7);

        return Container(
          padding: EdgeInsets.fromLTRB(
            16.w,
            12.h,
            16.w,
            12.h + MediaQuery.of(context).padding.bottom,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
              width: double.infinity,
              decoration: isEnabled
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(14.r),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF2F2F2F),
                            Color(0xFF161616),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      )
                    : null,
                child: FilledButton(
                  onPressed: isEnabled ? onGenerate : null,
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    backgroundColor: isEnabled
                        ? Colors.transparent
                        : colorScheme.onSurface.withValues(alpha: 0.12),
                    disabledBackgroundColor: colorScheme.onSurface.withValues(
                      alpha: 0.12,
                    ),
                    foregroundColor: foregroundColor,
                    disabledForegroundColor:
                        colorScheme.onSurface.withValues(alpha: 0.7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        size: 20.sp,
                        color: foregroundColor,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        t.storyGenerator.generate,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                          color: foregroundColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!isOnline)
                Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi_off_rounded,
                        size: 14.sp,
                        color: colorScheme.error,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        t.storyGenerator.requiresInternet,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
