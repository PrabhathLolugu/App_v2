import 'package:flutter/material.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:permission_handler/permission_handler.dart';

/// System microphone prompt only (no settings UI). Use from layers without [BuildContext].
Future<bool> requestMicrophonePermission() async {
  var status = await Permission.microphone.status;
  if (status.isGranted) return true;
  if (!status.isPermanentlyDenied && !status.isRestricted) {
    status = await Permission.microphone.request();
  }
  return status.isGranted;
}

/// Requests the system microphone permission when needed. If access is still
/// not granted afterward, shows a dialog with an action to open app settings.
Future<bool> ensureMicrophonePermission(BuildContext context) async {
  final ok = await requestMicrophonePermission();
  if (ok) return true;
  if (!context.mounted) return false;
  await showMicrophonePermissionDeniedDialog(context);
  return false;
}

/// Explains that the microphone is off and offers to open system app settings.
Future<void> showMicrophonePermissionDeniedDialog(BuildContext context) async {
  final t = Translations.of(context);
  final opened = await showDialog<bool>(
    context: context,
    useRootNavigator: true,
    builder: (ctx) => AlertDialog(
      title: Text(t.voice.microphonePermissionRequired),
      content: Text(t.voice.microphonePermissionSettingsHint),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(t.voice.openDeviceSettings),
        ),
      ],
    ),
  );
  if (opened == true && context.mounted) {
    await openAppSettings();
  }
}
