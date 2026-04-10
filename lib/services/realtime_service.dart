import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:myitihas/core/di/injection_container.dart';

/// Event representing a realtime update to social counts.
class SocialCountUpdate {
  final String contentId;
  final String contentType; // 'post' or 'story'
  final SocialCountType countType;
  final int delta; // +1 or -1

  SocialCountUpdate({
    required this.contentId,
    required this.contentType,
    required this.countType,
    required this.delta,
  });
}

enum SocialCountType { like, comment, bookmark, share }

/// Service for real-time updates to social interaction counts.
///
/// Subscribes to Supabase Realtime channels for likes, comments,
/// bookmarks, and shares tables. Emits events when counts change.
@lazySingleton
class RealtimeService {
  final SupabaseClient _supabase;
  final _logger = getIt<Talker>();

  RealtimeChannel? _likesChannel;
  RealtimeChannel? _commentsChannel;
  RealtimeChannel? _bookmarksChannel;
  RealtimeChannel? _sharesChannel;

  final _countUpdateController = StreamController<SocialCountUpdate>.broadcast();

  /// Stream of social count updates.
  Stream<SocialCountUpdate> get countUpdates => _countUpdateController.stream;

  RealtimeService(this._supabase);

  /// Initializes realtime subscriptions for all social tables.
  void initialize() {
    _subscribeLikes();
    _subscribeComments();
    _subscribeBookmarks();
    _subscribeShares();
    _logger.info('[RealtimeService] Initialized realtime subscriptions');
  }

  void _subscribeLikes() {
    _likesChannel = _supabase
        .channel('public:likes')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'likes',
          callback: (payload) {
            _handleLikeInsert(payload.newRecord);
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: 'likes',
          callback: (payload) {
            _handleLikeDelete(payload.oldRecord);
          },
        )
        .subscribe();
  }

  void _subscribeComments() {
    _commentsChannel = _supabase
        .channel('public:comments')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'comments',
          callback: (payload) {
            _handleCommentInsert(payload.newRecord);
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: 'comments',
          callback: (payload) {
            _handleCommentDelete(payload.oldRecord);
          },
        )
        .subscribe();
  }

  void _subscribeBookmarks() {
    _bookmarksChannel = _supabase
        .channel('public:bookmarks')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'bookmarks',
          callback: (payload) {
            _handleBookmarkInsert(payload.newRecord);
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: 'bookmarks',
          callback: (payload) {
            _handleBookmarkDelete(payload.oldRecord);
          },
        )
        .subscribe();
  }

  void _subscribeShares() {
    _sharesChannel = _supabase
        .channel('public:shares')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'shares',
          callback: (payload) {
            _handleShareInsert(payload.newRecord);
          },
        )
        .subscribe();
  }

  void _handleLikeInsert(Map<String, dynamic> record) {
    final contentId = record['likeable_id'] as String?;
    final contentType = record['likeable_type'] as String?;

    if (contentId != null && contentType != null) {
      _countUpdateController.add(SocialCountUpdate(
        contentId: contentId,
        contentType: contentType,
        countType: SocialCountType.like,
        delta: 1,
      ));
      _logger.debug('[RealtimeService] Like added: $contentId');
    }
  }

  void _handleLikeDelete(Map<String, dynamic> record) {
    final contentId = record['likeable_id'] as String?;
    final contentType = record['likeable_type'] as String?;

    if (contentId != null && contentType != null) {
      _countUpdateController.add(SocialCountUpdate(
        contentId: contentId,
        contentType: contentType,
        countType: SocialCountType.like,
        delta: -1,
      ));
      _logger.debug('[RealtimeService] Like removed: $contentId');
    }
  }

  void _handleCommentInsert(Map<String, dynamic> record) {
    final contentId = record['commentable_id'] as String?;
    final contentType = record['commentable_type'] as String?;

    if (contentId != null && contentType != null) {
      _countUpdateController.add(SocialCountUpdate(
        contentId: contentId,
        contentType: contentType,
        countType: SocialCountType.comment,
        delta: 1,
      ));
      _logger.debug('[RealtimeService] Comment added: $contentId');
    }
  }

  void _handleCommentDelete(Map<String, dynamic> record) {
    final contentId = record['commentable_id'] as String?;
    final contentType = record['commentable_type'] as String?;

    if (contentId != null && contentType != null) {
      _countUpdateController.add(SocialCountUpdate(
        contentId: contentId,
        contentType: contentType,
        countType: SocialCountType.comment,
        delta: -1,
      ));
      _logger.debug('[RealtimeService] Comment deleted: $contentId');
    }
  }

  void _handleBookmarkInsert(Map<String, dynamic> record) {
    final contentId = record['bookmarkable_id'] as String?;
    final contentType = record['bookmarkable_type'] as String?;

    if (contentId != null && contentType != null) {
      _countUpdateController.add(SocialCountUpdate(
        contentId: contentId,
        contentType: contentType,
        countType: SocialCountType.bookmark,
        delta: 1,
      ));
      _logger.debug('[RealtimeService] Bookmark added: $contentId');
    }
  }

  void _handleBookmarkDelete(Map<String, dynamic> record) {
    final contentId = record['bookmarkable_id'] as String?;
    final contentType = record['bookmarkable_type'] as String?;

    if (contentId != null && contentType != null) {
      _countUpdateController.add(SocialCountUpdate(
        contentId: contentId,
        contentType: contentType,
        countType: SocialCountType.bookmark,
        delta: -1,
      ));
      _logger.debug('[RealtimeService] Bookmark removed: $contentId');
    }
  }

  void _handleShareInsert(Map<String, dynamic> record) {
    final contentId = record['shareable_id'] as String?;
    final contentType = record['shareable_type'] as String?;

    if (contentId != null && contentType != null) {
      _countUpdateController.add(SocialCountUpdate(
        contentId: contentId,
        contentType: contentType,
        countType: SocialCountType.share,
        delta: 1,
      ));
      _logger.debug('[RealtimeService] Share added: $contentId');
    }
  }

  /// Disposes all realtime subscriptions.
  @disposeMethod
  void dispose() {
    _likesChannel?.unsubscribe();
    _commentsChannel?.unsubscribe();
    _bookmarksChannel?.unsubscribe();
    _sharesChannel?.unsubscribe();
    _countUpdateController.close();
    _logger.info('[RealtimeService] Disposed realtime subscriptions');
  }
}
