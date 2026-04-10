import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/core/network/network_info.dart';
import 'package:myitihas/core/utils/app_error_message.dart';
import 'package:myitihas/pages/map2/Model/sacred_location.dart';
import 'package:myitihas/pages/map2/plan/plan_content_view.dart';
import 'package:myitihas/pages/map2/plan/travel_mode_extractor.dart';
import 'package:myitihas/pages/map2/plan/plan_replan_modal.dart';
import 'package:myitihas/pages/map2/plan/booking_operator.dart';
import 'package:myitihas/pages/map2/intent_choice/widget/bloc/pilgrimage_bloc.dart';
import 'package:myitihas/pages/map2/intent_choice/widget/pilgrimage_state.dart';
import 'package:myitihas/pages/map2/map_navigation.dart';
import 'package:myitihas/pages/map2/widgets/map_header_nav.dart';
import 'package:myitihas/pages/Chat/Widget/share_to_conversation_sheet.dart';
import 'package:myitihas/pages/map2/plan/saved_travel_plan.dart';
import 'package:myitihas/services/chat_service.dart';
import 'package:myitihas/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sizer/sizer.dart';

/// Common Indian cities/regions for "from location" dropdown.
const List<String> _fromLocationOptions = [
  'Your location',
  'Mumbai',
  'Delhi',
  'Bangalore',
  'Chennai',
  'Kolkata',
  'Hyderabad',
  'Pune',
  'Ahmedabad',
  'Varanasi',
  'Haridwar',
  'Rishikesh',
  'Other',
];

/// Plan tab: spiritual travel planning with location, dates, destination,
/// AI-generated plan, and option to post travel story to social feed.
class PlanPage extends StatelessWidget {
  const PlanPage({super.key, this.initialDestination, this.customSiteDetails});

  final SacredLocation? initialDestination;
  final Map<String, dynamic>? customSiteDetails;

  @override
  Widget build(BuildContext context) {
    return _PlanPageView(
      initialDestination: initialDestination,
      customSiteDetails: customSiteDetails,
    );
  }
}

class _PlanPageView extends StatefulWidget {
  const _PlanPageView({this.initialDestination, this.customSiteDetails});

  final SacredLocation? initialDestination;
  final Map<String, dynamic>? customSiteDetails;

  @override
  State<_PlanPageView> createState() => _PlanPageViewState();
}

class _PlanPageViewState extends State<_PlanPageView> {
  final NetworkInfo _networkInfo = getIt<NetworkInfo>();
  final _pageScrollController = ScrollController();
  final _fromController = TextEditingController();
  String _selectedFrom = _fromLocationOptions.first;
  String? _resolvedLocation;
  bool _isResolvingLocation = false;
  DateTime? _startDate;
  DateTime? _endDate;
  SacredLocation? _destination;
  String? _planResult;
  bool _isLoading = false;
  String? _error;
  bool _isEditMode = false;
  final _planEditController = TextEditingController();
  bool _isSaving = false;
  final _fromSectionKey = GlobalKey();
  final _datesSectionKey = GlobalKey();
  final _destinationSectionKey = GlobalKey();
  final _nearbySectionKey = GlobalKey();
  final _generatedPlanSectionKey = GlobalKey();
  SavedTravelPlan? _lastSavedPlan;
  List<TravelMode> _detectedTravelModes = [];

  static String _locationDisplay(SacredLocation loc) =>
      '${loc.name}${loc.region != null ? ' (${loc.region})' : ''}';

  String? _buildCustomDestinationContext() {
    final custom = widget.customSiteDetails;
    if (custom == null) return null;
    final parts = <String>[];
    final location = custom['location']?.toString().trim();
    final about = custom['about']?.toString().trim();
    final history = custom['history']?.toString().trim();
    final reach = custom['howToReach']?.toString().trim();
    final bestTime = custom['bestTimeToVisit']?.toString().trim();
    if (location != null && location.isNotEmpty) parts.add('Location: $location.');
    if (about != null && about.isNotEmpty) parts.add('About: $about');
    if (history != null && history.isNotEmpty) parts.add('History: $history');
    if (reach != null && reach.isNotEmpty) parts.add('How to reach: $reach');
    if (bestTime != null && bestTime.isNotEmpty) {
      parts.add('Best time to visit: $bestTime');
    }
    if (parts.isEmpty) return null;
    return parts.join(' ');
  }

