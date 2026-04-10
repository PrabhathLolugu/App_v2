import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/pages/map2/indian_foods/food_catalog_repository.dart';
import 'package:myitihas/pages/map2/indian_foods/food_item_detail_payload.dart';
import 'package:myitihas/pages/map2/indian_foods/food_state_hub.dart';
import 'package:myitihas/pages/map2/indian_foods/food_state_preview_sheet.dart';
import 'package:sizer/sizer.dart';

class StateFoodsMapPage extends StatefulWidget {
  const StateFoodsMapPage({super.key});

  @override
  State<StateFoodsMapPage> createState() => _StateFoodsMapPageState();
}

class _StateFoodsMapPageState extends State<StateFoodsMapPage> {
  static const LatLng _indiaCenter = LatLng(22.5937, 79.9629);
  final _repository = FoodCatalogRepository();
  bool _isLoading = true;
  String? _error;
  List<FoodStateHub> _hubs = const [];
  double _currentZoom = 4.8;
  final Set<String> _visitedStateCodes = {};
  String? _tappedStateCode;

  @override
  void initState() {
    super.initState();
    _loadHubs();
  }

  Future<void> _loadHubs() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final hubs = await _repository.loadStateHubs();
      if (!mounted) return;
      setState(() {
        _hubs = hubs;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  bool _isHubVisibleAtZoom(FoodStateHub hub) {
    // State-level pins only; hide when zoom gets too specific.
    return _currentZoom >= 4.0 && _currentZoom <= hub.pinHideZoomMax;
  }

  Set<Marker> get _markers {
    return _hubs
        .where(_isHubVisibleAtZoom)
        .map(
          (hub) {
            final useGreen = _visitedStateCodes.contains(hub.stateCode) ||
                _tappedStateCode == hub.stateCode;
            return Marker(
              markerId: MarkerId('food-${hub.stateCode}'),
              position: LatLng(hub.latitude, hub.longitude),
              infoWindow: InfoWindow(
                title: hub.stateName,
                snippet: '${hub.items.length} food entries',
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                useGreen
                    ? BitmapDescriptor.hueGreen
                    : BitmapDescriptor.hueBlue,
              ),
              onTap: () => _showStateSheet(hub),
            );
          },
        )
        .toSet();
  }

  Future<void> _showStateSheet(FoodStateHub hub) async {
    setState(() => _tappedStateCode = hub.stateCode);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: 52.h,
          child: FoodStatePreviewSheet(
            stateName: hub.stateName,
            items: hub.items,
            onItemTap: (item) async {
              Navigator.of(context).pop();
              await FoodItemDetailRoute(
                $extra: FoodItemDetailPayload(
                  stateName: hub.stateName,
                  item: item,
                ),
              ).push(this.context);
              if (!mounted) return;
              setState(() => _visitedStateCodes.add(hub.stateCode));
            },
          ),
        );
      },
    );
    if (mounted) setState(() => _tappedStateCode = null);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Indian Foods by State')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null && _hubs.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Indian Foods by State')),
        body: Center(
          child: FilledButton.icon(
            onPressed: _loadHubs,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry loading'),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Indian Foods by State')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _indiaCenter,
              zoom: 4.8,
            ),
            minMaxZoomPreference: const MinMaxZoomPreference(4.0, 18.0),
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            },
            markers: _markers,
            onCameraMove: (position) {
              final nextZoom = position.zoom;
              if ((nextZoom - _currentZoom).abs() < 0.15) return;
              setState(() => _currentZoom = nextZoom);
            },
          ),
          Positioned(
            left: 4.w,
            right: 4.w,
            top: 1.4.h,
            child: Card(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                child: Text(
                  'State-level pins only. Zooming in hides pins to avoid city-level confusion.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
