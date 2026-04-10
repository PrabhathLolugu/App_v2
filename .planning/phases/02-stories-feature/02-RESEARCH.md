# Phase 2: Stories Feature - Research

**Researched:** 2026-01-29
**Domain:** Brick offline-first models with Supabase integration for Stories feature
**Confidence:** HIGH

## Summary

Phase 2 migrates the existing Stories feature from Hive to Brick offline-first caching. The core task is creating Brick models with `@ConnectOfflineFirstWithSupabase` annotation, mapping fields to the existing Supabase `stories` table, and swapping the repository implementation to use MyItihasRepository queries instead of Hive datasources.

Brick's code generation creates bidirectional adapters that serialize models between SQLite (local cache) and Supabase (remote backend). The `@ConnectOfflineFirstWithSupabase` decorator configures which providers (SQLite, Supabase) handle each model, while field-level annotations (`@Supabase`, `@Sqlite`, `@OfflineFirst`) control column mapping, foreign keys, and sync behavior.

Key architectural insight: Brick models replace the data layer's model files (currently using `@HiveType`), but domain entities remain unchanged. The Clean Architecture boundary stays intact - domain entities are pure Dart, Brick models live in the data layer with `toDomain()` methods. Repository implementations call `repository.get<StoryModel>()` instead of datasource methods, and Brick automatically handles offline-first queries (SQLite first, then Supabase if online).

**Primary recommendation:** Create `.model.dart` files extending `OfflineFirstWithSupabaseModel`, use `@Supabase()` annotations for column name mapping and foreign keys, configure realtime subscriptions for auto-sync, and implement size-based LRU cache eviction manually (Brick has no built-in cache size limits). Default to `alwaysHydrate` policy for story lists (background refresh) and `awaitRemoteWhenNoneExist` for detail views (fetch if not cached).

## Standard Stack

The established libraries/tools for Brick models with Supabase:

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| brick_offline_first_with_supabase | ^2.1.0 | Model annotations and adapters | Already installed in Phase 1, official Brick+Supabase integration |
| brick_offline_first_with_supabase_build | ^2.1.0 | Code generator for model adapters | Already installed, generates SQLite/Supabase serialization code |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| supabase_flutter | ^2.5.6 | Realtime subscriptions for sync | Already installed, use `.stream()` or `.onPostgresChanges()` for table updates |
| freezed | git custom | Immutable model classes | Already in project, use with Brick models for type safety |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| @ConnectOfflineFirstWithSupabase | Manual SQLite + Supabase calls | Brick eliminates 90% of serialization boilerplate, handles sync automatically |
| Supabase .stream() | Manual polling with Timer | stream() provides realtime updates with minimal code |
| Manual cache eviction | No size limits | Without limits, cache grows unbounded and consumes device storage |

**Installation:**
Already completed in Phase 1. No new packages required.

## Architecture Patterns

### Recommended Project Structure
```
lib/features/stories/
├── domain/
│   ├── entities/
│   │   └── story.dart              # Pure Dart entity (no change)
│   └── repositories/
│       └── story_repository.dart   # Interface (no change)
├── data/
│   ├── models/
│   │   ├── story.model.dart        # NEW: Brick model with @ConnectOfflineFirstWithSupabase
│   │   └── story_attributes.model.dart  # NEW: Nested model for attributes
│   └── repositories/
│       └── story_repository_impl.dart   # MODIFY: Use repository.get<StoryModel>()
└── presentation/                   # No changes (UI stays the same)
```

