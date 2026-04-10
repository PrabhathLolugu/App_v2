import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/logging/talker_setup.dart';
import 'package:myitihas/features/home/domain/entities/activity_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for activity tracking (stubbed)
@lazySingleton
class ActivityLocalDataSource {
  static const String _key = 'user_activities';
  final SharedPreferences _prefs;

  ActivityLocalDataSource(this._prefs);

  /// Initialize the service
  Future<void> init() async {
    talker.info('📊 ActivityLocalDataSource initialized');
  }

  /// Record a new activity
  Future<void> recordActivity(ActivityItem activity) async {
    try {
      final activities = await getAllActivities();

      // When recording a "Read" activity, we want a single entry per story.
      // Remove any previous "Read" entry for that story, as well as any
      // "Generated" entry, so the All Activity list only shows one row.
      if (activity.type == ActivityType.storyRead) {
        activities.removeWhere(
          (a) =>
              a.storyId == activity.storyId &&
              (a.type == ActivityType.storyRead ||
                  a.type == ActivityType.storyGenerated),
        );
      }

      // Add to beginning
      activities.insert(0, activity);

      // Limit to 50 items
      if (activities.length > 50) {
        activities.removeRange(50, activities.length);
      }

      await _saveActivities(activities);
      talker.info('📊 Recorded activity: ${activity.actionDescription} for ${activity.storyTitle}');
    } catch (e) {
      talker.error('📊 Failed to record activity', e);
    }
  }

  /// Get all activities sorted by timestamp (most recent first)
  Future<List<ActivityItem>> getAllActivities() async {
    final jsonString = _prefs.getString(_key);
    if (jsonString == null || jsonString.isEmpty) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => _mapToActivityItem(json)).toList();
    } catch (e) {
      talker.error('📊 Failed to parse activities', e);
      return [];
    }
  }

  /// Get recent activities (limited count)
  Future<List<ActivityItem>> getRecentActivities({int limit = 20}) async {
    final all = await getAllActivities();
    return all.take(limit).toList();
  }

  /// Get activities by type
  Future<List<ActivityItem>> getActivitiesByType(ActivityType type) async {
    final all = await getAllActivities();
    return all.where((a) => a.type == type).toList();
  }

  /// Get activities for a specific story
  Future<List<ActivityItem>> getActivitiesForStory(String storyId) async {
    final all = await getAllActivities();
    return all.where((a) => a.storyId == storyId).toList();
  }

  /// Get activities grouped by date
  Future<Map<DateTime, List<ActivityItem>>> getActivitiesGroupedByDate() async {
    final all = await getAllActivities();
    final grouped = <DateTime, List<ActivityItem>>{};

    for (final activity in all) {
      final date = DateTime(
        activity.timestamp.year,
        activity.timestamp.month,
        activity.timestamp.day,
      );
      grouped.putIfAbsent(date, () => []);
      grouped[date]!.add(activity);
    }

    return grouped;
  }

  /// Delete activity by ID
  Future<void> deleteActivity(String id) async {
    final all = await getAllActivities();
    all.removeWhere((a) => a.id == id);
    await _saveActivities(all);
  }

  /// Clear all activities
  Future<void> clearAll() async {
    await _prefs.remove(_key);
    talker.info('📊 Cleared all activities');
  }

  Future<void> _saveActivities(List<ActivityItem> activities) async {
    final jsonList = activities.map((a) => _activityItemToMap(a)).toList();
    await _prefs.setString(_key, jsonEncode(jsonList));
  }

  Map<String, dynamic> _activityItemToMap(ActivityItem item) {
    return {
      'id': item.id,
      'type': item.type.index,
      'storyId': item.storyId,
      'storyTitle': item.storyTitle,
      'timestamp': item.timestamp.toIso8601String(),
      'thumbnailUrl': item.thumbnailUrl,
      'scripture': item.scripture,
      'metadata': item.metadata,
    };
  }

  ActivityItem _mapToActivityItem(Map<String, dynamic> map) {
    return ActivityItem(
      id: map['id'],
      type: ActivityType.values[map['type']],
      storyId: map['storyId'],
      storyTitle: map['storyTitle'],
      timestamp: DateTime.parse(map['timestamp']),
      thumbnailUrl: map['thumbnailUrl'],
      scripture: map['scripture'],
      metadata: map['metadata'] != null ? Map<String, dynamic>.from(map['metadata']) : null,
    );
  }

  /// Helper to create a unique activity ID
  static String generateActivityId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecond}';
  }
}
