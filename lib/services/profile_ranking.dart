import 'dart:math';

/// Helper for ranking profile suggestions.
///
/// Profiles with higher connection scores are shown first. Profiles with the
/// same score are shuffled so non-mutual results do not appear in a fixed
/// newest-first order.
class ProfileRankingHelper {
  const ProfileRankingHelper._();

  static List<Map<String, dynamic>> rankProfiles({
    required List<Map<String, dynamic>> profiles,
    required Set<String> currentFollowingIds,
    required Set<String> currentFollowerIds,
    required Map<String, Set<String>> candidateFollowingByUserId,
    required Map<String, Set<String>> candidateFollowerByUserId,
    required Set<String> blockedUserIds,
    required Set<String> blockerUserIds,
    String? currentUserId,
    Random? random,
  }) {
    final rng = random ?? Random();
    final rankedProfiles = <_RankedProfile>[];

    for (final profile in profiles) {
      final userId = profile['id'] as String?;
      if (userId == null) continue;
      if (userId == currentUserId) continue;
      if (blockedUserIds.contains(userId) || blockerUserIds.contains(userId)) {
        continue;
      }

      rankedProfiles.add(
        _RankedProfile(
          profile: profile,
          score: _scoreProfile(
            userId: userId,
            currentFollowingIds: currentFollowingIds,
            currentFollowerIds: currentFollowerIds,
            candidateFollowingByUserId: candidateFollowingByUserId,
            candidateFollowerByUserId: candidateFollowerByUserId,
          ),
          tieBreaker: rng.nextDouble(),
        ),
      );
    }

    rankedProfiles.sort((left, right) {
      final scoreComparison = right.score.compareTo(left.score);
      if (scoreComparison != 0) {
        return scoreComparison;
      }
      return left.tieBreaker.compareTo(right.tieBreaker);
    });

    return rankedProfiles.map((entry) => entry.profile).toList();
  }

  static int _scoreProfile({
    required String userId,
    required Set<String> currentFollowingIds,
    required Set<String> currentFollowerIds,
    required Map<String, Set<String>> candidateFollowingByUserId,
    required Map<String, Set<String>> candidateFollowerByUserId,
  }) {
    var score = 0;

    if (currentFollowingIds.contains(userId) &&
        currentFollowerIds.contains(userId)) {
      score += 1000;
    }

    score += _intersectionCount(
      currentFollowingIds,
      candidateFollowingByUserId[userId],
    );
    score += _intersectionCount(
      currentFollowerIds,
      candidateFollowerByUserId[userId],
    );

    return score;
  }

  static int _intersectionCount(Set<String> left, Set<String>? right) {
    if (right == null || right.isEmpty || left.isEmpty) {
      return 0;
    }

    var count = 0;
    for (final value in right) {
      if (left.contains(value)) {
        count++;
      }
    }
    return count;
  }
}

class _RankedProfile {
  const _RankedProfile({
    required this.profile,
    required this.score,
    required this.tieBreaker,
  });

  final Map<String, dynamic> profile;
  final int score;
  final double tieBreaker;
}