# Phase 4: Social Feed Feature - Research

**Researched:** 2026-01-29
**Domain:** Brick offline-first social feed with Supabase posts, users, and realtime sync
**Confidence:** HIGH

## Summary

Phase 4 extends the Brick offline-first architecture to social feed entities: posts (text, image, video), users, likes, comments, and shares. The core challenge is caching heterogeneous feed items (stories + posts) with engagement counts while maintaining network-first behavior with graceful offline fallback.

The existing implementation uses PostService with direct Supabase calls. This phase replaces those calls with Brick models that cache feed data locally. Key architectural decisions: (1) cache posts and author profiles only, not comments/likes (load on demand when online), (2) engagement counts (likes_count, comments_count, shares_count) are cached as part of post data, not computed from joins, (3) Brick's `subscribeToRealtime<T>()` method handles live updates automatically when tables broadcast changes.

The standard pattern follows Phase 2/3: create `.model.dart` files extending `OfflineFirstWithSupabaseModel`, map to existing `posts` and `profiles` tables, use `alwaysHydrate` policy for feed queries (show cache immediately, refresh in background), and use `subscribeToRealtime<PostModel>()` for live feed updates. Write actions (like/comment/share) require network and show error snackbar when offline.

**Primary recommendation:** Create ImagePost.model.dart, TextPost.model.dart, VideoPost.model.dart, and User.model.dart with `@ConnectOfflineFirstWithSupabase` annotations. Map engagement counts as integer fields (not associations). Use `alwaysHydrate` for getAllFeedItems() to enable instant load from cache. Subscribe to posts table realtime for auto-insert of new posts. Disable write actions offline with snackbar error.

## Standard Stack

The established libraries/tools for offline-first social feeds with Brick:

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| brick_offline_first_with_supabase | ^2.1.0 | Model annotations and adapters | Already installed, handles post/user caching with Supabase sync |
| brick_offline_first_with_supabase_build | ^2.1.0 | Code generator for adapters | Already installed, generates SQLite schema from annotations |
| internet_connection_checker_plus | ^2.5.4 | Connectivity monitoring | Already installed in Phase 3, used for offline error detection |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| supabase_flutter | ^2.5.6 | Realtime subscriptions | Already installed, use .stream() or subscribeToRealtime() for feed updates |
| fpdart | ^1.1.0 | Either monad for error handling | Already in project, repository methods return Either<Failure, T> |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Brick subscribeToRealtime | Manual Supabase .onPostgresChanges | subscribeToRealtime auto-upserts to cache, manual requires boilerplate |
| Cached engagement counts | Compute from likes/comments tables | Counts as fields = instant load, joins = slow queries and complex cache invalidation |
| Network-first policy | Cache-first with background sync | User decision: try server first, prevents stale feed on app open |

**Installation:**
Already completed in Phase 1. No new packages required.

## Architecture Patterns

### Recommended Project Structure
```
lib/features/social/
├── domain/
│   ├── entities/
│   │   ├── image_post.dart         # Existing pure Dart entity
│   │   ├── text_post.dart          # Existing
│   │   ├── video_post.dart         # Existing
│   │   ├── user.dart               # Existing
│   │   ├── like.dart               # Existing (load on demand)
│   │   ├── comment.dart            # Existing (load on demand)
│   │   └── share.dart              # Existing (load on demand)
│   └── repositories/
│       ├── post_repository.dart    # Interface (no change)
│       └── user_repository.dart    # Interface (no change)
├── data/
│   ├── models/
│   │   ├── image_post.model.dart   # NEW: Brick model for image posts
│   │   ├── text_post.model.dart    # NEW: Brick model for text posts
│   │   ├── video_post.model.dart   # NEW: Brick model for video posts
│   │   └── user.model.dart         # MODIFY: Add @ConnectOfflineFirstWithSupabase
│   └── repositories/
│       ├── post_repository_impl.dart  # MODIFY: Use repository.get<PostModel>()
│       └── user_repository_impl.dart  # MODIFY: Use repository.get<UserModel>()
└── presentation/
    └── bloc/
        └── feed_bloc.dart          # MODIFY: Add realtime subscription management
```

