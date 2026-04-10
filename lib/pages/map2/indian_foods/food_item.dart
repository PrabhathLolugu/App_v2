class FoodItem {
  const FoodItem({
    required this.id,
    required this.hubId,
    required this.foodName,
    required this.shortDescription,
    required this.aboutFood,
    this.history,
    this.ingredients,
    this.preparationStyle,
    this.servingContext,
    this.nutritionNotes,
    this.bestSeason,
    required this.discussionSiteId,
    this.coverImageUrl,
    this.galleryUrls = const [],
    this.sortOrder = 0,
    this.isPublished = true,
  });

  final String id;
  final String hubId;
  final String foodName;
  final String shortDescription;
  final String aboutFood;
  final String? history;
  final String? ingredients;
  final String? preparationStyle;
  final String? servingContext;
  final String? nutritionNotes;
  final String? bestSeason;
  final String discussionSiteId;
  final String? coverImageUrl;
  final List<String> galleryUrls;
  final int sortOrder;
  final bool isPublished;

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: (map['id'] ?? '').toString(),
      hubId: (map['hub_id'] ?? '').toString(),
      foodName: (map['food_name'] ?? '').toString(),
      shortDescription: (map['short_description'] ?? '').toString(),
      aboutFood: (map['about_food'] ?? '').toString(),
      history: map['history']?.toString(),
      ingredients: map['ingredients']?.toString(),
      preparationStyle: map['preparation_style']?.toString(),
      servingContext: map['serving_context']?.toString(),
      nutritionNotes: map['nutrition_notes']?.toString(),
      bestSeason: map['best_season']?.toString(),
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
