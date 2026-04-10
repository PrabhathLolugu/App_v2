import 'package:flutter_test/flutter_test.dart';
import 'package:myitihas/features/social/domain/utils/share_url_builder.dart';

void main() {
  group('ShareUrlBuilder', () {
    test('builds canonical post URLs', () {
      expect(
        ShareUrlBuilder.buildPostUrl('post-id'),
        'https://myitihas.com/post/post-id',
      );
    });

    test('builds canonical story URLs', () {
      expect(
        ShareUrlBuilder.buildStoryUrl('story-id'),
        'https://myitihas.com/story/story-id',
      );
    });

    test('builds canonical video URLs', () {
      expect(
        ShareUrlBuilder.buildVideoUrl('video-id'),
        'https://myitihas.com/video/video-id',
      );
    });

    test('buildContentUrl maps post-like content to canonical post URLs', () {
      expect(
        ShareUrlBuilder.buildContentUrl(
          contentId: 'abc',
          contentType: 'image',
        ),
        'https://myitihas.com/post/abc',
      );
      expect(
        ShareUrlBuilder.buildContentUrl(
          contentId: 'def',
          contentType: 'story',
        ),
        'https://myitihas.com/story/def',
      );
    });

    test('accepts legacy share URLs as valid during migration', () {
      expect(
        ShareUrlBuilder.isValidShareableUrl(
          'https://myitihas.com/posts/image/post-id',
        ),
        isTrue,
      );
      expect(
        ShareUrlBuilder.isValidShareableUrl(
          'https://myitihas.com/content/post-id',
        ),
        isTrue,
      );
    });
  });
}