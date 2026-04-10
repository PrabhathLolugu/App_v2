import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/core/presentation/widgets/offline_aware_button.dart';
import 'package:myitihas/core/widgets/voice_input/voice_input_button.dart';
import 'package:myitihas/features/social/domain/utils/post_mention_composer_utils.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/services/post_service.dart';
import 'package:myitihas/services/profile_service.dart';
import 'package:myitihas/services/user_block_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import 'package:path_provider/path_provider.dart';

import '../bloc/create_post_bloc.dart';
import '../bloc/create_post_event.dart';
import '../bloc/create_post_state.dart';
import '../widgets/post_image_crop_sheet.dart';
import '../widgets/post_image_edit_page.dart';
import '../widgets/social_video_editor_page.dart';

enum _MentionField { title, body }

class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key, this.initialPostType, this.initialContent});

  final PostType? initialPostType;
  final String? initialContent;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<CreatePostBloc>()..add(const CreatePostEvent.initialize()),
      child: _CreatePostView(
        initialPostType: initialPostType,
        initialContent: initialContent,
      ),
    );
  }
}

class _CreatePostView extends StatefulWidget {
  const _CreatePostView({this.initialPostType, this.initialContent});

  final PostType? initialPostType;
  final String? initialContent;

  @override
  State<_CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<_CreatePostView>
    with TickerProviderStateMixin {
  final _contentController = TextEditingController();
  final _titleController = TextEditingController();
  final _imagePicker = ImagePicker();
  final _contentFocusNode = FocusNode();
  final _titleFocusNode = FocusNode();

  final ProfileService _profileService = getIt<ProfileService>();
  final UserBlockService _userBlockService = getIt<UserBlockService>();

  Timer? _mentionDebounce;
  _MentionField? _mentionField;
  List<Map<String, dynamic>> _mentionSuggestions = [];
  bool _mentionLoading = false;
  bool _mentionLoadFailed = false;

  late final AnimationController _fadeController;
  late final AnimationController _slideController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeController.forward();
    _slideController.forward();

    final bloc = context.read<CreatePostBloc>();
    if (widget.initialPostType != null) {
      bloc.add(CreatePostEvent.selectType(widget.initialPostType!));
    }
    if (widget.initialContent != null &&
        widget.initialContent!.trim().isNotEmpty) {
      final content = widget.initialContent!.trim();
      _contentController.text = content;
      bloc.add(CreatePostEvent.updateContent(content));
    }

    _titleController.addListener(_onComposerTextChanged);
    _contentController.addListener(_onComposerTextChanged);
    _titleFocusNode.addListener(_onMentionFocusChanged);
    _contentFocusNode.addListener(_onMentionFocusChanged);
  }

