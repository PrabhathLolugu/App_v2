/// Utility for building shareable URLs for posts, stories, and videos
class ShareUrlBuilder {
  static const String _baseUrl = 'https://myitihas.com';

  /// Generate a shareable URL for a post
  /// Example: https://myitihas.com/post/{uuid}
  static String buildPostUrl(String postId) {
    return '$_baseUrl/post/$postId';
  }

  /// Generate a shareable URL for a story
  /// Example: https://myitihas.com/story/{uuid}
  static String buildStoryUrl(String storyId) {
    return '$_baseUrl/story/$storyId';
  }

  /// Generate a shareable URL for a video
  /// Example: https://myitihas.com/video/{uuid}
  static String buildVideoUrl(String videoId) {
    return '$_baseUrl/video/$videoId';
  }

  /// Generate a canonical share URL for any content type.
  static String buildContentUrl({
    required String contentId,
    required String contentType,
  }) {
    switch (contentType.toLowerCase()) {
      case 'story':
        return buildStoryUrl(contentId);
      case 'video':
        return buildVideoUrl(contentId);
      case 'post':
      case 'image':
      case 'text':
      default:
        return buildPostUrl(contentId);
    }
  }

  static bool _isLegacyContentPath(List<String> segments) {
    if (segments.isEmpty) return false;

    final head = segments.first.toLowerCase();
    if (head == 'content') {
      return segments.length > 1 && segments[1].isNotEmpty;
    }

    if (head == 'posts') {
      return segments.length > 2 &&
          ['image', 'text'].contains(segments[1].toLowerCase()) &&
          segments[2].isNotEmpty;
    }

    if (head == 'videos' || head == 'stories') {
      return segments.length > 1 && segments[1].isNotEmpty;
    }

    return false;
  }

  /// Validate if a URL is a valid MyItihas shareable URL
  static bool isValidShareableUrl(String url) {
    try {
      final uri = Uri.parse(url);
      if (uri.scheme != 'https' || uri.host != 'myitihas.com') {
        return false;
      }
      if (uri.pathSegments.isEmpty) return false;

      final contentType = uri.pathSegments[0];
      final contentId = uri.pathSegments.length > 1
          ? uri.pathSegments[1]
          : null;

      if (['post', 'story', 'video'].contains(contentType)) {
        return contentId != null && contentId.isNotEmpty;
      }

      return _isLegacyContentPath(uri.pathSegments);
    } catch (e) {
      return false;
    }
  }
}