### Pattern 1: Brick Model with Supabase Table Mapping
**What:** Model class extending OfflineFirstWithSupabaseModel with field annotations
**When to use:** For every entity that needs offline caching with Supabase sync
**Example:**
```dart
// Source: https://github.com/GetDutchie/brick/tree/main/packages/brick_offline_first_with_supabase
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'stories'),
  sqliteConfig: SqliteSerializable(),
)
class StoryModel extends OfflineFirstWithSupabaseModel {
  // Supabase column: id (primary key)
  @Supabase(unique: true)
  final String id;

  final String title;
  final String scripture;
  final String story;

  // Nested model - Brick handles as foreign key automatically
  final StoryAttributesModel attributes;

  // Map to different column name in Supabase
  @Supabase(name: 'image_url')
  final String? imageUrl;

  // Supabase column: published_at (snake_case auto-converted)
  final DateTime? publishedAt;

  StoryModel({
    required this.id,
    required this.title,
    required this.scripture,
    required this.story,
    required this.attributes,
    this.imageUrl,
    this.publishedAt,
  });

  // Convert to domain entity
  Story toDomain() {
    return Story(
      id: id,
      title: title,
      scripture: scripture,
      story: story,
      attributes: attributes.toDomain(),
      imageUrl: imageUrl,
      publishedAt: publishedAt,
    );
  }
}
```

### Pattern 2: Nested Model Handling
**What:** Separate Brick model for complex nested data structures
**When to use:** When entity has nested objects (StoryAttributes, User associations, etc.)
**Example:**
```dart
// Source: https://github.com/GetDutchie/brick/tree/main/packages/brick_offline_first_with_supabase
@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'story_attributes'),
  sqliteConfig: SqliteSerializable(),
)
class StoryAttributesModel extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  final String id;  // Primary key for attributes table

  @Supabase(name: 'story_type')
  final String storyType;

  final String theme;

  // Arrays stored as JSON in Supabase
  final List<String> tags;
  final List<String> references;

  StoryAttributesModel({
    required this.id,
    required this.storyType,
    required this.theme,
    this.tags = const [],
    this.references = const [],
  });

  StoryAttributes toDomain() {
    return StoryAttributes(
      storyType: storyType,
      theme: theme,
      tags: tags,
      references: references,
    );
  }
}
```

### Pattern 3: Repository Implementation with Brick Queries
**What:** Replace Hive datasource calls with repository.get<T>() queries
**When to use:** In StoryRepositoryImpl after models are created
**Example:**
```dart
// Source: Brick offline-first patterns + existing MyItihas repository
@LazySingleton(as: StoryRepository)
class StoryRepositoryImpl implements StoryRepository {
  final MyItihasRepository repository;

  StoryRepositoryImpl({required this.repository});

  @override
  Future<Either<Failure, List<Story>>> getStories({
    String? searchQuery,
    int? limit,
  }) async {
    try {
      // Brick query: SQLite-first with background sync
      final models = await repository.get<StoryModel>(
        policy: OfflineFirstGetPolicy.alwaysHydrate,  // Refresh in background
        query: Query.where('title', searchQuery, compare: Compare.contains),
      );

      return Right(models.map((m) => m.toDomain()).toList());
    } on BrickException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Story>> getStoryById(String id) async {
    try {
      final models = await repository.get<StoryModel>(
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,  // Fetch if not cached
        query: Query.where('id', id),
      );

      if (models.isEmpty) {
        return const Left(NotFoundFailure('Story not found'));
      }

      return Right(models.first.toDomain());
    } on BrickException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
```

### Pattern 4: Realtime Sync for Updates
**What:** Supabase realtime subscriptions that automatically update SQLite cache
**When to use:** To keep cached data fresh when stories are updated/deleted on server
**Example:**
```dart
// Source: https://supabase.com/docs/reference/dart/subscribe
class StoryRealtimeSync {
  final MyItihasRepository repository;
  final SupabaseClient supabase;

  StoryRealtimeSync({required this.repository, required this.supabase});

  void startListening() {
    // Listen to story table changes
    supabase.channel('stories_channel')
      .onPostgresChanges(
        postgresChangeFilter: PostgresChangeFilter(
          event: '*',  // INSERT, UPDATE, DELETE
          schema: 'public',
          table: 'stories',
        ),
        (payload, [ref]) async {
          final eventType = payload.eventType;

          if (eventType == PostgresChangeEvent.insert ||
              eventType == PostgresChangeEvent.update) {
            // Brick will auto-sync on next query due to alwaysHydrate policy
            // OR manually trigger upsert:
            final storyData = payload.newRecord;
            final model = StoryModel.fromJson(storyData);
            await repository.upsert<StoryModel>(model);
          } else if (eventType == PostgresChangeEvent.delete) {
            // Remove from cache
            final storyId = payload.oldRecord['id'];
            await repository.delete<StoryModel>(
              Query.where('id', storyId),
            );
          }
        },
      )
      .subscribe();
  }
}
```

