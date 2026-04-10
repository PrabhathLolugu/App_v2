# Package Guide: Recommended Packages and Best Practices

## Overview

This guide outlines the recommended packages for building a production-ready Flutter application following Clean Architecture and DDD principles. All packages are selected for their reliability, community support, and compatibility with best practices.

## Core Dependencies

### State Management

#### BLoC (flutter_bloc)

**Purpose**: Predictable state management with separation of business logic

```yaml
dependencies:
  flutter_bloc: ^9.1.1
  bloc: ^9.1.0
```

**Usage**:

- Manages application state in the presentation layer
- Separates business logic from UI
- Easy to test and debug
- Works well with clean architecture

**Best Practice**: Use Cubits for simple state management, BLoCs for complex event-driven scenarios.

---

## Code Generation Packages

### 1. Freezed

**Purpose**: Immutable data classes, unions, and pattern matching

```yaml
dependencies:
  freezed_annotation: ^3.1.0

dev_dependencies:
  freezed: ^3.2.3
  build_runner: ^2.10.4
```

**Use Cases**:

- Domain entities and value objects
- DTOs and models
- State classes for BLoC/Cubit
- API request/response models

**Example**:

```dart
@freezed
class Story with _$Story {
  const factory Story({
    required String id,
    required String title,
    required String content,
    required DateTime createdAt,
  }) = _Story;
  
  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
}
```

**Commands**:

```bash
# Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes
flutter pub run build_runner watch --delete-conflicting-outputs
```

---

### 2. JSON Serializable

**Purpose**: Automatic JSON serialization/deserialization

```yaml
dependencies:
  json_annotation: ^4.9.0

dev_dependencies:
  json_serializable: ^6.11.3
  build_runner: ^2.10.4
```

**Use Cases**:

- API response models
- Local storage models
- Configuration files

**Works seamlessly with Freezed**:

```dart
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    @JsonKey(name: 'user_id') required String id,
    @JsonKey(name: 'full_name') required String name,
    @Default([]) List<String> tags,
  }) = _UserModel;
  
  factory UserModel.fromJson(Map<String, dynamic> json) => 
      _$UserModelFromJson(json);
}
```

---

### 3. Injectable (Dependency Injection)

**Purpose**: Compile-time dependency injection with code generation

```yaml
dependencies:
  injectable: ^2.7.1+2
  get_it: ^9.2.0

dev_dependencies:
  injectable_generator: ^2.11.1
  build_runner: ^2.10.4
```

**Setup**:

```dart
// injection_container.dart
import 'package:injectable/injectable.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();
```

**Usage Examples**:

```dart
// Register singleton
@lazySingleton
class StoryRepository implements IStoryRepository {
  final ApiClient apiClient;
  
  StoryRepository(this.apiClient);
}

// Register factory
@injectable
class GetStoriesUseCase {
  final IStoryRepository repository;
  
  GetStoriesUseCase(this.repository);
}

// Environment-specific registration
@Environment('dev')
@lazySingleton
class DevApiClient implements ApiClient { }

@Environment('prod')
@lazySingleton
class ProdApiClient implements ApiClient { }
```

**Commands**:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**Best Practices**:

- Use `@lazySingleton` for repositories and services
- Use `@injectable` or `@factory` for use cases and BLoCs
- Use `@singleton` sparingly (only for truly global state)
- Use named registration for multiple implementations
- Use environments for dev/staging/prod configurations

---

### 4. Envied (Environment Variables)

**Purpose**: Type-safe environment variables with code generation

```yaml
dependencies:
  envied: ^1.3.2

dev_dependencies:
  envied_generator: ^1.3.2
  build_runner: ^2.10.4
```

**Setup**:

```dart
// env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static String apiKey = _Env.apiKey;
  
  @EnviedField(varName: 'BASE_URL')
  static String baseUrl = _Env.baseUrl;
  
  @EnviedField(varName: 'DEBUG_MODE', defaultValue: false)
  static bool debugMode = _Env.debugMode;
}
```

