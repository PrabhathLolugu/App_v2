import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/errors/failures.dart';
import 'package:myitihas/core/logging/talker_setup.dart';
import 'package:myitihas/features/social/domain/entities/content_type.dart';
import 'package:myitihas/features/social/domain/entities/post_mention.dart';
import 'package:myitihas/features/social/domain/entities/feed_item.dart';
import 'package:myitihas/features/social/domain/entities/image_post.dart';
import 'package:myitihas/features/social/domain/entities/post_poll.dart';
import 'package:myitihas/features/social/domain/entities/share.dart';
import 'package:myitihas/features/social/domain/entities/text_post.dart';
import 'package:myitihas/features/social/domain/entities/user.dart';
import 'package:myitihas/features/social/domain/entities/video_post.dart';
import 'package:myitihas/features/social/domain/repositories/post_repository.dart';
import 'package:myitihas/features/social/domain/repositories/user_repository.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import 'package:myitihas/features/stories/domain/repositories/story_repository.dart';
import 'package:myitihas/services/post_service.dart';
import 'package:myitihas/services/social_service.dart';

@LazySingleton(as: PostRepository)
class PostRepositoryImpl implements PostRepository {
  final SocialService _socialService;
  final StoryRepository _storyRepository;
  final UserRepository _userRepository;
  final PostService _postService;

  PostRepositoryImpl(
    this._socialService,
    this._storyRepository,
    this._userRepository,
    this._postService,
  );

