import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Platform-aware bottom sheet widget that uses:
/// - CupertinoActionSheetAction on iOS
/// - MaterialActionChip on Android
class PlatformBottomSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    List<PlatformBottomSheetAction<T>> actions = const [],
    PlatformBottomSheetAction<T>? destructiveAction,
    PlatformBottomSheetAction<T>? cancelAction,
    bool isDismissible = true,
    Color? backgroundColor,
    ShapeBorder? shape,
  }) {
    if (Platform.isIOS) {
      return _showCupertinoBottomSheet<T>(
        context: context,
        title: title,
        actions: actions,
        destructiveAction: destructiveAction,
        cancelAction: cancelAction,
      );
    }
    return _showMaterialBottomSheet<T>(
      context: context,
      title: title,
      actions: actions,
      destructiveAction: destructiveAction,
      cancelAction: cancelAction,
      isDismissible: isDismissible,
      backgroundColor: backgroundColor,
      shape: shape,
    );
  }

  static Future<T?> _showCupertinoBottomSheet<T>({
    required BuildContext context,
    required String title,
    required List<PlatformBottomSheetAction<T>> actions,
    PlatformBottomSheetAction<T>? destructiveAction,
    PlatformBottomSheetAction<T>? cancelAction,
  }) {
    return showCupertinoModalPopup<T>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(title),
        actions: [
          ...actions.map(
            (action) => CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context, action.value);
              },
              isDefaultAction: action.isDefault,
              isDestructiveAction: action.isDestructive,
              child: Text(action.label),
            ),
          ),
          if (destructiveAction != null)
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context, destructiveAction.value);
              },
              isDestructiveAction: true,
              child: Text(destructiveAction.label),
            ),
        ],
        cancelButton: cancelAction != null
            ? CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context, cancelAction.value);
                },
                child: Text(cancelAction.label),
              )
            : null,
      ),
    );
  }

  static Future<T?> _showMaterialBottomSheet<T>({
    required BuildContext context,
    required String title,
    required List<PlatformBottomSheetAction<T>> actions,
    PlatformBottomSheetAction<T>? destructiveAction,
    PlatformBottomSheetAction<T>? cancelAction,
    bool isDismissible = true,
    Color? backgroundColor,
    ShapeBorder? shape,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      backgroundColor: backgroundColor,
      shape: shape,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(title, style: Theme.of(context).textTheme.titleLarge),
          ),
          ...actions.map(
            (action) => ListTile(
              onTap: () {
                Navigator.pop(context, action.value);
              },
              title: Text(action.label),
              textColor: action.isDefault
                  ? Theme.of(context).primaryColor
                  : null,
            ),
          ),
          if (destructiveAction != null)
            ListTile(
              onTap: () {
                Navigator.pop(context, destructiveAction.value);
              },
              title: Text(
                destructiveAction.label,
                style: TextStyle(color: Colors.red[600]),
              ),
            ),
          if (cancelAction != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                onTap: () {
                  Navigator.pop(context, cancelAction.value);
                },
                title: Text(
                  cancelAction.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Data class for bottom sheet action
class PlatformBottomSheetAction<T> {
  final String label;
  final T value;
  final bool isDefault;
  final bool isDestructive;

  PlatformBottomSheetAction({
    required this.label,
    required this.value,
    this.isDefault = false,
    this.isDestructive = false,
  });
}