**.env file**:

```
API_KEY=your_secret_api_key_here
BASE_URL=https://api.example.com
DEBUG_MODE=true
```

**Best Practices**:

- Use `obfuscate: true` for sensitive data
- Never commit `.env` files to version control
- Create `.env.example` with dummy values
- Use different env files for different environments

---

### 5. Go Router + Go Router Builder

**Purpose**: Declarative routing with code generation

```yaml
dependencies:
  go_router: ^17.0.1

dev_dependencies:
  go_router_builder: ^4.1.3
  build_runner: ^2.10.4
```

**Setup**:

```dart
// app_router.dart
import 'package:go_router/go_router.dart';

part 'app_router.g.dart';

@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: [
    TypedGoRoute<StoryDetailsRoute>(
      path: 'story/:id',
    ),
    TypedGoRoute<CreateStoryRoute>(
      path: 'create',
    ),
  ],
)
class HomeRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) => HomePage();
}

class StoryDetailsRoute extends GoRouteData {
  final String id;
  
  const StoryDetailsRoute({required this.id});
  
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return StoryDetailsPage(storyId: id);
  }
}

// Router configuration
final router = GoRouter(
  routes: $appRoutes,
  initialLocation: '/',
  redirect: (context, state) {
    // Add authentication logic
    return null;
  },
);
```

**Navigation**:

```dart
// Type-safe navigation
StoryDetailsRoute(id: '123').go(context);
StoryDetailsRoute(id: '123').push(context);

// With query parameters
@TypedGoRoute<SearchRoute>(path: '/search')
class SearchRoute extends GoRouteData {
  final String? query;
  final int? page;
  
  const SearchRoute({this.query, this.page});
}
```

---

## Functional Programming & Error Handling

### FpDart

**Purpose**: Functional programming utilities and robust error handling

```yaml
dependencies:
  fpdart: ^1.2.0
```

**Key Features**:

- `Either<L, R>` for error handling
- `Option<T>` for nullable values
- Immutable data structures
- Function composition

**Usage in Clean Architecture**:

#### Repository Interface

```dart
abstract class StoryRepository {
  Future<Either<Failure, List<Story>>> getStories();
  Future<Either<Failure, Story>> getStoryById(String id);
  Future<Either<Failure, Unit>> saveStory(Story story);
}
```

#### Use Case

```dart
class GetStoriesUseCase {
  final StoryRepository repository;
  
  GetStoriesUseCase(this.repository);
  
  Future<Either<Failure, List<Story>>> call() async {
    return repository.getStories();
  }
}
```

#### BLoC

```dart
Future<void> _onLoadStories(
  LoadStoriesEvent event,
  Emitter<StoryState> emit,
) async {
  emit(const StoryState.loading());
  
  final result = await getStoriesUseCase();
  
  emit(
    result.fold(
      (failure) => StoryState.error(failure.message),
      (stories) => StoryState.loaded(stories),
    ),
  );
}
```

#### Advanced Error Handling

```dart
// Chain operations
Future<Either<Failure, User>> getUserProfile(String userId) async {
  return (await repository.getUser(userId))
    .flatMap((user) => repository.getUserSettings(user.id))
    .map((settings) => user.copyWith(settings: settings));
}

// Handle options
Option<String> getUserEmail(User? user) {
  return Option.fromNullable(user?.email);
}

// Use TaskEither for async operations
TaskEither<Failure, List<Story>> getStoriesTask() {
  return TaskEither.tryCatch(
    () => apiClient.fetchStories(),
    (error, stackTrace) => ServerFailure(error.toString()),
  );
}
```

**Best Practices**:

- Use `Either<Failure, Success>` for all repository and use case returns
- Use `Option<T>` instead of nullable types when appropriate
- Leverage `fold`, `map`, and `flatMap` for clean error handling
- Use `Unit` type for operations that return nothing
- Create custom `Failure` classes for different error types

