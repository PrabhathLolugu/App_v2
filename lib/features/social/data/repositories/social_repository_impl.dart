import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/errors/exceptions.dart';
import 'package:myitihas/core/errors/failures.dart';
import 'package:myitihas/features/social/domain/entities/content_type.dart';
import 'package:myitihas/features/social/domain/repositories/user_repository.dart';
import 'package:myitihas/services/social_service.dart';
import 'package:myitihas/services/user_block_service.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/share.dart';
import '../../domain/repositories/social_repository.dart';
import '../datasources/social_data_source.dart';

/// Implementation of SocialRepository
@LazySingleton(as: SocialRepository)
class SocialRepositoryImpl implements SocialRepository {
  final SocialDataSource dataSource;
  final UserRepository userRepository;
  final SocialService socialService;
  final UserBlockService userBlockService;

  SocialRepositoryImpl({
    required this.dataSource,
    required this.userRepository,
    required this.socialService,
    required this.userBlockService,
  });

  @override
  Future<Either<Failure, void>> likeStory(String storyId) async {
    try {
      final currentUserResult = await userRepository.getCurrentUser();

      return await currentUserResult.fold((failure) => Left(failure), (
        currentUser,
      ) async {
        await dataSource.likeStory(currentUser.id, storyId);
        return const Right(null);
      });
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unlikeStory(String storyId) async {
    try {
      final currentUserResult = await userRepository.getCurrentUser();

      return await currentUserResult.fold((failure) => Left(failure), (
        currentUser,
      ) async {
        await dataSource.unlikeStory(currentUser.id, storyId);
        return const Right(null);
      });
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isStoryLiked(String storyId) async {
    try {
      final currentUserResult = await userRepository.getCurrentUser();

      return await currentUserResult.fold((failure) => Left(failure), (
        currentUser,
      ) async {
        final isLiked = await dataSource.isStoryLiked(currentUser.id, storyId);
        return Right(isLiked);
      });
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getStoryLikeCount(String storyId) async {
    try {
      final count = await dataSource.getStoryLikeCount(storyId);
      return Right(count);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Comment>> addComment({
    required String storyId,
    required String text,
    String? parentCommentId,
  }) async {
    try {
      final currentUserResult = await userRepository.getCurrentUser();

      return await currentUserResult.fold((failure) => Left(failure), (
        currentUser,
      ) async {
        // Check if user is trying to comment on a blocked user's content
        // or reply to a blocked user's comment
        if (parentCommentId != null) {
          // Get parent comment to check author
          final comments = await dataSource.getComments(storyId);
          final parentComment = comments
              .where((c) => c.id == parentCommentId)
              .firstOrNull;
          if (parentComment != null) {
            final blockedUsers = await userBlockService.getBlockedUsers();
            final usersWhoBlockedMe = await userBlockService
                .getUsersWhoBlockedMe();
            if (blockedUsers.contains(parentComment.userId) ||
                usersWhoBlockedMe.contains(parentComment.userId)) {
              return Left(
                ValidationFailure(
                  'Cannot reply to this comment',
                  'BLOCKED_USER',
                ),
              );
            }
          }
        }

        final commentModel = await dataSource.addComment(
          storyId: storyId,
          userId: currentUser.id,
          text: text,
          parentCommentId: parentCommentId,
        );

        return Right(commentModel.toEntity());
      });
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message, e.code));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteComment(String commentId) async {
    try {
      await dataSource.deleteComment(commentId);
      return const Right(null);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message, e.code));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> likeComment(String commentId) async {
    try {
      final currentUserResult = await userRepository.getCurrentUser();

      return await currentUserResult.fold((failure) => Left(failure), (
        currentUser,
      ) async {
        await dataSource.likeComment(currentUser.id, commentId);
        return const Right(null);
      });
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unlikeComment(String commentId) async {
    try {
      final currentUserResult = await userRepository.getCurrentUser();

      return await currentUserResult.fold((failure) => Left(failure), (
        currentUser,
      ) async {
        await dataSource.unlikeComment(currentUser.id, commentId);
        return const Right(null);
      });
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleCommentCollapse(String commentId) async {
    try {
      await dataSource.toggleCommentCollapse(commentId);
      return const Right(null);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Comment>>> getCommentsTree(String storyId) async {
    try {
      final comments = await dataSource.getComments(storyId);

      // Filter out comments from blocked users
      final blockedUsers = await userBlockService.getBlockedUsers();
      final usersWhoBlockedMe = await userBlockService.getUsersWhoBlockedMe();
      final allBlockedUserIds = {...blockedUsers, ...usersWhoBlockedMe};

      final filteredComments = comments.where((comment) {
        return !allBlockedUserIds.contains(comment.userId);
      }).toList();

      return Right(filteredComments.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> shareStory({
    required String storyId,
    required ShareType shareType,
    String? recipientId,
  }) async {
    try {
      final currentUserResult = await userRepository.getCurrentUser();

      return await currentUserResult.fold((failure) => Left(failure), (
        currentUser,
      ) async {
        await dataSource.shareStory(
          userId: currentUser.id,
          storyId: storyId,
          shareType: shareType,
          recipientId: recipientId,
        );
        return const Right(null);
      });
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getStoryShareCount(String storyId) async {
    try {
      final count = await dataSource.getStoryShareCount(storyId);
      return Right(count);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Share>>> getStoryShares(String storyId) async {
    try {
      final shares = await dataSource.getStoryShares(storyId);
      return Right(shares.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  // Polymorphic methods for content types

  @override
  Future<Either<Failure, Comment>> addContentComment({
    required String contentId,
    required ContentType contentType,
    required String text,
    String? parentCommentId,
  }) async {
    try {
      // Check if user is trying to reply to a blocked user's comment
      if (parentCommentId != null) {
        final commentsData = await socialService.getComments(
          contentType: contentType,
          contentId: contentId,
          limit: 1000,
          offset: 0,
        );
        final parentComment = commentsData
            .where((c) => c['id'] == parentCommentId)
            .firstOrNull;
        if (parentComment != null) {
          final parentAuthorId = parentComment['author_id'] as String?;
          if (parentAuthorId != null) {
            final blockedUsers = await userBlockService.getBlockedUsers();
            final usersWhoBlockedMe = await userBlockService
                .getUsersWhoBlockedMe();
            if (blockedUsers.contains(parentAuthorId) ||
                usersWhoBlockedMe.contains(parentAuthorId)) {
              return Left(
                ValidationFailure(
                  'Cannot reply to this comment',
                  'BLOCKED_USER',
                ),
              );
            }
          }
        }
      }

      final commentData = await socialService.addComment(
        contentType: contentType,
        contentId: contentId,
        text: text,
        parentCommentId: parentCommentId,
      );

      final currentUserResult = await userRepository.getCurrentUser();
      final currentUser = currentUserResult.fold((f) => null, (u) => u);

      final createdAt = commentData['created_at'] != null
          ? DateTime.parse(commentData['created_at'] as String)
          : DateTime.now();
      final depth = commentData['depth'] as int? ?? (parentCommentId != null ? 1 : 0);

      return Right(
        Comment(
          id: commentData['id'] as String,
          contentId: contentId,
          contentType: contentType.dbValue,
          userId: currentUser?.id ?? '',
          userName: currentUser?.displayName ?? currentUser?.username ?? 'User',
          userAvatar: currentUser?.avatarUrl ?? '',
          text: text,
          createdAt: createdAt,
          likeCount: 0,
          isLikedByCurrentUser: false,
          replies: [],
          depth: depth,
        ),
      );
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Comment>>> getContentComments({
    required String contentId,
    required ContentType contentType,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final commentsData = await socialService.getComments(
        contentType: contentType,
        contentId: contentId,
        limit: limit,
        offset: offset,
      );

      // Filter out comments from blocked users
      final blockedUsers = await userBlockService.getBlockedUsers();
      final usersWhoBlockedMe = await userBlockService.getUsersWhoBlockedMe();
      final allBlockedUserIds = {...blockedUsers, ...usersWhoBlockedMe};

      final comments = commentsData
          .where((data) {
            final authorId = data['author_id'] as String?;
            return authorId == null || !allBlockedUserIds.contains(authorId);
          })
          .map((data) => _mapCommentData(data, contentId, contentType.dbValue,
              allBlockedUserIds))
          .toList();

      return Right(comments);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  Comment _mapCommentData(
    Map<String, dynamic> data,
    String contentId,
    String contentTypeDb,
    Set<String> blockedUserIds,
  ) {
    final authorData = data['author'] as Map<String, dynamic>?;
    final repliesData = data['replies'] as List<dynamic>? ?? [];
    final replies = repliesData
        .where((r) => r is Map<String, dynamic>)
        .map((r) => r as Map<String, dynamic>)
        .where((r) {
          final id = r['author_id'] as String?;
          return id == null || !blockedUserIds.contains(id);
        })
        .map((r) => _mapCommentData(r, contentId, contentTypeDb, blockedUserIds))
        .toList();

    return Comment(
      id: data['id'] as String,
      contentId: contentId,
      contentType: contentTypeDb,
      userId: data['author_id'] as String,
      userName:
          authorData?['full_name'] as String? ??
          authorData?['username'] as String? ??
          'User',
      userAvatar: authorData?['avatar_url'] as String? ?? '',
      text: data['content'] as String? ?? '',
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'] as String)
          : DateTime.now(),
      likeCount: data['like_count'] as int? ?? 0,
      isLikedByCurrentUser: (data['is_liked_by_current_user'] as bool?) ?? false,
      replies: replies,
      depth: data['depth'] as int? ?? 0,
    );
  }

  @override
  Future<Either<Failure, void>> shareContent({
    required String contentId,
    required ContentType contentType,
    required ShareType shareType,
    String? recipientId,
  }) async {
    try {
      await socialService.shareContent(
        contentType: contentType,
        contentId: contentId,
        shareType: shareType,
        recipientId: recipientId,
      );
      return const Right(null);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getContentShareCount({
    required String contentId,
    required ContentType contentType,
  }) async {
    try {
      final count = await socialService.getShareCount(
        contentType: contentType,
        contentId: contentId,
      );
      return Right(count);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
