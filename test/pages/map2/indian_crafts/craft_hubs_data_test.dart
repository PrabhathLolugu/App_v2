import 'package:flutter_test/flutter_test.dart';
import 'package:myitihas/pages/map2/indian_crafts/craft_hubs_data.dart';

void main() {
  test('craft fallback hubs are non-empty and uniquely keyed', () {
    expect(kAllCraftHubs, isNotEmpty);

    final ids = <String>{};
    final discussionIds = <String>{};
    for (final hub in kAllCraftHubs) {
      expect(hub.id, isNotEmpty);
      expect(hub.discussionSiteId, isNotEmpty);
      expect(ids.add(hub.id), isTrue);
      expect(discussionIds.add(hub.discussionSiteId), isTrue);
    }
  });

  test('craftHubById resolves known hub', () {
    final first = kAllCraftHubs.first;
    final found = craftHubById(first.id);
    expect(found, isNotNull);
    expect(found!.id, first.id);
  });
}
