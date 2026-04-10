import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Creates platform-aware page routes for iOS and Android.
/// iOS uses CupertinoPageRoute for native slide-from-right transitions.
/// Android uses MaterialPageRoute for fade transitions.
abstract final class PlatformAwareRoutes {
  /// Navigate to page with platform-specific route transition
  static Route<T> to<T>(Widget page) {
    if (Platform.isIOS) {
      return CupertinoPageRoute<T>(builder: (_) => page);
    }
    return MaterialPageRoute<T>(builder: (_) => page);
  }

  /// Named route with platform-specific transition
  static Route<T> named<T>(
    String routeName, {
    Object? arguments,
    required Widget Function(BuildContext) builder,
  }) {
    if (Platform.isIOS) {
      return CupertinoPageRoute<T>(
        settings: RouteSettings(name: routeName, arguments: arguments),
        builder: builder,
      );
    }
    return MaterialPageRoute<T>(
      settings: RouteSettings(name: routeName, arguments: arguments),
      builder: builder,
    );
  }

  /// Dialog with platform-specific styling
  static Future<T?> showPlatformDialog<T>({
    required BuildContext context,
    required Widget Function(BuildContext) builder,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) {
    if (Platform.isIOS) {
      return showCupertinoDialog<T>(
        context: context,
        builder: builder,
        barrierDismissible: barrierDismissible,
      );
    }
    return showDialog<T>(
      context: context,
      builder: builder,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
    );
  }

  /// Modal bottom sheet with platform-specific animation
  static Future<T?> showPlatformModalBottomSheet<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    Color? barrierColor,
    bool isDismissible = true,
  }) {
    if (Platform.isIOS) {
      return showCupertinoModalPopup<T>(
        context: context,
        builder: builder,
        useRootNavigator: useRootNavigator,
        barrierColor: barrierColor ?? const Color.fromARGB(120, 0, 0, 0),
      );
    }
    return showModalBottomSheet<T>(
      context: context,
      builder: builder,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      barrierColor: barrierColor,
      isDismissible: isDismissible,
    );
  }
}
