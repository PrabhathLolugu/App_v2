// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoryModel _$StoryModelFromJson(Map<String, dynamic> json) => _StoryModel(
  id: json['id'] as String,
  title: json['title'] as String,
  scripture: json['scripture'] as String,
  story: json['story'] as String,
  quotes: json['quotes'] as String,
  trivia: json['trivia'] as String,
  activity: json['activity'] as String,
  lesson: json['lesson'] as String,
  attributes: StoryAttributesModel.fromJson(
    json['attributes'] as Map<String, dynamic>,
  ),
  imageUrl: json['imageUrl'] as String?,
  author: json['author'] as String?,
  publishedAt: json['publishedAt'] == null
      ? null
      : DateTime.parse(json['publishedAt'] as String),
  likes: (json['likes'] as num?)?.toInt() ?? 0,
  views: (json['views'] as num?)?.toInt() ?? 0,
  isFavorite: json['isFavorite'] as bool? ?? false,
);

Map<String, dynamic> _$StoryModelToJson(_StoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'scripture': instance.scripture,
      'story': instance.story,
      'quotes': instance.quotes,
      'trivia': instance.trivia,
      'activity': instance.activity,
      'lesson': instance.lesson,
      'attributes': instance.attributes,
      'imageUrl': instance.imageUrl,
      'author': instance.author,
      'publishedAt': instance.publishedAt?.toIso8601String(),
      'likes': instance.likes,
      'views': instance.views,
      'isFavorite': instance.isFavorite,
    };

_StoryAttributesModel _$StoryAttributesModelFromJson(
  Map<String, dynamic> json,
) => _StoryAttributesModel(
  storyType: json['storyType'] as String,
  theme: json['theme'] as String,
  mainCharacterType: json['mainCharacterType'] as String,
  storySetting: json['storySetting'] as String,
  timeEra: json['timeEra'] as String,
  narrativePerspective: json['narrativePerspective'] as String,
  languageStyle: json['languageStyle'] as String,
  emotionalTone: json['emotionalTone'] as String,
  narrativeStyle: json['narrativeStyle'] as String,
  plotStructure: json['plotStructure'] as String,
  storyLength: json['storyLength'] as String,
  references:
      (json['references'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$StoryAttributesModelToJson(
  _StoryAttributesModel instance,
) => <String, dynamic>{
  'storyType': instance.storyType,
  'theme': instance.theme,
  'mainCharacterType': instance.mainCharacterType,
  'storySetting': instance.storySetting,
  'timeEra': instance.timeEra,
  'narrativePerspective': instance.narrativePerspective,
  'languageStyle': instance.languageStyle,
  'emotionalTone': instance.emotionalTone,
  'narrativeStyle': instance.narrativeStyle,
  'plotStructure': instance.plotStructure,
  'storyLength': instance.storyLength,
  'references': instance.references,
  'tags': instance.tags,
};
