import 'package:myitihas/pages/map2/indian_culture/cultural_category.dart';
import 'package:myitihas/pages/map2/indian_culture/cultural_item.dart';

class CulturalStateHub {
  const CulturalStateHub({
    required this.id,
    required this.category,
    required this.slug,
    required this.stateCode,
    required this.stateName,
    required this.latitude,
    required this.longitude,
    this.pinHideZoomMax = 8.0,
    this.sortOrder = 0,
    this.isPublished = true,
    this.items = const [],
  });

  final String id;
  final CulturalCategory category;
  final String slug;
  final String stateCode;
  final String stateName;
  final double latitude;
  final double longitude;
  final double pinHideZoomMax;
  final int sortOrder;
  final bool isPublished;
  final List<CulturalItem> items;

  CulturalStateHub copyWith({List<CulturalItem>? items}) {
    return CulturalStateHub(
      id: id,
      category: category,
      slug: slug,
      stateCode: stateCode,
      stateName: stateName,
      latitude: latitude,
      longitude: longitude,
      pinHideZoomMax: pinHideZoomMax,
      sortOrder: sortOrder,
      isPublished: isPublished,
      items: items ?? this.items,
    );
  }

  factory CulturalStateHub.fromMap(
    Map<String, dynamic> map, {
    List<CulturalItem>? items,
  }) {
    final categoryRaw = (map['category'] ?? '').toString();
    final category = categoryRaw == CulturalCategory.classicalDance.dbValue
        ? CulturalCategory.classicalDance
        : CulturalCategory.classicalArt;

    return CulturalStateHub(
      id: (map['id'] ?? '').toString(),
      category: category,
      slug: (map['slug'] ?? '').toString(),
      stateCode: (map['state_code'] ?? '').toString(),
      stateName: (map['state_name'] ?? '').toString(),
      latitude: (map['latitude'] as num?)?.toDouble() ?? 20.5937,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 78.9629,
      pinHideZoomMax: (map['pin_hide_zoom_max'] as num?)?.toDouble() ?? 8.0,
      sortOrder: (map['sort_order'] as num?)?.toInt() ?? 0,
      isPublished: map['is_published'] != false,
      items: items ?? const [],
    );
  }
}