### Pattern 5: Cache Size Management with LRU Eviction
**What:** Manual implementation of cache size limits using SQLite queries
**When to use:** To prevent unbounded cache growth (Brick has no built-in size limits)
**Example:**
```dart
// Source: SQLite query patterns for LRU eviction
class StoryCacheManager {
  final MyItihasRepository repository;
  final int maxCacheSize;  // e.g., 50 MB
  final int maxStoryCount;  // e.g., 1000 stories

  Future<void> enforceStorageLimit() async {
    // Get current cache stats
    final stats = await repository.sqliteProvider.rawQuery(
      'SELECT COUNT(*) as count, SUM(LENGTH(story)) as size FROM StoryModel'
    );

    final count = stats.first['count'] as int;
    final sizeBytes = stats.first['size'] as int;

    // Evict oldest accessed stories if over limit
    if (count > maxStoryCount || sizeBytes > maxCacheSize) {
      final evictCount = (count - maxStoryCount).clamp(0, count);

      // Delete least recently accessed (assumes last_accessed column)
      await repository.sqliteProvider.rawQuery(
        'DELETE FROM StoryModel WHERE id IN '
        '(SELECT id FROM StoryModel ORDER BY last_accessed ASC LIMIT ?)',
        [evictCount]
      );
    }
  }

  // Call after each story access
  Future<void> touchStory(String storyId) async {
    await repository.sqliteProvider.rawQuery(
      'UPDATE StoryModel SET last_accessed = ? WHERE id = ?',
      [DateTime.now().millisecondsSinceEpoch, storyId]
    );
  }
}
```

### Anti-Patterns to Avoid
- **Using domain entities in repository.get():** Never `repository.get<Story>()` - use Brick models (`StoryModel`) that extend OfflineFirstWithSupabaseModel
- **Calling Supabase client directly:** After migration, always use `repository.get<T>()` instead of `supabase.from('stories')` for data that should be cached
- **Forgetting toDomain() conversion:** Repository must return domain entities to presentation layer, not Brick models
- **No unique ID annotation:** Always mark primary key field with `@Supabase(unique: true)` for upsert/delete to work correctly
- **Ignoring cache size:** Without manual eviction, cache grows unbounded and can consume gigabytes over time

## Don't Hand-Roll

Problems that look simple but have existing solutions:

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| SQLite schema for Story table | Manual CREATE TABLE scripts | Brick code generation | Auto-generates schema from model annotations, handles migrations automatically |
| Story JSON serialization | Hand-written fromJson/toJson | Brick adapters | Generates bidirectional SQLite ↔ Supabase serialization with type conversions |
| Offline-first query logic | if (networkInfo.isConnected) pattern | OfflineFirstGetPolicy | Built-in policies handle SQLite-first, background sync, await remote, etc. |
| Realtime sync to cache | Manual Supabase stream listeners | Brick + Supabase .stream() integration | Auto-updates SQLite when realtime events received |
| Foreign key relationships | Manual JOIN queries | Brick nested model handling | Automatically resolves associations, prevents N+1 queries |

**Key insight:** Story models have complex nested data (StoryAttributes), foreign keys (authorUser), and list fields (tags, references). Hand-rolling this with SQLite would require: JSON column handling, foreign key constraints, cascade deletes, and manual deserialization. Brick's code generation handles all these edge cases automatically.

## Common Pitfalls

