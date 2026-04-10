import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myitihas/pages/map2/plan/booking_operator.dart';
import 'package:myitihas/pages/map2/plan/travel_booking_config.dart';
import 'package:myitihas/pages/map2/plan/travel_mode_extractor.dart';

void main() {
  group('TravelModeExtractor', () {
    test('detects multiple travel modes from plan text', () {
      const plan = '''
        Day 1: Take a train from Delhi to Varanasi.
        Day 2: Continue by bus to nearby temples.
        Day 3: Stay in a dharamshala and return by flight.
      ''';

      final modes = TravelModeExtractor.extractTravelModes(plan);

      expect(modes, contains(TravelMode.train));
      expect(modes, contains(TravelMode.bus));
      expect(modes, contains(TravelMode.flight));
      expect(modes, isNot(contains(TravelMode.car)));
    });

    test('detects hotel and car keywords', () {
      const plan = '''
        Stay in a hotel near the temple.
        Hire a cab or car rental for local travel.
      ''';

      final modes = TravelModeExtractor.extractTravelModes(plan);

      expect(modes, contains(TravelMode.hotel));
      expect(modes, contains(TravelMode.car));
    });

    test('returns empty list for blank text', () {
      expect(TravelModeExtractor.extractTravelModes('   '), isEmpty);
    });
  });

  group('TravelBookingConfig', () {
    test('provides operators for train and bus modes', () {
      final trainOperators = TravelBookingConfig.getOperatorsForMode(TravelMode.train);
      final busOperators = TravelBookingConfig.getOperatorsForMode(TravelMode.bus);

      expect(trainOperators.map((op) => op.id), contains('irctc'));
      expect(trainOperators.map((op) => op.id), contains('ixigo_train'));
      expect(busOperators.map((op) => op.id), contains('abhibus'));
      expect(busOperators.map((op) => op.id), contains('ixigo_bus'));
    });

    test('generates deep links with parameters', () {
      const operator = BookingOperator(
        id: 'irctc',
        name: 'IRCTC',
        travelMode: TravelMode.train,
        deepLinkTemplate: 'https://example.com/?from={from}&to={to}&date={date}',
        color: Color(0xFF4CAF50),
        icon: Icons.train,
      );

      final link = operator.generateDeepLink(
        from: 'Delhi',
        to: 'Varanasi',
        date: '2026-04-10',
      );

      expect(link, contains('from=Delhi'));
      expect(link, contains('to=Varanasi'));
      expect(link, contains('date=2026-04-10'));
    });
  });
}
