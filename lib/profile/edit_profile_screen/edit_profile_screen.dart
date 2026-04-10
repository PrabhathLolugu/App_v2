import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myitihas/profile/edit_profile_screen/form_field_widget.dart';
import 'package:myitihas/profile/edit_profile_screen/profile_image_section_widget.dart';

import 'package:myitihas/pages/map2/widgets/custom_icon_widget.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

class EditProfile2Screen extends StatefulWidget {
  const EditProfile2Screen({super.key});

  @override
  State<EditProfile2Screen> createState() => _EditProfile2ScreenState();
}

class _EditProfile2ScreenState extends State<EditProfile2Screen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _bioController = TextEditingController();
  final _websiteController = TextEditingController();
  final _locationController = TextEditingController();

  String? _profileImagePath;
  bool _hasChanges = false;
  bool _isLoading = false;
  bool _isCheckingUsername = false;
  bool _isUsernameAvailable = true;

  // Mock current profile data
  final Map<String, dynamic> _currentProfile = {
    "username": "johndoe",
    "displayName": "John Doe",
    "bio":
        "Digital creator | Travel enthusiast | Coffee lover ☕\nSharing moments from around the world 🌍",
    "website": "https://johndoe.com",
    "location": "San Francisco, CA",
    "profileImage":
        "https://img.rocket.new/generatedImages/rocket_gen_img_1ad2903fa-1763293515114.png",
    "semanticLabel":
        "Professional headshot of a man with short brown hair wearing a blue button-up shirt against a neutral background",
  };

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _usernameController.addListener(_onUsernameChanged);
    _displayNameController.addListener(_onFieldChanged);
    _bioController.addListener(_onFieldChanged);
    _websiteController.addListener(_onFieldChanged);
    _locationController.addListener(_onFieldChanged);
  }

  void _loadProfileData() {
    _usernameController.text = _currentProfile["username"] as String;
    _displayNameController.text = _currentProfile["displayName"] as String;
    _bioController.text = _currentProfile["bio"] as String;
    _websiteController.text = _currentProfile["website"] as String;
    _locationController.text = _currentProfile["location"] as String;
  }

  void _onFieldChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = _checkForChanges();
      });
    }
  }

  void _onUsernameChanged() {
    _onFieldChanged();
    if (_usernameController.text != _currentProfile["username"]) {
      _checkUsernameAvailability();
    } else {
      setState(() {
        _isUsernameAvailable = true;
        _isCheckingUsername = false;
      });
    }
  }

  bool _checkForChanges() {
    return _usernameController.text != _currentProfile["username"] ||
        _displayNameController.text != _currentProfile["displayName"] ||
        _bioController.text != _currentProfile["bio"] ||
        _websiteController.text != _currentProfile["website"] ||
        _locationController.text != _currentProfile["location"] ||
        _profileImagePath != null;
  }

  Future<void> _checkUsernameAvailability() async {
    setState(() {
      _isCheckingUsername = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _isCheckingUsername = false;
      _isUsernameAvailable = _usernameController.text.length >= 3;
    });
  }

  Future<void> _showImageSourceActionSheet() async {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'camera_alt',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                title: Text('Take Photo', style: theme.textTheme.bodyLarge),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'photo_library',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                title: Text(
                  'Choose from Gallery',
                  style: theme.textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (_profileImagePath != null ||
                  _currentProfile["profileImage"] != null)
                ListTile(
                  leading: CustomIconWidget(
                    iconName: 'delete',
                    color: theme.colorScheme.error,
                    size: 24,
                  ),
                  title: Text(
                    'Remove Photo',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _removePhoto();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final permission = source == ImageSource.camera
          ? Permission.camera
          : Permission.photos;

      final status = await permission.request();

      if (!status.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Permission denied. Please enable ${source == ImageSource.camera ? 'camera' : 'photo'} access in settings.',
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
        return;
      }

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        await _cropImage(image.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image. Please try again.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _cropImage(String imagePath) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imagePath,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Profile Photo',
            toolbarColor: Theme.of(context).colorScheme.primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            hideBottomControls: false,
          ),
          IOSUiSettings(
            title: 'Crop Profile Photo',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          _profileImagePath = croppedFile.path;
          _hasChanges = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to crop image. Please try again.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _removePhoto() {
    setState(() {
      _profileImagePath = null;
      _hasChanges = true;
    });
  }

  Future<bool> _showDiscardDialog() async {
    final theme = Theme.of(context);
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Discard Changes?', style: theme.textTheme.titleLarge),
        content: Text(
          'You have unsaved changes. Are you sure you want to discard them?',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
            child: Text('Discard'),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_isUsernameAvailable) return;

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );

      context.pop();
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _displayNameController.dispose();
    _bioController.dispose();
    _websiteController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _showDiscardDialog();
        if (shouldPop && mounted) {
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(Translations.of(context).social.editProfile.title),
          leading: IconButton(
            icon: CustomIconWidget(
              iconName: 'close',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () async {
              if (!_hasChanges) {
                context.pop();
                return;
              }
              final shouldPop = await _showDiscardDialog();
              if (shouldPop && mounted) {
                context.pop();
              }
            },
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 2.w),
              child: TextButton(
                onPressed: (_hasChanges && !_isLoading && _isUsernameAvailable)
                    ? _saveProfile
                    : null,
                child: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.primary,
                          ),
                        ),
                      )
                    : Text(
                        'Save',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: (_hasChanges && _isUsernameAvailable)
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant.withValues(
                                  alpha: 0.5,
                                ),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  ProfileImageSectionWidget(
                    profileImagePath: _profileImagePath,
                    currentProfileImage:
                        _currentProfile["profileImage"] as String?,
                    semanticLabel: _currentProfile["semanticLabel"] as String,
                    onChangePhoto: _showImageSourceActionSheet,
                  ),
                  SizedBox(height: 4.h),
                  FormFieldWidget(
                    controller: _usernameController,
                    label: 'Username',
                    hint: 'Enter username',
                    prefixText: '@',
                    maxLength: 30,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username is required';
                      }
                      if (value.length < 3) {
                        return 'Username must be at least 3 characters';
                      }
                      if (!RegExp(r'^[a-zA-Z0-9_]+\$').hasMatch(value)) {
                        return 'Username can only contain letters, numbers, and underscores';
                      }
                      return null;
                    },
                    suffixWidget: _isCheckingUsername
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.primary,
                              ),
                            ),
                          )
                        : (_usernameController.text !=
                                  _currentProfile["username"] &&
                              _usernameController.text.isNotEmpty)
                        ? CustomIconWidget(
                            iconName: _isUsernameAvailable
                                ? 'check_circle'
                                : 'cancel',
                            color: _isUsernameAvailable
                                ? theme.colorScheme.primary
                                : theme.colorScheme.error,
                            size: 20,
                          )
                        : null,
                    helperText:
                        !_isUsernameAvailable &&
                            _usernameController.text !=
                                _currentProfile["username"]
                        ? 'Username is not available'
                        : null,
                  ),
                  SizedBox(height: 3.h),
                  FormFieldWidget(
                    controller: _displayNameController,
                    label: 'Display Name',
                    hint: 'Enter display name',
                    maxLength: 50,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Display name is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 3.h),
                  FormFieldWidget(
                    controller: _bioController,
                    label: 'Bio',
                    hint: 'Tell us about yourself',
                    maxLength: 150,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                  ),
                  SizedBox(height: 3.h),
                  FormFieldWidget(
                    controller: _websiteController,
                    label: 'Website',
                    hint: 'https://example.com',
                    keyboardType: TextInputType.url,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final urlPattern = RegExp(
                          r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)\$',
                        );
                        if (!urlPattern.hasMatch(value)) {
                          return 'Please enter a valid URL';
                        }
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 3.h),
                  FormFieldWidget(
                    controller: _locationController,
                    label: 'Location',
                    hint: 'City, Country',
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