### Pattern 1: Post Model with Engagement Counts
**What:** Brick model with engagement counts cached as integer fields
**When to use:** For all post types that appear in feed
**Example:**
```dart
// lib/features/social/data/models/image_post.model.dart
// Source: Phase 2 research + existing PostService schema
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import '../../domain/entities/image_post.dart';
import 'user.model.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'posts'),
  sqliteConfig: SqliteSerializable(),
)
class ImagePostModel extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  final String id;

  @Supabase(name: 'image_url')
  final String imageUrl;

  final String? caption;
  final String? location;

  @Supabase(name: 'aspect_ratio', defaultValue: 1.0)
  final double aspectRatio;

  @Supabase(name: 'created_at')
  final DateTime? createdAt;

  // Foreign key to profiles table
  @Supabase(foreignKey: 'author_id')
  final UserModel? author;

  // Engagement counts - cached as integers, NOT computed
  @Supabase(name: 'likes_count', defaultValue: 0)
  final int likes;

  @Supabase(name: 'comments_count', defaultValue: 0)
  final int commentCount;

  @Supabase(name: 'shares_count', defaultValue: 0)
  final int shareCount;

  // Local-only fields (not in Supabase)
  @Supabase(ignore: true)
  @Sqlite()
  final bool isLikedByCurrentUser;

  @Supabase(ignore: true)
  @Sqlite()
  final bool isFavorite;

  // Metadata stored as JSONB
  @Supabase(name: 'metadata')
  final Map<String, dynamic>? metadata;

  ImagePostModel({
    required this.id,
    required this.imageUrl,
    this.caption,
    this.location,
    this.aspectRatio = 1.0,
    this.createdAt,
    this.author,
    this.likes = 0,
    this.commentCount = 0,
    this.shareCount = 0,
    this.isLikedByCurrentUser = false,
    this.isFavorite = false,
    this.metadata,
  });

  ImagePost toDomain() {
    // Extract tags from metadata
    final tags = (metadata?['tags'] as List?)?.cast<String>() ?? <String>[];

    return ImagePost(
      id: id,
      imageUrl: imageUrl,
      caption: caption,
      location: location,
      aspectRatio: aspectRatio,
      createdAt: createdAt,
      authorId: author?.id,
      authorUser: author?.toDomain(),
      likes: likes,
      commentCount: commentCount,
      shareCount: shareCount,
      isLikedByCurrentUser: isLikedByCurrentUser,
      isFavorite: isFavorite,
      tags: tags,
    );
  }

  factory ImagePostModel.fromDomain(ImagePost post) {
    return ImagePostModel(
      id: post.id,
      imageUrl: post.imageUrl,
      caption: post.caption,
      location: post.location,
      aspectRatio: post.aspectRatio,
      createdAt: post.createdAt,
      author: post.authorUser != null
        ? UserModel.fromDomain(post.authorUser!)
        : null,
      likes: post.likes,
      commentCount: post.commentCount,
      shareCount: post.shareCount,
      isLikedByCurrentUser: post.isLikedByCurrentUser,
      isFavorite: post.isFavorite,
      metadata: {'tags': post.tags},
    );
  }
}
```

### Pattern 2: User Model for Author Profiles
**What:** User model cached with posts for offline profile display
**When to use:** Author profiles in feed items, accessed via foreign key
**Example:**
```dart
// lib/features/social/data/models/user.model.dart
// Source: Phase 2 patterns + existing UserModel structure
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import '../../domain/entities/user.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'profiles'),
  sqliteConfig: SqliteSerializable(),
)
class UserModel extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  final String id;

  final String username;

  @Supabase(name: 'full_name')
  final String displayName;

  @Supabase(name: 'avatar_url')
  final String avatarUrl;

  final String bio;

  @Supabase(name: 'follower_count', defaultValue: 0)
  final int followerCount;

  @Supabase(name: 'following_count', defaultValue: 0)
  final int followingCount;

  // Local-only fields
  @Supabase(ignore: true)
  @Sqlite()
  final bool isFollowing;

  @Supabase(ignore: true)
  @Sqlite()
  final bool isCurrentUser;

  @Supabase(ignore: true)
  @Sqlite()
  final List<String> savedStories;

  UserModel({
    required this.id,
    required this.username,
    required this.displayName,
    required this.avatarUrl,
    required this.bio,
    this.followerCount = 0,
    this.followingCount = 0,
    this.isFollowing = false,
    this.isCurrentUser = false,
    this.savedStories = const <String>[],
  });

  User toDomain() {
    return User(
      id: id,
      username: username,
      displayName: displayName,
      avatarUrl: avatarUrl,
      bio: bio,
      followerCount: followerCount,
      followingCount: followingCount,
      isFollowing: isFollowing,
      isCurrentUser: isCurrentUser,
      savedStories: savedStories,
    );
  }

  factory UserModel.fromDomain(User user) {
    return UserModel(
      id: user.id,
      username: user.username,
      displayName: user.displayName,
      avatarUrl: user.avatarUrl,
      bio: user.bio,
      followerCount: user.followerCount,
      followingCount: user.followingCount,
      isFollowing: user.isFollowing,
      isCurrentUser: user.isCurrentUser,
      savedStories: user.savedStories,
    );
  }
}
```

