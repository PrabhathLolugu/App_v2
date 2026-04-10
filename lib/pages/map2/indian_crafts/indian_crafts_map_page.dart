import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/pages/map2/forum_community/discussion_hashtag_utils.dart';
import 'package:myitihas/pages/map2/forum_community/forum_discussion_launch_context.dart';
import 'package:myitihas/pages/map2/indian_crafts/craft_catalog_repository.dart';
import 'package:myitihas/pages/map2/indian_crafts/craft_hub.dart';
import 'package:myitihas/pages/map2/indian_crafts/craft_preview_card_widget.dart';
import 'package:sizer/sizer.dart';

class IndianCraftsMapPage extends StatefulWidget {
  const IndianCraftsMapPage({super.key});

  @override
  State<IndianCraftsMapPage> createState() => _IndianCraftsMapPageState();
}

class _IndianCraftsMapPageState extends State<IndianCraftsMapPage> {
  static const LatLng _indiaCenter = LatLng(20.5937, 78.9629);
  final _repository = CraftCatalogRepository();
  bool _isLoading = true;
  String? _error;
  List<CraftHub> _hubs = const [];
  CraftHub? _selected;
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
    return _hubs
        .map(
          (hub) {
            final isVisited = _visitedHubIds.contains(hub.id);
            final isSelected = _selected?.id == hub.id;
            final useGreen = isVisited || isSelected;
            return Marker(
              markerId: MarkerId(hub.id),
              position: LatLng(hub.latitude, hub.longitude),
              infoWindow: InfoWindow(title: hub.name, snippet: hub.craftName),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                useGreen
                    ? BitmapDescriptor.hueGreen
                    : BitmapDescriptor.hueBlue,
              ),
              onTap: () => setState(() => _selected = hub),
            );
          },
        )
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error != null && _hubs.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Indian hand-made crafts')),
        body: Center(
          child: FilledButton.icon(
            onPressed: _loadHubs,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry loading crafts'),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Indian hand-made crafts')),
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
            minMaxZoomPreference: const MinMaxZoomPreference(4.0, 18.0),
            markers: _markers,
            onTap: (_) => setState(() => _selected = null),
          ),
          if (_selected != null)
            Positioned(
              left: 4.w,
              right: 4.w,
              bottom: 10.h + bottomInset,
              child: CraftPreviewCardWidget(
                hub: _selected!,
                onClose: () => setState(() => _selected = null),
                onDetails: () async {
                  final hub = _selected!;
                  await CraftHubDetailRoute($extra: hub).push(context);
                  if (!mounted) return;
                  setState(() => _visitedHubIds.add(hub.id));
                },
                onDiscussion: () {
                  final hub = _selected!;
                  ForumCommunityRoute(
                    siteId: 'general',
                    $extra: ForumDiscussionLaunchContext(
                      suggestedHashtags: buildHashtagsFromParts([
                        hub.craftName,
                        'Indian Crafts',
                        hub.name,
                        hub.state,
                        hub.region,
                      ]),
                      originSiteId: hub.discussionSiteId,
                      siteName: hub.name,
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
