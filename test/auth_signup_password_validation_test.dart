import 'package:flutter_test/flutter_test.dart';
import 'package:myitihas/services/auth_service.dart';

void main() {
  group('validateSignUpPassword', () {
    test('rejects empty password with caller-provided message', () {
      expect(
        validateSignUpPassword('', emptyMessage: 'Please enter your password'),
        'Please enter your password',
      );
    });

    test('rejects short passwords', () {
      expect(
        validateSignUpPassword('Ab1@cd'),
        kSignUpPasswordRequirementsMessage,
      );
    });

    test('rejects passwords without uppercase', () {
      expect(
        validateSignUpPassword('abc12345@'),
        kSignUpPasswordRequirementsMessage,
      );
    });

    test('rejects passwords without lowercase', () {
      expect(
        validateSignUpPassword('ABC12345@'),
        kSignUpPasswordRequirementsMessage,
      );
    });

    test('rejects passwords without a digit', () {
      expect(
        validateSignUpPassword('Abcdefg@'),
        kSignUpPasswordRequirementsMessage,
      );
    });

    test('rejects passwords without a symbol', () {
      expect(
        validateSignUpPassword('Abc12345'),
        kSignUpPasswordRequirementsMessage,
      );
    });

    test('accepts strong passwords even when similar to email/name', () {
      expect(
        validateSignUpPassword(
          'Myitihas@2025',
          email: 'myitihas@gmail.com',
          fullName: 'My Itihas',
        ),
        isNull,
      );
    });

    test('accepts strong passwords matching policy', () {
      expect(validateSignUpPassword('A1@securePass'), isNull);
    });
  });
}
