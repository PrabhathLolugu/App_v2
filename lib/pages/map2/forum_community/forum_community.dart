import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/core/utils/app_error_message.dart';
import 'package:myitihas/core/widgets/voice_input/voice_input_button.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/pages/map2/forum_community/comment/comments.dart';
import 'package:myitihas/pages/map2/forum_community/discussion_hashtag_utils.dart';
import 'package:myitihas/pages/map2/forum_community/discussion_ui_constants.dart';
import 'package:myitihas/pages/map2/forum_community/forum_discussion_launch_context.dart';
import 'package:myitihas/pages/map2/forum_community/search/discussion_search_page.dart';
import 'package:myitihas/pages/map2/forum_community/widget/bottom_action_bar_widget.dart';
import 'package:myitihas/pages/map2/forum_community/widget/category_filter_widget.dart';
import 'package:myitihas/pages/map2/forum_community/widget/cycling_hashtag_hint_text_field.dart';
import 'package:myitihas/pages/map2/forum_community/widget/discussion_card_widget.dart';
import 'package:myitihas/pages/map2/map_navigation.dart';
import 'package:myitihas/pages/map2/widgets/custom_image_widget.dart';
import 'package:myitihas/pages/map2/widgets/map_header_nav.dart';
import 'package:myitihas/utils/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForumCommunity extends StatefulWidget {
  final String siteId;
  final ForumDiscussionLaunchContext? launchContext;
  const ForumCommunity({super.key, required this.siteId, this.launchContext});

  @override
  State<ForumCommunity> createState() => _ForumCommunityState();
}