### Pitfall 1: Missing tableName Configuration
**What goes wrong:** Code generation fails with "Could not find table for model" error
**Why it happens:** `@ConnectOfflineFirstWithSupabase` defaults to class name, but Supabase table is `stories` (plural, lowercase)
**How to avoid:** Always specify `supabaseConfig: SupabaseSerializable(tableName: 'stories')` exactly matching Supabase table name
**Warning signs:**
- Build runner completes but adapters are empty
- Runtime error: "No table found for StoryModel"
- Queries return no results even when data exists in Supabase

### Pitfall 2: Forgetting @Supabase(unique: true) on Primary Key
**What goes wrong:** Upsert and delete operations don't work correctly, duplicate records created
**Why it happens:** Brick doesn't know which field is the primary key for conflict resolution
**How to avoid:** Annotate ID field with `@Supabase(unique: true)` to mark it as primary key
**Warning signs:**
- Stories duplicated in cache after sync
- Deleting a story doesn't remove it from SQLite
- Upsert creates new record instead of updating existing

### Pitfall 3: Column Name Mismatch (snake_case vs camelCase)
**What goes wrong:** Fields come back null or serialization fails with "Unknown column" error
**Why it happens:** Supabase uses snake_case (image_url), Dart uses camelCase (imageUrl)
**How to avoid:** Use `@Supabase(name: 'snake_case_name')` for fields that don't auto-convert, or configure `fieldRename` in SupabaseSerializable
**Warning signs:**
- Fields populated in Supabase but null in app
- Build runner generates adapters but queries fail
- Error: "column 'imageUrl' does not exist"

### Pitfall 4: Nested Models Without Separate Table
**What goes wrong:** StoryAttributes stored as JSON blob instead of normalized table, breaks querying
**Why it happens:** Not creating separate Brick model for nested objects
**How to avoid:** Create StoryAttributesModel extending OfflineFirstWithSupabaseModel with its own table
**Warning signs:**
- Can't query by story theme or type (nested fields)
- Attributes come back as Map<String, dynamic> instead of typed object
- Updates to attributes don't sync properly

### Pitfall 5: Unbounded Cache Growth
**What goes wrong:** SQLite database grows to hundreds of MB, slows down app, fills device storage
**Why it happens:** Brick has no built-in cache size limits, every fetched story stays cached forever
**How to avoid:** Implement manual LRU eviction based on story count or storage size
**Warning signs:**
- App becomes sluggish after weeks of use
- Users report "storage full" warnings
- SQLite queries take seconds instead of milliseconds

### Pitfall 6: Wrong Query Policy for Use Case
**What goes wrong:** Story lists always wait for network (slow) or never refresh (stale)
**Why it happens:** Using `awaitRemote` for lists (should be `alwaysHydrate`) or `localOnly` when data may be missing
**How to avoid:** Use `alwaysHydrate` for feeds/lists (show cached, refresh background), `awaitRemoteWhenNoneExist` for details (fetch if not cached)
**Warning signs:**
- Story list shows blank screen while loading (should show cached instantly)
- Opened story shows outdated content even when online
- Offline mode shows "no data" instead of cached stories

## Code Examples

Verified patterns from official sources:

