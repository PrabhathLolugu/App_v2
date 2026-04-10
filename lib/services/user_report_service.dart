import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Service for reporting users and managing report-related operations.
///
/// Handles user reports. Reporting **does not** block the user – blocking is
/// handled separately by `UserBlockService`.
@lazySingleton
class UserReportService {
  final SupabaseClient _supabase;
  final Talker _logger;

  UserReportService(this._supabase, this._logger);

  /// Reports a user.
  ///
  /// Steps:
  /// 1. Inserts report into user_reports table
  /// 2. Handles duplicate reports gracefully
  ///
  /// Throws exception if user is not authenticated or if operation fails.
  Future<void> reportUser(String targetUserId, String reason) async {
    try {
      final currentUserId = _supabase.auth.currentUser?.id;

      if (currentUserId == null) {
        _logger.error(
          '[UserReportService] Cannot report: User not authenticated',
        );
        throw Exception('User must be authenticated to report');
      }

      if (currentUserId == targetUserId) {
        _logger.warning(
          '[UserReportService] User attempted to report themselves',
        );
        throw Exception('Cannot report yourself');
      }

      if (reason.trim().isEmpty) {
        _logger.warning(
          '[UserReportService] Report attempted with empty reason',
        );
        throw Exception('Report reason cannot be empty');
      }

      _logger.info('[UserReportService] Reporting user $targetUserId');

      // Insert report into user_reports table
      await _supabase.from('user_reports').insert({
        'reporter_id': currentUserId,
        'reported_user_id': targetUserId,
        'reason': reason.trim(),
        'created_at': DateTime.now().toIso8601String(),
      });

      _logger.info('[UserReportService] Report submitted successfully');
    } on PostgrestException catch (e) {
      // Handle duplicate report constraint violation gracefully
      if (e.code == '23505') {
        _logger.warning(
          '[UserReportService] User already reported: $targetUserId',
        );
        throw Exception('You have already reported this user');
      }
      _logger.error('[UserReportService] Database error while reporting', e);
      throw Exception('Failed to report user: ${e.message}');
    } catch (e) {
      _logger.error('[UserReportService] Error reporting user', e);
      rethrow;
    }
  }

  /// Checks if the current user has already reported the target user.
  ///
  /// Returns true if a report exists, false otherwise.
  /// Returns false if user is not authenticated.
  Future<bool> hasReported(String targetUserId) async {
    try {
      final currentUserId = _supabase.auth.currentUser?.id;

      if (currentUserId == null) {
        _logger.warning(
          '[UserReportService] Cannot check report: User not authenticated',
        );
        return false;
      }

      final response = await _supabase
          .from('user_reports')
          .select('id')
          .eq('reporter_id', currentUserId)
          .eq('reported_user_id', targetUserId)
          .maybeSingle();

      final hasReported = response != null;

      _logger.debug(
        '[UserReportService] Report check for $targetUserId: $hasReported',
      );

      return hasReported;
    } catch (e) {
      _logger.error('[UserReportService] Error checking report status', e);
      return false; // Fail gracefully
    }
  }

  /// Gets the list of user IDs that the current user has reported.
  ///
  /// Returns empty list if user is not authenticated or on error.
  Future<List<String>> getReportedUsers() async {
    try {
      final currentUserId = _supabase.auth.currentUser?.id;

      if (currentUserId == null) {
        _logger.warning(
          '[UserReportService] Cannot get reports: User not authenticated',
        );
        return [];
      }

      final response = await _supabase
          .from('user_reports')
          .select('reported_user_id')
          .eq('reporter_id', currentUserId);

      final reportedUsers = (response as List)
          .map((row) => row['reported_user_id'] as String)
          .toList();

      _logger.info(
        '[UserReportService] Retrieved ${reportedUsers.length} reported users',
      );

      return reportedUsers;
    } catch (e) {
      _logger.error('[UserReportService] Error fetching reported users', e);
      return []; // Fail gracefully
    }
  }
}
