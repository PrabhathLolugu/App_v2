class CraftSeller {
  const CraftSeller({
    this.id,
    required this.name,
    required this.organization,
    required this.contactLine,
    this.website,
    this.city,
    this.sellerType = 'government',
    this.isFeatured = false,
  });

  final String? id;
  final String name;
  final String organization;
  final String contactLine;
  final String? website;
  final String? city;
  final String sellerType;
  final bool isFeatured;

  factory CraftSeller.fromMap(Map<String, dynamic> map) {
    return CraftSeller(
      id: map['id']?.toString(),
      name: (map['seller_name'] ?? map['name'] ?? '').toString(),
      organization: (map['organization'] ?? '').toString(),
      contactLine: (map['contact_line'] ?? map['contactLine'] ?? '').toString(),
      website: map['website']?.toString(),
      city: map['city']?.toString(),
      sellerType: (map['seller_type'] ?? 'government').toString(),
      isFeatured: map['is_featured'] == true,
    );
  }
}

class CraftHub {
  const CraftHub({
    required this.id,
    required this.slug,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.region,
    this.state,
    required this.craftName,
    required this.shortDescription,
    required this.aboutPlaceAndCraft,
    this.history,
    this.culturalSignificance,
    this.makingProcess,
    this.materials,
    this.motifsAndStyle,
    this.careAndAuthenticity,
    this.bestBuyingSeason,
    this.galleryUrls = const [],
    required this.discussionSiteId,
    this.sellers = const [],
    this.sortOrder = 0,
    this.isPublished = true,
    this.imageUrl,
  });

  final String id;
  final String slug;
  final String name;
  final double latitude;
  final double longitude;
  final String region;
  final String? state;
  final String craftName;
  final String shortDescription;
  final String aboutPlaceAndCraft;
  final String? history;
  final String? culturalSignificance;
  final String? makingProcess;
  final String? materials;
  final String? motifsAndStyle;
  final String? careAndAuthenticity;
  final String? bestBuyingSeason;
  final List<String> galleryUrls;
  final String discussionSiteId;
  final List<CraftSeller> sellers;
  final int sortOrder;
  final bool isPublished;
  final String? imageUrl;

  factory CraftHub.fromMap(
    Map<String, dynamic> map, {
    List<CraftSeller>? sellers,
  }) {
    return CraftHub(
      id: (map['id'] ?? '').toString(),
      slug: (map['slug'] ?? map['id'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      latitude: (map['latitude'] as num?)?.toDouble() ?? 20.5937,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 78.9629,
      region: (map['region'] ?? '').toString(),
      state: map['state']?.toString(),
      craftName: (map['craft_name'] ?? map['craftName'] ?? '').toString(),
      shortDescription: (map['short_description'] ?? '').toString(),
      aboutPlaceAndCraft: (map['about_place_and_craft'] ?? '').toString(),
      history: map['history']?.toString(),
      culturalSignificance: map['cultural_significance']?.toString(),
      makingProcess: map['making_process']?.toString(),
      materials: map['materials']?.toString(),
      motifsAndStyle: map['motifs_and_style']?.toString(),
      careAndAuthenticity: map['care_and_authenticity']?.toString(),
      bestBuyingSeason: map['best_buying_season']?.toString(),
      galleryUrls: ((map['gallery_urls'] as List?) ?? const [])
          .map((e) => e.toString())
          .where((e) => e.trim().isNotEmpty)
          .toList(),
      discussionSiteId: (map['discussion_site_id'] ?? '').toString(),
      sellers: sellers ?? const [],
      sortOrder: (map['sort_order'] as num?)?.toInt() ?? 0,
      isPublished: map['is_published'] != false,
      imageUrl: map['cover_image_url']?.toString(),
    );
  }
}
