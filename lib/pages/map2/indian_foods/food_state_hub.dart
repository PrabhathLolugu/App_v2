import 'package:myitihas/pages/map2/indian_foods/food_item.dart';

class FoodStateHub {
  const FoodStateHub({
    required this.id,
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
  final String slug;
  final String stateCode;
  final String stateName;
  final double latitude;
  final double longitude;
  final double pinHideZoomMax;
  final int sortOrder;
  final bool isPublished;
  final List<FoodItem> items;

  FoodStateHub copyWith({List<FoodItem>? items}) {
    return FoodStateHub(
      id: id,
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

  factory FoodStateHub.fromMap(
    Map<String, dynamic> map, {
    List<FoodItem>? items,
  }) {
    return FoodStateHub(
      id: (map['id'] ?? '').toString(),
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