### Pattern 3: Feed Repository with Network-First Policy
**What:** Replace PostService calls with repository.get<T>() using alwaysHydrate
**When to use:** In PostRepositoryImpl.getAllFeedItems()
**Example:**
```dart
// lib/features/social/data/repositories/post_repository_impl.dart
// Source: Phase 2 repository patterns + existing PostRepositoryImpl
@LazySingleton(as: PostRepository)
class PostRepositoryImpl implements PostRepository {
  final MyItihasRepository repository;
  final StoryRepository storyRepository;

  PostRepositoryImpl({
    required this.repository,
    required this.storyRepository,
  });

  @override
  Future<Either<Failure, List<FeedItem>>> getAllFeedItems({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      // Get cached stories from StoryRepository (already using Brick)
      final storiesResult = await storyRepository.getStories(
        limit: limit,
        offset: offset,
      );

      final storyItems = storiesResult.fold(
        (failure) => <FeedItem>[],
        (stories) => stories.map((s) => FeedItem.story(s)).toList(),
      );

      // Get posts from Brick cache with network-first policy
      final imagePosts = await repository.get<ImagePostModel>(
        policy: OfflineFirstGetPolicy.alwaysHydrate,  // Network first, cache fallback
        query: Query()
          .orderBy('created_at', descending: true)
          .offset(offset)
          .limit(limit),
      );

      final textPosts = await repository.get<TextPostModel>(
        policy: OfflineFirstGetPolicy.alwaysHydrate,
        query: Query()
          .orderBy('created_at', descending: true)
          .offset(offset)
          .limit(limit),
      );

      final videoPosts = await repository.get<VideoPostModel>(
        policy: OfflineFirstGetPolicy.alwaysHydrate,
        query: Query()
          .orderBy('created_at', descending: true)
          .offset(offset)
          .limit(limit),
      );

      // Convert to feed items
      final postItems = <FeedItem>[
        ...imagePosts.map((p) => FeedItem.imagePost(p.toDomain())),
        ...textPosts.map((p) => FeedItem.textPost(p.toDomain())),
        ...videoPosts.map((p) => FeedItem.videoPost(p.toDomain())),
      ];

      // Combine and sort by creation date
      final allItems = [...storyItems, ...postItems];
      allItems.sort((a, b) {
        final aDate = a.createdAt ?? DateTime(2000);
        final bDate = b.createdAt ?? DateTime(2000);
        return bDate.compareTo(aDate);
      });

      // Apply limit to combined results
      final paginatedItems = allItems.skip(offset).take(limit).toList();

      return Right(paginatedItems);
    } on BrickException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
```

### Pattern 4: Realtime Feed Subscription with Auto-Upsert
**What:** Use subscribeToRealtime<T>() to listen for new posts and auto-insert into cache
**When to use:** In FeedBloc initialization for live feed updates
**Example:**
```dart
// lib/features/social/presentation/bloc/feed_bloc.dart
// Source: GitHub Brick subscribeToRealtime docs + existing FeedBloc
@injectable
class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final PostRepository postRepository;
  final MyItihasRepository brickRepository;

  StreamSubscription<List<ImagePostModel>>? _imagePostSubscription;
  StreamSubscription<List<TextPostModel>>? _textPostSubscription;
  StreamSubscription<List<VideoPostModel>>? _videoPostSubscription;

  FeedBloc({
    required this.postRepository,
    required this.brickRepository,
  }) : super(const FeedState.initial()) {
    on<LoadFeedEvent>(_onLoadFeed);
    on<RealtimePostReceivedEvent>(_onRealtimePost);

    _startRealtimeSubscriptions();
  }

  void _startRealtimeSubscriptions() {
    // Subscribe to image posts
    _imagePostSubscription = brickRepository
      .subscribeToRealtime<ImagePostModel>()
      .listen((posts) {
        if (posts.isNotEmpty) {
          add(FeedEvent.realtimePostReceived(
            FeedItem.imagePost(posts.first.toDomain())
          ));
        }
      });

    // Subscribe to text posts
    _textPostSubscription = brickRepository
      .subscribeToRealtime<TextPostModel>()
      .listen((posts) {
        if (posts.isNotEmpty) {
          add(FeedEvent.realtimePostReceived(
            FeedItem.textPost(posts.first.toDomain())
          ));
        }
      });

    // Subscribe to video posts
    _videoPostSubscription = brickRepository
      .subscribeToRealtime<VideoPostModel>()
      .listen((posts) {
        if (posts.isNotEmpty) {
          add(FeedEvent.realtimePostReceived(
            FeedItem.videoPost(posts.first.toDomain())
          ));
        }
      });
  }

  Future<void> _onRealtimePost(
    RealtimePostReceivedEvent event,
    Emitter<FeedState> emit,
  ) async {
    final currentState = state;
    if (currentState is! FeedLoaded) return;

    // Insert new post at top of feed
    final updatedItems = [event.post, ...currentState.feedItems];

    emit(currentState.copyWith(feedItems: updatedItems));
  }

  @override
  Future<void> close() {
    _imagePostSubscription?.cancel();
    _textPostSubscription?.cancel();
    _videoPostSubscription?.cancel();
    return super.close();
  }
}
```