### Complete Story Model with All Annotations
```dart
// lib/features/stories/data/models/story.model.dart
// Source: https://github.com/GetDutchie/brick/tree/main/packages/brick_offline_first_with_supabase
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import '../../domain/entities/story.dart';
import 'story_attributes.model.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'stories'),
  sqliteConfig: SqliteSerializable(),
)
class StoryModel extends OfflineFirstWithSupabaseModel {
  // Primary key - MUST have unique annotation
  @Supabase(unique: true)
  final String id;

  final String title;
  final String scripture;
  final String story;
  final String quotes;
  final String trivia;
  final String activity;
  final String lesson;

  // Nested model - foreign key relationship
  @Supabase(foreignKey: 'attributes_id')
  final StoryAttributesModel attributes;

  // Column name differs from field name
  @Supabase(name: 'image_url')
  final String? imageUrl;

  final String? author;

  // Supabase snake_case auto-converts to camelCase
  final DateTime? publishedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final int likes;
  final int views;

  // Local-only field, not in Supabase
  @Supabase(ignore: true)
  @Sqlite()
  final bool isFavorite;

  // Foreign key to users table
  @Supabase(foreignKey: 'author_id')
  final String? authorId;

  // Computed getter, not persisted
  @Sqlite(ignore: true)
  String get displayAuthor => author ?? 'Anonymous';

  StoryModel({
    required this.id,
    required this.title,
    required this.scripture,
    required this.story,
    required this.quotes,
    required this.trivia,
    required this.activity,
    required this.lesson,
    required this.attributes,
    this.imageUrl,
    this.author,
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
    this.likes = 0,
    this.views = 0,
    this.isFavorite = false,
    this.authorId,
  });

  Story toDomain() {
    return Story(
      id: id,
      title: title,
      scripture: scripture,
      story: story,
      quotes: quotes,
      trivia: trivia,
      activity: activity,
      lesson: lesson,
      attributes: attributes.toDomain(),
      imageUrl: imageUrl,
      author: author,
      publishedAt: publishedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      likes: likes,
      views: views,
      isFavorite: isFavorite,
      authorId: authorId,
    );
  }
}
```

### StoryAttributes Nested Model
```dart
// lib/features/stories/data/models/story_attributes.model.dart
// Source: https://github.com/GetDutchie/brick/tree/main/packages/brick_offline_first_with_supabase
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import '../../domain/entities/story.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'story_attributes'),
  sqliteConfig: SqliteSerializable(),
)
class StoryAttributesModel extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  final String id;

  @Supabase(name: 'story_type')
  final String storyType;

  final String theme;

  @Supabase(name: 'main_character_type')
  final String mainCharacterType;

  @Supabase(name: 'story_setting')
  final String storySetting;

  @Supabase(name: 'time_era')
  final String timeEra;

  @Supabase(name: 'narrative_perspective')
  final String narrativePerspective;

  @Supabase(name: 'language_style')
  final String languageStyle;

  @Supabase(name: 'emotional_tone')
  final String emotionalTone;

  @Supabase(name: 'narrative_style')
  final String narrativeStyle;

  @Supabase(name: 'plot_structure')
  final String plotStructure;

  @Supabase(name: 'story_length')
  final String storyLength;

  // Arrays stored as JSON in Supabase
  final List<String> references;
  final List<String> tags;

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
  });

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
    );
  }
}
```