class _ForumCommunityState extends State<ForumCommunity>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final _supabase = Supabase.instance.client;

  List<Map<String, dynamic>> _discussions = [];
  List<Map<String, dynamic>> _filteredDiscussions = [];
  bool _isLoading = true;
  String _selectedCategory = DiscussionFeedFilter.all;
  String? _lastPostError;
  String? _activeContextTag;

  List<String> get _suggestedTags => mergeHashtags(
    const [],
    widget.launchContext?.suggestedHashtags ?? const [],
  );
  bool get _hasLocationContext => widget.launchContext?.hasLocationContext ?? false;
  String get _defaultPostCategory =>
      widget.launchContext?.defaultLocationMode == true && _hasLocationContext
      ? 'location'
      : 'general';
  static final RegExp _uuidRegExp = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
  );

  String? _coerceUuidSiteId(Object? value) {
    if (value == null) return null;
    final asString = value.toString().trim();
    if (asString.isEmpty) return null;
    return _uuidRegExp.hasMatch(asString) ? asString : null;
  }

  @override
  void initState() {
    super.initState();
    _fetchDiscussions();
    _searchController.addListener(_filterDiscussions);
    if (widget.launchContext?.openComposerOnLoad == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _startNewDiscussion();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchDiscussions() async {
    try {
      setState(() => _isLoading = true);

      final data = await _supabase
          .from('discussions')
          .select('*, discussion_likes(user_id)')
          .order('created_at', ascending: false);

      if (mounted) {
        setState(() {
          _discussions = List<Map<String, dynamic>>.from(data);
          _isLoading = false;
        });
        _filterDiscussions();
      }
    } catch (e) {
      debugPrint("Fetch Error: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _filterDiscussions() {
    final currentUser = _supabase.auth.currentUser;
    final parsedQuery = parseDiscussionSearchQuery(_searchController.text);
    final hasExplicitHashtagQuery = _searchController.text.contains('#');
    final implicitHashtag =
        !hasExplicitHashtagQuery &&
            parsedQuery.hashtags.isEmpty &&
            !parsedQuery.textQuery.contains(' ')
        ? normalizeHashtagToken(parsedQuery.textQuery).toLowerCase()
        : '';

    setState(() {
      _filteredDiscussions = _discussions.where((discussion) {
        final title = discussion['title']?.toString().toLowerCase() ?? '';
        final preview = discussion['preview']?.toString().toLowerCase() ?? '';
        final content = discussion['content']?.toString().toLowerCase() ?? '';
        final hashtags = List<String>.from(discussion['hashtags'] ?? const [])
            .map((tag) => normalizeHashtagToken(tag).toLowerCase())
            .where((tag) => tag.isNotEmpty)
            .toSet();

        final matchesText =
            parsedQuery.textQuery.isEmpty ||
            title.contains(parsedQuery.textQuery.toLowerCase()) ||
            preview.contains(parsedQuery.textQuery.toLowerCase()) ||
            content.contains(parsedQuery.textQuery.toLowerCase());
        final matchesSearchHashtags = parsedQuery.hashtags.every(
          (tag) => hashtags.contains(tag.toLowerCase()),
        );
        final matchesImplicitHashtag =
            implicitHashtag.isNotEmpty && hashtags.contains(implicitHashtag);
        final matchesContextTag =
            _activeContextTag == null ||
            hashtags.contains(_activeContextTag!.toLowerCase());

        bool matchesCategory = true;
        if (_selectedCategory == DiscussionFeedFilter.myActivity) {
          matchesCategory = discussion['author_id'] == currentUser?.id;
        }

        final matchesQuery = parsedQuery.hashtags.isEmpty && implicitHashtag.isNotEmpty
            ? (matchesText || matchesImplicitHashtag)
            : (matchesText && matchesSearchHashtags);

        return matchesQuery &&
            matchesContextTag &&
            matchesCategory;
      }).toList();
    });
  }

  /// Returns true if the discussion was posted successfully, false otherwise.
  Future<bool> _postNewDiscussion(
    String title,
    String content, {
    required String category,
    required List<String> hashtags,
  }) async {
    _lastPostError = null;
    final user = _supabase.auth.currentUser;
    if (user == null) return false;

    try {
      Map<String, dynamic>? profileResponse;
      try {
        profileResponse = await _supabase
            .from('profiles')
            .select('full_name, avatar_url')
            .eq('id', user.id)
            .maybeSingle();
      } catch (profileError) {
        // Non-blocking: some environments restrict profile reads via RLS.
        debugPrint(
          'Profile lookup skipped during discussion post: $profileError',
        );
      }

      // Best effort: ensure a public.users row exists for legacy accounts.
      // Discussions may reference public.users through FK/RLS.
      try {
        await _supabase.from('users').upsert({
          'id': user.id,
          'email': user.email ?? '',
          'full_name':
              profileResponse?['full_name'] ??
              user.userMetadata?['full_name'] ??
              user.userMetadata?['name'] ??
              'Anonymous Pilgrim',
          'username': (user.email ?? 'pilgrim').split('@').first,
          'avatar_url':
              profileResponse?['avatar_url'] ??
              user.userMetadata?['avatar_url'],
          'bio': '',
          'is_online': true,
          'last_seen': DateTime.now().toIso8601String(),
        }, onConflict: 'id');
      } catch (_) {
        // Non-blocking: posting can still succeed if row already exists
        // or FK/policy does not require it.
      }

      final String authorName =
          profileResponse?['full_name'] ??
          user.userMetadata?['full_name'] ??
          user.userMetadata?['name'] ??
          t.map.anonymousPilgrim;
      final String authorAvatar =
          profileResponse?['avatar_url'] ??
          user.userMetadata?['avatar_url'] ??
          "https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/sacred-sites/userpp.jpg";

      // Create preview from first 200 characters
      final String preview = content.length > 200
          ? '${content.substring(0, 200)}...'
          : content;

      final payload = <String, dynamic>{
        'title': title,
        'content': content,
        'preview': preview,
        'author': authorName,
        'author_id': user.id,
        'author_avatar': authorAvatar,
        'category': category,
        'hashtags': mergeHashtags(const [], hashtags),
        'like_count': 0,
        // Schema uses comment_count (not reply_count).
        'comment_count': 0,
      };
      if (category == 'location' && _hasLocationContext) {
        final originSiteId = widget.launchContext?.originSiteId;
        final uuidSiteId = _coerceUuidSiteId(originSiteId);
        if (uuidSiteId != null) {
          payload['site_id'] = uuidSiteId;
        }
        if ((widget.launchContext?.siteName ?? '').trim().isNotEmpty) {
          payload['site_name'] = widget.launchContext?.siteName?.trim();
        }
      }

      try {
        await _supabase.from('discussions').insert(payload);
      } catch (insertError) {
        // Retry once without site_id when the DB rejects site_id (null/NOT NULL/FK)
        // or when an invalid sentinel was used. Never send a non-UUID string for
        // site_id — Postgres expects UUID or NULL.
        final errorText = insertError.toString().toLowerCase();
        final siteIdProblem = errorText.contains('site_id') &&
            (errorText.contains('null') ||
                errorText.contains('not-null') ||
                errorText.contains('uuid') ||
                errorText.contains('foreign key'));
        if (!siteIdProblem) rethrow;

        final withoutSite = Map<String, dynamic>.from(payload)..remove('site_id');
        await _supabase.from('discussions').insert(withoutSite);
      }

      await _fetchDiscussions();
      return true;
    } catch (e) {
      debugPrint("Post Error: $e");
      _lastPostError = toUserFriendlyErrorMessage(
        e,
        fallback: t.map.discussions.postFailed,
      );
      return false;
    }
  }

  // ignore: unused_element - kept for potential long-press preview
  void _showProfilePreview(Map<String, dynamic> discussion) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: 2.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.3,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Container(
                width: 25.w,
                height: 25.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: CustomImageWidget(
                    imageUrl:
                        discussion['author_avatar']?.toString() ??
                        "https://ui-avatars.com/api/?name=${discussion['author'] ?? 'User'}",
                    width: 20.w,
                    height: 20.w,
                    fit: BoxFit.cover,
                    semanticLabel:
                        discussion['author_avatar_label']?.toString() ??
                        t.map.discussions.profilePhotoSemantic,
                    useAvatarPlaceholder: true,
                  ),
                ),
              ),
              SizedBox(height: 1.5.h),
              Text(
                // FIX: Safely handle the author name
                discussion['author']?.toString() ?? t.map.anonymousPilgrim,
                style: theme.textTheme.titleLarge,
              ),

              SizedBox(height: 2.h),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(
                    top: BorderSide(
                      color: theme.colorScheme.outline,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Container(
                  height: 5.5.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: isDark
                        ? DarkColors.messageUserGradient
                        : LightColors.messageUserGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).primaryColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final authorId = discussion['author_id']?.toString();
                      if (authorId != null) {
                        ProfileRoute(userId: authorId).push(context);
                        Navigator.pop(context); // Close the preview sheet
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    icon: Icon(Icons.person, color: Colors.white, size: 19.sp),
                    label: Text(
                      t.map.viewProfile,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startNewDiscussion() {
    final theme = Theme.of(context);
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final hashtagController = TextEditingController();
    final isDark = theme.brightness == Brightness.dark;
    String? titleError;
    String? contentError;
    String? hashtagError;
    bool isPosting = false;
    String selectedCategory = _defaultPostCategory;
    // Location-suggested tags apply only for "Location" posts; General leaves hashtags empty for the user.
    var autoTags = List<String>.from(
      selectedCategory == 'location' && _hasLocationContext
          ? _suggestedTags
          : const <String>[],
    );
    final manualTags = <String>[];

    List<String> getAllTags() => mergeHashtags(autoTags, manualTags);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          final tr = context.t;

          void commitHashtagFieldInput() {
            if (hashtagController.text.trim().isEmpty) {
              setSheetState(() => hashtagError = null);
              return;
            }
            final parsed =
                parseHashtagsFromComposerInput(hashtagController.text);
            if (parsed.isEmpty) {
              setSheetState(
                () => hashtagError = t.map.invalidHashtagLabel,
              );
              return;
            }
            setSheetState(() {
              hashtagError = null;
              for (final tag in parsed) {
                final existing = mergeHashtags(autoTags, manualTags);
                if (existing.length >= 5) {
                  hashtagError = t.map.hashtagMaxLimitReached;
                  return;
                }
                if (existing.any(
                  (e) => e.toLowerCase() == tag.toLowerCase(),
                )) {
                  continue;
                }
                manualTags.add(tag);
              }
            });
            hashtagController.clear();
          }

          return Padding(
            padding: EdgeInsets.only(
              // iOS: use viewPadding for home indicator safe area
              // Android: use viewInsets for keyboard height
              bottom: Platform.isIOS
                  ? MediaQuery.of(context).viewPadding.bottom
                  : MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_hasLocationContext)
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.h),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setSheetState(() {
                                  selectedCategory = 'general';
                                  autoTags.clear();
                                }),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 1.2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selectedCategory == 'general'
                                        ? theme.colorScheme.primary
                                        : theme
                                              .colorScheme
                                              .surfaceContainerHigh,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: selectedCategory == 'general'
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.outline,
                                    ),
                                  ),
                                  child: Text(
                                    tr.map.discussions.generalCategory,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: selectedCategory == 'general'
                                          ? theme.colorScheme.onPrimary
                                          : theme.colorScheme.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setSheetState(() {
                                  selectedCategory = 'location';
                                  autoTags
                                    ..clear()
                                    ..addAll(_suggestedTags);
                                }),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 1.2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selectedCategory == 'location'
                                        ? theme.colorScheme.primary
                                        : theme
                                              .colorScheme
                                              .surfaceContainerHigh,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: selectedCategory == 'location'
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.outline,
                                    ),
                                  ),
                                  child: Text(
                                    tr.map.discussions.locationCategory,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: selectedCategory == 'location'
                                          ? theme.colorScheme.onPrimary
                                          : theme.colorScheme.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: t.map.discussionTitleHint,
                        errorText: titleError,
                        suffixIcon: VoiceInputButton(
                          controller: titleController,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    TextField(
                      controller: contentController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: t.map.shareYourThoughtsHint,
                        errorText: contentError,
                        suffixIcon: VoiceInputButton(
                          controller: contentController,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        t.map.hashtagsLabel,
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    CyclingHashtagHintTextField(
                      controller: hashtagController,
                      hintIntro: tr.map.hashtagsHintIntro,
                      hintOutro: tr.map.hashtagsHintOutro,
                      errorText: hashtagError,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => commitHashtagFieldInput(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: commitHashtagFieldInput,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    if (autoTags.isNotEmpty || manualTags.isNotEmpty)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            for (final tag in autoTags)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: theme.colorScheme.primary,
                                  ),
                                  SizedBox(width: 0.5.w),
                                  Text(
                                    '#$tag',
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            for (final tag in manualTags)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '#$tag',
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close, size: 18),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(
                                      minWidth: 28,
                                      minHeight: 28,
                                    ),
                                    visualDensity: VisualDensity.compact,
                                    style: IconButton.styleFrom(
                                      foregroundColor:
                                          theme.colorScheme.onSurfaceVariant,
                                    ),
                                    onPressed: () {
                                      setSheetState(() {
                                        manualTags.remove(tag);
                                        hashtagError = null;
                                      });
                                    },
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    SizedBox(height: 0.8.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        t.map.hashtagLimitHint,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),

                    Container(
                      height: 5.5.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF505050), Color(0xFF121212)],
                        ),
                        border: Border.all(
                          color: Colors.white24,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: isPosting
                            ? null
                            : () async {
                                final title = titleController.text.trim();
                                final content = contentController.text.trim();
                                if (title.isEmpty || content.isEmpty) {
                                  setSheetState(() {
                                    titleError = title.isEmpty
                                        ? t.map.pleaseEnterDiscussionTitle
                                        : null;
                                    contentError = content.isEmpty
                                        ? tr.map.discussions.composerBodyRequired
                                        : null;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        title.isEmpty && content.isEmpty
                                            ? tr
                                                  .map
                                                  .discussions
                                                  .postTitleAndBodyRequired
                                            : title.isEmpty
                                            ? tr
                                                  .map
                                                  .discussions
                                                  .postTitleRequiredSnackbar
                                            : tr
                                                  .map
                                                  .discussions
                                                  .postBodyRequiredSnackbar,
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                final hashtags = getAllTags();
                                setSheetState(() => isPosting = true);
                                final success = await _postNewDiscussion(
                                  title,
                                  content,
                                  category: selectedCategory,
                                  hashtags: hashtags,
                                );
                                if (!context.mounted) return;
                                setSheetState(() => isPosting = false);
                                if (success) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        tr.map.discussions.postedSuccess,
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        _lastPostError ??
                                            tr.map.discussions.postFailed,
                                      ),
                                    ),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        icon: Icon(
                          isPosting ? Icons.hourglass_empty : Icons.send,
                          color: Colors.white,
                          size: 20,
                        ),
                        label: Text(
                          isPosting
                              ? tr.map.discussions.posting
                              : tr.map.discussions.postDiscussionCta,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _toggleLike(String discussionId, bool currentlyLiked) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      if (currentlyLiked) {
        await _supabase.from('discussion_likes').delete().match({
          'user_id': user.id,
          'discussion_id': discussionId,
        });
      } else {
        await _supabase.from('discussion_likes').insert({
          'user_id': user.id,
          'discussion_id': discussionId,
        });
      }

      await _fetchDiscussions();
    } catch (e) {
      debugPrint("❌ Like Error: $e");
      await _fetchDiscussions();
    }
  }

  Future<void> _deleteDiscussion(String id) async {
    try {
      await _supabase.from('discussions').delete().eq('id', id);

      _fetchDiscussions();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.t.map.discussions.deleteSuccess)),
        );
      }
    } catch (e) {
      debugPrint("Delete Error: $e");
    }
  }

  void _showDeleteConfirmation(String id) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final td = dialogContext.t;
        return AlertDialog(
          title: Text(td.map.discussions.deletePostTitle),
          content: Text(td.map.discussions.deletePostBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(td.common.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _deleteDiscussion(id);
              },
              child: Text(
                td.common.delete,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradientExt = theme.extension<GradientExtension>();
    final loc = context.t;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        goBackToMapLanding(context);
      },
      child: Scaffold(
        appBar: MapTabHeader(
          currentIndex: 2,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: loc.map.discussions.searchTooltip,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) =>
                      const DiscussionSearchPage(siteId: 'general'),
                );
              },
            ),
          ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient:
                gradientExt?.screenBackgroundGradient ??
                LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.surface,
                    theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.3,
                    ),
                  ],
                ),
          ),
          child: Column(
            children: [
              CategoryFilterWidget(
                selectedCategory: _selectedCategory,
                onCategorySelected: (cat) {
                  setState(() => _selectedCategory = cat);
                  _filterDiscussions();
                },
              ),
              if (_suggestedTags.isNotEmpty)
                SizedBox(
                  height: 5.h,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    children: [
                      _buildSimpleContextFilter(
                        label: loc.map.discussions.allContextChip,
                        selected: _activeContextTag == null,
                        onTap: () {
                          setState(() => _activeContextTag = null);
                          _filterDiscussions();
                        },
                      ),
                      for (final tag in _suggestedTags)
                        _buildSimpleContextFilter(
                          label: '#$tag',
                          selected: _activeContextTag == tag,
                          onTap: () {
                            setState(() => _activeContextTag = tag);
                            _filterDiscussions();
                          },
                        ),
                    ],
                  ),
                ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        onRefresh: _fetchDiscussions,
                        child: _filteredDiscussions.isEmpty
                            ? Center(
                                child: Text(
                                  _selectedCategory ==
                                          DiscussionFeedFilter.myActivity
                                      ? loc.map.discussions.emptyMyActivity
                                      : loc.map.discussions.emptyAll,
                                ),
                              )
                            : ListView.builder(
                                controller: _scrollController,
                                padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.paddingOf(context).bottom +
                                      100,
                                ),
                                itemCount: _filteredDiscussions.length,
                                itemBuilder: (context, index) {
                                  final discussion =
                                      _filteredDiscussions[index];
                                  final currentUser =
                                      _supabase.auth.currentUser;
                                  final bool isOwnPost =
                                      discussion['author_id'] ==
                                      currentUser?.id;

                                  final int commentCount =
                                      discussion['reply_count'] ??
                                      discussion['comment_count'] ??
                                      0;

                                  final List likes =
                                      discussion['discussion_likes'] ?? [];

                                  final bool isLiked = likes.any(
                                    (like) =>
                                        like['user_id'] == currentUser?.id,
                                  );
                                  return DiscussionCardWidget(
                                    isOwnPost: isOwnPost,
                                    onDelete: isOwnPost
                                        ? () => _showDeleteConfirmation(
                                            discussion['id'].toString(),
                                          )
                                        : null,

                                    discussion: {
                                      ..._filteredDiscussions[index],

                                      'author':
                                          _filteredDiscussions[index]['author']
                                              ?.toString() ??
                                          loc.map.discussions.anonymous,
                                      'title':
                                          _filteredDiscussions[index]['title']
                                              ?.toString() ??
                                          loc.map.discussions.noTitle,
                                      'preview':
                                          _filteredDiscussions[index]['preview']
                                              ?.toString() ??
                                          '',
                                      'authorAvatar':
                                          _filteredDiscussions[index]['author_avatar']
                                              ?.toString() ??
                                          '',
                                      'timestamp':
                                          _filteredDiscussions[index]['created_at']
                                              ?.toString() ??
                                          loc.map.discussions.justNow,
                                      'created_at':
                                          _filteredDiscussions[index]['created_at'],

                                      'likeCount':
                                          _filteredDiscussions[index]['like_count'] ??
                                          0,
                                      'replyCount': commentCount.toString(),
                                    },

                                    onTap: () {
                                      final discussionId =
                                          _filteredDiscussions[index]['id']
                                              .toString();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CommentsScreen(
                                            activityId: discussionId,
                                          ),
                                        ),
                                      );
                                    },
                                    onLike: () => _toggleLike(
                                      discussion['id'].toString(),
                                      isLiked,
                                    ),
                                    onShare: () {},
                                    onReport: () {},
                                    onHashtagTap: (tag) {
                                      _searchController.text = '#$tag';
                                      _searchController.selection =
                                          TextSelection.fromPosition(
                                            TextPosition(
                                              offset: _searchController
                                                  .text
                                                  .length,
                                            ),
                                          );
                                      _filterDiscussions();
                                    },
                                    onProfileTap: () {
                                      final authorId =
                                          _filteredDiscussions[index]['author_id']
                                              ?.toString();
                                      if (authorId != null) {
                                        ProfileRoute(
                                          userId: authorId,
                                        ).push(context);
                                      }
                                    },
                                  );
                                },
                              ),
                      ),
              ),
              BottomActionBarWidget(onStartDiscussion: _startNewDiscussion),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleContextFilter({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(right: 3.w),
      child: Center(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
            child: Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
