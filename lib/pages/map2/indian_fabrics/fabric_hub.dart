/// Static catalog entry for a traditional Indian fabric hub (not a sacred site).
class FabricSeller {
  const FabricSeller({
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

  /// Phone, website, or short address line for display.
  final String contactLine;
  final String? website;
  final String? city;
  final String sellerType;
  final bool isFeatured;

  factory FabricSeller.fromMap(Map<String, dynamic> map) {
    return FabricSeller(
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

class FabricHub {
  const FabricHub({
    required this.id,
    required this.slug,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.region,
    this.state,
    required this.fabricName,
    required this.shortDescription,
    required this.aboutPlaceAndFabric,
    this.history,
    this.culturalSignificance,
    this.weavingProcess,
    this.motifsAndDesign,
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
  final String fabricName;
  final String shortDescription;
  final String aboutPlaceAndFabric;
  final String? history;
  final String? culturalSignificance;
  final String? weavingProcess;
  final String? motifsAndDesign;
  final String? careAndAuthenticity;
  final String? bestBuyingSeason;
  final List<String> galleryUrls;

  /// UUID for `discussions.site_id` filtering in ForumCommunity.
  final String discussionSiteId;
  final List<FabricSeller> sellers;
  final int sortOrder;
  final bool isPublished;
  final String? imageUrl;

  factory FabricHub.fromMap(
    Map<String, dynamic> map, {
    List<FabricSeller>? sellers,
  }) {
    return FabricHub(
      id: (map['id'] ?? '').toString(),
      slug: (map['slug'] ?? map['id'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      latitude: (map['latitude'] as num?)?.toDouble() ?? 20.5937,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 78.9629,
      region: (map['region'] ?? '').toString(),
      state: map['state']?.toString(),
      fabricName: (map['fabric_name'] ?? map['fabricName'] ?? '').toString(),
      shortDescription: (map['short_description'] ?? '').toString(),
      aboutPlaceAndFabric: (map['about_place_and_fabric'] ?? '').toString(),
      history: map['history']?.toString(),
      culturalSignificance: map['cultural_significance']?.toString(),
      weavingProcess: map['weaving_process']?.toString(),
      motifsAndDesign: map['motifs_and_design']?.toString(),
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
      imageUrl:
          map['cover_image_url']?.toString() ?? map['imageUrl']?.toString(),
    );
  }

  List<FabricSeller> get governmentSellers {
    return sellers.where((s) {
      final type = s.sellerType.toLowerCase();
      return type == 'government' || type == 'cooperative';
    }).toList();
  }
}
