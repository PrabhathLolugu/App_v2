import 'package:flutter_test/flutter_test.dart';
import 'package:myitihas/core/widgets/markdown/app_markdown.dart';

void main() {
  group('preprocessMarkdown', () {
    test('converts escaped newlines and carriage returns', () {
      const input = 'Line 1\\r\\nLine 2\\nLine 3\\rLine 4';
      final output = preprocessMarkdown(input);

      expect(output, equals('Line 1\nLine 2\nLine 3\nLine 4'));
    });

    test('preserves valid triple-asterisk emphasis', () {
      const input = 'This is ***very important*** text.';
      final output = preprocessMarkdown(input);

      expect(output, equals(input));
    });

    test('normalizes escaped asterisks for markdown emphasis', () {
      const input = 'This is \\*\\*bold\\*\\* text.';
      final output = preprocessMarkdown(input);

      expect(output, equals('This is **bold** text.'));
    });
  });
}
