import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/errors/exceptions.dart';
import '../../domain/entities/generator_options.dart';
import '../../domain/entities/story_prompt.dart';

@lazySingleton
class RemoteStoryGeneratorDataSource {
  final SupabaseClient _supabase;

  RemoteStoryGeneratorDataSource(this._supabase);

  Future<Map<String, dynamic>> generateStory({
    required StoryPrompt prompt,
    required GeneratorOptions options,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw const ServerException('User must be authenticated to generate story');
      }

      // Build request body matching Edge Function format
      final requestBody = {
        'prompt': {
          'scripture': prompt.scripture,
          'scriptureSubtype': prompt.scriptureSubtype,
          'storyType': prompt.storyType,
          'theme': prompt.theme,
          'mainCharacter': prompt.mainCharacter,
          'setting': prompt.setting,
          'rawPrompt': prompt.rawPrompt,
          'isRawPrompt': prompt.isRawPrompt,
        },
        'options': {
          'language': {
            'displayName': options.language.displayName,
            'code': options.language.code,
          },
          'format': {
            'displayName': options.format.displayName,
            'description': options.format.description,
          },
          'length': {
            'displayName': options.length.displayName,
            'description': options.length.description,
            'approximateWords': options.length.approximateWords,
          },
        },
        'userId': userId,
      };

      // Call Supabase Edge Function
      final response = await _supabase.functions.invoke(
        'generate-story',
        body: requestBody,
      );

      if (response.status == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;

        // Extract attributes from nested structure
        final attributes = data['attributes'] as Map<String, dynamic>? ?? {};

        // Return flattened structure matching repository expectations
        return {
          'title': data['title'] as String? ?? 'Untitled Story',
          'story': data['story'] as String? ?? '',
          // Scripture inferred by backend/LLM when available
          'scripture': data['scripture'] as String?,
          'moral':
              data['lesson'] as String? ?? attributes['moral'] as String? ?? '',
          'reference':
              (attributes['references'] as List?)?.first as String? ??
              attributes['references'] as String? ??
              prompt.scripture ??
              '',
          'characters': attributes['characters'] ?? [],
          'quotes': data['quotes'] ?? '',
          'trivia': data['trivia'] ?? '',
          'activity': data['activity'] ?? '',
          'attributes': attributes,
        };
      } else {
        // Preserve error details from Edge Function
        final errorMessage = response.data is Map<String, dynamic>
            ? (response.data['error'] ??
                response.data['message'] ??
                'Unknown error')
            : response.data?.toString() ?? 'Unknown error';
        throw ServerException(
          'Failed to generate story (${response.status}): $errorMessage',
          response.status.toString(),
        );
      }
    } on Exception {
      rethrow; // Preserve original exception with details
    } catch (e) {
      throw Exception('Failed to generate story: $e');
    }
  }

  // Helper to get random options (mock implementation as backend doesn't support it yet)
  Future<StoryPrompt> getRandomOptions() async {
    throw UnimplementedError('Random options should be handled locally');
  }

  Future<Map<String, dynamic>> interactWithStory({
    required String storyTitle,
    required String storyContent,
    required String interactionType, // e.g. "expand"
    String? characterName,
    required int currentChapter,
    required String storyLanguage,
  }) async {
    try {
      final requestBody = {
        'story_title': storyTitle,
        'story_content': storyContent,
        'interaction_type': interactionType,
        'character_name': characterName,
        'story_language': storyLanguage,
      };

      final response = await _supabase.functions.invoke(
        'interact-with-story',
        body: requestBody,
      );

      if (response.status == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        return data;
      }

      final errorMessage = response.data is Map<String, dynamic>
          ? (response.data['error'] ?? 'Unknown error')
          : response.data?.toString() ?? 'Unknown error';
      throw ServerException(
        'Failed to interact with story (${response.status}): $errorMessage',
        response.status.toString(),
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Story interaction error: $e');
    }
  }

  Future<String> chat({
    required List<Map<String, dynamic>> messages,
    required String mode, // e.g. "story_scholar"
    Map<String, dynamic>? storyContext,
    required String language, // e.g. "English" or "Hindi"
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;

      // Get last message as the current message
      final lastMessage = messages.isNotEmpty ? messages.last : null;
      if (lastMessage == null) {
        throw const ServerException('No message to send');
      }

      String normalizedLanguage = language;
      if (normalizedLanguage.trim().isEmpty) {
        normalizedLanguage = 'English';
      }

      final requestBody = {
        'message': lastMessage['content'] ?? lastMessage['text'] ?? '',
        'mode': mode,
        'language': normalizedLanguage,
        'user_id': userId,
        if (storyContext != null) ...{
          'title': storyContext['title'],
          'story_content': storyContext['content'] ?? storyContext['story'],
          'moral': storyContext['moral'],
        },
      };

      final response = await _supabase.functions.invoke(
        'chat-service',
        body: requestBody,
      );

      if (response.status == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        return (data['response'] ?? '').toString();
      }

      throw ServerException('Failed to chat: ${response.status}', response.status.toString());
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Chat error: $e');
    }
  }

  Future<String> generateStoryImage({
    required String title,
    required String story,
    required String moral,
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        'generate-image',
        body: {'title': title, 'story_content': story},
      );

      if (response.status == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final imageUrl = data['url'] ?? data['image_url'];
        if (imageUrl != null) {
          return imageUrl.toString();
        }
        throw const ServerException('No image URL returned from service');
      }
      throw ServerException(
        'Failed to generate image: ${response.status}',
        response.status.toString(),
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Image generation error: $e');
    }
  }

  Future<Map<String, dynamic>> translateStory({
    required String title,
    required String content,
    required String moral,
    String? trivia,
    required String targetLang,
  }) async {
    final response = await _supabase.functions.invoke(
      'translation',
      body: {
        'title': title,
        'story': content,
        'moral': moral,
        'trivia': trivia ?? '',
        'target_lang': targetLang,
      },
    );

    if (response.status == 200 && response.data != null) {
      return response.data as Map<String, dynamic>;
    }

    throw ServerException('Translation failed: ${response.status}', response.status.toString());
  }
}
