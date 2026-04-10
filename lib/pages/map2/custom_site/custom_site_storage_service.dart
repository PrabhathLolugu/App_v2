import 'dart:convert';

import 'package:myitihas/pages/map2/custom_site/custom_site_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomSiteStorageService {
  static const _savedCustomSitesKey = 'map.saved_custom_sites';

  static Future<List<SavedCustomJourneySite>> loadSavedSites() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_savedCustomSitesKey);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return decoded
          .map(
            (item) => SavedCustomJourneySite.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();
    } catch (_) {
      return const [];
    }
  }

  static Future<void> saveSite(CustomSiteGenerationResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await loadSavedSites();
    final withoutDuplicate = existing
        .where((site) => site.submissionId != result.submissionId)
        .toList();

    final saved = SavedCustomJourneySite(
      submissionId: result.submissionId,
      location: result.sacredLocation,
      siteDetails: result.siteDetails,
      chatPrimer: result.chatPrimer,
      savedAt: DateTime.now().toIso8601String(),
    );
    withoutDuplicate.insert(0, saved);

    await prefs.setString(
      _savedCustomSitesKey,
      jsonEncode(withoutDuplicate.map((item) => item.toJson()).toList()),
    );
  }

  static Future<bool> isSaved(String submissionId) async {
    final items = await loadSavedSites();
    return items.any((item) => item.submissionId == submissionId);
  }
}
