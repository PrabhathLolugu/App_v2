import 'package:myitihas/pages/map2/indian_foods/food_hubs_data.dart';
import 'package:myitihas/pages/map2/indian_foods/food_item.dart';
import 'package:myitihas/pages/map2/indian_foods/food_state_hub.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FoodCatalogRepository {
  FoodCatalogRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<FoodStateHub>> loadStateHubs() async {
    try {
      final hubRows = await _client
          .from('food_state_hubs')
          .select(
            'id, slug, state_code, state_name, latitude, longitude, '
            'pin_hide_zoom_max, sort_order, is_published',
          )
          .eq('is_published', true)
          .order('sort_order', ascending: true);

      final hubs = (hubRows as List)
          .map(
            (raw) =>
                FoodStateHub.fromMap(Map<String, dynamic>.from(raw as Map)),
          )
          .where((hub) => hub.id.isNotEmpty)
          .toList();

      if (hubs.isEmpty) return kFoodStateHubs;

      final hubIds = hubs.map((h) => h.id).toList(growable: false);
      final itemRows = await _client
          .from('food_state_items')
          .select(
            'id, hub_id, food_name, short_description, about_food, history, '
            'ingredients, preparation_style, serving_context, nutrition_notes, '
            'best_season, discussion_site_id, cover_image_url, gallery_urls, '
            'sort_order, is_published',
          )
          .eq('is_published', true)
          .inFilter('hub_id', hubIds)
          .order('sort_order', ascending: true);

      final itemsByHub = <String, List<FoodItem>>{};
      for (final raw in itemRows as List) {
        final item = FoodItem.fromMap(Map<String, dynamic>.from(raw as Map));
        if (item.hubId.isEmpty || item.discussionSiteId.isEmpty) continue;
        itemsByHub.putIfAbsent(item.hubId, () => []).add(item);
      }

      return hubs
          .map((hub) => hub.copyWith(items: itemsByHub[hub.id] ?? const []))
          .toList();
    } catch (_) {
      return kFoodStateHubs;
    }
  }
}
