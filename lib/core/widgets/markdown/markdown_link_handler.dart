import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:myitihas/core/logging/talker_setup.dart';
import 'package:myitihas/i18n/strings.g.dart';

/// Utility class for handling markdown link taps.
///
/// - Internal paths (starting with `/`) are routed via GoRouter
/// - External URLs are opened via url_launcher
class MarkdownLinkHandler {
  const MarkdownLinkHandler._();

  /// Handle a link tap from markdown content.
  ///
  /// [context] - BuildContext for navigation
  /// [text] - The display text of the link
  /// [href] - The URL/path of the link
  /// [title] - Optional title attribute of the link
  static Future<void> handleLinkTap(
    BuildContext context,
    String text,
    String? href,
    String title,
  ) async {
    if (href == null || href.isEmpty) {
      talker.warning('MarkdownLinkHandler: Empty href for link "$text"');
      return;
    }

    // Handle internal paths (starting with /)
    if (href.startsWith('/')) {
      _handleInternalLink(context, href);
      return;
    }

    // Handle anchor links (starting with #)
    if (href.startsWith('#')) {
      talker.info('MarkdownLinkHandler: Anchor link "$href" - not implemented');
      return;
    }

    // Handle external URLs
    await _handleExternalLink(context, href);
  }

  /// Navigate to an internal route using GoRouter
  static void _handleInternalLink(BuildContext context, String path) {
    try {
      GoRouter.of(context).go(path);
    } catch (e, stackTrace) {
      talker.error(
        'MarkdownLinkHandler: Failed to navigate to "$path"',
        e,
        stackTrace,
      );
    }
  }

  /// Open an external URL using url_launcher
  static Future<void> _handleExternalLink(
    BuildContext context,
    String urlString,
  ) async {
    try {
      final uri = Uri.parse(urlString);

      if (!uri.hasScheme) {
        // Assume https if no scheme provided
        final httpsUri = Uri.parse('https://$urlString');
        await _launchUri(httpsUri);
        return;
      }

      await _launchUri(uri);
    } catch (e, stackTrace) {
      talker.error(
        'MarkdownLinkHandler: Failed to open URL "$urlString"',
        e,
        stackTrace,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(Translations.of(context).error.couldNotOpenLink(url: urlString)),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  static Future<void> _launchUri(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch $uri');
    }
  }
}
