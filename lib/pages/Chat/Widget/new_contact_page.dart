// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:myitihas/core/widgets/voice_input/voice_input_button.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myitihas/utils/constants.dart';
import 'package:sizer/sizer.dart';

class NewContactPage extends StatefulWidget {
  const NewContactPage({super.key});

  @override
  State<NewContactPage> createState() => _NewContactPageState();
}

class _NewContactPageState extends State<NewContactPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final String _selectedCountryCode = "+91";

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color textColor = isDark ? DarkColors.textPrimary : LightColors.textPrimary;
    Color subTextColor = isDark
        ? DarkColors.textSecondary
        : LightColors.textSecondary;
    Color inputBg = isDark ? DarkColors.inputBg : LightColors.inputBg;
    Color borderColor = isDark
        ? DarkColors.glassBorder
        : LightColors.glassBorder;

    final accentColor = isDark
        ? DarkColors.accentPrimary
        : LightColors.accentPrimary;

    return Scaffold(
      backgroundColor: isDark ? DarkColors.bgColor : LightColors.bgColor,

      // 1. App Bar
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(6.h),
        child: Container(
          decoration: BoxDecoration(
            gradient: isDark
                ? DarkColors.featureCardGradient
                : LightColors.featureCardGradient,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).secondaryHeaderColor.withAlpha(50),
                blurRadius: 10,
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: textColor),
                    onPressed: () => context.pop(),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "New contact",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 18.sp,
                            foreground: Paint()
                              ..shader =
                                  (isDark
                                          ? DarkColors.messageUserGradient
                                          : LightColors.messageUserGradient)
                                      .createShader(
                                        Rect.fromLTWH(0, 0, 200, 70),
                                      ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search, color: accentColor),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // 2. Form Body
      body: Container(
        height: 100.h,
        width: 100.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              DarkColors.accentPrimary.withAlpha(5),
              isDark ? Color(0xFF1E293B) : Color(0xFFF1F5F9),
            ],
            transform: GradientRotation(3.14 / 1.5),
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(5.w),
          child: Column(
            children: [
              SizedBox(height: 2.h),

              // Icon Placeholder
              Center(
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? DarkColors.glassBg : Colors.grey.shade200,
                    border: Border.all(color: borderColor),
                  ),
                  child: Icon(
                    Icons.person_add_alt_1_rounded,
                    size: 25.sp,
                    color: subTextColor,
                  ),
                ),
              ),

              SizedBox(height: 4.h),

              // First Name Field
              _buildTextField(
                controller: _firstNameController,
                label: "First name",
                icon: Icons.person_outline,
                isDark: isDark,
                inputBg: inputBg,
                borderColor: borderColor,
                textColor: textColor,
                subTextColor: subTextColor,
              ),

              SizedBox(height: 2.5.h),

              // Last Name Field
              _buildTextField(
                controller: _lastNameController,
                label: "Last name",
                icon: Icons
                    .person_outline, // Optional: hide icon if you prefer cleaner look like image
                isDark: isDark,
                inputBg: inputBg,
                borderColor: borderColor,
                textColor: textColor,
                subTextColor: subTextColor,
              ),

              SizedBox(height: 2.5.h),

              // Phone Number Row
              Row(
                children: [
                  // Country Code
                  Container(
                    width: 28.w,
                    height: 6.h, // Match height with text field
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    decoration: BoxDecoration(
                      color: inputBg.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isDark
                            ? DarkColors.glassBorder
                            : LightColors.glassBorder,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          color: subTextColor,
                          size: 16.sp,
                        ),
                        Text(
                          _selectedCountryCode,
                          style: GoogleFonts.inter(
                            color: textColor,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(Icons.arrow_drop_down, color: subTextColor),
                      ],
                    ),
                  ),
                  SizedBox(width: 3.w),

                  // Phone Input
                  Expanded(
                    child: _buildTextField(
                      controller: _phoneController,
                      label: "Phone",
                      icon: null, // No icon inside, layout handles it
                      isDark: isDark,
                      inputBg: inputBg,
                      borderColor: borderColor,
                      textColor: textColor,
                      subTextColor: subTextColor,
                      inputType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.5.h),
              GestureDetector(
                onTap: () {
                  // TODO: Handle Groups button tap
                },

                child: Container(
                  width: 90.w,
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.w, // Wider horizontal padding for pill shape
                    vertical: 1.5.h, // Vertical padding
                  ),
                  decoration: BoxDecoration(
                    // Use your theme's gradient
                    gradient: isDark
                        ? DarkColors.messageUserGradient
                        : LightColors.messageUserGradient,
                    borderRadius: BorderRadius.circular(
                      30,
                    ), // Fully rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).primaryColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "Save",
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white, // White text on gradient
                        letterSpacing: 0.5,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    required bool isDark,
    required Color inputBg,
    required Color borderColor,
    required Color textColor,
    required Color subTextColor,
    TextInputType inputType = TextInputType.text,
  }) {
    return Container(
      height: 6.h, // Fixed height for consistency
      decoration: BoxDecoration(
        color: inputBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isDark ? DarkColors.glassBorder : LightColors.glassBorder,
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        style: GoogleFonts.inter(color: textColor, fontSize: 15.sp),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: subTextColor, fontSize: 15.sp),
          suffixIcon: VoiceInputButton(controller: controller),
          border: InputBorder.none,
          prefixIcon: icon != null
              ? Icon(icon, color: subTextColor, size: 16.sp)
              : null,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 2.h, // Centers text vertically
          ),
        ),
      ),
    );
  }
}
