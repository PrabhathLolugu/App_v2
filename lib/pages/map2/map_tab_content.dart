import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myitihas/pages/map2/akhanda_bharata_map/akhanda_bharata_map.dart';
import 'package:myitihas/pages/map2/intent_choice/intent_choice.dart';
import 'package:myitihas/pages/map2/my_journey/my_journey.dart';
import 'package:myitihas/pages/map2/forum_community/forum_community.dart';
import 'package:myitihas/pages/map2/plan/plan_page.dart';
import 'package:myitihas/pages/map2/map_explore/map_explore_page.dart';

/// Content for the Map tab on [HomePage]. Shows [IntentChoice] by default,
/// or [AkhandaBharataMap] without the floating bar when route has map=akhanda
/// (so the main app nav bar is the only bottom bar).
class MapTabContent extends StatefulWidget {
  const MapTabContent({super.key});

  @override
  State<MapTabContent> createState() => _MapTabContentState();
}

class _MapTabContentState extends State<MapTabContent> {
  // Map strings to their respective index in the stack.
  final Map<String, int> _tabIndexMap = {
    'intent': 0,
    'akhanda': 1,
    'journey': 2,
    'discussions': 3,
    'plan': 4,
    'explore': 5,
  };

  int _getPageIndex(String? mapScreen) {
    if (mapScreen == null || !_tabIndexMap.containsKey(mapScreen)) {
      return 0; // default IntentChoice
    }
    return _tabIndexMap[mapScreen]!;
  }

  @override
  Widget build(BuildContext context) {
    final mapScreen = GoRouterState.of(context).uri.queryParameters['map'];
    final currentIndex = _getPageIndex(mapScreen);

    return IndexedStack(
      index: currentIndex,
      children: [
        IntentChoice(), // 0
        const AkhandaBharataMap(
          selectedIntents: [],
          showFloatingBar: false,
        ), // 1
        const MyJourney(), // 2
        const ForumCommunity(siteId: 'general'), // 3
        const PlanPage(), // 4
        const MapExplorePage(), // 5
      ],
    );
  }
}
