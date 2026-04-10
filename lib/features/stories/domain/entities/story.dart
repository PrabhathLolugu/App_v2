import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myitihas/features/social/domain/entities/user.dart';
import 'package:myitihas/features/story_generator/domain/entities/story_translation.dart';

part 'story.freezed.dart';

@freezed
abstract class Story with _$Story {
  const factory Story({
    required String id,
    required String title,
    required String scripture,
    required String story,
    required String quotes,
    required String trivia,
    required String activity,
    required String lesson,
    required StoryAttributes attributes,
    String? imageUrl,
    String? author,
    DateTime? publishedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(0) int likes,
    @Default(0) int views,
    @Default(false) bool isFavorite,
    @Default(false) bool isFeatured,
    String? authorId,
    User? authorUser,
    @Default(0) int commentCount,
    @Default(0) int shareCount,
    @Default(false) bool isLikedByCurrentUser,
  }) = _Story;

  const Story._();
}

@freezed
abstract class StoryAttributes with _$StoryAttributes {
  const factory StoryAttributes({
    required String storyType,
    required String theme,
    required String mainCharacterType,
    required String storySetting,
    required String timeEra,
    required String narrativePerspective,
    required String languageStyle,
    required String emotionalTone,
    required String narrativeStyle,
    required String plotStructure,
    required String storyLength,
    @Default([]) List<String> references,
    @Default([]) List<String> tags,
    @Default([]) List<String> characters,
    @Default({}) Map<String, dynamic> characterDetails,
    @Default({}) Map<String, TranslatedStory> translations,
  }) = _StoryAttributes;
}