### Pattern 5: Offline Write Error with Snackbar
**What:** Check connectivity before write actions, show error snackbar when offline
**When to use:** Like, comment, share actions in FeedBloc
**Example:**
```dart
// lib/features/social/presentation/bloc/feed_bloc.dart
// Source: Phase 3 offline error pattern + existing FeedBloc
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

@injectable
class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final PostRepository postRepository;
  final InternetConnection internetConnection;

  FeedBloc({
    required this.postRepository,
    required this.internetConnection,
  }) : super(const FeedState.initial()) {
    on<ToggleLikeEvent>(_onToggleLike);
    on<AddCommentEvent>(_onAddComment);
  }

  Future<void> _onToggleLike(
    ToggleLikeEvent event,
    Emitter<FeedState> emit,
  ) async {
    // Check connectivity
    final isOnline = await internetConnection.hasInternetAccess;
    if (!isOnline) {
      // Emit error state with offline flag
      final currentState = state;
      if (currentState is FeedLoaded) {
        emit(currentState.copyWith(
          error: 'No internet connection. Try again later.',
          isOfflineError: true,
        ));
      }
      return;
    }

    // Proceed with like/unlike
    final currentState = state;
    if (currentState is! FeedLoaded) return;

    // Optimistic UI update
    final updatedItems = currentState.feedItems.map((item) {
      if (item.id == event.contentId) {
        return item.toggleLike();
      }
      return item;
    }).toList();

    emit(currentState.copyWith(feedItems: updatedItems));

    // Call repository
    if (event.contentType == ContentType.story) {
      // Story likes handled by existing SocialRepository
    } else {
      // Post likes
      await postRepository.likeContent(
        contentId: event.contentId,
        contentType: event.contentType,
      );
    }
  }
}

// In UI layer (feed_page.dart)
BlocListener<FeedBloc, FeedState>(
  listener: (context, state) {
    if (state is FeedLoaded && state.error != null && state.isOfflineError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.error!),
          backgroundColor: context.colorScheme.error,
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: context.colorScheme.onError,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  },
  child: // ... feed UI
)
```

### Anti-Patterns to Avoid
- **Caching likes/comments as separate Brick models:** Comments and likes load on demand when online. Don't cache - too many records, complex sync.
- **Computing engagement counts from joins:** Counts should be cached integer fields (likes_count), not COUNT(*) queries. Join performance degrades with large tables.
- **Using localOnly policy for feed:** Feed should use alwaysHydrate (network-first with cache fallback). localOnly never refreshes.
- **Manual Supabase realtime wiring:** Use Brick's subscribeToRealtime<T>() instead of manual .onPostgresChanges. Auto-upserts to cache.
- **Filtering realtime by complex queries:** subscribeToRealtime ignores complex queries (associations, nested where). Keep it simple or filter in stream.

## Don't Hand-Roll

Problems that look simple but have existing solutions:

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Polymorphic feed items (Story + Post) | Custom union type with manual serialization | Separate Brick models (StoryModel, ImagePostModel, etc.) + FeedItem sealed class | Brick handles each model independently, domain layer combines with sealed class |
| Realtime post updates to cache | Manual Supabase .onPostgresChanges + repository.upsert | Brick subscribeToRealtime<PostModel>() | Auto-upserts to SQLite when realtime event received, no boilerplate |
| Post type discrimination | Custom discriminator column logic | Separate tables or post_type filtering | PostService already uses post_type column, Brick queries filter by it |
| Engagement count sync | Manual increment/decrement with local counters | Cache counts from Supabase, rely on server truth | Server counts are source of truth, avoids sync conflicts |
| Pagination with heterogeneous items | Manual offset tracking per type | Fetch all types, combine and sort in memory, apply offset | Simpler than multi-cursor pagination, acceptable for feed use case |

