import 'package:myitihas/pages/map2/indian_foods/food_item.dart';
import 'package:myitihas/pages/map2/indian_foods/food_state_hub.dart';

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

const _foodNamesByState = <String, List<String>>{
  'IN-AP': ['Pulihora', 'Bellam Pongali'],
  'IN-AR': ['Apong Rice Cake'],
  'IN-AS': ['Til Pitha', 'Khar'],
  'IN-BR': ['Litti Chokha', 'Thekua'],
  'IN-CT': ['Faraa'],
  'IN-GA': ['Khatkhate'],
  'IN-GJ': ['Undhiyu', 'Khichdi Kadhi'],
  'IN-HR': ['Bajra Khichdi'],
  'IN-HP': ['Madra'],
  'IN-JH': ['Dhuska'],
  'IN-KA': ['Bisi Bele Bath', 'Kosambari'],
  'IN-KL': ['Avial', 'Palada Payasam'],
  'IN-MP': ['Dal Bafla', 'Bhutte ka Kees'],
  'IN-MH': ['Puran Poli', 'Sabudana Khichdi'],
  'IN-MN': ['Chakhao Kheer'],
  'IN-ML': ['Pumaloi'],
  'IN-MZ': ['Bai'],
  'IN-NL': ['Sticky Rice Cake'],
  'IN-OR': ['Dalma', 'Khiri'],
  'IN-PB': ['Makki Roti with Sarson Saag', 'Panjiri'],
  'IN-RJ': ['Dal Baati Churma', 'Ghevar'],
  'IN-SK': ['Sel Roti'],
  'IN-TN': ['Sakkarai Pongal', 'Kozhukattai'],
  'IN-TS': ['Sakinalu', 'Pulihora'],
  'IN-TR': ['Awandru'],
  'IN-UP': ['Mathura Peda', 'Kachori Sabzi'],
  'IN-UK': ['Kafuli', 'Jhangora Kheer'],
  'IN-WB': ['Shukto', 'Narkel Naru'],
  'IN-AN': ['Coconut Rice Prasadam'],
  'IN-CH': ['Atta Pinni'],
  'IN-DN': ['Dudh Pak'],
  'IN-DL': ['Bedmi Puri Aloo'],
  'IN-JK': ['Rajma Gogji'],
  'IN-LA': ['Khambir with Ghee'],
  'IN-LD': ['Coconut Jaggery Laddoo'],
  'IN-PY': ['Puliyodarai'],
};

String _slugify(String value) {
  return value
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
}

String _uuidLike(String seed) {
  final bytes = seed.codeUnits.fold<int>(
    0,
    (sum, e) => (sum * 31 + e) & 0x7fffffff,
  );
  final hex = bytes.toRadixString(16).padLeft(8, '0');
  return '$hex-${hex.substring(0, 4)}-${hex.substring(4, 8)}-f00d-${hex}cafe';
}

final List<FoodStateHub> kFoodStateHubs = _stateSeeds
    .map((state) {
      final foodNames =
          _foodNamesByState[state.code] ?? const ['Regional food'];
      final hubId = _uuidLike('${state.code}-hub');
      final codePart = state.code.replaceFirst('IN-', '').toLowerCase();

      final items = foodNames
          .asMap()
          .entries
          .map((entry) {
            final index = entry.key;
            final foodName = entry.value;
            final foodSlug = _slugify(foodName);
            final discussionSiteId = _uuidLike(
              '${state.code}-$foodSlug-discussion',
            );
            return FoodItem(
              id: _uuidLike('${state.code}-$foodSlug-item'),
              hubId: hubId,
              foodName: foodName,
              shortDescription:
                  '$foodName is a culturally rooted state food tradition associated with local Hindu festive and devotional contexts.',
              aboutFood:
                  '$foodName is mapped at state level for ${state.name}. The profile focuses on indigenous, community-rooted food traditions and excludes Mughal court-origin dishes.',
              history:
                  'The food evolved through households, temple kitchens, and seasonal rituals in ${state.name}.',
              ingredients:
                  'Regional grains, lentils, jaggery, coconut, native spices, and seasonal produce.',
              preparationStyle:
                  'Prepared in traditional home-style methods with region-specific tempering and slow-cooking practices.',
              servingContext:
                  'Common in festivals, vrata meals, temple offerings, and ceremonial family gatherings.',
              nutritionNotes:
                  'Usually grain-legume balanced with seasonal ingredients and moderate spice profiles.',
              bestSeason: 'Year-round (peak during festivals)',
              discussionSiteId: discussionSiteId,
              coverImageUrl:
                  'https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/state-foods/$codePart/$foodSlug/cover.jpg',
              galleryUrls: [
                'https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/state-foods/$codePart/$foodSlug/gallery/1.jpg',
              ],
              sortOrder: index + 1,
            );
          })
          .toList(growable: false);

      return FoodStateHub(
        id: hubId,
        slug: 'food-$codePart',
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
