import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/core/errors/exceptions.dart';
import 'package:myitihas/features/social/data/datasources/social_data_source.dart';
import 'package:myitihas/features/social/domain/entities/share.dart';
import '../models/comment_model.dart';
import '../models/like_model.dart';
import '../models/share_model.dart';

@LazySingleton(as: SocialDataSource)
class SocialRemoteDataSource implements SocialDataSource {
  final SupabaseClient _supabase;

  SocialRemoteDataSource(this._supabase);

  @override
  Future<void> likeStory(String userId, String storyId) async {
    final logger = getIt<Talker>();

    try {
      await _supabase.from('likes').upsert(
        {
          'user_id': userId,
          'likeable_type': 'story',
          'likeable_id': storyId,
        },
        onConflict: 'user_id,likeable_type,likeable_id',
      );

      logger.debug('[SocialRemoteDataSource] Liked story $storyId');
    } catch (e, stackTrace) {
      logger.error('[SocialRemoteDataSource] Error liking story', e, stackTrace);
      throw ServerException('Failed to like story: ${e.toString()}');
    }
  }

  @override
  Future<void> unlikeStory(String userId, String storyId) async {
    final logger = getIt<Talker>();

    try {
      await _supabase
          .from('likes')
          .delete()
          .eq('user_id', userId)
          .eq('likeable_type', 'story')
          .eq('likeable_id', storyId);

      logger.debug('[SocialRemoteDataSource] Unliked story $storyId');
    } catch (e, stackTrace) {
      logger.error(
        '[SocialRemoteDataSource] Error unliking story',
        e,
        stackTrace,
      );
      throw ServerException('Failed to unlike story: ${e.toString()}');
    }
  }

