import 'package:flutter/material.dart';

/// Enum for travel modes
enum TravelMode {
  train('train', 'Train', '🚆'),
  flight('flight', 'Flight', '✈️'),
  bus('bus', 'Bus', '🚌'),
  hotel('hotel', 'Hotel', '🏨'),
  car('car', 'Car', '🚗');

  const TravelMode(this.id, this.displayName, this.emoji);

  final String id;
  final String displayName;
  final String emoji;

  /// Parse travel mode from string
  static TravelMode? fromString(String? value) {
    if (value == null) return null;
    try {
      return TravelMode.values.firstWhere((e) => e.id == value.toLowerCase());
    } catch (_) {
      return null;
    }
  }
}

/// Represents a booking operator (e.g., IRCTC, MMT, RedBus)
class BookingOperator {
  const BookingOperator({
    required this.id,
    required this.name,
    required this.travelMode,
    required this.deepLinkTemplate,
    required this.color,
    required this.icon,
    this.isVerified = false,
    this.description,
    this.logoUrl,
  });

  final String id;
  final String name;
  final TravelMode travelMode;
  final String deepLinkTemplate;
  final Color color;
  final IconData icon;
  final bool isVerified;
  final String? description;
  final String? logoUrl;

  /// Generate deep link with parameters
  /// Example: deepLinkTemplate = "https://irctc.co.in/?from={from}&to={to}&date={date}"
  String generateDeepLink({
    String? from,
    String? to,
    String? date,
    String? returnDate,
  }) {
    String link = deepLinkTemplate;
    if (from != null) {
      link = link.replaceAll('{from}', Uri.encodeComponent(from));
    }
    if (to != null) {
      link = link.replaceAll('{to}', Uri.encodeComponent(to));
    }
    if (date != null) {
      link = link.replaceAll('{date}', Uri.encodeComponent(date));
    }
    if (returnDate != null) {
      link = link.replaceAll('{returnDate}', Uri.encodeComponent(returnDate));
    }
    return link;
  }
}
