import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:myitihas/core/widgets/image_loading_placeholder/image_loading_placeholder.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/pages/map2/Model/sacred_location.dart';
import 'package:myitihas/pages/map2/akhanda_bharata_map/widget/filter_chips_widget.dart';
import 'package:myitihas/pages/map2/akhanda_bharata_map/widget/location_preview_card_widget.dart';
import 'package:myitihas/pages/map2/akhanda_bharata_map/widget/search_filter_bar_widget.dart';
import 'package:myitihas/pages/map2/forum_community/discussion_hashtag_utils.dart';
import 'package:myitihas/pages/map2/forum_community/forum_discussion_launch_context.dart';
import 'package:myitihas/pages/map2/widgets/map_header_nav.dart';
import 'package:myitihas/pages/map2/app_theme.dart';
import 'package:myitihas/pages/map2/intent_choice/widget/bloc/pilgrimage_bloc.dart';
import 'package:myitihas/pages/map2/intent_choice/widget/pilgrimage_event.dart';
import 'package:myitihas/pages/map2/intent_choice/widget/pilgrimage_state.dart';
import 'package:myitihas/pages/map2/custom_site/custom_site_input_page.dart';
import 'package:myitihas/pages/map2/custom_site/custom_site_models.dart';
import 'package:myitihas/pages/map2/custom_site/custom_site_storage_service.dart';
import 'package:myitihas/pages/map2/site_detail/site_detail.dart';
import 'package:myitihas/pages/map2/map_navigation.dart';
import 'package:myitihas/pages/map2/map_state_storage.dart';
import 'package:myitihas/pages/map2/widgets/custom_icon_widget.dart';
import 'package:sizer/sizer.dart';

class AkhandaBharataMap extends StatelessWidget {
  final List<String> selectedIntents;
  final bool showFloatingBar;

  const AkhandaBharataMap({
    super.key,
    required this.selectedIntents,
    this.showFloatingBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return _AkhandaBharataMapContent(
      initialIntents: selectedIntents,
      showFloatingBar: showFloatingBar,
    );
  }
}

class _AkhandaBharataMapContent extends StatefulWidget {
  final List<String> initialIntents;
  final bool showFloatingBar;

  const _AkhandaBharataMapContent({
    required this.initialIntents,
    this.showFloatingBar = true,
  });

  @override
  State<_AkhandaBharataMapContent> createState() =>
      _AkhandaBharataMapContentState();
}

class _AkhandaBharataMapContentState extends State<_AkhandaBharataMapContent> {
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  static const double _otherSitesVisibleZoom = 10.0;

  bool _isLoading = false;
  // ignore: unused_field - set when location is unavailable for future offline UI
  bool _isOfflineMode = false;
  Position? _currentPosition;

  SacredLocation? _selectedLocation;
  int? _focusedSiteId;
  bool _hasAppliedFocus = false;
  List<SacredLocation> _customSiteLocations = [];
  List<String> _activeFilters = [];
  String _currentSearchQuery = '';
  String? _currentMapStyleJson;
  String _selectedThemeName = 'Standard';
  double _currentZoom = 4.8;
  String _normalizeToken(String value) => value.trim().toLowerCase();

  /// Ensures (lat, lng) for India: corrects if data was stored as (lng, lat).
  /// India bounds: lat ~8–37, lng ~68–97.
  static LatLng _toMapLatLng(double lat, double lng) {
    const double indiaLatMin = 8.0, indiaLatMax = 37.0;
    const double indiaLngMin = 68.0, indiaLngMax = 97.0;
    final a = lat;
    final b = lng;
    final aLooksLng = a >= indiaLngMin && a <= indiaLngMax;
    final bLooksLat = b >= indiaLatMin && b <= indiaLatMax;
    if (aLooksLng && bLooksLat) {
      return LatLng(b, a); // was (lng, lat)
    }
    return LatLng(a, b);
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialIntents.isNotEmpty) {
      context.read<PilgrimageBloc>().add(
        UpdateIntents(widget.initialIntents.toSet()),
      );
    }
    // _updateMarkers(_sacredLocations);
    _initializeLocation();
    _searchController.addListener(_onSearchTextChanged);
    _restoreMapState();
    _persistMapState();
    _loadCustomSites();
  }

