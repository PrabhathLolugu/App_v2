import 'package:fpdart/fpdart.dart';
import 'package:myitihas/core/errors/failures.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import 'package:myitihas/features/story_generator/domain/entities/story_chat_message.dart';
import 'package:myitihas/features/story_generator/domain/entities/story_translation.dart';
import '../entities/story_prompt.dart';
import '../entities/generator_options.dart';

/// Repository interface for story generation
abstract class StoryGeneratorRepository {
  /// Generate a new story based on the prompt and options
  Future<Either<Failure, Story>> generateStory({
    required StoryPrompt prompt,
    required GeneratorOptions options,
  });

  /// Get a single generated story by ID
  Future<Either<Failure, Story>> getStoryById(String storyId);

  Future<Either<Failure, List<Story>>> getStories(int limit);

  /// Get random options for story generation
  Future<Either<Failure, StoryPrompt>> getRandomOptions();

  /// Generate an image for the story
  Future<Either<Failure, String>> generateStoryImage({
    required String title,
    required String story,
    required String moral,
  });

  /// Save the generated story to Supabase
  Future<Either<Failure, Story>> updateStory(Story story);

  Future<Either<Failure, Story>> likeStory(Story story, bool isLiked);

  /// Get list of generated stories for the current user
  Future<Either<Failure, List<Story>>> getGeneratedStories({
    int limit = 10,
    int offset = 0,
  });

  Future<Either<Failure, Story>> regenerateStory({
    required Story original,
    required StoryPrompt prompt,
    required GeneratorOptions options,
  });

  Future<Either<Failure, String>> expandStory({
    required Story story,
    required int currentChapter,
    required String storyLanguage,
  });

  Future<Either<Failure, Map<String, dynamic>>> getCharacterDetails({
    required Story story,
    required String characterName,
    required int currentChapter,
    required String storyLanguage,
  });

  Future<Either<Failure, StoryChatConversation>> getOrCreateStoryChat({
    required Story story,
  });

  Future<Either<Failure, StoryChatConversation>> sendStoryChatMessage({
    required Story story,
    required StoryChatConversation conversation,
    required String message,
    required String language, // ISO code like "en" or "hi"
  });

  Future<Either<Failure, TranslatedStory>> translateStory({
    required Story story,
    required String targetLang,
  });
}
