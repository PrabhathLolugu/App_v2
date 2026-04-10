/// Markdown rendering widgets for MyItihas.
///
/// This library provides themed markdown rendering with:
/// - [AppMarkdown] / [AppMarkdownBody] - Base markdown with app theming
/// - [ExpandableMarkdown] - Truncated markdown with read more/less
/// - [SanitizedMarkdown] - Restricted markdown for user-generated content
/// - [DropCapParagraphBuilder] - Custom first-paragraph drop cap styling
/// - [MarkdownLinkHandler] - Smart link handling (internal via GoRouter, external via url_launcher)
/// - [preprocessMarkdown] - Utility to normalize escaped newlines in markdown content
library;

export 'app_markdown.dart'
    show AppMarkdown, AppMarkdownBody, preprocessMarkdown;
export 'drop_cap_builder.dart';
export 'expandable_markdown.dart';
export 'markdown_link_handler.dart';
export 'sanitized_markdown.dart';
