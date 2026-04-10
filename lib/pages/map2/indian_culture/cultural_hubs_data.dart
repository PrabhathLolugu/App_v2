import 'package:myitihas/pages/map2/indian_culture/cultural_category.dart';
import 'package:myitihas/pages/map2/indian_culture/cultural_item.dart';
import 'package:myitihas/pages/map2/indian_culture/cultural_state_hub.dart';

class _StateSeed {
  const _StateSeed({
    required this.code,
    required this.name,
    required this.lat,
    required this.lng,
    required this.pinHideZoomMax,
    required this.order,
  });

  final String code;
  final String name;
  final double lat;
  final double lng;
  final double pinHideZoomMax;
  final int order;
}

const _stateSeeds = <_StateSeed>[
  _StateSeed(
    code: 'IN-AP',
    name: 'Andhra Pradesh',
    lat: 15.9129,
    lng: 79.7400,
    pinHideZoomMax: 7.6,
    order: 1,
  ),
  _StateSeed(
    code: 'IN-AR',
    name: 'Arunachal Pradesh',
    lat: 28.2180,
    lng: 94.7278,
    pinHideZoomMax: 8.6,
    order: 2,
  ),
  _StateSeed(
    code: 'IN-AS',
    name: 'Assam',
    lat: 26.2006,
    lng: 92.9376,
    pinHideZoomMax: 8.3,
    order: 3,
  ),
  _StateSeed(
    code: 'IN-BR',
    name: 'Bihar',
    lat: 25.0961,
    lng: 85.3131,
    pinHideZoomMax: 7.9,
    order: 4,
  ),
  _StateSeed(
    code: 'IN-CT',
    name: 'Chhattisgarh',
    lat: 21.2787,
    lng: 81.8661,
    pinHideZoomMax: 7.7,
    order: 5,
  ),
  _StateSeed(
    code: 'IN-GA',
    name: 'Goa',
    lat: 15.2993,
    lng: 74.1240,
    pinHideZoomMax: 8.9,
    order: 6,
  ),
  _StateSeed(
    code: 'IN-GJ',
    name: 'Gujarat',
    lat: 22.2587,
    lng: 71.1924,
    pinHideZoomMax: 7.5,
    order: 7,
  ),
  _StateSeed(
    code: 'IN-HR',
    name: 'Haryana',
    lat: 29.0588,
    lng: 76.0856,
    pinHideZoomMax: 8.1,
    order: 8,
  ),
  _StateSeed(
    code: 'IN-HP',
    name: 'Himachal Pradesh',
    lat: 31.1048,
    lng: 77.1734,
    pinHideZoomMax: 8.5,
    order: 9,
  ),
  _StateSeed(
    code: 'IN-JH',
    name: 'Jharkhand',
    lat: 23.6102,
    lng: 85.2799,
    pinHideZoomMax: 8.0,
    order: 10,
  ),
  _StateSeed(
    code: 'IN-KA',
    name: 'Karnataka',
    lat: 15.3173,
    lng: 75.7139,
    pinHideZoomMax: 7.4,
    order: 11,
  ),
  _StateSeed(
    code: 'IN-KL',
    name: 'Kerala',
    lat: 10.8505,
    lng: 76.2711,
    pinHideZoomMax: 8.0,
    order: 12,
  ),
  _StateSeed(
    code: 'IN-MP',
    name: 'Madhya Pradesh',
    lat: 22.9734,
    lng: 78.6569,
    pinHideZoomMax: 7.3,
    order: 13,
  ),
  _StateSeed(
    code: 'IN-MH',
    name: 'Maharashtra',
    lat: 19.7515,
    lng: 75.7139,
    pinHideZoomMax: 7.2,
    order: 14,
  ),
  _StateSeed(
    code: 'IN-MN',
    name: 'Manipur',
    lat: 24.6637,
    lng: 93.9063,
    pinHideZoomMax: 8.7,
    order: 15,
  ),
  _StateSeed(
    code: 'IN-ML',
    name: 'Meghalaya',
    lat: 25.4670,
    lng: 91.3662,
    pinHideZoomMax: 8.7,
    order: 16,
  ),
  _StateSeed(
    code: 'IN-MZ',
    name: 'Mizoram',
    lat: 23.1645,
    lng: 92.9376,
    pinHideZoomMax: 8.8,
    order: 17,
  ),
  _StateSeed(
    code: 'IN-NL',
    name: 'Nagaland',
    lat: 26.1584,
    lng: 94.5624,
    pinHideZoomMax: 8.7,
    order: 18,
  ),
  _StateSeed(
    code: 'IN-OR',
    name: 'Odisha',
    lat: 20.9517,
    lng: 85.0985,
    pinHideZoomMax: 7.8,
    order: 19,
  ),
  _StateSeed(
    code: 'IN-PB',
    name: 'Punjab',
    lat: 31.1471,
    lng: 75.3412,
    pinHideZoomMax: 8.1,
    order: 20,
  ),
  _StateSeed(
    code: 'IN-RJ',
    name: 'Rajasthan',
    lat: 27.0238,
    lng: 74.2179,
    pinHideZoomMax: 7.2,
    order: 21,
  ),
  _StateSeed(
    code: 'IN-SK',
    name: 'Sikkim',
    lat: 27.5330,
    lng: 88.5122,
    pinHideZoomMax: 8.8,
    order: 22,
  ),
  _StateSeed(
    code: 'IN-TN',
    name: 'Tamil Nadu',
    lat: 11.1271,
    lng: 78.6569,
    pinHideZoomMax: 7.4,
    order: 23,
  ),
  _StateSeed(
    code: 'IN-TS',
    name: 'Telangana',
    lat: 18.1124,
    lng: 79.0193,
    pinHideZoomMax: 7.8,
    order: 24,
  ),
  _StateSeed(
    code: 'IN-TR',
    name: 'Tripura',
    lat: 23.9408,
    lng: 91.9882,
    pinHideZoomMax: 8.7,
    order: 25,
  ),
  _StateSeed(
    code: 'IN-UP',
    name: 'Uttar Pradesh',
    lat: 26.8467,
    lng: 80.9462,
    pinHideZoomMax: 7.1,
    order: 26,
  ),
  _StateSeed(
    code: 'IN-UK',
    name: 'Uttarakhand',
    lat: 30.0668,
    lng: 79.0193,
    pinHideZoomMax: 8.4,
    order: 27,
  ),
  _StateSeed(
    code: 'IN-WB',
    name: 'West Bengal',
    lat: 22.9868,
    lng: 87.8550,
    pinHideZoomMax: 7.8,
    order: 28,
  ),
  _StateSeed(
    code: 'IN-AN',
    name: 'Andaman and Nicobar Islands',
    lat: 11.7401,
    lng: 92.6586,
    pinHideZoomMax: 8.9,
    order: 29,
  ),
  _StateSeed(
    code: 'IN-CH',
    name: 'Chandigarh',
    lat: 30.7333,
    lng: 76.7794,
    pinHideZoomMax: 9.0,
    order: 30,
  ),
  _StateSeed(
    code: 'IN-DN',
    name: 'Dadra and Nagar Haveli and Daman and Diu',
    lat: 20.3974,
    lng: 72.8328,
    pinHideZoomMax: 8.9,
    order: 31,
  ),
  _StateSeed(
    code: 'IN-DL',
    name: 'Delhi',
    lat: 28.7041,
    lng: 77.1025,
    pinHideZoomMax: 8.9,
    order: 32,
  ),
  _StateSeed(
    code: 'IN-JK',
    name: 'Jammu and Kashmir',
    lat: 33.7782,
    lng: 76.5762,
    pinHideZoomMax: 8.5,
    order: 33,
  ),
  _StateSeed(
    code: 'IN-LA',
    name: 'Ladakh',
    lat: 34.1526,
    lng: 77.5770,
    pinHideZoomMax: 8.9,
    order: 34,
  ),
  _StateSeed(
    code: 'IN-LD',
    name: 'Lakshadweep',
    lat: 10.5667,
    lng: 72.6417,
    pinHideZoomMax: 9.0,
    order: 35,
  ),
  _StateSeed(
    code: 'IN-PY',
    name: 'Puducherry',
    lat: 11.9416,
    lng: 79.8083,
    pinHideZoomMax: 8.9,
    order: 36,
  ),
];