  /// Load saved custom sites so they appear on the map and "View in Map" works for them.
  Future<void> _loadCustomSites() async {
    final saved = await CustomSiteStorageService.loadSavedSites();
    if (!mounted) return;
    setState(() {
      _customSiteLocations = saved.map((s) => s.location).toList();
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Sync focus from URL so "View in Map" from a new site updates the pin and camera
    final focusParam = GoRouterState.of(context).uri.queryParameters['focus'];
    final int? requestedFocusId =
        focusParam != null ? int.tryParse(focusParam) : null;
    if (requestedFocusId != _focusedSiteId) {
      _focusedSiteId = requestedFocusId;
      _hasAppliedFocus = false; // allow camera to animate to the (new) focused site
      if (mounted) setState(() {});
    }
  }

  final MapStyle _mapStyleSource = MapStyle();
  List<Map<String, dynamic>> get _mapThemes => [
    {
      'name': 'Standard',
      'style': null,
      'image':
          "https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/sacred-sites/Standard.png",
    },

    {
      'name': 'Retro',
      'style': _mapStyleSource.retro,
      'image':
          'https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/sacred-sites/Retro.png',
    },
    {
      'name': 'Aubergine',
      'style': _mapStyleSource.aubergine,
      'image':
          "https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/sacred-sites/Aubergine.png",
    },
  ];
  void _onThemePressed() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildThemeBottomSheet(),
    );
  }

  Future<void> _restoreMapState() async {
    final savedFilters = await MapStateStorage.loadActiveFilters();
    if (!mounted) return;
    setState(() {
      _activeFilters = savedFilters;
    });
  }

  Future<void> _persistMapState() async {
    await MapStateStorage.saveActiveFilters(_activeFilters);
  }

