import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_core/query.dart';
import 'package:sqflite/sqflite.dart' show databaseFactory;
import 'package:supabase_flutter/supabase_flutter.dart';

// Import generated brick code
import 'package:myitihas/brick/brick.g.dart';
import 'package:myitihas/brick/db/schema.g.dart';

/// MyItihas repository extending Brick's offline-first with Supabase support.
///
/// This repository provides SQLite-first queries with automatic Supabase sync
/// and an offline request queue for network operations.
///
/// Initialize once in main.dart before runApp() using configure().
/// Access singleton instance via MyItihasRepository.instance.
class MyItihasRepository extends OfflineFirstWithSupabaseRepository {
  static late MyItihasRepository _singleton;

  MyItihasRepository._({
    required super.supabaseProvider,
    required super.sqliteProvider,
    required super.migrations,
    required super.offlineRequestQueue,
  });

  /// Configure the repository singleton with Supabase credentials.
  ///
  /// Must be called once in main.dart AFTER initHive() and BEFORE configureDependencies().
  ///
  /// Example:
  /// ```dart
  /// MyItihasRepository.configure(
  ///   supabaseUrl: 'https://your-project.supabase.co',
  ///   supabaseAnonKey: 'your-anon-key',
  /// );
  /// ```
  static void configure({
    required String supabaseUrl,
    required String supabaseAnonKey,
  }) {
    // clientQueue helper creates HTTP client + offline queue
    // ignorePaths prevents auth/storage/functions from being queued for retry
    final (client, queue) = OfflineFirstWithSupabaseRepository.clientQueue(
      databaseFactory: databaseFactory,
      ignorePaths: {
        '/auth/v1',      // Don't retry auth requests
        '/storage/v1',   // Don't retry file uploads/downloads
        '/functions/v1', // Don't retry edge functions (story generation)
      },
    );

    _singleton = MyItihasRepository._(
      supabaseProvider: SupabaseProvider(
        SupabaseClient(supabaseUrl, supabaseAnonKey, httpClient: client),
        modelDictionary: supabaseModelDictionary,
      ),
      sqliteProvider: SqliteProvider(
        'myitihas.sqlite', // Database filename
        databaseFactory: databaseFactory,
        modelDictionary: sqliteModelDictionary,
      ),
      migrations: migrations,
      offlineRequestQueue: queue,
    );
  }

  /// Access the configured repository singleton.
  ///
  /// Throws LateInitializationError if configure() was not called.
  static MyItihasRepository get instance => _singleton;

  /// Fetch data directly from Supabase, bypassing SQLite cache.
  ///
  /// Use this for fields that are not stored in SQLite (e.g., large imageUrl).
  /// Falls back to SQLite if Supabase fetch fails.
  Future<List<TModel>> getFromRemote<TModel extends OfflineFirstWithSupabaseModel>({
    Query? query,
  }) async {
    try {
      return await remoteProvider.get<TModel>(query: query, repository: this);
    } catch (e) {
      // Fall back to local cache if remote fails
      return await sqliteProvider.get<TModel>(query: query, repository: this);
    }
  }

  /// Clear all pending requests from the offline queue.
  ///
  /// Use this to remove stuck requests that are failing repeatedly.
  Future<void> clearOfflineQueue() async {
    final requests = await offlineRequestQueue.client.requestManager.unprocessedRequests();
    for (final request in requests) {
      final id = request['id'] as int?;
      if (id != null) {
        await offlineRequestQueue.client.requestManager.deleteUnprocessedRequest(id);
      }
    }
  }
}
