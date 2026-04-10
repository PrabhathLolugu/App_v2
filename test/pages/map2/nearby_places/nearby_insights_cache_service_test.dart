import 'package:flutter_test/flutter_test.dart';
import 'package:myitihas/pages/map2/nearby_places/nearby_insights_cache_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NearbyInsightsCacheService', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('stores and reads cached insight payloads', () async {
      final service = NearbyInsightsCacheService();
      const cacheKey = 'selected-1-radius-200-en-1-2-3';
      final payload = <String, dynamic>{
        'selectedSummary': 'Cached summary',
        'selectedBestTime': 'October to March',
        'nearby': [
          {
            'name': 'Temple A',
            'shortDescription': 'A sacred temple',
            'bestTimeToVisit': 'Winter',
            'pilgrimTips': 'Arrive early',
          },
        ],
      };

      await service.write(cacheKey, payload);

      final cached = await service.read(cacheKey);
      expect(cached, isNotNull);
      expect(cached!['selectedSummary'], 'Cached summary');
      expect(cached['nearby'], isA<List>());
    });

    test('expires cached payloads when ttl is exceeded', () async {
      final service = NearbyInsightsCacheService();
      const cacheKey = 'selected-1-radius-200-en-1-2-3';
      final payload = <String, dynamic>{
        'selectedSummary': 'Cached summary',
        'selectedBestTime': 'October to March',
        'nearby': const [],
      };

      await service.write(cacheKey, payload);

      final expired = await service.read(
        cacheKey,
        ttl: Duration.zero,
      );

      expect(expired, isNull);
    });
  });
}
