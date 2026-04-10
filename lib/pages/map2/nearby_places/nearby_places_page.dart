import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/pages/map2/Model/sacred_location.dart';
import 'package:myitihas/pages/map2/intent_choice/widget/bloc/pilgrimage_bloc.dart';
import 'package:myitihas/pages/map2/intent_choice/widget/pilgrimage_event.dart';
import 'package:myitihas/pages/map2/intent_choice/widget/pilgrimage_state.dart';
import 'package:myitihas/pages/map2/nearby_places/nearby_insights_cache_service.dart';
import 'package:myitihas/pages/map2/widgets/custom_image_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NearbyPlacesPage extends StatefulWidget {
  final SacredLocation selectedLocation;

  const NearbyPlacesPage({
    super.key,
    required this.selectedLocation,
  });

  @override
  State<NearbyPlacesPage> createState() => _NearbyPlacesPageState();
}

class _NearbyPlacesPageState extends State<NearbyPlacesPage> {
  static const List<double> _radiusOptionsKm = [50, 100, 200, 300];
  static const double _defaultRadiusKm = 200;
  static const Duration _insightsCacheTtl = Duration(hours: 12);

  final NearbyInsightsCacheService _nearbyInsightsCacheService = NearbyInsightsCacheService();
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _cardKeys = {};

  double _selectedRadiusKm = _defaultRadiusKm;
  bool _isSelectedSiteLoading = false;
  Map<String, dynamic>? _selectedSiteData;

