import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/core/errors/exceptions.dart';
import 'package:myitihas/pages/map2/Model/sacred_location.dart';
import 'package:myitihas/pages/map2/widgets/custom_app_bar.dart';
import 'package:myitihas/services/post_service.dart';
import 'package:sizer/sizer.dart';

/// Dedicated page to post a travel story: one image + short description.
/// Optionally tagged with a sacred site (when opened from Plan page).
class PostTravelStoryPage extends StatefulWidget {
  const PostTravelStoryPage({super.key, this.destination});

  final SacredLocation? destination;

  @override
  State<PostTravelStoryPage> createState() => _PostTravelStoryPageState();
}

class _PostTravelStoryPageState extends State<PostTravelStoryPage> {
  final _descriptionController = TextEditingController();
  final _imagePicker = ImagePicker();
  File? _pickedImage;
  bool _isPosting = false;
  String? _error;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final xFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      if (xFile != null && mounted) {
        setState(() {
          _pickedImage = File(xFile.path);
          _error = null;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Could not pick image.');
      }
    }
  }

  Future<void> _submit() async {
    if (_pickedImage == null) {
      setState(() => _error = 'Please add a photo.');
      return;
    }

    setState(() {
      _error = null;
      _isPosting = true;
    });

    try {
      final postService = getIt<PostService>();
      final metadata = <String, dynamic>{
        'travel_story': true,
      };
      if (widget.destination != null) {
        metadata['sacred_site_id'] = widget.destination!.id;
        metadata['destination_name'] = widget.destination!.name;
      }

      await postService.createPost(
        postType: PostType.image,
        content: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        mediaFiles: [_pickedImage!],
        visibility: PostVisibility.public,
        metadata: metadata,
      );

      if (mounted) {
        context.go('/social-feed');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Travel story posted to feed'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } on AuthException catch (_) {
      if (mounted) {
        setState(() {
          _error = 'Please sign in to post.';
          _isPosting = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to post. Please try again.';
          _isPosting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradientExt = theme.extension<GradientExtension>();

    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Post your experience',
        variant: CustomAppBarVariant.withBack,
        onBackPressed: () => context.pop(),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: gradientExt?.screenBackgroundGradient ??
              LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.colorScheme.surface,
                  theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                ],
              ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Share a photo and short description from your pilgrimage.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 2.h),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _isPosting ? null : _pickImage,
                      child: Container(
                        height: 38.h,
                        decoration: BoxDecoration(
                          border: _pickedImage == null
                              ? Border.all(
                                  color: colorScheme.outline.withValues(alpha: 0.5),
                                  width: 2,
                                  strokeAlign: BorderSide.strokeAlignInside,
                                )
                              : null,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: _pickedImage == null
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 48,
                                      color: colorScheme.primary,
                                    ),
                                    SizedBox(height: 1.h),
                                    Text(
                                      'Add a photo from your visit',
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Text(
                                      'Tap to choose from gallery',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: colorScheme.outline,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.file(
                                    _pickedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    left: 8,
                                    right: 8,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Tap to change photo',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Describe your visit',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'A few lines about your experience...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
                enabled: !_isPosting,
              ),
              if (widget.destination != null) ...[
                SizedBox(height: 1.5.h),
                Row(
                  children: [
                    Icon(Icons.place, size: 18, color: colorScheme.primary),
                    SizedBox(width: 2.w),
                    Flexible(
                      child: Chip(
                        label: Text(
                          widget.destination!.name,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        backgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ],
              if (_error != null) ...[
                SizedBox(height: 1.5.h),
                Card(
                  color: colorScheme.errorContainer.withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: colorScheme.error.withValues(alpha: 0.5)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: colorScheme.error, size: 22),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            _error!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              SizedBox(height: 2.h),
              FilledButton(
                onPressed: _isPosting ? null : _submit,
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  minimumSize: Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isPosting
                    ? SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.colorScheme.onPrimary,
                        ),
                      )
                    : const Text('Share with community'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
