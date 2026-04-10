class CulturalItem {
  const CulturalItem({
    required this.id,
    required this.hubId,
    required this.itemName,
    required this.shortDescription,
    required this.aboutStateTradition,
    this.history,
    this.culturalSignificance,
    this.practiceAndPedagogy,
    this.performanceContext,
    this.notableExponents,
    required this.discussionSiteId,
    this.coverImageUrl,
    this.galleryUrls = const [],
    this.sortOrder = 0,
    this.isPublished = true,
  });

  final String id;
  final String hubId;
  final String itemName;
  final String shortDescription;
  final String aboutStateTradition;
  final String? history;
  final String? culturalSignificance;
  final String? practiceAndPedagogy;
  final String? performanceContext;
  final String? notableExponents;
  final String discussionSiteId;
  final String? coverImageUrl;
  final List<String> galleryUrls;
  final int sortOrder;
  final bool isPublished;

  factory CulturalItem.fromMap(Map<String, dynamic> map) {
    return CulturalItem(
      id: (map['id'] ?? '').toString(),
      hubId: (map['hub_id'] ?? '').toString(),
      itemName: (map['item_name'] ?? '').toString(),
      shortDescription: (map['short_description'] ?? '').toString(),
      aboutStateTradition: (map['about_state_tradition'] ?? '').toString(),
      history: map['history']?.toString(),
      culturalSignificance: map['cultural_significance']?.toString(),
      practiceAndPedagogy: map['practice_and_pedagogy']?.toString(),
      performanceContext: map['performance_context']?.toString(),
      notableExponents: map['notable_exponents']?.toString(),
      discussionSiteId: (map['discussion_site_id'] ?? '').toString(),
      coverImageUrl: map['cover_image_url']?.toString(),
      galleryUrls: ((map['gallery_urls'] as List?) ?? const [])
          .map((e) => e.toString())
          .where((e) => e.trim().isNotEmpty)
          .toList(),
      sortOrder: (map['sort_order'] as num?)?.toInt() ?? 0,
      isPublished: map['is_published'] != false,
    );
  }
}
