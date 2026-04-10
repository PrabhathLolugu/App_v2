import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/pages/map2/forum_community/discussion_hashtag_utils.dart';
import 'package:myitihas/pages/map2/forum_community/forum_discussion_launch_context.dart';
import 'package:myitihas/pages/map2/indian_fabrics/fabric_catalog_repository.dart';
import 'package:myitihas/pages/map2/indian_fabrics/fabric_hub.dart';
import 'package:myitihas/pages/map2/indian_fabrics/fabric_preview_card_widget.dart';
import 'package:sizer/sizer.dart';

/// Standalone India map for traditional fabric hubs (no sacred-site pins).
class IndianFabricsMapPage extends StatefulWidget {
  const IndianFabricsMapPage({super.key});

  @override
  State<IndianFabricsMapPage> createState() => _IndianFabricsMapPageState();
}

class _IndianFabricsMapPageState extends State<IndianFabricsMapPage> {
  static const LatLng _indiaCenter = LatLng(20.5937, 78.9629);
  final _repository = FabricCatalogRepository();
  bool _isLoading = true;
  String? _error;
  List<FabricHub> _hubs = const [];
  FabricHub? _selected;
  final Set<String> _visitedHubIds = {};

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
      final hubs = await _repository.loadHubs();
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

  Set<Marker> get _markers {
    return _hubs.map((hub) {
      final isVisited = _visitedHubIds.contains(hub.id);
      final isSelected = _selected?.id == hub.id;
      final useGreen = isVisited || isSelected;
      return Marker(
        markerId: MarkerId(hub.id),
        position: LatLng(hub.latitude, hub.longitude),
        infoWindow: InfoWindow(title: hub.name, snippet: hub.fabricName),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          useGreen ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueBlue,
        ),
        onTap: () => setState(() => _selected = hub),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(t.map.fabricMap.screenTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null && _hubs.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(t.map.fabricMap.screenTitle)),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cloud_off_outlined,
                  size: 30.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(height: 1.5.h),
                Text(
                  'Unable to load fabric hubs right now.',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 1.h),
                FilledButton.icon(
                  onPressed: _loadHubs,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_hubs.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(t.map.fabricMap.screenTitle)),
        body: const Center(child: Text('No fabric hubs available yet.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(t.map.fabricMap.screenTitle)),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _indiaCenter,
              zoom: 4.8,
            ),
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            },
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            rotateGesturesEnabled: true,
            tiltGesturesEnabled: true,
            minMaxZoomPreference: const MinMaxZoomPreference(4.0, 18.0),
            markers: _markers,
            onTap: (_) => setState(() => _selected = null),
          ),
          if (_selected != null)
            Positioned(
              left: 4.w,
              right: 4.w,
              bottom: 10.h + bottomInset,
              child: FabricPreviewCardWidget(
                hub: _selected!,
                onClose: () => setState(() => _selected = null),
                onDetails: () async {
                  final h = _selected!;
                  await FabricHubDetailRoute($extra: h).push(context);
                  if (!mounted) return;
                  setState(() => _visitedHubIds.add(h.id));
                },
                onDiscussion: () {
                  final h = _selected!;
                  ForumCommunityRoute(
                    siteId: 'general',
                    $extra: ForumDiscussionLaunchContext(
                      suggestedHashtags: buildHashtagsFromParts([
                        h.fabricName,
                        'Indian Fabrics',
                        h.name,
                        h.state,
                        h.region,
                      ]),
                      originSiteId: h.discussionSiteId,
                      siteName: h.name,
                      defaultLocationMode: true,
                    ),
                  ).push(context);
                },
              ),
            ),
        ],
      ),
    );
  }
}
