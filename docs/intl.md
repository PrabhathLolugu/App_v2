# Internationalization (i18n) Guide: Using Slang

## Overview

This guide demonstrates how to implement internationalization in your Flutter application using [slang](https://pub.dev/packages/slang), a type-safe i18n solution that uses code generation to provide compile-time safety and zero parsing overhead.

## Why Slang?

**Key Advantages:**

- 🚀 **Minimal Setup**: Create JSON/YAML/CSV files and get started immediately
- 🐞 **Bug-Resistant**: Compile-time checking prevents typos and missing arguments
- ⚡ **Fast**: Native Dart method calls with zero parsing at runtime
- 📁 **Organized**: Split translations using namespaces for better maintainability
- 🔨 **Configurable**: Customize everything from file patterns to pluralization
- 🖥️ **Framework-Independent**: Works with any Dart project, not just Flutter
- 📊 **Powerful CLI**: Analyze, migrate, and manage translations efficiently

## Installation

### Step 1: Add Dependencies

```yaml
# pubspec.yaml
dependencies:
  slang: ^4.11.1
  slang_flutter: ^4.11.1  # Only for Flutter projects
  
dev_dependencies:
  slang_build_runner: ^4.11.1  # Optional: for build_runner integration
```

### Step 2: Run Pub Get

```bash
flutter pub get
```

## Basic Setup

### File Structure

Create translation files in a consistent location. Most common directories are `lib/i18n` or `assets/i18n`.

**Recommended Structure:**

```
lib/
 └── i18n/
      ├── strings.g.dart          (generated)
      ├── strings.i18n.json       (base locale - English)
      ├── strings_fr.i18n.json    (French)
      ├── strings_es.i18n.json    (Spanish)
      └── strings_zh-CN.i18n.json (Chinese - with country code)
```

**File Naming Convention:**

```
strings_<locale>.<extension>
```

- Base locale (English): `strings.i18n.json`
- Other locales: `strings_<locale>.i18n.json`
- Supported extensions: `.json`, `.yaml`, `.csv`, `.arb`

### Creating Translation Files

#### English (Base Locale)

```json
// File: lib/i18n/strings.i18n.json
{
  "appName": "MyItihas",
  "common": {
    "save": "Save",
    "cancel": "Cancel",
    "delete": "Delete",
    "confirm": "Confirm",
    "loading": "Loading..."
  },
  "home": {
    "title": "Home",
    "welcome": "Welcome, $name!",
    "storiesCount": "You have {n} {n, plural, one{story} other{stories}}"
  },
  "stories": {
    "create": "Create Story",
    "title": "My Stories",
    "empty": "No stories yet. Create your first one!",
    "details": {
      "title": "Story Details",
      "author": "Author: $author",
      "createdAt": "Created: {date}"
    }
  },
  "settings": {
    "title": "Settings",
    "language": "Language",
    "theme": "Theme",
    "about": "About"
  }
}
```

#### Hindi Translation

```json
// File: lib/i18n/strings_hi.i18n.json
{
  "appName": "मेरा इतिहास",
  "common": {
    "save": "सहेजें",
    "cancel": "रद्द करें",
    "delete": "हटाएं",
    "confirm": "पुष्टि करें",
    "loading": "लोड हो रहा है..."
  },
  "home": {
    "title": "होम",
    "welcome": "स्वागत है, $name!",
    "storiesCount": "आपके पास {n} {n, plural, one{कहानी} other{कहानियां}} हैं"
  },
  "stories": {
    "create": "कहानी बनाएं",
    "title": "मेरी कहानियां",
    "empty": "अभी तक कोई कहानी नहीं। अपनी पहली कहानी बनाएं!",
    "details": {
      "title": "कहानी विवरण",
      "author": "लेखक: $author",
      "createdAt": "बनाया गया: {date}"
    }
  },
  "settings": {
    "title": "सेटिंग्स",
    "language": "भाषा",
    "theme": "थीम",
    "about": "के बारे में"
  }
}
```

### Configuration (Optional)

Create `slang.yaml` in your project root for customization:

```yaml
# slang.yaml
base_locale: en
fallback_strategy: base_locale  # Fallback to English for missing translations
input_directory: lib/i18n
input_file_pattern: .i18n.json
output_directory: lib/i18n
output_file_name: strings.g.dart
string_interpolation: dart  # Use Dart string interpolation: $name
translate_var: t  # Translation variable name
enum_name: AppLocale
class_name: Translations
key_case: camel  # Transform keys to camelCase
param_case: camel  # Transform parameters to camelCase
```

### Generate Code

Run the slang command to generate Dart code:

```bash
# Recommended: Built-in generator
dart run slang

# Alternative: Using build_runner
dart run build_runner build --delete-conflicting-outputs
```

**Watch Mode (Auto-regenerate on file changes):**

```bash
dart run slang watch
```

## Initialization

### Method 1: Device Locale (Recommended for most apps)

```dart
// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'i18n/strings.g.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale(); // Use device's locale
  runApp(TranslationProvider(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: t.appName,
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: HomePage(),
    );
  }
}
```

### Method 2: Specific Locale (User preference)

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load saved locale from storage
  String? savedLocale = await loadLocaleFromStorage();
  if (savedLocale != null) {
    LocaleSettings.setLocaleRaw(savedLocale);
  } else {
    LocaleSettings.useDeviceLocale();
  }
  
  runApp(TranslationProvider(child: MyApp()));
}
```

### Method 3: Dependency Injection (Advanced)

```dart
// For custom state management solutions
final english = AppLocale.en.build();
final hindi = AppLocale.hi.build();

