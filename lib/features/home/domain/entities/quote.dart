import 'package:freezed_annotation/freezed_annotation.dart';

part 'quote.freezed.dart';

/// Domain entity representing a scriptural quote
@freezed
abstract class Quote with _$Quote {
  const factory Quote({
    required String id,
    required String text,
    required String author,
    required String scripture,
    String? chapter,
    String? verse,
  }) = _Quote;

  const Quote._();

  /// Formatted attribution text (e.g., "— Lord Krishna, Bhagavad Gita 2.47")
  String get attribution {
    final buffer = StringBuffer('— $author');
    if (scripture.isNotEmpty) {
      buffer.write(', $scripture');
    }
    if (chapter != null && verse != null) {
      buffer.write(' $chapter.$verse');
    } else if (chapter != null) {
      buffer.write(' Ch. $chapter');
    }
    return buffer.toString();
  }

  /// Full shareable text with quote and attribution
  String get shareableText => '"$text"\n\n$attribution\n\n— via MyItihas';
}