  void _onPlaceSelected(SacredLocation location) async {
    setState(() {
      _selectedLocation = location;
      _currentSearchQuery = '';
      _searchController.clear();
    });

    // Animate the map camera to the selected temple
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newLatLngZoom(
        _toMapLatLng(location.latitude, location.longitude),
        14, // Zoom in closer for the selected site
      ),
    );
  }

  Widget _buildThemeBottomSheet() {
    final theme = Theme.of(context);
    return Container(
      height: 25.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          SizedBox(height: 1.h),
          Text('Map Layers', style: theme.textTheme.titleMedium),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(4.w),
              itemCount: _mapThemes.length,
              itemBuilder: (context, index) {
                final item = _mapThemes[index];
                final isSelected = _selectedThemeName == item['name'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedThemeName = item['name'];
                      _currentMapStyleJson = item['style'];
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 30.w,
                    margin: EdgeInsets.only(right: 4.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.navigationOrange
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              item['image'],
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const ImageLoadingPlaceholder();
                              },
                              errorBuilder: (c, e, s) =>
                                  Container(color: Colors.grey),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            item['name'],
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapControls() {
    return Positioned(
      bottom: 11.h,
      right: 4.w,
      child: Column(
        children: [
          // Theme Selection Button
          FloatingActionButton(
            heroTag: 'themeBtn',
            onPressed: _onThemePressed,
            backgroundColor: AppTheme.containerWhite,
            mini: true,
            child: const Icon(Icons.layers, color: Colors.black54),
          ),
          SizedBox(height: 1.5.h),
          // My Location Button
          FloatingActionButton(
            heroTag: 'locBtn',
            onPressed: () {}, // Implementation...
            backgroundColor: AppTheme.navigationOrange,
            child: const Icon(Icons.my_location, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // Consolidation of filtering logic to handle search, chips, and BLoC state
  List<SacredLocation> _getFilteredLocations(
    List<SacredLocation> allSites,
    Set<String> intentSet,
  ) {
    Iterable<SacredLocation> filtered = allSites;
    final selectedIntents = intentSet
        .map(_normalizeToken)
        .where((intent) => intent.isNotEmpty)
        .toList();
    final isAllMode = selectedIntents.contains('all');
    final isOtherMode = selectedIntents.contains('other');

    // 1. Filter by Intent (Shaktipeethas, Jyotirlinga, etc.)
    if (selectedIntents.isNotEmpty && !isAllMode) {
      filtered = filtered.where((loc) {
        return loc.intent.any(
          (intent) => selectedIntents.contains(_normalizeToken(intent)),
        );
      });
    }

    // In "All" mode, "Other Sacred Sites" are intentionally suppressed until
    // the user zooms in to reduce clutter.
    if (isAllMode && !isOtherMode) {
      filtered = filtered.where((loc) {
        final isOtherSite = loc.intent.any(
          (intent) => _normalizeToken(intent) == 'other',
        );
        if (!isOtherSite) {
          return true;
        }
        return _currentZoom >= _otherSitesVisibleZoom;
      });
    }

    if (_currentSearchQuery.isNotEmpty) {
      filtered = filtered.where((loc) {
        return loc.name.toLowerCase().contains(
          _currentSearchQuery.toLowerCase(),
        );
      });
    }

    if (_activeFilters.isNotEmpty) {
      final normalizedFilters = _activeFilters.map(_normalizeToken).toSet();
      filtered = filtered.where((loc) {
        final locType = _normalizeToken(loc.type ?? '');
        final locRegion = _normalizeToken(loc.region ?? '');
        final locTradition = _normalizeToken(loc.tradition ?? '');

        // Broaden matching for better user experience
        return normalizedFilters.any((filter) {
          // Check if filter matches type (e.g., "shiva temple" matches "shiva temple")
          if (locType.contains(filter) || filter.contains(locType)) return true;
          // Check if filter matches region
          if (locRegion.contains(filter) || filter.contains(locRegion)) {
            return true;
          }
          // Check if filter matches tradition (e.g., "shiva temple" matches "shaiva")
          if (locTradition.contains(filter) ||
              filter.contains(locTradition) ||
              (filter.contains('shiva') && locTradition.contains('shaiva')) ||
              (filter.contains('vishnu') && locTradition.contains('vaishnava')) ||
              (filter.contains('shakti') && locTradition.contains('shakta'))) {
            return true;
          }
          return false;
        });
      });
    }

    return filtered.toList();
  }

  void _onFilterChipRemoved(String filter) {
    setState(() {
      _activeFilters.remove(filter);
    });
    _persistMapState();
  }

  void _onSearchTextChanged() {
    setState(() {
      _currentSearchQuery = _searchController.text;
    });
  }

  Future<void> _initializeLocation() async {
    setState(() => _isLoading = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoading = false;
          _isOfflineMode = true;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isLoading = false;
            _isOfflineMode = true;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoading = false;
          _isOfflineMode = true;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });
      // Don't auto-center on user location - keep showing India. User taps
      // My Location button to move to their position.
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isOfflineMode = true;
      });
    }
  }

  void _onFilterPressed() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFilterBottomSheet(),
    );
  }

  Future<void> _onCustomSitePressed() async {
    final result = await Navigator.of(context).push<CustomSiteGenerationResult>(
      MaterialPageRoute(builder: (_) => const CustomSiteInputPage()),
    );
    if (!mounted || result == null) return;

    if (result.publishedLocationId != null) {
      context.read<PilgrimageBloc>().add(const LoadJourneyData());
    }

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SiteDetail(
          location: result.sacredLocation,
          preloadedSiteData: result.siteDetails,
          customSubmissionId:
              result.publishedLocationId == null ? result.submissionId : null,
          customChatPrimer: result.chatPrimer,
        ),
      ),
    );
    if (!mounted) return;
    await _loadCustomSites();
  }

  Widget _buildFilterBottomSheet() {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 10.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 1.5.h),
            Text('Filter Sacred Sites', style: theme.textTheme.titleLarge),
            SizedBox(height: 2.h),
            Text('Temple Type', style: theme.textTheme.titleMedium),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 0.5.h,
              children: [
                'Shiva Temple',
                'Vishnu Temple',
                'Shakti Temple',
                'Other',
              ]
                  .map(
                    (type) => FilterChip(
                      label: Text(type),
                      selected: _activeFilters.contains(type),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _activeFilters.add(type);
                          } else {
                            _activeFilters.remove(type);
                          }
                        });
                        _persistMapState();
                        // Removed Navigator.pop so user can select multiple filters at once
                      },
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 1.5.h),
            Text('Region', style: theme.textTheme.titleMedium),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 0.5.h,
              children:
                  ['North India', 'South India', 'East India', 'West India']
                      .map(
                        (region) => FilterChip(
                          label: Text(region),
                          selected: _activeFilters.contains(region),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _activeFilters.add(region);
                              } else {
                                _activeFilters.remove(region);
                              }
                            });
                            _persistMapState();
                          },
                        ),
                      )
                      .toList(),
            ),
            SizedBox(height: 2.h),

            SizedBox(
              width: double.infinity,
              child: Container(
                height: 5.5.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _activeFilters.clear();
                    });
                    _persistMapState();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),

                  label: Text(
                    'Clear All Filters',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 1.h),
          ],
        ),
      ),
    );
  }

  void _onMyLocationPressed() async {
    setState(() => _isLoading = true);

    try {
      await _initializeLocation();

      if (_currentPosition != null) {
        final controller = await _controller.future;

        HapticFeedback.mediumImpact();

        await controller.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            15,
          ),
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Unable to fetch current location")),
          );
        }
      }
    } catch (e) {
      debugPrint("Location Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _onCameraMove(CameraPosition position) {
    final nextZoom = position.zoom;
    if ((nextZoom - _currentZoom).abs() < 0.1) return;
    setState(() => _currentZoom = nextZoom);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final textColor = colorScheme.onSurface;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final mapBottomPadding = 13.h;
    final customFabBottom = mapBottomPadding + 16 + bottomInset;
    final selectedCardBottom = customFabBottom + 8.h;
    return BlocBuilder<PilgrimageBloc, PilgrimageState>(
      builder: (context, state) {
        final allSites = [
          ...state.allLocations,
          ..._customSiteLocations,
        ];
        final filteredList = _getFilteredLocations(
          allSites,
          state.selectedIntents,
        );
        SacredLocation? maybeFocusedLocation;
        bool hasFocusedLocation = false;
        if (_focusedSiteId != null) {
          try {
            maybeFocusedLocation =
                allSites.firstWhere((loc) => loc.id == _focusedSiteId);
            hasFocusedLocation = true;
          } catch (_) {
            maybeFocusedLocation = null;
            hasFocusedLocation = false;
          }
        }

        final Set<Marker> markers = filteredList.map((site) {
          final bool isVisited = state.visitedSiteIds.contains(site.id);
          final bool isFocused =
              _focusedSiteId != null && site.id == _focusedSiteId;
          final bool isSelected = _selectedLocation?.id == site.id;
          final bool showGreen = isVisited || isSelected || isFocused;

          return Marker(
            markerId: MarkerId(site.id.toString()),
            position: _toMapLatLng(site.latitude, site.longitude),
            infoWindow: InfoWindow(
              title: site.name,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              showGreen
                  ? BitmapDescriptor.hueGreen
                  : BitmapDescriptor.hueBlue,
            ),
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _selectedLocation = site);
            },
          );
        }).toSet();

        if (hasFocusedLocation && maybeFocusedLocation != null &&
            !filteredList.any((loc) => loc.id == maybeFocusedLocation!.id)) {
          final focused = maybeFocusedLocation;
          markers.add(
            Marker(
              markerId: MarkerId('focused_${focused.id}'),
              position: _toMapLatLng(
                focused.latitude,
                focused.longitude,
              ),
              infoWindow: InfoWindow(
                title: focused.name,
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen,
              ),
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _selectedLocation = focused);
              },
            ),
          );
        }

        if (!_hasAppliedFocus && hasFocusedLocation && maybeFocusedLocation != null) {
          final focused = maybeFocusedLocation;
          _hasAppliedFocus = true;
          final target = _toMapLatLng(focused.latitude, focused.longitude);
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            try {
              final controller = await _controller.future;
              await controller.animateCamera(
                CameraUpdate.newLatLngZoom(target, 14),
              );
            } catch (_) {}
          });
        }
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            goBackToMapLanding(context);
          },
          child: Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: MapTabHeader(currentIndex: 0),
          body: Stack(
            children: [
              Positioned.fill(
                child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(20.5937, 78.9629),
                  zoom: 4.8,
                ),
                onCameraMove: _onCameraMove,
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                  Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer(),
                  ),
                },
                scrollGesturesEnabled: true,
                zoomGesturesEnabled: true,
                rotateGesturesEnabled: true,
                tiltGesturesEnabled: true,
                markers: markers,
                style: _currentMapStyleJson,
                myLocationEnabled: _currentPosition != null,
                myLocationButtonEnabled: false,
                minMaxZoomPreference: const MinMaxZoomPreference(4.0, 18.0),
                onTap: (_) => setState(() => _selectedLocation = null),
                compassEnabled: true,
                mapType: MapType.normal,
              ),
              ),

              _buildMapControls(),

              // Top Overlay - Search and Progress
              Positioned(
                top: 1.0.h,
                left: 0,
                right: 0,
                child: SearchFilterBarWidget(
                  controller: _searchController,
                  onSearchChanged: (value) => _onSearchTextChanged(),
                  onFilterPressed: _onFilterPressed,
                ),
              ),

              if (_currentSearchQuery.isNotEmpty && filteredList.isNotEmpty)
                Positioned(
                  top: 14.h,
                  left: 4.w,
                  right: 4.w,
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(15),

                    color: isDark
                        ? Colors.black.withOpacity(0.6)
                        : Colors.white,
                    child: Container(
                      constraints: BoxConstraints(maxHeight: 40.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: isDark
                              ? theme.colorScheme.outline.withValues(alpha: 0.5)
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: filteredList.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          color: isDark ? Colors.white10 : Colors.grey.shade200,
                        ),
                        itemBuilder: (context, index) {
                          final place = filteredList[index];
                          return ListTile(
                            leading: Icon(
                              Icons.location_on,
                              color: AppTheme.navigationOrange,
                              size: 20.sp,
                            ),
                            title: Text(
                              place.name,
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            onTap: () {
                              _onPlaceSelected(place);
                              FocusScope.of(
                                context,
                              ).unfocus(); // Close keyboard
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 8.h,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_activeFilters.isNotEmpty)
                      FilterChipsWidget(
                        activeFilters: _activeFilters,
                        onRemoveFilter: _onFilterChipRemoved,
                      ),
                  ],
                ),
              ),
              if (_selectedLocation != null)
                Positioned(
                  bottom: selectedCardBottom,
                  left: 4.w,
                  right: 4.w,
                  child: LocationPreviewCardWidget(
                    location: _selectedLocation!,
                    isVisited: state.visitedSiteIds.contains(
                      _selectedLocation!.id,
                    ),
                    isFavorite: state.favoriteSiteIds.contains(
                      _selectedLocation!.id,
                    ),
                    onClose: () => setState(() => _selectedLocation = null),
                    onNavigate: () {
                      context.push('/site-detail', extra: _selectedLocation);
                    },
                    onNavigate_chat: () {
                      final location = _selectedLocation!;
                      ForumCommunityRoute(
                        siteId: 'general',
                        $extra: ForumDiscussionLaunchContext(
                          suggestedHashtags: buildHashtagsFromParts([
                            location.name,
                            location.type,
                            location.tradition,
                            ...location.intent,
                            ...parseRegionTokens(location.region),
                          ]),
                          originSiteId: location.id,
                          siteName: location.name,
                          defaultLocationMode: true,
                        ),
                      ).push(context);
                    },

                    onToggleFavorite: () {
                      context.read<PilgrimageBloc>().add(
                        ToggleFavorite(_selectedLocation!.id),
                      );
                    },
                  ),
                ),

              Positioned(
                left: 4.w,
                bottom: customFabBottom,
                child: Transform.scale(
                  scale: 0.85,
                  child: FloatingActionButton(
                    heroTag: 'customSite',
                    onPressed: _onCustomSitePressed,
                    backgroundColor: AppTheme.navigationOrange,
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ),

              // My Location Button
              Positioned(
                bottom: 11.h,
                right: 4.w,
                child: Transform.scale(
                  scale: 0.85,
                  child: FloatingActionButton(
                  heroTag: 'myLocation',
                  onPressed: _onMyLocationPressed,
                  backgroundColor: AppTheme.navigationOrange,
                  child: CustomIconWidget(
                    iconName: 'my_location',
                    color: AppTheme.containerWhite,
                    size: 24,
                  ),
                ),
              ),
              ),

              // Loading Indicator
              if (_isLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
            ],
          ),
          ),
        );
      },
    );
  }
}