### Repository Implementation Pattern
```dart
// lib/features/stories/data/repositories/story_repository_impl.dart
// Source: Existing pattern + Brick integration
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:myitihas/repository/my_itihas_repository.dart';
import '../../domain/entities/story.dart';
import '../../domain/repositories/story_repository.dart';
import '../models/story.model.dart';

@LazySingleton(as: StoryRepository)
class StoryRepositoryImpl implements StoryRepository {
  final MyItihasRepository repository;

  StoryRepositoryImpl({required this.repository});

  @override
  Future<Either<Failure, List<Story>>> getStories({
    String? searchQuery,
    String? sortBy,
    String? filterByType,
    String? filterByTheme,
    int? limit,
    int? offset,
  }) async {
    try {
      // Build Brick query
      Query query = Query();

      // Add search filter
      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = Query.where('title', searchQuery, compare: Compare.contains);
      }

      // Add type filter
      if (filterByType != null) {
        query = query.where('attributes',
          Where.exact('storyType', filterByType));
      }

      // Fetch with alwaysHydrate: show cached, refresh in background
      final models = await repository.get<StoryModel>(
        policy: OfflineFirstGetPolicy.alwaysHydrate,
        query: query,
      );

      // Apply sorting (SQLite doesn't support ORDER BY in Query yet)
      var sorted = models;
      if (sortBy == 'newest') {
        sorted.sort((a, b) => (b.publishedAt ?? DateTime(2000))
            .compareTo(a.publishedAt ?? DateTime(2000)));
      } else if (sortBy == 'popular') {
        sorted.sort((a, b) => b.likes.compareTo(a.likes));
      }

      // Apply pagination
      if (offset != null && limit != null) {
        final start = offset.clamp(0, sorted.length);
        final end = (offset + limit).clamp(0, sorted.length);
        sorted = sorted.sublist(start, end);
      }

      return Right(sorted.map((m) => m.toDomain()).toList());
    } on BrickException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Story>> getStoryById(String id) async {
    try {
      // Fetch if not cached, use cache otherwise
      final models = await repository.get<StoryModel>(
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
        query: Query.where('id', id),
      );

      if (models.isEmpty) {
        return const Left(NotFoundFailure('Story not found'));
      }

      return Right(models.first.toDomain());
    } on BrickException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(String storyId) async {
    try {
      // Get current story
      final models = await repository.get<StoryModel>(
        policy: OfflineFirstGetPolicy.localOnly,
        query: Query.where('id', storyId),
      );

      if (models.isEmpty) {
        return const Left(NotFoundFailure('Story not found'));
      }

      final story = models.first;

      // Update favorite status (local only, no Supabase sync)
      final updated = StoryModel(
        id: story.id,
        title: story.title,
        scripture: story.scripture,
        story: story.story,
        quotes: story.quotes,
        trivia: story.trivia,
        activity: story.activity,
        lesson: story.lesson,
        attributes: story.attributes,
        imageUrl: story.imageUrl,
        author: story.author,
        publishedAt: story.publishedAt,
        likes: story.likes,
        views: story.views,
        isFavorite: !story.isFavorite,  // Toggle
        authorId: story.authorId,
      );

      await repository.upsert<StoryModel>(
        updated,
        policy: OfflineFirstUpsertPolicy.optimisticLocal,
      );

      return const Right(null);
    } on BrickException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
```

