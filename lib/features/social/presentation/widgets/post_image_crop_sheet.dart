import 'dart:io';

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

/// Presets for post image cropping. Values match feed display options.
enum PostCropPreset {
  square(1.0, CropAspectRatioPreset.square, 1, 1),
  portrait(4 / 5, CropAspectRatioPreset.ratio5x4, 4, 5), // 4:5 portrait
  landscape(16 / 9, CropAspectRatioPreset.ratio16x9, 16, 9),
  free(0, CropAspectRatioPreset.original, 0, 0);

  const PostCropPreset(this.ratio, this.preset, this.ratioX, this.ratioY);
  final double ratio;
  final CropAspectRatioPreset preset;
  final int ratioX;
  final int ratioY;
  bool get isLocked => this != PostCropPreset.free;
}

/// Result of cropping an image for a post.
class PostCropResult {
  const PostCropResult({required this.file, this.aspectRatio});
  final File file;
  final double? aspectRatio;
}

/// Opens the image cropper for a post image with aspect presets.
/// [defaultAspectPreset] defaults to [CropAspectRatioPreset.original] so posts keep their original ratio (Instagram-like).
/// Returns the cropped file and optional aspect ratio (from preset), or null if cancelled.
Future<PostCropResult?> cropPostImage({
  required BuildContext context,
  required String sourcePath,
  String? cropTitle,
  CropAspectRatioPreset defaultAspectPreset = CropAspectRatioPreset.original,
}) async {
  // Capture theme and strings before any async work so we never use context after await.
  final theme = Theme.of(context);
  final title = cropTitle ?? 'Crop photo';

  try {
    final cropped = await ImageCropper().cropImage(
      sourcePath: sourcePath,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: title,
          toolbarColor: theme.colorScheme.primary,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: defaultAspectPreset,
          lockAspectRatio: false,
          hideBottomControls: false,
        ),
        IOSUiSettings(
          title: title,
          aspectRatioLockEnabled: false,
          resetAspectRatioEnabled: true,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
            CropAspectRatioPreset.original,
          ],
        ),
      ],
    );

    if (cropped == null) return null;

    final file = File(cropped.path);
    if (!file.existsSync()) return null;

    return PostCropResult(file: file, aspectRatio: null);
  } catch (_) {
    return null;
  }
}

/// Crops with a fixed aspect ratio (e.g. from preset chips in UI).
Future<PostCropResult?> cropPostImageWithAspect({
  required BuildContext context,
  required String sourcePath,
  required PostCropPreset preset,
  String? cropTitle,
}) async {
  if (preset == PostCropPreset.free) {
    return cropPostImage(context: context, sourcePath: sourcePath, cropTitle: cropTitle);
  }

  final theme = Theme.of(context);
  final title = cropTitle ?? 'Crop photo';

  try {
    final cropped = await ImageCropper().cropImage(
    sourcePath: sourcePath,
    aspectRatio: CropAspectRatio(ratioX: preset.ratioX.toDouble(), ratioY: preset.ratioY.toDouble()),
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: title,
        toolbarColor: theme.colorScheme.primary,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: preset.preset,
        lockAspectRatio: true,
        hideBottomControls: false,
      ),
      IOSUiSettings(
        title: title,
        aspectRatioLockEnabled: true,
        resetAspectRatioEnabled: false,
      ),
    ],
  );

    if (cropped == null) return null;

    final file = File(cropped.path);
    if (!file.existsSync()) return null;

    return PostCropResult(file: file, aspectRatio: preset.ratio);
  } catch (_) {
    return null;
  }
}

/// Computes aspect ratio (width / height) of an image file. Returns null on failure.
Future<double?> getImageAspectRatio(File file) async {
  try {
    final bytes = await file.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;
    if (image.width > 0 && image.height > 0) {
      return image.width / image.height;
    }
  } catch (_) {}
  return null;
}