---

## Logging & Debugging

### Talker

**Purpose**: Advanced logging, error handling, and monitoring

```yaml
dependencies:
  talker: ^5.1.7
  talker_flutter: ^5.1.7
  talker_bloc_logger: ^5.1.7
  talker_dio_logger: ^5.1.7
```

**Setup**:

```dart
// core/logging/talker_setup.dart
import 'package:talker_flutter/talker_flutter.dart';

final talker = TalkerFlutter.init(
  settings: TalkerSettings(
    enabled: true,
    useConsoleLogs: true,
    useHistory: true,
    maxHistoryItems: 1000,
  ),
  logger: TalkerLogger(
    settings: TalkerLoggerSettings(
      enableColors: true,
      level: TalkerLogLevel.debug,
    ),
  ),
);
```

**Integration with BLoC**:

```dart
import 'package:talker_bloc_logger/talker_bloc_logger.dart';

void main() {
  Bloc.observer = TalkerBlocObserver(
    talker: talker,
    settings: TalkerBlocLoggerSettings(
      printStateFullData: false,
      printEventFullData: false,
    ),
  );
  
  runApp(MyApp());
}
```

**Usage in Repository**:

```dart
@lazySingleton
class StoryRepositoryImpl implements StoryRepository {
  final ApiClient apiClient;
  final Talker talker;
  
  StoryRepositoryImpl(this.apiClient, this.talker);
  
  @override
  Future<Either<Failure, List<Story>>> getStories() async {
    try {
      talker.info('Fetching stories from API');
      
      final stories = await apiClient.getStories();
      
      talker.good('Successfully fetched ${stories.length} stories');
      return Right(stories);
      
    } catch (e, st) {
      talker.error('Failed to fetch stories', e, st);
      return Left(ServerFailure(e.toString()));
    }
  }
}
```

**Log Viewer UI**:

```dart
// Add to dev menu
TalkerScreen(talker: talker)

// Or as route
GoRoute(
  path: '/logs',
  builder: (context, state) => TalkerScreen(talker: talker),
)
```

**Custom Logs**:

```dart
// Different log levels
talker.debug('Debug information');
talker.info('Informational message');
talker.warning('Warning message');
talker.error('Error message', error, stackTrace);
talker.critical('Critical error');

// Custom log types
class ApiLog extends TalkerLog {
  ApiLog(String message) : super(message);
  
  @override
  String get title => 'API';
  
  @override
  AnsiPen get pen => AnsiPen()..blue();
}

talker.log(ApiLog('API request completed'));
```

---

## HTTP Client

### Dio + Interceptors

**Purpose**: Powerful HTTP client with interceptors

```yaml
dependencies:
  dio: ^5.9.0
  talker_dio_logger: ^5.1.7
  pretty_dio_logger: ^1.3.1
```

**Setup**:

```dart
@module
abstract class NetworkModule {
  @lazySingleton
  Dio dio(Talker talker) {
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    
    // Add Talker logger
    dio.interceptors.add(
      TalkerDioLogger(
        talker: talker,
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
          printResponseMessage: true,
        ),
      ),
    );
    
    // Add auth interceptor
    dio.interceptors.add(AuthInterceptor());
    
    // Add retry interceptor
    dio.interceptors.add(RetryInterceptor());
    
    return dio;
  }
}
```

---

## Responsive Design & Layout

### 1. Flutter ScreenUtil

**Purpose**: Adaptive screen sizing

```yaml
dependencies:
  flutter_screenutil: ^5.9.3
```

**Setup**:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Design mockup size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          // ...
        );
      },
    );
  }
}
```

**Usage**:

```dart
// Adaptive sizing
Container(
  width: 100.w,  // Adaptive width
  height: 100.h, // Adaptive height
  padding: EdgeInsets.all(16.r), // Adaptive radius/padding
)

