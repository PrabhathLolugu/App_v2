import 'package:myitihas/features/home/domain/entities/activity_item.dart';

/// Model for ActivityItem persistence
class ActivityItemModel {
  final String id;
  final int typeIndex;
  final String storyId;
  final String storyTitle;
  final DateTime timestamp;
  final String? thumbnailUrl;
  final String? scripture;

  ActivityItemModel({
    required this.id,
    required this.typeIndex,
    required this.storyId,
    required this.storyTitle,
    required this.timestamp,
    this.thumbnailUrl,
    this.scripture,
  });

  /// Create from domain entity
  factory ActivityItemModel.fromDomain(ActivityItem item) {
    return ActivityItemModel(
      id: item.id,
      typeIndex: item.type.index,
      storyId: item.storyId,
      storyTitle: item.storyTitle,
      timestamp: item.timestamp,
      thumbnailUrl: item.thumbnailUrl,
      scripture: item.scripture,
    );
  }

  /// Convert to domain entity
  ActivityItem toDomain() {
    return ActivityItem(
      id: id,
      type: ActivityType.values[typeIndex],
      storyId: storyId,
      storyTitle: storyTitle,
      timestamp: timestamp,
      thumbnailUrl: thumbnailUrl,
      scripture: scripture,
    );
  }
}