  List<String> _customNearbyNames() {
    final custom = widget.customSiteDetails;
    if (custom == null) return const [];
    final raw = custom['nearbyPlaces'] ?? custom['nearby_places'] ?? custom['nearby'];
    if (raw is List) {
      return raw
          .map((e) => e?.toString().trim() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    }
    if (raw is String && raw.trim().isNotEmpty) {
      return [raw.trim()];
    }
    return const [];
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialDestination != null) {
      _destination = widget.initialDestination;
    }
    if (_selectedFrom == 'Your location') {
      _resolveCurrentLocation();
    }
  }

  @override
  void dispose() {
    _pageScrollController.dispose();
    _fromController.dispose();
    _planEditController.dispose();
    super.dispose();
  }

  Future<void> _scrollToSection(GlobalKey key) async {
    final context = key.currentContext;
    if (context == null) return;
    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      alignment: 0.08,
    );
  }

  void _resolveDestinationFromLocations(List<SacredLocation> locations) {
    if (_destination == null || locations.isEmpty) return;
    try {
      final match = locations.firstWhere((l) => l.id == _destination!.id);
      if (match != _destination) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _destination = match);
        });
      }
    } catch (_) {}
  }

  String get _effectiveFromLocation {
    if (_selectedFrom == 'Your location') {
      return _resolvedLocation ?? 'Current location';
    }
    if (_selectedFrom == 'Other') {
      return _fromController.text.trim().isEmpty
          ? 'My city'
          : _fromController.text.trim();
    }
    return _selectedFrom;
  }

  Future<void> _resolveCurrentLocation() async {
    if (!mounted) return;
    setState(() => _isResolvingLocation = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            setState(() {
              _isResolvingLocation = false;
              _resolvedLocation = 'Current location (GPS)';
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Location permission denied. Select a city manually for accurate travel plans.',
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            _isResolvingLocation = false;
            _resolvedLocation = 'Current location (GPS)';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Location access disabled. Please select a city from the list.',
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }

      await Geolocator.getCurrentPosition();
      // Use a generic label; reverse geocoding would require the geocoding package (compileSdk 34+ on Android)
      if (mounted) {
        setState(() {
          _resolvedLocation = 'Current location';
          _isResolvingLocation = false;
        });
      }
    } catch (e) {
      debugPrint('Resolve location error: $e');
      if (mounted) {
        setState(() {
          _resolvedLocation = 'Current location (GPS)';
          _isResolvingLocation = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Could not detect city. Using "Current location". Select a city for more accurate plans.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _generatePlan() async {
    if (_startDate == null || _endDate == null) {
      setState(() => _error = 'Please select start and end dates.');
      return;
    }
    if (_destination == null) {
      setState(() => _error = 'Please select a destination.');
      return;
    }
    if (_endDate!.isBefore(_startDate!)) {
      setState(() => _error = 'End date must be after start date.');
      return;
    }

    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      setState(() {
        _error = kConnectToInternetMessage;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _error = null;
      _planResult = null;
      _isEditMode = false;
      _isLoading = true;
    });

    try {
      final supabase = Supabase.instance.client;
      final bloc = context.read<PilgrimageBloc>();
      final nearby = _getNearbyTemples(_destination!, bloc.state.allLocations);
      var nearbyNames = nearby.map((e) => e.$1.name).toList();
      final bool isCustomDestination = _destination!.id < 0;
      if (nearbyNames.isEmpty && isCustomDestination) {
        nearbyNames = _customNearbyNames();
      }

      final body = <String, dynamic>{
        'fromLocation': _effectiveFromLocation,
        'startDate': _startDate!.toIso8601String().split('T').first,
        'endDate': _endDate!.toIso8601String().split('T').first,
        'destinationId': _destination!.id,
        'destinationName': _destination!.name,
      };
      if (isCustomDestination) {
        final customContext = _buildCustomDestinationContext();
        if (customContext != null && customContext.isNotEmpty) {
          body['customDestinationContext'] = customContext;
        }
      }
      if (nearbyNames.isNotEmpty) {
        body['nearbyTempleNames'] = nearbyNames;
      }

      final response = await supabase.functions.invoke(
        'generate-travel-plan',
        body: body,
      );

      if (response.status >= 200 && response.status < 300 && response.data != null) {
        try {
          final Map<String, dynamic> data = response.data is Map<String, dynamic>
              ? response.data as Map<String, dynamic>
              : (jsonDecode(response.data.toString()) as Map<String, dynamic>);
          final plan = data['plan'] as String? ?? 'No plan returned.';
          if (mounted) {
            // Detect travel modes from the generated plan
            final detectedModes = TravelModeExtractor.extractTravelModes(plan);
            setState(() {
              _planResult = plan;
              _detectedTravelModes = detectedModes;
              _isLoading = false;
            });
          }
        } catch (_) {
          if (mounted) {
            setState(() {
              _error = 'Invalid response from plan service. Please try again.';
              _isLoading = false;
            });
          }
        }
      } else {
        final msg = response.data is Map
            ? (response.data['error'] ?? response.data['message'])
            : response.data?.toString();
        if (mounted) {
          setState(() {
            _error = toUserFriendlyErrorMessage(
              Exception(msg ?? ''),
              fallback: 'Unable to generate plan right now.',
            );
            _isLoading = false;
          });
        }
      }
    } on FunctionException catch (e) {
      debugPrint('Plan FunctionException: status=${e.status} details=${e.details}');
      final message = toUserFriendlyErrorMessage(
        e,
        fallback: 'Unable to generate plan right now.',
      );
      if (mounted) {
        setState(() {
          _error = message;
          _isLoading = false;
        });
      }
    } catch (e, st) {
      debugPrint('Plan generation error: $e');
      debugPrint('$st');
      if (mounted) {
        setState(() {
          _error = toUserFriendlyErrorMessage(
            e,
            fallback: 'Unable to generate plan right now.',
          );
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openPostTravelStory() async {
    await const CreatePostRoute().push(context);
  }

  Future<SavedTravelPlan?> _savePlan() async {
    if (_planResult == null || _planResult!.trim().isEmpty) return null;
    final userId = SupabaseService.client.auth.currentUser?.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign in to save your plan'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return null;
    }
    final planText = _isEditMode
        ? _planEditController.text.trim()
        : _planResult!;
    if (planText.isEmpty) return null;

    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(kConnectToInternetMessage),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return null;
    }

    setState(() => _isSaving = true);
    try {
      final map = <String, dynamic>{
        'user_id': userId,
        'plan': planText,
        'from_location': _effectiveFromLocation,
        'start_date': _startDate?.toIso8601String().split('T').first,
        'end_date': _endDate?.toIso8601String().split('T').first,
        'destination_id': _destination?.id,
        'destination_name': _destination?.name,
        'destination_region': _destination?.region,
        'destination_image': _destination?.image,
        'title': _destination != null && _startDate != null
            ? '${_destination!.name} - ${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
            : _destination?.name ?? 'Pilgrimage Plan',
      };
      final response = await Supabase.instance.client
          .from('saved_travel_plans')
          .insert(map)
          .select()
          .single();
      final savedPlan = SavedTravelPlan.fromJson(response);
      _lastSavedPlan = savedPlan;
      if (_isEditMode) {
        setState(() {
          _planResult = planText;
          _isEditMode = false;
        });
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Plan saved'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return _lastSavedPlan;
    } catch (e) {
      debugPrint('Save plan error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              toUserFriendlyErrorMessage(
                e,
                fallback: 'Unable to save plan right now.',
              ),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
      return _lastSavedPlan;
    }
  }

  /// Handle replan request - opens modal for user to provide feedback
  void _handleReplan() {
    if (_planResult == null || _planResult!.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No plan to replan'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => PlanReplanModal(
        originalPlan: _planResult!,
        fromLocation: _selectedFrom,
        startDate: _startDate?.toIso8601String().split('T').first ?? '',
        endDate: _endDate?.toIso8601String().split('T').first ?? '',
        destinationName: _destination?.name ?? 'Destination',
        destinationContext: _destination?.description,
        onReplanSuccess: (newPlan, changeSummary) {
          // Update the plan and detect new travel modes
          final newModes = TravelModeExtractor.extractTravelModes(newPlan);
          setState(() {
            _planResult = newPlan;
            _detectedTravelModes = newModes;
            _isEditMode = false;
            _planEditController.text = newPlan;
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(changeSummary),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        onReplanError: (error) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Replan failed: $error'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      ),
    );
  }

  static const double _nearbyRadiusKm = 80;

  double _toRad(double deg) => deg * math.pi / 180;

  double _haversineKm(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0;
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRad(lat1)) *
            math.cos(_toRad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return r * c;
  }

  List<(SacredLocation, double)> _getNearbyTemples(
    SacredLocation destination,
    List<SacredLocation> allLocations,
  ) {
    final result = <(SacredLocation, double)>[];
    for (final loc in allLocations) {
      if (loc.id == destination.id) continue;
      final dist = _haversineKm(
        destination.latitude,
        destination.longitude,
        loc.latitude,
        loc.longitude,
      );
      if (dist <= _nearbyRadiusKm) {
        result.add((loc, dist));
      }
    }
    result.sort((a, b) => a.$2.compareTo(b.$2));
    return result.take(10).toList();
  }

  Widget _buildPilgrimagePlanSection({
    required ThemeData theme,
    required ColorScheme colorScheme,
    GradientExtension? gradients,
  }) {
    final daysCount = (_startDate != null && _endDate != null &&
            !_endDate!.isBefore(_startDate!))
        ? _endDate!.difference(_startDate!).inDays + 1
        : null;

    return PlanContentView(
      plan: _planResult!,
      destinationName: _destination?.name,
      destinationRegion: _destination?.region,
      destinationImage: _destination?.image,
      daysCount: daysCount,
      travelModes: _detectedTravelModes,
      fromLocation: _selectedFrom,
      startDate: _startDate?.toIso8601String().split('T').first,
      endDate: _endDate?.toIso8601String().split('T').first,
      onCopy: () {},
      onEdit: () {
        if (_isEditMode) {
          setState(() {
            _isEditMode = false;
            _planEditController.text = _planResult ?? '';
          });
        } else {
          _planEditController.text = _planResult ?? '';
          setState(() => _isEditMode = true);
        }
      },
      onSave: _savePlan,
      onAskGuide: () => MapChatbotRoute($extra: 'Guide me visiting ${_destination!.name}').push(context),
      onReplan: _handleReplan,
      isEditMode: _isEditMode,
      editController: _planEditController,
      onPlanChanged: () => setState(() {}),
      isSaving: _isSaving,
    );
  }

  Widget _buildNearbyTemplesSection({
    Key? key,
    required SacredLocation destination,
    required List<SacredLocation> allLocations,
    required ThemeData theme,
    required ColorScheme colorScheme,
    GradientExtension? gradients,
  }) {
    final nearby = _getNearbyTemples(destination, allLocations);
    if (nearby.isEmpty) return const SizedBox.shrink();

    final isDark = theme.brightness == Brightness.dark;
    final contentBg = gradients?.glassCardBackground ??
        colorScheme.surface.withValues(alpha: isDark ? 0.5 : 0.85);
    final contentBorder = gradients?.glassCardBorder ??
        colorScheme.primary.withValues(alpha: 0.12);

    return Container(
      key: key,
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: contentBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: contentBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.temple_hindu_rounded,
                size: 24,
                color: colorScheme.primary,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Nearby Temples - Special Attractions',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: nearby.length,
              separatorBuilder: (_, __) => SizedBox(width: 2.w),
              itemBuilder: (context, index) {
                final (loc, dist) = nearby[index];
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => SiteDetailRoute($extra: loc).push(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.place_rounded,
                            size: 18,
                            color: colorScheme.primary,
                          ),
                          SizedBox(width: 1.5.w),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                loc.name,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${dist.toStringAsFixed(0)} km',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

  Widget _buildHero(
    ThemeData theme,
    ColorScheme colorScheme,
    GradientExtension? gradients,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Plan your pilgrimage',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
              letterSpacing: -0.2,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'Get a detailed, day-wise spiritual travel plan, save it for later, and turn it into a story for your journey.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanSectionCard({
    Key? sectionKey,
    required ThemeData theme,
    required ColorScheme colorScheme,
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      key: sectionKey,
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.surfaceContainerHigh.withValues(alpha: isDark ? 0.2 : 0.5),
            colorScheme.surfaceContainerHighest.withValues(alpha: isDark ? 0.3 : 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: colorScheme.primary),
              ),
              SizedBox(width: 2.5.w),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.2.h),
          child,
        ],
      ),
    );
  }

  Widget _buildQuickAccessStrip(ThemeData theme) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _quickAccessChip(
            theme,
            label: 'From',
            onTap: () => _scrollToSection(_fromSectionKey),
          ),
          _quickAccessChip(
            theme,
            label: 'Dates',
            onTap: () => _scrollToSection(_datesSectionKey),
          ),
          _quickAccessChip(
            theme,
            label: 'Destination',
            onTap: () => _scrollToSection(_destinationSectionKey),
          ),
          if (_destination != null)
            _quickAccessChip(
              theme,
              label: 'Nearby',
              onTap: () => _scrollToSection(_nearbySectionKey),
            ),
          if (_planResult != null)
            _quickAccessChip(
              theme,
              label: 'Generated Plan',
              onTap: () => _scrollToSection(_generatedPlanSectionKey),
            ),
        ],
      ),
    );
  }

  Widget _quickAccessChip(
    ThemeData theme, {
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        onPressed: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        tooltip: 'Go to $label section',
        label: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradientExt = theme.extension<GradientExtension>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        goBackToMapLanding(context);
      },
      child: Scaffold(
        appBar: MapTabHeader(currentIndex: 3),
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: gradientExt?.screenBackgroundGradient ??
                LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.surface,
                    theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  ],
                ),
          ),
        child: BlocBuilder<PilgrimageBloc, PilgrimageState>(
          builder: (context, state) {
            final locations = state.allLocations;
            final colorScheme = theme.colorScheme;
            final gradients = gradientExt;

            return ListView(
              controller: _pageScrollController,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              children: [
                _buildHero(theme, colorScheme, gradients),
                SizedBox(height: 1.2.h),
                _buildQuickAccessStrip(theme),
                SizedBox(height: 2.h),
                _buildPlanSectionCard(
                  sectionKey: _fromSectionKey,
                  theme: theme,
                  colorScheme: colorScheme,
                  icon: Icons.my_location_rounded,
                  title: 'Where are you travelling from?',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _selectedFrom,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 14,
                                      ),
                                ),
                                items: _fromLocationOptions
                                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                    .toList(),
                                onChanged: (v) {
                                  final newVal = v ?? _fromLocationOptions.first;
                                  setState(() => _selectedFrom = newVal);
                                  if (newVal == 'Your location') {
                                    _resolveCurrentLocation();
                                  } else {
                                    setState(() => _resolvedLocation = null);
                                  }
                                },
                              ),
                            ),
                            if (_selectedFrom == 'Your location' &&
                                _isResolvingLocation) ...[
                              SizedBox(width: 2.w),
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ],
                            if (_selectedFrom == 'Your location' &&
                                !_isResolvingLocation &&
                                _resolvedLocation != null) ...[
                              SizedBox(width: 2.w),
                              Icon(
                                Icons.location_on,
                                color: colorScheme.primary,
                                size: 22,
                              ),
                            ],
                          ],
                        ),
                        if (_selectedFrom == 'Other') ...[
                          SizedBox(height: 1.h),
                          TextField(
                            controller: _fromController,
                            decoration: InputDecoration(
                              hintText: 'Enter your city or region',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                      ],
                    ],
                  ),
                ),
                _buildPlanSectionCard(
                  sectionKey: _datesSectionKey,
                  theme: theme,
                  colorScheme: colorScheme,
                  icon: Icons.date_range_rounded,
                  title: 'Travel dates',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  final d = await showDatePicker(
                                    context: context,
                                    initialDate: _startDate ?? DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                                  );
                                  if (d != null) setState(() => _startDate = d);
                                },
                                icon: const Icon(Icons.calendar_today, size: 18),
                                label: Text(_startDate == null
                                    ? 'Start date'
                                    : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'),
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  final d = await showDatePicker(
                                    context: context,
                                    initialDate: _endDate ?? _startDate ?? DateTime.now(),
                                    firstDate: _startDate ?? DateTime.now(),
                                    lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                                  );
                                  if (d != null) setState(() => _endDate = d);
                                },
                                icon: const Icon(Icons.calendar_today, size: 18),
                                label: Text(_endDate == null
                                    ? 'End date'
                                    : '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'),
                              ),
                            ),
                          ],
                        ),
                        if (_startDate != null && _endDate != null &&
                            !_endDate!.isBefore(_startDate!)) ...[
                          SizedBox(height: 0.5.h),
                          Text(
                            '${_endDate!.difference(_startDate!).inDays + 1} days',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
                _buildPlanSectionCard(
                  sectionKey: _destinationSectionKey,
                  theme: theme,
                  colorScheme: colorScheme,
                  icon: Icons.temple_hindu_rounded,
                  title: 'Destination (sacred site)',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state.isLoading)
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (locations.isEmpty)
                          Padding(
                            padding: EdgeInsets.all(2.h),
                            child: Text(
                              'No sacred sites loaded. Open the map first.',
                              style: theme.textTheme.bodyMedium,
                            ),
                          )
                        else ...[
                          Builder(
                            builder: (context) {
                              _resolveDestinationFromLocations(locations);
                              final combined = List<SacredLocation>.from(locations);
                              if (widget.initialDestination != null &&
                                  !combined.any((l) => l.id == widget.initialDestination!.id)) {
                                combined.insert(0, widget.initialDestination!);
                              }
                              return Autocomplete<SacredLocation>(
                                initialValue: _destination != null
                                    ? TextEditingValue(
                                        text: _locationDisplay(_destination!),
                                      )
                                    : null,
                                displayStringForOption: _locationDisplay,
                                optionsBuilder: (value) {
                                  if (value.text.isEmpty) return combined;
                                  final q = value.text.toLowerCase();
                                  return combined.where((loc) {
                                    final s = _locationDisplay(loc).toLowerCase();
                                    return s.contains(q);
                                  });
                                },
                                onSelected: (loc) {
                                  setState(() => _destination = loc);
                                },
                                fieldViewBuilder: (
                                  context,
                                  controller,
                                  focusNode,
                                  onFieldSubmitted,
                                ) {
                                  if (_destination != null && controller.text.isEmpty) {
                                    controller.text = _locationDisplay(_destination!);
                                  }
                                  return TextFormField(
                                    controller: controller,
                                    focusNode: focusNode,
                                    decoration: InputDecoration(
                                      hintText: 'Search or select destination...',
                                      prefixIcon: const Icon(Icons.search),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 14),
                                    ),
                                    onChanged: (_) => setState(() {}),
                                  );
                                },
                              );
                            },
                          ),
                      ],
                    ],
                  ),
                ),
                if (_destination != null && locations.isNotEmpty)
                  _buildNearbyTemplesSection(
                    key: _nearbySectionKey,
                    destination: _destination!,
                    allLocations: locations,
                    theme: theme,
                    colorScheme: colorScheme,
                    gradients: gradients,
                  ),
                if (_error != null) ...[
                  Card(
                    margin: EdgeInsets.only(bottom: 2.h),
                    color: colorScheme.errorContainer.withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: colorScheme.error.withValues(alpha: 0.5)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: colorScheme.error, size: 22),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              _error!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onErrorContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                SizedBox(height: 1.h),
                Container(
                  decoration: BoxDecoration(
                    gradient: _isLoading ? null : LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.tertiary,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: _isLoading ? null : [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _generatePlan,
                    icon: _isLoading
                        ? SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.auto_awesome, size: 22, color: Colors.white),
                    label: Text(
                      _isLoading ? 'Generating…' : 'Generate plan',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                if (_planResult != null) ...[
                  SizedBox(height: 2.h),
                  Container(
                    key: _generatedPlanSectionKey,
                    child: _buildPilgrimagePlanSection(
                      theme: theme,
                      colorScheme: colorScheme,
                      gradients: gradients,
                    ),
                  ),
                  if (_destination != null) ...[
                    SizedBox(height: 1.5.h),
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFF6B35),
                            Color(0xFFFF9B44),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF6B35).withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.secondary,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: _sharePlanToChat,
                        icon: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Share with others',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
                SizedBox(height: 2.h),
                _buildPlanSectionCard(
                  theme: theme,
                  colorScheme: colorScheme,
                  icon: Icons.add_box_rounded,
                  title: 'Share your experience',
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.secondary,
                          theme.colorScheme.tertiary,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.secondary.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _openPostTravelStory,
                      icon: const Icon(Icons.add_box_rounded, color: Colors.white),
                      label: const Text(
                        'Create a post',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24 + MediaQuery.paddingOf(context).bottom),
              ],
            );
          },
        ),
      ),
    ),
  );
}

  Future<void> _sharePlanToChat() async {
    if (_planResult == null || _planResult!.trim().isEmpty) return;

    final plan = await _savePlan();
    if (plan == null || !mounted) return;

    final conversationId = await ShareToConversationSheet.show(context);
    if (conversationId == null || !mounted) return;

    final chatService = getIt<ChatService>();
    try {
      await chatService.sendMessage(
        conversationId: conversationId,
        content: 'Shared a travel plan',
        type: 'travelPlan',
        sharedContentId: plan.id,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Plan shared'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to share plan: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