const _artItemByState = <String, String>{
  'IN-AP': 'Kalamkari Visual Tradition',
  'IN-AR': 'Monpa Thangka Tradition',
  'IN-AS': 'Majuli Mask Craft Theatre Art',
  'IN-BR': 'Madhubani Painting',
  'IN-CT': 'Bastar Dhokra Sculpture',
  'IN-GA': 'Mando Music-Theatre Visual Art',
  'IN-GJ': 'Pithora Ritual Painting',
  'IN-HR': 'Phulkari Heritage Embroidery Art',
  'IN-HP': 'Kangra Miniature Painting',
  'IN-JH': 'Sohrai-Khovar Wall Art',
  'IN-KA': 'Mysore Painting',
  'IN-KL': 'Kathakali Chutti Visual Design',
  'IN-MP': 'Gond Narrative Art',
  'IN-MH': 'Warli Painting',
  'IN-MN': 'Manipuri Sankirtana Performance Art',
  'IN-ML': 'Wangala Drum-Choreographic Art',
  'IN-MZ': 'Mizo Bamboo Performance Art',
  'IN-NL': 'Naga Woodcarving Heritage Art',
  'IN-OR': 'Pattachitra Classical Painting',
  'IN-PB': 'Sikh Fresco-Miniature Heritage Art',
  'IN-RJ': 'Phad Narrative Scroll Painting',
  'IN-SK': 'Sikkimese Thangka School',
  'IN-TN': 'Tanjore Painting',
  'IN-TS': 'Cheriyal Scroll Painting',
  'IN-TR': 'Tripuri Bamboo-Cane Art',
  'IN-UP': 'Banaras Gulabi Meenakari Art',
  'IN-UK': 'Aipan Ritual Floor Art',
  'IN-WB': 'Kalighat Pat Visual School',
  'IN-AN': 'Nicobari Cane-Shell Art',
  'IN-CH': 'Punjabi Sufi Stage Visual Tradition',
  'IN-DN': 'Daman-Diu Coastal Mural Art',
  'IN-DL': 'Delhi Hindustani Stage Art',
  'IN-JK': 'Kashmiri Papier-Mache Art',
  'IN-LA': 'Ladakhi Monastic Art',
  'IN-LD': 'Lakshadweep Shell Craft Art',
  'IN-PY': 'Puducherry Franco-Tamil Devotional Art',
};

