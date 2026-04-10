import 'package:myitihas/core/logging/talker_setup.dart';

/// Represents a parsed deep link for content routing
class DeepLinkRoute {
  final DeepLinkType type;
  final String contentId;
  final String? postType; // 'image', 'video', 'text' for posts

  const DeepLinkRoute({
    required this.type,
    required this.contentId,
    this.postType,
  });

  /// Convert to go_router compatible path
  String toRoutePath() {
    switch (type) {
      case DeepLinkType.post:
        final encodedId = Uri.encodeComponent(contentId);
        final typeQuery = postType != null ? '?postType=$postType' : '';
        return '/post/$encodedId$typeQuery';

      case DeepLinkType.story:
        final encodedId = Uri.encodeComponent(contentId);
        return '/home/stories/$encodedId';

      case DeepLinkType.video:
        final encodedId = Uri.encodeComponent(contentId);
        return '/post/$encodedId?postType=video';

      case DeepLinkType.group:
        final encodedCode = Uri.encodeComponent(contentId);
        return '/join-group-via-link/$encodedCode';

      case DeepLinkType.auth:
        return '/'; // Auth routes handled separately
    }
  }

  @override
  String toString() =>
      'DeepLinkRoute(type: $type, contentId: $contentId, postType: $postType)';
}

enum DeepLinkType { post, story, video, group, auth }

/// Service for parsing and routing deep links
/// Handles both HTTPS URLs (https://myitihas.com/post/{uuid})
/// and custom scheme URLs (myitihas://post/{uuid})
class DeepLinkService {
  static const Set<String> _supportedHttpsHosts = {
    'myitihas.com',
    'www.myitihas.com',
  };

  /// Parse a URI into a DeepLinkRoute
  /// Returns null if the URI cannot be parsed or is not a content link
  static DeepLinkRoute? parseDeepLink(Uri uri) {
    talker.debug('[DeepLinkService] Parsing URI: $uri');
    talker.debug(
      '[DeepLinkService] Scheme: ${uri.scheme}, Host: ${uri.host}, Path: ${uri.path}',
    );

    // Handle HTTPS URLs (Universal Links / App Links)
    if (uri.scheme == 'https' && _supportedHttpsHosts.contains(uri.host)) {
      return _parseHttpsDeepLink(uri);
    }

    // Handle custom scheme URLs (fallback)
    if (uri.scheme == 'myitihas') {
      return _parseCustomSchemeDeepLink(uri);
    }

    talker.debug('[DeepLinkService] Unknown URI type, ignoring');
    return null;
  }

  /// Parse HTTPS URLs like https://myitihas.com/post/{uuid}
  static DeepLinkRoute? _parseHttpsDeepLink(Uri uri) {
    final pathSegments = uri.pathSegments;

    if (pathSegments.isEmpty) {
      talker.debug('[DeepLinkService] HTTPS: No path segments');
      return null;
    }

    final contentType = pathSegments[0].toLowerCase();
    final contentId = _extractContentId(pathSegments);

    if (contentId == null || contentId.isEmpty) {
      talker.debug('[DeepLinkService] HTTPS: Missing content ID');
      return null;
    }

    talker.debug(
      '[DeepLinkService] HTTPS: contentType=$contentType, contentId=$contentId',
    );

    switch (contentType) {
      case 'post':
        return DeepLinkRoute(type: DeepLinkType.post, contentId: contentId);

      case 'story':
        return DeepLinkRoute(type: DeepLinkType.story, contentId: contentId);

      case 'video':
        return DeepLinkRoute(type: DeepLinkType.video, contentId: contentId);

      case 'group':
        return DeepLinkRoute(type: DeepLinkType.group, contentId: contentId);

      case 'posts':
        if (pathSegments.length > 2) {
          return DeepLinkRoute(
            type: DeepLinkType.post,
            contentId: pathSegments[2],
            postType: pathSegments[1].toLowerCase(),
          );
        }
        return null;

      case 'videos':
        return DeepLinkRoute(type: DeepLinkType.video, contentId: contentId);

      case 'stories':
        return DeepLinkRoute(type: DeepLinkType.story, contentId: contentId);

      case 'content':
        return DeepLinkRoute(type: DeepLinkType.post, contentId: contentId);

      default:
        talker.debug(
          '[DeepLinkService] HTTPS: Unknown content type: $contentType',
        );
        return null;
    }
  }

  static String? _extractContentId(List<String> pathSegments) {
    if (pathSegments.length < 2) {
      return null;
    }

    final head = pathSegments[0].toLowerCase();
    if (head == 'posts' && pathSegments.length > 2) {
      return pathSegments[2];
    }

    return pathSegments[1];
  }

  /// Parse custom scheme URLs like myitihas://post/{uuid}
  static DeepLinkRoute? _parseCustomSchemeDeepLink(Uri uri) {
    // For custom schemes, the host is the content type (post, story, video)
    // and the path contains the UUID
    final contentType = uri.host.toLowerCase();
    final pathSegments = uri.pathSegments;

    // Extract UUID from path or query
    // Format: myitihas://post?id={uuid} or myitihas://post/{uuid}
    String? contentId;

    // Try to get from query parameters first
    if (uri.queryParameters.containsKey('id')) {
      contentId = uri.queryParameters['id'];
    } else if (pathSegments.isNotEmpty) {
      contentId = pathSegments[0];
    }

    if (contentId == null || contentId.isEmpty) {
      talker.debug('[DeepLinkService] Custom scheme: Missing content ID');
      return null;
    }

    talker.debug(
      '[DeepLinkService] Custom scheme: contentType=$contentType, contentId=$contentId',
    );

    switch (contentType) {
      case 'post':
        return DeepLinkRoute(type: DeepLinkType.post, contentId: contentId);

      case 'story':
        return DeepLinkRoute(type: DeepLinkType.story, contentId: contentId);

      case 'video':
        return DeepLinkRoute(type: DeepLinkType.video, contentId: contentId);

      case 'group':
        return DeepLinkRoute(type: DeepLinkType.group, contentId: contentId);

      default:
        talker.debug(
          '[DeepLinkService] Custom scheme: Unknown content type: $contentType',
        );
        return null;
    }
  }
}
