import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myitihas/pages/map2/Model/sacred_location.dart';
import 'package:myitihas/pages/map2/intent_choice/widget/pilgrimage_event.dart';
import 'package:myitihas/pages/map2/intent_choice/widget/pilgrimage_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PilgrimageBloc extends Bloc<PilgrimageEvent, PilgrimageState> {
  final _supabase = Supabase.instance.client;
  PilgrimageBloc() : super(const PilgrimageState()) {
    on<LoadJourneyData>(_onLoadData);
    on<ToggleIntent>(_onToggleIntent);
    on<ToggleFavorite>(_onToggleFavorite);
    on<MarkSiteVisited>(_onMarkVisited);
    on<AddReflection>(_onAddReflection);
    on<UpdateIntents>(_onUpdateIntents);
  }

  Future<void> _onLoadData(
    LoadJourneyData event,
    Emitter<PilgrimageState> emit,
  ) async {
    emit(state.copyWith(isLoading: true)); // Start loading state

    try {
      final prefs = await SharedPreferences.getInstance();

      // 1. FETCH REMOTE DATA FROM SUPABASE
      final response = await _supabase.from('sacred_locations').select();
      final allLocations = (response as List)
          .map((json) => SacredLocation.fromJson(json))
          .toList();

      // 2. LOAD LOCAL PERSISTENCE (Favorites, Visited, etc.)
      final favorites = (prefs.getStringList('favorite_sites') ?? [])
          .map((id) => int.tryParse(id) ?? 0)
          .toSet();

      final intents = prefs.getStringList('selected_intents') ?? [];
      final visited = (prefs.getStringList('visited_sites') ?? [])
          .map((id) => int.tryParse(id) ?? 0)
          .toList();

      final String storedHistory = prefs.getString('visit_history') ?? '{}';
      final Map<String, dynamic> historyJson = jsonDecode(storedHistory);
      final Map<int, String> history = historyJson.map(
        (k, v) => MapEntry(int.parse(k), v.toString()),
      );

      final reflectionsJson = prefs.getStringList('reflections') ?? [];
      final reflections = reflectionsJson
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .toList();

      emit(
        state.copyWith(
          allLocations: allLocations, // New Supabase data
          selectedIntents: intents.toSet(),
          visitedSiteIds: visited,
          favoriteSiteIds: favorites,
          reflections: reflections,
          visitHistory: history,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: "Error connecting to servers: $e",
        ),
      );
    }
  }

  Future<void> _onAddReflection(
    AddReflection event,
    Emitter<PilgrimageState> emit,
  ) async {
    final updatedReflections = List<Map<String, dynamic>>.from(
      state.reflections,
    )..insert(0, event.reflection);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'reflections',
      updatedReflections.map((item) => jsonEncode(item)).toList(),
    );

    emit(state.copyWith(reflections: updatedReflections));
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<PilgrimageState> emit,
  ) async {
    final updatedFavorites = Set<int>.from(state.favoriteSiteIds);

    if (updatedFavorites.contains(event.siteId)) {
      updatedFavorites.remove(event.siteId);
    } else {
      updatedFavorites.add(event.siteId);
    }

    // Persist to SharedPreferences as a list of strings
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'favorite_sites',
      updatedFavorites.map((id) => id.toString()).toList(),
    );

    emit(state.copyWith(favoriteSiteIds: updatedFavorites));
  }

  Future<void> _onMarkVisited(
    MarkSiteVisited event,
    Emitter<PilgrimageState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Load existing history Map {siteId: visitDate}
    final String storedData = prefs.getString('visit_history') ?? '{}';
    final Map<String, dynamic> history = jsonDecode(storedData);

    // 2. Load the ordered list of keys to manage the "Queue" of 5
    List<String> orderedKeys = prefs.getStringList('ordered_visit_keys') ?? [];

    if (history.containsKey(event.siteId.toString())) {
      // Toggle off: Remove if already exists
      history.remove(event.siteId.toString());
      orderedKeys.remove(event.siteId.toString());
    } else {
      // Toggle on: Add new visit
      final date = DateTime.now();
      final dateString = "${date.day}/${date.month}/${date.year}";

      // If we already have 5, remove the oldest (first in the list)
      // if (orderedKeys.length >= 5) {
      //   String oldestKey = orderedKeys.removeAt(0);
      //   history.remove(oldestKey);
      // }

      // Add the new site to the end of the queue
      orderedKeys.add(event.siteId.toString());
      history[event.siteId.toString()] = dateString;
    }

    // 3. Persist both the data and the order
    await prefs.setString('visit_history', jsonEncode(history));
    await prefs.setStringList('ordered_visit_keys', orderedKeys);
    // Simple ID list for markers and progress percentage
    await prefs.setStringList('visited_sites', history.keys.toList());

    emit(
      state.copyWith(
        visitedSiteIds: history.keys.map(int.parse).toList(),
        visitHistory: history.map(
          (k, v) => MapEntry(int.parse(k), v.toString()),
        ),
      ),
    );
  }

  Future<void> _onToggleIntent(
    ToggleIntent event,
    Emitter<PilgrimageState> emit,
  ) async {
    final updatedIntents = Set<String>.from(state.selectedIntents);

    if (updatedIntents.contains(event.intentId)) {
      updatedIntents.remove(event.intentId);
    } else {
      updatedIntents.add(event.intentId);
      // When selecting another option, unselect "All Sacred Sites"
      if (event.intentId != 'All') {
        updatedIntents.remove('All');
      } else {
        // When selecting "All", clear other intents (mutual exclusivity)
        updatedIntents.removeWhere((id) => id != 'All');
      }
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selected_intents', updatedIntents.toList());

    emit(state.copyWith(selectedIntents: updatedIntents));
  }

  Future<void> _onUpdateIntents(
    UpdateIntents event,
    Emitter<PilgrimageState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selected_intents', event.intents.toList());
    emit(state.copyWith(selectedIntents: event.intents));
  }
}
