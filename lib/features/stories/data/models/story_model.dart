import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/story.dart';

part 'story_model.freezed.dart';
part 'story_model.g.dart';

@freezed
abstract class StoryModel with _$StoryModel {
  const factory StoryModel({
    required String id,
    required String title,
    required String scripture,
    required String story,
    required String quotes,
    required String trivia,
    required String activity,
    required String lesson,
    required StoryAttributesModel attributes,
    String? imageUrl,
    String? author,
    DateTime? publishedAt,
    @Default(0) int likes,
    @Default(0) int views,
    @Default(false) bool isFavorite,
  }) = _StoryModel;

  const StoryModel._();

  factory StoryModel.fromJson(Map<String, dynamic> json) =>
      _$StoryModelFromJson(json);

  Story toEntity() {
    return Story(
      id: id,
      title: title,
      scripture: scripture,
      story: story,
      quotes: quotes,
      trivia: trivia,
      activity: activity,
      lesson: lesson,
      attributes: attributes.toEntity(),
      imageUrl: imageUrl,
      author: author,
      publishedAt: publishedAt,
      likes: likes,
      views: views,
      isFavorite: isFavorite,
    );
  }

  factory StoryModel.fromEntity(Story entity) {
    return StoryModel(
      id: entity.id,
      title: entity.title,
      scripture: entity.scripture,
      story: entity.story,
      quotes: entity.quotes,
      trivia: entity.trivia,
      activity: entity.activity,
      lesson: entity.lesson,
      attributes: StoryAttributesModel.fromEntity(entity.attributes),
      imageUrl: entity.imageUrl,
      author: entity.author,
      publishedAt: entity.publishedAt,
      likes: entity.likes,
      views: entity.views,
      isFavorite: entity.isFavorite,
    );
  }
}

@freezed
abstract class StoryAttributesModel with _$StoryAttributesModel {
  const factory StoryAttributesModel({
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
  }) = _StoryAttributesModel;

  const StoryAttributesModel._();

  factory StoryAttributesModel.fromJson(Map<String, dynamic> json) =>
      _$StoryAttributesModelFromJson(json);

  StoryAttributes toEntity() {
    return StoryAttributes(
      storyType: storyType,
      theme: theme,
      mainCharacterType: mainCharacterType,
      storySetting: storySetting,
      timeEra: timeEra,
      narrativePerspective: narrativePerspective,
      languageStyle: languageStyle,
      emotionalTone: emotionalTone,
      narrativeStyle: narrativeStyle,
      plotStructure: plotStructure,
      storyLength: storyLength,
      references: references,
      tags: tags,
    );
  }

  factory StoryAttributesModel.fromEntity(StoryAttributes entity) {
    return StoryAttributesModel(
      storyType: entity.storyType,
      theme: entity.theme,
      mainCharacterType: entity.mainCharacterType,
      storySetting: entity.storySetting,
      timeEra: entity.timeEra,
      narrativePerspective: entity.narrativePerspective,
      languageStyle: entity.languageStyle,
      emotionalTone: entity.emotionalTone,
      narrativeStyle: entity.narrativeStyle,
      plotStructure: entity.plotStructure,
      storyLength: entity.storyLength,
      references: entity.references,
      tags: entity.tags,
    );
  }
}
