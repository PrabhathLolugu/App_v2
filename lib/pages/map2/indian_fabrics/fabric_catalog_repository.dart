import 'package:myitihas/pages/map2/indian_fabrics/fabric_hub.dart';
import 'package:myitihas/pages/map2/indian_fabrics/fabric_hubs_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FabricCatalogRepository {
  FabricCatalogRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<FabricHub>> loadHubs() async {
    try {
      final rows = await _client
          .from('fabric_hubs')
          .select(
            'id, slug, name, region, state, latitude, longitude, fabric_name, '
            'short_description, about_place_and_fabric, history, '
            'cultural_significance, weaving_process, motifs_and_design, '
            'care_and_authenticity, best_buying_season, cover_image_url, '
            'gallery_urls, discussion_site_id, sort_order, is_published',
          )
          .eq('is_published', true)
          .order('sort_order', ascending: true);

      final sellerRows = await _client
          .from('fabric_sellers')
          .select(
            'id, fabric_hub_id, seller_name, organization, seller_type, '
            'contact_line, website, city, is_featured, display_order',
          )
          .order('display_order', ascending: true);

      final sellersByHub = <String, List<FabricSeller>>{};
      for (final raw in sellerRows as List) {
        final row = Map<String, dynamic>.from(raw as Map);
        final hubId = row['fabric_hub_id']?.toString();
        if (hubId == null || hubId.isEmpty) continue;
        sellersByHub
            .putIfAbsent(hubId, () => [])
            .add(FabricSeller.fromMap(row));
      }

      final hubs = (rows as List)
          .map((raw) {
            final row = Map<String, dynamic>.from(raw as Map);
            final id = row['id']?.toString() ?? '';
            return FabricHub.fromMap(
              row,
              sellers: sellersByHub[id] ?? const [],
            );
          })
          .where((hub) => hub.id.isNotEmpty && hub.discussionSiteId.isNotEmpty)
          .toList();

      if (hubs.isEmpty) return kAllFabricHubs;
      return hubs;
    } catch (_) {
      return kAllFabricHubs;
    }
  }
}