**Key insight:** Social feeds have heterogeneous items (stories, image posts, text posts, video posts) with varying schemas. Hand-rolling a unified table would require: polymorphic associations, discriminator columns, nullable fields for type-specific data. Instead, Brick models each type separately, repository layer combines them into FeedItem sealed class, and UI layer handles rendering via pattern matching.

## Common Pitfalls

### Pitfall 1: Not Filtering Posts by post_type
**What goes wrong:** ImagePostModel queries return text posts and vice versa
**Why it happens:** `posts` table stores all post types, needs filtering by `post_type` column
**How to avoid:** Add `.where('post_type', 'image')` to Query for type-specific fetches
**Warning signs:**
- ImagePost rendered with text post data (missing imageUrl)
- Type casting errors when mapping Supabase rows to models
- More posts returned than expected

### Pitfall 2: Caching Comments and Likes as Brick Models
**What goes wrong:** SQLite bloats with thousands of like/comment records, slow queries
**Why it happens:** Trying to cache everything for complete offline experience
**How to avoid:** User decision: cache posts and counts only, load comments/likes on demand when online
**Warning signs:**
- SQLite database grows rapidly (10MB+ after few days)
- Feed scroll becomes laggy
- Brick queries take seconds instead of milliseconds

### Pitfall 3: Using awaitRemote Policy for Feed
**What goes wrong:** Feed shows loading spinner while waiting for network, even when cache exists
**Why it happens:** awaitRemote always waits for server response
**How to avoid:** Use alwaysHydrate for feed (show cache immediately, refresh background)
**Warning signs:**
- Feed shows blank screen while loading, even on second+ app open
- Users report "slow feed" when they have cached data
- No instant response when opening feed offline

### Pitfall 4: Complex Realtime Query Filters
**What goes wrong:** Realtime subscription doesn't filter, receives all post events
**Why it happens:** subscribeToRealtime ignores complex queries (associations, multiple where clauses)
**How to avoid:** Use simple query or no query for subscribeToRealtime, filter in stream listener
**Warning signs:**
- Realtime events received for wrong post types
- Too many cache upserts from realtime
- Brick warning logs about unsupported query operators

### Pitfall 5: Not Handling Nullable Author
**What goes wrong:** Null pointer exceptions when post has no cached author profile
**Why it happens:** Foreign key fetch may fail if author not in cache
**How to avoid:** Make author field nullable (UserModel?), handle null in toDomain() conversion
**Warning signs:**
- Crashes when rendering feed items
- "Null check operator used on null value" errors
- Posts display with missing author info

### Pitfall 6: Forgetting to Cancel Realtime Subscriptions
**What goes wrong:** Memory leak, BLoC continues receiving events after disposal
**Why it happens:** subscribeToRealtime returns StreamSubscription, must be cancelled
**How to avoid:** Store subscription in BLoC field, cancel in close() method
**Warning signs:**
- Memory usage grows over time
- Events received after navigating away from feed
- Multiple subscriptions to same channel

### Pitfall 7: Pull-to-Refresh Offline Error
**What goes wrong:** Pull-to-refresh triggers network call that fails silently offline
**Why it happens:** RefreshFeedEvent doesn't check connectivity before calling repository
**How to avoid:** Check InternetConnection.hasInternetAccess, show snackbar if offline
**Warning signs:**
- Pull-to-refresh spinner hangs offline
- No feedback when refreshing without internet
- Users confused why refresh doesn't work

## Code Examples

Verified patterns from official sources:

