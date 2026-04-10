import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myitihas/core/navigation/home_back_stack.dart';
import 'package:myitihas/pages/map2/map_state_storage.dart';

/// Navigates back to the previously visited page when possible (stack pop),
/// otherwise to the map home (e.g. when user landed via bottom bar).
/// If no valid back page exists, navigates to home page to prevent app exit.
void goBackToMapLanding(BuildContext context) {
  if (context.canPop()) {
    context.pop();
    return;
  }

  if (HomeBackStack.goBack(context)) {
    return;
  }

  final uri = GoRouterState.of(context).uri;
  if (uri.path != '/home') {
    context.go('/home?tab=3');
    return;
  }

  final tab = uri.queryParameters['tab'];
  final map = uri.queryParameters['map'];

  // Inside home map subtabs, fallback to map landing first.
  if (tab == '3' && map != null && map.isNotEmpty) {
    context.go('/home?tab=3');
    return;
  }

  // Final fallback is main shell (Social tab by default).
  context.go('/home?tab=2');
}

/// Alternative back handler that always goes to home to prevent app exit
void goBackToHomeInstead(BuildContext context) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go('/home?tab=2');
  }
}

Future<void> goToMapWithSavedState(BuildContext context) async {
  await MapStateStorage.loadSelectedIntents();
  if (!context.mounted) return;
  // Note: we can't easily pass 'intents' as a direct object to context.go,
  // but MapStateStorage will be loaded by AkhandaBharataMap on init anyway,
  // since MapTabContent instantiates it with selectedIntents: const [].
  context.go('/home?tab=3&map=akhanda');
}

/// Navigate to the main Akhanda map tab and highlight a specific sacred site.
///
/// The site will appear with an orange pin and can be tapped to open its
/// preview card.
void goToMapFocusingSite(BuildContext context, int siteId) {
  context.go('/home?tab=3&map=akhanda&focus=$siteId');
}
