import 'package:flutter_test/flutter_test.dart';
import 'package:myitihas/features/social/domain/utils/post_mention_composer_utils.dart';

void main() {
  group('activeMentionAtCaret', () {
    test('returns null when caret outside word', () {
      expect(activeMentionAtCaret('hello', 0), isNull);
      expect(activeMentionAtCaret('hello', 5), isNull);
    });

    test('detects @ with empty query', () {
      final r = activeMentionAtCaret('Hi @', 4);
      expect(r, isNotNull);
      expect(r!.atIndex, 3);
      expect(r.endIndex, 4);
      expect(r.query, '');
    });

    test('detects partial handle', () {
      final r = activeMentionAtCaret('Hi @joh', 7);
      expect(r, isNotNull);
      expect(r!.query, 'joh');
    });

    test('returns null when space before caret inside segment', () {
      expect(activeMentionAtCaret('Hi @john doe', 10), isNull);
    });

    test('returns null for email-like token', () {
      expect(activeMentionAtCaret('a@b', 3), isNull);
    });
  });
}
