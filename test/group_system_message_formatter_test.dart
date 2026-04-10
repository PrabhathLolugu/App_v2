import 'package:flutter_test/flutter_test.dart';
import 'package:myitihas/core/utils/group_system_message_formatter.dart';

void main() {
  group('GroupSystemMessageFormatter', () {
    test('detects supported membership event types', () {
      expect(
        GroupSystemMessageFormatter.isMembershipEventType(
          GroupSystemMessageFormatter.typeJoined,
        ),
        isTrue,
      );
      expect(
        GroupSystemMessageFormatter.isMembershipEventType(
          GroupSystemMessageFormatter.typeLeft,
        ),
        isTrue,
      );
      expect(
        GroupSystemMessageFormatter.isMembershipEventType(
          GroupSystemMessageFormatter.typeRemoved,
        ),
        isTrue,
      );
      expect(
        GroupSystemMessageFormatter.isMembershipEventType('text'),
        isFalse,
      );
    });

    test('uses explicit content text when available', () {
      final label = GroupSystemMessageFormatter.formatDisplayText(
        type: GroupSystemMessageFormatter.typeJoined,
        content: 'Aarav joined the group',
      );

      expect(label, 'Aarav joined the group');
    });

    test('uses fallback text when content is empty', () {
      expect(
        GroupSystemMessageFormatter.formatDisplayText(
          type: GroupSystemMessageFormatter.typeJoined,
          content: '   ',
        ),
        'A member joined the group',
      );

      expect(
        GroupSystemMessageFormatter.formatDisplayText(
          type: GroupSystemMessageFormatter.typeLeft,
          content: '',
        ),
        'A member left the group',
      );

      expect(
        GroupSystemMessageFormatter.formatDisplayText(
          type: GroupSystemMessageFormatter.typeRemoved,
          content: '',
        ),
        'A member was removed',
      );
    });
  });
}
