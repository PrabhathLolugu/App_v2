import 'package:flutter_test/flutter_test.dart';
import 'package:myitihas/services/auth_service.dart';

void main() {
  group('Duplicate email signup messaging', () {
    test('canonical message matches product requirement', () {
      expect(kDuplicateEmailSignUpMessage, 'Email already registered.');
    });

    test('classifier detects canonical message', () {
      expect(isDuplicateEmailSignUpError(kDuplicateEmailSignUpMessage), isTrue);
    });

    test('classifier detects common backend duplicate patterns', () {
      expect(isDuplicateEmailSignUpError('Email already registered.'), isTrue);
      expect(
        isDuplicateEmailSignUpError(
          'An account with this email address already exists. Please log in or use a different email address.',
        ),
        isTrue,
      );
      expect(
        isDuplicateEmailSignUpError(
          'duplicate key value violates unique constraint users_email_unique',
        ),
        isTrue,
      );
      expect(isDuplicateEmailSignUpError('user already exists'), isTrue);
    });

    test('classifier ignores non-duplicate failures', () {
      expect(
        isDuplicateEmailSignUpError(
          'Network error. Please check your internet connection and try again.',
        ),
        isFalse,
      );
      expect(
        isDuplicateEmailSignUpError(
          'Account creation is temporarily limited. Please try again later.',
        ),
        isFalse,
      );
    });
  });
}
