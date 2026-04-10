import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:myitihas/core/widgets/media/media_editor_scaffold.dart';
import 'package:myitihas/i18n/strings.g.dart';

import 'post_image_crop_sheet.dart';

/// Result returned when user taps "Done" on the edit page.
class PostImageEditResult {
  const PostImageEditResult({
    required this.files,
    required this.aspectRatios,
  });
  final List<File> files;
  final List<double?> aspectRatios;
}

/// Full-screen image edit flow: crop (default square), aspect presets, rotate, remove.
/// Open after picking images; on Done, returns edited files and aspect ratios for the create post bloc.
class PostImageEditPage extends StatefulWidget {
  const PostImageEditPage({
    super.key,
    required this.initialFiles,
  });

  final List<File> initialFiles;

  /// Pushes the edit page and returns the result when user taps Done, or null if cancelled/empty.
  static Future<PostImageEditResult?> open(
    BuildContext context,
    List<File> files,
  ) async {
    if (files.isEmpty) return null;
    final result = await Navigator.of(context).push<PostImageEditResult>(
      MaterialPageRoute(
        builder: (context) => PostImageEditPage(initialFiles: files),
        fullscreenDialog: true,
      ),
    );
    return result;
  }

  @override
  State<PostImageEditPage> createState() => _PostImageEditPageState();
}

class _PostImageEditPageState extends State<PostImageEditPage> {
  late List<File> _files;
  late List<double?> _aspectRatios;
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _files = List.from(widget.initialFiles);
    _aspectRatios = List.filled(_files.length, null);
    _pageController = PageController();
    _hydrateInitialAspectRatios();
  }

  Future<void> _hydrateInitialAspectRatios() async {
    final ratios = <double?>[];
    for (final f in _files) {
      ratios.add(await getImageAspectRatio(f));
    }
    if (!mounted) return;
    setState(() {
      for (var i = 0; i < ratios.length && i < _aspectRatios.length; i++) {
        _aspectRatios[i] = ratios[i];
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _cropCurrentWithPreset(PostCropPreset preset) async {
    if (_currentIndex < 0 || _currentIndex >= _files.length) return;
    final file = _files[_currentIndex];
    String sourcePath = file.path;
    if (!File(sourcePath).existsSync() ||
        sourcePath.contains('/cache/') ||
        sourcePath.contains('content://')) {
      final tempDir = await getTemporaryDirectory();
      if (!mounted) return;
      final tempFile = File(
        '${tempDir.path}/post_edit_${_currentIndex}_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await tempFile.writeAsBytes(await file.readAsBytes());
      sourcePath = tempFile.path;
    }
    final result = await _cropWithPreset(sourcePath, preset);
    if (!mounted || result == null) return;
    final tempDir = await getTemporaryDirectory();
    final ownedFile = File(
      '${tempDir.path}/post_edited_${_currentIndex}_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await ownedFile.writeAsBytes(await result.file.readAsBytes());
    final ratio = result.aspectRatio ?? await getImageAspectRatio(ownedFile);
    setState(() {
      _files[_currentIndex] = ownedFile;
      _aspectRatios[_currentIndex] = ratio;
    });
  }

  Future<PostCropResult?> _cropWithPreset(
    String sourcePath,
    PostCropPreset preset,
  ) async {
    if (!mounted) return null;
    final cropTitle = t.social.createPost.cropPhoto;
    if (preset == PostCropPreset.free) {
      return cropPostImage(
        context: context,
        sourcePath: sourcePath,
        cropTitle: cropTitle,
        defaultAspectPreset: CropAspectRatioPreset.original,
      );
    }
    return cropPostImageWithAspect(
      context: context,
      sourcePath: sourcePath,
      preset: preset,
      cropTitle: cropTitle,
    );
  }

  void _removeCurrent() {
    if (_files.isEmpty) return;
    setState(() {
      _files.removeAt(_currentIndex);
      _aspectRatios.removeAt(_currentIndex);
      if (_currentIndex >= _files.length && _currentIndex > 0) {
        _currentIndex = _files.length - 1;
      }
      if (_files.isEmpty) {
        Navigator.of(context).pop(null);
      }
    });
  }

  Future<void> _done() async {
    HapticFeedback.mediumImpact();

    // Ensure aspect ratios are present even if user taps Done quickly.
    final outRatios = List<double?>.from(_aspectRatios);
    for (var i = 0; i < outRatios.length && i < _files.length; i++) {
      if (outRatios[i] != null) continue;
      outRatios[i] = await getImageAspectRatio(_files[i]);
    }
    if (!mounted) return;

    Navigator.of(context).pop(
      PostImageEditResult(files: List.from(_files), aspectRatios: outRatios),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_files.isEmpty) {
      return const Scaffold(
        body: SizedBox.shrink(),
      );
    }
    final colorScheme = Theme.of(context).colorScheme;

    return MediaEditorScaffold(
      title: t.social.createPost.editPhoto,
      subtitle: _files.length > 1
          ? '${_currentIndex + 1} / ${_files.length} • ${t.social.createPost.editPhotoSubtitle}'
          : t.social.createPost.editPhotoSubtitle,
      onClose: () => Navigator.of(context).pop(null),
      onDone: _done,
      onReset: () {
        HapticFeedback.lightImpact();
        setState(() {
          _files = List.from(widget.initialFiles);
          _aspectRatios = List.filled(_files.length, null);
          _currentIndex = 0;
          _pageController.jumpToPage(0);
        });
        _hydrateInitialAspectRatios();
      },
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPressStart: (_) => HapticFeedback.lightImpact(),
        child: PageView.builder(
          controller: _pageController,
          itemCount: _files.length,
          onPageChanged: (index) => setState(() => _currentIndex = index),
          itemBuilder: (context, index) {
            return _buildImagePage(_files[index], colorScheme);
          },
        ),
      ),
      bottomBar: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildEditToolbar(colorScheme),
          SizedBox(height: 8.h),
          _buildAspectPresets(colorScheme),
        ],
      ),
    );
  }

  Widget _buildImagePage(File file, ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 26,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18.r),
          child: Image.file(
            file,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildEditToolbar(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _EditToolButton(
          icon: Icons.crop_rounded,
          label: t.social.createPost.cropPhoto,
          colorScheme: colorScheme,
          onTap: () => _cropCurrentWithPreset(PostCropPreset.square),
        ),
        _EditToolButton(
          icon: Icons.rotate_right_rounded,
          label: t.social.createPost.rotate,
          colorScheme: colorScheme,
          onTap: () => _cropCurrentWithPreset(PostCropPreset.free),
        ),
        _EditToolButton(
          icon: Icons.delete_outline_rounded,
          label: t.social.createPost.removePhoto,
          colorScheme: colorScheme,
          onTap: _removeCurrent,
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildAspectPresets(ColorScheme colorScheme) {
    final presets = [
      (PostCropPreset.square, t.social.createPost.aspectSquare),
      (PostCropPreset.portrait, t.social.createPost.aspectPortrait),
      (PostCropPreset.landscape, t.social.createPost.aspectLandscape),
      (PostCropPreset.free, t.social.createPost.aspectFree),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          for (final (preset, label) in presets)
            Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: Material(
                color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(12.r),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12.r),
                  onTap: () => _cropCurrentWithPreset(preset),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EditToolButton extends StatelessWidget {
  const _EditToolButton({
    required this.icon,
    required this.label,
    required this.colorScheme,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final ColorScheme colorScheme;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? colorScheme.error : colorScheme.primary;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 24.sp, color: color),
              SizedBox(height: 4.h),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
