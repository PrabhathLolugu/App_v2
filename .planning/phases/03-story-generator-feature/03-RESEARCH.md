# Phase 3: Story Generator Feature - Research

**Researched:** 2026-01-29
**Domain:** Offline caching for generated story history with Brick, network-aware UI patterns
**Confidence:** HIGH

## Summary

Phase 3 adds offline caching to the Story Generator feature, enabling users to browse and read their previously generated stories without internet. The core challenge is handling complex nested data (chat conversations, translations, character details) that currently lives only in Supabase.

**Key insight:** Generated stories already use the `Story` entity which has a Brick model from Phase 2. The main work is: (1) creating Brick models for `StoryChatConversation` to cache chat history, (2) handling `Map<String, TranslatedStory>` translations as JSONB in Supabase (Brick can't model Map types with custom value classes), (3) implementing network-aware UI (disable generate button when offline, show snackbar for uncached stories), and (4) deciding caching timing for related data.

Current repository implementation stores translations in `attributes.translations` (Map field in JSONB column) and chat conversations in a separate `story_chats` table. Translations can stay embedded as JSONB since they're accessed as a unit with the story. Chat conversations need their own Brick model since they're stored in a separate table with independent sync lifecycle.

**Primary recommendation:** Create `StoryChatConversationModel` extending OfflineFirstWithSupabaseModel for the `story_chats` table with JSONB `messages` column. Keep translations embedded in story attributes (no separate model - serialize as Map to JSONB). Use `NetworkInfo` service with BLoC listeners to disable generate button when offline. Cache stories immediately after generation (already happens via repository upsert), cache chat conversations lazily on first access (alwaysHydrate policy), and fetch character details on-demand (don't pre-cache).

## Standard Stack

The established libraries/tools for Phase 3:

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| brick_offline_first_with_supabase | ^2.1.0 | Already installed, handles Story caching | Phase 2 completion, same patterns extend to chat |
| internet_connection_checker_plus | ^2.9.1 | Already installed, network connectivity detection | Existing NetworkInfo service in core layer |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| flutter_bloc | current | Already installed, state management | Listen to connectivity changes, disable UI when offline |
| fpdart | current | Already installed, Either monad for failures | Repository return types for offline/network errors |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| JSONB for translations | Separate translations table with Brick model | Separate table adds complexity, translations are always accessed as a unit with story |
| Lazy chat caching | Cache chats immediately with story | Lazy caching reduces initial sync time, most users don't use chat feature |
| Separate NetworkInfo checks | Brick's automatic offline handling | Brick handles data access offline, but generation requires explicit online check |
| StreamBuilder for connectivity | BLoC with connectivity listener | BLoC aligns with existing architecture, better for complex state |

**Installation:**
Already completed in Phase 1-2. No new packages required.

## Architecture Patterns

### Recommended Project Structure
```
lib/features/story_generator/
├── domain/
│   ├── entities/
│   │   ├── story_chat_message.dart       # Already exists (pure Dart)
│   │   └── story_translation.dart        # Already exists (simple class with fromJson/toJson)
│   └── repositories/
│       └── story_generator_repository.dart  # Interface (no change)
├── data/
│   ├── models/
│   │   └── story_chat_conversation.model.dart  # NEW: Brick model for story_chats table
│   ├── repositories/
│   │   └── story_generator_repository_impl.dart  # MODIFY: Use repository.get<> for cached stories
│   └── datasources/
│       └── remote_story_generator_datasource.dart  # Keep for generation (requires online)
└── presentation/
    ├── bloc/
    │   └── story_generator_bloc.dart      # MODIFY: Listen to NetworkInfo, disable generate when offline
    └── pages/
        ├── story_generator_page.dart      # MODIFY: Disable button + hint text when offline
        └── generated_story_detail_page.dart  # MODIFY: Show snackbar if story not cached offline
```

### Pattern 1: Brick Model for Chat Conversations with JSONB Messages
**What:** Model for `story_chats` table storing messages array as JSONB
**When to use:** For entity stored in separate Supabase table with complex nested data
**Example:**
```dart
// lib/features/story_generator/data/models/story_chat_conversation.model.dart
// Source: Existing StoryChatConversation + Phase 2 Brick patterns
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import '../../domain/entities/story_chat_message.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'story_chats'),
  sqliteConfig: SqliteSerializable(),
)
class StoryChatConversationModel extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  final String id;

  @Supabase(name: 'story_id')
  final String storyId;

  @Supabase(name: 'user_id')
  final String userId;

  final String title;

  // JSONB column - store as JSON string in SQLite, Map in Supabase
  // Brick will auto-serialize List<Map<String, dynamic>>
  @Supabase(name: 'messages')
  @Sqlite(name: 'messages')
  final List<Map<String, dynamic>> messagesJson;

  @Supabase(name: 'created_at')
  final DateTime createdAt;

  @Supabase(name: 'updated_at')
  final DateTime updatedAt;

  StoryChatConversationModel({
    required this.id,
    required this.storyId,
    required this.userId,
    required this.title,
    required this.messagesJson,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StoryChatConversationModel.fromDomain(StoryChatConversation entity) {
    return StoryChatConversationModel(
      id: entity.id,
      storyId: entity.storyId,
      userId: entity.userId,
      title: entity.title,
      messagesJson: entity.messages.map((m) => m.toJson()).toList(),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  StoryChatConversation toDomain() {
    return StoryChatConversation(
      id: id,
      storyId: storyId,
      userId: userId,
      title: title,
      messages: messagesJson
          .map((json) => StoryChatMessage.fromJson(json))
          .toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
```

### Pattern 2: Repository with Cached Story Queries
**What:** Use Brick repository for getGeneratedStories() with alwaysHydrate policy
**When to use:** Replace direct Supabase queries for data that should be cached
**Example:**
```dart
// lib/features/story_generator/data/repositories/story_generator_repository_impl.dart
// Modify existing implementation
@override
Future<Either<Failure, List<Story>>> getGeneratedStories() async {
  try {
    final user = SupabaseService.client.auth.currentUser;
    if (user == null) {
      return Left(ServerFailure('User not authenticated'));
    }

    // Use Brick instead of direct Supabase query
    final models = await repository.get<StoryModel>(
      policy: OfflineFirstGetPolicy.alwaysHydrate,  // Show cache, sync background
      query: Query.where('authorId', user.id),
    );

    return Right(models.map((m) => m.toDomain()).toList());
  } on BrickException catch (e) {
    return Left(CacheFailure(e.message));
  } catch (e) {
    return Left(UnexpectedFailure(e.toString()));
  }
}

@override
Future<Either<Failure, Story>> getStoryById(String storyId) async {
  try {
    final user = SupabaseService.client.auth.currentUser;
    if (user == null) {
      return Left(ServerFailure('User not authenticated'));
    }

    final models = await repository.get<StoryModel>(
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,  // Fetch if not cached
      query: Query.where('id', storyId).where('authorId', user.id),
    );

    if (models.isEmpty) {
      return Left(NotFoundFailure('Story not available offline'));
    }

    return Right(models.first.toDomain());
  } on BrickException catch (e) {
    return Left(CacheFailure(e.message));
  } catch (e) {
    return Left(UnexpectedFailure(e.toString()));
  }
}
```

### Pattern 3: Cache Story Immediately After Generation
**What:** Upsert generated story to Brick repository after Supabase insert
**When to use:** After story generation completes successfully
**Example:**
```dart
// In generateStory() method, after Supabase insert
@override
Future<Either<Failure, Story>> generateStory({
  required StoryPrompt prompt,
  required GeneratorOptions options,
}) async {
  try {
    // ... existing generation logic ...

    // Insert to Supabase
    final response = await SupabaseService.client
        .from('stories')
        .insert(storyMap)
        .select()
        .single();

    final story = _mapSupabaseRowToStory(response);

    // NEW: Cache immediately to Brick for offline access
    await repository.upsert<StoryModel>(
      StoryModel.fromDomain(story),
      policy: OfflineFirstUpsertPolicy.optimisticLocal,
    );

    return Right(story);
  } catch (e) {
    return Left(ServerFailure('Failed to generate story: ${e.toString()}'));
  }
}
```

### Pattern 4: Lazy Chat Caching on Access
**What:** Cache chat conversations when user opens chat for first time
**When to use:** In getOrCreateStoryChat() method
**Example:**
```dart
@override
Future<Either<Failure, StoryChatConversation>> getOrCreateStoryChat({
  required Story story,
}) async {
  try {
    final user = SupabaseService.client.auth.currentUser;
    if (user == null) {
      return Left(ServerFailure('User not authenticated'));
    }

    // Try Brick cache first
    final cached = await repository.get<StoryChatConversationModel>(
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
      query: Query.where('storyId', story.id).where('userId', user.id),
    );

    if (cached.isNotEmpty) {
      return Right(cached.first.toDomain());
    }

    // Create new conversation in Supabase
    final now = DateTime.now();
    final initial = StoryChatMessage(
      sender: 'bot',
      text: "Let's discuss "${story.title}". Ask me anything!",
      timestamp: now,
      storyContext: _buildStoryContext(story),
    );

    final insertBody = {
      'story_id': story.id,
      'user_id': user.id,
      'messages': [initial.toJson()],
    };

    final row = await SupabaseService.client
        .from('story_chats')
        .insert(insertBody)
        .select()
        .single();

    final conversation = StoryChatConversation.fromSupabaseRow(row);

    // Cache to Brick
    await repository.upsert<StoryChatConversationModel>(
      StoryChatConversationModel.fromDomain(conversation),
      policy: OfflineFirstUpsertPolicy.optimisticLocal,
    );

    return Right(conversation);
  } catch (e) {
    return Left(ServerFailure('Failed to load story chat: ${e.toString()}'));
  }
}
```

### Pattern 5: Network-Aware BLoC State
**What:** Listen to NetworkInfo connectivity and update state
**When to use:** In story generator BLoC initialization
**Example:**
```dart
// lib/features/story_generator/presentation/bloc/story_generator_bloc.dart
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class StoryGeneratorBloc extends Bloc<StoryGeneratorEvent, StoryGeneratorState> {
  final GenerateStory _generateStory;
  final NetworkInfo _networkInfo;
  StreamSubscription<InternetStatus>? _connectivitySubscription;

  StoryGeneratorBloc({
    required GenerateStory generateStory,
    required NetworkInfo networkInfo,
  })  : _generateStory = generateStory,
        _networkInfo = networkInfo,
        super(const StoryGeneratorState.initial()) {

    on<_CheckConnectivity>(_onCheckConnectivity);
    on<_GenerateStory>(_onGenerateStory);

    // Listen to connectivity changes
    _connectivitySubscription = InternetConnection().onStatusChange.listen(
      (InternetStatus status) {
        add(const StoryGeneratorEvent.checkConnectivity());
      },
    );
  }

  Future<void> _onCheckConnectivity(
    _CheckConnectivity event,
    Emitter<StoryGeneratorState> emit,
  ) async {
    final isOnline = await _networkInfo.isConnected;
    emit(state.copyWith(isOnline: isOnline));
  }

  Future<void> _onGenerateStory(
    _GenerateStory event,
    Emitter<StoryGeneratorState> emit,
  ) async {
    // Check online before generation
    final isOnline = await _networkInfo.isConnected;
    if (!isOnline) {
      emit(state.copyWith(
        status: GeneratorStatus.error,
        errorMessage: 'Story generation requires internet connection',
      ));
      return;
    }

    emit(state.copyWith(status: GeneratorStatus.generating));

    final result = await _generateStory(GenerateStoryParams(
      prompt: event.prompt,
      options: event.options,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        status: GeneratorStatus.error,
        errorMessage: failure.message,
      )),
      (story) => emit(state.copyWith(
        status: GeneratorStatus.success,
        generatedStory: story,
      )),
    );
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
```

### Pattern 6: Offline UI Feedback (Disabled Button + Tooltip)
**What:** Disable generate button when offline, show explanatory text
**When to use:** In story_generator_page.dart UI
**Example:**
```dart
// lib/features/story_generator/presentation/pages/story_generator_page.dart
BlocBuilder<StoryGeneratorBloc, StoryGeneratorState>(
  builder: (context, state) {
    final isOnline = state.isOnline ?? true;

    return Column(
      children: [
        // Generate button
        ElevatedButton(
          onPressed: isOnline && state.prompt.isComplete
              ? () => context.read<StoryGeneratorBloc>().add(
                    StoryGeneratorEvent.generateStory(
                      prompt: state.prompt,
                      options: state.options,
                    ),
                  )
              : null,  // Disabled when offline or incomplete
          child: Text(context.t.storyGenerator.generateButton),
        ),

        // Offline hint text
        if (!isOnline)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              context.t.storyGenerator.requiresInternet,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  },
)
```

### Pattern 7: Snackbar for Uncached Story Access Offline
**What:** Show snackbar when user taps story that isn't cached while offline
**When to use:** In generated_story_detail_page.dart when story fetch fails offline
**Example:**
```dart
// lib/features/story_generator/presentation/pages/generated_story_detail_page.dart
BlocListener<StoryDetailBloc, StoryDetailState>(
  listener: (context, state) {
    if (state is StoryDetailError) {
      final isOfflineError = state.failure is NotFoundFailure ||
                             state.failure is CacheFailure;

      if (isOfflineError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.t.storyGenerator.notAvailableOffline),
            backgroundColor: context.colorScheme.error,
            action: SnackBarAction(
              label: context.t.common.dismiss,
              textColor: context.colorScheme.onError,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    }
  },
  child: BlocBuilder<StoryDetailBloc, StoryDetailState>(
    builder: (context, state) {
      // ... existing UI ...
    },
  ),
)
```

### Anti-Patterns to Avoid
- **Creating separate Brick model for TranslatedStory:** Translations are part of story attributes, stored as JSONB Map. Keep as JSON serialization in existing StoryAttributesModel.
- **Pre-caching character details:** Character details are fetched on-demand from edge function. Don't cache - too variable, not worth storage.
- **Showing offline badge on history list items:** User decision: stories appear normal, only show error when tapped while offline.
- **Using Brick for story generation:** Generation calls edge function (requires online). Only use Brick for caching result.
- **Checking connectivity before every Brick query:** Brick handles offline automatically. Only check for operations that truly require network (generation, image upload).

## Don't Hand-Roll

Problems that look simple but have existing solutions:

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Connectivity monitoring | Manual Stream.periodic ping checks | internet_connection_checker_plus already installed | Handles edge cases (captive portal, DNS, actual internet vs. WiFi connected) |
| Offline queue for failed requests | Custom retry logic with SharedPreferences | Brick's offlineRequestQueue (already configured) | Handles request ordering, deduplication, auth token refresh |
| Chat message JSONB serialization | Custom JSON encoding/decoding | Brick adapters with List<Map<String, dynamic>> | Auto-generates SQLite schema, handles type conversions |
| Network error vs cache miss | Custom error types and if/else chains | BrickException types + Either monad | Brick throws specific exceptions, fpdart Either handles gracefully |

**Key insight:** Story generator already has complex Supabase interactions (edge functions, JSONB attributes). Adding manual offline caching would require: request queue, retry logic, conflict resolution, incremental sync. Brick handles all of this with declarative policies.

## Common Pitfalls

### Pitfall 1: Forgetting to Add NetworkInfo to BLoC Constructor
**What goes wrong:** BLoC can't check connectivity, generate button always enabled offline, users see confusing errors
**Why it happens:** NetworkInfo service exists but not injected into generator BLoC
**How to avoid:** Add NetworkInfo parameter to StoryGeneratorBloc constructor, register in injectable
**Warning signs:**
- Generate button stays enabled even when offline
- Users see "Failed to generate story" instead of "Requires internet connection"
- No connectivity subscription in BLoC

### Pitfall 2: Not Caching Story After Generation
**What goes wrong:** Story saved to Supabase but not local cache, disappears offline
**Why it happens:** generateStory() returns Supabase row but doesn't upsert to Brick
**How to avoid:** Call repository.upsert<StoryModel>() after successful Supabase insert
**Warning signs:**
- Generated stories show in online list but disappear when offline
- getGeneratedStories() returns empty list offline even after generating stories
- No upsert call in generateStory() method

### Pitfall 3: Caching Character Details with Story
**What goes wrong:** Storage bloat from caching ephemeral data, stale character details shown
**Why it happens:** Trying to cache everything for "complete offline experience"
**How to avoid:** Cache only persistent data (story content, translations, chat history). Fetch character details on-demand.
**Warning signs:**
- Database size grows much faster than expected
- Character details become stale when story updated
- Trying to create CharacterDetailsModel extending Brick

### Pitfall 4: Using Separate Table for Translations
**What goes wrong:** Adds schema complexity, slows down story queries, translations never accessed independently
**Why it happens:** Thinking "one model per entity" instead of "one model per table"
**How to avoid:** Keep translations embedded in story attributes as JSONB Map. Only create separate model for separate tables.
**Warning signs:**
- Creating TranslatedStoryModel.dart file
- Adding translations table to Supabase schema
- Complex JOIN queries to fetch story + translations

### Pitfall 5: Not Handling Missing Story Attributes Fields
**What goes wrong:** Runtime errors when accessing characters, characterDetails, translations fields missing from Phase 2 model
**Why it happens:** StoryAttributesModel from Phase 2 doesn't include all fields from domain entity
**How to avoid:** Extend StoryAttributesModel with missing fields: characters (List<String>), characterDetails (Map stored as JSONB), translations (Map stored as JSONB)
**Warning signs:**
- NoSuchMethodError when accessing story.attributes.characters
- Generated stories fail to cache
- Build runner errors about missing fields in adapter

### Pitfall 6: Showing Generic "Error" for Offline Story Access
**What goes wrong:** User doesn't understand why story won't load, thinks app is broken
**Why it happens:** Not distinguishing between NotFoundFailure (offline, not cached) vs ServerFailure (network error)
**How to avoid:** Check failure type, show specific message: "Story not available offline. Connect to internet to view."
**Warning signs:**
- Same error message for all failures
- No network context in error handling
- Users confused why some stories load offline and others don't

## Code Examples

Verified patterns from official sources and Phase 2 implementation:

### Complete StoryChatConversationModel
```dart
// lib/features/story_generator/data/models/story_chat_conversation.model.dart
// Source: Phase 2 Brick patterns + existing StoryChatConversation entity
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import '../../domain/entities/story_chat_message.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'story_chats'),
  sqliteConfig: SqliteSerializable(),
)
class StoryChatConversationModel extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  final String id;

  @Supabase(name: 'story_id')
  final String storyId;

  @Supabase(name: 'user_id')
  final String userId;

  final String title;

  // JSONB column in Supabase, TEXT column in SQLite
  // Brick auto-serializes List<Map<String, dynamic>> to/from JSON
  @Supabase(name: 'messages')
  @Sqlite(name: 'messages')
  final List<Map<String, dynamic>> messagesJson;

  @Supabase(name: 'created_at')
  final DateTime createdAt;

  @Supabase(name: 'updated_at')
  final DateTime updatedAt;

  StoryChatConversationModel({
    required this.id,
    required this.storyId,
    required this.userId,
    required this.title,
    required this.messagesJson,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StoryChatConversationModel.fromDomain(StoryChatConversation entity) {
    return StoryChatConversationModel(
      id: entity.id,
      storyId: entity.storyId,
      userId: entity.userId,
      title: entity.title,
      messagesJson: entity.messages.map((m) => m.toJson()).toList(),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  StoryChatConversation toDomain() {
    return StoryChatConversation(
      id: id,
      storyId: storyId,
      userId: userId,
      title: title,
      messages: messagesJson
          .map((json) => StoryChatMessage.fromJson(json))
          .toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
```

### Extended StoryAttributesModel with Missing Fields
```dart
// lib/features/stories/data/models/story_attributes.model.dart
// Add missing fields from domain entity
@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'story_attributes'),
  sqliteConfig: SqliteSerializable(),
)
class StoryAttributesModel extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  final String id;
  final String storyType;
  final String theme;
  final String mainCharacterType;
  final String storySetting;
  final String timeEra;
  final String narrativePerspective;
  final String languageStyle;
  final String emotionalTone;
  final String narrativeStyle;
  final String plotStructure;
  final String storyLength;
  final List<String> references;
  final List<String> tags;

  // NEW: Missing fields from domain entity
  final List<String> characters;

  // JSONB Map fields - Brick serializes as JSON string in SQLite
  @Supabase(name: 'character_details')
  @Sqlite(name: 'character_details')
  final Map<String, dynamic> characterDetails;

  // Translations stored as JSONB Map - serialize manually in toDomain/fromDomain
  @Supabase(name: 'translations')
  @Sqlite(name: 'translations')
  final Map<String, dynamic> translationsJson;

  StoryAttributesModel({
    required this.id,
    required this.storyType,
    required this.theme,
    required this.mainCharacterType,
    required this.storySetting,
    required this.timeEra,
    required this.narrativePerspective,
    required this.languageStyle,
    required this.emotionalTone,
    required this.narrativeStyle,
    required this.plotStructure,
    required this.storyLength,
    this.references = const [],
    this.tags = const [],
    this.characters = const [],
    this.characterDetails = const {},
    this.translationsJson = const {},
  });

  factory StoryAttributesModel.fromDomain(StoryAttributes entity) {
    return StoryAttributesModel(
      id: '',  // Generated by Brick
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
      characters: entity.characters,
      characterDetails: entity.characterDetails,
      translationsJson: entity.translations.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
    );
  }

  StoryAttributes toDomain() {
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
      characters: characters,
      characterDetails: characterDetails,
      translations: _parseTranslations(translationsJson),
    );
  }

  Map<String, TranslatedStory> _parseTranslations(Map<String, dynamic> json) {
    final result = <String, TranslatedStory>{};
    for (final entry in json.entries) {
      if (entry.value is Map<String, dynamic>) {
        result[entry.key] = TranslatedStory.fromJson(entry.value);
      }
    }
    return result;
  }
}
```

### Network-Aware Generator BLoC State
```dart
// lib/features/story_generator/presentation/bloc/story_generator_state.dart
// Add isOnline field to state
@freezed
sealed class StoryGeneratorState with _$StoryGeneratorState {
  const factory StoryGeneratorState({
    @Default(GeneratorStatus.initial) GeneratorStatus status,
    @Default(StoryPrompt()) StoryPrompt prompt,
    @Default(GeneratorOptions()) GeneratorOptions options,
    Story? generatedStory,
    String? errorMessage,
    @Default(true) bool isOnline,  // NEW: Track connectivity
  }) = _StoryGeneratorState;
}

// lib/features/story_generator/presentation/bloc/story_generator_event.dart
// Add connectivity check event
@freezed
sealed class StoryGeneratorEvent with _$StoryGeneratorEvent {
  const factory StoryGeneratorEvent.checkConnectivity() = _CheckConnectivity;
  const factory StoryGeneratorEvent.generateStory({
    required StoryPrompt prompt,
    required GeneratorOptions options,
  }) = _GenerateStory;
  // ... other events ...
}
```

### Repository Implementation with Brick Caching
```dart
// lib/features/story_generator/data/repositories/story_generator_repository_impl.dart
// Full implementation with caching
@LazySingleton(as: StoryGeneratorRepository)
class StoryGeneratorRepositoryImpl implements StoryGeneratorRepository {
  final RemoteStoryGeneratorDataSource _remoteDataSource;
  final MyItihasRepository _repository;
  final NetworkInfo _networkInfo;

  StoryGeneratorRepositoryImpl(
    this._remoteDataSource,
    this._repository,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, List<Story>>> getGeneratedStories() async {
    try {
      final user = SupabaseService.client.auth.currentUser;
      if (user == null) {
        return Left(ServerFailure('User not authenticated'));
      }

      // Use Brick with alwaysHydrate: show cache, sync in background
      final models = await _repository.get<StoryModel>(
        policy: OfflineFirstGetPolicy.alwaysHydrate,
        query: Query.where('authorId', user.id),
      );

      return Right(models.map((m) => m.toDomain()).toList());
    } on BrickException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Story>> getStoryById(String storyId) async {
    try {
      final user = SupabaseService.client.auth.currentUser;
      if (user == null) {
        return Left(ServerFailure('User not authenticated'));
      }

      final models = await _repository.get<StoryModel>(
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
        query: Query.where('id', storyId).where('authorId', user.id),
      );

      if (models.isEmpty) {
        final isOnline = await _networkInfo.isConnected;
        if (!isOnline) {
          return Left(NotFoundFailure('Story not available offline'));
        }
        return Left(NotFoundFailure('Story not found'));
      }

      return Right(models.first.toDomain());
    } on BrickException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Story>> generateStory({
    required StoryPrompt prompt,
    required GeneratorOptions options,
  }) async {
    try {
      // Check online before generation
      final isOnline = await _networkInfo.isConnected;
      if (!isOnline) {
        return Left(NetworkFailure('Story generation requires internet connection'));
      }

      // Generate via edge function (requires online)
      final result = await _remoteDataSource.generateStory(
        prompt: prompt,
        options: options,
      );

      // ... existing story mapping logic ...

      // Insert to Supabase
      final response = await SupabaseService.client
          .from('stories')
          .insert(storyMap)
          .select()
          .single();

      final story = _mapSupabaseRowToStory(response);

      // NEW: Cache immediately for offline access
      await _repository.upsert<StoryModel>(
        StoryModel.fromDomain(story),
        policy: OfflineFirstUpsertPolicy.optimisticLocal,
      );

      return Right(story);
    } catch (e) {
      return Left(ServerFailure('Failed to generate story: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, StoryChatConversation>> getOrCreateStoryChat({
    required Story story,
  }) async {
    try {
      final user = SupabaseService.client.auth.currentUser;
      if (user == null) {
        return Left(ServerFailure('User not authenticated'));
      }

      // Try Brick cache first, fetch if not cached
      final cached = await _repository.get<StoryChatConversationModel>(
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
        query: Query.where('storyId', story.id).where('userId', user.id),
      );

      if (cached.isNotEmpty) {
        return Right(cached.first.toDomain());
      }

      // Create new in Supabase
      final now = DateTime.now();
      final initial = StoryChatMessage(
        sender: 'bot',
        text: "Let's discuss "${story.title}". Ask me anything!",
        timestamp: now,
      );

      final insertBody = {
        'story_id': story.id,
        'user_id': user.id,
        'messages': [initial.toJson()],
      };

      final row = await SupabaseService.client
          .from('story_chats')
          .insert(insertBody)
          .select()
          .single();

      final conversation = StoryChatConversation.fromSupabaseRow(row);

      // Cache to Brick
      await _repository.upsert<StoryChatConversationModel>(
        StoryChatConversationModel.fromDomain(conversation),
        policy: OfflineFirstUpsertPolicy.optimisticLocal,
      );

      return Right(conversation);
    } catch (e) {
      return Left(ServerFailure('Failed to load story chat: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, StoryChatConversation>> sendStoryChatMessage({
    required Story story,
    required StoryChatConversation conversation,
    required String message,
    required String language,
  }) async {
    try {
      // Check online before sending (chat requires network)
      final isOnline = await _networkInfo.isConnected;
      if (!isOnline) {
        return Left(NetworkFailure('Chat requires internet connection'));
      }

      // ... existing chat logic ...

      final row = await SupabaseService.client
          .from('story_chats')
          .update(updateBody)
          .eq('id', conversation.id)
          .select()
          .single();

      final updated = StoryChatConversation.fromSupabaseRow(row);

      // Update cache
      await _repository.upsert<StoryChatConversationModel>(
        StoryChatConversationModel.fromDomain(updated),
        policy: OfflineFirstUpsertPolicy.optimisticLocal,
      );

      return Right(updated);
    } catch (e) {
      return Left(ServerFailure('Failed to send message: ${e.toString()}'));
    }
  }

  // Character details: NO CACHING - always fetch on-demand
  @override
  Future<Either<Failure, Map<String, dynamic>>> getCharacterDetails({
    required Story story,
    required String characterName,
    required int currentChapter,
    required String storyLanguage,
  }) async {
    try {
      // Check online (requires edge function)
      final isOnline = await _networkInfo.isConnected;
      if (!isOnline) {
        return Left(NetworkFailure('Character details require internet connection'));
      }

      final result = await _remoteDataSource.interactWithStory(
        storyTitle: story.title,
        storyContent: story.story,
        interactionType: 'characters',
        characterName: characterName,
        currentChapter: currentChapter,
        storyLanguage: storyLanguage,
      );

      if (result.isEmpty) {
        return Left(ServerFailure('Empty character details response'));
      }

      // Don't cache - too ephemeral, changes with story context
      return Right(result);
    } catch (e) {
      return Left(ServerFailure('Failed to get character details: ${e.toString()}'));
    }
  }
}
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Direct Supabase queries in repository | Brick repository.get<T>() with policies | Phase 2 (2026-01) | Automatic offline caching for story history |
| Manual connectivity checks in UI | NetworkInfo service with BLoC listeners | Existing pattern, extended in Phase 3 | Reactive UI updates when connectivity changes |
| No offline story access | SQLite cache with alwaysHydrate policy | Phase 3 | Users can browse generated stories offline |
| Chat stored only in Supabase | Brick model with lazy caching on access | Phase 3 | Chat history available offline after first load |
| Translations in Supabase JSONB | Same, but cached as part of story attributes | Phase 3 | Translated stories readable offline |

**Deprecated/outdated:**
- **Direct Supabase client for getGeneratedStories()**: Replaced by Brick repository queries
- **No offline fallback for story detail page**: Now shows cached story or specific offline error
- **Always-online assumption for story generator UI**: Now checks connectivity before enabling generate button

## Open Questions

Things that couldn't be fully resolved:

1. **Should chat conversations be cached immediately with story or lazily on access?**
   - What we know: Chat is separate table, not all users use chat feature, caching adds sync time
   - What's unclear: How many users actually use chat? What's acceptable delay for first chat load?
   - Recommendation: Cache lazily on first access (getOrCreateStoryChat). Most users don't use chat, those who do can wait 1-2 seconds on first open. Use alwaysHydrate on subsequent loads.

2. **Should we show persistent offline banner on generator page?**
   - What we know: User decided "Claude's discretion", some apps show persistent banner, others just disable features
   - What's unclear: Does persistent banner annoy users or help them understand app state?
   - Recommendation: No persistent banner. Show hint text below disabled generate button: "Requires internet connection". Less intrusive, contextual to the action.

3. **What to show for missing thumbnails in history list offline?**
   - What we know: image_url may be null or image may not be cached (Phase 6-7 handles media caching)
   - What's unclear: Preferred placeholder style (generic icon, scripture-specific icon, colored background?)
   - Recommendation: Generic book/scroll icon with scripture name initial. Keep simple until Phase 6-7 implements full media caching.

4. **Should translations be cached with every story or only when accessed?**
   - What we know: Translations stored in attributes.translations Map, user can translate story to multiple languages
   - What's unclear: Do users translate offline or only online? How many translations per story?
   - Recommendation: Cache all translations that exist in Supabase when story is fetched. Translation generation requires online (edge function), but viewing existing translations should work offline.

## Sources

### Primary (HIGH confidence)
- Phase 2 Research - /Users/amansikarwar/Development/Contributions/MyItihas/.planning/phases/02-stories-feature/02-RESEARCH.md
  - Brick model patterns, toDomain/fromDomain conventions, offline-first policies
- Phase 1 Research - /Users/amansikarwar/Development/Contributions/MyItihas/.planning/phases/01-core-infrastructure/01-RESEARCH.md
  - MyItihasRepository configuration, initialization order, dependency injection
- Existing Codebase - lib/features/story_generator/
  - StoryChatConversation entity and Supabase serialization (story_chat_message.dart)
  - Repository implementation patterns (story_generator_repository_impl.dart)
  - NetworkInfo service implementation (lib/core/network/network_info.dart)
- Brick Offline First Documentation
  - GitHub: https://github.com/GetDutchie/brick/tree/main/packages/brick_offline_first_with_supabase
  - OfflineFirstGetPolicy options, OfflineFirstUpsertPolicy options

### Secondary (MEDIUM confidence)
- internet_connection_checker_plus documentation
  - Package already installed, used in NetworkInfo service
  - Stream.onStatusChange for connectivity monitoring
- Flutter BLoC patterns
  - Existing project uses BLoC for state management
  - Connectivity subscription in BLoC lifecycle

### Tertiary (LOW confidence)
- None - all findings verified with existing codebase or official documentation

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - All packages already installed, no new dependencies
- Architecture: HIGH - Extends Phase 2 patterns, verified with existing Brick implementation
- Pitfalls: MEDIUM - Based on common Brick mistakes and Phase 2 learnings, some project-specific
- UI patterns: MEDIUM - Following existing app conventions for error handling and offline feedback

**Research date:** 2026-01-29
**Valid until:** 2026-02-28 (30 days - stable packages, established patterns)
