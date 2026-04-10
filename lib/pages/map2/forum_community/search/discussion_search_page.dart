import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/core/utils/app_error_message.dart';
import 'package:myitihas/core/widgets/voice_input/voice_input_button.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/pages/map2/forum_community/comment/comments.dart';
import 'package:myitihas/pages/map2/forum_community/discussion_ui_constants.dart';
import 'package:myitihas/pages/map2/forum_community/search/discussion_search_service.dart';
import 'package:myitihas/pages/map2/forum_community/widget/discussion_card_widget.dart';
import 'package:myitihas/utils/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Dedicated search page for searching discussions with full-text search and filtering.
///
/// Features:
/// - Full-text search across discussion titles and content
/// - Category filtering (All Discussions, General, Location)
/// - Real-time server-side search results
/// - Loading and empty states
/// - Integration with discussion cards and actions
class DiscussionSearchPage extends StatefulWidget {
  final String siteId;

  const DiscussionSearchPage({super.key, required this.siteId});

  @override
  State<DiscussionSearchPage> createState() => _DiscussionSearchPageState();
}

class _DiscussionSearchPageState extends State<DiscussionSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final _supabase = Supabase.instance.client;
  final _searchService = DiscussionSearchService();

  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  bool _hasSearched = false;
  String _selectedCategory = DiscussionSearchScope.all;
  String? _lastSearchError;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    debugPrint(
      '🔍 DiscussionSearchPage initialized for siteId: ${widget.siteId}',
    );
    _searchController.addListener(_onSearchChanged);
    // Auto-focus search field for better UX
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  /// Called when search text changes - debounced to avoid excessive queries
  void _onSearchChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), _performSearch);
  }

  /// Performs the search based on current query and category filter
  Future<void> _performSearch() async {
    _lastSearchError = null;

    setState(() {
      _isSearching = true;
      _hasSearched = true;
    });

    try {
      final query = _searchController.text.trim();
      final category = _selectedCategory == DiscussionSearchScope.all
          ? null
          : _selectedCategory;

      debugPrint(
        '🔎 Searching: query="$query", category="$category"',
      );

      final results = await _searchService.searchDiscussions(
        query: query,
        category: category,
      );

      debugPrint('📊 Got ${results.length} results');

      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Search Error: $e');
      if (mounted) {
        setState(() {
          _isSearching = false;
          _lastSearchError = toUserFriendlyErrorMessage(
            e,
            fallback: context.t.map.discussions.searchErrorFallback,
          );
        });
      }
    }
  }

  /// Called when category filter changes
  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
    });
    // Re-perform search with new category filter
    _performSearch();
  }

  /// Open map discussion comments (same as main forum feed — there is no `/home/discussion/...` route).
  void _onDiscussionTap(Map<String, dynamic> discussion) {
    final id = discussion['id']?.toString();
    if (id == null || id.isEmpty) return;
    final navigator = Navigator.of(context);
    navigator.pop();
    navigator.push(
      MaterialPageRoute<void>(
        builder: (context) => CommentsScreen(activityId: id),
      ),
    );
  }

  /// Like a discussion
  void _onLikeTapped(Map<String, dynamic> discussion) async {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.t.map.discussions.loginToLike)),
      );
      return;
    }

    final discussionId = discussion['id'];
    final likes = List<Map<String, dynamic>>.from(
      discussion['discussion_likes'] ?? [],
    );
    final isLiked = likes.any((like) => like['user_id'] == currentUser.id);

    try {
      if (isLiked) {
        // Unlike
        await _supabase
            .from('discussion_likes')
            .delete()
            .eq('discussion_id', discussionId)
            .eq('user_id', currentUser.id);
      } else {
        // Like
        await _supabase.from('discussion_likes').insert({
          'discussion_id': discussionId,
          'user_id': currentUser.id,
        });
      }

      // Refresh search results
      await _performSearch();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(content: Text(context.t.map.discussions.genericActionError)),
      );
    }
  }

  void _onShareTapped(Map<String, dynamic> discussion) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Share: ${discussion['title']}')));
  }

  void _onReportTapped(Map<String, dynamic> discussion) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Report: ${discussion['title']}')));
  }

  void _onProfileTapped(Map<String, dynamic> discussion) {
    final authorId = discussion['author_id']?.toString();
    if (authorId != null) {
      Navigator.of(context).pop(); // Close search
      ProfileRoute(userId: authorId).push(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final t = context.t;

    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: theme.colorScheme.surface,
          appBar: AppBar(
            backgroundColor: theme.colorScheme.surface,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              t.map.discussions.searchTitle,
              style: theme.textTheme.titleLarge,
            ),
          ),
          body: Column(
            children: [
              // Search field
              Padding(
                padding: EdgeInsets.all(4.w),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: t.map.discussions.searchHint,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _hasSearched = false;
                                _searchResults = [];
                              });
                            },
                          )
                        : VoiceInputButton(controller: _searchController),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),

              // Category filter chips
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: SizedBox(
                  height: 5.h,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCategoryChip(
                        label: t.map.allDiscussions,
                        isSelected:
                            _selectedCategory == DiscussionSearchScope.all,
                        isDark: isDark,
                        onTap: () =>
                            _onCategoryChanged(DiscussionSearchScope.all),
                      ),
                      SizedBox(width: 2.w),
                      _buildCategoryChip(
                        label: t.map.discussions.generalCategory,
                        isSelected:
                            _selectedCategory == DiscussionSearchScope.general,
                        isDark: isDark,
                        onTap: () =>
                            _onCategoryChanged(DiscussionSearchScope.general),
                      ),
                      SizedBox(width: 2.w),
                      _buildCategoryChip(
                        label: t.map.discussions.locationCategory,
                        isSelected:
                            _selectedCategory == DiscussionSearchScope.location,
                        isDark: isDark,
                        onTap: () =>
                            _onCategoryChanged(DiscussionSearchScope.location),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 1.h),

              // Results or loading/empty state
              Expanded(child: _buildResultsView()),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the search results view with loading, error, and empty states
  Widget _buildResultsView() {
    final theme = Theme.of(context);
    final t = context.t;

    if (!_hasSearched) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 15.w,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            SizedBox(height: 2.h),
            Text(
              t.map.discussions.startTyping,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }

    if (_isSearching) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: theme.colorScheme.onSurface),
            SizedBox(height: 2.h),
            Text(t.map.discussions.searching, style: theme.textTheme.bodyMedium),
          ],
        ),
      );
    }

    if (_lastSearchError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 15.w,
              color: theme.colorScheme.error,
            ),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                _lastSearchError!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            ElevatedButton(
              onPressed: _performSearch,
              child: Text(t.common.retry),
            ),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox,
              size: 15.w,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            SizedBox(height: 2.h),
            Text(
              t.map.discussions.noResults,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              t.map.discussions.noResultsHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final discussion = _searchResults[index];
        final currentUser = _supabase.auth.currentUser;
        final isOwnPost = discussion['author_id'] == currentUser?.id;

        return DiscussionCardWidget(
          discussion: discussion,
          onTap: () => _onDiscussionTap(discussion),
          onLike: () => _onLikeTapped(discussion),
          onShare: () => _onShareTapped(discussion),
          onReport: () => _onReportTapped(discussion),
          onHashtagTap: (tag) {
            _searchController.text = '#$tag';
            _searchController.selection = TextSelection.fromPosition(
              TextPosition(offset: _searchController.text.length),
            );
            _debounceTimer?.cancel();
            _performSearch();
          },
          onProfileTap: () => _onProfileTapped(discussion),
          onDelete: isOwnPost
              ? () {
                  // Delete functionality could be added here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.t.map.discussions.deleteFromTabHint),
                    ),
                  );
                }
              : null,
          isOwnPost: isOwnPost,
        );
      },
    );
  }

  /// Builds a category filter chip
  Widget _buildCategoryChip({
    required String label,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
        decoration: BoxDecoration(
          gradient: isSelected
              ? (isDark
                    ? DarkColors.messageUserGradient
                    : LightColors.messageUserGradient)
              : null,
          color: isSelected ? null : theme.colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 13.sp,
          ),
        ),
      ),
    );
  }
}
