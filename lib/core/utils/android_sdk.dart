import 'dart:io';

/// Returns Android SDK int when available, otherwise null.
int? getAndroidSdkInt() {
  if (!Platform.isAndroid) return null;

  final version = Platform.operatingSystemVersion;
  final sdkMatch = RegExp(
    r'SDK\s*(\d+)',
    caseSensitive: false,
  ).firstMatch(version);
  if (sdkMatch != null) {
    return int.tryParse(sdkMatch.group(1)!);
  }

  // Fallback for variants like "Android 9" without explicit SDK marker.
  final androidMajor = RegExp(
    r'Android\s*(\d+)',
    caseSensitive: false,
  ).firstMatch(version);
  if (androidMajor == null) return null;

  final major = int.tryParse(androidMajor.group(1)!);
  if (major == null) return null;

  // Rough fallback mapping for old versions when SDK token is missing.
  if (major >= 13) return 33;
  if (major == 12) return 31;
  if (major == 11) return 30;
  if (major == 10) return 29;
  if (major == 9) return 28;
  if (major == 8) return 26;
  if (major == 7) return 24;
  if (major == 6) return 23;
  if (major == 5) return 21;

  return null;
}
