import 'package:myitihas/pages/map2/Model/sacred_location.dart';

class CustomSiteGenerationResult {
  final String submissionId;
  final String submissionStatus;
  final int? publishedLocationId;
  final SacredLocation sacredLocation;
  final Map<String, dynamic> siteDetails;
  final Map<String, dynamic> chatPrimer;

  const CustomSiteGenerationResult({
    required this.submissionId,
    required this.submissionStatus,
    required this.publishedLocationId,
    required this.sacredLocation,
    required this.siteDetails,
    required this.chatPrimer,
  });

  static int syntheticSiteId(String submissionId) {
    final compact = submissionId.replaceAll('-', '');
    final prefix = compact.length >= 8 ? compact.substring(0, 8) : compact;
    final parsed = int.tryParse(prefix, radix: 16) ?? 1;
    return -parsed.abs();
  }

  factory CustomSiteGenerationResult.fromResponse(Map<String, dynamic> json) {
    final submissionId = (json['submissionId'] ?? '').toString();
    final submissionStatus = (json['submissionStatus'] ?? 'approved').toString();
    final publishedLocationId = (json['publishedLocationId'] as num?)?.toInt();
    final sacredJson = Map<String, dynamic>.from(
      (json['sacredLocationDraft'] as Map?) ?? const {},
    );
    final detailsJson = Map<String, dynamic>.from(
      (json['siteDetailsDraft'] as Map?) ?? const {},
    );
    final primerJson = Map<String, dynamic>.from(
      (json['chatPrimer'] as Map?) ?? const {},
    );

    final a = (sacredJson['latitude'] as num?)?.toDouble() ?? 20.5937;
    final b = (sacredJson['longitude'] as num?)?.toDouble() ?? 78.9629;
    final (lat, lon) = SacredLocation.normalizeIndiaLatLng(a, b);
    final resolvedSiteId =
        publishedLocationId ?? syntheticSiteId(submissionId.isEmpty ? '1' : submissionId);

    final sacredLocation = SacredLocation(
      id: resolvedSiteId,
      name: (sacredJson['name'] ?? 'Custom Sacred Site').toString(),
      latitude: lat,
      longitude: lon,
      intent: const ['Other'],
      type: (sacredJson['type'] ?? 'Other').toString(),
      region: (sacredJson['region'] ?? 'Bharat').toString(),
      tradition: (sacredJson['tradition'] ?? 'Sanatan').toString(),
      image: (sacredJson['image'] ?? '').toString(),
      description: (sacredJson['description'] ?? '').toString(),
      ref: submissionId,
    );

    detailsJson['id'] = publishedLocationId ?? submissionId;
    detailsJson['name'] = detailsJson['name'] ?? sacredLocation.name;
    detailsJson['location'] = detailsJson['location'] ?? sacredLocation.region;

    return CustomSiteGenerationResult(
      submissionId: submissionId,
      submissionStatus: submissionStatus,
      publishedLocationId: publishedLocationId,
      sacredLocation: sacredLocation,
      siteDetails: detailsJson,
      chatPrimer: primerJson,
    );
  }
}

class SavedCustomJourneySite {
  final String submissionId;
  final SacredLocation location;
  final Map<String, dynamic> siteDetails;
  final Map<String, dynamic> chatPrimer;
  final String savedAt;

  const SavedCustomJourneySite({
    required this.submissionId,
    required this.location,
    required this.siteDetails,
    required this.chatPrimer,
    required this.savedAt,
  });

  factory SavedCustomJourneySite.fromJson(Map<String, dynamic> json) {
    return SavedCustomJourneySite(
      submissionId: (json['submissionId'] ?? '').toString(),
      location: SacredLocation.fromJson(
        Map<String, dynamic>.from((json['location'] as Map?) ?? const {}),
      ),
      siteDetails: Map<String, dynamic>.from(
        (json['siteDetails'] as Map?) ?? const {},
      ),
      chatPrimer: Map<String, dynamic>.from(
        (json['chatPrimer'] as Map?) ?? const {},
      ),
      savedAt: (json['savedAt'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'submissionId': submissionId,
      'location': location.toMap(),
      'siteDetails': siteDetails,
      'chatPrimer': chatPrimer,
      'savedAt': savedAt,
    };
  }
}