// Adaptive text
Text(
  'Hello',
  style: TextStyle(fontSize: 16.sp), // Adaptive font size
)

// Get screen info
double screenWidth = 1.sw; // Screen width
double screenHeight = 1.sh; // Screen height
double statusBarHeight = ScreenUtil().statusBarHeight;
```

---

### 2. Responsive Framework

**Purpose**: Breakpoint-based responsive design

```yaml
dependencies:
  responsive_framework: ^1.5.1
```

**Setup**:

```dart
MaterialApp(
  builder: (context, child) => ResponsiveBreakpoints.builder(
    child: child!,
    breakpoints: [
      const Breakpoint(start: 0, end: 450, name: MOBILE),
      const Breakpoint(start: 451, end: 800, name: TABLET),
      const Breakpoint(start: 801, end: 1920, name: DESKTOP),
      const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
    ],
  ),
)
```

**Usage**:

```dart
// Responsive widgets
ResponsiveRowColumn(
  layout: ResponsiveBreakpoints.of(context).smallerThan(TABLET)
      ? ResponsiveRowColumnType.COLUMN
      : ResponsiveRowColumnType.ROW,
  children: [
    ResponsiveRowColumnItem(child: Widget1()),
    ResponsiveRowColumnItem(child: Widget2()),
  ],
)

// Conditional rendering
if (ResponsiveBreakpoints.of(context).largerThan(MOBILE))
  DesktopNavigationBar()
else
  MobileNavigationBar()

// Responsive values
final padding = ResponsiveValue<double>(
  context,
  defaultValue: 16.0,
  conditionalValues: [
    Condition.smallerThan(name: TABLET, value: 8.0),
    Condition.largerThan(name: TABLET, value: 24.0),
  ],
).value;
```

---

### 3. Layout Builder Pattern

**Purpose**: Native Flutter responsive approach

```dart
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  
  const ResponsiveLayout({
    required this.mobile,
    this.tablet,
    this.desktop,
  });
  
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 650;
      
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 650 &&
      MediaQuery.of(context).size.width < 1100;
      
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1100) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= 650) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}
```

---

## Storage & Persistence

### 1. Hive + Hive Generator

**Purpose**: Fast, local NoSQL database

```yaml
dependencies:
  hive: ^2.2.3
  hive_flutter: ^1.1.0

dev_dependencies:
  hive_generator: ^2.0.1
  build_runner: ^2.10.4
```

**Setup**:

```dart
@HiveType(typeId: 0)
class StoryModel extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String content;
  
  StoryModel({
    required this.id,
    required this.title,
    required this.content,
  });
}
```

---

### 2. Shared Preferences

**Purpose**: Simple key-value storage

```yaml
dependencies:
  shared_preferences: ^2.2.2
```

---

## Testing

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.4
  bloc_test: ^10.0.0
  integration_test:
    sdk: flutter
```

---

## Additional Recommended Packages

### Theming & Design

```yaml
dependencies:
  # Google Fonts - 1000+ fonts from Google
  google_fonts: ^6.2.1
  
  # Dynamic Color - Platform-adaptive theming
  dynamic_color: ^1.7.0
```

**Note**: For comprehensive theming setup including Material Design 3, color schemes, typography, component themes, and best practices, see the [Theming Guide](theming.md).

**google_fonts** enables easy integration of Google Fonts:

```dart
import 'package:google_fonts/google_fonts.dart';

// Apply to entire theme
ThemeData(
  textTheme: GoogleFonts.robotoTextTheme(),
);

// Use individual fonts
Text('Hello', style: GoogleFonts.lato(fontSize: 24));
```

**dynamic_color** enables platform-adaptive colors on Android 12+:

```dart
import 'package:dynamic_color/dynamic_color.dart';

DynamicColorBuilder(
  builder: (lightDynamic, darkDynamic) {
    return MaterialApp(
      theme: ThemeData(colorScheme: lightDynamic),
      darkTheme: ThemeData(colorScheme: darkDynamic),
    );
  },
);
```

