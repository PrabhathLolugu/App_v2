# Repository Guidelines

## Project Structure & Module Organization
- `lib/` is the Flutter app source. Primary code follows feature-first clean architecture (`features/<feature>/{data,domain,presentation}`) with shared code in `lib/core/`, `lib/config/`, and `lib/services/`.
- `assets/` stores images, icons, and static data (`assets/data/quotes.json`).
- `supabase/` contains backend logic: SQL migrations in `supabase/migrations/` and Edge Functions in `supabase/functions/`.
- Platform folders (`android/`, `ios/`, `web/`, `macos/`, `linux/`, `windows/`) are generated targets; keep app logic in `lib/`.
- Docs and references live in `docs/`.

## Build, Test, and Development Commands
- `flutter pub get` installs dependencies.
- `flutter run` launches the app on the selected device.
- `flutter analyze` runs static analysis using `analysis_options.yaml`.
- `dart format .` formats Dart source.
- `flutter test` runs unit/widget tests (add tests under `test/`).
- `flutter pub run build_runner build --delete-conflicting-outputs` regenerates Freezed/JSON/Injectable/Envied/Brick code.
- `flutter pub run build_runner watch --delete-conflicting-outputs` keeps generated files updated during development.

## Coding Style & Naming Conventions
- Use standard Dart formatting (2-space indentation) and keep analyzer warnings at zero.
- File names: `snake_case.dart`; classes/types: `PascalCase`; methods/variables: `camelCase`.
- Suffixes should match layer intent, for example `*_repository_impl.dart`, `*_remote_data_source.dart`, `*_bloc.dart`, `*_state.dart`.
- Do not hand-edit generated files (`*.g.dart`, `*.freezed.dart`, `lib/brick/db/*`, `lib/i18n/strings*.dart`).

## Testing Guidelines
- Preferred framework: `flutter_test`.
- Place tests in `test/` and name files `*_test.dart`.
- Mirror source paths where practical (example: `lib/features/chat/...` -> `test/features/chat/...`).
- For feature changes, include at least one unit or widget test covering success and failure/empty states.

## Commit & Pull Request Guidelines
- Follow Conventional Commit style seen in history: `feat:`, `fix:`, `refactor:`, `chore:`.
- Keep commits focused and atomic; include regenerated artifacts when source annotations change.
- PRs should include: purpose, key changes, screenshots/videos for UI updates, testing notes (`flutter analyze`, `flutter test`), and linked issue(s).

## Security & Configuration Tips
- Copy `.env.example` to `.env`; never commit real secrets.
- Configure Supabase and Google OAuth values via environment variables.
- Use Supabase secrets for Edge Function credentials instead of hardcoding keys.
