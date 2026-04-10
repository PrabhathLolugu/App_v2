import 'package:equatable/equatable.dart';
import 'package:myitihas/pages/map2/Model/sacred_location.dart';

class PilgrimageState extends Equatable {
  final List<SacredLocation> allLocations;
  final Set<String> selectedIntents;
  final List<int> visitedSiteIds;
  final Set<int> favoriteSiteIds; // Track favorites
  final bool isLoading;
  final List<Map<String, dynamic>> reflections;
  final Map<int, String> visitHistory;
  final String? errorMessage;

  const PilgrimageState({
    this.allLocations = const [],
    this.selectedIntents = const {},
    this.visitedSiteIds = const [],
    this.favoriteSiteIds = const {},
    this.isLoading = true,
    this.reflections = const [],
    this.visitHistory = const {},
    this.errorMessage,
  });
  double get completionPercentage =>
      visitedSiteIds.isEmpty ? 0 : (visitedSiteIds.length / 27) * 100;
  PilgrimageState copyWith({
    List<SacredLocation>? allLocations,
    Set<String>? selectedIntents,
    List<int>? visitedSiteIds,
    Set<int>? favoriteSiteIds,
    bool? isLoading,
    List<Map<String, dynamic>>? reflections,
    Map<int, String>? visitHistory,
    String? errorMessage,
  }) {
    return PilgrimageState(
      allLocations: allLocations ?? this.allLocations,
      selectedIntents: selectedIntents ?? this.selectedIntents,
      visitedSiteIds: visitedSiteIds ?? this.visitedSiteIds,
      favoriteSiteIds: favoriteSiteIds ?? this.favoriteSiteIds,
      isLoading: isLoading ?? this.isLoading,
      reflections: reflections ?? this.reflections,
      visitHistory: visitHistory ?? this.visitHistory,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    allLocations,
    selectedIntents,
    visitedSiteIds,
    favoriteSiteIds,
    isLoading,
    reflections,
    visitHistory,
    errorMessage,
  ];
}
