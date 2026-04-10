# MyItihas – Publication Readiness Report

**Date:** February 15, 2026  
**Summary:** The app is **close to ready** for store submission. A few critical and high-priority items were fixed or must be completed before publishing. Remaining items are recommended for quality and maintainability.

---

## ✅ Fixed in This Review

1. **`.env` in `.gitignore`**  
   `.env` was commented out in the root `.gitignore`, so it could be committed. It is now properly ignored. **Action:** Ensure `.env` is never committed; use `.env.example` for documentation only.

2. **`key.properties` and keystore in `android/.gitignore`**  
   Android signing config was not ignored. `key.properties` and `**/*.keystore`, `**/*.jks` are now in `android/.gitignore` so signing secrets are not committed.

3. **iOS speech/microphone permissions**  
   `speech_to_text` and microphone are used but `Info.plist` had no usage descriptions. Added:
   - `NSMicrophoneUsageDescription`
   - `NSSpeechRecognitionUsageDescription`  
   This avoids possible crashes or rejections when users use voice input on iOS.

---

## 🔴 Critical – Do Before Publishing

### 1. Ensure `.env` and signing files are not in git history

- If `.env` or `key.properties` / keystore files were ever committed, remove them from history and rotate any exposed keys (Supabase anon key, Google OAuth client IDs, etc.).
- Use `git status` and `git log` to confirm; consider `git filter-branch` or BFG if needed.

### 2. Production logging

- **`lib/services/auth_service.dart`** (and a few other files) use `print()` for deep links, OAuth, signup, errors, etc. In release builds these can show up in device logs and may leak URIs or error details.
- **Recommendation:** Replace `print()` with your existing `talker` and use a release check, e.g. only log when `kDebugMode` is true, or use a log level that is disabled in release. Keep only high-level, non-sensitive logs in production if any.

### 3. Android release build

- Release build expects `android/key.properties` with `keyAlias`, `keyPassword`, `storeFile`, `storePassword`. Create this file (see `docs/ANDROID_STUDIO_SETUP.md`) and **do not commit it**.
- Run:  
  `flutter build appbundle`  
  and fix any signing or build errors before submitting to Play Store.

### 4. Google Maps API key (Android)

- The key is in `android/app/src/main/AndroidManifest.xml`. In **Google Cloud Console**:
  - Restrict the key to **Android apps** and add your app’s package name (`com.myitihas.app`) and release keystore SHA-1.
  - Optionally create a separate key for release vs debug.
- This limits abuse if the key is ever exposed in the APK.

---

## 🟠 High Priority – Should Fix

### 1. Unfinished TODOs

| Location | TODO | Suggestion |
| -------- | ---- | ---------- |
| `settings_page.dart` | Implement upgrade plan | Either implement or hide/disable the “Upgrade Plan” tile for v1. |
| `group_profile_page.dart` | Navigate to profile | Implement navigation or remove the control. |
| `new_contact_page.dart` | Handle Groups button tap | Implement or hide for v1. |
| `post_detail_page.dart` | Handle this case (×2) | Replace with real handling or a clear fallback. |
| `chat_repository_impl.dart` | Phase 6 – delete messages older than 30 days | Document as future work or implement. |
| `api_client.dart` | Update with actual API URL / Add auth token | If this client is used in production, set the real base URL and add auth; otherwise remove or stub. |

### 2. `pubspec.yaml` description

- Current: `description: "A new Flutter project."`
- Update to a short, accurate description of MyItihas for store listings (and pub.dev if you ever publish the package).

### 3. Tests

- There is no `test/` directory. Adding a few smoke tests (e.g. app starts, main routes load) and critical-path tests will help catch regressions before each release.

---

## 🟡 Medium / Nice to Have

- **Talker in release:** `talker_setup.dart` already uses `kDebugMode` for log level (verbose in debug, error in release). Confirm you’re happy with what is logged in production (e.g. only errors).
- **iOS display name:** `Info.plist` has `CFBundleDisplayName` “Myitihas” and `CFBundleName` “myitihas”. Consider matching casing to your brand (e.g. “MyItihas”) if desired.
- **`avoid_print`:** `analysis_options.yaml` does not disable `avoid_print`. Running `flutter analyze` will flag remaining `print()` calls; replacing them with talker (or removing them) will clean this up.

---

## ✅ Already in Good Shape

- **Legal:** Privacy Policy and Terms & Conditions are linked from Settings (`legal_links.dart`); URLs (e.g. myitihas.com) resolve and show real content.
- **Android:** Release signing config present; minify and shrink resources enabled in `build.gradle.kts`.
- **iOS:** Deep links, Google URL scheme, background modes (e.g. remote-notification), and required usage descriptions (camera, location, photo library, and now microphone/speech) are set.
- **Config:** Supabase and Google OAuth are driven by env (Envied); no hardcoded app secrets in repo (aside from the Maps API key in the manifest, which is normal but should be restricted).
- **Version:** `pubspec.yaml` has a clear version (e.g. `1.0.0+1`).

---

## Checklist Before Submitting

- [ ] `.env` and `key.properties` / keystore are not in the repo or history; keys rotated if they were.
- [ ] All `print()` in production paths replaced or guarded (e.g. with talker + `kDebugMode`).
- [ ] `flutter build appbundle` and `flutter build ios` succeed; release signing is correct.
- [ ] Google Maps API key restricted (Android app + SHA-1).
- [ ] Upgrade plan / Groups / “Handle this case” either implemented or hidden for v1.
- [ ] `pubspec.yaml` description updated.
- [ ] Optional: add a few tests and run `flutter analyze` with zero issues.

Once these are done, the app is in a good state to publish to the stores.
