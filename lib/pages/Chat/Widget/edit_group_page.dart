import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myitihas/core/widgets/voice_input/voice_input_button.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myitihas/utils/constants.dart';
import 'package:path/path.dart' as path;
import 'package:sizer/sizer.dart';
import 'package:myitihas/services/supabase_service.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show FileOptions;

class EditGroupPage extends StatefulWidget {
  final String conversationId;

  const EditGroupPage({super.key, required this.conversationId});

  @override
  State<EditGroupPage> createState() => _EditGroupPageState();
}

class _EditGroupPageState extends State<EditGroupPage> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _groupDescriptionController =
      TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final logger = getIt<Talker>();

  File? _selectedGroupImage;
  String? _currentAvatarUrl;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _avatarChanged = false;
  bool _removeAvatar = false;

  @override
  void initState() {
    super.initState();
    _loadGroupData();
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _groupDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadGroupData() async {
    try {
      final data = await SupabaseService.client
          .from('conversations')
          .select('group_name, group_description, group_avatar_url')
          .eq('id', widget.conversationId)
          .single();

      setState(() {
        _groupNameController.text = data['group_name'] ?? '';
        _groupDescriptionController.text = data['group_description'] ?? '';
        _currentAvatarUrl = data['group_avatar_url'];
        _isLoading = false;
      });
    } catch (e) {
      logger.error('Error loading group data', e);
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load group data: $e')),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedGroupImage = File(pickedFile.path);
          _avatarChanged = true;
          _removeAvatar = false;
        });
      }
    } catch (e) {
      logger.error('Error picking image', e);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
      }
    }
  }

  Future<void> _removeGroupIcon() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Group Icon'),
        content: const Text('Are you sure you want to remove the group icon?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _selectedGroupImage = null;
        _currentAvatarUrl = null;
        _avatarChanged = true;
        _removeAvatar = true;
      });
    }
  }

  Future<void> _saveChanges() async {
    final groupName = _groupNameController.text.trim();

    if (groupName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a group name')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      String? newAvatarUrl = _currentAvatarUrl;
      final currentUserId = SupabaseService.client.auth.currentUser?.id;

      // Handle avatar removal
      if (_removeAvatar) {
        // Delete old avatar if exists (best effort, do not block DB update).
        final oldObjectPath = _extractStoragePathFromPublicUrl(
          _currentAvatarUrl,
        );
        if (oldObjectPath != null) {
          try {
            await SupabaseService.client.storage.from('group_avatar').remove([
              oldObjectPath,
            ]);
            logger.debug('Deleted old avatar: $oldObjectPath');
          } catch (e) {
            logger.warning('Failed to delete old avatar', e);
          }
        }
        newAvatarUrl = null;
      }
      // Handle avatar update if changed
      else if (_avatarChanged && _selectedGroupImage != null) {
        if (currentUserId == null) {
          throw Exception('User must be authenticated to update group icon');
        }

        // Upload new avatar to a unique user-scoped key to avoid RLS/upsert conflicts.
        final extension = path
            .extension(_selectedGroupImage!.path)
            .replaceFirst('.', '')
            .toLowerCase();
        final safeExtension = extension.isEmpty ? 'jpg' : extension;
        final avatarPath =
            '$currentUserId/${widget.conversationId}/avatar_${DateTime.now().millisecondsSinceEpoch}.$safeExtension';
        await SupabaseService.client.storage
            .from('group_avatar')
            .upload(
              avatarPath,
              _selectedGroupImage!,
              fileOptions: const FileOptions(
                cacheControl: '3600',
                upsert: false,
              ),
            );

        // Get public URL
        newAvatarUrl = SupabaseService.client.storage
            .from('group_avatar')
            .getPublicUrl(avatarPath);
        logger.debug('Uploaded new avatar: $avatarPath');

        // Best effort cleanup of previous avatar object after successful upload.
        final oldObjectPath = _extractStoragePathFromPublicUrl(
          _currentAvatarUrl,
        );
        if (oldObjectPath != null && oldObjectPath != avatarPath) {
          try {
            await SupabaseService.client.storage.from('group_avatar').remove([
              oldObjectPath,
            ]);
            logger.debug('Deleted old avatar: $oldObjectPath');
          } catch (e) {
            logger.warning('Failed to delete old avatar', e);
          }
        }
      }

      // Update conversations table
      final updateResponse = await SupabaseService.client
          .from('conversations')
          .update({
            'group_name': groupName,
            'group_description': _groupDescriptionController.text.trim(),
            'group_avatar_url': newAvatarUrl,
          })
          .eq('id', widget.conversationId)
          .select();

      logger.info('Group updated successfully: $updateResponse');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Group updated successfully')),
        );
        context.pop(true); // Return true to indicate success
      }
    } catch (e) {
      logger.error('Error saving group changes', e);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save changes: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  String? _extractStoragePathFromPublicUrl(String? publicUrl) {
    if (publicUrl == null || publicUrl.isEmpty) return null;
    final marker = '/object/public/group_avatar/';
    final index = publicUrl.indexOf(marker);
    if (index < 0) return null;
    final objectPath = publicUrl.substring(index + marker.length);
    if (objectPath.isEmpty) return null;
    return Uri.decodeComponent(objectPath);
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color bgColor = isDark ? DarkColors.bgColor : LightColors.bgColor;
    Color textColor = isDark ? DarkColors.textPrimary : LightColors.textPrimary;
    Color subTextColor = isDark
        ? DarkColors.textSecondary
        : LightColors.textSecondary;
    Color accentColor = const Color(0xFF3B82F6);
    Color groupColor = const Color(0xFF8B5CF6);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 18.sp),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/chat');
              }
            },
          ),
          title: Text(
            'Edit Group',
            style: GoogleFonts.inter(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 18.sp),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Edit Group',
          style: GoogleFonts.inter(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 4.h),

                // Group Avatar with Camera Button
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 35.w,
                      height: 35.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: groupColor.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                    ),
                    _selectedGroupImage != null
                        ? Container(
                            width: 32.w,
                            height: 32.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                            child: ClipOval(
                              child: Image.file(
                                _selectedGroupImage!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : (_currentAvatarUrl != null &&
                              _currentAvatarUrl!.isNotEmpty)
                        ? Container(
                            width: 32.w,
                            height: 32.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                _currentAvatarUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildFallbackAvatar(groupColor);
                                },
                              ),
                            ),
                          )
                        : _buildFallbackAvatar(groupColor),

                    // Camera Button
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: accentColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: bgColor, width: 3),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 4.h),

                // Group Name Input
                TextField(
                  controller: _groupNameController,
                  style: GoogleFonts.inter(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Group Name',
                    suffixIcon: VoiceInputButton(
                      controller: _groupNameController,
                    ),
                    labelStyle: GoogleFonts.inter(color: subTextColor),
                    filled: true,
                    fillColor: isDark
                        ? DarkColors.glassBg
                        : Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                  ),
                ),

                SizedBox(height: 2.h),

                // Group Description Input
                TextField(
                  controller: _groupDescriptionController,
                  style: GoogleFonts.inter(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Description (Optional)',
                    suffixIcon: VoiceInputButton(
                      controller: _groupDescriptionController,
                    ),
                    labelStyle: GoogleFonts.inter(color: subTextColor),
                    filled: true,
                    fillColor: isDark
                        ? DarkColors.glassBg
                        : Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                  ),
                ),

                SizedBox(height: 2.h),

                // Remove Icon Button
                if (_currentAvatarUrl != null || _selectedGroupImage != null)
                  SizedBox(
                    width: double.infinity,
                    height: 6.h,
                    child: OutlinedButton.icon(
                      onPressed: _removeGroupIcon,
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red.shade400,
                      ),
                      label: Text(
                        'Remove Group Icon',
                        style: GoogleFonts.inter(
                          color: Colors.red.shade400,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red.shade400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                SizedBox(height: 2.h),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 6.h,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isSaving
                        ? SizedBox(
                            height: 20.sp,
                            width: 20.sp,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Save Changes',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                SizedBox(height: 3.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackAvatar(Color groupColor) {
    return Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: groupColor.withValues(alpha: 0.2),
        border: Border.all(color: Colors.white, width: 4),
      ),
      child: Center(
        child: Text(
          _groupNameController.text.isNotEmpty
              ? _groupNameController.text[0].toUpperCase()
              : 'G',
          style: GoogleFonts.inter(
            fontSize: 40.sp,
            fontWeight: FontWeight.bold,
            color: groupColor,
          ),
        ),
      ),
    );
  }
}
