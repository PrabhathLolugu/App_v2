class SacredLocation {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final List<String> intent;
  final String? type;
  final String? region;
  final String? tradition;
  final String? ref;
  final String? image;
  final String? description;
  final bool isFavorite;
  final bool visited;

  SacredLocation({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.intent,
    this.type,
    this.region,
    this.tradition,
    this.ref,
    this.image,
    this.description,
    this.isFavorite = false,
    this.visited = false,
  });

  /// Ensures (lat, lng) for India: corrects if data was stored as (lng, lat).
  /// India bounds: lat ~8–37, lng ~68–97.
  static (double, double) normalizeIndiaLatLng(double a, double b) {
    const double indiaLatMin = 8.0, indiaLatMax = 37.0;
    const double indiaLngMin = 68.0, indiaLngMax = 97.0;
    final aLooksLng = a >= indiaLngMin && a <= indiaLngMax;
    final bLooksLat = b >= indiaLatMin && b <= indiaLatMax;
    if (aLooksLng && bLooksLat) return (b, a); // was (lng, lat)
    return (a, b);
  }

  factory SacredLocation.fromJson(Map<String, dynamic> json) {
    final a = (json['latitude'] as num).toDouble();
    final b = (json['longitude'] as num).toDouble();
    final (lat, lng) = normalizeIndiaLatLng(a, b);
    return SacredLocation(
      id: json['id'],
      name: json['name'],
      latitude: lat,
      longitude: lng,
      intent: List<String>.from(json['intent'] ?? []),
      type: json['type'],
      region: json['region'],
      tradition: json['tradition'],
      ref: json['ref'],
      image: json['image'],
      description: json['description'],
      isFavorite: json['isFavorite'] ?? false,
      visited: json['visited'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'intent': intent,
      'type': type,
      'region': region,
      'tradition': tradition,
      'ref': ref,
      'image': image,
      'description': description,
      'isFavorite': isFavorite,
      'visited': visited,
    };
  }
}
