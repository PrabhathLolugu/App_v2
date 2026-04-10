import 'package:myitihas/pages/map2/plan/booking_operator.dart';

/// Utility to extract/detect travel modes from plan text
class TravelModeExtractor {
  /// Keywords that indicate each travel mode
  static const Map<TravelMode, List<String>> keywordsByMode = {
    TravelMode.train: [
      'train',
      'railway',
      'irctc',
      'rails',
      'gauge',
      'locomot',
      'express',
      'passenger train',
      'freight train',
      'metro',
      'tube',
      'rail journey',
    ],
    TravelMode.flight: [
      'flight',
      'fly',
      'airline',
      'airport',
      'aircraft',
      'plane',
      'aviation',
      'air travel',
      'domestic flight',
      'international flight',
      'boarding',
      'takeoff',
      'landing',
    ],
    TravelMode.bus: [
      'bus',
      'coach',
      'shuttle',
      'minibus',
      'intercity',
      'highway',
      'deluxe',
      'luxury bus',
      'ac bus',
      'sleeper bus',
      'volvo',
    ],
    TravelMode.hotel: [
      'hotel',
      'resort',
      'stay',
      'accommodation',
      'lodge',
      'inn',
      'guesthouse',
      'ashram',
      'dharamshala',
      'hostel',
      'room booking',
      'room',
      'guest house',
    ],
    TravelMode.car: [
      'car',
      'automobile',
      'vehicle',
      'rental',
      'cab',
      'taxi',
      'self-drive',
      'chauffeur',
      'jeep',
      'suv',
      'driving',
      'road trip',
    ],
  };

  /// Extract travel modes from plan text
  /// Returns a list of detected travel modes (case-insensitive)
  static List<TravelMode> extractTravelModes(String planText) {
    if (planText.trim().isEmpty) {
      return [];
    }

    final detected = <TravelMode>{};
    final lowerText = planText.toLowerCase();

    for (final entry in keywordsByMode.entries) {
      final mode = entry.key;
      final keywords = entry.value;

      for (final keyword in keywords) {
        if (lowerText.contains(keyword)) {
          detected.add(mode);
          break; // Found this mode, no need to check more keywords for it
        }
      }
    }

    return detected.toList();
  }

  /// Extract travel modes with confidence scores
  /// Returns a map of travel modes to their confidence (0.0 to 1.0)
  static Map<TravelMode, double> extractTravelModesWithConfidence(
    String planText,
  ) {
    if (planText.trim().isEmpty) {
      return {};
    }

    final confidence = <TravelMode, double>{};
    final lowerText = planText.toLowerCase();

    for (final entry in keywordsByMode.entries) {
      final mode = entry.key;
      final keywords = entry.value;

      int matchCount = 0;
      for (final keyword in keywords) {
        matchCount += keyword.allMatches(lowerText).length;
      }

      if (matchCount > 0) {
        // Confidence based on number of keyword matches
        // Max out at 1.0, increase with more matches
        final baseConfidence = ((matchCount / keywords.length) * 0.5).clamp(0.0, 1.0);
        confidence[mode] = 0.5 + baseConfidence; // Min 0.5 if detected, max 1.0
      }
    }

    return confidence;
  }

  /// Format travel modes as a readable string
  /// Example: "Train, Flight, Bus"
  static String formatTravelModes(List<TravelMode> modes) {
    if (modes.isEmpty) return 'No travel modes detected';
    return modes.map((m) => m.displayName).join(', ');
  }

  /// Format travel modes with emojis
  /// Example: "🚆 Train, ✈️ Flight, 🚌 Bus"
  static String formatTravelModesWithEmojis(List<TravelMode> modes) {
    if (modes.isEmpty) return 'No travel modes detected';
    return modes.map((m) => '${m.emoji} ${m.displayName}').join(', ');
  }

  /// Detect primary travel mode (the one mentioned most)
  static TravelMode? detectPrimaryTravelMode(String planText) {
    final confidence = extractTravelModesWithConfidence(planText);
    if (confidence.isEmpty) return null;
    
    var primary = confidence.entries.first;
    for (final entry in confidence.entries) {
      if (entry.value > primary.value) {
        primary = entry;
      }
    }
    
    return primary.key;
  }

  /// Check if a specific travel mode is mentioned in the text
  static bool hasTravelMode(String planText, TravelMode mode) {
    if (planText.trim().isEmpty) return false;
    final keywords = keywordsByMode[mode] ?? [];
    final lowerText = planText.toLowerCase();
    return keywords.any((keyword) => lowerText.contains(keyword));
  }
}