  @override
  void dispose() {
    _mentionDebounce?.cancel();
    _titleController.removeListener(_onComposerTextChanged);
    _contentController.removeListener(_onComposerTextChanged);
    _titleFocusNode.removeListener(_onMentionFocusChanged);
    _contentFocusNode.removeListener(_onMentionFocusChanged);
    _contentController.dispose();
    _titleController.dispose();
    _contentFocusNode.dispose();
    _titleFocusNode.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _onComposerTextChanged() {
    _mentionDebounce?.cancel();
    _mentionDebounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      unawaited(_syncMentionSuggestions());
    });
  }

  void _onMentionFocusChanged() {
    if (!_titleFocusNode.hasFocus && !_contentFocusNode.hasFocus) {
      _clearMentionUi();
      return;
    }
    _onComposerTextChanged();
  }

  _MentionField? _resolveMentionField() {
    if (_titleFocusNode.hasFocus) return _MentionField.title;
    if (_contentFocusNode.hasFocus) return _MentionField.body;
    return null;
  }

  void _clearMentionUi() {
    if (!_mentionLoading &&
        !_mentionLoadFailed &&
        _mentionSuggestions.isEmpty &&
        _mentionField == null) {
      return;
    }
    setState(() {
      _mentionSuggestions = [];
      _mentionLoading = false;
      _mentionLoadFailed = false;
      _mentionField = null;
    });
  }

  Future<void> _syncMentionSuggestions() async {
    final field = _resolveMentionField();
    if (field == null) {
      _clearMentionUi();
      return;
    }
    final controller =
        field == _MentionField.title ? _titleController : _contentController;
    final caret = controller.selection.baseOffset;
    final range = activeMentionAtCaret(controller.text, caret);
    if (range == null) {
      _clearMentionUi();
      return;
    }

    setState(() {
      _mentionField = field;
      _mentionLoading = true;
      _mentionLoadFailed = false;
    });

    try {
      final uid = Supabase.instance.client.auth.currentUser?.id;
      var blocked = <String>{};
      try {
        blocked = {
          ...await _userBlockService.getBlockedUsers(),
          ...await _userBlockService.getUsersWhoBlockedMe(),
        };
      } catch (_) {}

      final q = range.query.trim();
      final List<Map<String, dynamic>> raw;
      if (q.isEmpty) {
        raw = await _profileService.fetchPublicProfiles(limit: 20, offset: 0);
      } else {
        raw = await _profileService.searchProfiles(q);
      }

      final filtered = raw.where((u) {
        final id = u['id'] as String?;
        if (id == null || id == uid) return false;
        if (blocked.contains(id)) return false;
        return true;
      }).toList();

      if (!mounted) return;
      setState(() {
        _mentionSuggestions = filtered;
        _mentionLoading = false;
        _mentionField = field;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _mentionLoading = false;
        _mentionLoadFailed = true;
        _mentionSuggestions = [];
        _mentionField = field;
      });
    }
  }

  void _insertMentionFromProfile(Map<String, dynamic> profile) {
    final canonical = profile['username'] as String?;
    if (canonical == null || canonical.isEmpty) return;
    final field = _mentionField;
    if (field == null) return;
    final controller =
        field == _MentionField.title ? _titleController : _contentController;
    final range = activeMentionAtCaret(
      controller.text,
      controller.selection.baseOffset,
    );
    if (range == null) return;

    HapticFeedback.selectionClick();
    final replacement = '@$canonical ';
    var newText = controller.text.replaceRange(
      range.atIndex,
      range.endIndex,
      replacement,
    );
    final maxLen = field == _MentionField.title ? 100 : 2000;
    if (newText.length > maxLen) {
      newText = newText.substring(0, maxLen);
    }
    final newOffset = (range.atIndex + replacement.length).clamp(0, newText.length);
    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newOffset),
    );

    final bloc = context.read<CreatePostBloc>();
    if (field == _MentionField.title) {
      bloc.add(CreatePostEvent.updateTitle(controller.text));
    } else {
      bloc.add(CreatePostEvent.updateContent(controller.text));
    }
    _clearMentionUi();
  }

  Widget _buildMentionSuggestionPanel({
    required ColorScheme colorScheme,
    required bool isDark,
  }) {
    if (_mentionField == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Material(
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12.r),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 220.h),
          child: _mentionLoading
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 22.w,
                          height: 22.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          t.social.createPost.mentionSearching,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : _mentionLoadFailed
              ? Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Text(
                    t.social.createPost.mentionLoadFailed,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              : _mentionSuggestions.isEmpty
              ? Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Text(
                    t.social.createPost.mentionNoUsers,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  itemCount: _mentionSuggestions.length,
                  separatorBuilder: (_, _) => Divider(
                    height: 1,
                    color: colorScheme.outline.withValues(alpha: 0.12),
                  ),
                  itemBuilder: (context, index) {
                    final u = _mentionSuggestions[index];
                    final username = (u['username'] as String?) ?? '';
                    final name = (u['full_name'] as String?)?.trim();
                    final avatar = u['avatar_url'] as String?;
                    return InkWell(
                      onTap: () => _insertMentionFromProfile(u),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18.r,
                              backgroundColor:
                                  colorScheme.surfaceContainerHighest,
                              backgroundImage:
                                  avatar != null && avatar.isNotEmpty
                                  ? CachedNetworkImageProvider(avatar)
                                  : null,
                              child: avatar == null || avatar.isEmpty
                                  ? Icon(
                                      Icons.person_rounded,
                                      size: 20.sp,
                                      color: colorScheme.onSurfaceVariant,
                                    )
                                  : null,
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name?.isNotEmpty == true ? name! : username,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  if (username.isNotEmpty)
                                    Text(
                                      '@$username',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  /// Avoids focus jumping to the main body field after poll toolbar actions.
  void _unfocusForPollComposerAction() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<bool> _onWillPop() async {
    final state = context.read<CreatePostBloc>().state;
    if (!state.hasContent) return true;

    final shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (context) => _DiscardDialog(),
    );
    return shouldDiscard ?? false;
  }

  Future<void> _pickImages() async {
    HapticFeedback.selectionClick();
    try {
      final images = await _imagePicker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      if (images.isNotEmpty && mounted) {
        final files = images.map((xFile) => File(xFile.path)).toList();
        final result = await PostImageEditPage.open(context, files);
        if (!mounted) return;
        if (result != null && result.files.isNotEmpty) {
          context.read<CreatePostBloc>().add(
            CreatePostEvent.setMedia(
              result.files,
              aspectRatios: result.aspectRatios,
            ),
          );
        }
      }
    } catch (_) {
      _showErrorSnackBar(t.social.createPost.failedPickImages);
    }
  }

  Future<void> _pickVideo() async {
    HapticFeedback.selectionClick();
    try {
      final video = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(seconds: 30),
      );
      if (video != null && mounted) {
        context.read<CreatePostBloc>().add(
          CreatePostEvent.addMedia([File(video.path)]),
        );
      }
    } catch (_) {
      _showErrorSnackBar(t.social.createPost.failedPickVideo);
    }
  }

  Future<void> _takePhoto() async {
    HapticFeedback.selectionClick();
    try {
      final photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      if (photo != null && mounted) {
        final result = await PostImageEditPage.open(context, [
          File(photo.path),
        ]);
        if (!mounted) return;
        if (result != null && result.files.isNotEmpty) {
          context.read<CreatePostBloc>().add(
            CreatePostEvent.setMedia(
              result.files,
              aspectRatios: result.aspectRatios,
            ),
          );
        }
      }
    } catch (_) {
      _showErrorSnackBar(t.social.createPost.failedCapturePhoto);
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final gradients = theme.extension<GradientExtension>();
    final isDark = theme.brightness == Brightness.dark;
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (!context.mounted) return;
        if (shouldPop) context.pop();
      },
      child: BlocConsumer<CreatePostBloc, CreatePostState>(
        listener: (context, state) {
          if (state.isSuccess) {
            HapticFeedback.heavyImpact();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 12.w),
                    Text(t.social.createPost.postCreated),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            );
            context.pop(true);
          } else if (state.errorMessage != null) {
            _showErrorSnackBar(state.errorMessage!);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: colorScheme.surface,
            body: Stack(
              children: [
                Positioned.fill(
                  child: IgnorePointer(
                    child: _buildBackgroundLayer(
                      colorScheme: colorScheme,
                      isDark: isDark,
                    ),
                  ),
                ),
                CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    _buildAppBar(
                      context: context,
                      state: state,
                      colorScheme: colorScheme,
                      isDark: isDark,
                    ),
                    SliverToBoxAdapter(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Column(
                              children: [
                                SizedBox(height: 16.h),
                                _buildComposerHeader(
                                  state: state,
                                  colorScheme: colorScheme,
                                  gradients: gradients,
                                  isDark: isDark,
                                ),
                                SizedBox(height: 14.h),
                                _buildPostTypeSelector(
                                  context: context,
                                  state: state,
                                  colorScheme: colorScheme,
                                  gradients: gradients,
                                  isDark: isDark,
                                ),
                                SizedBox(height: 14.h),
                                _buildContentSection(
                                  context: context,
                                  state: state,
                                  colorScheme: colorScheme,
                                  isDark: isDark,
                                ),
                                if (state.postType == PostType.image ||
                                    state.postType == PostType.video) ...[
                                  SizedBox(height: 14.h),
                                  _buildMediaSection(
                                    context: context,
                                    state: state,
                                    colorScheme: colorScheme,
                                    isDark: isDark,
                                  ),
                                ],
                                SizedBox(height: 14.h),
                                _buildVisibilitySection(
                                  context: context,
                                  state: state,
                                  colorScheme: colorScheme,
                                  isDark: isDark,
                                ),
                                SizedBox(
                                  height: keyboardInset > 0
                                      ? 32.h
                                      : 170.h +
                                            MediaQuery.paddingOf(
                                              context,
                                            ).bottom,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                _buildBottomActionBar(
                  context: context,
                  state: state,
                  colorScheme: colorScheme,
                  gradients: gradients,
                  isDark: isDark,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackgroundLayer({
    required ColorScheme colorScheme,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [colorScheme.surface, colorScheme.surfaceContainerLowest],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -100.h,
            right: -40.w,
            child: Container(
              width: 230.w,
              height: 230.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    colorScheme.primary.withValues(alpha: isDark ? 0.26 : 0.14),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 140.h,
            left: -70.w,
            child: Container(
              width: 210.w,
              height: 210.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    colorScheme.secondary.withValues(
                      alpha: isDark ? 0.22 : 0.1,
                    ),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar({
    required BuildContext context,
    required CreatePostState state,
    required ColorScheme colorScheme,
    required bool isDark,
  }) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: colorScheme.surface.withValues(alpha: 0.94),
      surfaceTintColor: Colors.transparent,
      leadingWidth: 58.w,
      leading: Padding(
        padding: EdgeInsets.only(left: 10.w),
        child: _buildRoundIconButton(
          icon: Icons.close_rounded,
          colorScheme: colorScheme,
          isDark: isDark,
          onTap: () async {
            final shouldPop = await _onWillPop();
            if (!context.mounted) return;
            if (shouldPop) context.pop();
          },
        ),
      ),
      titleSpacing: 0,
      title: Text(
        t.social.createPost.title,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
          letterSpacing: -0.2,
        ),
      ),
      actions: [
        _buildProgressChip(state: state, colorScheme: colorScheme),
        SizedBox(width: 12.w),
      ],
    );
  }

  Widget _buildRoundIconButton({
    required IconData icon,
    required ColorScheme colorScheme,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Material(
      color: isDark
          ? Colors.white.withValues(alpha: 0.08)
          : colorScheme.surfaceContainerHighest,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Icon(icon, size: 20.sp, color: colorScheme.onSurface),
        ),
      ),
    );
  }

  Widget _buildProgressChip({
    required CreatePostState state,
    required ColorScheme colorScheme,
  }) {
    final showMediaCount = state.postType != PostType.text;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.notes_rounded,
            size: 14.sp,
            color: colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: 4.w),
          Text(
            '${state.content.length}',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          if (showMediaCount) ...[
            SizedBox(width: 8.w),
            Container(
              width: 1,
              height: 12.h,
              color: colorScheme.outline.withValues(alpha: 0.35),
            ),
            SizedBox(width: 8.w),
            Icon(
              state.postType == PostType.video
                  ? Icons.videocam_rounded
                  : Icons.image_rounded,
              size: 14.sp,
              color: colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: 4.w),
            Text(
              '${state.mediaFiles.length}',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildComposerHeader({
    required CreatePostState state,
    required ColorScheme colorScheme,
    required GradientExtension? gradients,
    required bool isDark,
  }) {
    return _buildSectionCard(
      colorScheme: colorScheme,
      isDark: isDark,
      child: Row(
        children: [
          Container(
            width: 46.w,
            height: 46.w,
            decoration: BoxDecoration(
              gradient: _resolvePrimaryGradient(gradients, colorScheme),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              _iconForPostType(state.postType),
              size: 24.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _labelForPostType(state.postType),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  _hintForPostType(state.postType),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: colorScheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Text(
              _labelForVisibility(state.visibility),
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSecondaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostTypeSelector({
    required BuildContext context,
    required CreatePostState state,
    required ColorScheme colorScheme,
    required GradientExtension? gradients,
    required bool isDark,
  }) {
    final options = [
      _PostTypeOption(
        type: PostType.text,
        icon: Icons.notes_rounded,
        label: t.social.createPost.text,
      ),
      _PostTypeOption(
        type: PostType.image,
        icon: Icons.image_rounded,
        label: t.social.createPost.image,
      ),
      _PostTypeOption(
        type: PostType.video,
        icon: Icons.videocam_rounded,
        label: t.social.createPost.video,
      ),
    ];

    return _buildSectionCard(
      colorScheme: colorScheme,
      isDark: isDark,
      child: Row(
        children: [
          for (int i = 0; i < options.length; i++) ...[
            if (i > 0) SizedBox(width: 8.w),
            Expanded(
              child: _buildPostTypeOption(
                context: context,
                state: state,
                option: options[i],
                colorScheme: colorScheme,
                gradients: gradients,
                isDark: isDark,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPostTypeOption({
    required BuildContext context,
    required CreatePostState state,
    required _PostTypeOption option,
    required ColorScheme colorScheme,
    required GradientExtension? gradients,
    required bool isDark,
  }) {
    final isSelected = state.postType == option.type;
    final selectedTextColor = Colors.white;
    final defaultTextColor = colorScheme.onSurfaceVariant;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: state.isSubmitting
            ? null
            : () {
                HapticFeedback.selectionClick();
                context.read<CreatePostBloc>().add(
                  CreatePostEvent.selectType(option.type),
                );
              },
        borderRadius: BorderRadius.circular(14.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            gradient: isSelected
                ? _resolvePrimaryGradient(gradients, colorScheme)
                : null,
            color: isSelected
                ? null
                : isDark
                ? Colors.white.withValues(alpha: 0.04)
                : colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : colorScheme.outline.withValues(alpha: 0.25),
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Icon(
                option.icon,
                size: 20.sp,
                color: isSelected ? selectedTextColor : defaultTextColor,
              ),
              SizedBox(height: 6.h),
              Text(
                option.label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? selectedTextColor : defaultTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentSection({
    required BuildContext context,
    required CreatePostState state,
    required ColorScheme colorScheme,
    required bool isDark,
  }) {
    return _buildSectionCard(
      colorScheme: colorScheme,
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _titleController,
            focusNode: _titleFocusNode,
            enabled: !state.isSubmitting,
            textInputAction: TextInputAction.next,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: t.social.createPost.titleHint,
              hintStyle: TextStyle(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.65),
                fontWeight: FontWeight.w500,
              ),
              suffixIcon: VoiceInputButton(
                controller: _titleController,
                append: true,
                onResult: (spokenText) {
                  final ctrl = _titleController;
                  final current = ctrl.text.trimRight();
                  final prefix = current.isNotEmpty ? '$current ' : '';
                  final newText = '$prefix$spokenText'.trimRight();
                  ctrl.text = newText;
                  ctrl.selection = TextSelection.collapsed(
                    offset: ctrl.text.length,
                  );
                  context.read<CreatePostBloc>().add(
                    CreatePostEvent.updateTitle(newText),
                  );
                },
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              counterText: '',
            ),
            maxLength: 100,
            onChanged: (value) => context.read<CreatePostBloc>().add(
              CreatePostEvent.updateTitle(value),
            ),
          ),
          if (_mentionField == _MentionField.title)
            _buildMentionSuggestionPanel(
              colorScheme: colorScheme,
              isDark: isDark,
            ),
          SizedBox(height: 10.h),
          Divider(
            height: 1,
            color: colorScheme.outline.withValues(alpha: 0.15),
          ),
          SizedBox(height: 12.h),
          TextField(
            controller: _contentController,
            focusNode: _contentFocusNode,
            enabled: !state.isSubmitting,
            style: TextStyle(
              fontSize: 15.sp,
              height: 1.45,
              color: colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: _hintForPostType(state.postType),
              hintStyle: TextStyle(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.62),
                height: 1.4,
              ),
              suffixIcon: VoiceInputButton(
                controller: _contentController,
                append: true,
                onResult: (spokenText) {
                  final ctrl = _contentController;
                  final current = ctrl.text.trimRight();
                  final prefix = current.isNotEmpty ? '$current ' : '';
                  final newText = '$prefix$spokenText'.trimRight();
                  ctrl.text = newText;
                  ctrl.selection = TextSelection.collapsed(
                    offset: ctrl.text.length,
                  );
                  context.read<CreatePostBloc>().add(
                    CreatePostEvent.updateContent(newText),
                  );
                },
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              counterText: '',
            ),
            maxLines: null,
            minLines: state.postType == PostType.text ? 8 : 5,
            maxLength: 2000,
            onChanged: (value) => context.read<CreatePostBloc>().add(
              CreatePostEvent.updateContent(value),
            ),
          ),
          if (_mentionField == _MentionField.body)
            _buildMentionSuggestionPanel(
              colorScheme: colorScheme,
              isDark: isDark,
            ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  state.showValidationError &&
                          (state.postType == PostType.text ||
                              state.postType == PostType.storyShare) &&
                          state.validationMessage != null
                      ? state.validationMessage!
                      : '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.error.withValues(alpha: 0.85),
                  ),
                ),
              ),
              Text(
                '${state.content.length}/2000',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.75),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (state.postType == PostType.text) ...[
            SizedBox(height: 12.h),
            _buildPollComposer(
              context: context,
              state: state,
              colorScheme: colorScheme,
              isDark: isDark,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPollComposer({
    required BuildContext context,
    required CreatePostState state,
    required ColorScheme colorScheme,
    required bool isDark,
  }) {
    final canAddMore = state.pollOptions.length < CreatePostState.maxPollOptions;
    final canRemove =
        state.pollOptions.length > CreatePostState.minPollOptions;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.poll_rounded, size: 18.sp, color: colorScheme.primary),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  t.social.createPost.pollTitle,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              Switch.adaptive(
                value: state.pollEnabled,
                onChanged: state.isSubmitting
                    ? null
                    : (enabled) {
                        _unfocusForPollComposerAction();
                        context.read<CreatePostBloc>().add(
                          CreatePostEvent.togglePoll(enabled),
                        );
                      },
              ),
            ],
          ),
          Text(
            t.social.createPost.pollSubtitle,
            style: TextStyle(
              fontSize: 12.sp,
              color: colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
          if (state.pollEnabled) ...[
            SizedBox(height: 10.h),
            for (int i = 0; i < state.pollOptions.length; i++) ...[
              _buildPollOptionField(
                context: context,
                state: state,
                colorScheme: colorScheme,
                optionIndex: i,
                canRemove: canRemove,
              ),
              if (i < state.pollOptions.length - 1) SizedBox(height: 8.h),
            ],
            SizedBox(height: 10.h),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: state.isSubmitting || !canAddMore
                      ? null
                      : () {
                          _unfocusForPollComposerAction();
                          context.read<CreatePostBloc>().add(
                            const CreatePostEvent.addPollOption(),
                          );
                        },
                  icon: const Icon(Icons.add_rounded),
                  label: Text(
                    canAddMore
                        ? t.social.createPost.addPollOption
                        : t.social.createPost.pollMaxOptionsReached,
                  ),
                ),
                const Spacer(),
                Text(
                  '${state.pollOptions.length}/${CreatePostState.maxPollOptions}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPollOptionField({
    required BuildContext context,
    required CreatePostState state,
    required ColorScheme colorScheme,
    required int optionIndex,
    required bool canRemove,
  }) {
    final optionLabel = t.social.createPost.pollChoiceLabel(
      index: optionIndex + 1,
    );
    return TextFormField(
      key: ValueKey('poll-option-$optionIndex-${state.pollOptions.length}'),
      initialValue: state.pollOptions[optionIndex],
      enabled: !state.isSubmitting,
      textInputAction: TextInputAction.next,
      maxLength: 100,
      style: TextStyle(fontSize: 14.sp, color: colorScheme.onSurface),
      decoration: InputDecoration(
        hintText: optionLabel,
        counterText: '',
        filled: true,
        fillColor: colorScheme.surface.withValues(alpha: 0.55),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: colorScheme.primary.withValues(alpha: 0.55)),
        ),
        suffixIcon: canRemove
            ? IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  size: 18.sp,
                  color: colorScheme.onSurfaceVariant,
                ),
                onPressed: () {
                  _unfocusForPollComposerAction();
                  context.read<CreatePostBloc>().add(
                    CreatePostEvent.removePollOption(optionIndex),
                  );
                },
              )
            : null,
      ),
      onChanged: (value) {
        context.read<CreatePostBloc>().add(
          CreatePostEvent.updatePollOption(optionIndex, value),
        );
      },
    );
  }

  Widget _buildMediaSection({
    required BuildContext context,
    required CreatePostState state,
    required ColorScheme colorScheme,
    required bool isDark,
  }) {
    final isVideo = state.postType == PostType.video;
    final maxMedia = isVideo ? 1 : 10;

    return _buildSectionCard(
      colorScheme: colorScheme,
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isVideo ? Icons.videocam_rounded : Icons.photo_library_rounded,
                size: 20.sp,
                color: colorScheme.primary,
              ),
              SizedBox(width: 8.w),
              Text(
                isVideo ? t.social.createPost.video : t.social.createPost.image,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Text(
                '${state.mediaFiles.length}/$maxMedia',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            isVideo
                ? t.social.createPost.videoSectionHint
                : t.social.createPost.imageSectionHint,
            style: TextStyle(
              fontSize: 12.sp,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.9),
              height: 1.3,
            ),
          ),
          SizedBox(height: 12.h),
          if (isVideo)
            _buildVideoComposer(
              context: context,
              state: state,
              colorScheme: colorScheme,
              isDark: isDark,
            )
          else
            _buildImageComposer(
              context: context,
              state: state,
              colorScheme: colorScheme,
              isDark: isDark,
            ),
          if (state.showValidationError && state.validationMessage != null) ...[
            SizedBox(height: 8.h),
            Text(
              state.validationMessage!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: colorScheme.error.withValues(alpha: 0.85),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVideoComposer({
    required BuildContext context,
    required CreatePostState state,
    required ColorScheme colorScheme,
    required bool isDark,
  }) {
    if (state.mediaFiles.isEmpty) {
      return _buildActionTile(
        icon: Icons.video_library_rounded,
        label: t.social.createPost.selectVideo,
        colorScheme: colorScheme,
        isDark: isDark,
        onTap: _pickVideo,
      );
    }

    final fileName = state.mediaFiles.first.path.split(RegExp(r'[/\\]')).last;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.videocam_rounded,
                      color: colorScheme.primary,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      fileName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        height: 1.3,
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              Text(
                t.social.createPost.videoEditOptions,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.9),
                  letterSpacing: 0.2,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _openVideoEditor(context, state.mediaFiles.first),
                      icon: Icon(
                        Icons.edit_rounded,
                        size: 18.sp,
                        color: colorScheme.primary,
                      ),
                      label: Text(
                        t.social.createPost.editVideo,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.primary,
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickVideo,
                      icon: Icon(
                        Icons.refresh_rounded,
                        size: 18.sp,
                        color: colorScheme.primary,
                      ),
                      label: Text(
                        t.social.createPost.selectVideo,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.primary,
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Tooltip(
                    message: t.social.createPost.removeVideo,
                    child: Material(
                      color: colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(12.r),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12.r),
                        onTap: () => context.read<CreatePostBloc>().add(
                          const CreatePostEvent.removeMedia(0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10.w),
                          child: Icon(
                            Icons.delete_rounded,
                            size: 20.sp,
                            color: colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageComposer({
    required BuildContext context,
    required CreatePostState state,
    required ColorScheme colorScheme,
    required bool isDark,
  }) {
    if (state.mediaFiles.isEmpty) {
      return Row(
        children: [
          Expanded(
            child: _buildActionTile(
              icon: Icons.photo_library_rounded,
              label: t.social.createPost.gallery,
              colorScheme: colorScheme,
              isDark: isDark,
              onTap: _pickImages,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: _buildActionTile(
              icon: Icons.camera_alt_rounded,
              label: t.social.createPost.camera,
              colorScheme: colorScheme,
              isDark: isDark,
              onTap: _takePhoto,
            ),
          ),
        ],
      );
    }

    final canAddMore = state.mediaFiles.length < 10;
    final itemCount = state.mediaFiles.length + (canAddMore ? 1 : 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.w,
            mainAxisSpacing: 8.h,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            if (index == state.mediaFiles.length) {
              return _buildAddMediaTile(
                colorScheme: colorScheme,
                isDark: isDark,
                onTap: _pickImages,
              );
            }
            return _buildImageThumbnail(
              context: context,
              index: index,
              file: state.mediaFiles[index],
            );
          },
        ),
        SizedBox(height: 8.h),
        Text(
          t.social.createPost.photoEditHint,
          style: TextStyle(
            fontSize: 12.sp,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.85),
            height: 1.3,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: TextButton.icon(
                onPressed: canAddMore ? _pickImages : null,
                icon: const Icon(Icons.photo_library_rounded),
                label: Text(t.social.createPost.gallery),
              ),
            ),
            Expanded(
              child: TextButton.icon(
                onPressed: canAddMore ? _takePhoto : null,
                icon: const Icon(Icons.camera_alt_rounded),
                label: Text(t.social.createPost.camera),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String label,
    required ColorScheme colorScheme,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.03)
                : colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.35),
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: colorScheme.primary, size: 28.sp),
              SizedBox(height: 8.h),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddMediaTile({
    required ColorScheme colorScheme,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.03)
                : colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.4),
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate_rounded,
                color: colorScheme.primary,
                size: 28.sp,
              ),
              SizedBox(height: 6.h),
              Text(
                t.social.createPost.addPhoto,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageThumbnail({
    required BuildContext context,
    required int index,
    required File file,
  }) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(file, fit: BoxFit.cover),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.75),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _cropImageAt(context, index, file),
                        borderRadius: BorderRadius.circular(8.r),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.crop_rounded,
                              size: 20.sp,
                              color: Colors.white,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              t.social.createPost.cropPhoto,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 28.h,
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          context.read<CreatePostBloc>().add(
                            CreatePostEvent.removeMedia(index),
                          );
                        },
                        borderRadius: BorderRadius.circular(8.r),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete_outline_rounded,
                              size: 20.sp,
                              color: theme.colorScheme.errorContainer,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              t.social.createPost.removePhoto,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.errorContainer,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _cropImageAt(BuildContext context, int index, File file) async {
    HapticFeedback.selectionClick();
    final failedCropMsg = t.social.createPost.failedCrop;
    final cropTitle = t.social.createPost.cropPhoto;
    try {
      String sourcePath = file.path;
      // Give native cropper a stable file path (some Android paths from picker are not readable by cropper).
      if (!File(sourcePath).existsSync() ||
          sourcePath.contains('/cache/') ||
          sourcePath.contains('content://')) {
        final tempDir = await getTemporaryDirectory();
        final tempFile = File(
          '${tempDir.path}/post_crop_${index}_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        await tempFile.writeAsBytes(await file.readAsBytes());
        sourcePath = tempFile.path;
      }
      if (!context.mounted) return;
      final result = await cropPostImage(
        context: context,
        sourcePath: sourcePath,
        cropTitle: cropTitle,
      );
      if (!context.mounted || result == null) return;
      // Copy to a file we own so upload uses the cropped image (cropper may overwrite temp later).
      final tempDir = await getTemporaryDirectory();
      final ownedFile = File(
        '${tempDir.path}/post_cropped_${index}_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await ownedFile.writeAsBytes(await result.file.readAsBytes());
      final aspectRatio =
          result.aspectRatio ?? await getImageAspectRatio(ownedFile);
      if (!context.mounted) return;
      context.read<CreatePostBloc>().add(
        CreatePostEvent.replaceMedia(
          index,
          ownedFile,
          aspectRatio: aspectRatio,
        ),
      );
    } catch (_) {
      if (context.mounted) _showErrorSnackBar(failedCropMsg);
    }
  }

  Future<void> _openVideoEditor(BuildContext context, File file) async {
    HapticFeedback.selectionClick();
    final result = await SocialVideoEditorPage.open(context, file);
    if (!context.mounted || result == null) return;
    // Copy to a file we own so upload uses the edited video.
    final tempDir = await getTemporaryDirectory();
    final ext = result.file.path.split('.').last.toLowerCase();
    final ownedFile = File(
      '${tempDir.path}/post_edited_${DateTime.now().millisecondsSinceEpoch}.${ext == 'mp4' || ext == 'mov' ? ext : 'mp4'}',
    );
    await ownedFile.writeAsBytes(await result.file.readAsBytes());
    if (!context.mounted) return;
    context.read<CreatePostBloc>().add(
      CreatePostEvent.replaceMedia(
        0,
        ownedFile,
        durationSeconds: result.durationSeconds,
        startSeconds: result.startSeconds,
        endSeconds: result.endSeconds,
        playbackSpeed: result.playbackSpeed != 1.0 ? result.playbackSpeed : null,
      ),
    );
    final overlayText = result.overlayText;
    if (overlayText != null &&
        overlayText.trim().isNotEmpty &&
        _contentController.text.trim().isEmpty) {
      final text = overlayText.trim();
      _contentController.text = text;
      context.read<CreatePostBloc>().add(CreatePostEvent.updateContent(text));
    }
  }

  Widget _buildVisibilitySection({
    required BuildContext context,
    required CreatePostState state,
    required ColorScheme colorScheme,
    required bool isDark,
  }) {
    return _buildSectionCard(
      colorScheme: colorScheme,
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.social.createPost.visibility,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 10.h),
          _buildVisibilityTile(
            context: context,
            icon: Icons.public_rounded,
            label: t.social.createPost.public,
            isSelected: state.visibility == PostVisibility.public,
            colorScheme: colorScheme,
            onTap: () => context.read<CreatePostBloc>().add(
              const CreatePostEvent.changeVisibility(PostVisibility.public),
            ),
          ),
          SizedBox(height: 8.h),
          _buildVisibilityTile(
            context: context,
            icon: Icons.people_rounded,
            label: t.social.createPost.followers,
            isSelected: state.visibility == PostVisibility.followers,
            colorScheme: colorScheme,
            onTap: () => context.read<CreatePostBloc>().add(
              const CreatePostEvent.changeVisibility(PostVisibility.followers),
            ),
          ),
          SizedBox(height: 8.h),
          _buildVisibilityTile(
            context: context,
            icon: Icons.lock_rounded,
            label: t.social.createPost.private,
            isSelected: state.visibility == PostVisibility.private,
            colorScheme: colorScheme,
            onTap: () => context.read<CreatePostBloc>().add(
              const CreatePostEvent.changeVisibility(PostVisibility.private),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisibilityTile({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isSelected,
    required ColorScheme colorScheme,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary.withValues(alpha: 0.12)
                : colorScheme.surfaceContainerLowest.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outline.withValues(alpha: 0.24),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18.sp,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 180),
                opacity: isSelected ? 1 : 0,
                child: Icon(
                  Icons.check_circle_rounded,
                  size: 18.sp,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionBar({
    required BuildContext context,
    required CreatePostState state,
    required ColorScheme colorScheme,
    required GradientExtension? gradients,
    required bool isDark,
  }) {
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: keyboardInset > 0 ? 8.h : 0),
        child: SafeArea(
          top: false,
          minimum: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xDD111827)
                  : Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : colorScheme.outline.withValues(alpha: 0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.24 : 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildScheduleSection(
                  context: context,
                  state: state,
                  colorScheme: colorScheme,
                  isDark: isDark,
                ),
                SizedBox(height: 10.h),
                OfflineAwareButton(
                  onPressed: !state.isSubmitting
                      ? () async {
                          if (!state.canSubmit) {
                            HapticFeedback.lightImpact();
                            context.read<CreatePostBloc>().add(
                              const CreatePostEvent.submit(),
                            );
                            return;
                          }
                          HapticFeedback.mediumImpact();
                          final shouldSubmit = await _showContentPolicyDialog(
                            context,
                          );
                          if (shouldSubmit == true && context.mounted) {
                            context.read<CreatePostBloc>().add(
                              const CreatePostEvent.submit(),
                            );
                          }
                        }
                      : null,
                  offlineMessage: t.social.createPost.cannotCreateOffline,
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                    backgroundColor: WidgetStateProperty.all(
                      Colors.transparent,
                    ),
                    elevation: WidgetStateProperty.all(0),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: _resolvePrimaryGradient(gradients, colorScheme),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.25),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                        BoxShadow(
                          color: colorScheme.secondary.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      height: 56.h,
                      child: Center(
                        child: state.isSubmitting
                            ? SizedBox(
                                width: 22.w,
                                height: 22.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    state.isScheduled
                                        ? Icons.schedule_send_rounded
                                        : Icons.send_rounded,
                                    size: 18.sp,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    state.isScheduled
                                        ? 'Schedule post'
                                        : t.social.createPost.post,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
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

  Widget _buildScheduleSection({
    required BuildContext context,
    required CreatePostState state,
    required ColorScheme colorScheme,
    required bool isDark,
  }) {
    final isScheduled = state.isScheduled;
    final scheduledAt = state.scheduledAtLocal;
    final textTheme = Theme.of(context).textTheme;

    String subtitle;
    if (!isScheduled) {
      subtitle = 'Post will be shared immediately.';
    } else if (scheduledAt != null) {
      final timeText =
          '${scheduledAt.day.toString().padLeft(2, '0')} '
          '${_monthLabel(scheduledAt.month)}, '
          '${_formatTimeOfDay(scheduledAt)} IST';
      subtitle = 'Will be posted on $timeText';
    } else {
      subtitle = 'Choose a date and time (IST).';
    }

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: () {
          HapticFeedback.selectionClick();
        },
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.03)
                : colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.22),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 16.sp,
                          color: colorScheme.primary,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'When to post?',
                          style: textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  _buildScheduleToggleChip(
                    context: context,
                    label: 'Post now',
                    isSelected: !isScheduled,
                    colorScheme: colorScheme,
                    onTap: () {
                      context.read<CreatePostBloc>().add(
                        const CreatePostEvent.toggleScheduling(false),
                      );
                    },
                  ),
                  SizedBox(width: 6.w),
                  _buildScheduleToggleChip(
                    context: context,
                    label: 'Schedule',
                    isSelected: isScheduled,
                    colorScheme: colorScheme,
                    onTap: () {
                      context.read<CreatePostBloc>().add(
                        const CreatePostEvent.toggleScheduling(true),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Text(
                subtitle,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.9),
                  height: 1.3,
                ),
              ),
              if (isScheduled) ...[
                SizedBox(height: 6.h),
                Text(
                  'All scheduled posts use India Standard Time (IST, UTC+5:30). You can schedule up to 1 month in advance.',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    fontSize: 11.sp,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _pickScheduledDateTime(context, state),
                        icon: Icon(
                          Icons.calendar_today_rounded,
                          size: 16.sp,
                          color: colorScheme.primary,
                        ),
                        label: Text(
                          'Pick date',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colorScheme.primary,
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _pickScheduledDateTime(context, state),
                        icon: Icon(
                          Icons.access_time_rounded,
                          size: 16.sp,
                          color: colorScheme.primary,
                        ),
                        label: Text(
                          'Pick time',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colorScheme.primary,
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                        ),
                      ),
                    ),
                  ],
                ),
                if (scheduledAt != null) ...[
                  SizedBox(height: 6.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(
                        alpha: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.schedule_send_rounded,
                          size: 14.sp,
                          color: colorScheme.onPrimaryContainer,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Selected time (IST): ${scheduledAt.day.toString().padLeft(2, '0')} ${_monthLabel(scheduledAt.month)}, ${_formatTimeOfDay(scheduledAt)}',
                          style: textTheme.labelMedium?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
              if (state.schedulingErrorMessage != null &&
                  state.schedulingErrorMessage!.isNotEmpty) ...[
                SizedBox(height: 4.h),
                Text(
                  state.schedulingErrorMessage!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.error.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleToggleChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required ColorScheme colorScheme,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(999.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(999.r),
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999.r),
            color: isSelected
                ? colorScheme.primary
                : colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? colorScheme.onPrimary
                  : colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickScheduledDateTime(
    BuildContext context,
    CreatePostState state,
  ) async {
    final now = DateTime.now();
    const maxScheduleDays = 30;
    final maxDate = now.add(const Duration(days: maxScheduleDays));
    final rawInitial =
        state.scheduledAtLocal ?? now.add(const Duration(minutes: 10));
    final initial = rawInitial.isAfter(maxDate) ? maxDate : rawInitial;

    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now,
      lastDate: maxDate,
    );
    if (date == null) return;
    if (!context.mounted) return;

    final timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (timeOfDay == null) return;

    final combined = DateTime(
      date.year,
      date.month,
      date.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    if (!context.mounted) return;
    context.read<CreatePostBloc>().add(
      CreatePostEvent.updateScheduledAt(combined),
    );
  }

  String _monthLabel(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    if (month < 1 || month > 12) return '';
    return months[month - 1];
  }

  String _formatTimeOfDay(DateTime dt) {
    final hour = dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final isPm = hour >= 12;
    final displayHour = ((hour + 11) % 12) + 1;
    final suffix = isPm ? 'PM' : 'AM';
    return '$displayHour:$minute $suffix';
  }

  Widget _buildSectionCard({
    required ColorScheme colorScheme,
    required bool isDark,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xC61A2130)
            : Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : colorScheme.outline.withValues(alpha: 0.14),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.22 : 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  Gradient _resolvePrimaryGradient(
    GradientExtension? gradients,
    ColorScheme colorScheme,
  ) {
    return gradients?.primaryButtonGradient ??
        LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorScheme.primary, colorScheme.secondary],
        );
  }

  IconData _iconForPostType(PostType postType) {
    return switch (postType) {
      PostType.text => Icons.notes_rounded,
      PostType.image => Icons.image_rounded,
      PostType.video => Icons.videocam_rounded,
      PostType.storyShare => Icons.auto_stories_rounded,
    };
  }

  String _labelForPostType(PostType postType) {
    return switch (postType) {
      PostType.text => t.social.createPost.text,
      PostType.image => t.social.createPost.image,
      PostType.video => t.social.createPost.video,
      PostType.storyShare => t.social.createPost.text,
    };
  }

  String _hintForPostType(PostType postType) {
    final extra = ' ${t.feed.captionHashtagsMentionsHint}';
    return switch (postType) {
      PostType.text => '${t.social.createPost.textHint}$extra',
      PostType.image => '${t.social.createPost.imageCaptionHint}$extra',
      PostType.video => '${t.social.createPost.videoCaptionHint}$extra',
      PostType.storyShare => '${t.social.createPost.shareCaptionHint}$extra',
    };
  }

  String _labelForVisibility(PostVisibility visibility) {
    return switch (visibility) {
      PostVisibility.public => t.social.createPost.public,
      PostVisibility.followers => t.social.createPost.followers,
      PostVisibility.private => t.social.createPost.private,
    };
  }

  Future<bool?> _showContentPolicyDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Row(
            children: [
              Icon(
                Icons.gavel_rounded,
                color: colorScheme.primary,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              const Expanded(child: Text("Content Policy")),
            ],
          ),
          content: Text(
            "Only Bharatiya content should be added. Adding irrelevant content is subject to breaking the user agreement.",
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
              fontSize: 14.sp,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

class _DiscardDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      title: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 24.sp),
          SizedBox(width: 8.w),
          Expanded(child: Text(t.social.createPost.discardTitle)),
        ],
      ),
      content: Text(
        t.social.createPost.discardMessage,
        style: TextStyle(color: colorScheme.onSurfaceVariant, height: 1.4),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(t.social.createPost.keepEditing),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          child: Text(t.social.createPost.discard),
        ),
      ],
    );
  }
}

class _PostTypeOption {
  final PostType type;
  final IconData icon;
  final String label;

  const _PostTypeOption({
    required this.type,
    required this.icon,
    required this.label,
  });
}
