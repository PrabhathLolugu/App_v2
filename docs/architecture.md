# Architecture Guide: Clean Architecture with Domain Driven Design

## Overview

This project follows **Clean Architecture** principles combined with **Domain Driven Design (DDD)** to create a maintainable, testable, and scalable application structure.

For detailed package recommendations and code generation setup, see the [Package Guide](packages.md).

## Core Principles

### Clean Architecture

Clean Architecture emphasizes separation of concerns through layered architecture where dependencies flow inward:

```
┌─────────────────────────────────────────┐
│        Presentation Layer               │
│  (UI, Widgets, State Management)        │
├─────────────────────────────────────────┤
│        Application Layer                │
│    (Use Cases, Business Logic)          │
├─────────────────────────────────────────┤
│          Domain Layer                   │
│  (Entities, Value Objects, Interfaces)  │
├─────────────────────────────────────────┤
│      Infrastructure Layer               │
│  (Data Sources, APIs, Repositories)     │
└─────────────────────────────────────────┘
```

### Domain Driven Design (DDD)

DDD focuses on:

- **Ubiquitous Language**: Shared vocabulary between developers and domain experts
- **Bounded Contexts**: Clear boundaries for different parts of the system
- **Entities and Value Objects**: Core domain models
- **Aggregates**: Clusters of domain objects treated as a single unit
- **Repositories**: Abstraction over data persistence
- **Domain Events**: Communication between different parts of the domain

## Project Structure

```
lib/
├── core/
│   ├── di/
│   │   ├── injection_container.dart
│   │   └── injection_container.config.dart (generated)
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── logging/
│   │   └── talker_setup.dart
│   ├── usecases/
│   │   └── usecase.dart
│   ├── utils/
│   │   ├── constants.dart
│   │   └── extensions.dart
│   └── network/
│       └── network_info.dart
│
├── features/
│   └── [feature_name]/
│       ├── domain/
│       │   ├── entities/
│       │   │   └── [entity].dart
│       │   ├── repositories/
│       │   │   └── [repository]_repository.dart
│       │   └── usecases/
│       │       └── [usecase].dart
│       │
│       ├── data/
│       │   ├── models/
│       │   │   └── [model].dart
│       │   ├── datasources/
│       │   │   ├── [datasource]_local_data_source.dart
│       │   │   └── [datasource]_remote_data_source.dart
│       │   └── repositories/
│       │       └── [repository]_repository_impl.dart
│       │
│       └── presentation/
│           ├── bloc|cubit/
│           │   ├── [feature]_bloc.dart
│           │   ├── [feature]_event.dart
│           │   └── [feature]_state.dart
│           ├── pages/
│           │   └── [page]_page.dart
│           └── widgets/
│               └── [widget].dart
│
├── config/
│   ├── routes.dart
│   └── theme/
│       ├── app_theme.dart           # Main theme configuration
│       ├── color_schemes.dart       # Light & dark color schemes
│       ├── text_theme.dart          # Typography configuration
│       └── component_themes.dart    # Individual component themes
│
└── main.dart
```

**Note**: For comprehensive theming setup and best practices, see the [Theming Guide](theming.md).

## Layer Responsibilities

### 1. Domain Layer (innermost, no dependencies)

**Purpose**: Contains the business logic and is independent of any external framework.

#### Entities

- Pure Dart classes representing core business objects
- Contain business logic relevant to the entity itself
- No dependencies on other layers

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'story.freezed.dart';

@freezed
class Story with _$Story {
  const Story._();
  
  const factory Story({
    required String id,
    required String title,
    required String content,
    required DateTime createdAt,
  }) = _Story;
  
  // Business logic methods
  bool isRecent() => DateTime.now().difference(createdAt).inDays < 7;
}
```

#### Value Objects

- Immutable objects defined by their attributes
- Represent domain concepts that have no identity

```dart
class Email {
  final String value;
  
  Email(this.value) {
    if (!_isValid(value)) {
      throw InvalidEmailException();
    }
  }
  
  bool _isValid(String email) {
    // Validation logic
  }
}
```

#### Repository Interfaces

- Abstract contracts for data access
- Define what operations are needed, not how they're implemented

```dart
import 'package:fpdart/fpdart.dart';

