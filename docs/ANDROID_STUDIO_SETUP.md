# MyItihas – Android Studio setup

MyItihas is a **Flutter** app. Use this guide to open and run it in Android Studio.

## 1. Prerequisites

- **Flutter SDK**  
  - Install from [flutter.dev](https://flutter.dev/docs/get-started/install) and add `flutter` to your PATH.  
  - From a terminal: `flutter doctor`
- **Android Studio** (latest stable)  
  - [Download Android Studio](https://developer.android.com/studio)
- **Flutter & Dart plugins in Android Studio**  
  - **File → Settings → Plugins** (Windows/Linux) or **Android Studio → Settings → Plugins** (macOS)  
  - Install **Flutter** and **Dart**. Restart Android Studio.

## 2. Open the project in Android Studio

- **Open the project root**, not the `android` folder:
  - **File → Open**
  - Choose: `MyItihas-main` (the folder that contains `pubspec.yaml`, `lib/`, and `android/`)
- Click **Open**. Let Android Studio index and sync (Gradle, Flutter, etc.).

## 3. Flutter SDK and `local.properties`

The Android build needs your Flutter SDK path in `android/local.properties`. It is created automatically when Flutter runs from this project.

- In a terminal, go to the project root and run:
  ```bash
  cd path/to/MyItihas-main
  flutter pub get
  ```
- This should create/update `android/local.properties` with something like:
  ```properties
  flutter.sdk=C:\\path\\to\\flutter
  ```
- If you prefer to create it manually, create `MyItihas-main/android/local.properties` with one line (use your real Flutter path; on Windows use `\\` or `/`):
  ```properties
  flutter.sdk=C\:\\path\\to\\flutter
  ```

## 4. Environment and code generation (required for the app)

- Copy the example env file and add your Supabase values:
  ```bash
  copy .env.example .env
  ```
  Edit `.env` and set at least:
  - `SUPABASE_URL`
  - `SUPABASE_ANON_KEY`
- From the project root, run:
  ```bash
  dart run build_runner build --delete-conflicting-outputs
  ```

## 5. Run on Android

- **Device/emulator**: Start an Android emulator or connect a device with USB debugging.
- In Android Studio:
  - Select the Android device in the device dropdown.
  - Click the **Run** button (green play) or press **Shift+F10**.
- Or from the project root in a terminal:
  ```bash
  flutter run
  ```

## 6. Optional: release build (signing)

For a signed release APK/App Bundle, create `android/key.properties` (see `android/app/build.gradle.kts`). For local development and debug builds you can skip this.

## Troubleshooting

| Issue | What to do |
|-------|------------|
| “flutter.sdk not set in local.properties” | Run `flutter pub get` from project root, or add `flutter.sdk` to `android/local.properties` as above. |
| Gradle sync fails | Ensure you opened the **root** `MyItihas-main` folder, not only `android`. Then **File → Invalidate Caches → Invalidate and Restart** if needed. |
| Flutter not detected | In Android Studio: **File → Settings → Languages & Frameworks → Flutter** and set **Flutter SDK path** to your Flutter install. |
| Missing dependencies / red code | In terminal: `flutter pub get` then `dart run build_runner build --delete-conflicting-outputs`. |
| App crashes or env errors | Ensure `.env` exists (from `.env.example`) and you ran `dart run build_runner build --delete-conflicting-outputs` after editing `.env`. |

---

**Summary:** Install Flutter + Android Studio (+ Flutter/Dart plugins) → open **MyItihas-main** (root) → run `flutter pub get` → set up `.env` and run build_runner → run the app from Android Studio or `flutter run`.
