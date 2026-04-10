import 'package:flutter_test/flutter_test.dart';
import 'package:myitihas/pages/map2/indian_foods/food_hubs_data.dart';

void main() {
  test('fallback food hubs include 30+ state pins', () {
    expect(kFoodStateHubs.length, greaterThanOrEqualTo(30));
    final stateCodes = kFoodStateHubs.map((e) => e.stateCode).toSet();
    expect(stateCodes.length, kFoodStateHubs.length);
  });

  test('fallback food discussion IDs are unique', () {
    final discussionIds = <String>{};
    for (final hub in kFoodStateHubs) {
      for (final item in hub.items) {
        expect(item.discussionSiteId, isNotEmpty);
        expect(discussionIds.add(item.discussionSiteId), isTrue);
      }
    }
  });

  test('fallback foods avoid mughal-origin keyword entries', () {
    final forbidden = ['biryani', 'mughal', 'mughlai'];
    final names = kFoodStateHubs
        .expand((hub) => hub.items.map((item) => item.foodName.toLowerCase()))
        .toList(growable: false);

    for (final name in names) {
      for (final term in forbidden) {
        expect(name.contains(term), isFalse);
      }
    }
  });
}
