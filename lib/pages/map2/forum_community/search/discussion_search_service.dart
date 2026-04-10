import 'package:flutter/foundation.dart';
import 'package:myitihas/pages/map2/forum_community/discussion_hashtag_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service for searching discussions with full-text and field-based querying.
class DiscussionSearchService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Searches discussions by keyword across title and content.
  ///
  /// Parameters:
  ///   - [query]: Search keyword(s) - searches title and content
  ///   - [category]: Optional category filter ('general', 'location', or null for all)
  /// Returns: List of matching discussions, sorted by creation date (newest first)
  Future<List<Map<String, dynamic>>> searchDiscussions({
    required String query,
    String? category,
  }) async {
    try {
      final parsed = parseDiscussionSearchQuery(query);
      final hasExplicitHashtagQuery = query.contains('#');
      final implicitHashtag =
          !hasExplicitHashtagQuery &&
              parsed.hashtags.isEmpty &&
              !parsed.textQuery.contains(' ')
          ? normalizeHashtagToken(parsed.textQuery)
          : '';

      if (parsed.textQuery.isEmpty && parsed.hashtags.isEmpty) {
        // If query is empty, return all recent discussions
        return await _fetchAllDiscussions(category: category);
      }

      debugPrint(
        '🔍 Server-side searching for text="${parsed.textQuery}" hashtags=${parsed.hashtags}',
      );

      // Build the search pattern for ILIKE queries (uses BTREE indexes on LOWER columns)
      final searchPattern = '%${parsed.textQuery}%';

      // Start with base query
      var baseQuery = _supabase
          .from('discussions')
          .select('*, discussion_likes(user_id)');

      // Apply category filter if specified
      if (category != null && category.isNotEmpty) {
        baseQuery = baseQuery.eq('category', category);
      }

      if (parsed.hashtags.isNotEmpty) {
        baseQuery = baseQuery.contains('hashtags', parsed.hashtags);
      }

      dynamic results;
      if (parsed.textQuery.isNotEmpty) {
        results = await baseQuery
            .or('title.ilike.$searchPattern,content.ilike.$searchPattern')
            .order('created_at', ascending: false);
      } else {
        results = await baseQuery.order('created_at', ascending: false);
      }

      if (parsed.hashtags.isEmpty && implicitHashtag.isNotEmpty) {
        var hashtagQuery = _supabase
            .from('discussions')
            .select('*, discussion_likes(user_id)');
        if (category != null && category.isNotEmpty) {
          hashtagQuery = hashtagQuery.eq('category', category);
        }
        final hashtagResults = await hashtagQuery
            .contains('hashtags', [implicitHashtag])
            .order('created_at', ascending: false);

        final merged = <String, Map<String, dynamic>>{};
        for (final row in List<Map<String, dynamic>>.from(results)) {
          merged[row['id'].toString()] = row;
        }
        for (final row in List<Map<String, dynamic>>.from(hashtagResults)) {
          merged[row['id'].toString()] = row;
        }
        results = merged.values.toList()
          ..sort((a, b) {
            final aDate = DateTime.tryParse(a['created_at']?.toString() ?? '');
            final bDate = DateTime.tryParse(b['created_at']?.toString() ?? '');
            if (aDate == null && bDate == null) return 0;
            if (aDate == null) return 1;
            if (bDate == null) return -1;
            return bDate.compareTo(aDate);
          });
      }

      debugPrint('✅ Found ${results.length} results');
      return List<Map<String, dynamic>>.from(results);
    } catch (e) {
      debugPrint(
        '⚠️ Server-side search failed, falling back to client-side: $e',
      );
      // Fallback to client-side filtering if server-side fails
      return await _clientSideSearch(
        query: query,
        category: category,
      );
    }
  }

  /// Client-side fallback search when server-side search fails
  Future<List<Map<String, dynamic>>> _clientSideSearch({
    required String query,
    String? category,
  }) async {
    try {
      final parsed = parseDiscussionSearchQuery(query);
      final hasExplicitHashtagQuery = query.contains('#');
      final implicitHashtag =
          !hasExplicitHashtagQuery &&
              parsed.hashtags.isEmpty &&
              !parsed.textQuery.contains(' ')
          ? normalizeHashtagToken(parsed.textQuery).toLowerCase()
          : '';
      debugPrint(
        '🔍 Falling back to client-side search for text="${parsed.textQuery}" hashtags=${parsed.hashtags}',
      );

      // Fetch all discussions with basic filters
      var baseQuery = _supabase
          .from('discussions')
          .select('*, discussion_likes(user_id)');

      if (category != null && category.isNotEmpty) {
        baseQuery = baseQuery.eq('category', category);
      }

      final allDiscussions = await baseQuery.order(
        'created_at',
        ascending: false,
      );

      final searchLower = parsed.textQuery.toLowerCase();
      final filteredResults = (allDiscussions as List).where((discussion) {
        final title = discussion['title']?.toString().toLowerCase() ?? '';
        final content = discussion['content']?.toString().toLowerCase() ?? '';
        final preview = discussion['preview']?.toString().toLowerCase() ?? '';
        final hashtags = List<String>.from(discussion['hashtags'] ?? const [])
            .map((tag) => normalizeHashtagToken(tag).toLowerCase())
            .where((tag) => tag.isNotEmpty)
            .toSet();
        final matchesText =
            parsed.textQuery.isEmpty ||
            title.contains(searchLower) ||
            content.contains(searchLower) ||
            preview.contains(searchLower);
        final matchesTags = parsed.hashtags.every(
          (tag) => hashtags.contains(tag.toLowerCase()),
        );
        final matchesImplicitHashtag =
            implicitHashtag.isNotEmpty && hashtags.contains(implicitHashtag);

        if (parsed.hashtags.isEmpty && implicitHashtag.isNotEmpty) {
          return matchesText || matchesImplicitHashtag;
        }
        return matchesText && matchesTags;
      }).toList();

      debugPrint(
        '✅ Client-side search found ${filteredResults.length} results',
      );
      return List<Map<String, dynamic>>.from(filteredResults);
    } catch (e) {
      debugPrint('❌ Client-side search error: $e');
      return [];
    }
  }

  /// Fetches all discussions with optional category and site filtering.
  Future<List<Map<String, dynamic>>> _fetchAllDiscussions({
    String? category,
  }) async {
    try {
      var queryBuilder = _supabase
          .from('discussions')
          .select('*, discussion_likes(user_id)');

      if (category != null && category.isNotEmpty) {
        queryBuilder = queryBuilder.eq('category', category);
      }

      final results = await queryBuilder.order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(results);
    } catch (e) {
      debugPrint('Fetch All Discussions Error: $e');
      return [];
    }
  }
}
