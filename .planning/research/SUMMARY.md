# Research Summary: Brick Offline-First with Supabase

**Research Date:** 2026-01-28
**Package:** `brick_offline_first_with_supabase: ^2.1.0`
**Source:** [GetDutchie/Brick](https://github.com/GetDutchie/brick)

## Executive Summary

Brick is an extensible query interface for Dart that provides offline-first capabilities with automatic sync. The `brick_offline_first_with_supabase` package specifically integrates with Supabase, providing:

- **SQLite-first data access** — Queries hit local SQLite before Supabase
- **Offline request queue** — Failed requests cached and retried when online
- **Realtime subscriptions** — Automatic updates via Supabase Realtime
- **Code generation** — Models annotated and adapters auto-generated

## Core Architecture

### Repository Pattern
```dart
class MyRepository extends OfflineFirstWithSupabaseRepository {
  // Singleton pattern
  static late MyRepository? _singleton;

  static void configure({
    required String supabaseUrl,
    required String supabaseAnonKey,
  }) {
    final (client, queue) = OfflineFirstWithSupabaseRepository.clientQueue(
      databaseFactory: databaseFactory,
    );

    _singleton = MyRepository._(
      supabaseProvider: SupabaseProvider(
        SupabaseClient(supabaseUrl, supabaseAnonKey, httpClient: client),
        modelDictionary: supabaseModelDictionary,
      ),
      sqliteProvider: SqliteProvider(
        'my_repository.sqlite',
        databaseFactory: databaseFactory,
        modelDictionary: sqliteModelDictionary,
      ),
      migrations: migrations,
      offlineRequestQueue: queue,
    );
  }
}
```

### Model Annotations
```dart
@ConnectOfflineFirstWithSupabase(
  sqliteConfig: SqliteSerializable(nullable: false),
  supabaseConfig: SupabaseSerializable(tableName: 'users'),
)
class User extends OfflineFirstWithSupabaseModel {
  final String id;
  final String name;

  @Supabase(foreignKey: 'address_id')
  final Address address;

  @Supabase(enumAsString: true)
  final UserStatus status;
}
```

### Realtime Subscriptions
```dart
// Subscribe to all changes
final stream = repository.subscribeToRealtime<Customer>();

// Subscribe with filter
final stream = repository.subscribeToRealtime<Customer>(
  query: Query.where('id', 1),
);

// Use and cleanup
final subscription = stream.listen((value) => ...);
await subscription.cancel();
```

## Key Considerations for MyItihas Migration

### 1. Model Migration
- All Hive models must be rewritten as Brick models
- Use `@ConnectOfflineFirstWithSupabase` annotation
- Models must extend `OfflineFirstWithSupabaseModel`
- File suffix must be `.model.dart`

### 2. Offline Queue Behavior
By default, queue **does not** cache:
- Auth requests (`/auth/v1`)
- Storage requests (`/storage/v1`)
- Edge Functions (`/functions/v1`)

**Implication:** Media upload/download and story generation (Edge Function) won't queue. This aligns with user decision to disable actions when offline.

### 3. Associations
- Use `@Supabase(foreignKey: 'column_name')` for relationships
- Nullable associations can cause over-fetching (returns all results)
- Recursion limited to 2 levels to prevent stack overflow

### 4. Code Generation
```bash
dart run build_runner build --delete-conflicting-outputs
```
Generates:
- `brick.g.dart` — Model dictionaries
- `db/schema.g.dart` — SQLite migrations
- `adapters/*` — Serialization adapters

### 5. Primary Keys
- Use `@Supabase(unique: true)` for primary key fields
- Required for upsert/delete operations

## Migration Strategy for MyItihas

### Phase 1: Core Setup
1. Add `brick_offline_first_with_supabase: ^2.1.0`
2. Configure `MyItihasRepository` singleton
3. Set up SQLite database factory
4. Configure offline queue (ignore auth/storage/functions paths)

### Phase 2: Model Migration (per feature)
For each Hive model:
1. Create Brick model with `.model.dart` suffix
2. Add `@ConnectOfflineFirstWithSupabase` annotation
3. Map fields to Supabase columns
4. Configure associations with `@Supabase(foreignKey: ...)`
5. Run build_runner

### Phase 3: Repository Layer
1. Replace Hive datasources with Brick repository calls
2. Update domain repositories to use Brick
3. Preserve Clean Architecture boundaries

### Phase 4: Realtime Integration
1. Replace existing Supabase Realtime channels
2. Use `subscribeToRealtime<Model>()` pattern
3. Manage subscription lifecycle in BLoCs

### Phase 5: Cleanup
1. Remove Hive packages
2. Remove Hive boxes and adapters
3. Clear local Hive data on first launch

## Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| Large migration scope | Phase by feature, start with Stories |
| Realtime can get expensive | Use query filters to limit subscriptions |
| Nullable associations over-fetch | Use non-nullable where possible |
| Generated code conflicts | Use --delete-conflicting-outputs |
| Media not cached | Separate image caching (cached_network_image) |

## Dependencies

```yaml
dependencies:
  brick_offline_first_with_supabase: ^2.1.0
  sqflite: ^2.4.2  # Already in project

dev_dependencies:
  brick_offline_first_with_supabase_build: ^2.1.0
  build_runner: ^2.10.4  # Already in project
```

## File Structure

```
lib/
├── brick/
│   ├── brick.g.dart              # Generated
│   ├── db/
│   │   └── schema.g.dart         # Generated migrations
│   └── adapters/                  # Generated adapters
├── models/                        # Brick models
│   ├── story.model.dart
│   ├── user.model.dart
│   └── ...
└── repository/
    └── my_itihas_repository.dart  # Main Brick repository
```

---

*Research complete: 2026-01-28*
