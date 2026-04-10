import 'package:flutter_test/flutter_test.dart';
import 'package:myitihas/core/logging/talker_setup.dart';
import 'package:myitihas/services/deep_link_service.dart';

void main() {
  setUpAll(initTalker);

  group('DeepLinkService post links', () {
    test('parses canonical HTTPS post links', () {
      final route = DeepLinkService.parseDeepLink(
        Uri.parse('https://myitihas.com/post/e8ac8fa5-9138-4d4a-873b-16c2bc0674bd'),
      );

      expect(route, isNotNull);
      expect(route!.type, DeepLinkType.post);
      expect(route.contentId, 'e8ac8fa5-9138-4d4a-873b-16c2bc0674bd');
      expect(
        route.toRoutePath(),
        '/post/e8ac8fa5-9138-4d4a-873b-16c2bc0674bd',
      );
    });

    test('parses legacy HTTPS post links with type segment', () {
      final route = DeepLinkService.parseDeepLink(
        Uri.parse(
          'https://myitihas.com/posts/image/e8ac8fa5-9138-4d4a-873b-16c2bc0674bd',
        ),
      );

      expect(route, isNotNull);
      expect(route!.type, DeepLinkType.post);
      expect(route.contentId, 'e8ac8fa5-9138-4d4a-873b-16c2bc0674bd');
      expect(route.postType, 'image');
      expect(
        route.toRoutePath(),
        '/post/e8ac8fa5-9138-4d4a-873b-16c2bc0674bd?postType=image',
      );
    });

    test('parses legacy content links', () {
      final route = DeepLinkService.parseDeepLink(
        Uri.parse('https://myitihas.com/content/e8ac8fa5-9138-4d4a-873b-16c2bc0674bd'),
      );

      expect(route, isNotNull);
      expect(route!.type, DeepLinkType.post);
      expect(route.contentId, 'e8ac8fa5-9138-4d4a-873b-16c2bc0674bd');
      expect(
        route.toRoutePath(),
        '/post/e8ac8fa5-9138-4d4a-873b-16c2bc0674bd',
      );
    });
  });

  group('DeepLinkService group links', () {
    test('parses HTTPS group invite links', () {
      final route = DeepLinkService.parseDeepLink(
        Uri.parse('https://myitihas.com/group/ABCD1234'),
      );

      expect(route, isNotNull);
      expect(route!.type, DeepLinkType.group);
      expect(route.contentId, 'ABCD1234');
      expect(route.toRoutePath(), '/join-group-via-link/ABCD1234');
    });

    test('parses custom-scheme group invite links', () {
      final route = DeepLinkService.parseDeepLink(
        Uri.parse('myitihas://group/ABCD1234'),
      );

      expect(route, isNotNull);
      expect(route!.type, DeepLinkType.group);
      expect(route.contentId, 'ABCD1234');
      expect(route.toRoutePath(), '/join-group-via-link/ABCD1234');
    });

    test('returns null for malformed group links', () {
      final route = DeepLinkService.parseDeepLink(
        Uri.parse('https://myitihas.com/group'),
      );

      expect(route, isNull);
    });
  });
}