const _extraArtItemByState = <String, String>{
  'IN-AP': 'Lepakshi Mural Tradition',
  'IN-AS': 'Assamese Manuscript Painting',
  'IN-BR': 'Manjusha Art',
  'IN-CT': 'Bastar Tribal Wall Art',
  'IN-GJ': 'Mata ni Pachedi',
  'IN-HP': 'Chamba Rumal Art',
  'IN-JH': 'Jadopatia Scroll Art',
  'IN-KA': 'Karnataka Mysore Ganjifa Art',
  'IN-KL': 'Kerala Mural Tradition',
  'IN-MP': 'Bhil Painting',
  'IN-MH': 'Pinguli Chitrakathi',
  'IN-OR': 'Tala Pattachitra',
  'IN-PB': 'Punjab Phulkari Art',
  'IN-RJ': 'Kishangarh Miniature School',
  'IN-TN': 'Kolam Ritual Art',
  'IN-TS': 'Nirmal Painting',
  'IN-UP': 'Mathura School Visual Tradition',
  'IN-UK': 'Garhwal Miniature Tradition',
  'IN-WB': 'Bengal Patachitra',
  'IN-JK': 'Kashmiri Khatamband Design Art',
};

const _danceItemByState = <String, String>{
  'IN-AP': 'Kuchipudi',
  'IN-AR': 'Ponung Classicalized Tradition',
  'IN-AS': 'Sattriya',
  'IN-BR': 'Bidesia Dance-Theatre Tradition',
  'IN-CT': 'Panthi Dance Tradition',
  'IN-GA': 'Dekhni-Mando Dance Tradition',
  'IN-GJ': 'Garba-Raas Stage Tradition',
  'IN-HR': 'Jhumar Stage Tradition',
  'IN-HP': 'Nati Classical Stage Tradition',
  'IN-JH': 'Paika Martial Dance',
  'IN-KA': 'Yakshagana Nritya-Abhinaya',
  'IN-KL': 'Mohiniyattam',
  'IN-MP': 'Rai Dance Tradition',
  'IN-MH': 'Lavani Stage Tradition',
  'IN-MN': 'Manipuri Ras',
  'IN-ML': 'Nongkrem Dance Tradition',
  'IN-MZ': 'Cheraw Dance',
  'IN-NL': 'Chang Lo Dance Tradition',
  'IN-OR': 'Odissi',
  'IN-PB': 'Giddha Stage Tradition',
  'IN-RJ': 'Ghoomar Stage Tradition',
  'IN-SK': 'Singhi Chham',
  'IN-TN': 'Bharatanatyam',
  'IN-TS': 'Perini Shivatandavam',
  'IN-TR': 'Hojagiri Dance Tradition',
  'IN-UP': 'Kathak',
  'IN-UK': 'Chholiya Dance Tradition',
  'IN-WB': 'Gaudiya Nritya',
  'IN-AN': 'Nicobari Community Dance',
  'IN-CH': 'Bhangra Stage Tradition',
  'IN-DN': 'Vira Dance Tradition',
  'IN-DL': 'Kathak Rangmanch Circuit',
  'IN-JK': 'Rouf Dance Tradition',
  'IN-LA': 'Cham Dance',
  'IN-LD': 'Lava Dance Tradition',
  'IN-PY': 'Bharatanatyam (Puducherry Bani)',
};

