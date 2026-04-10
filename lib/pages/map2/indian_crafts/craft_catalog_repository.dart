import 'package:myitihas/pages/map2/indian_crafts/craft_hub.dart';
import 'package:myitihas/pages/map2/indian_crafts/craft_hubs_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CraftCatalogRepository {
  CraftCatalogRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<CraftHub>> loadHubs() async {
    try {
      final rows = await _client
          .from('craft_hubs')
          .select(
            'id, slug, name, state, region, latitude, longitude, craft_name, '
            'short_description, about_place_and_craft, history, '
            'cultural_significance, making_process, materials, motifs_and_style, '
            'care_and_authenticity, best_buying_season, cover_image_url, '
            'gallery_urls, discussion_site_id, sort_order, is_published',
          )
          .eq('is_published', true)
          .order('sort_order', ascending: true);

      final sellerRows = await _client
          .from('craft_sellers')
          .select(
            'id, craft_hub_id, seller_name, organization, seller_type, '
            'contact_line, website, city, is_featured, display_order',
          )
          .order('display_order', ascending: true);

      final sellersByHub = <String, List<CraftSeller>>{};
      for (final raw in sellerRows as List) {
        final row = Map<String, dynamic>.from(raw as Map);
        final hubId = row['craft_hub_id']?.toString();
        if (hubId == null || hubId.isEmpty) continue;
        sellersByHub.putIfAbsent(hubId, () => []).add(CraftSeller.fromMap(row));
      }

      final hubs = (rows as List)
          .map((raw) {
            final row = Map<String, dynamic>.from(raw as Map);
            final id = row['id']?.toString() ?? '';
            return CraftHub.fromMap(row, sellers: sellersByHub[id] ?? const []);
          })
          .where((hub) => hub.id.isNotEmpty && hub.discussionSiteId.isNotEmpty)
          .toList();

      if (hubs.isEmpty) return kAllCraftHubs;
      return hubs;
    } catch (_) {
      return kAllCraftHubs;
    }
  }
}
