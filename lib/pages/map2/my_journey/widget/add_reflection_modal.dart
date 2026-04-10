import 'package:flutter/material.dart';
import 'package:myitihas/core/widgets/voice_input/voice_input_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/pages/map2/widgets/custom_icon_widget.dart';
import 'package:myitihas/utils/constants.dart';
import 'package:sizer/sizer.dart';

/// Modal for adding a new reflection journal entry
class AddReflectionModal extends StatefulWidget {
  final Function(String title, String content, String siteName) onSave;

  const AddReflectionModal({super.key, required this.onSave});

  @override
  State<AddReflectionModal> createState() => _AddReflectionModalState();
}

class _AddReflectionModalState extends State<AddReflectionModal> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _siteNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  XFile? _selectedImage;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _siteNameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  void _saveReflection() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave(
        _titleController.text,
        _contentController.text,
        _siteNameController.text,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          t.map.addReflection,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        IconButton(
                          icon: CustomIconWidget(
                            iconName: 'close',
                            color: theme.colorScheme.onSurface,
                            size: 24,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),

                    // Title Field
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: t.map.reflectionTitle,
                        hintText: t.map.enterReflectionTitle,
                        suffixIcon: VoiceInputButton(controller: _titleController),
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'title',
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return t.map.pleaseEnterTitle;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 2.h),

                    // Site Name Field
                    TextFormField(
                      controller: _siteNameController,
                      decoration: InputDecoration(
                        labelText: t.map.siteName,
                        hintText: t.map.enterSacredSiteName,
                        suffixIcon: VoiceInputButton(controller: _siteNameController),
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'place',
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return t.map.pleaseEnterSiteName;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 2.h),

                    // Content Field
                    TextFormField(
                      controller: _contentController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'Reflection',
                        hintText: 'Share your thoughts and experiences...',
                        alignLabelWithHint: true,
                        suffixIcon: VoiceInputButton(controller: _contentController),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return t.map.pleaseEnterReflection;
                        }
                        return null;
                      },
                    ),

                    // Photo Attachment
                    SizedBox(height: 2.h),

                    Container(
                      height: 5.5.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: isDark
                            ? DarkColors.messageUserGradient
                            : LightColors.messageUserGradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: _saveReflection,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        icon: Icon(Icons.save, color: Colors.white, size: 20),
                        label: Text(
                          t.map.saveReflection,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
