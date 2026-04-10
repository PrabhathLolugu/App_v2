import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myitihas/features/home/domain/entities/quote.dart';

part 'quote_model.freezed.dart';
part 'quote_model.g.dart';

/// Data model for Quote with JSON serialization
@freezed
abstract class QuoteModel with _$QuoteModel {
  const factory QuoteModel({
    required String id,
    required String text,
    required String author,
    required String scripture,
    String? chapter,
    String? verse,
  }) = _QuoteModel;

  const QuoteModel._();

  factory QuoteModel.fromJson(Map<String, dynamic> json) =>
      _$QuoteModelFromJson(json);

  /// Convert to domain entity
  Quote toDomain() => Quote(
    id: id,
    text: text,
    author: author,
    scripture: scripture,
    chapter: chapter,
    verse: verse,
  );
}
