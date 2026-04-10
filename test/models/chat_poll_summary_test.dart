import 'package:flutter_test/flutter_test.dart';
import 'package:myitihas/models/chat_poll_summary.dart';

void main() {
  group('ChatPollSummary.fromJson', () {
    test('parses RPC row with counts and my_option', () {
      final s = ChatPollSummary.fromJson({
        'message_id': 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
        'counts': [2, 1, 0, 0],
        'total_votes': 3,
        'my_option': 1,
      });
      expect(s.messageId, 'a1b2c3d4-e5f6-7890-abcd-ef1234567890');
      expect(s.counts, [2, 1, 0, 0]);
      expect(s.totalVotes, 3);
      expect(s.myOptionIndex, 1);
    });

    test('handles null my_option', () {
      final s = ChatPollSummary.fromJson({
        'message_id': 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
        'counts': [0, 0, 0, 0],
        'total_votes': 0,
        'my_option': null,
      });
      expect(s.myOptionIndex, isNull);
    });
  });
}
