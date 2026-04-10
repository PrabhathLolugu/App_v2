// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuoteModel _$QuoteModelFromJson(Map<String, dynamic> json) => _QuoteModel(
  id: json['id'] as String,
  text: json['text'] as String,
  author: json['author'] as String,
  scripture: json['scripture'] as String,
  chapter: json['chapter'] as String?,
  verse: json['verse'] as String?,
);

Map<String, dynamic> _$QuoteModelToJson(_QuoteModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'author': instance.author,
      'scripture': instance.scripture,
      'chapter': instance.chapter,
      'verse': instance.verse,
    };