class MapStyle {
  final String aubergine = """
    [
      {
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#1d2c4d"
          }
        ]
      },
      {
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#8ec3b9"
          }
        ]
      },
      {
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#1a3646"
          }
        ]
      },
      {
        "featureType": "administrative.country",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#4b6878"
          }
        ]
      },
      {
        "featureType": "administrative.land_parcel",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#64779e"
          }
        ]
      },
      {
        "featureType": "administrative.province",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#4b6878"
          }
        ]
      },
      {
        "featureType": "landscape.man_made",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#334e87"
          }
        ]
      },
      {
        "featureType": "landscape.natural",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#023e58"
          }
        ]
      },
      {
        "featureType": "poi",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#283d6a"
          }
        ]
      },
      {
        "featureType": "poi",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#6f9ba5"
          }
        ]
      },
      {
        "featureType": "poi",
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#1d2c4d"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "geometry.fill",
        "stylers": [
          {
            "color": "#023e58"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#3C7680"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#304a7d"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#98a5be"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#1d2c4d"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#2c6675"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#255763"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#b0d5ce"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#023e58"
          }
        ]
      },
      {
        "featureType": "transit",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#98a5be"
          }
        ]
      },
      {
        "featureType": "transit",
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#1d2c4d"
          }
        ]
      },
      {
        "featureType": "transit.line",
        "elementType": "geometry.fill",
        "stylers": [
          {
            "color": "#283d6a"
          }
        ]
      },
      {
        "featureType": "transit.station",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#3a4762"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#0e1626"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#4e6d70"
          }
        ]
      }
    ]""";