### UI Components

```yaml
dependencies:
  # Animations
  animations: ^2.0.11
  lottie: ^3.0.0
  
  # Images
  cached_network_image: ^3.3.1
  flutter_svg: ^2.2.3
  
  # Icons
  flutter_launcher_icons: ^0.13.1
  
  # Shimmer loading
  shimmer: ^3.0.0
```

### Internationalization (i18n)

### Slang

**Purpose**: Type-safe internationalization with code generation

```yaml
dependencies:
  slang: ^4.11.1
  slang_flutter: ^4.11.0

dev_dependencies:
  slang_build_runner: ^4.11.1
```

**Key Features**:

- Compile-time type safety for translations
- Zero runtime parsing overhead
- Support for JSON, YAML, CSV, and ARB formats
- Built-in pluralization and context-based translations
- Powerful CLI for translation management
- Automatic code generation

**Basic Setup**:

Create translation files:

```
lib/i18n/
 ├── strings.i18n.json       (English - base)
 ├── strings_hi.i18n.json    (Hindi)
 └── strings_es.i18n.json    (Spanish)
```

**Configuration** (`slang.yaml`):

```yaml
base_locale: en
fallback_strategy: base_locale
input_directory: lib/i18n
input_file_pattern: .i18n.json
output_directory: lib/i18n
output_file_name: strings.g.dart
string_interpolation: dart
translate_var: t
enum_name: AppLocale
key_case: camel
```

**Example Translation File**:

```json
{
  "appName": "MyItihas",
  "common": {
    "save": "Save",
    "cancel": "Cancel"
  },
  "home": {
    "welcome": "Welcome, $name!",
    "items": {
      "one": "One item",
      "other": "$n items"
    }
  }
}
```

**Initialization**:

```dart
// main.dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'i18n/strings.g.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  runApp(TranslationProvider(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: HomePage(),
    );
  }
}
```

**Usage**:

```dart
// In widgets
final t = Translations.of(context);

Text(t.home.welcome(name: 'John'));
Text(t.home.items(n: 5)); // "5 items"

// Change locale
LocaleSettings.setLocale(AppLocale.hi);
```Internationalization
  slang: ^4.11.1
  slang_flutter: ^4.11.1
  
  # 

**Commands**:

```bash
# Generate translations
dart run slang

# Watch for changes
dart run slang watch

# Analyze translations
dart run slang analyze

# Configure iOS locales
dart run slang configure
```

**Advanced Features**:

- **Pluralization**: Automatic plural form detection
- **Context-based**: Gender, formality, or custom contexts
- **Rich Text**: Multiple styles in one translation
- **Linked Translations**: Reuse translations within others
- **Date/Number Formatting**: Locale-specific formatting with `intl`
- **Namespaces**: Split large translation files
- **Translation Overrides**: Update translations at runtime
slang_build_runner: ^4.11.1
  
**Best Practices**:

- Use hierarchical key structure for organization
- Leverage fallback strategy during development
- Run `dart run slang` after modifying translation files
- Use `Translations.of(context)` for automatic rebuilds
- Add translation tests to ensure compilation

For a comprehensive guide, see [Internationalization Guide](intl.md).

---

## Utilities

```yaml
dependencies:
  # Date/Time
  intl: ^0.19.0  # Also used by slang for L10n
  timeago: ^3.6.0
  
  # Async utilities
  rxdart: ^0.27.7
  
  # Connectivity
  connectivity_plus: ^5.0.2
  
  # Device info
  device_info_plus: ^9.1.1
  
  # Package info
  package_info_plus: ^5.0.1
```

---

## Build Commands

### Code Generation

```bash
# One-time generation
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate)
flutter pub run build_runner watch --delete-conflicting-outputs

# Clean build
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Development Workflow

```bash
# Get dependencies
flutter pub get

# Analyze code
flutter analyze

# Format code
dart format .

