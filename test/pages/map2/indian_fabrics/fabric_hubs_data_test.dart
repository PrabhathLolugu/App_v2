import 'package:flutter_test/flutter_test.dart';
import 'package:myitihas/pages/map2/indian_fabrics/fabric_hubs_data.dart';

void main() {
  test('fabric hub catalog has unique ids and discussion UUIDs', () {
    expect(kAllFabricHubs.length, greaterThanOrEqualTo(8));
    final ids = kAllFabricHubs.map((h) => h.id).toSet();
    expect(ids.length, kAllFabricHubs.length, reason: 'hub ids must be unique');
    final uuids = kAllFabricHubs.map((h) => h.discussionSiteId).toSet();
    expect(
      uuids.length,
      kAllFabricHubs.length,
      reason: 'discussion UUIDs must be unique',
    );
    expect(fabricHubById('kanchipuram_silk'), isNotNull);
    expect(fabricHubById('unknown'), isNull);
  });
}
