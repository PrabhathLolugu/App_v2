import 'package:flutter_test/flutter_test.dart';
import 'package:myitihas/core/utils/chat_mention_parser.dart';

void main() {
  group('ChatMentionParser', () {
    test('encodes mention with display and userId', () {
      final encoded = ChatMentionParser.encode(
        display: 'Sidhartha Buddala',
        userId: '123e4567-e89b-12d3-a456-426614174000',
      );

      expect(
        encoded,
        '@[Sidhartha Buddala](123e4567-e89b-12d3-a456-426614174000)',
      );
    });

    test('extracts encoded mention matches with bounds', () {
      const message =
          'Hi @[Umesh](123e4567-e89b-12d3-a456-426614174111), check this';

      final matches = ChatMentionParser.extractEncodedMatches(message);

      expect(matches.length, 1);
      expect(matches.first.display, 'Umesh');
      expect(matches.first.userId, '123e4567-e89b-12d3-a456-426614174111');
      expect(
        message.substring(matches.first.start, matches.first.end),
        '@[Umesh](123e4567-e89b-12d3-a456-426614174111)',
      );
    });

    test('converts encoded mentions to visible display text', () {
      const message =
          'Hello @[Sidhartha](123e4567-e89b-12d3-a456-426614174222), visit https://example.com';

      final visible = ChatMentionParser.toDisplayText(message);

      expect(visible, 'Hello @Sidhartha, visit https://example.com');
    });

    test('returns plain mention when encode inputs are incomplete', () {
      final encoded = ChatMentionParser.encode(display: 'User', userId: '');

      expect(encoded, '@User');
    });
  });
}