### Realtime Sync Service
```dart
// lib/features/stories/data/services/story_sync_service.dart
// Source: https://supabase.com/docs/reference/dart/subscribe
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myitihas/repository/my_itihas_repository.dart';
import '../models/story.model.dart';

@lazySingleton
class StorySyncService {
  final MyItihasRepository repository;
  final SupabaseClient supabase;

  StorySyncService({
    required this.repository,
    required this.supabase,
  });

  void startRealtimeSync() {
    // Listen to story table changes
    supabase.channel('stories_realtime')
      .onPostgresChanges(
        postgresChangeFilter: PostgresChangeFilter(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'stories',
        ),
        (payload, [ref]) async {
          final eventType = payload.eventType;

          if (eventType == PostgresChangeEvent.insert ||
              eventType == PostgresChangeEvent.update) {
            // Upsert to cache
            final storyData = payload.newRecord;
            final model = StoryModel.fromJson(storyData);
            await repository.upsert<StoryModel>(model);

            talker.info('Story ${eventType.name}: ${model.title}');
          } else if (eventType == PostgresChangeEvent.delete) {
            // Remove from cache
            final storyId = payload.oldRecord['id'] as String;
            await repository.delete<StoryModel>(
              Query.where('id', storyId),
            );

            talker.info('Story deleted from cache: $storyId');
          }
        },
      )
      .subscribe();
  }
}
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Hive @HiveType models | Brick @ConnectOfflineFirstWithSupabase | Brick 2.1.0 (2024) | Native Supabase integration, automatic sync, realtime subscriptions |
| Manual Supabase client calls | repository.get<T>() with policies | Brick offline-first pattern | Automatic offline-first with configurable behavior |
| if/else network checks | OfflineFirstGetPolicy enum | Brick 1.0 (2020) | Declarative policies replace imperative network checks |
| Manual fromJson/toJson | Code-generated adapters | Current | Eliminates serialization bugs, handles nested models |
| Local storage only or remote only | SQLite-first with background sync | Current | Best of both worlds: instant load + fresh data |

**Deprecated/outdated:**
- **Hive models with @HiveType**: Phase 1 decision to migrate to Brick, Hive will be removed in Phase 8
- **Manual network connectivity checks in repository**: Replaced by Brick policies
- **Separate local and remote datasources**: Unified in MyItihasRepository

## Open Questions

Things that couldn't be fully resolved:

1. **How to handle StoryAttributes association in existing schema?**
   - What we know: Domain entity has `attributes: StoryAttributes` field, current Hive model has `StoryAttributesModel`
   - What's unclear: Does Supabase have separate `story_attributes` table, or is it embedded JSON in `stories` table?
   - Recommendation: Check Supabase schema. If separate table with FK, create StoryAttributesModel extending OfflineFirstWithSupabaseModel. If embedded JSON, use `@Supabase(name: 'attributes')` with Dart object serialization.

2. **What is appropriate cache size limit for story metadata?**
   - What we know: User decided "Claude decides appropriate size", recommendation is size-based limit
   - What's unclear: Average story size in bytes, typical user behavior (how many stories viewed)
   - Recommendation: 50MB cache limit or 1000 stories, whichever reached first. Text/metadata only (no images), should accommodate ~3-6 months of casual usage.

3. **Should we cache related entities (User for authorUser field)?**
   - What we know: Story entity has `authorUser?: User` field for author profile
   - What's unclear: Whether User model migration is in Phase 2 or Phase 4 (Social)
   - Recommendation: Use `@Supabase(foreignKey: 'author_id')` with `String? authorId` for now, add User model association in Phase 4 when User.model.dart is created.

4. **How to handle translations (TranslatedStory in attributes)?**
   - What we know: StoryAttributes has `translations: Map<String, TranslatedStory>` field
   - What's unclear: Supabase storage format for translations (JSON column, separate table?)
   - Recommendation: If JSON column, Brick can serialize Map directly. If separate table, defer to Phase 3 (Story Generator has translation feature).

## Sources

### Primary (HIGH confidence)
- GitHub GetDutchie/Brick - Official Brick offline-first with Supabase package
  - README: https://github.com/GetDutchie/brick/tree/main/packages/brick_offline_first_with_supabase
  - Model annotations: https://github.com/GetDutchie/brick/tree/main/packages/brick_supabase
- Supabase Flutter Documentation (Context7: /websites/supabase_reference_dart)
  - Realtime subscriptions: .stream() and .onPostgresChanges()
  - Query filters: eq, neq, inFilter, etc.
- pub.dev API Documentation
  - OfflineFirstGetPolicy: https://pub.dev/documentation/brick_offline_first/latest/brick_offline_first/OfflineFirstGetPolicy.html
  - OfflineFirstUpsertPolicy: https://pub.dev/documentation/brick_offline_first/latest/brick_offline_first/OfflineFirstUpsertPolicy.html

### Secondary (MEDIUM confidence)
- Phase 1 research findings (.planning/phases/01-core-infrastructure/01-RESEARCH.md)
  - MyItihasRepository patterns
  - Initialization order and DI registration
- Existing MyItihas codebase
  - Story entity structure (lib/features/stories/domain/entities/story.dart)
  - Current Hive model (lib/features/stories/data/models/story_model.dart)
  - Repository interface (lib/features/stories/domain/repositories/story_repository.dart)

### Tertiary (LOW confidence)
- None - all findings verified with official documentation

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - Using packages from Phase 1, no new dependencies
- Architecture: HIGH - Verified Brick patterns from official docs, aligned with existing Clean Architecture
- Pitfalls: MEDIUM - Based on official docs and Phase 1 learnings, some edge cases may be project-specific
- Cache management: MEDIUM - Manual LRU implementation required (no official Brick pattern), size limits are estimates

**Research date:** 2026-01-29
**Valid until:** 2026-02-28 (30 days - stable packages, established patterns)