// Use directly without LocaleSettings
String title = hindi.home.title; // "होम"
```

### iOS Configuration

Add supported locales to `ios/Runner/Info.plist`:

```xml
<key>CFBundleLocalizations</key>
<array>
   <string>en</string>
   <string>hi</string>
   <string>es</string>
</array>
```

**Quick command:**

```bash
dart run slang configure
```

## Usage

### Basic Translation Access

```dart
import 'package:my_app/i18n/strings.g.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Method 1: Context-aware (rebuilds on locale change)
    final t = Translations.of(context);
    
    // Method 2: Static getter (no rebuild)
    // final t = Translations.instance;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(t.home.title),
      ),
      body: Column(
        children: [
          Text(t.home.welcome(name: 'John')),
          Text(t.common.save),
        ],
      ),
    );
  }
}
```

### String Interpolation

**Simple Parameters:**

```json
{
  "greeting": "Hello, $name!"
}
```

```dart
String message = t.greeting(name: 'Alice'); // "Hello, Alice!"
```

**Multiple Parameters:**

```json
{
  "profile": "Name: $name, Age: $age, City: $city"
}
```

```dart
String info = t.profile(
  name: 'Bob',
  age: 30,
  city: 'Mumbai',
); // "Name: Bob, Age: 30, City: Mumbai"
```

### Pluralization

Slang automatically detects plural forms using CLDR standards.

**Supported Keywords:** `zero`, `one`, `two`, `few`, `many`, `other`

```json
{
  "items": {
    "zero": "No items",
    "one": "One item",
    "other": "$n items"
  }
}
```

```dart
String a = t.items(n: 0); // "No items"
String b = t.items(n: 1); // "One item"
String c = t.items(n: 5); // "5 items"
```

**Custom Parameter Name:**

```json
{
  "apples(param=count)": {
    "one": "I have one apple",
    "other": "I have $count apples"
  }
}
```

```dart
String text = t.apples(count: 3); // "I have 3 apples"
```

**Ordinal Plurals:**

```json
{
  "place(ordinal)": {
    "one": "${n}st place",
    "two": "${n}nd place",
    "few": "${n}rd place",
    "other": "${n}th place"
  }
}
```

```dart
String a = t.place(n: 1); // "1st place"
String b = t.place(n: 2); // "2nd place"
String c = t.place(n: 3); // "3rd place"
String d = t.place(n: 4); // "4th place"
```

### Lists and Maps

**Lists:**

```json
{
  "onboarding": [
    "Welcome to MyItihas",
    "Create your stories",
    "Share with others"
  ]
}
```

```dart
String step1 = t.onboarding[0]; // "Welcome to MyItihas"
String step2 = t.onboarding[1]; // "Create your stories"
```

**Maps:**

```json
{
  "errors(map)": {
    "network": "Network error",
    "server": "Server error",
    "unknown": "Unknown error"
  }
}
```

```dart
String error = t.errors['network']; // "Network error"
```

### Typed Parameters

Increase type safety by specifying parameter types:

```json
{
  "userInfo": "Name: {name: String}, Age: {age: int}, Balance: {balance: double}"
}
```

```dart
String info = t.userInfo(
  name: 'Alice',
  age: 25,
  balance: 1234.56,
);
```

### Date and Number Formatting (L10n)

Slang integrates with `intl` for locale-specific formatting.

```json
{
  "account": "You have {amount: currency} in your account",
  "today": "Today is {date: yMd}",
  "time": "Current time: {time: jm}"
}
```

```dart
String a = t.account(amount: 1234.56); 
// English: "You have $1,234.56 in your account"
// Hindi: "आपके खाते में ₹1,234.56 हैं"

