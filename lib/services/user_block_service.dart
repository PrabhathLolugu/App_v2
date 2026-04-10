import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import 'package:talker_flutter/talker_flutter.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/core/errors/exceptions.dart';

/// Service for managing user blocking functionality.
///
/// Uses the user_blocks table with schema:
/// - id (uuid, primary key, auto generated)
/// - blocker_id (uuid) - the user who is blocking
/// - blocked_id (uuid) - the user being blocked
/// - created_at (timestamp)
///
/// Unique constraint: (blocker_id, blocked_id) must be unique
///
/// All operations use auth.currentUser.id for the blocker_id to ensure
/// users can only manage their own block list.
@lazySingleton
class UserBlockService {
  final SupabaseClient _supabase;

  UserBlockService(this._supabase);

  /// Blocks a user by inserting a row into the user_blocks table.
  ///
  /// [targetUserId] - The ID of the user to block.
  ///
  /// Uses auth.currentUser.id as blocker_id.
  /// Handles duplicate blocks safely by checking if already blocked first.
  ///
  /// Throws [AuthException] if user is not authenticated.
  /// Throws [ServerException] on database errors.
  Future<void> blockUser(String targetUserId) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw AuthException('User must be authenticated to block');
      }

      // Prevent self-block
      if (currentUserId == targetUserId) {
        logger.warning('[UserBlockService] User attempted to block themselves');
        return;
      }

      // Use RPC to block and clean up follow relationships atomically on the backend.
      // This relies on the block_user_and_cleanup() function defined in Supabase.
      await _supabase.rpc(
        'block_user_and_cleanup',
        params: {'blocked': targetUserId},
      );

      logger.info(
        '[UserBlockService] User $currentUserId blocked $targetUserId',
      );
    } on AuthException {
      rethrow;
    } catch (e) {
      logger.error('[UserBlockService] Error blocking user: $e');
      throw ServerException(
        'Failed to block user: ${e.toString()}',
        'BLOCK_USER_ERROR',
      );
    }
  }

  /// Unblocks a user by deleting the row from the user_blocks table.
  ///
  /// [targetUserId] - The ID of the user to unblock.
  ///
  /// Uses auth.currentUser.id as blocker_id to match the row.
  /// Safe to call even if not currently blocked (no error on missing row).
  ///
  /// Throws [AuthException] if user is not authenticated.
  /// Throws [ServerException] on database errors.
  Future<void> unblockUser(String targetUserId) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw AuthException('User must be authenticated to unblock');
      }

      // Delete the block record
      await _supabase
          .from('user_blocks')
          .delete()
          .eq('blocker_id', currentUserId)
          .eq('blocked_id', targetUserId);

      logger.info(
        '[UserBlockService] User $currentUserId unblocked $targetUserId',
      );
    } on AuthException {
      rethrow;
    } catch (e) {
      logger.error('[UserBlockService] Error unblocking user: $e');
      throw ServerException(
        'Failed to unblock user: ${e.toString()}',
        'UNBLOCK_USER_ERROR',
      );
    }
  }

  /// Returns true if [userId] has blocked the current user (blocker_id = userId, blocked_id = me).
  /// Used to prevent sending message/group invite requests to users who have blocked you.
  Future<bool> hasBlockedMe(String userId) async {
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      throw AuthException('User must be authenticated');
    }
    final response = await _supabase
        .from('user_blocks')
        .select('id')
        .eq('blocker_id', userId)
        .eq('blocked_id', currentUserId)
        .maybeSingle();
    return response != null;
  }

  /// Checks if the current user has blocked a specific user.
  ///
  /// [targetUserId] - The ID of the user to check.
  ///
  /// Returns true if the current user has blocked targetUserId, false otherwise.
  ///
  /// Throws [AuthException] if user is not authenticated.
  /// Throws [ServerException] on database errors.
  Future<bool> isUserBlocked(String targetUserId) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw AuthException('User must be authenticated to check block status');
      }

      // Query for existing block record
      final response = await _supabase
          .from('user_blocks')
          .select('id')
          .eq('blocker_id', currentUserId)
          .eq('blocked_id', targetUserId)
          .maybeSingle();

      final isBlocked = response != null;
      logger.info(
        '[UserBlockService] Block check: $currentUserId -> $targetUserId = $isBlocked',
      );

      return isBlocked;
    } on AuthException {
      rethrow;
    } catch (e) {
      logger.error('[UserBlockService] Error checking block status: $e');
      throw ServerException(
        'Failed to check block status: ${e.toString()}',
        'CHECK_BLOCK_STATUS_ERROR',
      );
    }
  }

  /// Gets the list of all users blocked by the current user.
  ///
  /// Returns a list of user IDs (blocked_id) that the current user has blocked.
  ///
  /// Throws [AuthException] if user is not authenticated.
  /// Throws [ServerException] on database errors.
  Future<List<String>> getBlockedUsers() async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw AuthException('User must be authenticated to get blocked users');
      }

      // Query all blocks by the current user
      final response = await _supabase
          .from('user_blocks')
          .select('blocked_id')
          .eq('blocker_id', currentUserId);

      // Extract blocked_id values into a list
      final blockedIds = (response as List)
          .map((row) => row['blocked_id'] as String)
          .toList();

      logger.info(
        '[UserBlockService] User $currentUserId has ${blockedIds.length} blocked users',
      );

      return blockedIds;
    } on AuthException {
      rethrow;
    } catch (e) {
      logger.error('[UserBlockService] Error getting blocked users: $e');
      throw ServerException(
        'Failed to get blocked users: ${e.toString()}',
        'GET_BLOCKED_USERS_ERROR',
      );
    }
  }

  /// Gets the list of all users who have blocked the current user.
  ///
  /// Returns a list of user IDs (blocker_id) who have blocked the current user.
  ///
  /// Throws [AuthException] if user is not authenticated.
  /// Throws [ServerException] on database errors.
  Future<List<String>> getUsersWhoBlockedMe() async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw AuthException('User must be authenticated to get blockers');
      }

      // Query all users who have blocked the current user
      final response = await _supabase
          .from('user_blocks')
          .select('blocker_id')
          .eq('blocked_id', currentUserId);

      // Extract blocker_id values into a list
      final blockerIds = (response as List)
          .map((row) => row['blocker_id'] as String)
          .toList();

      logger.info(
        '[UserBlockService] ${blockerIds.length} users have blocked $currentUserId',
      );

      return blockerIds;
    } on AuthException {
      rethrow;
    } catch (e) {
      logger.error('[UserBlockService] Error getting blockers: $e');
      throw ServerException(
        'Failed to get blockers: ${e.toString()}',
        'GET_BLOCKERS_ERROR',
      );
    }
  }
}
