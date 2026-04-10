/// Base exception class for all custom exceptions in the app
abstract class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, {this.code});

  @override
  String toString() =>
      'AppException: $message${code != null ? ' (code: $code)' : ''}';
}

/// Exception thrown when a server request fails
class ServerException extends AppException {
  const ServerException([super.message = 'Server error occurred', String? code])
    : super(code: code);
}

/// Exception thrown when cached data cannot be retrieved
class CacheException extends AppException {
  const CacheException([super.message = 'Cache error occurred', String? code])
    : super(code: code);
}

/// Exception thrown when there is no internet connection
class NetworkException extends AppException {
  const NetworkException([
    super.message = 'No internet connection',
    String? code,
  ]) : super(code: code);
}

/// Exception thrown when authentication fails
class AuthException extends AppException {
  const AuthException([super.message = 'Authentication failed', String? code])
    : super(code: code);
}

/// Exception thrown when data validation fails
class ValidationException extends AppException {
  const ValidationException([super.message = 'Validation failed', String? code])
    : super(code: code);
}

/// Exception thrown when data is not found
class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Resource not found', String? code])
    : super(code: code);
}

/// Exception thrown when an operation times out
class TimeoutException extends AppException {
  const TimeoutException([super.message = 'Operation timed out', String? code])
    : super(code: code);
}

/// Exception thrown when parsing fails
class ParsingException extends AppException {
  const ParsingException([super.message = 'Failed to parse data', String? code])
    : super(code: code);
}