String b = t.today(date: DateTime.now());
// English: "Today is 12/13/2025"

String c = t.time(time: DateTime.now());
// English: "Current time: 2:30 PM"
```

**Custom Formats:**

```json
{
  "@@types": {
    "price": "currency(symbol: '₹')",
    "dateOnly": "DateFormat('dd/MM/yyyy')"
  },
  "orderTotal": "Total: {amount: price}",
  "orderDate": "Date: {date: dateOnly}"
}
```

### Linked Translations

Reuse translations within other translations:

```json
{
  "fields": {
    "name": "my name is {firstName}",
    "age": "I am {age} years old"
  },
  "introduce": "Hello, @:fields.name and @:fields.age"
}
```

```dart
String intro = t.introduce(firstName: 'Tom', age: 27);
// "Hello, my name is Tom and I am 27 years old."
```

### Context-Based Translations (Custom Enums)

Handle different contexts like gender:

```json
{
  "greet(context=GenderContext)": {
    "male": "Hello Mr. $name",
    "female": "Hello Ms. $name"
  }
}
```

```dart
// Generated enum
enum GenderContext {
  male,
  female,
}

// Usage
String a = t.greet(name: 'Maria', context: GenderContext.female);
// "Hello Ms. Maria"
```

### RichText Support

Create rich text with multiple styles:

```json
{
  "welcome(rich)": "Welcome $name. Click ${link(here)} to continue!"
}
```

```dart
Widget text = Text.rich(
  t.welcome(
    name: TextSpan(
      text: 'Tom',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    link: (text) => TextSpan(
      text: text,
      style: TextStyle(color: Colors.blue),
      recognizer: TapGestureRecognizer()..onTap = () {
        // Handle tap
      },
    ),
  ),
);
```

## Changing Locale at Runtime

### Using LocaleSettings

```dart
// Type-safe locale change
LocaleSettings.setLocale(AppLocale.hi);

// String-based locale change
LocaleSettings.setLocaleRaw('hi');

// Back to device locale
LocaleSettings.useDeviceLocale();
```

### In a Settings Page

```dart
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    
    return Scaffold(
      appBar: AppBar(title: Text(t.settings.title)),
      body: ListView(
        children: [
          ListTile(
            title: Text(t.settings.language),
            trailing: DropdownButton<AppLocale>(
              value: LocaleSettings.currentLocale,
              items: AppLocale.values.map((locale) {
                return DropdownMenuItem(
                  value: locale,
                  child: Text(locale.languageTag),
                );
              }).toList(),
              onChanged: (locale) {
                if (locale != null) {
                  LocaleSettings.setLocale(locale);
                  // Save to storage
                  saveLocaleToStorage(locale.languageTag);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

### Listen to Locale Changes

```dart
LocaleSettings.getLocaleStream().listen((locale) {
  print('Locale changed to: $locale');
  // Perform actions on locale change
});
```

## Advanced Features

### Namespaces (For Large Projects)

Split translations into multiple files for better organization.

**Enable in config:**

```yaml
# slang.yaml
namespaces: true
output_file_name: translations.g.dart  # Required when using namespaces
```

**File Structure:**

```
lib/i18n/
 ├── common_en.i18n.json
 ├── common_hi.i18n.json
 ├── auth_en.i18n.json
 ├── auth_hi.i18n.json
 ├── stories_en.i18n.json
 └── stories_hi.i18n.json
```

**Usage:**

```dart
String a = t.common.save;
String b = t.auth.login.title;
String c = t.stories.create;
```

### Fallback Strategy

Handle missing translations gracefully:

```yaml
# slang.yaml
base_locale: en
fallback_strategy: base_locale  # Options: none, base_locale, base_locale_empty_string
```

This allows rapid development without providing all translations immediately.

### Comments in Translations

Add documentation to your translations:

**JSON:**

```json
{
  "login": {
    "button": "Login",
    "@button": "The main login button on the login page"
  }
}
```

**CSV:**

```csv
key,(comment),en,hi
login.button,The main login button,Login,लॉगिन
```

**Generated Code:**

```dart
/// The main login button on the login page
String get button => 'Login';
```

### Translation Overrides (Dynamic Updates)

Update translations at runtime (e.g., from a backend):

**Enable in config:**

```yaml
# slang.yaml
translation_overrides: true
```

**Usage:**

```dart
LocaleSettings.overrideTranslations(
  locale: AppLocale.en,
  fileType: FileType.yaml,
  content: r'''
home:
  title: 'Updated Title'
  ''',
);

String title = t.home.title; // "Updated Title"
```

## CLI Tools

### Analyze Translations

Find missing and unused translations:

```bash
dart run slang analyze --full
```

Output: `_missing_translations.json` and `_unused_translations.json`

### Clean Unused Translations

Remove unused translations:

```bash
dart run slang clean
```

### Apply Missing Translations

Add missing translations to files:

```bash
dart run slang apply
```

### Normalize Translations

Sort translations to match base locale order:

```bash
dart run slang normalize
```

### Migration from ARB

Migrate from Flutter's ARB format:

```bash
dart run slang migrate arb source.arb destination.json
```

### Statistics

Get translation statistics:

```bash
dart run slang stats
```

Output:

```
[en]
 - 25 keys
 - 20 translations
 - 150 words
 - 820 characters
```

## Integration with Clean Architecture

### Domain Layer

```dart
// features/stories/domain/entities/locale.dart
abstract class LocaleEntity {
  String get languageCode;
  String get displayName;
}
```

### Presentation Layer

```dart
// features/settings/presentation/bloc/locale_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../i18n/strings.g.dart';

@injectable
class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc() : super(LocaleState(LocaleSettings.currentLocale)) {
    on<ChangeLocaleEvent>(_onChangeLocale);
  }
  
  void _onChangeLocale(ChangeLocaleEvent event, Emitter<LocaleState> emit) {
    LocaleSettings.setLocale(event.locale);
    emit(LocaleState(event.locale));
  }
}

class LocaleState {
  final AppLocale locale;
  LocaleState(this.locale);
}

abstract class LocaleEvent {}

class ChangeLocaleEvent extends LocaleEvent {
  final AppLocale locale;
  ChangeLocaleEvent(this.locale);
}
```

### Usage in Pages

```dart
class StoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    
    return BlocProvider(
      create: (context) => getIt<StoryBloc>()..add(LoadStoriesEvent()),
      child: Scaffold(
        appBar: AppBar(title: Text(t.stories.title)),
        body: BlocBuilder<StoryBloc, StoryState>(
          builder: (context, state) {
            return state.when(
              initial: () => Center(child: Text(t.common.loading)),
              loading: () => CircularProgressIndicator(),
              loaded: (stories) => StoryListWidget(stories: stories),
              error: (message) => Center(child: Text(message)),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push('/stories/create'),
          child: Icon(Icons.add),
          tooltip: t.stories.create,
        ),
      ),
    );
  }
}
```

## Best Practices

### 1. **Consistent Naming**

Use clear, hierarchical key names:

```json
{
  "featureName": {
    "screenName": {
      "elementName": "Translation"
    }
  }
}
```

### 2. **Group Related Translations**

```json
{
  "auth": {
    "login": { ... },
    "signup": { ... },
    "forgotPassword": { ... }
  },
  "profile": {
    "edit": { ... },
    "view": { ... }
  }
}
```

### 3. **Use Descriptive Parameter Names**

```json
{
  "greeting": "Hello, {userName}!",  // Good
  "greeting": "Hello, {0}!"          // Avoid
}
```

### 4. **Leverage Code Generation**

Always run `dart run slang` after modifying translation files.

### 5. **Version Control**

- Commit translation files (`.json`, `.yaml`, etc.)
- Add generated files to `.gitignore` if using `build_runner`
- For slang's built-in generator, you may commit generated files

### 6. **Translation Keys in Comments**

```dart
// Instead of magic strings
Text(t.home.welcome(name: user.name))

// Not recommended
Text('Welcome, ${user.name}!')
```

### 7. **Use Fallback Strategy**

Enable fallback during development:

```yaml
fallback_strategy: base_locale
```

### 8. **Test Translations**

```dart
void main() {
  group('i18n', () {
    test('All locales should be accessible', () {
      for (final locale in AppLocale.values) {
        final translations = locale.build();
        expect(translations.appName, isNotEmpty);
      }
    });
  });
}
```

## Common Patterns

### Error Messages

```json
{
  "errors": {
    "network": "Unable to connect to the server",
    "notFound": "The requested resource was not found",
    "unauthorized": "You don't have permission to access this",
    "generic": "An unexpected error occurred"
  }
}
```

### Form Validation

```json
{
  "validation": {
    "required": "{field} is required",
    "email": "Please enter a valid email address",
    "minLength": "{field} must be at least {min} characters",
    "maxLength": "{field} must not exceed {max} characters"
  }
}
```

### Confirmation Dialogs

```json
{
  "dialogs": {
    "deleteStory": {
      "title": "Delete Story",
      "message": "Are you sure you want to delete this story?",
      "confirm": "Delete",
      "cancel": "Cancel"
    }
  }
}
```

## Performance Considerations

1. **Lazy Loading**: Slang automatically lazy-loads secondary locales on web
2. **Zero Runtime Parsing**: All translations are pre-generated Dart code
3. **Tree Shaking**: Unused translations are removed in release builds
4. **Small Bundle Size**: Only active locale is included

## Troubleshooting

### Translations Don't Update

- Ensure you're using `Translations.of(context)` for automatic rebuilds
- Wrap your app with `TranslationProvider`
- Call `setState` after `LocaleSettings.setLocale()`

### Missing Plural Resolver

Add custom plural resolver for unsupported languages:

```dart
LocaleSettings.setPluralResolver(
  locale: AppLocale.customLocale,
  cardinalResolver: (n, {zero, one, two, few, many, other}) {
    if (n == 0) return zero ?? other!;
    if (n == 1) return one ?? other!;
    return other!;
  },
);
```

### iOS Localization Not Working

Verify `CFBundleLocalizations` in `Info.plist` or run:

```bash
dart run slang configure
```

## Migration from Other Solutions

### From Flutter Intl (ARB)

```bash
dart run slang migrate arb source.arb destination.json
```

### From JSON Files

Slang can use your existing JSON files. Just rename them to match the pattern:

```
messages_en.json → strings_en.i18n.json
```

## Resources

- **Package**: [pub.dev/packages/slang](https://pub.dev/packages/slang)
- **GitHub**: [github.com/slang-i18n/slang](https://github.com/slang-i18n/slang)
- **Examples**: [github.com/slang-i18n/slang/tree/main/slang/example](https://github.com/slang-i18n/slang/tree/main/slang/example)
- **Documentation**: See inline documentation in generated files

## See Also

- [Architecture Guide](architecture.md) - Clean Architecture patterns
- [Package Guide](packages.md) - Recommended packages and best practices

## Conclusion

Slang provides a robust, type-safe solution for internationalization that integrates seamlessly with Clean Architecture and modern Flutter development practices. Its compile-time safety eliminates entire classes of i18n bugs while maintaining excellent performance and developer experience.
