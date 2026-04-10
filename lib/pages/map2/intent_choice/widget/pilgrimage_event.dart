abstract class PilgrimageEvent {
  const PilgrimageEvent();
}

class LoadJourneyData extends PilgrimageEvent {
  const LoadJourneyData();
}

class AddReflection extends PilgrimageEvent {
  final Map<String, dynamic> reflection;
  const AddReflection(this.reflection);
}

class ToggleIntent extends PilgrimageEvent {
  final String intentId;
  const ToggleIntent(this.intentId);
}

// Added events for Map interactions
class ToggleFavorite extends PilgrimageEvent {
  final int siteId;
  const ToggleFavorite(this.siteId);
}

class MarkSiteVisited extends PilgrimageEvent {
  final int siteId;
  const MarkSiteVisited(this.siteId);
}

class UpdateIntents extends PilgrimageEvent {
  final Set<String> intents;
  const UpdateIntents(this.intents);
}