  final String sliver = """
    [
      {
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#f5f5f5"
          }
        ]
      },
      {
        "elementType": "labels.icon",
        "stylers": [
          {
            "visibility": "off"
          }
        ]
      },
      {
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#616161"
          }
        ]
      },
      {
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#f5f5f5"
          }
        ]
      },
      {
        "featureType": "administrative.land_parcel",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#bdbdbd"
          }
        ]
      },
      {
        "featureType": "poi",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#eeeeee"
          }
        ]
      },
      {
        "featureType": "poi",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#757575"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#e5e5e5"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#9e9e9e"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#ffffff"
          }
        ]
      },
      {
        "featureType": "road.arterial",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#757575"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#dadada"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#616161"
          }
        ]
      },
      {
        "featureType": "road.local",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#9e9e9e"
          }
        ]
      },
      {
        "featureType": "transit.line",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#e5e5e5"
          }
        ]
      },
      {
        "featureType": "transit.station",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#eeeeee"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#c9c9c9"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#9e9e9e"
          }
        ]
      }
    ]""";

  final String retro = """
    [
      {
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#ebe3cd"
          }
        ]
      },
      {
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#523735"
          }
        ]
      },
      {
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#f5f1e6"
          }
        ]
      },
      {
        "featureType": "administrative",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#c9b2a6"
          }
        ]
      },
      {
        "featureType": "administrative.land_parcel",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#dcd2be"
          }
        ]
      },
      {
        "featureType": "administrative.land_parcel",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#ae9e90"
          }
        ]
      },
      {
        "featureType": "landscape.natural",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#dfd2ae"
          }
        ]
      },
      {
        "featureType": "poi",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#dfd2ae"
          }
        ]
      },
      {
        "featureType": "poi",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#93817c"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "geometry.fill",
        "stylers": [
          {
            "color": "#a5b076"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#447530"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#f5f1e6"
          }
        ]
      },
      {
        "featureType": "road.arterial",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#fdfcf8"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#f8c967"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#e9bc62"
          }
        ]
      },
      {
        "featureType": "road.highway.controlled_access",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#e98d58"
          }
        ]
      },
      {
        "featureType": "road.highway.controlled_access",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#db8555"
          }
        ]
      },
      {
        "featureType": "road.local",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#806b63"
          }
        ]
      },
      {
        "featureType": "transit.line",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#dfd2ae"
          }
        ]
      },
      {
        "featureType": "transit.line",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#8f7d77"
          }
        ]
      },
      {
        "featureType": "transit.line",
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#ebe3cd"
          }
        ]
      },
      {
        "featureType": "transit.station",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#dfd2ae"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "geometry.fill",
        "stylers": [
          {
            "color": "#b9d3c2"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#92998d"
          }
        ]
      }
    ]""";

