import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myitihas/core/presentation/widgets/app_snackbar.dart';
import 'package:myitihas/core/utils/app_error_mapper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/legal_links.dart';
import '../../services/auth_service.dart'
    show AuthServiceException, kMinPasswordLength, validateSignUpPassword;
import '../../services/supabase_service.dart';
import '../../utils/constants.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _hasAcceptedLegal = false;
  String? _emailServerError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      if (_autovalidateMode != AutovalidateMode.onUserInteraction) {
        setState(() {
          _autovalidateMode = AutovalidateMode.onUserInteraction;
        });
      }
      return;
    }

    if (!_hasAcceptedLegal) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please agree to the Terms & Conditions and Privacy Policy.',
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _emailServerError = null;
    });

    try {
      // Sign up using Supabase Auth
      final response = await SupabaseService.authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _nameController.text.trim(),
      );

      // Check if signup was accepted.
      // In email-confirmation flows Supabase typically returns session==null.
      final requiresEmailConfirmation = response.session == null;
      if (mounted) {
        if (requiresEmailConfirmation) {
          // Show message about email verification
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.email_outlined, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Account created! Please check your email to verify your account before signing in.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF1E1E1E),
              duration: const Duration(seconds: 6),
              behavior: SnackBarBehavior.floating,
            ),
          );

          // Navigate to login page since they need to verify email first
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted) {
            context.go('/login');
          }
        } else {
          // Email confirmation not required - user is logged in
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Account created successfully! Welcome!',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            ),
          );

          // GoRouter will automatically redirect to home
        }
      }
    } on AuthServiceException catch (e) {
      // Handle authentication-specific errors with user-friendly messaging
      if (mounted) {
        final rawMessage = e.message;
        final message = AppErrorMapper.getUserMessage(
          e,
          fallbackMessage:
              'We couldn\'t create your account. Please check your details and try again.',
        );
        if (_isDuplicateEmailError(rawMessage) ||
            _isDuplicateEmailError(message)) {
          setState(() {
            _emailServerError = message;
          });
          _formKey.currentState?.validate();
          AppSnackBar.showError(context, message);
        } else {
          AppSnackBar.showError(context, message);
        }
      }
    } on Exception catch (e) {
      // Handle other exceptions with friendly, non-technical text
      if (mounted) {
        final message = AppErrorMapper.getUserMessage(
          e,
          fallbackMessage:
              'We couldn\'t create your account. Please try again in a moment.',
        );
        AppSnackBar.showError(context, message);
      }
    } catch (_) {
      // Handle unexpected errors
      if (mounted) {
        AppSnackBar.showError(
          context,
          'Something went wrong while creating your account. Please try again.',
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

  Future<void> _openLegalLink(Uri uri, String label) async {
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && mounted) {
        _showLinkOpenError(label);
      }
    } catch (_) {
      if (mounted) {
        _showLinkOpenError(label);
      }
    }
  }

  void _showLinkOpenError(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Could not open $label right now. Please try again.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onEmailChanged() {
    if (_emailServerError == null) return;
    setState(() {
      _emailServerError = null;
    });
  }

  bool _isDuplicateEmailError(String message) {
    final lower = message.toLowerCase();
    return lower.contains('already exists') ||
        lower.contains('already registered') ||
        lower.contains('already in use') ||
        lower.contains('email') && lower.contains('exists') ||
        lower.contains('duplicate');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? DarkColors.textPrimary : LightColors.textPrimary;
    final backgroundColor = isDark ? DarkColors.bgColor : LightColors.bgColor;
    final inputBgColor = isDark ? DarkColors.inputBg : LightColors.inputBg;

    // Vibrant green color matching the image
    const signUpButtonColor = Color.fromRGBO(22, 162, 74, 1);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Center(
                    child: Text(
                      'Create Account',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Full Name field
                  Text(
                    'Full Name',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nameController,
                    style: GoogleFonts.inter(color: textColor, fontSize: 16),
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      prefixIcon: Icon(Iconsax.user),
                      filled: true,
                      fillColor: inputBgColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: textColor.withOpacity(0.6),
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: textColor.withOpacity(0.6),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: textColor.withOpacity(0.6),
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      hintText: 'Enter your full name',
                      hintStyle: GoogleFonts.inter(
                        color: textColor.withValues(alpha: 0.5),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),

                  // Email field
                  Text(
                    'Email',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    onChanged: (_) => _onEmailChanged(),
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.inter(color: textColor, fontSize: 16),
                    decoration: InputDecoration(
                      labelText: "E-mail",
                      prefixIcon: Icon(Iconsax.direct),
                      filled: true,
                      fillColor: inputBgColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: textColor.withOpacity(0.6),
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: textColor.withOpacity(0.6),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: textColor.withOpacity(0.6),
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      hintText: 'Enter your email',
                      hintStyle: GoogleFonts.inter(
                        color: textColor.withValues(alpha: 0.5),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Please enter a valid email';
                      }
                      if (_emailServerError != null) {
                        return _emailServerError;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),

                  // Password field
                  Text(
                    'Password',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'At least $kMinPasswordLength characters with one uppercase letter, one lowercase letter, one number, and one special character.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: textColor.withValues(alpha: 0.6),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: GoogleFonts.inter(
                      color: textColor.withOpacity(0.6),
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Iconsax.password_check),
                      filled: true,
                      fillColor: inputBgColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: textColor.withOpacity(0.6),
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: textColor.withOpacity(0.6),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: textColor.withOpacity(0.6),
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      hintText: 'Enter your password',
                      hintStyle: GoogleFonts.inter(
                        color: textColor.withValues(alpha: 0.5),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: textColor.withValues(alpha: 0.6),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      return validateSignUpPassword(
                        value ?? '',
                        emptyMessage: 'Please enter your password',
                        email: _emailController.text,
                        fullName: _nameController.text,
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Legal agreement checkbox
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _hasAcceptedLegal,
                        onChanged: _isLoading
                            ? null
                            : (value) {
                                setState(() {
                                  _hasAcceptedLegal = value ?? false;
                                });
                              },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Wrap(
                            children: [
                              Text(
                                'I agree to the ',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: textColor.withValues(alpha: 0.75),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _openLegalLink(
                                    LegalLinks.termsAndConditions,
                                    'Terms & Conditions',
                                  );
                                },
                                child: Text(
                                  'Terms & Conditions',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: signUpButtonColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                ' and ',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: textColor.withValues(alpha: 0.75),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _openLegalLink(
                                    LegalLinks.privacyPolicy,
                                    'Privacy Policy',
                                  );
                                },
                                child: Text(
                                  'Privacy Policy',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: signUpButtonColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                '.',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: textColor.withValues(alpha: 0.75),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Sign Up button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSignUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: signUpButtonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              'Sign Up',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Already have account text
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: textColor.withValues(alpha: 0.7),
                        ),
                        children: [
                          const TextSpan(text: 'Already have an account? '),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () {
                                context.go('/login');
                              },
                              child: Text(
                                'Log in',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: signUpButtonColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
