import 'package:myitihas/core/errors/failures.dart';
import 'package:myitihas/services/auth_service.dart';

/// Central helper for converting technical errors (Supabase, HTTP, etc.)
/// into short, user-friendly messages suitable for UI.
class AppErrorMapper {
  const AppErrorMapper._();

  /// Returns a user-friendly message for any error.
  ///
  /// - Keeps messages from [AuthServiceException] and typed [Failure]s as-is
  ///   (they are already user-focused in most cases).
  /// - For generic exceptions, strips technical details and maps common
  ///   patterns (network, permissions, auth, not found) to friendly text.
  /// - Falls back to [fallbackMessage] or a generic message when needed.
  static String getUserMessage(
    Object error, {
    String? fallbackMessage,
  }) {
    // Already user-friendly domain errors
    if (error is AuthServiceException) {
      return error.message;
    }
    if (error is Failure) {
      final cleaned = _stripTechnicalDetails(error.message);
      if (cleaned.isNotEmpty) return cleaned;
    }

    final raw = _extractRawMessage(error);
    final lower = raw.toLowerCase();

    // Map common categories first
    if (_isNetworkError(lower)) {
      return 'We couldn\'t connect right now. Please check your internet connection and try again.';
    }

    if (_isTimeoutError(lower)) {
      return 'This is taking longer than expected. Please try again in a moment.';
    }

    if (_isAuthExpiredError(lower)) {
      return 'Your session has expired. Please sign in again to continue.';
    }

    if (_isPermissionError(lower)) {
      return 'You don\'t have permission to do this action.';
    }

    if (_isNotFoundError(lower)) {
      return 'We couldn\'t find this item. It may have been removed.';
    }

    if (_isRateLimitError(lower)) {
      return 'Too many attempts. Please wait a bit and try again.';
    }

    // If we still have a reasonably human-readable message, keep a simplified
    // version; otherwise fall back to a generic message.
    final simplified = _stripTechnicalDetails(raw);
    if (simplified.isNotEmpty && !_looksOverlyTechnical(simplified)) {
      return simplified;
    }

    return fallbackMessage ??
        'Something went wrong. Please try again in a moment.';
  }

  /// Extracts a "raw" message string from any error type.
  static String _extractRawMessage(Object error) {
    if (error is Failure) return error.message;
    if (error is AuthServiceException) return error.message;
    if (error is Exception || error is Error) {
      return error.toString();
    }
    return error.toString();
  }

  /// Removes obvious technical noise from error strings.
  ///
  /// - Drops stack traces and multi-line content.
  /// - Removes well-known prefixes like "Exception:".
  /// - Optionally trims trailing technical fragments after ':'.
  static String _stripTechnicalDetails(String message) {
    var result = message.trim();
    if (result.isEmpty) return result;

    // Only keep first line if there are multiple
    final newlineIndex = result.indexOf('\n');
    if (newlineIndex != -1) {
      result = result.substring(0, newlineIndex).trim();
    }

    // Remove common Dart / Supabase prefixes
    const prefixes = [
      'Exception:',
      'PostgrestException:',
      'AuthException:',
      'SupabaseException:',
      'SocketException:',
    ];
    for (final prefix in prefixes) {
      if (result.startsWith(prefix)) {
        result = result.substring(prefix.length).trim();
        break;
      }
    }

    // If there is a colon and the tail looks technical, keep only the prefix
    final colonIndex = result.indexOf(':');
    if (colonIndex != -1) {
      final before = result.substring(0, colonIndex).trim();
      final after = result.substring(colonIndex + 1).trim();
      if (_looksOverlyTechnical(after)) {
        result = before;
      }
    }

    // Truncate very long messages
    const maxLength = 160;
    if (result.length > maxLength) {
      result = result.substring(0, maxLength - 1).trimRight() + '…';
    }

    return result;
  }

  /// Heuristic check for "very technical" looking text (SQL, stack traces, etc.)
  static bool _looksOverlyTechnical(String text) {
    final lower = text.toLowerCase();
    const technicalMarkers = [
      'supabase',
      'postgrest',
      'exception',
      'stacktrace',
      'socket',
      'host lookup',
      'sql',
      'column ',
      'row-level security',
      'rls',
      'code ',
      'line ',
    ];
    return technicalMarkers.any(lower.contains);
  }

  static bool _isNetworkError(String lower) {
    return lower.contains('socketexception') ||
        lower.contains('network') ||
        lower.contains('connection') ||
        lower.contains('failed host lookup') ||
        lower.contains('dns') ||
        lower.contains('offline');
  }

  static bool _isTimeoutError(String lower) {
    return lower.contains('timeout') || lower.contains('timed out');
  }

  static bool _isAuthExpiredError(String lower) {
    return lower.contains('jwt expired') ||
        lower.contains('token expired') ||
        lower.contains('session not found') ||
        lower.contains('invalid jwt') ||
        lower.contains('invalid token');
  }

  static bool _isPermissionError(String lower) {
    return lower.contains('permission denied') ||
        lower.contains('not authorized') ||
        lower.contains('not authorised') ||
        lower.contains('row-level security policy') ||
        lower.contains('rls') && lower.contains('denied');
  }

  static bool _isNotFoundError(String lower) {
    return lower.contains('not found') ||
        lower.contains('no rows') ||
        lower.contains('404');
  }

  static bool _isRateLimitError(String lower) {
    return lower.contains('rate limit') ||
        lower.contains('too many requests') ||
        lower.contains('429');
  }
}