### Text Post Model with Metadata
```dart
// lib/features/social/data/models/text_post.model.dart
// Source: Phase 2 patterns + PostService schema
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import '../../domain/entities/text_post.dart';
import 'user.model.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'posts'),
  sqliteConfig: SqliteSerializable(),
)
class TextPostModel extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  final String id;

  @Supabase(name: 'content')
  final String body;

  @Supabase(name: 'thumbnail_url')
  final String? imageUrl;

  @Supabase(name: 'created_at')
  final DateTime? createdAt;

  @Supabase(foreignKey: 'author_id')
  final UserModel? author;

  @Supabase(name: 'likes_count', defaultValue: 0)
  final int likes;

  @Supabase(name: 'comments_count', defaultValue: 0)
  final int commentCount;

  @Supabase(name: 'shares_count', defaultValue: 0)
  final int shareCount;

  // Metadata for styling (background color, text color, font size)
  @Supabase(name: 'metadata')
  final Map<String, dynamic>? metadata;

  @Supabase(ignore: true)
  @Sqlite()
  final bool isLikedByCurrentUser;

  @Supabase(ignore: true)
  @Sqlite()
  final bool isFavorite;

  TextPostModel({
    required this.id,
    required this.body,
    this.imageUrl,
    this.createdAt,
    this.author,
    this.likes = 0,
    this.commentCount = 0,
    this.shareCount = 0,
    this.metadata,
    this.isLikedByCurrentUser = false,
    this.isFavorite = false,
  });

  TextPost toDomain() {
    final meta = metadata ?? {};
    final tags = (meta['tags'] as List?)?.cast<String>() ?? <String>[];

    return TextPost(
      id: id,
      body: body,
      imageUrl: imageUrl,
      backgroundColor: meta['background_color'] as int? ?? 0xFF1E3A5F,
      textColor: meta['text_color'] as int? ?? 0xFFFFFFFF,
      fontSize: (meta['font_size'] as num?)?.toDouble() ?? 18.0,
      fontFamily: meta['font_family'] as String?,
      createdAt: createdAt,
      authorId: author?.id,
      authorUser: author?.toDomain(),
      likes: likes,
      commentCount: commentCount,
      shareCount: shareCount,
      isLikedByCurrentUser: isLikedByCurrentUser,
      isFavorite: isFavorite,
      tags: tags,
    );
  }

  factory TextPostModel.fromDomain(TextPost post) {
    return TextPostModel(
      id: post.id,
      body: post.body,
      imageUrl: post.imageUrl,
      createdAt: post.createdAt,
      author: post.authorUser != null
        ? UserModel.fromDomain(post.authorUser!)
        : null,
      likes: post.likes,
      commentCount: post.commentCount,
      shareCount: post.shareCount,
      metadata: {
        'background_color': post.backgroundColor,
        'text_color': post.textColor,
        'font_size': post.fontSize,
        'font_family': post.fontFamily,
        'tags': post.tags,
      },
      isLikedByCurrentUser: post.isLikedByCurrentUser,
      isFavorite: post.isFavorite,
    );
  }
}
```

### Video Post Model with Duration
```dart
// lib/features/social/data/models/video_post.model.dart
// Source: PostService schema + Phase 2 patterns
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import '../../domain/entities/video_post.dart';
import 'user.model.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'posts'),
  sqliteConfig: SqliteSerializable(),
)
class VideoPostModel extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  final String id;

  @Supabase(name: 'media_urls')
  final List<String> mediaUrls;

  String get videoUrl => mediaUrls.isNotEmpty ? mediaUrls.first : '';

  @Supabase(name: 'thumbnail_url')
  final String? thumbnailUrl;

  @Supabase(name: 'content')
  final String caption;

  @Supabase(name: 'created_at')
  final DateTime? createdAt;

  @Supabase(foreignKey: 'author_id')
  final UserModel? author;

  @Supabase(name: 'likes_count', defaultValue: 0)
  final int likes;

  @Supabase(name: 'comments_count', defaultValue: 0)
  final int commentCount;

  @Supabase(name: 'shares_count', defaultValue: 0)
  final int shareCount;

  @Supabase(name: 'metadata')
  final Map<String, dynamic>? metadata;

  @Supabase(ignore: true)
  @Sqlite()
  final bool isLikedByCurrentUser;

  @Supabase(ignore: true)
  @Sqlite()
  final bool isFavorite;

  VideoPostModel({
    required this.id,
    required this.mediaUrls,
    this.thumbnailUrl,
    required this.caption,
    this.createdAt,
    this.author,
    this.likes = 0,
    this.commentCount = 0,
    this.shareCount = 0,
    this.metadata,
    this.isLikedByCurrentUser = false,
    this.isFavorite = false,
  });

  VideoPost toDomain() {
    final meta = metadata ?? {};
    final tags = (meta['tags'] as List?)?.cast<String>() ?? <String>[];
    final location = meta['location'] as String?;
    final durationSeconds = meta['duration_seconds'] as int? ?? 0;
    final viewCount = meta['view_count'] as int? ?? 0;

    return VideoPost(
      id: id,
      videoUrl: videoUrl,
      thumbnailUrl: thumbnailUrl,
      caption: caption,
      location: location,
      durationSeconds: durationSeconds,
      createdAt: createdAt,
      authorId: author?.id,
      authorUser: author?.toDomain(),
      likes: likes,
      commentCount: commentCount,
      shareCount: shareCount,
      viewCount: viewCount,
      isLikedByCurrentUser: isLikedByCurrentUser,
      isFavorite: isFavorite,
      tags: tags,
    );
  }

  factory VideoPostModel.fromDomain(VideoPost post) {
    return VideoPostModel(
      id: post.id,
      mediaUrls: [post.videoUrl],
      thumbnailUrl: post.thumbnailUrl,
      caption: post.caption,
      createdAt: post.createdAt,
      author: post.authorUser != null
        ? UserModel.fromDomain(post.authorUser!)
        : null,
      likes: post.likes,
      commentCount: post.commentCount,
      shareCount: post.shareCount,
      metadata: {
        'location': post.location,
        'duration_seconds': post.durationSeconds,
        'view_count': post.viewCount,
        'tags': post.tags,
      },
      isLikedByCurrentUser: post.isLikedByCurrentUser,
      isFavorite: post.isFavorite,
    );
  }
}
```