abstract class StoryRepository {
  Future<Either<Failure, List<Story>>> getStories();
  Future<Either<Failure, Story>> getStoryById(String id);
  Future<Either<Failure, Unit>> saveStory(Story story);
  Future<Either<Failure, Unit>> deleteStory(String id);
}
```

#### Use Cases

- Single-purpose classes that orchestrate business logic
- Implement specific application operations
- Follow Single Responsibility Principle

```dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetStories implements UseCase<List<Story>, NoParams> {
  final StoryRepository repository;
  
  GetStories(this.repository);
  
  @override
  Future<Either<Failure, List<Story>>> call(NoParams params) async {
    return await repository.getStories();
  }
}
```

### 2. Data Layer (implements domain contracts)

**Purpose**: Handles data operations and implements repository interfaces.

#### Models

- Data Transfer Objects (DTOs)
- Extend domain entities with serialization/deserialization
- Convert between domain and data layers

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/story.dart';

part 'story_model.freezed.dart';
part 'story_model.g.dart';

@freezed
class StoryModel with _$StoryModel {
  const StoryModel._();
  
  const factory StoryModel({
    required String id,
    required String title,
    required String content,
    required DateTime createdAt,
  }) = _StoryModel;
  
  factory StoryModel.fromJson(Map<String, dynamic> json) => 
      _$StoryModelFromJson(json);
  
  // Convert to domain entity
  Story toDomain() {
    return Story(
      id: id,
      title: title,
      content: content,
      createdAt: createdAt,
    );
  }
  
  // Create from domain entity
  factory StoryModel.fromDomain(Story story) {
    return StoryModel(
      id: story.id,
      title: story.title,
      content: story.content,
      createdAt: story.createdAt,
    );
  }
}
```

#### Data Sources

- Handle raw data operations (API calls, database queries, cache)
- Separate local and remote data sources

```dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class StoryRemoteDataSource {
  Future<List<StoryModel>> getStories();
  Future<StoryModel> getStoryById(String id);
}

@LazySingleton(as: StoryRemoteDataSource)
class StoryRemoteDataSourceImpl implements StoryRemoteDataSource {
  final Dio dio;
  
  StoryRemoteDataSourceImpl(this.dio);
  
  @override
  Future<List<StoryModel>> getStories() async {
    try {
      final response = await dio.get('/stories');
      
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => StoryModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server error');
    }
  }
}
```

#### Repository Implementation

- Implements domain repository interfaces
- Coordinates between data sources
- Handles error mapping (exceptions to failures)

```dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:talker/talker.dart';

@LazySingleton(as: StoryRepository)
class StoryRepositoryImpl implements StoryRepository {
  final StoryRemoteDataSource remoteDataSource;
  final StoryLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final Talker talker;
  
  StoryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
    required this.talker,
  });
  
  @override
  Future<Either<Failure, List<Story>>> getStories() async {
    if (await networkInfo.isConnected) {
      try {
        talker.info('Fetching stories from remote source');
        
        final remoteStories = await remoteDataSource.getStories();
        await localDataSource.cacheStories(remoteStories);
        
        final stories = remoteStories.map((model) => model.toDomain()).toList();
        
        talker.good('Successfully fetched ${stories.length} stories');
        return Right(stories);
        
      } on ServerException catch (e, st) {
        talker.error('Server error while fetching stories', e, st);
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        talker.info('Fetching stories from local cache');
        
        final localStories = await localDataSource.getCachedStories();
        final stories = localStories.map((model) => model.toDomain()).toList();
        
        return Right(stories);
        
      } on CacheException catch (e, st) {
        talker.error('Cache error while fetching stories', e, st);
        return Left(CacheFailure(e.message));
      }
    }
  }
}
```

### 3. Presentation Layer

**Purpose**: Handles UI and user interactions.

#### State Management (BLoC/Cubit)

- Manages application state
- Responds to user events
- Calls use cases

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'story_bloc.freezed.dart';

@injectable
class StoryBloc extends Bloc<StoryEvent, StoryState> {
  final GetStories getStories;
  final SaveStory saveStory;
  
  StoryBloc({
    required this.getStories,
    required this.saveStory,
  }) : super(const StoryState.initial()) {
    on<LoadStoriesEvent>(_onLoadStories);
    on<SaveStoryEvent>(_onSaveStory);
  }
  
  Future<void> _onLoadStories(
    LoadStoriesEvent event,
    Emitter<StoryState> emit,
  ) async {
    emit(const StoryState.loading());
    
    final result = await getStories(NoParams());
    
    emit(
      result.fold(
        (failure) => StoryState.error(failure.message),
        (stories) => StoryState.loaded(stories),
      ),
    );
  }
}

// State with Freezed
@freezed
class StoryState with _$StoryState {
  const factory StoryState.initial() = _Initial;
  const factory StoryState.loading() = _Loading;
  const factory StoryState.loaded(List<Story> stories) = _Loaded;
  const factory StoryState.error(String message) = _Error;
}
```

#### Pages

- Full-screen views
- Minimal business logic
- Use state management solutions
- Support internationalization

```dart
import 'package:my_app/i18n/strings.g.dart';

class StoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context); // i18n support
    
    return BlocProvider(
      create: (context) => getIt<StoryBloc>()..add(LoadStoriesEvent()),
      child: Scaffold(
        appBar: AppBar(title: Text(t.stories.title)),
        body: BlocBuilder<StoryBloc, StoryState>(
          builder: (context, state) {
            if (state is StoryLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is StoryLoaded) {
              return StoryListWidget(stories: state.stories);
            } else if (state is StoryError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
```

#### Widgets

- Reusable UI components
- Purely presentational
- Receive data through parameters

### 4. Core Layer

**Purpose**: Shared utilities and interfaces used across the application.

- **Errors**: Custom exceptions and failure classes
- **Use Cases**: Base use case interfaces
- **Utils**: Helper functions, constants, extensions
- **Network**: Network connectivity checks

## Dependency Flow Rules

### The Dependency Rule

**Source code dependencies must point inward only.**

- **Presentation** depends on **Domain**
- **Data** depends on **Domain**
- **Domain** depends on nothing (except Dart core)
- **Core** can be used by all layers

### Never Break These Rules

1. **Domain layer must not import**:
   - Flutter/UI frameworks
   - External packages (except core Dart)
   - Data layer implementations

2. **Data layer must not import**:
   - Presentation layer
   - Flutter/UI frameworks (except for platform channels if necessary)

3. **Use dependency injection**:
   - Use interfaces/abstract classes in domain
   - Inject implementations from outer layers

## Error Handling

### Exceptions (Data Layer)

```dart
class ServerException implements Exception {}
class CacheException implements Exception {}
class NetworkException implements Exception {}
```

### Failures (Domain Layer)

```dart
abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure() : super('Server error occurred');
}

class CacheFailure extends Failure {
  CacheFailure() : super('Cache error occurred');
}

class NetworkFailure extends Failure {
  NetworkFailure() : super('Network connection failed');
}
```

## Dependency Injection

Use `injectable` with `get_it` for automatic code generation:

```dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection_container.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();
```

**Usage in classes**:

```dart
// Singleton (created once, lives for app lifetime)
@lazySingleton
class NetworkInfoImpl implements NetworkInfo { }

// Factory (created every time it's requested)
@injectable
class GetStories implements UseCase { }

// Named registration
@Named('api')
@lazySingleton
class ApiClient { }

// Environment-specific
@Environment('dev')
@lazySingleton
class DevApiClient implements ApiClient { }

@Environment('prod')
@lazySingleton
class ProdApiClient implements ApiClient { }
```

**In main.dart**:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await configureDependencies();
  
  runApp(MyApp());
}
```

For more details, see the [Package Guide](packages.md#3-injectable-dependency-injection).

## Testing Strategy

### Domain Layer Tests

- Unit tests for entities and value objects
- Mock repositories for use case tests
- Test business logic in isolation

### Data Layer Tests

- Mock data sources
- Test repository implementations
- Test model conversions

### Presentation Layer Tests

- Widget tests for UI components
- BLoC tests using mock use cases
- Integration tests for user flows

## Best Practices

1. **Keep domain pure**: No framework dependencies in domain layer
2. **Use Freezed for immutability**: All entities, models, and states should use Freezed
3. **Use fpdart for error handling**: Always return `Either<Failure, Success>` from repositories and use cases
4. **Use injectable for DI**: Annotate all services, repositories, and use cases
5. **Single Responsibility**: Each class has one reason to change
6. **Dependency Inversion**: Depend on abstractions, not concretions
7. **Feature-first organization**: Group by feature, not by layer
8. **Meaningful naming**: Use ubiquitous language from the domain
9. **Avoid primitive obsession**: Use value objects instead of primitives
10. **Keep use cases focused**: One use case = one business operation
11. **Use Talker for logging**: Integrate logging at repository and use case levels
12. **Run code generation**: Always run `build_runner` after changes to generated files

For package-specific best practices, see the [Package Guide](packages.md).

## Migration Guide

### Refactoring Existing Code

1. **Identify domain entities**: Extract business objects from existing code
2. **Create repository interfaces**: Define contracts in domain layer
3. **Implement data layer**: Move data access logic to data sources and repositories
4. **Extract use cases**: Isolate business operations into use case classes
5. **Refactor UI**: Move business logic from widgets to BLoCs/Cubits
6. **Setup DI**: Configure dependency injection
7. **Write tests**: Add tests starting from domain layer

### Gradual Adoption

You don't need to refactor everything at once:

1. Start with new features using clean architecture
2. Gradually refactor existing features
3. Focus on high-value or frequently changed areas first

## References

- [Package Guide](packages.md) - Recommended packages and code generation setup
- [Internationalization Guide](intl.md) - Complete i18n guide using slang
- [Theming Guide](theming.md) - Material Design 3 theming and styling
- [Clean Architecture by Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Domain-Driven Design by Eric Evans](https://www.domainlanguage.com/ddd/)
- [Flutter Clean Architecture Guide](https://resocoder.com/flutter-clean-architecture-tdd/)
- [FpDart Documentation](https://www.sandromaglione.com/fpdart-functional-programming-dart-flutter)
- [BLoC Library](https://bloclibrary.dev/)

## Conclusion

Following Clean Architecture with DDD provides:

- **Testability**: Easy to test business logic in isolation
- **Maintainability**: Clear separation of concerns
- **Flexibility**: Easy to swap implementations
- **Scalability**: Structure supports growth
- **Independence**: UI, database, and frameworks are replaceable

The key is consistency and discipline in following the dependency rule and keeping concerns properly separated.
