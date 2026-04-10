import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myitihas/core/widgets/voice_input/voice_input_button.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/core/navigation/home_back_stack.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/core/cache/managers/image_cache_manager.dart';
import 'package:myitihas/core/presentation/widgets/app_snackbar.dart';
import 'package:myitihas/core/utils/app_error_mapper.dart';
import 'package:myitihas/features/social/domain/repositories/user_repository.dart';
import 'package:myitihas/features/social/presentation/widgets/svg_avatar.dart';
import 'package:myitihas/i18n/strings.g.dart';

class EditProfilePage extends StatefulWidget {
  final String userId;
  final String currentDisplayName;
  final String currentBio;
  final String currentAvatarUrl;

  const EditProfilePage({
    super.key,
    required this.userId,
    required this.currentDisplayName,
    required this.currentBio,
    required this.currentAvatarUrl,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _displayNameController;
  late final TextEditingController _bioController;
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;
  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController(
      text: widget.currentDisplayName,
    );
    _bioController = TextEditingController(text: widget.currentBio);

    _displayNameController.addListener(_checkForChanges);
    _bioController.addListener(_checkForChanges);
  }

  void _checkForChanges() {
    final currentDisplayNameTrimmed = widget.currentDisplayName.trim();
    final currentBioTrimmed = widget.currentBio.trim();

    final newDisplayNameTrimmed = _displayNameController.text.trim();
    final newBioTrimmed = _bioController.text.trim();

    final hasChanges =
        newDisplayNameTrimmed != currentDisplayNameTrimmed ||
        newBioTrimmed != currentBioTrimmed ||
        _selectedImage != null;
    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _checkForChanges();
        });
      }
    } catch (e) {
      if (mounted) {
        final friendly = AppErrorMapper.getUserMessage(
          e,
          fallbackMessage:
              'We couldn\'t pick that image. Please try again.',
        );
        AppSnackBar.showError(
          context,
          t.social.editProfile.failedPickImage(error: friendly),
        );
      }
    }
  }

  Future<void> _saveChanges() async {
    final logger = getIt<Talker>();
    logger.info('💾 [UI] Save Changes initiated');

    if (_displayNameController.text.trim().isEmpty) {
      logger.warning('⚠️ [UI] Validation failed: Display name is empty');
      AppSnackBar.showError(context, t.social.editProfile.displayNameEmpty);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userRepository = getIt<UserRepository>();
      logger.debug('[UI] Display Name: ${_displayNameController.text.trim()}');
      logger.debug('[UI] Bio: ${_bioController.text.trim()}');
      logger.debug('[UI] Has selected image: ${_selectedImage != null}');

      String? uploadedAvatarUrl;

      // Step 1: Upload profile photo if user selected one
      if (_selectedImage != null) {
        logger.info('📸 [UI] Uploading selected photo...');
        final uploadResult = await userRepository.uploadProfilePhoto(
          userId: widget.userId,
          imageFile: _selectedImage!,
        );

        await uploadResult.fold(
          (failure) async {
            // Photo upload failed - show error but continue with other updates
            logger.error('❌ [UI] Photo upload failed: ${failure.message}');
            if (mounted) {
              final friendly = AppErrorMapper.getUserMessage(
                failure,
                fallbackMessage:
                    'We couldn\'t update your photo. You can try again later.',
              );
              AppSnackBar.showError(
                context,
                t.social.editProfile.failedUploadPhoto(error: friendly),
              );
            }
          },
          (avatarUrl) async {
            logger.info('✅ [UI] Photo uploaded successfully: $avatarUrl');
            uploadedAvatarUrl = avatarUrl;

            // Clear cache for old avatar URL to force refresh
            // IMPORTANT: Use ImageCacheManager.instance (same as SvgAvatar widget)
            if (widget.currentAvatarUrl.isNotEmpty) {
              logger.info(
                '🗑️ [UI] Clearing cache for old avatar: ${widget.currentAvatarUrl}',
              );
              await ImageCacheManager.instance.removeFile(
                widget.currentAvatarUrl,
              );
              await CachedNetworkImage.evictFromCache(widget.currentAvatarUrl);
            }
            // Also evict the new URL to ensure fresh load
            logger.info('🗑️ [UI] Clearing cache for new avatar: $avatarUrl');
            await ImageCacheManager.instance.removeFile(avatarUrl);
            await CachedNetworkImage.evictFromCache(avatarUrl);
          },
        );
      } else {
        logger.info('⏭️ [UI] No photo selected, skipping upload');
      }

      // Step 2: Update display name and bio
      logger.info('📝 [UI] Updating profile information...');
      final result = await userRepository.updateUserProfile(
        userId: widget.userId,
        displayName: _displayNameController.text.trim(),
        bio: _bioController.text.trim(),
      );

      result.fold(
        (failure) {
          logger.error('❌ [UI] Profile update failed: ${failure.message}');
          if (mounted) {
            final friendly = AppErrorMapper.getUserMessage(
              failure,
              fallbackMessage:
                  'We couldn\'t update your profile. Please try again.',
            );
            AppSnackBar.showError(
              context,
              t.social.editProfile.failedUpdateProfile(error: friendly),
            );
          }
        },
        (_) {
          logger.info('✅ [UI] Profile update successful');
          if (mounted) {
            final message = uploadedAvatarUrl != null
                ? t.social.editProfile.profileAndPhotoUpdated
                : t.social.editProfile.profileUpdated;
            logger.info('🎉 [UI] $message');
            AppSnackBar.showSuccess(context, message);
            context.pop(true); // Return true to indicate success
          }
        },
      );
    } catch (e) {
      logger.error('❌ [UI] Unexpected error in _saveChanges', e);
      if (mounted) {
        final friendly = AppErrorMapper.getUserMessage(
          e,
          fallbackMessage:
              'Something went wrong while saving your changes. Please try again.',
        );
        AppSnackBar.showError(
          context,
          t.social.editProfile.unexpectedError(error: friendly),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.social.editProfile.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => HomeBackStack.goBackOrHome(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Photo Section
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      // Avatar Display
                      _selectedImage != null
                          ? CircleAvatar(
                              radius: 60,
                              backgroundImage: FileImage(_selectedImage!),
                            )
                          : SvgAvatar(
                              imageUrl: widget.currentAvatarUrl,
                              radius: 60,
                              fallbackText: widget.currentDisplayName,
                            ),
                      // Edit Button Overlay
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: Theme.of(context)
                                .extension<GradientExtension>()!
                                .primaryButtonGradient,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.surface,
                              width: 3,
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: _isLoading ? null : _pickImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _isLoading ? null : _pickImage,
                    child: Text(
                      t.social.editProfile.changePhoto,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Display Name Field
            Text(
              t.social.editProfile.displayName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _displayNameController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                hintText: t.social.editProfile.displayNameHint,
                suffixIcon: VoiceInputButton(
                  controller: _displayNameController,
                ),
                filled: true,
                fillColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              maxLength: 50,
            ),
            const SizedBox(height: 24),

            // Bio Field
            Text(
              t.social.editProfile.bio,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _bioController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                hintText: t.social.editProfile.bioHint,
                suffixIcon: VoiceInputButton(controller: _bioController),
                filled: true,
                fillColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              maxLines: 5,
              maxLength: 150,
            ),
            const SizedBox(height: 32),

            // Save Button (alternative to app bar button)
            if (_hasChanges)
              SizedBox(
                width: double.infinity,
                height: 48,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: Theme.of(
                      context,
                    ).extension<GradientExtension>()!.primaryButtonGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            t.social.editProfile.saveChanges,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
          ],
        ),
      ),
      ),
    );
  }
}