  bool _isInsightsLoading = false;
  String? _insightsError;
  _NearbyInsights? _insights;
  String? _insightsSourceLabel;
  GoogleMapController? _mapController;
  int? _selectedNearbySiteId;
  String _lastInsightsKey = '';
  String _lastMapFitKey = '';
  Timer? _insightsDebounce;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<PilgrimageBloc>();
    if (bloc.state.allLocations.isEmpty && !bloc.state.isLoading) {
      bloc.add(const LoadJourneyData());
    }
    _fetchSelectedSiteData();
  }

  @override
  void dispose() {
    _insightsDebounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  GlobalKey _cardKeyFor(int siteId) {
    return _cardKeys.putIfAbsent(siteId, GlobalKey.new);
  }

  double _toRad(double deg) => deg * math.pi / 180;

  double _haversineKm(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0;
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);
    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRad(lat1)) *
            math.cos(_toRad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return r * c;
  }

  double _pilgrimageRelevanceScore(SacredLocation location) {
    var score = 0.0;

    final intents = location.intent.map((e) => e.toLowerCase()).toSet();
    if (intents.contains('pilgrimage')) score += 3.0;
    if (intents.contains('worship')) score += 2.0;
    if (intents.contains('spiritual')) score += 1.5;

    final type = (location.type ?? '').toLowerCase();
    if (type.contains('temple')) score += 2.5;
    if (type.contains('jyotirling')) score += 2.0;
    if (type.contains('shakti')) score += 1.8;
    if (type.contains('ashram')) score += 1.2;

    if ((location.tradition ?? '').trim().isNotEmpty) {
      score += 0.7;
    }
    if ((location.description ?? '').trim().isNotEmpty) {
      score += 0.4;
    }

    return score;
  }

  List<_RankedNearbySite> _rankNearbySites(List<SacredLocation> allLocations) {
    final ranked = <_RankedNearbySite>[];
    for (final location in allLocations) {
      if (location.id == widget.selectedLocation.id) continue;

      final distanceKm = _haversineKm(
        widget.selectedLocation.latitude,
        widget.selectedLocation.longitude,
        location.latitude,
        location.longitude,
      );

      if (distanceKm > _selectedRadiusKm) continue;

      ranked.add(
        _RankedNearbySite(
          location: location,
          distanceKm: distanceKm,
          relevanceScore: _pilgrimageRelevanceScore(location),
        ),
      );
    }

    ranked.sort((a, b) {
      final relevanceCompare = b.relevanceScore.compareTo(a.relevanceScore);
      if (relevanceCompare != 0) return relevanceCompare;

      final distanceCompare = a.distanceKm.compareTo(b.distanceKm);
      if (distanceCompare != 0) return distanceCompare;

      return a.location.name.toLowerCase().compareTo(b.location.name.toLowerCase());
    });

    return ranked;
  }

  Future<void> _fetchSelectedSiteData() async {
    setState(() {
      _isSelectedSiteLoading = true;
    });

    try {
      final response = await Supabase.instance.client
          .from('site_details')
          .select()
          .eq('id', widget.selectedLocation.id)
          .maybeSingle();

      if (!mounted) return;
      setState(() {
        _selectedSiteData = response;
        _isSelectedSiteLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isSelectedSiteLoading = false;
      });
    }
  }

  void _maybeLoadInsights(List<_RankedNearbySite> rankedNearby) {
    final localeCode = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    final top = rankedNearby.take(8).toList();
    final key =
        '${widget.selectedLocation.id}-${_selectedRadiusKm.toInt()}-$localeCode-${top.map((e) => e.location.id).join('-')}';

    if (key == _lastInsightsKey) return;
    _lastInsightsKey = key;

    _insightsDebounce?.cancel();
    _insightsDebounce = Timer(const Duration(milliseconds: 250), () {
      _loadInsights(top, localeCode: localeCode);
    });
  }

  String _buildInsightsCacheKey(List<_RankedNearbySite> rankedNearby, String localeCode) {
    final topIds = rankedNearby.take(8).map((site) => site.location.id).join('-');
    return 'nearby-insights-${widget.selectedLocation.id}-${_selectedRadiusKm.toInt()}-$localeCode-$topIds';
  }

  Future<void> _loadInsights(
    List<_RankedNearbySite> rankedNearby, {
    required String localeCode,
    bool forceRefresh = false,
  }) async {
    if (!mounted) return;
    if (rankedNearby.isEmpty) {
      setState(() {
        _insights = null;
        _isInsightsLoading = false;
        _insightsError = null;
        _insightsSourceLabel = null;
      });
      return;
    }

    setState(() {
      _isInsightsLoading = true;
      _insightsError = null;
    });

    final cacheKey = _buildInsightsCacheKey(rankedNearby, localeCode);
    if (!forceRefresh) {
      final cached = await _nearbyInsightsCacheService.read(
        cacheKey,
        ttl: _insightsCacheTtl,
      );
      if (!mounted) return;
      if (cached != null) {
        setState(() {
          _insights = _NearbyInsights.fromDynamic(cached);
          _isInsightsLoading = false;
          _insightsError = null;
          _insightsSourceLabel = 'Cached guidance';
        });
        return;
      }
    }

    final body = {
      'selectedLocation': {
        'id': widget.selectedLocation.id,
        'name': widget.selectedLocation.name,
        'region': widget.selectedLocation.region,
        'type': widget.selectedLocation.type,
        'tradition': widget.selectedLocation.tradition,
        'description': widget.selectedLocation.description,
        'latitude': widget.selectedLocation.latitude,
        'longitude': widget.selectedLocation.longitude,
      },
      'radiusKm': _selectedRadiusKm,
      'nearbyLocations': rankedNearby
          .map(
            (site) => {
              'id': site.location.id,
              'name': site.location.name,
              'region': site.location.region,
              'type': site.location.type,
              'tradition': site.location.tradition,
              'description': site.location.description,
              'distanceKm': site.distanceKm,
              'latitude': site.location.latitude,
              'longitude': site.location.longitude,
            },
          )
          .toList(),
    };

    try {
      final response = await Supabase.instance.client.functions.invoke(
        'generate-nearby-pilgrimage-insights',
        body: body,
      );

      if (!mounted) return;

      if (response.status >= 200 && response.status < 300 && response.data != null) {
        final parsed = _NearbyInsights.fromDynamic(response.data);
        await _nearbyInsightsCacheService.write(
          cacheKey,
          Map<String, dynamic>.from(response.data as Map),
        );
        if (!mounted) return;
        setState(() {
          _insights = parsed;
          _isInsightsLoading = false;
          _insightsError = null;
          _insightsSourceLabel = 'Fresh guidance';
        });
        return;
      }

      setState(() {
        _isInsightsLoading = false;
        _insightsError = 'Live insights are unavailable right now.';
        _insightsSourceLabel = 'Local guidance';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isInsightsLoading = false;
        _insightsError = 'Live insights are unavailable right now.';
        _insightsSourceLabel = 'Local guidance';
      });
    }
  }

  void _focusNearbySite(_RankedNearbySite rankedSite, List<_RankedNearbySite> rankedNearby) {
    setState(() {
      _selectedNearbySiteId = rankedSite.location.id;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _cardKeyFor(rankedSite.location.id).currentContext;
      if (context == null) return;
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 320),
        alignment: 0.12,
        curve: Curves.easeInOut,
      );
    });

    _syncMapViewport(rankedNearby);
  }

  void _scheduleMapFit(List<_RankedNearbySite> rankedNearby) {
    final fitKey = '${widget.selectedLocation.id}-${_selectedRadiusKm.toInt()}-${_selectedNearbySiteId ?? 'none'}-${rankedNearby.map((e) => e.location.id).join('-')}';
    if (fitKey == _lastMapFitKey) return;
    _lastMapFitKey = fitKey;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncMapViewport(rankedNearby);
    });
  }

  Future<void> _syncMapViewport(List<_RankedNearbySite> rankedNearby) async {
    final controller = _mapController;
    if (controller == null || !mounted) return;

    final points = <LatLng>[
      LatLng(widget.selectedLocation.latitude, widget.selectedLocation.longitude),
      ...rankedNearby.take(20).map((site) => LatLng(site.location.latitude, site.location.longitude)),
    ];

    try {
      if (points.length <= 1) {
        await controller.animateCamera(
          CameraUpdate.newLatLngZoom(points.first, 8.2),
        );
        return;
      }

      var minLat = points.first.latitude;
      var maxLat = points.first.latitude;
      var minLng = points.first.longitude;
      var maxLng = points.first.longitude;

      for (final point in points.skip(1)) {
        if (point.latitude < minLat) minLat = point.latitude;
        if (point.latitude > maxLat) maxLat = point.latitude;
        if (point.longitude < minLng) minLng = point.longitude;
        if (point.longitude > maxLng) maxLng = point.longitude;
      }

      if ((minLat - maxLat).abs() < 0.0001 && (minLng - maxLng).abs() < 0.0001) {
        await controller.animateCamera(
          CameraUpdate.newLatLngZoom(points.first, 8.2),
        );
        return;
      }

      await controller.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(minLat, minLng),
            northeast: LatLng(maxLat, maxLng),
          ),
          56,
        ),
      );
    } catch (_) {
      await controller.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(widget.selectedLocation.latitude, widget.selectedLocation.longitude),
          7.6,
        ),
      );
    }
  }

  Future<void> _openDirections(SacredLocation site) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${site.latitude},${site.longitude}&travelmode=driving',
    );
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to open directions for ${site.name}.')),
      );
    }
  }

  Future<void> _toggleFavorite(int siteId) async {
    context.read<PilgrimageBloc>().add(ToggleFavorite(siteId));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Updated favorites.')),
    );
  }

  Future<void> _markVisited(int siteId) async {
    context.read<PilgrimageBloc>().add(MarkSiteVisited(siteId));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Updated visited sites.')),
    );
  }

  String _selectedSummaryFallback() {
    final selectedAbout = (_selectedSiteData?['about'] ?? '').toString().trim();
    if (selectedAbout.isNotEmpty) return selectedAbout;

    final locationDescription = (widget.selectedLocation.description ?? '').trim();
    if (locationDescription.isNotEmpty) return locationDescription;

    return '${widget.selectedLocation.name} is a sacred destination for pilgrims. Nearby temples and spiritual landmarks are curated below for your journey.';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final localeCode = Localizations.localeOf(context).languageCode;

    return BlocBuilder<PilgrimageBloc, PilgrimageState>(
      builder: (context, state) {
        final rankedNearby = _rankNearbySites(state.allLocations);
        _scheduleMapFit(rankedNearby);
        _maybeLoadInsights(rankedNearby);

        return Scaffold(
          appBar: AppBar(
            title: Text('Nearby Pilgrimage Sites'),
          ),
          body: state.isLoading && state.allLocations.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () async {
                    context.read<PilgrimageBloc>().add(const LoadJourneyData());
                    await _fetchSelectedSiteData();
                    _lastInsightsKey = '';
                    await _loadInsights(
                      rankedNearby,
                      localeCode: localeCode,
                      forceRefresh: true,
                    );
                  },
                  child: ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    children: [
                      _buildRadiusSelector(colorScheme),
                      const SizedBox(height: 12),
                      _buildMapPreview(rankedNearby),
                      const SizedBox(height: 14),
                      _buildSelectedSummaryCard(colorScheme),
                      if (_isInsightsLoading) ...[
                        const SizedBox(height: 10),
                        const LinearProgressIndicator(minHeight: 2.5),
                      ],
                      if (_isInsightsLoading && _insights == null) ...[
                        const SizedBox(height: 12),
                        _buildNearbySkeletonCard(),
                        const SizedBox(height: 12),
                        _buildNearbySkeletonCard(),
                      ],
                      if (_insightsError != null) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colorScheme.errorContainer.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: colorScheme.error.withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.info_outline_rounded, color: colorScheme.error, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _insightsError!,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: colorScheme.error,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextButton(
                                      onPressed: () {
                                        _lastInsightsKey = '';
                                        _loadInsights(
                                          rankedNearby,
                                          localeCode: localeCode,
                                          forceRefresh: true,
                                        );
                                      },
                                      child: const Text('Retry insights'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 14),
                      if (rankedNearby.isEmpty)
                        _buildEmptyState()
                      else
                        ...rankedNearby.asMap().entries.map((entry) {
                          final index = entry.key;
                          final rankedSite = entry.value;
                          final insight = _insights?.insightFor(rankedSite.location.name);
                          final siteId = rankedSite.location.id;
                          return Padding(
                            key: _cardKeyFor(siteId),
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _buildNearbySiteCard(
                              index: index,
                              rankedSite: rankedSite,
                              insight: insight,
                              isSelected: siteId == _selectedNearbySiteId,
                              isFavorite: state.favoriteSiteIds.contains(siteId),
                              isVisited: state.visitedSiteIds.contains(siteId),
                              onTap: () => _focusNearbySite(rankedSite, rankedNearby),
                              onOpenDetail: () => SiteDetailRoute($extra: rankedSite.location).push(context),
                              onOpenDirections: () => _openDirections(rankedSite.location),
                              onToggleFavorite: () => _toggleFavorite(siteId),
                              onMarkVisited: () => _markVisited(siteId),
                            ),
                          );
                        }),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildRadiusSelector(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.48),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Places to visit nearby',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Showing sacred sites within ${_selectedRadiusKm.toStringAsFixed(0)} km',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _radiusOptionsKm.map((radius) {
              final selected = radius == _selectedRadiusKm;
              return ChoiceChip(
                selected: selected,
                onSelected: (_) {
                  if (selected) return;
                  setState(() {
                    _selectedRadiusKm = radius;
                    _lastInsightsKey = '';
                  });
                },
                label: Text('${radius.toInt()} km'),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPreview(List<_RankedNearbySite> rankedNearby) {
    final visitedIds = context.read<PilgrimageBloc>().state.visitedSiteIds.toSet();

    final nearbyMarkers = rankedNearby.take(20).map((site) {
      final isSelected = _selectedNearbySiteId == site.location.id;
      final isVisited = visitedIds.contains(site.location.id);
      return Marker(
        markerId: MarkerId('nearby-${site.location.id}'),
        position: LatLng(site.location.latitude, site.location.longitude),
        infoWindow: InfoWindow(
          title: site.location.name,
          snippet: '${site.distanceKm.toStringAsFixed(0)} km away',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          isSelected
              ? BitmapDescriptor.hueAzure
              : isVisited
                  ? BitmapDescriptor.hueGreen
                  : BitmapDescriptor.hueOrange,
        ),
        onTap: () => _focusNearbySite(site, rankedNearby),
      );
    });

    final selectedMarker = Marker(
      markerId: MarkerId('selected-${widget.selectedLocation.id}'),
      position: LatLng(
        widget.selectedLocation.latitude,
        widget.selectedLocation.longitude,
      ),
      infoWindow: InfoWindow(
        title: widget.selectedLocation.name,
        snippet: 'Selected site',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    );

    return Container(
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: GoogleMap(
          onMapCreated: (controller) {
            _mapController = controller;
            _syncMapViewport(rankedNearby);
          },
          initialCameraPosition: CameraPosition(
            target: LatLng(
              widget.selectedLocation.latitude,
              widget.selectedLocation.longitude,
            ),
            zoom: 7.1,
          ),
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          markers: {selectedMarker, ...nearbyMarkers},
          circles: {
            Circle(
              circleId: const CircleId('radius'),
              center: LatLng(
                widget.selectedLocation.latitude,
                widget.selectedLocation.longitude,
              ),
              radius: _selectedRadiusKm * 1000,
              fillColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              strokeColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.45),
              strokeWidth: 2,
            ),
          },
          gestureRecognizers: {
            Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
          },
        ),
      ),
    );
  }

  Widget _buildSelectedSummaryCard(ColorScheme colorScheme) {
    final aiSummary = _insights?.selectedSummary.trim();
    final bestTime = _insights?.selectedBestTime.trim();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About ${widget.selectedLocation.name}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          if (_isSelectedSiteLoading && (aiSummary == null || aiSummary.isEmpty))
            const LinearProgressIndicator(minHeight: 2.2)
          else
            Text(
              aiSummary != null && aiSummary.isNotEmpty
                  ? aiSummary
                  : _selectedSummaryFallback(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.42),
            ),
          if (bestTime != null && bestTime.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.event_available_rounded, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Best time to visit: $bestTime',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ],
          if (_insightsSourceLabel != null) ...[
            const SizedBox(height: 10),
            _smallChip(_insightsSourceLabel!),
          ],
        ],
      ),
    );
  }

  Widget _buildNearbySiteCard({
    required int index,
    required _RankedNearbySite rankedSite,
    _NearbySiteInsight? insight,
    required bool isSelected,
    required bool isFavorite,
    required bool isVisited,
    required VoidCallback onTap,
    required VoidCallback onOpenDetail,
    required VoidCallback onOpenDirections,
    required VoidCallback onToggleFavorite,
    required VoidCallback onMarkVisited,
  }) {
    final site = rankedSite.location;
    final summary = (insight?.shortDescription ?? site.description ?? '').trim();
    final bestTime = (insight?.bestTimeToVisit ?? '').trim();
    final tips = (insight?.pilgrimTips ?? '').trim();

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLowest.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.65)
                : Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.45),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: CustomImageWidget(
                imageUrl: site.image,
                height: 178,
                width: double.infinity,
                fit: BoxFit.cover,
                useSacredPlaceholder: true,
                sacredPlaceholderSeed: site.name,
                semanticLabel: site.name,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${index + 1}. ${site.name}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _smallChip('${rankedSite.distanceKm.toStringAsFixed(0)} km'),
                      if (site.type != null && site.type!.trim().isNotEmpty)
                        _smallChip(site.type!.trim()),
                      if (isVisited) _smallChip('Visited'),
                      if (isFavorite) _smallChip('Saved'),
                      if (_insightsSourceLabel != null) _smallChip(_insightsSourceLabel!),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _actionChip(
                        icon: Icons.open_in_new_rounded,
                        label: 'Details',
                        onTap: onOpenDetail,
                      ),
                      _actionChip(
                        icon: Icons.directions_rounded,
                        label: 'Directions',
                        onTap: onOpenDirections,
                      ),
                      _actionChip(
                        icon: isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        label: isFavorite ? 'Saved' : 'Save',
                        onTap: onToggleFavorite,
                      ),
                      _actionChip(
                        icon: Icons.verified_rounded,
                        label: isVisited ? 'Visited' : 'Mark visited',
                        onTap: onMarkVisited,
                      ),
                    ],
                  ),
                  if (summary.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      summary,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4),
                    ),
                  ],
                  if (bestTime.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'When to visit: $bestTime',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  if (tips.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Pilgrim tip: $tips',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }

  Widget _actionChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ActionChip(
      onPressed: onTap,
      avatar: Icon(icon, size: 16),
      label: Text(label),
    );
  }

  Widget _buildNearbySkeletonCard() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 178,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 16, width: 180, color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(height: 22, width: 66, decoration: BoxDecoration(color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45), borderRadius: BorderRadius.circular(999))),
                    const SizedBox(width: 8),
                    Container(height: 22, width: 76, decoration: BoxDecoration(color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45), borderRadius: BorderRadius.circular(999))),
                  ],
                ),
                const SizedBox(height: 10),
                Container(height: 12, width: double.infinity, color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45)),
                const SizedBox(height: 8),
                Container(height: 12, width: 220, color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      child: Text(
        'No pilgrimage sites found in ${_selectedRadiusKm.toStringAsFixed(0)} km. Try increasing the radius or refresh for a new view.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class _RankedNearbySite {
  final SacredLocation location;
  final double distanceKm;
  final double relevanceScore;

  const _RankedNearbySite({
    required this.location,
    required this.distanceKm,
    required this.relevanceScore,
  });
}

class _NearbyInsights {
  final String selectedSummary;
  final String selectedBestTime;
  final Map<String, _NearbySiteInsight> bySiteName;

  const _NearbyInsights({
    required this.selectedSummary,
    required this.selectedBestTime,
    required this.bySiteName,
  });

  factory _NearbyInsights.fromDynamic(dynamic data) {
    if (data is! Map) {
      return const _NearbyInsights(
        selectedSummary: '',
        selectedBestTime: '',
        bySiteName: {},
      );
    }

    final selectedSummary = (data['selectedSummary'] ?? '').toString();
    final selectedBestTime = (data['selectedBestTime'] ?? '').toString();

    final nearby = data['nearby'];
    final bySiteName = <String, _NearbySiteInsight>{};

    if (nearby is List) {
      for (final item in nearby) {
        if (item is! Map) continue;
        final name = (item['name'] ?? '').toString().trim();
        if (name.isEmpty) continue;
        bySiteName[name.toLowerCase()] = _NearbySiteInsight.fromMap(item);
      }
    }

    return _NearbyInsights(
      selectedSummary: selectedSummary,
      selectedBestTime: selectedBestTime,
      bySiteName: bySiteName,
    );
  }

  _NearbySiteInsight? insightFor(String siteName) {
    return bySiteName[siteName.toLowerCase().trim()];
  }
}

class _NearbySiteInsight {
  final String shortDescription;
  final String bestTimeToVisit;
  final String pilgrimTips;

  const _NearbySiteInsight({
    required this.shortDescription,
    required this.bestTimeToVisit,
    required this.pilgrimTips,
  });

  factory _NearbySiteInsight.fromMap(Map<dynamic, dynamic> map) {
    return _NearbySiteInsight(
      shortDescription: (map['shortDescription'] ?? '').toString(),
      bestTimeToVisit: (map['bestTimeToVisit'] ?? '').toString(),
      pilgrimTips: (map['pilgrimTips'] ?? '').toString(),
    );
  }
}
