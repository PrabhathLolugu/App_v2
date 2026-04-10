import 'package:injectable/injectable.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/core/errors/exceptions.dart';
import 'package:myitihas/features/social/domain/entities/content_type.dart';
import 'package:myitihas/features/social/domain/entities/share.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import 'package:talker_flutter/talker_flutter.dart';

/// Service for social interactions: likes, comments, bookmarks, shares.
///
/// Provides a unified interface for all social actions across posts,
/// stories, and comments. All operations use auth.uid() for authorization.
@lazySingleton
class SocialService {
  final SupabaseClient _supabase;

  SocialService(this._supabase);

  // ==================== LIKES ====================

  /// Likes a piece of content (post, comment, or story).
  ///
  /// Upserts to handle duplicate likes gracefully.
  Future<void> likeContent({
    required ContentType contentType,
    required String contentId,
  }) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw AuthException('User must be authenticated to like content');
      }

      // Avoid upsert here: if row exists and RLS blocks updates, upsert can fail.
      final existing = await _supabase
          .from('likes')
          .select('id')
          .eq('user_id', currentUserId)
          .eq('likeable_type', contentType.dbValue)
          .eq('likeable_id', contentId)
          .limit(1);

      if ((existing as List).isNotEmpty) {
        logger.debug(
          '[SocialService] Like already exists for $currentUserId on ${contentType.name} $contentId',
        );
        return;
      }

      try {
        await _supabase.from('likes').insert({
          'user_id': currentUserId,
          'likeable_type': contentType.dbValue,
          'likeable_id': contentId,
        });
      } on PostgrestException catch (e) {
        final code = e.code?.trim();
        final message = e.message.toLowerCase();
        final isDuplicate =
            code == '23505' || message.contains('duplicate key');

        if (!isDuplicate) {
          rethrow;
        }

        logger.debug(
          '[SocialService] Like insert raced with an existing row for $currentUserId on ${contentType.name} $contentId',
        );
      }

      logger.info(
        '[SocialService] User $currentUserId liked ${contentType.name} $contentId',
      );
    } on AuthException {
      rethrow;
    } catch (e, stackTrace) {
      logger.error('[SocialService] Error liking content', e, stackTrace);
      throw ServerException('Failed to like content: ${e.toString()}');
    }
  }

  /// Unlikes a piece of content.
  Future<void> unlikeContent({
    required ContentType contentType,
    required String contentId,
  }) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw AuthException('User must be authenticated to unlike content');
      }

      await _supabase
          .from('likes')
          .delete()
          .eq('user_id', currentUserId)
          .eq('likeable_type', contentType.dbValue)
          .eq('likeable_id', contentId);

      logger.info(
        '[SocialService] User $currentUserId unliked ${contentType.name} $contentId',
      );
    } on AuthException {
      rethrow;
    } catch (e, stackTrace) {
      logger.error('[SocialService] Error unliking content', e, stackTrace);
      throw ServerException('Failed to unlike content: ${e.toString()}');
    }
  }

  /// Checks if the current user has liked a piece of content.
  Future<bool> isLiked({
    required ContentType contentType,
    required String contentId,
  }) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        return false;
      }

      final response = await _supabase
          .from('likes')
          .select('id')
          .eq('user_id', currentUserId)
          .eq('likeable_type', contentType.dbValue)
          .eq('likeable_id', contentId)
          .maybeSingle();

      return response != null;
    } catch (e, stackTrace) {
      logger.error('[SocialService] Error checking like status', e, stackTrace);
      return false;
    }
  }

  /// Gets the like count for a piece of content.
  Future<int> getLikeCount({
    required ContentType contentType,
    required String contentId,
  }) async {
    try {
      final response = await _supabase
          .from('likes')
          .select()
          .eq('likeable_type', contentType.dbValue)
          .eq('likeable_id', contentId)
          .count(CountOption.exact);

      return response.count;
    } catch (e) {
      return 0;
    }
  }

  // ==================== COMMENTS ====================

  /// Adds a comment to a post or story.
  ///
  /// [contentType] - Whether commenting on a post or story
  /// [contentId] - ID of the post or story
  /// [text] - Comment text
  /// [parentCommentId] - Optional parent for nested replies (max 3 levels)
  ///
  /// Returns the created comment data with author info.
  Future<Map<String, dynamic>> addComment({
    required ContentType contentType,
    required String contentId,
    required String text,
    String? parentCommentId,
  }) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw AuthException('User must be authenticated to comment');
      }

      if (text.trim().isEmpty) {
        throw const ServerException('Comment cannot be empty', '400');
      }

      // Calculate depth and root comment
      int depth = 0;
      String? rootCommentId;

      if (parentCommentId != null) {
        final parent = await _supabase
            .from('comments')
            .select('depth, root_comment_id')
            .eq('id', parentCommentId)
            .single();

        depth = (parent['depth'] as int) + 1;
        if (depth > 3) {
          throw const ServerException(
            'Maximum comment nesting depth (3) exceeded',
            '400',
          );
        }

        // Root is either parent's root or parent itself (if top-level reply)
        rootCommentId = parent['root_comment_id'] as String? ?? parentCommentId;
      }

      final commentData = {
        'author_id': currentUserId,
        'commentable_type': contentType.dbValue,
        'commentable_id': contentId,
        'content': text.trim(),
        'parent_comment_id': parentCommentId,
        'depth': depth,
        'root_comment_id': rootCommentId,
      };

      // Select only from comments so insert succeeds even if profiles FK name differs
      final response = await _supabase
          .from('comments')
          .insert(commentData)
          .select('id, created_at, depth')
          .single();

      logger.info(
        '[SocialService] Comment created on ${contentType.name} $contentId',
      );
      return response;
    } on AuthException {
      rethrow;
    } on ServerException {
      rethrow;
    } on PostgrestException catch (e, stackTrace) {
      logger.error(
        '[SocialService] Postgrest error adding comment',
        e,
        stackTrace,
      );
      final msg = e.message.isNotEmpty
          ? e.message
          : (e.details?.toString() ?? e.toString());
      final detailsStr = e.details?.toString().trim() ?? '';
      final extra = detailsStr.isNotEmpty ? ' | $detailsStr' : '';
      throw ServerException('Comment failed: $msg$extra');
    } catch (e, stackTrace) {
      logger.error('[SocialService] Error adding comment', e, stackTrace);
      throw ServerException('Failed to add comment: ${e.toString()}');
    }
  }

  /// Deletes a comment.
  ///
  /// Only the author can delete their comments (enforced by RLS).
  Future<void> deleteComment(String commentId) async {
    final logger = getIt<Talker>();

    try {
      await _supabase.from('comments').delete().eq('id', commentId);
      logger.info('[SocialService] Deleted comment $commentId');
    } catch (e, stackTrace) {
      logger.error('[SocialService] Error deleting comment', e, stackTrace);
      throw ServerException('Failed to delete comment: ${e.toString()}');
    }
  }

  /// Gets comments for a piece of content with threading.
  ///
  /// Returns top-level comments with nested replies loaded.
  Future<List<Map<String, dynamic>>> getComments({
    required ContentType contentType,
    required String contentId,
    int limit = 20,
    int offset = 0,
  }) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;

      // Get top-level comments (use inferred FK so it works regardless of FK name)
      final topLevelComments = await _supabase
          .from('comments')
          .select('''
            *,
            author:profiles(id, username, full_name, avatar_url)
          ''')
          .eq('commentable_type', contentType.dbValue)
          .eq('commentable_id', contentId)
          .isFilter('parent_comment_id', null)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      // For each top-level comment, get replies
      final commentsWithReplies = <Map<String, dynamic>>[];
      final allCommentIds = <String>[];

      for (final comment in topLevelComments) {
        allCommentIds.add(comment['id'] as String);

        // Get replies (query by root so we work even when reply_count is missing or stale)
        final replies = await _supabase
            .from('comments')
            .select('''
              *,
              author:profiles(id, username, full_name, avatar_url)
            ''')
            .eq('root_comment_id', comment['id'])
            .order('created_at', ascending: true);

        for (final r in replies) {
          allCommentIds.add(r['id'] as String);
        }

        final commentMap = Map<String, dynamic>.from(comment);
        commentMap['replies'] = replies;
        commentsWithReplies.add(commentMap);
      }

      // Batch check which comments are liked by current user (avoids N+1)
      final likedCommentIds = currentUserId != null && allCommentIds.isNotEmpty
          ? await batchCheckLiked(
              contentType: ContentType.comment,
              contentIds: allCommentIds,
            )
          : <String>{};

      for (final commentMap in commentsWithReplies) {
        commentMap['is_liked_by_current_user'] = likedCommentIds.contains(
          commentMap['id'] as String?,
        );
        final replies = commentMap['replies'] as List<dynamic>? ?? [];
        for (final reply in replies) {
          if (reply is Map<String, dynamic>) {
            reply['is_liked_by_current_user'] = likedCommentIds.contains(
              reply['id'] as String?,
            );
          }
        }
      }

      logger.debug(
        '[SocialService] Fetched ${commentsWithReplies.length} comments for ${contentType.name} $contentId',
      );
      return commentsWithReplies;
    } catch (e, stackTrace) {
      logger.error('[SocialService] Error fetching comments', e, stackTrace);
      throw ServerException('Failed to fetch comments: ${e.toString()}');
    }
  }

  // ==================== BOOKMARKS ====================

  /// Bookmarks a piece of content.
  ///
  /// [collection] - Optional collection name for organization
  Future<void> bookmarkContent({
    required ContentType contentType,
    required String contentId,
    String? collection,
  }) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw AuthException('User must be authenticated to bookmark');
      }

      await _supabase.from('bookmarks').upsert({
        'user_id': currentUserId,
        'bookmarkable_type': contentType.dbValue,
        'bookmarkable_id': contentId,
        'collection_name': collection,
      }, onConflict: 'user_id,bookmarkable_type,bookmarkable_id');

      logger.info(
        '[SocialService] User $currentUserId bookmarked ${contentType.name} $contentId',
      );
    } on AuthException {
      rethrow;
    } catch (e, stackTrace) {
      logger.error('[SocialService] Error bookmarking content', e, stackTrace);
      throw ServerException('Failed to bookmark: ${e.toString()}');
    }
  }

  /// Removes a bookmark.
  Future<void> removeBookmark({
    required ContentType contentType,
    required String contentId,
  }) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw AuthException('User must be authenticated');
      }

      await _supabase
          .from('bookmarks')
          .delete()
          .eq('user_id', currentUserId)
          .eq('bookmarkable_type', contentType.dbValue)
          .eq('bookmarkable_id', contentId);

      logger.info(
        '[SocialService] User $currentUserId removed bookmark from ${contentType.name} $contentId',
      );
    } on AuthException {
      rethrow;
    } catch (e, stackTrace) {
      logger.error('[SocialService] Error removing bookmark', e, stackTrace);
      throw ServerException('Failed to remove bookmark: ${e.toString()}');
    }
  }

  /// Checks if content is bookmarked by current user.
  Future<bool> isBookmarked({
    required ContentType contentType,
    required String contentId,
  }) async {
    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        return false;
      }

      final response = await _supabase
          .from('bookmarks')
          .select('id')
          .eq('user_id', currentUserId)
          .eq('bookmarkable_type', contentType.dbValue)
          .eq('bookmarkable_id', contentId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }

  /// Gets all bookmarked content for the current user.
  Future<List<Map<String, dynamic>>> getBookmarks({
    int limit = 20,
    int offset = 0,
    String? collection,
  }) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        return [];
      }

      // Build base query with filters first, then transformations
      var query = _supabase
          .from('bookmarks')
          .select()
          .eq('user_id', currentUserId);

      if (collection != null) {
        query = query.eq('collection_name', collection);
      }

      final bookmarks = await query
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      // Fetch the actual bookmarked content
      final results = <Map<String, dynamic>>[];

      for (final bookmark in bookmarks) {
        final type = bookmark['bookmarkable_type'] as String;
        final id = bookmark['bookmarkable_id'] as String;

        Map<String, dynamic>? content;
        if (type == 'post') {
          content = await _supabase
              .from('posts')
              .select('''
                *,
                author:profiles!posts_author_id_fkey(id, username, full_name, avatar_url)
              ''')
              .eq('id', id)
              .maybeSingle();
        } else if (type == 'story') {
          content = await _supabase
              .from('stories')
              .select()
              .eq('id', id)
              .maybeSingle();
        }

        if (content != null) {
          results.add({
            'bookmark': bookmark,
            'content': content,
            'content_type': type,
          });
        }
      }

      logger.debug('[SocialService] Fetched ${results.length} bookmarks');
      return results;
    } catch (e, stackTrace) {
      logger.error('[SocialService] Error fetching bookmarks', e, stackTrace);
      throw ServerException('Failed to fetch bookmarks: ${e.toString()}');
    }
  }

  // ==================== SHARES ====================

  /// Records a share action.
  ///
  /// [shareType] - How content was shared (repost, DM, external)
  /// [recipientId] - For DM shares, the recipient user ID
  Future<void> shareContent({
    required ContentType contentType,
    required String contentId,
    required ShareType shareType,
    String? recipientId,
  }) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw AuthException('User must be authenticated to share');
      }

      await _supabase.from('shares').insert({
        'user_id': currentUserId,
        'shareable_type': contentType.dbValue,
        'shareable_id': contentId,
        'share_type': _shareTypeToDbEnum(shareType),
        'recipient_id': recipientId,
      });

      logger.info(
        '[SocialService] User $currentUserId shared ${contentType.name} $contentId via ${shareType.name}',
      );
    } on AuthException {
      rethrow;
    } catch (e, stackTrace) {
      logger.error('[SocialService] Error sharing content', e, stackTrace);
      throw ServerException('Failed to share: ${e.toString()}');
    }
  }

  /// Gets share count for content.
  Future<int> getShareCount({
    required ContentType contentType,
    required String contentId,
  }) async {
    try {
      final response = await _supabase
          .from('shares')
          .select()
          .eq('shareable_type', contentType.dbValue)
          .eq('shareable_id', contentId)
          .count(CountOption.exact);

      return response.count;
    } catch (e) {
      return 0;
    }
  }

  // ==================== BATCH CHECKS ====================

  /// Batch checks which content IDs are liked by the current user.
  /// Returns a set of content IDs that are liked.
  Future<Set<String>> batchCheckLiked({
    required ContentType contentType,
    required List<String> contentIds,
  }) async {
    if (contentIds.isEmpty) return {};

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) return {};

      final response = await _supabase
          .from('likes')
          .select('likeable_id')
          .eq('user_id', currentUserId)
          .eq('likeable_type', contentType.dbValue)
          .inFilter('likeable_id', contentIds);

      return response.map((row) => row['likeable_id'] as String).toSet();
    } catch (e) {
      return {};
    }
  }

  /// Batch checks which content IDs are bookmarked by the current user.
  /// Returns a set of content IDs that are bookmarked.
  Future<Set<String>> batchCheckBookmarked({
    required ContentType contentType,
    required List<String> contentIds,
  }) async {
    if (contentIds.isEmpty) return {};

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) return {};

      final response = await _supabase
          .from('bookmarks')
          .select('bookmarkable_id')
          .eq('user_id', currentUserId)
          .eq('bookmarkable_type', contentType.dbValue)
          .inFilter('bookmarkable_id', contentIds);

      return response.map((row) => row['bookmarkable_id'] as String).toSet();
    } catch (e) {
      return {};
    }
  }

  // ==================== HELPERS ====================

  String _shareTypeToDbEnum(ShareType type) {
    switch (type) {
      case ShareType.repost:
        return 'repost';
      case ShareType.directMessage:
        return 'direct_message';
      case ShareType.external:
        return 'external';
    }
  }
}
