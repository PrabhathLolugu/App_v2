import 'dart:convert';
import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/core/errors/exceptions.dart';
import 'package:myitihas/features/social/domain/utils/post_caption_metadata.dart';
import 'package:myitihas/services/profile_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import 'package:talker_flutter/talker_flutter.dart';
import 'package:uuid/uuid.dart';

/// Represents the type of post content
enum PostType { text, image, video, storyShare }

/// Represents the visibility of a post
enum PostVisibility { public, followers, private }

/// PostgREST [or] splits on commas; JSON for [contains] must be double-quoted.
/// Matches [metadata.tags] **or** `#tag` in caption/title (legacy rows without persisted tags).
String _postgrestHashtagOrClause(String hashtagNormalized) {
  final tag = hashtagNormalized.toLowerCase().trim();
  if (tag.isEmpty) return '';
  final csJson = jsonEncode({'tags': [tag]});
  final quotedCs = '"${csJson.replaceAll(r'\', r'\\').replaceAll('"', r'\"')}"';
  final ilikePattern = _ilikeHashtagCaptionPattern(tag);
  final quotedIlike =
      '"${ilikePattern.replaceAll(r'\', r'\\').replaceAll('"', r'\"')}"';
  return 'metadata.cs.$quotedCs,content.ilike.$quotedIlike,title.ilike.$quotedIlike';
}

/// ILIKE pattern for a literal `#` + tag substring (same idea as `strpos(..., '#' || tag)`).
/// Postgres default LIKE has no escape char; `%` / `_` inside rare tags may act as wildcards.
String _ilikeHashtagCaptionPattern(String normalizedTagLowercase) {
  return '%#$normalizedTagLowercase%';
}

class PollSummary {
  const PollSummary({
    required this.counts,
    required this.totalVotes,
    this.myOption,
  });

  final List<int> counts;
  final int totalVotes;
  final int? myOption;
}

/// Service for managing posts in the social feed.
///
/// Handles CRUD operations for posts, media uploads, and feed retrieval.
/// All operations use auth.uid() to ensure proper authorization.
@lazySingleton
class PostService {
  final SupabaseClient _supabase;
  final ProfileService _profileService;

  PostService(this._supabase, this._profileService);

  Future<Map<String, dynamic>> _applyCaptionMetadata({
    required Map<String, dynamic>? metadata,
    required String? content,
    required String? title,
  }) async {
    final base = Map<String, dynamic>.from(metadata ?? {});
    final tags = normalizedHashtagsFromText(content, title);
    final names = mentionUsernamesFromText(content, title);
    final idMap = await _profileService.getUserIdsByUsernames(names);
    base['tags'] = mergeTagLists(base['tags'], tags);
    final mentions = buildMentionsJson(names, idMap);
    if (mentions.isEmpty) {
      base.remove('mentions');
    } else {
      base['mentions'] = mentions;
    }
    final tagList = base['tags'];
    if (tagList is List && tagList.isEmpty) {
      base.remove('tags');
    }
    return base;
  }

