import 'package:myitihas/pages/map2/indian_culture/cultural_category.dart';
import 'package:myitihas/pages/map2/indian_culture/cultural_hubs_data.dart';
import 'package:myitihas/pages/map2/indian_culture/cultural_item.dart';
import 'package:myitihas/pages/map2/indian_culture/cultural_state_hub.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CulturalCatalogRepository {
  CulturalCatalogRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<CulturalStateHub>> loadStateHubs(
    CulturalCategory category,
  ) async {
    try {
      final hubRows = await _client
          .from('cultural_state_hubs')
          .select(
            'id, category, slug, state_code, state_name, latitude, longitude, '
            'pin_hide_zoom_max, sort_order, is_published',
          )
          .eq('category', category.dbValue)
          .eq('is_published', true)
          .order('sort_order', ascending: true);

      final hubs = (hubRows as List)
          .map(
            (raw) =>
                CulturalStateHub.fromMap(Map<String, dynamic>.from(raw as Map)),
          )
          .where((hub) => hub.id.isNotEmpty)
          .toList();

      if (hubs.isEmpty) return fallbackHubsForCategory(category);

      final hubIds = hubs.map((h) => h.id).toList(growable: false);
      final itemRows = await _client
          .from('cultural_state_items')
          .select(
            'id, hub_id, item_name, short_description, about_state_tradition, '
            'history, cultural_significance, practice_and_pedagogy, '
            'performance_context, notable_exponents, discussion_site_id, '
            'cover_image_url, gallery_urls, sort_order, is_published',
          )
          .eq('is_published', true)
          .inFilter('hub_id', hubIds)
          .order('sort_order', ascending: true);

      final itemsByHub = <String, List<CulturalItem>>{};
      for (final raw in itemRows as List) {
        final item = CulturalItem.fromMap(
          Map<String, dynamic>.from(raw as Map),
        );
        if (item.hubId.isEmpty || item.discussionSiteId.isEmpty) continue;
        itemsByHub.putIfAbsent(item.hubId, () => []).add(item);
      }

      return hubs
          .map((hub) => hub.copyWith(items: itemsByHub[hub.id] ?? const []))
          .toList();
    } catch (_) {
      return fallbackHubsForCategory(category);
    }
  }
}