String _uuidLike(String seed) {
  final bytes = seed.codeUnits.fold<int>(
    0,
    (sum, e) => (sum * 31 + e) & 0x7fffffff,
  );
  final hex = bytes.toRadixString(16).padLeft(8, '0');
  return '$hex-${hex.substring(0, 4)}-${hex.substring(4, 8)}-a1b2-${hex}c0de';
}

List<CulturalStateHub> _buildFallback(
  CulturalCategory category,
  Map<String, String> map,
) {
  return _stateSeeds
      .map((state) {
        final itemName = map[state.code] ?? 'Classical tradition';
        final hubId = _uuidLike('${category.dbValue}-${state.code}-hub');
        final discussionId = _uuidLike(
          '${category.dbValue}-${state.code}-discussion',
        );
        final imageKey =
            '${category.dbValue}/${state.code.replaceFirst('IN-', '').toLowerCase()}';
        final item = CulturalItem(
          id: _uuidLike('${category.dbValue}-${state.code}-item'),
          hubId: hubId,
          itemName: itemName,
          shortDescription:
              '$itemName is a major ${category.itemTypeLabel.toLowerCase()} tradition documented for ${state.name}.',
          aboutStateTradition:
              'This profile maps $itemName to ${state.name} at a state level (not city level), '
              'so users can discover multiple traditions from the same region.',
          history:
              '$itemName in ${state.name} evolved through temple, court, festival, and community transmission lineages.',
          culturalSignificance:
              'The tradition carries identity memory, pedagogy, and inter-generational continuity within ${state.name}.',
          practiceAndPedagogy:
              'Training usually involves repertoire discipline, foundational technique, guided apprenticeship, and stage context.',
          performanceContext:
              'Presented in sabhas, state festivals, cultural academies, and community celebrations.',
          notableExponents:
              'Regional gurus, institutional repertories, and lineage practitioners.',
          discussionSiteId: discussionId,
          coverImageUrl:
              'https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/cultural-state/$imageKey/cover.jpg',
          galleryUrls: [
            'https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/cultural-state/$imageKey/gallery/1.jpg',
          ],
        );
        final items = <CulturalItem>[item];
        final extraArtName = category == CulturalCategory.classicalArt
            ? _extraArtItemByState[state.code]
            : null;
        if (extraArtName != null && extraArtName.trim().isNotEmpty) {
          final extraSlug = extraArtName
              .toLowerCase()
              .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
              .replaceAll(RegExp(r'^-+|-+$'), '');
          items.add(
            CulturalItem(
              id: _uuidLike(
                '${category.dbValue}-${state.code}-$extraSlug-item',
              ),
              hubId: hubId,
              itemName: extraArtName,
              shortDescription:
                  '$extraArtName is an additional ${category.itemTypeLabel.toLowerCase()} profile for ${state.name}.',
              aboutStateTradition:
                  '$extraArtName in ${state.name} is presented at state level to support multiple traditions under the same state pin.',
              history:
                  '$extraArtName evolved through regional ateliers, temple and community transmission, and local schools.',
              culturalSignificance:
                  'It preserves visual identity and regional cultural memory in ${state.name}.',
              practiceAndPedagogy:
                  'Training typically continues via lineage, workshops, and academy pathways.',
              performanceContext:
                  'Shown in festivals, museums, cultural centers, and curated heritage events.',
              notableExponents:
                  'Regional masters, lineage artists, and institutional practitioners.',
              discussionSiteId: _uuidLike(
                '${category.dbValue}-${state.code}-$extraSlug-discussion',
              ),
              coverImageUrl:
                  'https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/cultural-state/$imageKey/$extraSlug/cover.jpg',
              galleryUrls: [
                'https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/cultural-state/$imageKey/$extraSlug/gallery/1.jpg',
              ],
              sortOrder: 2,
            ),
          );
        }

        return CulturalStateHub(
          id: hubId,
          category: category,
          slug:
              '${category.dbValue}-${state.code.replaceFirst('IN-', '').toLowerCase()}',
          stateCode: state.code,
          stateName: state.name,
          latitude: state.lat,
          longitude: state.lng,
          pinHideZoomMax: state.pinHideZoomMax,
          sortOrder: state.order,
          items: items,
        );
      })
      .toList(growable: false);
}

final List<CulturalStateHub> kClassicalArtStateHubs = _buildFallback(
  CulturalCategory.classicalArt,
  _artItemByState,
);

final List<CulturalStateHub> kClassicalDanceStateHubs = _buildFallback(
  CulturalCategory.classicalDance,
  _danceItemByState,
);

List<CulturalStateHub> fallbackHubsForCategory(CulturalCategory category) {
  return category == CulturalCategory.classicalDance
      ? kClassicalDanceStateHubs
      : kClassicalArtStateHubs;
}
