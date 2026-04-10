import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:myitihas/core/errors/failures.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import '../entities/user.dart';

/// Repository interface for user profile and social operations
abstract class UserRepository {
  Future<Either<Failure, User>> getCurrentUser();

  Future<Either<Failure, void>> setCurrentUser(String userId);

  Future<Either<Failure, User>> getUserProfile(String userId);

  Future<Either<Failure, List<User>>> searchUsers(String query);

  Future<Either<Failure, void>> followUser(String userId);

  Future<Either<Failure, void>> unfollowUser(String userId);

  Future<Either<Failure, List<User>>> getFollowers(
    String userId, {
    int limit = 20,
    int offset = 0,
  });

  Future<Either<Failure, List<User>>> getFollowing(
    String userId, {
    int limit = 20,
    int offset = 0,
  });

  Future<Either<Failure, List<User>>> getAllUsers();

  Future<Either<Failure, void>> updateUserProfile({
    required String userId,
    String? displayName,
    String? bio,
    String? avatarUrl,
  });

  /// Uploads profile photo to storage and updates user's avatar_url
  /// 
  /// - Only authenticated user can upload their own photo
  /// - Compresses and optimizes image before upload
  /// - Returns updated User entity with new avatar URL
  Future<Either<Failure, String>> uploadProfilePhoto({
    required String userId,
    required File imageFile,
  });

  Future<Either<Failure, List<Story>>> getSavedStories();
}
