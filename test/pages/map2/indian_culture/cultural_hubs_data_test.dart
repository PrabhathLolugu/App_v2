import 'package:flutter_test/flutter_test.dart';
import 'package:myitihas/pages/map2/indian_culture/cultural_hubs_data.dart';

void main() {
  test('fallback classical art hubs include 30+ state pins', () {
    expect(kClassicalArtStateHubs.length, greaterThanOrEqualTo(30));
    final stateCodes = kClassicalArtStateHubs.map((e) => e.stateCode).toSet();
    expect(stateCodes.length, kClassicalArtStateHubs.length);
  });

  test('fallback classical dance hubs include 30+ state pins', () {
    expect(kClassicalDanceStateHubs.length, greaterThanOrEqualTo(30));
    final stateCodes = kClassicalDanceStateHubs.map((e) => e.stateCode).toSet();
    expect(stateCodes.length, kClassicalDanceStateHubs.length);
  });

  test('discussion IDs are unique per category fallback', () {
    final artDiscussion = <String>{};
    for (final hub in kClassicalArtStateHubs) {
      for (final item in hub.items) {
        expect(item.discussionSiteId, isNotEmpty);
        expect(artDiscussion.add(item.discussionSiteId), isTrue);
      }
    }

    final danceDiscussion = <String>{};
    for (final hub in kClassicalDanceStateHubs) {
      for (final item in hub.items) {
        expect(item.discussionSiteId, isNotEmpty);
        expect(danceDiscussion.add(item.discussionSiteId), isTrue);
      }
    }
  });
}
