import 'package:flutter/material.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import 'package:myitihas/features/story_generator/domain/repositories/story_generator_repository.dart';
import 'package:myitihas/features/story_generator/presentation/pages/generated_story_detail_page.dart';
import 'package:myitihas/i18n/strings.g.dart';

/// Page that fetches a generated story by ID and displays it
class GeneratedStoryByIdPage extends StatefulWidget {
  final String storyId;

  const GeneratedStoryByIdPage({super.key, required this.storyId});

  @override
  State<GeneratedStoryByIdPage> createState() => _GeneratedStoryByIdPageState();
}

class _GeneratedStoryByIdPageState extends State<GeneratedStoryByIdPage> {
  late Future<Story?> _storyFuture;

  @override
  void initState() {
    super.initState();
    _storyFuture = _fetchStory();
  }

  Future<Story?> _fetchStory() async {
    final repository = getIt<StoryGeneratorRepository>();
    final result = await repository.getStoryById(widget.storyId);

    return result.fold((failure) => null, (story) => story);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final t = Translations.of(context);

    return FutureBuilder<Story?>(
      future: _storyFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: colorScheme.surface,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final story = snapshot.data;
        if (story == null) {
          return Scaffold(
            backgroundColor: colorScheme.surface,
            appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
            body: Padding(
              padding: const EdgeInsets.all(80.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 64,
                      color: colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      t.stories.failedToLoad,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () {
                        setState(() {
                          _storyFuture = _fetchStory();
                        });
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(t.common.retry),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return GeneratedStoryDetailPage(story: story);
      },
    );
  }
}