  @override
  Future<bool> isStoryLiked(String userId, String storyId) async {
    try {
      final response = await _supabase
          .from('likes')
          .select('id')
          .eq('user_id', userId)
          .eq('likeable_type', 'story')
          .eq('likeable_id', storyId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<int> getStoryLikeCount(String storyId) async {
    try {
      final response = await _supabase
          .from('likes')
          .select()
          .eq('likeable_type', 'story')
          .eq('likeable_id', storyId)
          .count(CountOption.exact);

      return response.count;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<List<LikeModel>> getStoryLikes(String storyId) async {
    final logger = getIt<Talker>();

    try {
      final response = await _supabase
          .from('likes')
          .select()
          .eq('likeable_type', 'story')
          .eq('likeable_id', storyId)
          .order('created_at', ascending: false);

      return (response as List).map((json) {
        return LikeModel(
          userId: json['user_id'] as String,
          contentId: json['likeable_id'] as String,
          contentType: json['likeable_type'] as String? ?? 'story',
          timestamp: DateTime.parse(json['created_at'] as String),
        );
      }).toList();
    } catch (e, stackTrace) {
      logger.error(
        '[SocialRemoteDataSource] Error getting story likes',
        e,
        stackTrace,
      );
      return [];
    }
  }

  @override
  Future<CommentModel> addComment({
    required String storyId,
    required String userId,
    required String text,
    String? parentCommentId,
  }) async {
    final logger = getIt<Talker>();

    try {
      final userProfile = await _supabase
          .from('profiles')
          .select('username, full_name, avatar_url')
          .eq('id', userId)
          .maybeSingle();

      final userName = (userProfile?['username'] ??
          userProfile?['full_name'] ??
          'Anonymous') as String;
      final userAvatar = (userProfile?['avatar_url'] as String?) ?? '';

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
          throw const ValidationException(
            'Maximum comment depth (3) exceeded',
          );
        }
        rootCommentId = parent['root_comment_id'] as String? ?? parentCommentId;
      }

      final commentData = {
        'author_id': userId,
        'commentable_type': 'story',
        'commentable_id': storyId,
        'content': text.trim(),
        'parent_comment_id': parentCommentId,
        'depth': depth,
        'root_comment_id': rootCommentId,
      };

      final response = await _supabase
          .from('comments')
          .insert(commentData)
          .select()
          .single();

      logger.info(
        '[SocialRemoteDataSource] Added comment to story $storyId',
      );

      return CommentModel(
        id: response['id'] as String,
        contentId: storyId,
        contentType: 'story',
        userId: userId,
        userName: userName,
        userAvatar: userAvatar,
        text: response['content'] as String,
        createdAt: DateTime.parse(response['created_at'] as String),
        parentCommentId: parentCommentId,
        depth: depth,
        likeCount: 0,
        isLikedByCurrentUser: false,
      );
    } on ValidationException {
      rethrow;
    } catch (e, stackTrace) {
      logger.error(
        '[SocialRemoteDataSource] Error adding comment',
        e,
        stackTrace,
      );
      throw ServerException('Failed to add comment: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteComment(String commentId) async {
    final logger = getIt<Talker>();

    try {
      await _supabase.from('comments').delete().eq('id', commentId);
      logger.debug('[SocialRemoteDataSource] Deleted comment $commentId');
    } catch (e, stackTrace) {
      logger.error(
        '[SocialRemoteDataSource] Error deleting comment',
        e,
        stackTrace,
      );
      throw ServerException('Failed to delete comment: ${e.toString()}');
    }
  }

  @override
  Future<void> likeComment(String userId, String commentId) async {
    final logger = getIt<Talker>();

    try {
      await _supabase.from('likes').upsert(
        {
          'user_id': userId,
          'likeable_type': 'comment',
          'likeable_id': commentId,
        },
        onConflict: 'user_id,likeable_type,likeable_id',
      );

      logger.debug('[SocialRemoteDataSource] Liked comment $commentId');
    } catch (e, stackTrace) {
      logger.error(
        '[SocialRemoteDataSource] Error liking comment',
        e,
        stackTrace,
      );
      throw ServerException('Failed to like comment: ${e.toString()}');
    }
  }

  @override
  Future<void> unlikeComment(String userId, String commentId) async {
    final logger = getIt<Talker>();

    try {
      await _supabase
          .from('likes')
          .delete()
          .eq('user_id', userId)
          .eq('likeable_type', 'comment')
          .eq('likeable_id', commentId);

      logger.debug('[SocialRemoteDataSource] Unliked comment $commentId');
    } catch (e, stackTrace) {
      logger.error(
        '[SocialRemoteDataSource] Error unliking comment',
        e,
        stackTrace,
      );
      throw ServerException('Failed to unlike comment: ${e.toString()}');
    }
  }

  @override
  Future<void> toggleCommentCollapse(String commentId) async {
    // This is a client-side UI state, not persisted in database
    // The caller should manage this state locally
  }

  @override
  Future<List<CommentModel>> getComments(String storyId) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;

      final response = await _supabase
          .from('comments')
          .select('''
            id, content, created_at, author_id, parent_comment_id, depth,
            like_count, reply_count,
            author:profiles!comments_author_id_fkey(id, username, full_name, avatar_url)
          ''')
          .eq('commentable_type', 'story')
          .eq('commentable_id', storyId)
          .isFilter('parent_comment_id', null)
          .order('created_at', ascending: false);

      final comments = <CommentModel>[];

      for (final commentJson in response) {
        final author = commentJson['author'] as Map<String, dynamic>?;

        bool isLiked = false;
        if (currentUserId != null) {
          final likeCheck = await _supabase
              .from('likes')
              .select('id')
              .eq('user_id', currentUserId)
              .eq('likeable_type', 'comment')
              .eq('likeable_id', commentJson['id'])
              .maybeSingle();
          isLiked = likeCheck != null;
        }

        final replies = await _getCommentReplies(
          rootCommentId: commentJson['id'],
          currentUserId: currentUserId,
        );

        final comment = CommentModel(
          id: commentJson['id'] as String,
          contentId: storyId,
          contentType: 'story',
          userId: commentJson['author_id'] as String,
          userName: (author?['username'] ?? author?['full_name'] ?? 'Anonymous') as String,
          userAvatar: (author?['avatar_url'] as String?) ?? '',
          text: commentJson['content'] as String,
          createdAt: DateTime.parse(commentJson['created_at'] as String),
          parentCommentId: null,
          depth: 0,
          likeCount: commentJson['like_count'] as int? ?? 0,
          isLikedByCurrentUser: isLiked,
          replies: replies,
        );

        comments.add(comment);
      }

      logger.debug(
        '[SocialRemoteDataSource] Fetched ${comments.length} comments for story $storyId',
      );
      return comments;
    } catch (e, stackTrace) {
      logger.error(
        '[SocialRemoteDataSource] Error getting comments',
        e,
        stackTrace,
      );
      return [];
    }
  }

  Future<List<CommentModel>> _getCommentReplies({
    required String rootCommentId,
    String? currentUserId,
  }) async {
    try {
      final response = await _supabase
          .from('comments')
          .select('''
            id, content, created_at, author_id, parent_comment_id, depth,
            like_count, reply_count,
            author:profiles!comments_author_id_fkey(id, username, full_name, avatar_url)
          ''')
          .eq('root_comment_id', rootCommentId)
          .order('created_at', ascending: true);

      final replies = <CommentModel>[];

      for (final replyJson in response) {
        final author = replyJson['author'] as Map<String, dynamic>?;

        bool isLiked = false;
        if (currentUserId != null) {
          final likeCheck = await _supabase
              .from('likes')
              .select('id')
              .eq('user_id', currentUserId)
              .eq('likeable_type', 'comment')
              .eq('likeable_id', replyJson['id'])
              .maybeSingle();
          isLiked = likeCheck != null;
        }

        replies.add(CommentModel(
          id: replyJson['id'] as String,
          contentId: '',
          contentType: 'story',
          userId: replyJson['author_id'] as String,
          userName: (author?['username'] ?? author?['full_name'] ?? 'Anonymous') as String,
          userAvatar: (author?['avatar_url'] as String?) ?? '',
          text: replyJson['content'] as String,
          createdAt: DateTime.parse(replyJson['created_at'] as String),
          parentCommentId: replyJson['parent_comment_id'] as String?,
          depth: replyJson['depth'] as int? ?? 0,
          likeCount: replyJson['like_count'] as int? ?? 0,
          isLikedByCurrentUser: isLiked,
        ));
      }

      return replies;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> shareStory({
    required String userId,
    required String storyId,
    required ShareType shareType,
    String? recipientId,
  }) async {
    final logger = getIt<Talker>();

    try {
      String dbShareType;
      switch (shareType) {
        case ShareType.external:
          dbShareType = 'external';
        case ShareType.directMessage:
          dbShareType = 'direct_message';
        case ShareType.repost:
          dbShareType = 'repost';
      }

      await _supabase.from('shares').insert({
        'user_id': userId,
        'shareable_type': 'story',
        'shareable_id': storyId,
        'share_type': dbShareType,
        'recipient_id': recipientId,
      });

      logger.info(
        '[SocialRemoteDataSource] Shared story $storyId via $dbShareType',
      );
    } catch (e, stackTrace) {
      logger.error(
        '[SocialRemoteDataSource] Error sharing story',
        e,
        stackTrace,
      );
      throw ServerException('Failed to share story: ${e.toString()}');
    }
  }

  @override
  Future<int> getStoryShareCount(String storyId) async {
    try {
      final response = await _supabase
          .from('shares')
          .select()
          .eq('shareable_type', 'story')
          .eq('shareable_id', storyId)
          .count(CountOption.exact);

      return response.count;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<List<ShareModel>> getStoryShares(String storyId) async {
    final logger = getIt<Talker>();

    try {
      final response = await _supabase
          .from('shares')
          .select()
          .eq('shareable_type', 'story')
          .eq('shareable_id', storyId)
          .order('created_at', ascending: false);

      return (response as List).map((json) {
        ShareType shareType;
        switch (json['share_type'] as String) {
          case 'direct_message':
            shareType = ShareType.directMessage;
          case 'repost':
            shareType = ShareType.repost;
          default:
            shareType = ShareType.external;
        }

        return ShareModel(
          userId: json['user_id'] as String,
          contentId: json['shareable_id'] as String,
          contentType: json['shareable_type'] as String? ?? 'story',
          shareType: shareType,
          recipientId: json['recipient_id'] as String?,
          timestamp: DateTime.parse(json['created_at'] as String),
        );
      }).toList();
    } catch (e, stackTrace) {
      logger.error(
        '[SocialRemoteDataSource] Error getting story shares',
        e,
        stackTrace,
      );
      return [];
    }
  }
}
