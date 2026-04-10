import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:google_fonts/google_fonts.dart';

/// Shared typography for chat-style message bodies (WhatsApp-like: Inter, regular, readable size).
abstract final class ChatMessageTypography {
  static const double fontSize = 15;
  static const double lineHeight = 1.38;
  static const double letterSpacing = 0.2;

  /// Sent bubble (tinted primaryContainer): use paired foreground.
  static Color outgoingMessageForeground(ColorScheme scheme) =>
      scheme.onPrimaryContainer;

  /// Received bubble: standard surface text.
  static Color incomingMessageForeground(ColorScheme scheme) =>
      scheme.onSurface;

  static TextStyle bodyStyle({
    required Color color,
    double? fontSizeValue,
    double? height,
    FontWeight? fontWeight,
  }) {
    return GoogleFonts.inter(
      color: color,
      fontWeight: fontWeight ?? FontWeight.w400,
      fontSize: fontSizeValue ?? fontSize,
      height: height ?? lineHeight,
      letterSpacing: letterSpacing,
    );
  }

  /// Markdown inside story-generator bot bubbles (`#111C33` / `#F1F5F9`).
  static MarkdownStyleSheet storyBotBubbleMarkdown({required bool isDark}) {
    final incomingFg =
        isDark ? const Color(0xFFE8E8E8) : const Color(0xFF1A1A1A);
    final muted =
        isDark ? const Color(0xFFB8C0D4) : const Color(0xFF475569);
    final base = GoogleFonts.inter(
      color: incomingFg,
      fontWeight: FontWeight.w400,
      fontSize: fontSize,
      height: lineHeight,
      letterSpacing: letterSpacing,
    );
    final linkColor =
        isDark ? const Color(0xFF7DD3FC) : const Color(0xFF0369A1);

    return MarkdownStyleSheet(
      p: base,
      strong: base.copyWith(fontWeight: FontWeight.w600),
      em: base.copyWith(fontStyle: FontStyle.italic),
      a: base.copyWith(
        color: linkColor,
        decoration: TextDecoration.underline,
        decorationColor: linkColor,
      ),
      listBullet: base.copyWith(color: muted),
      blockquote: base.copyWith(
        fontStyle: FontStyle.italic,
        color: muted,
      ),
      code: TextStyle(
        fontFamily: 'monospace',
        fontSize: 13,
        height: lineHeight,
        backgroundColor: isDark
            ? Colors.white.withValues(alpha: 0.12)
            : Colors.black.withValues(alpha: 0.08),
        color: incomingFg,
      ),
      blockquoteDecoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.35)
                : Colors.black.withValues(alpha: 0.18),
            width: 3,
          ),
        ),
      ),
      blockquotePadding: const EdgeInsets.fromLTRB(10, 4, 8, 4),
    );
  }

  /// Markdown on story user bubbles (cyan/purple gradient).
  static MarkdownStyleSheet storyUserBubbleMarkdownGradient() {
    const white = Colors.white;
    final base = GoogleFonts.inter(
      color: white,
      fontWeight: FontWeight.w400,
      fontSize: fontSize,
      height: lineHeight,
      letterSpacing: letterSpacing,
    );
    const linkColor = Color(0xFFE0F2FE);

    return MarkdownStyleSheet(
      p: base,
      strong: base.copyWith(fontWeight: FontWeight.w600),
      em: base.copyWith(fontStyle: FontStyle.italic),
      a: base.copyWith(
        color: linkColor,
        decoration: TextDecoration.underline,
        decorationColor: linkColor,
      ),
      listBullet: base.copyWith(color: Color(0xCCFFFFFF)),
      blockquote: base.copyWith(
        fontStyle: FontStyle.italic,
        color: Color(0xE6FFFFFF),
      ),
      code: TextStyle(
        fontFamily: 'monospace',
        fontSize: 13,
        height: lineHeight,
        backgroundColor: Colors.white.withValues(alpha: 0.22),
        color: white,
      ),
      blockquoteDecoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Colors.white.withValues(alpha: 0.55),
            width: 3,
          ),
        ),
      ),
      blockquotePadding: const EdgeInsets.fromLTRB(10, 4, 8, 4),
    );
  }

  /// Readable chapter narrative (aligns with site detail body density).
  static MarkdownStyleSheet storyChapterBodyMarkdown(ColorScheme scheme) {
    final base = GoogleFonts.inter(
      color: scheme.onSurface,
      fontWeight: FontWeight.w400,
      fontSize: 16,
      height: 1.5,
      letterSpacing: 0.25,
    );
    return MarkdownStyleSheet(
      p: base,
      strong: base.copyWith(fontWeight: FontWeight.w600),
      em: base.copyWith(fontStyle: FontStyle.italic),
      a: base.copyWith(
        color: scheme.primary,
        decoration: TextDecoration.underline,
        decorationColor: scheme.primary,
      ),
      listBullet: base.copyWith(color: scheme.primary),
      h1: base.copyWith(fontSize: 22, fontWeight: FontWeight.w600),
      h2: base.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
      h3: base.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
    );
  }
}
