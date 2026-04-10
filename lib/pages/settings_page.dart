import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:myitihas/utils/theme.dart';
import 'package:myitihas/services/auth_service.dart';
import 'package:myitihas/services/supabase_service.dart';
import 'package:myitihas/core/logging/talker_setup.dart';
import 'package:myitihas/repository/my_itihas_repository.dart';
import 'package:myitihas/core/cache/managers/image_cache_manager.dart';
import 'package:myitihas/core/cache/managers/video_cache_manager.dart';
import 'package:myitihas/core/cache/managers/audio_cache_manager.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/config/legal_links.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/services/downloaded_stories_service.dart';
import 'package:myitihas/features/home/domain/repositories/continue_reading_repository.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/core/utils/content_language.dart';
import 'package:myitihas/core/utils/locale_mapper.dart';

/// Display names for app locales (used in language dropdown)
const Map<AppLocale, String> _localeDisplayNames = {
  AppLocale.en: 'English',
  AppLocale.hi: 'हिन्दी',
  AppLocale.ta: 'தமிழ்',
  AppLocale.te: 'తెలుగు',
  AppLocale.bn: 'বাংলা',
  AppLocale.gu: 'ગુજરાતી',
  AppLocale.kn: 'ಕನ್ನಡ',
  AppLocale.ml: 'മലയാളം',
  AppLocale.mr: 'मराठी',
  AppLocale.or: 'ଓଡ଼ିଆ',
  AppLocale.pa: 'ਪੰਜਾਬੀ',
  AppLocale.sa: 'संस्कृत',
  AppLocale.as: 'অসমীয়া',
  AppLocale.ur: 'اردو',
};

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark ? const Color(0xFF0F0F0F) : Colors.white;
    final iconNeutral = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: scaffoldBg,
        title: Text(t.settings.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: iconNeutral),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Theme Section
            _buildSectionCard(
              context,
              icon: Icons.palette_outlined,
              title: t.settings.theme,
              children: [
                BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (context, themeState) {
                    final themeMode = themeState.followSystem
                        ? ThemeMode.system
                        : (themeState.isDark
                              ? ThemeMode.dark
                              : ThemeMode.light);
                    return Column(
                      children: [
                        RadioListTile<ThemeMode>(
                          value: ThemeMode.system,
                          groupValue: themeMode,
                          onChanged: (value) {
                            if (value != null) {
                              context.read<ThemeBloc>().add(
                                SetThemeMode(value),
                              );
                            }
                          },
                          secondary: Icon(
                            Icons.settings_suggest_outlined,
                            color: iconNeutral,
                          ),
                          title: Text(t.settings.themeSystem),
                          dense: true,
                        ),
                        RadioListTile<ThemeMode>(
                          value: ThemeMode.light,
                          groupValue: themeMode,
                          onChanged: (value) {
                            if (value != null) {
                              context.read<ThemeBloc>().add(
                                SetThemeMode(value),
                              );
                            }
                          },
                          secondary: Icon(
                            Icons.light_mode_outlined,
                            color: iconNeutral,
                          ),
                          title: Text(t.settings.themeLight),
                          dense: true,
                        ),
                        RadioListTile<ThemeMode>(
                          value: ThemeMode.dark,
                          groupValue: themeMode,
                          onChanged: (value) {
                            if (value != null) {
                              context.read<ThemeBloc>().add(
                                SetThemeMode(value),
                              );
                            }
                          },
                          secondary: Icon(
                            Icons.dark_mode_outlined,
                            color: iconNeutral,
                          ),
                          title: Text(t.settings.themeDark),
                          dense: true,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Language Section
            _buildSectionCard(
              context,
              icon: Icons.language_outlined,
              title: t.settings.language,
              children: [_buildLanguageTile(context, t)],
            ),
            const SizedBox(height: 16),

            // General Section (Notifications, Cache)
            _buildSectionCard(
              context,
              icon: Icons.tune_outlined,
              title: t.settings.general,
              children: [
                _buildListTile(
                  context,
                  icon: Icons.notifications_outlined,
                  title: t.settings.notifications,
                  useAltBackground: false,
                  onTap: () => const NotificationRoute().push(context),
                ),
                _buildDivider(),
                _buildListTile(
                  context,
                  icon: Icons.storage_outlined,
                  title: t.settings.cacheSettings,
                  useAltBackground: true,
                  onTap: () => const CacheSettingsRoute().push(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Help & Support Section
            _buildSectionCard(
              context,
              icon: Icons.help_outline_outlined,
              title: t.settings.helpSupport,
              children: [
                _buildListTile(
                  context,
                  icon: Icons.mail_outline,
                  title: t.settings.contactUs,
                  useAltBackground: false,
                  onTap: _handleContactUs,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Legal Section
            _buildSectionCard(
              context,
              icon: Icons.description_outlined,
              title: t.settings.legal,
              children: [
                _buildListTile(
                  context,
                  icon: Icons.privacy_tip_outlined,
                  title: t.settings.privacyPolicy,
                  useAltBackground: false,
                  onTap: () => _openLegalLink(
                    LegalLinks.privacyPolicy,
                    t.settings.privacyPolicy,
                  ),
                ),
                _buildDivider(),
                _buildListTile(
                  context,
                  icon: Icons.gavel_outlined,
                  title: t.settings.termsConditions,
                  useAltBackground: true,
                  onTap: () => _openLegalLink(
                    LegalLinks.termsAndConditions,
                    t.settings.termsConditions,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Account Section
            _buildSectionCard(
              context,
              icon: Icons.person_outline,
              title: t.settings.account,
              children: [
                _buildListTile(
                  context,
                  icon: Icons.download_done_rounded,
                  title: t.settings.downloadedStories,
                  useAltBackground: false,
                  onTap: () => const DownloadedStoriesRoute().push(context),
                ),
                _buildDivider(),
                _buildListTile(
                  context,
                  icon: Icons.block_outlined,
                  title: t.settings.blockedUsers,
                  useAltBackground: true,
                  onTap: () => const BlockedUsersRoute().push(context),
                ),
                _buildDivider(),
                _buildListTile(
                  context,
                  icon: Icons.delete_forever_outlined,
                  title: t.settings.deleteAccount,
                  useAltBackground: false,
                  onTap: _handleDeleteAccount,
                  isDestructive: true,
                ),
                _buildDivider(),
                _buildListTile(
                  context,
                  icon: Icons.logout_outlined,
                  title: t.settings.logout,
                  useAltBackground: true,
                  onTap: _handleLogout,
                  isDestructive: true,
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Future<void> _handleContactUs() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'myitihas@gmail.com',
      query: 'subject=Support Request&body=Hello MyItihas Team,',
    );
    try {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        final t = Translations.of(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t.settings.couldNotOpenEmail)));
      }
    }
  }

  Widget _buildLanguageTile(BuildContext context, Translations t) {
    final currentLocale = LocaleSettings.currentLocale;
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(
        Icons.language_outlined,
        color: colorScheme.onSurface,
      ),
      title: Text(
        t.settings.selectLanguage,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      trailing: DropdownButton<AppLocale>(
        value: currentLocale,
        underline: const SizedBox(),
        items: AppLocale.values.map((locale) {
          return DropdownMenuItem<AppLocale>(
            value: locale,
            child: Text(_localeDisplayNames[locale] ?? locale.languageCode),
          );
        }).toList(),
        onChanged: (locale) async {
          if (locale != null) {
            await LocaleSettings.setLocale(locale);
            // Keep content generation/chat language in sync with selected app language.
            await ContentLanguageSettings.setCurrentLanguage(
              storyLanguageFromAppLocale(locale),
            );
            // Persist so language is retained after app restart (BG_16).
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('app_locale', locale.languageCode);
            if (mounted) setState(() {});
          }
        },
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sectionBg = isDark ? const Color(0xFF121212) : Colors.white;
    final iconNeutral = isDark ? Colors.white : Colors.black87;

    return Container(
      decoration: BoxDecoration(
        color: sectionBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white24 : Colors.black12,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, size: 22, color: iconNeutral),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
    bool useAltBackground = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final neutralColor = isDark ? Colors.white : Colors.black87;
    final tileBackground = isDark
        ? (useAltBackground
              ? const Color(0xFF181818)
              : const Color(0xFF141414))
        : (useAltBackground
              ? const Color(0xFFF3F3F3)
              : const Color(0xFFFFFFFF));
    final color = isDestructive
        ? Colors.red
        : neutralColor;

    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: tileBackground,
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: isDestructive ? Colors.red : null,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: isDestructive
            ? Colors.red.withValues(alpha: 0.8)
            : neutralColor.withValues(alpha: 0.75),
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, indent: 56, endIndent: 16);
  }

  Future<void> _openLegalLink(Uri uri, String label) async {
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && mounted) {
        final t = Translations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.settings.couldNotOpenLabel(label: label))),
        );
      }
    } catch (_) {
      if (mounted) {
        final t = Translations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.settings.couldNotOpenLabel(label: label))),
        );
      }
    }
  }

  // ============================================================================
  // Delete Account Flow
  // ============================================================================

  void _handleDeleteAccount() {
    final authService = SupabaseService.authService;
    if (!authService.isAuthenticated()) return;

    _showWarningDialog();
  }

  /// Step 1: Warning dialog explaining what will be deleted
  void _showWarningDialog() {
    final t = Translations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.red),
            const SizedBox(width: 8),
            Text(t.settings.deleteAccountTitle),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.settings.deleteAccountWarning,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 12),
            Text(t.settings.deleteAccountDescription),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t.common.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              final provider = SupabaseService.authService.getAuthProvider();
              if (provider == 'google' || provider == 'apple') {
                // For Google sign-in users we already have a valid OAuth session.
                // Skip the extra "Verify your identity" Google dialog and go
                // straight to final confirmation + deletion flow.
                _showFinalConfirmationDialog();
              } else {
                _showPasswordDialog();
              }
            },
            child: Text(
              t.settings.continueLabel,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  /// Step 2a: Password re-entry dialog for email/password users
  void _showPasswordDialog() {
    final t = Translations.of(context);
    final passwordController = TextEditingController();
    bool isLoading = false;
    String? errorText;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(t.settings.confirmPassword),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(t.settings.confirmPasswordDesc),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                enabled: !isLoading,
                decoration: InputDecoration(
                  labelText: t.auth.password,
                  border: const OutlineInputBorder(),
                  errorText: errorText,
                ),
                onSubmitted: (_) async {
                  if (passwordController.text.isEmpty) return;
                  setDialogState(() {
                    isLoading = true;
                    errorText = null;
                  });
                  await _verifyPasswordAndConfirm(
                    passwordController.text,
                    context,
                    setDialogState,
                    (msg) => setDialogState(() {
                      isLoading = false;
                      errorText = msg;
                    }),
                  );
                },
              ),
              if (isLoading) ...[
                const SizedBox(height: 16),
                const CircularProgressIndicator(),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
              child: Text(t.common.cancel),
            ),
            TextButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      if (passwordController.text.isEmpty) {
                        setDialogState(
                          () => errorText = t.settings.passwordRequired,
                        );
                        return;
                      }
                      setDialogState(() {
                        isLoading = true;
                        errorText = null;
                      });
                      await _verifyPasswordAndConfirm(
                        passwordController.text,
                        context,
                        setDialogState,
                        (msg) => setDialogState(() {
                          isLoading = false;
                          errorText = msg;
                        }),
                      );
                    },
              child: Text(
                t.settings.verify,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Verify password and show final confirmation
  Future<void> _verifyPasswordAndConfirm(
    String password,
    BuildContext dialogContext,
    StateSetter setDialogState,
    void Function(String) onError,
  ) async {
    try {
      final user = SupabaseService.authService.getCurrentUser();
      if (user?.email == null) {
        onError(Translations.of(dialogContext).settings.unableToVerifyIdentity);
        return;
      }

      await SupabaseService.authService.reauthenticateWithPassword(
        email: user!.email!,
        password: password,
      );

      // Close password dialog
      if (dialogContext.mounted) Navigator.pop(dialogContext);

      // Show final confirmation
      if (mounted) _showFinalConfirmationDialog();
    } catch (e) {
      talker.error('[DeleteAccount] Password verification failed', e);
      if (dialogContext.mounted) {
        onError(Translations.of(dialogContext).settings.invalidPassword);
      }
    }
  }

  /// Step 3: Final confirmation dialog
  void _showFinalConfirmationDialog() {
    final t = Translations.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(t.settings.finalConfirmationTitle),
        content: Text(t.settings.finalConfirmation),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(t.common.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _executeAccountDeletion();
            },
            child: Text(
              t.settings.deleteMyAccount,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Execute the actual account deletion
  Future<void> _executeAccountDeletion() async {
    // Show loading overlay
    if (mounted) {
      final t = Translations.of(context);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => PopScope(
          canPop: false,
          child: AlertDialog(
            content: Row(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 16),
                Text(t.settings.deletingAccount),
              ],
            ),
          ),
        ),
      );
    }

    try {
      await SupabaseService.authService.deleteAccount();

      // Clean up local data (best-effort)
      await _cleanupLocalData();

      talker.info('[DeleteAccount] Account deleted successfully');

      // Close loading dialog
      if (mounted) Navigator.pop(context);

      // Sign out to clear local session (auth user already deleted server-side)
      try {
        await SupabaseService.authService.signOut();
      } catch (_) {
        // Session may already be invalid - that's fine
      }

      // Show in-app account-deleted page (clear status + app info, no web page)
      if (mounted) {
        context.go('/account-deleted');
      }
    } on AuthServiceException catch (e) {
      talker.error('[DeleteAccount] Deletion failed: ${e.message}', e);

      if (mounted) Navigator.pop(context);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (e) {
      talker.error('[DeleteAccount] Deletion failed', e);

      if (mounted) Navigator.pop(context);
      if (mounted) {
        final t = Translations.of(context);
        final fallbackMessage = t.settings.deleteAccountFailed;
        final message = e is AuthServiceException ? e.message : fallbackMessage;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }

  /// Clean up local data after account deletion
  Future<void> _cleanupLocalData() async {
    try {
      await MyItihasRepository.instance.clearOfflineQueue();
      await getIt<ContinueReadingRepository>().clearContinueReading();
    } catch (e) {
      talker.warning('[DeleteAccount] Failed to clear offline queue: $e');
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      talker.warning('[DeleteAccount] Failed to clear SharedPreferences: $e');
    }

    try {
      await ImageCacheManager.instance.emptyCache();
    } catch (e) {
      talker.warning('[DeleteAccount] Failed to clear image cache: $e');
    }

    try {
      await VideoCacheManager.instance.emptyCache();
    } catch (e) {
      talker.warning('[DeleteAccount] Failed to clear video cache: $e');
    }

    try {
      await AudioCacheManager.instance.emptyCache();
    } catch (e) {
      talker.warning('[DeleteAccount] Failed to clear audio cache: $e');
    }

    try {
      await DownloadedStoriesService().clearAllDownloadedStories();
    } catch (e) {
      talker.warning('[DeleteAccount] Failed to clear downloaded stories: $e');
    }
  }

  // ============================================================================
  // Logout
  // ============================================================================

  void _handleLogout() {
    final authService = SupabaseService.authService;

    if (authService.isAuthenticated()) {
      final t = Translations.of(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(t.settings.logoutTitle),
          content: Text(t.settings.logoutConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(t.common.cancel),
            ),
            TextButton(
              onPressed: () async {
                // Close dialog first
                Navigator.pop(context);

                // Call signOut - GoRouter redirect handles navigation
                // When session becomes null, GoRouter redirects to /login
                await DownloadedStoriesService().clearAllDownloadedStories();
                await getIt<ContinueReadingRepository>().clearContinueReading();
                await authService.signOut();
              },
              child: Text(
                t.settings.logout,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );
    }
  }
}