  /// Creates a new post with optional media.
  ///
  /// [postType] - Type of post (text, image, video, storyShare)
  /// [content] - Main text content/caption
  /// [title] - Optional title for the post
  /// [mediaFiles] - List of media files to upload (for image/video posts)
  /// [visibility] - Who can see the post (default: public)
  /// [sharedStoryId] - Story ID if this is a story share post
  /// [metadata] - Additional metadata as JSON
  ///
  /// Returns the created post data including generated ID.
  ///
  /// Throws [AuthException] if user is not authenticated.
  /// Throws [ServerException] on database/storage errors.
  Future<Map<String, dynamic>> createPost({
    required PostType postType,
    String? content,
    String? title,
    List<File>? mediaFiles,
    PostVisibility visibility = PostVisibility.public,
    String? sharedStoryId,
    String? repostedPostId,
    Map<String, dynamic>? metadata,

    /// When set, the post will be scheduled for this UTC time and created with
    /// status = 'scheduled'. All scheduling times must be converted to UTC by
    /// the caller (e.g. from IST).
    DateTime? scheduledAtUtc,

    /// Logical status of the post: 'published' (default) or 'scheduled', etc.
    /// This must stay in sync with the database constraint on posts.status.
    String status = 'published',
  }) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw AuthException('User must be authenticated to create posts');
      }

      logger.info(
        '[PostService] Creating ${postType.name} post for user $currentUserId',
      );

      // Upload media files if provided
      List<String> mediaUrls = [];
      String? thumbnailUrl;

      if (mediaFiles != null && mediaFiles.isNotEmpty) {
        for (int i = 0; i < mediaFiles.length; i++) {
          final file = mediaFiles[i];
          final fileExt = file.path.split('.').last.toLowerCase();

          // Convert HEIF/HEIC to JPEG (not supported by Supabase Storage)
          File fileToUpload = file;
          String uploadExt = fileExt;

          if (fileExt == 'heif' || fileExt == 'heic') {
            logger.debug('[PostService] Converting HEIF/HEIC to JPEG');
            final compressedBytes = await FlutterImageCompress.compressWithFile(
              file.absolute.path,
              format: CompressFormat.jpeg,
              quality: 90,
            );

            if (compressedBytes != null) {
              final tempDir = await getTemporaryDirectory();
              final tempFile = File('${tempDir.path}/${const Uuid().v4()}.jpg');
              await tempFile.writeAsBytes(compressedBytes);
              fileToUpload = tempFile;
              uploadExt = 'jpg';
            }
          }

          final fileName = '${const Uuid().v4()}.$uploadExt';
          final storagePath = '$currentUserId/$fileName';

          logger.debug('[PostService] Uploading media: $storagePath');

          await _supabase.storage
              .from('post-media')
              .upload(
                storagePath,
                fileToUpload,
                fileOptions: const FileOptions(
                  cacheControl: '3600',
                  upsert: false,
                ),
              );

          final publicUrl = _supabase.storage
              .from('post-media')
              .getPublicUrl(storagePath);
          mediaUrls.add(publicUrl);

          // First image/video becomes thumbnail
          if (i == 0) {
            thumbnailUrl = publicUrl;
          }

          // Clean up temp file if we created one
          if (fileToUpload != file) {
            try {
              await fileToUpload.delete();
            } catch (_) {}
          }
        }

        logger.debug('[PostService] Uploaded ${mediaUrls.length} media files');
      }

      final mergedMetadata = await _applyCaptionMetadata(
        metadata: metadata,
        content: content,
        title: title,
      );

      // Prepare post data
      final postData = <String, dynamic>{
        'author_id': currentUserId,
        'post_type': _postTypeToString(postType),
        'content': content,
        'title': title,
        'media_urls': mediaUrls,
        'thumbnail_url': thumbnailUrl,
        'visibility': _visibilityToString(visibility),
        'shared_story_id': sharedStoryId,
        'reposted_post_id': repostedPostId,
        'metadata': mergedMetadata,
        'scheduled_at': scheduledAtUtc?.toUtc().toIso8601String(),
        'status': status,
      };

      // Insert post
      final response = await _supabase
          .from('posts')
          .insert(postData)
          .select()
          .single();

      logger.info('[PostService] Created post: ${response['id']}');
      return response;
    } on AuthException {
      rethrow;
    } on StorageException catch (e, stackTrace) {
      logger.error('[PostService] Storage error creating post', e, stackTrace);
      throw ServerException(
        'Failed to upload media: ${e.message}',
        e.statusCode,
      );
    } on PostgrestException catch (e, stackTrace) {
      logger.error('[PostService] Database error creating post', e, stackTrace);
      throw ServerException('Failed to create post: ${e.message}', e.code);
    } catch (e, stackTrace) {
      logger.error(
        '[PostService] Unexpected error creating post',
        e,
        stackTrace,
      );
      throw const ServerException('Failed to create post');
    }
  }

  /// Creates a repost for an existing post.
  ///
  /// The repost keeps a relation to the original post via `reposted_post_id` and
  /// copies media/title metadata so existing cards can render it immediately.
  Future<Map<String, dynamic>> createRepost({
    required String originalPostId,
    String? quoteCaption,
  }) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw AuthException('User must be authenticated to repost');
      }

      Map<String, dynamic>? original;
      try {
        original = await _supabase
            .from('posts')
            .select(_postWithRelationsSelect)
            .eq('id', originalPostId)
            .eq('status', 'published')
            .maybeSingle();
      } on PostgrestException catch (e) {
        if (!_isMissingRepostRelationError(e)) rethrow;
        original = await _supabase
            .from('posts')
            .select(_postWithRelationsSelectLegacy)
            .eq('id', originalPostId)
            .eq('status', 'published')
            .maybeSingle();
      }

      if (original == null) {
        throw const ServerException('Original post not found', '404');
      }

      final originalPostType = original['post_type'] as String?;
      if (originalPostType == null ||
          !{'image', 'text', 'video'}.contains(originalPostType)) {
        throw const ServerException(
          'Only image, text, or video posts can be reposted',
          '400',
        );
      }

      final trimmedQuote = quoteCaption?.trim();
      final originalContent = original['content'] as String?;

      var repostMetadata =
          Map<String, dynamic>.from(original['metadata'] ?? <String, dynamic>{});
      if (trimmedQuote != null && trimmedQuote.isNotEmpty) {
        repostMetadata
          ..remove('tags')
          ..remove('mentions');
        repostMetadata = await _applyCaptionMetadata(
          metadata: repostMetadata,
          content: trimmedQuote,
          title: null,
        );
      }

      final repostData = <String, dynamic>{
        'author_id': currentUserId,
        'post_type': originalPostType,
        'title': original['title'],
        'content':
            (trimmedQuote != null && trimmedQuote.isNotEmpty)
                ? trimmedQuote
                : originalContent,
        'media_urls': original['media_urls'] ?? <String>[],
        'thumbnail_url': original['thumbnail_url'],
        'video_duration_seconds': original['video_duration_seconds'],
        'visibility': 'public',
        'metadata': repostMetadata,
        'status': 'published',
        'published_at': DateTime.now().toUtc().toIso8601String(),
        'reposted_post_id': originalPostId,
      };

      // Use legacy select on insert — returning with `reposted_post:posts!…` embed
      // can fail or roll back the whole request on some PostgREST/RLS setups.
      final response = await _supabase
          .from('posts')
          .insert(repostData)
          .select(_postWithRelationsSelectLegacy)
          .single();

      final enriched = Map<String, dynamic>.from(response);
      enriched['reposted_post'] = _repostedPostEmbedFromRow(original);

      logger.info(
        '[PostService] User $currentUserId reposted post $originalPostId as ${enriched['id']}',
      );
      return enriched;
    } on AuthException {
      rethrow;
    } on ServerException {
      rethrow;
    } on PostgrestException catch (e, stackTrace) {
      logger.error('[PostService] Database error creating repost', e, stackTrace);
      throw ServerException('Failed to create repost: ${e.message}', e.code);
    } catch (e, stackTrace) {
      logger.error('[PostService] Unexpected error creating repost', e, stackTrace);
      throw const ServerException('Failed to create repost');
    }
  }

  /// Gets a single post by ID.
  ///
  /// Returns post data with author profile information.
  /// RLS policies automatically filter based on visibility.
  Future<Map<String, dynamic>?> getPost(String postId) async {
    final logger = getIt<Talker>();

    try {
      Map<String, dynamic>? response;
      try {
        response = await _supabase
            .from('posts')
            .select(_postWithRelationsSelect)
            .eq('id', postId)
            .maybeSingle();
      } on PostgrestException catch (e) {
        if (!_isMissingRepostRelationError(e)) rethrow;
        response = await _supabase
            .from('posts')
            .select(_postWithRelationsSelectLegacy)
            .eq('id', postId)
            .maybeSingle();
      }

      return response;
    } catch (e, stackTrace) {
      logger.error('[PostService] Error fetching post $postId', e, stackTrace);
      throw ServerException('Failed to fetch post: ${e.toString()}');
    }
  }

  /// Updates an existing post.
  ///
  /// Only the author can update their posts (enforced by RLS).
  /// For scheduling: pass [status] ('published' | 'scheduled' | 'cancelled'),
  /// [scheduledAtUtc] for schedule time, [publishedAtUtc] when publishing now.
  Future<void> updatePost({
    required String postId,
    String? content,
    String? title,
    PostVisibility? visibility,
    bool? isCommentsDisabled,
    Map<String, dynamic>? metadata,

    /// Set to 'published' to publish now, 'scheduled' to keep/update schedule, 'cancelled' to cancel.
    String? status,

    /// New scheduled time (UTC). Used when status is 'scheduled'.
    DateTime? scheduledAtUtc,

    /// When publishing immediately, set to now() in UTC.
    DateTime? publishedAtUtc,
  }) async {
    final logger = getIt<Talker>();

    try {
      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      };

      if (content != null) updates['content'] = content;
      if (title != null) updates['title'] = title;
      if (visibility != null) {
        updates['visibility'] = _visibilityToString(visibility);
      }
      if (isCommentsDisabled != null) {
        updates['is_comments_disabled'] = isCommentsDisabled;
      }
      if (metadata != null) updates['metadata'] = metadata;
      if (status != null) updates['status'] = status;
      if (scheduledAtUtc != null) {
        updates['scheduled_at'] = scheduledAtUtc.toUtc().toIso8601String();
      }
      if (publishedAtUtc != null) {
        updates['published_at'] = publishedAtUtc.toUtc().toIso8601String();
      }
      if (status == 'published' && !updates.containsKey('published_at')) {
        updates['published_at'] = DateTime.now().toUtc().toIso8601String();
      }

      await _supabase.from('posts').update(updates).eq('id', postId);

      logger.info('[PostService] Updated post $postId');
    } catch (e, stackTrace) {
      logger.error('[PostService] Error updating post $postId', e, stackTrace);
      throw ServerException('Failed to update post: ${e.toString()}');
    }
  }

  /// Updates post body and recomputes `metadata.tags` / `metadata.mentions` from text.
  Future<void> updatePostCaptionWithMergedMetadata({
    required String postId,
    required String content,
  }) async {
    final row = await getPost(postId);
    if (row == null) {
      throw const ServerException('Post not found');
    }
    final title = row['title'] as String?;
    final existingMeta = row['metadata'];
    final merged = await _applyCaptionMetadata(
      metadata: existingMeta is Map<String, dynamic>
          ? existingMeta
          : (existingMeta != null
                ? Map<String, dynamic>.from(existingMeta as Map)
                : null),
      content: content,
      title: title,
    );
    await updatePost(postId: postId, content: content, metadata: merged);
  }

  /// Fetches scheduled posts for the current user only.
  /// Used on own profile to show "Scheduled" section.
  Future<List<Map<String, dynamic>>> getScheduledPostsForCurrentUser({
    int limit = 20,
    int offset = 0,
  }) async {
    final logger = getIt<Talker>();
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) return [];

    try {
      List<dynamic> response;
      try {
        response = await _supabase
            .from('posts')
            .select(_postWithRelationsSelect)
            .eq('author_id', currentUserId)
            .eq('status', 'scheduled')
            .order('scheduled_at', ascending: true)
            .range(offset, offset + limit - 1);
      } on PostgrestException catch (e) {
        if (!_isMissingRepostRelationError(e)) rethrow;
        response = await _supabase
            .from('posts')
            .select(_postWithRelationsSelectLegacy)
            .eq('author_id', currentUserId)
            .eq('status', 'scheduled')
            .order('scheduled_at', ascending: true)
            .range(offset, offset + limit - 1);
      }

      logger.debug(
        '[PostService] Fetched ${response.length} scheduled posts for user $currentUserId',
      );
      return List<Map<String, dynamic>>.from(response);
    } catch (e, stackTrace) {
      logger.error(
        '[PostService] Error fetching scheduled posts',
        e,
        stackTrace,
      );
      throw ServerException('Failed to fetch scheduled posts: ${e.toString()}');
    }
  }

  /// Deletes a post.
  ///
  /// Only the author can delete their posts (enforced by RLS).
  /// Associated media files are NOT automatically deleted.
  Future<void> deletePost(String postId) async {
    final logger = getIt<Talker>();

    try {
      await _supabase.from('posts').delete().eq('id', postId);
      logger.info('[PostService] Deleted post $postId');
    } catch (e, stackTrace) {
      logger.error('[PostService] Error deleting post $postId', e, stackTrace);
      throw ServerException('Failed to delete post: ${e.toString()}');
    }
  }

  /// Reports a post for moderation.
  ///
  /// A user can report a post once; subsequent reports update the reason/details.
  Future<void> reportPost({
    required String postId,
    required String reason,
    String? details,
  }) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw AuthException('User must be authenticated to report posts');
      }

      if (reason.trim().isEmpty) {
        throw const ServerException('Report reason is required', '400');
      }

      await _supabase.from('post_reports').upsert({
        'post_id': postId,
        'reporter_id': currentUserId,
        'reason': reason.trim(),
        'details': details?.trim(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }, onConflict: 'post_id,reporter_id');

      logger.info('[PostService] User $currentUserId reported post $postId');
    } on AuthException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e, stackTrace) {
      logger.error('[PostService] Error reporting post $postId', e, stackTrace);
      throw ServerException('Failed to report post: ${e.toString()}');
    }
  }

  /// Gets the main social feed with chronological ordering.
  ///
  /// [limit] - Maximum number of posts to fetch
  /// [offset] - Number of posts to skip (for pagination)
  /// [postType] - Optional filter by post type
  ///
  /// Returns posts with author profile data, ordered by most recent.
  Future<List<Map<String, dynamic>>> getFeed({
    required int limit,
    required int offset,
    PostType? postType,
    /// Normalized tag without `#` (lowercase); filters `metadata.tags` via JSON contains.
    String? hashtagNormalized,
  }) async {
    final logger = getIt<Talker>();

    try {
      Future<List<dynamic>> runQuery(String selectClause) async {
        var query = _supabase.from('posts').select(selectClause);

        if (postType != null) {
          query = query.eq('post_type', _postTypeToString(postType));
        }

        query = query.eq('status', 'published');

        if (hashtagNormalized != null && hashtagNormalized.isNotEmpty) {
          query = query.or(_postgrestHashtagOrClause(hashtagNormalized));
        }

        return await query
            .order('created_at', ascending: false)
            .range(offset, offset + limit - 1);
      }

      List<dynamic> response;
      try {
        response = await runQuery(_postWithRelationsSelect);
      } on PostgrestException catch (e) {
        if (!_isMissingRepostRelationError(e)) rethrow;
        response = await runQuery(_postWithRelationsSelectLegacy);
      }

      logger.debug('[PostService] Fetched ${response.length} feed items');
      return List<Map<String, dynamic>>.from(response);
    } catch (e, stackTrace) {
      logger.error('[PostService] Error fetching feed', e, stackTrace);
      throw ServerException('Failed to fetch feed: ${e.toString()}');
    }
  }

  /// Gets posts by a specific user.
  ///
  /// RLS policies automatically filter based on visibility and follow status.
  Future<List<Map<String, dynamic>>> getUserPosts({
    required String userId,
    required int limit,
    required int offset,
  }) async {
    final logger = getIt<Talker>();

    try {
      List<dynamic> response;
      try {
        response = await _supabase
            .from('posts')
            .select(_postWithRelationsSelect)
            .eq('author_id', userId)
            .eq('status', 'published')
            .order('created_at', ascending: false)
            .range(offset, offset + limit - 1);
      } on PostgrestException catch (e) {
        if (!_isMissingRepostRelationError(e)) rethrow;
        response = await _supabase
            .from('posts')
            .select(_postWithRelationsSelectLegacy)
            .eq('author_id', userId)
            .eq('status', 'published')
            .order('created_at', ascending: false)
            .range(offset, offset + limit - 1);
      }

      logger.debug(
        '[PostService] Fetched ${response.length} posts for user $userId',
      );
      return List<Map<String, dynamic>>.from(response);
    } catch (e, stackTrace) {
      logger.error('[PostService] Error fetching user posts', e, stackTrace);
      throw ServerException('Failed to fetch user posts: ${e.toString()}');
    }
  }

  /// Gets the count of posts by a specific user.
  ///
  /// This is optimized to only count records without fetching full data.
  /// RLS policies automatically filter based on visibility and follow status.
  Future<int> getUserPostCount(String userId) async {
    final logger = getIt<Talker>();

    try {
      final response = await _supabase
          .from('posts')
          .select()
          .eq('author_id', userId)
          .count(CountOption.exact);

      final count = response.count;
      logger.debug('[PostService] User $userId has $count posts');
      return count;
    } catch (e, stackTrace) {
      logger.error('[PostService] Error counting user posts', e, stackTrace);
      throw ServerException('Failed to count user posts: ${e.toString()}');
    }
  }

  /// Gets posts by a specific user filtered by post type.
  ///
  /// RLS policies automatically filter based on visibility and follow status.
  Future<List<Map<String, dynamic>>> getUserPostsByType({
    required String userId,
    required PostType postType,
    required int limit,
    required int offset,
  }) async {
    final logger = getIt<Talker>();

    try {
      List<dynamic> response;
      try {
        response = await _supabase
            .from('posts')
            .select(_postWithRelationsSelect)
            .eq('author_id', userId)
            .eq('post_type', _postTypeToString(postType))
            .eq('status', 'published')
            .order('created_at', ascending: false)
            .range(offset, offset + limit - 1);
      } on PostgrestException catch (e) {
        if (!_isMissingRepostRelationError(e)) rethrow;
        response = await _supabase
            .from('posts')
            .select(_postWithRelationsSelectLegacy)
            .eq('author_id', userId)
            .eq('post_type', _postTypeToString(postType))
            .eq('status', 'published')
            .order('created_at', ascending: false)
            .range(offset, offset + limit - 1);
      }

      logger.debug(
        '[PostService] Fetched ${response.length} ${postType.name} posts for user $userId',
      );
      return List<Map<String, dynamic>>.from(response);
    } catch (e, stackTrace) {
      logger.error(
        '[PostService] Error fetching user posts by type',
        e,
        stackTrace,
      );
      throw ServerException('Failed to fetch user posts: ${e.toString()}');
    }
  }

  /// Gets posts from users the current user follows.
  ///
  /// This provides a "following" feed experience.
  Future<List<Map<String, dynamic>>> getFollowingFeed({
    required int limit,
    required int offset,
  }) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        return [];
      }

      // Get posts from followed users using a subquery
      Future<List<dynamic>> runQuery(String selectClause) async {
        return await _supabase
            .from('posts')
            .select(selectClause)
            .filter(
              'author_id',
              'in',
              '(SELECT following_id FROM follows WHERE follower_id = \'$currentUserId\')',
            )
            .eq('status', 'published')
            .order('created_at', ascending: false)
            .range(offset, offset + limit - 1);
      }

      List<dynamic> response;
      try {
        response = await runQuery(_postWithRelationsSelect);
      } on PostgrestException catch (e) {
        if (!_isMissingRepostRelationError(e)) rethrow;
        response = await runQuery(_postWithRelationsSelectLegacy);
      }

      logger.debug(
        '[PostService] Fetched ${response.length} following feed items',
      );
      return List<Map<String, dynamic>>.from(response);
    } catch (e, stackTrace) {
      logger.error(
        '[PostService] Error fetching following feed',
        e,
        stackTrace,
      );
      throw ServerException('Failed to fetch following feed: ${e.toString()}');
    }
  }

  /// Subscribes to real-time post updates for the feed.
  ///
  /// Returns a stream that emits new posts as they are created.
  /// Each new post event contains the full post data with author info.
  Stream<Map<String, dynamic>> subscribeToNewPosts() {
    final logger = getIt<Talker>();

    logger.info('[PostService] Setting up real-time post subscription');

    return _supabase
        .from('posts')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .limit(1)
        .map((data) {
          if (data.isNotEmpty) {
            return data.first;
          }
          return <String, dynamic>{};
        });
  }

  /// Increments the view count for a post.
  /// Gets a single post by its ID.
  ///
  /// Returns null if post doesn't exist or user doesn't have access.
  Future<Map<String, dynamic>?> getPostById(String postId) async {
    final logger = getIt<Talker>();

    try {
      Map<String, dynamic>? response;
      try {
        response = await _supabase
            .from('posts')
            .select(_postWithRelationsSelect)
            .eq('id', postId)
            .maybeSingle();
      } on PostgrestException catch (e) {
        if (!_isMissingRepostRelationError(e)) rethrow;
        response = await _supabase
            .from('posts')
            .select(_postWithRelationsSelectLegacy)
            .eq('id', postId)
            .maybeSingle();
      }

      if (response == null) {
        logger.debug('[PostService] Post $postId not found');
        return null;
      }

      return response;
    } catch (e, stackTrace) {
      logger.error('[PostService] Error fetching post $postId', e, stackTrace);
      return null;
    }
  }

  Future<void> voteOnPoll({
    required String postId,
    required int optionIndex,
  }) async {
    final logger = getIt<Talker>();

    try {
      await _supabase.rpc(
        'submit_post_poll_vote',
        params: {'p_post_id': postId, 'p_option_index': optionIndex},
      );
    } on PostgrestException catch (e, stackTrace) {
      logger.error('[PostService] Error voting on poll $postId', e, stackTrace);
      throw ServerException(e.message, e.code);
    } catch (e, stackTrace) {
      logger.error('[PostService] Error voting on poll $postId', e, stackTrace);
      throw ServerException('Failed to submit poll vote: ${e.toString()}');
    }
  }

  Future<Map<String, PollSummary>> fetchPollSummaries(
    List<String> postIds,
  ) async {
    final logger = getIt<Talker>();
    if (postIds.isEmpty) return <String, PollSummary>{};

    try {
      final response = await _supabase.rpc(
        'get_post_poll_summaries',
        params: {'p_post_ids': postIds},
      );
      if (response is! List) return <String, PollSummary>{};

      final summaries = <String, PollSummary>{};
      for (final row in response) {
        if (row is! Map) continue;
        final data = row.cast<String, dynamic>();
        final postId = data['post_id']?.toString();
        if (postId == null || postId.isEmpty) continue;

        final countsRaw = data['counts'];
        final counts = <int>[];
        if (countsRaw is List) {
          for (final item in countsRaw.take(4)) {
            if (item is int) {
              counts.add(item);
            } else if (item is num) {
              counts.add(item.toInt());
            } else {
              counts.add(0);
            }
          }
        }
        while (counts.length < 4) {
          counts.add(0);
        }

        final totalRaw = data['total_votes'];
        final totalVotes = totalRaw is int
            ? totalRaw
            : totalRaw is num
            ? totalRaw.toInt()
            : 0;

        final myOptionRaw = data['my_option'];
        final myOption = myOptionRaw is int
            ? myOptionRaw
            : myOptionRaw is num
            ? myOptionRaw.toInt()
            : null;

        summaries[postId] = PollSummary(
          counts: counts,
          totalVotes: totalVotes,
          myOption: myOption,
        );
      }
      return summaries;
    } on PostgrestException catch (e, stackTrace) {
      logger.error('[PostService] Error fetching poll summaries', e, stackTrace);
      return <String, PollSummary>{};
    } catch (e, stackTrace) {
      logger.error('[PostService] Error fetching poll summaries', e, stackTrace);
      return <String, PollSummary>{};
    }
  }

  /// Increments view count for a post.
  Future<void> incrementViewCount(String postId) async {
    try {
      await _supabase.rpc('increment_post_view', params: {'post_id': postId});
    } catch (e) {
      // Non-critical operation, don't throw
      getIt<Talker>().warning(
        '[PostService] Failed to increment view count: $e',
      );
    }
  }

  // Helper methods
  String _postTypeToString(PostType type) {
    switch (type) {
      case PostType.text:
        return 'text';
      case PostType.image:
        return 'image';
      case PostType.video:
        return 'video';
      case PostType.storyShare:
        return 'story_share';
    }
  }

  String _visibilityToString(PostVisibility visibility) {
    switch (visibility) {
      case PostVisibility.public:
        return 'public';
      case PostVisibility.followers:
        return 'followers';
      case PostVisibility.private:
        return 'private';
    }
  }

  String get _postWithRelationsSelect => '''
            *,
            author:profiles!posts_author_id_fkey(id, username, full_name, avatar_url),
            reposted_post:posts!posts_reposted_post_id_fkey(
              id,
              author_id,
              post_type,
              title,
              content,
              media_urls,
              thumbnail_url,
              like_count,
              comment_count,
              share_count,
              created_at,
              author:profiles!posts_author_id_fkey(id, username, full_name, avatar_url)
            ),
            shared_story:stories!posts_shared_story_id_fkey(
              id,
              title,
              content,
              image_url,
              attributes,
              author_id,
              author,
              published_at,
              comment_count,
              share_count,
              likes,
              views,
              created_at,
              updated_at
            )
          ''';

  /// Shape expected by [PostRepositoryImpl] `_extractRepostedPost` (matches embed).
  Map<String, dynamic> _repostedPostEmbedFromRow(Map<String, dynamic> post) {
    return {
      'id': post['id'],
      'author_id': post['author_id'],
      'post_type': post['post_type'],
      'title': post['title'],
      'content': post['content'],
      'media_urls': post['media_urls'],
      'thumbnail_url': post['thumbnail_url'],
      'like_count': post['like_count'],
      'comment_count': post['comment_count'],
      'share_count': post['share_count'],
      'created_at': post['created_at'],
      'author': post['author'],
    };
  }

  String get _postWithRelationsSelectLegacy => '''
            *,
            author:profiles!posts_author_id_fkey(id, username, full_name, avatar_url),
            shared_story:stories!posts_shared_story_id_fkey(
              id,
              title,
              content,
              image_url,
              attributes,
              author_id,
              author,
              published_at,
              comment_count,
              share_count,
              likes,
              views,
              created_at,
              updated_at
            )
          ''';

  bool _isMissingRepostRelationError(PostgrestException e) {
    final errorText =
        '${e.message} ${e.details ?? ''} ${e.hint ?? ''}'.toLowerCase();
    return errorText.contains('reposted_post') ||
        errorText.contains('reposted_post_id') ||
        errorText.contains('posts_reposted_post_id_fkey') ||
        errorText.contains('could not find a relationship') ||
        errorText.contains('could not embed');
  }
}
