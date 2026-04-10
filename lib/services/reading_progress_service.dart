import 'package:injectable/injectable.dart';
import 'package:myitihas/core/logging/talker_setup.dart';

/// Model representing reading progress for a story
class ReadingProgress {
  final String storyId;
  final String storyTitle;
  final double scrollPosition;
  final double totalLength;
  final DateTime lastReadAt;
  final String? thumbnailUrl;
  final String? scripture;

  ReadingProgress({
    required this.storyId,
    required this.storyTitle,
    required this.scrollPosition,
    required this.totalLength,
    required this.lastReadAt,
    this.thumbnailUrl,
    this.scripture,
  });

  /// Progress percentage (0.0 - 1.0)
  double get percentage =>
      totalLength > 0 ? (scrollPosition / totalLength).clamp(0.0, 1.0) : 0.0;

  /// Estimated reading time left in minutes (assuming 200 words per minute, ~5 chars per word)
  int get minutesLeft {
    final remainingLength = totalLength - scrollPosition;
    final wordsRemaining = remainingLength / 5;
    return (wordsRemaining / 200).ceil();
  }

  /// Whether the story is considered complete (>95% read)
  bool get isComplete => percentage >= 0.95;

  ReadingProgress copyWith({
    String? storyId,
    String? storyTitle,
    double? scrollPosition,
    double? totalLength,
    DateTime? lastReadAt,
    String? thumbnailUrl,
    String? scripture,
  }) {
    return ReadingProgress(
      storyId: storyId ?? this.storyId,
      storyTitle: storyTitle ?? this.storyTitle,
      scrollPosition: scrollPosition ?? this.scrollPosition,
      totalLength: totalLength ?? this.totalLength,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      scripture: scripture ?? this.scripture,
    );
  }
}

/// Service for tracking and persisting reading progress
@lazySingleton
class ReadingProgressService {
  // Note: This service is now a stub since reading progress is not critical
  // for the Brick migration. It can be reimplemented with Brick or SharedPreferences
  // in a future phase if needed.

  /// Initialize the service
  Future<void> init() async {
    talker.info('📖 ReadingProgressService initialized (stub)');
  }

  /// Save or update reading progress for a story
  Future<void> saveProgress({
    required String storyId,
    required String storyTitle,
    required double scrollPosition,
    required double totalLength,
    String? thumbnailUrl,
    String? scripture,
  }) async {
    // Stub: No-op for now
    talker.info(
      '📖 [Stub] Would save progress for "$storyTitle"',
    );
  }

  /// Get reading progress for a specific story
  Future<ReadingProgress?> getProgress(String storyId) async {
    // Stub: Always return null
    return null;
  }

  /// Get all stories currently in progress (not complete)
  Future<List<ReadingProgress>> getAllInProgress() async {
    // Stub: Always return empty list
    return [];
  }

  /// Get all completed stories
  Future<List<ReadingProgress>> getCompleted() async {
    // Stub: Always return empty list
    return [];
  }

  /// Clear reading progress for a specific story
  Future<void> clearProgress(String storyId) async {
    // Stub: No-op
    talker.info('📖 [Stub] Would clear progress for story: $storyId');
  }

  /// Clear all reading progress
  Future<void> clearAll() async {
    // Stub: No-op
    talker.info('📖 [Stub] Would clear all reading progress');
  }

  /// Mark a story as complete
  Future<void> markComplete({
    required String storyId,
    required String storyTitle,
    required double totalLength,
    String? thumbnailUrl,
    String? scripture,
  }) async {
    await saveProgress(
      storyId: storyId,
      storyTitle: storyTitle,
      scrollPosition: totalLength,
      totalLength: totalLength,
      thumbnailUrl: thumbnailUrl,
      scripture: scripture,
    );
  }
}