# Run tests
flutter test

# Run with environment
flutter run --dart-define-from-file=.env
```

---

## Package Organization in pubspec.yaml

```yaml
name: myitihas
description: A Flutter application following Clean Architecture

publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_bloc: ^9.1.1
  
  # Functional Programming
  fpdart: ^1.2.0
  
  # Dependency Injection
  injectable: ^2.7.1+2
  get_it: ^9.2.0
  
  # Routing
  go_router: ^17.0.1
  
  # HTTP Client
  dio: ^5.9.0
  
  # Logging
  talker: ^5.1.7
  talker_flutter: ^5.1.7
  talker_bloc_logger: ^5.1.7
  talker_dio_logger: ^5.1.7
  
  # Code Generation Annotations
  freezed_annotation: ^3.1.0
  json_annotation: ^4.9.0
  
  # Environment Variables
  envied: ^1.3.2
  
  # Responsive Design
  flutter_screenutil: ^5.9.3
  responsive_framework: ^1.5.1
  
  # Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  shared_preferences: ^2.2.2
  
  # UI Components
  cached_network_image: ^3.3.1
  flutter_svg: ^2.2.3
  shimmer: ^3.0.0
  lottie: ^3.0.0
  
  # Utilities
  intl: ^0.19.0
  connectivity_plus: ^5.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # Code Generation
  build_runner: ^2.10.4
  freezed: ^3.2.3
  json_serializable: ^6.11.3
  injectable_generator: ^2.11.1
  go_router_builder: ^4.1.3
  envied_generator: ^1.3.2
  hive_generator: ^2.0.1
  
  # Testing
  mocktail: ^1.0.4
  bloc_test: ^10.0.0
  
  # Linting
  flutter_lints: ^6.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/
  fonts:
    - family: CustomFont
      fonts:
        - asset: fonts/CustomFont-Regular.ttf
        - asset: fonts/CustomFont-Bold.ttf
          weight: 700
```

---

## Best Practices Summary

1. **Code Generation**: Always run build_runner after changing models, routes, or DI annotations
2. **Environment Variables**: Use envied for all configuration and secrets
3. **Error Handling**: Always return `Either<Failure, Success>` from repositories and use cases
4. **Logging**: Integrate Talker early for better debugging
5. **Dependency Injection**: Use injectable for automatic DI setup
6. **Immutability**: Use Freezed for all data classes
7. **Routing**: Use go_router with code generation for type-safe navigation
8. **Responsive Design**: Choose one approach (ScreenUtil or ResponsiveFramework) and use consistently
9. **Testing**: Write tests for domain and data layers first
10. **Documentation**: Keep this guide updated as new packages are added

---

## Quick Start Checklist

- [ ] Add all dependencies to pubspec.yaml
- [ ] Create translation files in `lib/i18n`
- [ ] Configure slang in `slang.yaml`
- [ ] Run `dart run slang` to generate translations
- [ ] Run `build_runner build`
- [ ] Create feature folders following clean architecture
- [ ] Setup responsive design breakpoints
- [ ] Configure CI/CD with build_runner and slang
- [ ] Setup go_router navigation
- [ ] Run `build_runner build`
- [ ] Create feature folders following clean architecture
- [Internationalization Guide](intl.md) - Complete i18n guide using slang
- [Flutter Documentation](https://docs.flutter.dev/)
- [FpDart Documentation](https://www.sandromaglione.com/fpdart-functional-programming-dart-flutter)
- [BLoC Documentation](https://bloclibrary.dev/)
- [Slang Documentation](<https://pub.dev/packages/slang>

---

## See Also

- [Architecture Guide](architecture.md) - Clean Architecture and DDD patterns
- [Flutter Documentation](https://docs.flutter.dev/)
- [FpDart Documentation](https://www.sandromaglione.com/fpdart-functional-programming-dart-flutter)
- [BLoC Documentation](https://bloclibrary.dev/)
