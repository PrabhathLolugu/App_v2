import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:myitihas/services/profile_ranking.dart';

class _SequenceRandom implements Random {
  _SequenceRandom(this.values);

  final List<double> values;
  int _index = 0;

  @override
  double nextDouble() {
    if (values.isEmpty) {
      return 0;
    }
    final value = values[_index % values.length];
    _index++;
    return value;
  }

  @override
  bool nextBool() => nextDouble() >= 0.5;

  @override
  int nextInt(int max) => (nextDouble() * max).floor();
}

void main() {
  group('ProfileRankingHelper', () {
    test('ranks profiles with higher mutual/shared connection scores first', () {
      final ranked = ProfileRankingHelper.rankProfiles(
        profiles: [
          {'id': 'direct-mutual', 'username': 'direct'},
          {'id': 'shared-high', 'username': 'shared-high'},
          {'id': 'shared-low', 'username': 'shared-low'},
          {'id': 'random-a', 'username': 'random-a'},
        ],
        currentFollowingIds: {'direct-mutual', 'f1', 'f2', 'f3'},
        currentFollowerIds: {'direct-mutual', 'b1'},
        candidateFollowingByUserId: {
          'direct-mutual': {'direct-mutual'},
          'shared-high': {'f1', 'f2', 'f3'},
          'shared-low': {'f1'},
        },
        candidateFollowerByUserId: {
          'direct-mutual': {'direct-mutual'},
          'shared-high': {'b1', 'b2'},
          'shared-low': {'b1'},
        },
        blockedUserIds: const {},
        blockerUserIds: const {},
        currentUserId: 'candidate',
        random: _SequenceRandom([0.8, 0.2, 0.5, 0.1]),
      );

      expect(
        ranked.map((profile) => profile['id']).toList(),
        ['direct-mutual', 'shared-high', 'shared-low', 'random-a'],
      );
    });

    test('shuffles zero-score profiles instead of keeping newest-first order', () {
      final profiles = [
        {'id': 'zero-a', 'username': 'zero-a'},
        {'id': 'zero-b', 'username': 'zero-b'},
        {'id': 'zero-c', 'username': 'zero-c'},
      ];

      final rankedA = ProfileRankingHelper.rankProfiles(
        profiles: profiles,
        currentFollowingIds: const {},
        currentFollowerIds: const {},
        candidateFollowingByUserId: const {},
        candidateFollowerByUserId: const {},
        blockedUserIds: const {},
        blockerUserIds: const {},
        currentUserId: 'viewer-a',
        random: _SequenceRandom([0.9, 0.2, 0.7]),
      );

      final rankedB = ProfileRankingHelper.rankProfiles(
        profiles: profiles,
        currentFollowingIds: const {},
        currentFollowerIds: const {},
        candidateFollowingByUserId: const {},
        candidateFollowerByUserId: const {},
        blockedUserIds: const {},
        blockerUserIds: const {},
        currentUserId: 'viewer-b',
        random: _SequenceRandom([0.1, 0.8, 0.4]),
      );

      expect(
        rankedA.map((profile) => profile['id']).toList(),
        isNot(equals(profiles.map((profile) => profile['id']).toList())),
      );
      expect(
        rankedA.map((profile) => profile['id']).toList(),
        isNot(equals(rankedB.map((profile) => profile['id']).toList())),
      );
    });

    test('filters blocked users before ranking', () {
      final ranked = ProfileRankingHelper.rankProfiles(
        profiles: [
          {'id': 'allowed', 'username': 'allowed'},
          {'id': 'blocked', 'username': 'blocked'},
          {'id': 'blocker', 'username': 'blocker'},
        ],
        currentFollowingIds: const {},
        currentFollowerIds: const {},
        candidateFollowingByUserId: const {},
        candidateFollowerByUserId: const {},
        blockedUserIds: {'blocked'},
        blockerUserIds: {'blocker'},
        currentUserId: 'viewer',
        random: _SequenceRandom([0.3]),
      );

      expect(
        ranked.map((profile) => profile['id']).toList(),
        ['allowed'],
      );
    });
  });
}