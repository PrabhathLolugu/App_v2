import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myitihas/pages/map2/Model/sacred_location.dart';
import 'package:myitihas/pages/map2/intent_choice/widget/bloc/pilgrimage_bloc.dart';
import 'package:myitihas/pages/map2/intent_choice/widget/pilgrimage_event.dart';
import 'package:myitihas/pages/map2/intent_choice/widget/pilgrimage_state.dart';
import 'package:myitihas/pages/map2/map_navigation.dart';
import 'package:myitihas/pages/map2/widgets/map_header_nav.dart';
import 'package:sizer/sizer.dart';

/// Lightweight Explore screen listing sacred sites with link to the map.
class MapExplorePage extends StatelessWidget {
  const MapExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _MapExploreView();
  }
}

class _MapExploreView extends StatefulWidget {
  const _MapExploreView();

  @override
  State<_MapExploreView> createState() => _MapExploreViewState();
}

class _MapExploreViewState extends State<_MapExploreView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SacredLocation> _filterLocations(
    List<SacredLocation> locations,
    String query,
  ) {
    if (query.trim().isEmpty) return locations;
    final lower = query.trim().toLowerCase();
    return locations.where((loc) {
      final matchName = loc.name.toLowerCase().contains(lower);
      final matchRegion =
          loc.region != null && loc.region!.toLowerCase().contains(lower);
      final matchDesc = loc.description != null &&
          loc.description!.toLowerCase().contains(lower);
      return matchName || matchRegion || matchDesc;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<PilgrimageBloc, PilgrimageState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final locations = state.allLocations;
        final filtered =
            _filterLocations(locations, _searchController.text);

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            goBackToMapLanding(context);
          },
          child: Scaffold(
            appBar: MapTabHeader(
              currentIndex: 0,
              actions: [
                TextButton.icon(
                  onPressed: () => goToMapWithSavedState(context),
                  icon: const Icon(Icons.map_outlined, size: 20),
                  label: const Text('Open Map'),
                ),
              ],
            ),
          body: locations.isEmpty
                    ? Center(
                        child: Text(
                          'No sacred sites loaded.',
                          style: theme.textTheme.bodyLarge,
                        ),
                      )
                    : filtered.isEmpty
                        ? Center(
                            child: Text(
                              'No sites match your search.',
                              style: theme.textTheme.bodyLarge,
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 2.h,
                            ),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final site = filtered[index];
                              return _SiteListTile(
                                location: site,
                                onTap: () =>
                                    context.push('/site-detail', extra: site),
                              );
                            },
                          ),
        ),
      );
      },
    );
  }
}

class _SiteListTile extends StatelessWidget {
  final SacredLocation location;
  final VoidCallback onTap;

  const _SiteListTile({
    required this.location,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.only(bottom: 1.5.h),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(
            Icons.temple_hindu,
            color: theme.colorScheme.onPrimaryContainer,
            size: 22,
          ),
        ),
        title: Text(
          location.name,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: location.region != null
            ? Text(
                location.region!,
                style: theme.textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