  @override
  Future<Either<Failure, List<ImagePost>>> getImagePosts({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final response = await _postService.getFeed(
        postType: PostType.image,
        limit: limit,
        offset: offset,
      );
      final imagePosts = response.map((p) => _mapToImagePost(p)).toList();
      return Right(imagePosts);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TextPost>>> getTextPosts({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final response = await _postService.getFeed(
        postType: PostType.text,
        limit: limit,
        offset: offset,
      );
      final withPolls = await _attachPollSummaries(response);
      final textPosts = withPolls.map((p) => _mapToTextPost(p)).toList();
      return Right(textPosts);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VideoPost>>> getVideoPosts({
    int limit = 10,
    int offset = 0,
    String? hashtagNormalized,
  }) async {
    try {
      final response = await _postService.getFeed(
        postType: PostType.video,
        limit: limit,
        offset: offset,
        hashtagNormalized: hashtagNormalized,
      );
      final videoPosts = response.map((p) => _mapToVideoPost(p)).toList();
      return Right(videoPosts);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FeedItem>>> getPosts({
    int limit = 10,
    int offset = 0,
    String? hashtagNormalized,
  }) async {
    try {
      // Fetch enough image/text/story-share posts to fill after combining
      final fetchLimit = limit + offset;
      final responses = await Future.wait([
        _postService.getFeed(
          postType: PostType.image,
          limit: fetchLimit,
          offset: 0,
          hashtagNormalized: hashtagNormalized,
        ),
        _postService.getFeed(
          postType: PostType.text,
          limit: fetchLimit,
          offset: 0,
          hashtagNormalized: hashtagNormalized,
        ),
        _postService.getFeed(
          postType: PostType.storyShare,
          limit: fetchLimit,
          offset: 0,
          hashtagNormalized: hashtagNormalized,
        ),
      ]);

      final imageRows = List<Map<String, dynamic>>.from(responses[0]);
      final textRows = await _attachPollSummaries(
        List<Map<String, dynamic>>.from(responses[1]),
      );
      final sharedStoryRows = List<Map<String, dynamic>>.from(responses[2]);

      final imagePosts = imageRows.map((p) => _mapToFeedItem(p)).toList();
      final textPosts = textRows.map((p) => _mapToFeedItem(p)).toList();
      final sharedStoryPosts = sharedStoryRows.map((p) => _mapToFeedItem(p)).toList();

      // Combine and sort by date
      final feedItems = [...imagePosts, ...textPosts, ...sharedStoryPosts];
      feedItems.sort((a, b) {
        final aDate = a.createdAt ?? DateTime.now();
        final bDate = b.createdAt ?? DateTime.now();
        return bDate.compareTo(aDate);
      });

      // Apply pagination
      final startIndex = offset.clamp(0, feedItems.length);
      final endIndex = (offset + limit).clamp(0, feedItems.length);
      return Right(feedItems.sublist(startIndex, endIndex));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FeedItem>>> getAllFeedItems({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      // Get stories from story repository
      final storiesResult = await _storyRepository.getStories(
        limit: limit,
        offset: offset,
      );

      final stories = storiesResult.fold(
        (failure) => <FeedItem>[],
        (storyList) => storyList.map((s) => FeedItem.story(s)).toList(),
      );

      // Fetch all post types from Supabase
      final fetchLimit = limit + offset;
      final responses = await Future.wait([
        _postService.getFeed(
          postType: PostType.image,
          limit: fetchLimit,
          offset: 0,
        ),
        _postService.getFeed(
          postType: PostType.text,
          limit: fetchLimit,
          offset: 0,
        ),
        _postService.getFeed(
          postType: PostType.video,
          limit: fetchLimit,
          offset: 0,
        ),
      ]);
      final imageRows = List<Map<String, dynamic>>.from(responses[0]);
      final textRows = await _attachPollSummaries(
        List<Map<String, dynamic>>.from(responses[1]),
      );
      final videoRows = List<Map<String, dynamic>>.from(responses[2]);

      final imagePosts = imageRows.map((p) => _mapToFeedItem(p)).toList();
      final textPosts = textRows.map((p) => _mapToFeedItem(p)).toList();
      final videoPosts = videoRows.map((p) => _mapToFeedItem(p)).toList();

      // Combine and sort by date
      final allItems = [...stories, ...imagePosts, ...textPosts, ...videoPosts];
      allItems.sort((a, b) {
        final aDate = a.createdAt ?? DateTime.now();
        final bDate = b.createdAt ?? DateTime.now();
        return bDate.compareTo(aDate);
      });

      // Apply pagination
      final startIndex = offset.clamp(0, allItems.length);
      final endIndex = (offset + limit).clamp(0, allItems.length);
      return Right(allItems.sublist(startIndex, endIndex));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Story>>> getSharedStories({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final response = await _postService.getFeed(
        postType: PostType.storyShare,
        limit: limit,
        offset: offset,
      );
      final stories = response
          .map<Story>((p) => _mapStoryShareToStory(p))
          .toList();
      return Right(stories);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> likeContent({
    required String contentId,
    required ContentType contentType,
  }) async {
    try {
      await _socialService.likeContent(
        contentType: contentType,
        contentId: contentId,
      );
      return const Right(null);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unlikeContent({
    required String contentId,
    required ContentType contentType,
  }) async {
    try {
      await _socialService.unlikeContent(
        contentType: contentType,
        contentId: contentId,
      );
      return const Right(null);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isContentLiked({
    required String contentId,
    required ContentType contentType,
  }) async {
    try {
      final isLiked = await _socialService.isLiked(
        contentType: contentType,
        contentId: contentId,
      );
      return Right(isLiked);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePostContent({
    required String postId,
    required String content,
  }) async {
    try {
      await _postService.updatePostCaptionWithMergedMetadata(
        postId: postId,
        content: content,
      );
      return const Right(null);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePostSchedule({
    required String postId,
    String? status,
    DateTime? scheduledAtUtc,
  }) async {
    try {
      await _postService.updatePost(
        postId: postId,
        status: status,
        scheduledAtUtc: scheduledAtUtc,
      );
      return const Right(null);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FeedItem>>> getScheduledPostsForCurrentUser({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final posts = await _postService.getScheduledPostsForCurrentUser(
        limit: limit,
        offset: offset,
      );
      final withPolls = await _attachPollSummaries(posts);
      final feedItems = withPolls.map((p) => _mapToFeedItem(p)).toList();
      return Right(feedItems);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getUserPostCount(String userId) async {
    try {
      final count = await _postService.getUserPostCount(userId);
      return Right(count);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FeedItem>>> getUserPostsByType({
    required String userId,
    required String postType,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      PostType type;
      switch (postType) {
        case 'image':
          type = PostType.image;
        case 'video':
          type = PostType.video;
        case 'text':
          type = PostType.text;
        case 'story_share':
          type = PostType.storyShare;
        default:
          return Left(UnexpectedFailure('Invalid post type: $postType'));
      }

      final posts = await _postService.getUserPostsByType(
        userId: userId,
        postType: type,
        limit: limit,
        offset: offset,
      );
      final withPolls = await _attachPollSummaries(posts);
      final feedItems = withPolls.map((p) => _mapToFeedItem(p)).toList();
      final enrichedFeedItems = await enrichFeedItemsWithSocialData(feedItems);
      return Right(enrichedFeedItems);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FeedItem>>> getSavedPosts({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final bookmarks = await _socialService.getBookmarks(
        limit: limit,
        offset: offset,
      );

      // Filter to only bookmarks that point to posts (image, text, video, story_share).
      // We rely primarily on the underlying bookmark row's `bookmarkable_type`
      // and fall back to `content_type` for compatibility with older data.
      final postBookmarks = bookmarks
          .where((entry) {
            final bookmarkRow = entry['bookmark'] as Map<String, dynamic>?;
            final bookmarkableType =
                bookmarkRow?['bookmarkable_type'] as String?;
            final contentType = entry['content_type'] as String?;
            final effectiveType = bookmarkableType ?? contentType;
            return effectiveType == 'post';
          })
          .map((entry) => entry['content'])
          .whereType<Map<String, dynamic>>()
          .toList();

      final withPolls = await _attachPollSummaries(postBookmarks);
      final mappedPosts = withPolls.map(_mapToFeedItem).toList();

      final enriched = await enrichFeedItemsWithSocialData(mappedPosts);
      return Right(enriched);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleBookmark({
    required String contentId,
    required ContentType contentType,
  }) async {
    try {
      final isBookmarked = await _socialService.isBookmarked(
        contentType: contentType,
        contentId: contentId,
      );
      if (isBookmarked) {
        await _socialService.removeBookmark(
          contentType: contentType,
          contentId: contentId,
        );
      } else {
        await _socialService.bookmarkContent(
          contentType: contentType,
          contentId: contentId,
        );
      }
      return const Right(null);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ImagePost>> getImagePostById(String id) async {
    try {
      final data = await _postService.getPostById(id);
      if (data == null) {
        return Left(NotFoundFailure('Image post not found', 'NOT_FOUND'));
      }
      return Right(_mapToImagePost(data));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TextPost>> getTextPostById(String id) async {
    try {
      final data = await _postService.getPostById(id);
      if (data == null) {
        return Left(NotFoundFailure('Text post not found', 'NOT_FOUND'));
      }
      final withPolls = await _attachPollSummaries([data]);
      return Right(_mapToTextPost(withPolls.first));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VideoPost>> getVideoPostById(String id) async {
    try {
      final data = await _postService.getPostById(id);
      if (data == null) {
        return Left(NotFoundFailure('Video post not found', 'NOT_FOUND'));
      }
      return Right(_mapToVideoPost(data));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePost(String postId) async {
    try {
      await _postService.deletePost(postId);
      return const Right(null);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> reportPost({
    required String postId,
    required String reason,
    String? details,
  }) async {
    try {
      await _postService.reportPost(
        postId: postId,
        reason: reason,
        details: details,
      );
      return const Right(null);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FeedItem>> repostPost({
    required String originalPostId,
    String? quoteCaption,
  }) async {
    try {
      final repostData = await _postService.createRepost(
        originalPostId: originalPostId,
        quoteCaption: quoteCaption,
      );

      try {
        await _socialService.shareContent(
          contentType: ContentType.post,
          contentId: originalPostId,
          shareType: ShareType.repost,
        );
      } catch (e, st) {
        // Repost row is already persisted; shares row is analytics only.
        talker.warning(
          '[PostRepository] shareContent after repost failed (repost still saved)',
          e,
          st,
        );
      }

      return Right(_mapToFeedItem(repostData));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  FeedItem _mapToFeedItem(Map<String, dynamic> data) {
    final postType = data['post_type'] as String? ?? 'text';

    switch (postType) {
      case 'image':
        return FeedItem.imagePost(_mapToImagePost(data));
      case 'story_share':
        return FeedItem.story(_mapStoryShareToStory(data));
      case 'video':
        return FeedItem.videoPost(_mapToVideoPost(data));
      case 'text':
      default:
        return FeedItem.textPost(_mapToTextPost(data));
    }
  }

  ImagePost _mapToImagePost(Map<String, dynamic> data) {
    final author = _extractAuthor(data);
    final mediaUrls = _extractMediaUrls(data);
    final imageUrl = _extractImageUrl(data, mediaUrls);
    final metadata = _extractMetadata(data);
    final repostedPost = _extractRepostedPost(data);

    return ImagePost(
      id: data['id'] as String,
      imageUrl: imageUrl,
      mediaUrls: mediaUrls,
      caption: _extractPostCaption(data),
      title: data['title'] as String?,
      location: _extractLocation(data),
      aspectRatio: _extractAspectRatio(data),
      scheduledAt: _parseDateTime(data['scheduled_at']),
      publishedAt: _parseDateTime(data['published_at']),
      status: (data['status'] as String?) ?? (metadata['status'] as String?),
      tags: _extractTags(data),
      mentions: _extractMentions(data),
      authorId: data['author_id'] as String,
      authorUser: author,
      createdAt: _parseDateTime(data['created_at']),
      likes: data['like_count'] as int? ?? 0,
      commentCount: data['comment_count'] as int? ?? 0,
      shareCount: data['share_count'] as int? ?? 0,
      isLikedByCurrentUser: false,
      isFavorite: false,
      repostedPostId: data['reposted_post_id'] as String?,
      repostedPostType: repostedPost?['post_type'] as String?,
      repostedMediaUrl: _extractRepostedMediaUrl(repostedPost),
      repostedThumbnailUrl: repostedPost?['thumbnail_url'] as String?,
      repostedCaption: repostedPost?['content'] as String?,
      repostedAuthorId: repostedPost?['author_id'] as String?,
      repostedAuthorName: _extractRepostedAuthorField(
        repostedPost,
        'full_name',
      ),
      repostedAuthorUsername: _extractRepostedAuthorField(
        repostedPost,
        'username',
      ),
      repostedAuthorAvatarUrl: _extractRepostedAuthorField(
        repostedPost,
        'avatar_url',
      ),
    );
  }

  TextPost _mapToTextPost(Map<String, dynamic> data) {
    final author = _extractAuthor(data);
    final metadata = _extractMetadata(data);
    final repostedPost = _extractRepostedPost(data);
    final poll = _extractPostPoll(metadata);

    return TextPost(
      id: data['id'] as String,
      body: data['content'] as String? ?? '',
      title: data['title'] as String?,
      imageUrl: data['thumbnail_url'] as String?,
      backgroundColor: metadata['background_color'] as int? ?? 0xFF1A237E,
      textColor: metadata['text_color'] as int? ?? 0xFFFFFFFF,
      fontSize: (metadata['font_size'] as num?)?.toDouble() ?? 18.0,
      fontFamily: metadata['font_family'] as String?,
      tags: _extractTags(data),
      mentions: _extractMentions(data),
      poll: poll,
      scheduledAt: _parseDateTime(data['scheduled_at']),
      publishedAt: _parseDateTime(data['published_at']),
      status: (data['status'] as String?) ?? (metadata['status'] as String?),
      authorId: data['author_id'] as String,
      authorUser: author,
      createdAt: _parseDateTime(data['created_at']),
      likes: data['like_count'] as int? ?? 0,
      commentCount: data['comment_count'] as int? ?? 0,
      shareCount: data['share_count'] as int? ?? 0,
      isLikedByCurrentUser: false,
      isFavorite: false,
      repostedPostId: data['reposted_post_id'] as String?,
      repostedPostType: repostedPost?['post_type'] as String?,
      repostedMediaUrl: _extractRepostedMediaUrl(repostedPost),
      repostedThumbnailUrl: repostedPost?['thumbnail_url'] as String?,
      repostedCaption: repostedPost?['content'] as String?,
      repostedAuthorId: repostedPost?['author_id'] as String?,
      repostedAuthorName: _extractRepostedAuthorField(
        repostedPost,
        'full_name',
      ),
      repostedAuthorUsername: _extractRepostedAuthorField(
        repostedPost,
        'username',
      ),
      repostedAuthorAvatarUrl: _extractRepostedAuthorField(
        repostedPost,
        'avatar_url',
      ),
    );
  }

  VideoPost _mapToVideoPost(Map<String, dynamic> data) {
    final author = _extractAuthor(data);
    final mediaUrls = _extractMediaUrls(data);
    final metadata = _extractMetadata(data);
    final repostedPost = _extractRepostedPost(data);

    return VideoPost(
      id: data['id'] as String,
      videoUrl: mediaUrls.isNotEmpty ? mediaUrls.first : '',
      thumbnailUrl: data['thumbnail_url'] as String?,
      caption: data['content'] as String? ?? '',
      title: data['title'] as String?,
      location: _extractLocation(data),
      aspectRatio: _extractVideoAspectRatio(metadata),
      durationSeconds: _extractVideoDuration(metadata),
      tags: _extractTags(data),
      mentions: _extractMentions(data),
      scheduledAt: _parseDateTime(data['scheduled_at']),
      publishedAt: _parseDateTime(data['published_at']),
      status: (data['status'] as String?) ?? (metadata['status'] as String?),
      authorId: data['author_id'] as String,
      authorUser: author,
      createdAt: _parseDateTime(data['created_at']),
      likes: data['like_count'] as int? ?? 0,
      commentCount: data['comment_count'] as int? ?? 0,
      shareCount: data['share_count'] as int? ?? 0,
      viewCount: metadata['view_count'] as int? ?? 0,
      isLikedByCurrentUser: false,
      isFavorite: false,
      repostedPostId: data['reposted_post_id'] as String?,
      repostedPostType: repostedPost?['post_type'] as String?,
      repostedMediaUrl: _extractRepostedMediaUrl(repostedPost),
      repostedThumbnailUrl: repostedPost?['thumbnail_url'] as String?,
      repostedCaption: repostedPost?['content'] as String?,
      repostedAuthorId: repostedPost?['author_id'] as String?,
      repostedAuthorName: _extractRepostedAuthorField(
        repostedPost,
        'full_name',
      ),
      repostedAuthorUsername: _extractRepostedAuthorField(
        repostedPost,
        'username',
      ),
      repostedAuthorAvatarUrl: _extractRepostedAuthorField(
        repostedPost,
        'avatar_url',
      ),
    );
  }

  Story _mapStoryShareToStory(Map<String, dynamic> data) {
    final sharedStory = _asStringDynamicMap(data['shared_story']);
    final metadata = _extractMetadata(data);
    final attributes = _asStringDynamicMap(sharedStory?['attributes']);
    final characterDetails =
        _asStringDynamicMap(attributes?['character_details']) ??
        <String, dynamic>{};

    final storyId =
        sharedStory?['id']?.toString() ??
        data['shared_story_id']?.toString() ??
        data['id']?.toString() ??
        '';

    final title = _firstNonEmptyString([
      sharedStory?['title']?.toString(),
      metadata['story_title']?.toString(),
      data['title']?.toString(),
    ]);

    final storyContent = _firstNonEmptyString([
      sharedStory?['content']?.toString(),
      metadata['story_content']?.toString(),
      data['content']?.toString(),
    ]);

    final lesson = _firstNonEmptyString([
      attributes?['moral']?.toString(),
      metadata['story_lesson']?.toString(),
      data['content']?.toString(),
    ]);

    return Story(
      id: storyId,
      title: title ?? 'Shared Story',
      scripture:
          attributes?['scripture']?.toString() ??
          metadata['story_scripture']?.toString() ??
          'Scripture',
      story: storyContent ?? '',
      quotes: attributes?['quotes']?.toString() ?? '',
      trivia: attributes?['trivia']?.toString() ?? '',
      activity: attributes?['activity']?.toString() ?? '',
      lesson: lesson ?? '',
      attributes: StoryAttributes(
        storyType: attributes?['story_type']?.toString() ?? 'General',
        theme: attributes?['theme']?.toString() ?? 'Dharma (Duty)',
        mainCharacterType:
            attributes?['main_character_type']?.toString() ?? 'Protagonist',
        storySetting:
            attributes?['story_setting']?.toString() ?? 'Ancient India',
        timeEra: attributes?['time_era']?.toString() ?? 'Ancient',
        narrativePerspective:
            attributes?['narrative_perspective']?.toString() ?? 'Third Person',
        languageStyle: attributes?['language_style']?.toString() ?? 'English',
        emotionalTone:
            attributes?['emotional_tone']?.toString() ?? 'Inspirational',
        narrativeStyle:
            attributes?['narrative_style']?.toString() ?? 'Narrative',
        plotStructure: attributes?['plot_structure']?.toString() ?? 'Linear',
        storyLength:
            attributes?['story_length']?.toString() ?? 'Medium ~1000 words',
        references: _toStringList(attributes?['references']),
        tags: _toStringList(attributes?['tags']),
        characters: _toStringList(attributes?['characters']),
        characterDetails: characterDetails,
      ),
      imageUrl: _firstNonEmptyString([
        sharedStory?['image_url']?.toString(),
        metadata['story_image_url']?.toString(),
      ]),
      author: sharedStory?['author']?.toString(),
      // Use post timestamps so newly shared older stories appear as recent.
      publishedAt: _parseDateTime(data['created_at']),
      createdAt: _parseDateTime(data['created_at']),
      updatedAt: _parseDateTime(sharedStory?['updated_at']),
      likes: _toInt(data['like_count']),
      views: _toInt(sharedStory?['views']),
      isFavorite: false,
      isFeatured: false,
      authorId:
          sharedStory?['author_id']?.toString() ??
          data['author_id']?.toString(),
      authorUser: _extractAuthor(data),
      commentCount: _toInt(data['comment_count']),
      shareCount: _toInt(data['share_count']),
      isLikedByCurrentUser: false,
    );
  }

  User? _extractAuthor(Map<String, dynamic> data) {
    final authorData = _asStringDynamicMap(data['author']);
    if (authorData == null) return null;

    final authorId = authorData['id'] as String;

    return User(
      id: authorId,
      username: authorData['username'] as String? ?? 'unknown',
      displayName: authorData['full_name'] as String? ?? 'Unknown User',
      avatarUrl: authorData['avatar_url'] as String? ?? '',
      bio: '',
      followerCount: 0,
      followingCount: 0,
      isFollowing: false,
      isCurrentUser: false,
    );
  }

  @override
  Future<Either<Failure, FeedItem>> enrichFeedItemWithUserData(
    FeedItem item,
  ) async {
    try {
      final authorId = item.authorId;
      if (authorId == null) return right(item);

      final userResult = await _userRepository.getUserProfile(authorId);

      return userResult.fold(
        (failure) => right(item),
        (user) => right(
          item.when(
            story: (story) => FeedItem.story(story.copyWith(authorUser: user)),
            imagePost: (post) =>
                FeedItem.imagePost(post.copyWith(authorUser: user)),
            textPost: (post) =>
                FeedItem.textPost(post.copyWith(authorUser: user)),
            videoPost: (post) =>
                FeedItem.videoPost(post.copyWith(authorUser: user)),
          ),
        ),
      );
    } catch (e, st) {
      talker.error('Error enriching feed item with user data', e, st);
      return right(item);
    }
  }

  @override
  Future<List<FeedItem>> enrichFeedItemsWithSocialData(
    List<FeedItem> items,
  ) async {
    if (items.isEmpty) return items;

    try {
      final postIds = items
          .where((item) => item.contentType != ContentType.story)
          .map((item) => item.id)
          .toList();

      if (postIds.isEmpty) return items;

      // Batch check likes and bookmarks in parallel
      final results = await Future.wait([
        _socialService.batchCheckLiked(
          contentType: ContentType.post,
          contentIds: postIds,
        ),
        _socialService.batchCheckBookmarked(
          contentType: ContentType.post,
          contentIds: postIds,
        ),
      ]);

      final likedIds = results[0];
      final bookmarkedIds = results[1];

      return items.map((item) {
        final isLiked = likedIds.contains(item.id);
        final isBookmarked = bookmarkedIds.contains(item.id);

        return item.when(
          story: (story) => FeedItem.story(story),
          imagePost: (post) => FeedItem.imagePost(
            post.copyWith(
              isLikedByCurrentUser: isLiked,
              isFavorite: isBookmarked,
            ),
          ),
          textPost: (post) => FeedItem.textPost(
            post.copyWith(
              isLikedByCurrentUser: isLiked,
              isFavorite: isBookmarked,
            ),
          ),
          videoPost: (post) => FeedItem.videoPost(
            post.copyWith(
              isLikedByCurrentUser: isLiked,
              isFavorite: isBookmarked,
            ),
          ),
        );
      }).toList();
    } catch (e, st) {
      talker.error('Error enriching feed items with social data', e, st);
      return items;
    }
  }

  List<String> _extractMediaUrls(Map<String, dynamic> data) {
    final mediaUrls = data['media_urls'];
    if (mediaUrls == null) return [];
    if (mediaUrls is List) {
      return mediaUrls.map((e) => e.toString()).toList();
    }
    return [];
  }

  List<String> _extractTags(Map<String, dynamic> data) {
    final metadata = _extractMetadata(data);
    final tags = metadata['tags'];
    if (tags is List) {
      return tags.map((e) => e.toString()).toList();
    }

    if (data['post_type'] == 'story_share') {
      final sharedStory = _asStringDynamicMap(data['shared_story']);
      final attributes = _asStringDynamicMap(sharedStory?['attributes']);
      final storyTags = attributes?['tags'];
      if (storyTags is List) {
        return storyTags.map((e) => e.toString()).toList();
      }
    }

    return [];
  }

  List<PostMention> _extractMentions(Map<String, dynamic> data) {
    final metadata = _extractMetadata(data);
    final raw = metadata['mentions'];
    if (raw is! List) return [];
    final out = <PostMention>[];
    for (final e in raw) {
      if (e is Map) {
        final u = e['username']?.toString();
        final id = e['user_id']?.toString();
        if (u != null && id != null && id.isNotEmpty) {
          out.add(PostMention(username: u, userId: id));
        }
      }
    }
    return out;
  }

  String? _extractLocation(Map<String, dynamic> data) {
    final metadata = _extractMetadata(data);
    return metadata['location'] as String?;
  }

  double _extractAspectRatio(Map<String, dynamic> data) {
    final metadata = _extractMetadata(data);
    // Prefer per-media entry if available, fall back to legacy top-level key.
    final mediaMeta = _extractMediaMeta(metadata);
    if (mediaMeta.isNotEmpty) {
      final first = mediaMeta.first;
      final ratio = first['aspect_ratio'];
      if (ratio is num) {
        return ratio.toDouble();
      }
    }

    return (metadata['aspect_ratio'] as num?)?.toDouble() ?? 1.0;
  }

  /// Extracts the aspect ratio for video posts.
  ///
  /// This mirrors [_extractAspectRatio] but keeps a separate helper for
  /// potential future video-specific behavior.
  double _extractVideoAspectRatio(Map<String, dynamic> metadata) {
    final mediaMeta = _extractMediaMeta(metadata);
    if (mediaMeta.isNotEmpty) {
      final first = mediaMeta.first;
      final ratio = first['aspect_ratio'];
      if (ratio is num) {
        return ratio.toDouble();
      }
    }

    return (metadata['aspect_ratio'] as num?)?.toDouble() ?? (9 / 16);
  }

  /// Extracts the duration in seconds for video posts.
  int _extractVideoDuration(Map<String, dynamic> metadata) {
    final mediaMeta = _extractMediaMeta(metadata);
    if (mediaMeta.isNotEmpty) {
      final first = mediaMeta.first;
      final duration = first['duration_seconds'];
      if (duration is int) return duration;
      if (duration is num) return duration.toInt();
    }

    final duration = metadata['duration_seconds'];
    if (duration is int) return duration;
    if (duration is num) return duration.toInt();
    return 0;
  }

  /// Safely extracts the `media_meta` array from metadata.
  ///
  /// The structure is expected to be a `List<Map<String, dynamic>>`, but we
  /// defensively normalise and ignore malformed entries.
  List<Map<String, dynamic>> _extractMediaMeta(Map<String, dynamic> metadata) {
    final raw = metadata['media_meta'];
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((e) => e.cast<String, dynamic>())
          .toList();
    }
    return const [];
  }

  PostPoll? _extractPostPoll(Map<String, dynamic> metadata) {
    final pollData = _asStringDynamicMap(metadata['poll']);
    if (pollData == null) return null;

    final rawOptions = pollData['options'];
    if (rawOptions is! List) return null;

    final options = rawOptions
        .map((option) => option.toString().trim())
        .where((option) => option.isNotEmpty)
        .toList();

    if (options.length < 2 || options.length > 4) {
      return null;
    }

    final countsRaw = pollData['counts'];
    final counts = <int>[];
    if (countsRaw is List) {
      for (final value in countsRaw.take(4)) {
        counts.add(_toInt(value));
      }
    }
    while (counts.length < 4) {
      counts.add(0);
    }

    final totalVotes = _toInt(pollData['total_votes']);
    final myOptionRaw = pollData['my_option'];
    final myOption = myOptionRaw is int
        ? myOptionRaw
        : myOptionRaw is num
        ? myOptionRaw.toInt()
        : null;

    return PostPoll(
      options: options,
      voteCounts: counts,
      totalVotes: totalVotes,
      mySelectedIndex: myOption,
    );
  }

  String _extractImageUrl(Map<String, dynamic> data, List<String> mediaUrls) {
    if (mediaUrls.isNotEmpty && mediaUrls.first.trim().isNotEmpty) {
      return mediaUrls.first;
    }

    final thumbnailUrl = data['thumbnail_url'] as String?;
    if (thumbnailUrl != null && thumbnailUrl.trim().isNotEmpty) {
      return thumbnailUrl;
    }

    final metadata = _extractMetadata(data);
    final storyImageFromMetadata = metadata['story_image_url'] as String?;
    if (storyImageFromMetadata != null &&
        storyImageFromMetadata.trim().isNotEmpty) {
      return storyImageFromMetadata;
    }

    final sharedStory = _asStringDynamicMap(data['shared_story']);
    final storyImageFromRelation = sharedStory?['image_url'] as String?;
    if (storyImageFromRelation != null &&
        storyImageFromRelation.trim().isNotEmpty) {
      return storyImageFromRelation;
    }

    return '';
  }

  String? _extractPostCaption(Map<String, dynamic> data) {
    final caption = data['content'] as String?;
    if (caption != null && caption.trim().isNotEmpty) {
      return caption;
    }

    if (data['post_type'] == 'story_share') {
      final metadata = _extractMetadata(data);
      final storyTitleFromMetadata = metadata['story_title'] as String?;
      if (storyTitleFromMetadata != null &&
          storyTitleFromMetadata.trim().isNotEmpty) {
        return storyTitleFromMetadata;
      }

      final sharedStory = _asStringDynamicMap(data['shared_story']);
      final storyTitleFromRelation = sharedStory?['title'] as String?;
      if (storyTitleFromRelation != null &&
          storyTitleFromRelation.trim().isNotEmpty) {
        return storyTitleFromRelation;
      }
    }

    return caption;
  }

  Map<String, dynamic> _extractMetadata(Map<String, dynamic> data) {
    return _asStringDynamicMap(data['metadata']) ?? <String, dynamic>{};
  }

  Future<List<Map<String, dynamic>>> _attachPollSummaries(
    List<Map<String, dynamic>> rows,
  ) async {
    if (rows.isEmpty) return rows;

    final textRowsWithPoll = rows.where((row) {
      if (row['post_type']?.toString() != 'text') return false;
      final metadata = _extractMetadata(row);
      final poll = _asStringDynamicMap(metadata['poll']);
      final options = poll?['options'];
      return options is List && options.isNotEmpty;
    }).toList();

    if (textRowsWithPoll.isEmpty) {
      return rows;
    }

    final postIds = textRowsWithPoll
        .map((row) => row['id']?.toString())
        .whereType<String>()
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();

    if (postIds.isEmpty) {
      return rows;
    }

    final summaries = await _postService.fetchPollSummaries(postIds);
    if (summaries.isEmpty) {
      return rows;
    }

    return rows.map((row) {
      final postId = row['id']?.toString();
      if (postId == null) return row;

      final summary = summaries[postId];
      if (summary == null) return row;

      final metadata = _extractMetadata(row);
      final poll = _asStringDynamicMap(metadata['poll']);
      if (poll == null) return row;

      final updatedPoll = <String, dynamic>{
        ...poll,
        'counts': summary.counts,
        'total_votes': summary.totalVotes,
        'my_option': summary.myOption,
      };
      final updatedMetadata = <String, dynamic>{
        ...metadata,
        'poll': updatedPoll,
      };

      return <String, dynamic>{...row, 'metadata': updatedMetadata};
    }).toList();
  }

  Map<String, dynamic>? _extractRepostedPost(Map<String, dynamic> data) {
    return _asStringDynamicMap(data['reposted_post']);
  }

  String? _extractRepostedMediaUrl(Map<String, dynamic>? repostedPost) {
    if (repostedPost == null) return null;
    final mediaUrls = repostedPost['media_urls'];
    if (mediaUrls is List && mediaUrls.isNotEmpty) {
      final first = mediaUrls.first?.toString();
      if (first != null && first.trim().isNotEmpty) return first;
    }
    final thumbnail = repostedPost['thumbnail_url'] as String?;
    if (thumbnail != null && thumbnail.trim().isNotEmpty) return thumbnail;
    return null;
  }

  String? _extractRepostedAuthorField(
    Map<String, dynamic>? repostedPost,
    String field,
  ) {
    if (repostedPost == null) return null;
    final author = _asStringDynamicMap(repostedPost['author']);
    return author?[field] as String?;
  }

  Map<String, dynamic>? _asStringDynamicMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return value.cast<String, dynamic>();
    return null;
  }

  List<String> _toStringList(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return const [];
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return 0;
  }

  String? _firstNonEmptyString(List<String?> values) {
    for (final value in values) {
      if (value != null && value.trim().isNotEmpty) {
        return value;
      }
    }
    return null;
  }

  DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