### Repository Query with Type Filtering
```dart
// lib/features/social/data/repositories/post_repository_impl.dart
// Source: Existing PostRepositoryImpl + Brick query patterns
@override
Future<Either<Failure, List<ImagePost>>> getImagePosts({
  int limit = 10,
  int offset = 0,
}) async {
  try {
    // Query Brick cache with post_type filter
    final models = await repository.get<ImagePostModel>(
      policy: OfflineFirstGetPolicy.alwaysHydrate,
      query: Query.where('post_type', 'image')
        .orderBy('created_at', descending: true)
        .offset(offset)
        .limit(limit),
    );

    return Right(models.map((m) => m.toDomain()).toList());
  } on BrickException catch (e) {
    return Left(CacheFailure(e.message));
  } catch (e) {
    return Left(UnexpectedFailure(e.toString()));
  }
}
```

### Realtime Subscription Lifecycle
```dart
// lib/features/social/presentation/bloc/feed_bloc.dart
// Source: GitHub Brick subscribeToRealtime docs
import 'dart:async';
import 'package:myitihas/repository/my_itihas_repository.dart';

@injectable
class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final MyItihasRepository brickRepository;

  StreamSubscription<List<ImagePostModel>>? _imagePostSub;
  StreamSubscription<List<TextPostModel>>? _textPostSub;
  StreamSubscription<List<VideoPostModel>>? _videoPostSub;

  FeedBloc({required this.brickRepository}) : super(const FeedState.initial()) {
    on<LoadFeedEvent>(_onLoadFeed);
    on<RealtimePostReceivedEvent>(_onRealtimePost);

    // Start listening after first event
    on<StartRealtimeEvent>(_onStartRealtime);
  }

  Future<void> _onStartRealtime(
    StartRealtimeEvent event,
    Emitter<FeedState> emit,
  ) async {
    // Subscribe to all post types
    // Note: subscribeToRealtime returns Stream<List<T>>, not Stream<T>
    _imagePostSub = brickRepository
      .subscribeToRealtime<ImagePostModel>()
      .listen((models) {
        // Models are auto-upserted to cache
        // Stream emits when any change occurs
        if (models.isNotEmpty) {
          final latest = models.first;  // Most recent based on ordering
          add(FeedEvent.realtimePostReceived(
            FeedItem.imagePost(latest.toDomain())
          ));
        }
      });

    _textPostSub = brickRepository
      .subscribeToRealtime<TextPostModel>()
      .listen((models) {
        if (models.isNotEmpty) {
          add(FeedEvent.realtimePostReceived(
            FeedItem.textPost(models.first.toDomain())
          ));
        }
      });

    _videoPostSub = brickRepository
      .subscribeToRealtime<VideoPostModel>()
      .listen((models) {
        if (models.isNotEmpty) {
          add(FeedEvent.realtimePostReceived(
            FeedItem.videoPost(models.first.toDomain())
          ));
        }
      });

    talker.info('[FeedBloc] Realtime subscriptions started');
  }

  @override
  Future<void> close() async {
    await _imagePostSub?.cancel();
    await _textPostSub?.cancel();
    await _videoPostSub?.cancel();
    return super.close();
  }
}
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Direct Supabase PostService calls | Brick repository.get<PostModel>() | Phase 4 (this phase) | Automatic offline caching, network-first with cache fallback |
| Manual .onPostgresChanges realtime | Brick subscribeToRealtime<T>() | Phase 4 | Auto-upsert to cache, no manual sync code |
| Hive UserModel | Brick UserModel with foreign keys | Phase 4 | Automatic association resolution, profile caching with posts |
| Computed engagement counts via joins | Cached count fields (likes_count) | Existing PostService pattern | Instant display, no expensive COUNT queries |
| Separate feed for each post type | Combined heterogeneous feed | Existing FeedBloc pattern | Unified UX, sort by date across all content types |

**Deprecated/outdated:**
- **PostService.getFeed() direct calls**: Replaced by PostRepository with Brick models in Phase 4
- **Manual Supabase realtime setup in FeedBloc**: Replaced by subscribeToRealtime<T>()
- **Hive @HiveType models for User**: Migrated to Brick @ConnectOfflineFirstWithSupabase

## Open Questions

Things that couldn't be fully resolved:

1. **What is the posts table primary key and column structure?**
   - What we know: PostService uses 'posts' table with columns: id, author_id, post_type, content, media_urls, thumbnail_url, visibility, created_at, likes_count, comments_count, shares_count, metadata
   - What's unclear: Exact schema (foreign key constraints, indexes, RLS policies)
   - Recommendation: Assume standard UUID primary key 'id', foreign key to profiles(id) for author_id. Verify schema during implementation.

2. **Should video posts cache video files or just URLs?**
   - What we know: PostService stores media in Supabase storage, returns public URLs
   - What's unclear: User decision on caching video blobs vs streaming
   - Recommendation: Cache URLs only, not video files. Too large for SQLite, stream from Supabase storage when online.

3. **How to handle post_type column for model discrimination?**
   - What we know: Posts table has post_type column ('text', 'image', 'video', 'story_share')
   - What's unclear: Whether Brick models need @Supabase(name: 'post_type', defaultValue: 'image') annotation
   - Recommendation: Add post_type as a field with defaultValue matching model type. Ensures queries filter correctly.

4. **What happens to realtime subscriptions when app backgrounds?**
   - What we know: subscribeToRealtime returns StreamSubscription
   - What's unclear: Whether subscription auto-resumes on app resume
   - Recommendation: Subscriptions likely pause when app backgrounds (Supabase behavior). BLoC close() cancels, LoadFeedEvent restarts. Test lifecycle.

5. **Should engagement counts update optimistically or wait for server?**
   - What we know: User decision is network-first (try server first)
   - What's unclear: Whether UI should show immediate count update or wait for confirmation
   - Recommendation: Optimistic update for better UX (toggleLike immediately updates count), then sync with server. Realtime subscription corrects if mismatch.

## Sources

### Primary (HIGH confidence)
- GitHub GetDutchie/Brick offline-first with Supabase
  - subscribeToRealtime method: https://github.com/GetDutchie/brick/tree/main/packages/brick_offline_first_with_supabase
  - OfflineFirstRepository API: https://github.com/GetDutchie/brick/blob/main/packages/brick_offline_first/lib/src/offline_first_repository.dart
- Supabase Flutter Documentation (Context7: /websites/supabase_reference_dart)
  - Realtime subscriptions with onPostgresChanges
  - PostgresChangePayload structure
- Phase 2 Research (.planning/phases/02-stories-feature/02-RESEARCH.md)
  - Brick model patterns, @ConnectOfflineFirstWithSupabase usage
  - OfflineFirstGetPolicy: alwaysHydrate, awaitRemoteWhenNoneExist
- Phase 3 Research (.planning/phases/03-story-generator-feature/03-RESEARCH.md)
  - Connectivity checking with InternetConnection
  - Offline error snackbar pattern

### Secondary (MEDIUM confidence)
- Existing MyItihas codebase
  - PostService schema and methods (lib/services/post_service.dart)
  - FeedBloc existing implementation (lib/features/social/presentation/bloc/feed_bloc.dart)
  - Post domain entities (lib/features/social/domain/entities/*.dart)
- pub.dev brick_offline_first_with_supabase package documentation
  - Model annotation examples
  - Foreign key and association handling

### Tertiary (LOW confidence)
- None - all findings verified with codebase and official docs

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - Using existing packages from Phase 1/2, no new dependencies
- Architecture: HIGH - Verified Brick patterns from Phase 2, PostService schema from codebase
- Pitfalls: MEDIUM - Based on Phase 2/3 learnings and documented Brick limitations, some social-feed-specific issues may emerge
- Realtime sync: MEDIUM - subscribeToRealtime documented but limited examples, lifecycle behavior needs validation

**Research date:** 2026-01-29
**Valid until:** 2026-02-28 (30 days - stable packages, established patterns)
