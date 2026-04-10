import 'package:equatable/equatable.dart';

/// Base failure class for error handling using Either type
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() =>
      'Failure: $message${code != null ? ' (code: $code)' : ''}';
}

/// Failure that occurs when a server request fails
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred', String? code])
    : super(code: code);
}

/// Failure that occurs when cached data cannot be retrieved
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred', String? code])
    : super(code: code);
}

/// Failure that occurs when there is no internet connection
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection', String? code])
    : super(code: code);
}

/// Failure that occurs when authentication fails
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed', String? code])
    : super(code: code);
}

/// Failure that occurs when data validation fails
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validation failed', String? code])
    : super(code: code);
}

/// Failure that occurs when data is not found
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found', String? code])
    : super(code: code);
}

/// Failure that occurs when an operation times out
class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Operation timed out', String? code])
    : super(code: code);
}

/// Failure that occurs when parsing fails
class ParsingFailure extends Failure {
  const ParsingFailure([super.message = 'Failed to parse data', String? code])
    : super(code: code);
}

/// Failure that occurs for unexpected errors
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([
    super.message = 'An unexpected error occurred',
    String? code,
  ]) : super(code: code);
}