  final String dark = """
    [
      {
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#212121"
          }
        ]
      },
      {
        "elementType": "labels.icon",
        "stylers": [
          {
            "visibility": "off"
          }
        ]
      },
      {
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#757575"
          }
        ]
      },
      {
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#212121"
          }
        ]
      },
      {
        "featureType": "administrative",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#757575"
          }
        ]
      },
      {
        "featureType": "administrative.country",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#9e9e9e"
          }
        ]
      },
      {
        "featureType": "administrative.land_parcel",
        "stylers": [
          {
            "visibility": "off"
          }
        ]
      },
      {
        "featureType": "administrative.locality",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#bdbdbd"
          }
        ]
      },
      {
        "featureType": "poi",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#757575"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#181818"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#616161"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#1b1b1b"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "geometry.fill",
        "stylers": [
          {
            "color": "#2c2c2c"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#8a8a8a"
          }
        ]
      },
      {
        "featureType": "road.arterial",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#373737"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#3c3c3c"
          }
        ]
      },
      {
        "featureType": "road.highway.controlled_access",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#4e4e4e"
          }
        ]
      },
      {
        "featureType": "road.local",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#616161"
          }
        ]
      },
      {
        "featureType": "transit",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#757575"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#000000"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#3d3d3d"
          }
        ]
      }
    ]""";

  final String night = """
    [
      {
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#242f3e"
          }
        ]
      },
      {
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#746855"
          }
        ]
      },
      {
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#242f3e"
          }
        ]
      },
      {
        "featureType": "administrative.locality",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#d59563"
          }
        ]
      },
      {
        "featureType": "poi",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#d59563"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#263c3f"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#6b9a76"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#38414e"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#212a37"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#9ca5b3"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#746855"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#1f2835"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#f3d19c"
          }
        ]
      },
      {
        "featureType": "transit",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#2f3948"
          }
        ]
      },
      {
        "featureType": "transit.station",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#d59563"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#17263c"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#515c6d"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#17263c"
          }
        ]
      }
    ]""";
}
