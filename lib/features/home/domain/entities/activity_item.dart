import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_item.freezed.dart';

/// Types of user activity
enum ActivityType {
  /// User read/viewed a story
  storyRead,

  /// User generated a new story
  storyGenerated,

  /// User bookmarked a story
  storyBookmarked,

  /// User shared a story
  storyShared,

  /// User completed reading a story
  storyCompleted,
}

/// Domain entity representing a user activity event
@freezed
abstract class ActivityItem with _$ActivityItem {
  const factory ActivityItem({
    required String id,
    required ActivityType type,
    required String storyId,
    required String storyTitle,
    required DateTime timestamp,
    String? thumbnailUrl,
    String? scripture,

    /// Additional metadata (e.g., share platform, completion percentage)
    Map<String, dynamic>? metadata,
  }) = _ActivityItem;

  const ActivityItem._();

  /// Icon name based on activity type
  String get iconName {
    switch (type) {
      case ActivityType.storyRead:
        return 'book';
      case ActivityType.storyGenerated:
        return 'auto_awesome';
      case ActivityType.storyBookmarked:
        return 'bookmark';
      case ActivityType.storyShared:
        return 'share';
      case ActivityType.storyCompleted:
        return 'check_circle';
    }
  }

  /// Human-readable action description
  String get actionDescription {
    switch (type) {
      case ActivityType.storyRead:
        return 'Read a story';
      case ActivityType.storyGenerated:
        return 'Generated a story';
      case ActivityType.storyBookmarked:
        return 'Bookmarked a story';
      case ActivityType.storyShared:
        return 'Shared a story';
      case ActivityType.storyCompleted:
        return 'Completed reading';
    }
  }
}
