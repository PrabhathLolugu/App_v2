import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/core/network/network_info.dart';
import 'package:myitihas/core/utils/app_error_message.dart';
import 'package:myitihas/pages/Chat/Widget/share_to_conversation_sheet.dart';
import 'package:myitihas/pages/map2/Model/sacred_location.dart';
import 'package:myitihas/pages/map2/app_theme.dart';
import 'package:myitihas/pages/map2/custom_site/custom_site_models.dart';
import 'package:myitihas/pages/map2/custom_site/custom_site_storage_service.dart';
import 'package:myitihas/pages/map2/intent_choice/widget/bloc/pilgrimage_bloc.dart';
import 'package:myitihas/pages/map2/intent_choice/widget/pilgrimage_event.dart';
import 'package:myitihas/pages/map2/intent_choice/widget/pilgrimage_state.dart';
import 'package:myitihas/pages/map2/map_guide.dart';
import 'package:myitihas/pages/map2/map_navigation.dart';
import 'package:myitihas/pages/map2/plan/plan_page.dart';
import 'package:myitihas/pages/map2/site_detail/widget/action_buttons_section.dart';
import 'package:myitihas/pages/map2/site_detail/widget/audio_player_section.dart';
import 'package:myitihas/pages/map2/site_detail/widget/expandable_section.dart';
import 'package:myitihas/pages/map2/site_detail/widget/hero_image_section.dart';
import 'package:myitihas/pages/map2/site_detail/widget/site_header_section.dart';
import 'package:myitihas/pages/map2/widgets/custom_icon_widget.dart';
import 'package:myitihas/services/chat_service.dart';
import 'package:myitihas/services/post_service.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

enum _SiteSection { about, history, visitInfo, festivals, nearby, bestTime }

class SiteDetail extends StatelessWidget {
  final SacredLocation location;
  final Map<String, dynamic>? preloadedSiteData;
  final String? customSubmissionId;
  final Map<String, dynamic>? customChatPrimer;

  const SiteDetail({
    super.key,
    required this.location,
    this.preloadedSiteData,
    this.customSubmissionId,
    this.customChatPrimer,
  });

  @override
  Widget build(BuildContext context) {
    return _SiteDetailContent(
      location: location,
      preloadedSiteData: preloadedSiteData,
      customSubmissionId: customSubmissionId,
      customChatPrimer: customChatPrimer,
    );
  }
}

class _SiteDetailContent extends StatefulWidget {
  final SacredLocation location;
  final Map<String, dynamic>? preloadedSiteData;
  final String? customSubmissionId;
  final Map<String, dynamic>? customChatPrimer;

  const _SiteDetailContent({
    required this.location,
    this.preloadedSiteData,
    this.customSubmissionId,
    this.customChatPrimer,
  });

  @override
  State<_SiteDetailContent> createState() => _SiteDetailContentState();
}

class _SiteDetailContentState extends State<_SiteDetailContent> {
  final _supabase = Supabase.instance.client;
  final NetworkInfo _networkInfo = getIt<NetworkInfo>();
  final ScrollController _scrollController = ScrollController();
  final FlutterTts _tts = FlutterTts();
  final _aboutKey = GlobalKey();
  final _historyKey = GlobalKey();
  final _visitInfoKey = GlobalKey();
  final _festivalsKey = GlobalKey();
  final _nearbyKey = GlobalKey();
  final _bestTimeKey = GlobalKey();

  Map<String, dynamic>? _fetchedSiteData;
  bool _isDataLoading = true;
  String? _error;
  static const double _nearbyRadiusKm = 200;
  bool _isAboutExpanded = false;
  bool _isHistoryExpanded = false;
  bool _isVisitInfoExpanded = true;
  bool _isFestivalsExpanded = false;
  bool _isNearbyExpanded = false;
  bool _isBestTimeExpanded = false;
  bool _isAudioReady = false;
  bool _isAudioPlaying = false;
  bool _audioPauseRequested = false;
  int _audioCurrentOffset = 0;
  int _audioSpeakStartOffset = 0;
  String _activeNarrationText = '';

  bool get _isCustomGenerated => widget.customSubmissionId != null;

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

  List<(SacredLocation, double)> _getNearbyLocations(
    List<SacredLocation> allLocations,
  ) {
    final result = <(SacredLocation, double)>[];
    for (final loc in allLocations) {
      if (loc.id == widget.location.id) continue;
      final distance = _haversineKm(
        widget.location.latitude,
        widget.location.longitude,
        loc.latitude,
        loc.longitude,
      );
      if (distance <= _nearbyRadiusKm) {
        result.add((loc, distance));
      }
    }
    result.sort((a, b) => a.$2.compareTo(b.$2));
    return result.take(6).toList();
  }

  String _buildHashtag(String rawName) {
    final cleaned = rawName
        .replaceAll(RegExp(r'[^A-Za-z0-9\s]'), ' ')
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join();
    if (cleaned.isEmpty) return '#MyItihas';
    return '#$cleaned';
  }

  Future<void> _fetchSupabaseDetails() async {
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      setState(() {
        _error = kConnectToInternetMessage;
        _isDataLoading = false;
      });
      return;
    }
    try {
      setState(() => _isDataLoading = true);

      final data = await _supabase
          .from('site_details')
          .select()
          .eq('id', widget.location.id)
          .single();

      setState(() {
        _fetchedSiteData = data;
        _isDataLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = toUserFriendlyErrorMessage(
          e,
          fallback: 'Unable to load details right now.',
        );
        _isDataLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeNarrationAudio();
    if (widget.preloadedSiteData != null) {
      _fetchedSiteData = Map<String, dynamic>.from(widget.preloadedSiteData!);
      _isDataLoading = false;
    } else {
      _fetchSupabaseDetails();
    }
  }

  @override
  void dispose() {
    _tts.stop();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeNarrationAudio() async {
    try {
      await _tts.setVolume(0.7);
      await _tts.setSpeechRate(0.44);
      await _tts.setPitch(1.0);
      await _tts.awaitSpeakCompletion(true);
      await _applyNarrationVoice();

      _tts.setStartHandler(() {
        if (!mounted) return;
        setState(() {
          _isAudioPlaying = true;
        });
      });

      _tts.setProgressHandler((text, start, end, word) {
        if (!mounted || _activeNarrationText.isEmpty) return;
        final absolute = (_audioSpeakStartOffset + end).clamp(
          0,
          _activeNarrationText.length,
        );
        _audioCurrentOffset = absolute;
      });

      _tts.setCompletionHandler(() {
        if (!mounted) return;
        setState(() {
          _isAudioPlaying = false;
          _resetNarrationProgress();
        });
      });

      _tts.setCancelHandler(() {
        if (!mounted) return;
        if (_audioPauseRequested) {
          _audioPauseRequested = false;
          setState(() {
            _isAudioPlaying = false;
          });
          return;
        }
        setState(() {
          _isAudioPlaying = false;
        });
      });

      if (!mounted) return;
      setState(() {
        _isAudioReady = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isAudioReady = false;
      });
    }
  }

  Future<void> _applyNarrationVoice() async {
    const preferredLocale = 'en-IN';
    const fallbackLocale = 'en-IN';
    try {
      await _tts.setLanguage(preferredLocale);

      final voices = await _tts.getVoices;
      if (voices is! List) {
        return;
      }

      Map<dynamic, dynamic>? selected;
      for (final voice in voices) {
        if (voice is! Map) continue;
        final locale = (voice['locale'] ?? '').toString().toLowerCase();
        final name = (voice['name'] ?? '').toString().toLowerCase();
        if (locale.startsWith(preferredLocale.toLowerCase())) {
          selected = voice;
          break;
        }
        if (selected == null &&
            (locale.contains('-in') || name.contains('india'))) {
          selected = voice;
        }
      }

      if (selected != null) {
        await _tts.setVoice({
          'name': selected['name'],
          'locale': selected['locale'],
        });
      }
    } catch (_) {
      await _tts.setLanguage(fallbackLocale);
    }
  }

  Future<void> _toggleAudioNarration(String narrationText) async {
    if (!_isAudioReady) {
      return;
    }

    final cleanedNarration = narrationText.trim();
    if (cleanedNarration.isEmpty) {
      return;
    }

    if (_activeNarrationText != cleanedNarration) {
      await _stopAudioNarration(resetToStart: true);
      _activeNarrationText = cleanedNarration;
    }

    if (_isAudioPlaying) {
      _audioPauseRequested = true;
      await _tts.stop();
      return;
    }

    await _speakNarrationFromOffset(
      narrationText: cleanedNarration,
      offset: _audioCurrentOffset,
    );
  }

  Future<void> _speakNarrationFromOffset({
    required String narrationText,
    required int offset,
  }) async {
    final clampedOffset = offset.clamp(0, narrationText.length);
    final remaining = narrationText.substring(clampedOffset);
    if (remaining.trim().isEmpty) {
      if (!mounted) return;
      setState(_resetNarrationProgress);
      return;
    }

    _audioSpeakStartOffset = clampedOffset;
    _audioCurrentOffset = clampedOffset;
    _audioPauseRequested = false;
    await _tts.speak(remaining);
  }

  Future<void> _stopAudioNarration({required bool resetToStart}) async {
    _audioPauseRequested = false;
    await _tts.stop();
    if (!mounted) return;
    setState(() {
      _isAudioPlaying = false;
      if (resetToStart) {
        _resetNarrationProgress();
      }
    });
  }

  void _resetNarrationProgress() {
    _audioCurrentOffset = 0;
    _audioSpeakStartOffset = 0;
  }

  Future<void> _scrollToSection(GlobalKey key) async {
    final sectionContext = key.currentContext;
    if (sectionContext == null) return;
    await Scrollable.ensureVisible(
      sectionContext,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      alignment: 0.08,
    );
  }

  bool _isSectionExpanded(_SiteSection section) {
    switch (section) {
      case _SiteSection.about:
        return _isAboutExpanded;
      case _SiteSection.history:
        return _isHistoryExpanded;
      case _SiteSection.visitInfo:
        return _isVisitInfoExpanded;
      case _SiteSection.festivals:
        return _isFestivalsExpanded;
      case _SiteSection.nearby:
        return _isNearbyExpanded;
      case _SiteSection.bestTime:
        return _isBestTimeExpanded;
    }
  }

  void _setSectionExpanded(_SiteSection section, bool isExpanded) {
    switch (section) {
      case _SiteSection.about:
        _isAboutExpanded = isExpanded;
        break;
      case _SiteSection.history:
        _isHistoryExpanded = isExpanded;
        break;
      case _SiteSection.visitInfo:
        _isVisitInfoExpanded = isExpanded;
        break;
      case _SiteSection.festivals:
        _isFestivalsExpanded = isExpanded;
        break;
      case _SiteSection.nearby:
        _isNearbyExpanded = isExpanded;
        break;
      case _SiteSection.bestTime:
        _isBestTimeExpanded = isExpanded;
        break;
    }
  }

  void _toggleSection(_SiteSection section) {
    setState(() {
      _setSectionExpanded(section, !_isSectionExpanded(section));
    });
  }

  void _openSectionAndScroll(_SiteSection section, GlobalKey key) {
    setState(() {
      _setSectionExpanded(section, true);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSection(key);
    });
  }

  Widget _buildQuickAccessChips() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _sectionChip(
                label: 'Visit Info',
                icon: Icons.info_outline_rounded,
                onTap: () => _openSectionAndScroll(
                  _SiteSection.visitInfo,
                  _visitInfoKey,
                ),
              ),
              _sectionChip(
                label: 'Nearby Explorer',
                icon: Icons.travel_explore_rounded,
                onTap: _openNearbyExplorer,
              ),
              _sectionChip(
                label: 'About',
                icon: Icons.menu_book_rounded,
                onTap: () =>
                    _openSectionAndScroll(_SiteSection.about, _aboutKey),
              ),
              _sectionChip(
                label: 'Best Time',
                icon: Icons.sunny_snowing,
                onTap: () =>
                    _openSectionAndScroll(_SiteSection.bestTime, _bestTimeKey),
              ),
              _sectionChip(
                label: 'History',
                icon: Icons.auto_stories_rounded,
                onTap: () =>
                    _openSectionAndScroll(_SiteSection.history, _historyKey),
              ),
              _sectionChip(
                label: 'Festivals',
                icon: Icons.festival_rounded,
                onTap: () => _openSectionAndScroll(
                  _SiteSection.festivals,
                  _festivalsKey,
                ),
              ),
              _sectionChip(
                label: 'Nearby',
                icon: Icons.place_rounded,
                onTap: () =>
                    _openSectionAndScroll(_SiteSection.nearby, _nearbyKey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionChip({
    required String label,
    required IconData icon,
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
          color: Theme.of(
            context,
          ).colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        tooltip: 'Jump to $label section',
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  bool _hasValue(dynamic value) {
    if (value == null) return false;
    if (value is String) return value.trim().isNotEmpty;
    if (value is Iterable) return value.any(_hasValue);
    if (value is Map) return value.values.any(_hasValue);
    return true;
  }

  String _humanizeKey(String key) {
    final spaced = key
        .replaceAll('_', ' ')
        .replaceAllMapped(
          RegExp(r'([a-z])([A-Z])'),
          (m) => '${m.group(1)} ${m.group(2)}',
        )
        .trim();
    if (spaced.isEmpty) return key;
    return spaced
        .split(RegExp(r'\s+'))
        .map((word) {
          if (word.isEmpty) return word;
          return '${word[0].toUpperCase()}${word.substring(1)}';
        })
        .join(' ');
  }

  String _toInlineText(dynamic value) {
    if (value == null) return '';
    if (value is String) return value.trim();
    if (value is num || value is bool) return value.toString();
    if (value is Map) {
      return value.entries
          .where((entry) => _hasValue(entry.value))
          .map(
            (entry) =>
                '${_humanizeKey(entry.key.toString())}: ${_toInlineText(entry.value)}',
          )
          .where((line) => line.trim().isNotEmpty)
          .join('\n');
    }
    if (value is Iterable) {
      return value
          .where(_hasValue)
          .map(_toInlineText)
          .where((line) => line.trim().isNotEmpty)
          .join('\n');
    }
    return value.toString();
  }

  Widget _buildStructuredValue(dynamic value) {
    final theme = Theme.of(context);

    if (!_hasValue(value)) {
      return Text(
        'Details will be updated soon.',
        style: theme.textTheme.bodyMedium,
      );
    }

    if (value is String || value is num || value is bool) {
      return Text(
        _toInlineText(value),
        style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
      );
    }

    if (value is Iterable) {
      final items = value.where(_hasValue).toList();
      if (items.isEmpty) {
        return Text(
          'Details will be updated soon.',
          style: theme.textTheme.bodyMedium,
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) {
          final itemText = _toInlineText(item);
          if (itemText.isEmpty) return const SizedBox.shrink();
          return Padding(
            padding: EdgeInsets.only(bottom: 0.8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 0.5.h, right: 2.w),
                  child: const Icon(Icons.circle, size: 7),
                ),
                Expanded(
                  child: Text(
                    itemText,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    }

    if (value is Map) {
      final entries = value.entries
          .where((entry) => _hasValue(entry.value))
          .toList();
      if (entries.isEmpty) {
        return Text(
          'Details will be updated soon.',
          style: theme.textTheme.bodyMedium,
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: entries.map((entry) {
          return Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 1.h),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark
                  ? const Color(0xFF181818)
                  : const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _humanizeKey(entry.key.toString()),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  _toInlineText(entry.value),
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
                ),
              ],
            ),
          );
        }).toList(),
      );
    }

    return Text(
      _toInlineText(value),
      style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
    );
  }

  Widget _buildVisitInfoBody(Map<String, dynamic> data) {
    final fields = <(String, List<String>)>[
      ('Visiting Hours', ['visitingHours', 'visiting_hours', 'hours']),
      (
        'How To Reach',
        ['howToReach', 'how_to_reach', 'reach', 'directions', 'travelRoutes'],
      ),
      (
        'Nearby Transport',
        [
          'localTransport',
          'local_transport',
          'transport',
          'nearestAirport',
          'nearestRailwayStation',
          'nearestBusStand',
        ],
      ),
      ('Stay Options', ['stayOptions', 'stay_options', 'accommodation']),
      ('Entry Fee', ['entryFee', 'entry_fee', 'ticketPrice']),
      ('Dress Code', ['dressCode', 'dress_code']),
      ('Accessibility', ['accessibility', 'specialAccess', 'special_access']),
      ('Travel Tips', ['travelTips', 'travel_tips', 'tips']),
      ('Safety Notes', ['safetyInfo', 'safety_info', 'safetyNotes']),
      ('Contact Info', ['contactInfo', 'contact_info', 'contact']),
      (
        'Rituals & Seva',
        ['rituals', 'poojaTimings', 'aartiTimings', 'darshanTimings'],
      ),
      (
        'Food & Facilities',
        ['foodOptions', 'facilities', 'cloakRoom', 'parking', 'washrooms'],
      ),
    ];

    final sections = <Widget>[];
    for (final field in fields) {
      dynamic value;
      for (final key in field.$2) {
        if (_hasValue(data[key])) {
          value = data[key];
          break;
        }
      }
      if (!_hasValue(value)) continue;
      sections.add(
        Padding(
          padding: EdgeInsets.only(bottom: 1.5.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                field.$1,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 0.6.h),
              _buildStructuredValue(value),
            ],
          ),
        ),
      );
    }

    if (sections.isEmpty) {
      return Text(
        'Visit information will be updated soon.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections,
    );
  }

  SliverToBoxAdapter _buildHighlightsRow(Map<String, dynamic> data) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String? deity = (data['deity'] ?? data['mainDeity'])
        ?.toString()
        .trim();
    final String? tradition =
        (data['tradition'] ?? data['sampradaya'] ?? data['sect'])
            ?.toString()
            .trim();
    final String? state = (data['state'] ?? data['region'])?.toString().trim();
    final String? importance = (data['importance'] ?? data['significance'])
        ?.toString()
        .trim();

    final chips = <Widget>[];

    void addChip({
      required IconData icon,
      required String label,
      required String value,
    }) {
      if (value.trim().isEmpty) return;
      chips.add(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
          margin: EdgeInsets.only(right: 2.w, bottom: 1.h),
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.dark
                ? const Color(0xFF1A1A1A)
                : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.6),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: colorScheme.primary),
              SizedBox(width: 1.2.w),
              Text(
                '$label: ',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Flexible(
                child: Text(
                  value,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (deity != null && deity.isNotEmpty) {
      addChip(
        icon: Icons.self_improvement_rounded,
        label: 'Deity',
        value: deity,
      );
    }
    if (tradition != null && tradition.isNotEmpty) {
      addChip(
        icon: Icons.local_fire_department_rounded,
        label: 'Tradition',
        value: tradition,
      );
    }
    if (state != null && state.isNotEmpty) {
      addChip(icon: Icons.map_rounded, label: 'Region', value: state);
    }
    if (importance != null && importance.isNotEmpty) {
      addChip(icon: Icons.star_rounded, label: 'Importance', value: importance);
    }

    if (chips.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(
          left: 4.w,
          right: 4.w,
          top: 0.5.h,
          bottom: 0.5.h,
        ),
        child: Wrap(children: chips),
      ),
    );
  }

  Widget _buildFestivalsBody(dynamic festivals) {
    final resolvedFestivals =
        festivals ??
        _fetchedSiteData?['festivalInfo'] ??
        _fetchedSiteData?['festival_info'];
    if (!_hasValue(resolvedFestivals)) {
      return Text(
        'Festival details will be updated soon.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
      );
    }
    return _buildStructuredValue(resolvedFestivals);
  }

  String _buildVisitInfoNarration(Map<String, dynamic> data) {
    final fields = <(String, List<String>)>[
      ('Visiting Hours', ['visitingHours', 'visiting_hours', 'hours']),
      (
        'How To Reach',
        ['howToReach', 'how_to_reach', 'reach', 'directions', 'travelRoutes'],
      ),
      (
        'Nearby Transport',
        [
          'localTransport',
          'local_transport',
          'transport',
          'nearestAirport',
          'nearestRailwayStation',
          'nearestBusStand',
        ],
      ),
      ('Stay Options', ['stayOptions', 'stay_options', 'accommodation']),
      ('Entry Fee', ['entryFee', 'entry_fee', 'ticketPrice']),
      ('Dress Code', ['dressCode', 'dress_code']),
      ('Travel Tips', ['travelTips', 'travel_tips', 'tips']),
      ('Safety Notes', ['safetyInfo', 'safety_info', 'safetyNotes']),
      ('Contact Info', ['contactInfo', 'contact_info', 'contact']),
      (
        'Rituals and Seva',
        ['rituals', 'poojaTimings', 'aartiTimings', 'darshanTimings'],
      ),
      (
        'Food and Facilities',
        ['foodOptions', 'facilities', 'cloakRoom', 'parking', 'washrooms'],
      ),
    ];

    final lines = <String>[];
    for (final field in fields) {
      dynamic value;
      for (final key in field.$2) {
        if (_hasValue(data[key])) {
          value = data[key];
          break;
        }
      }
      if (!_hasValue(value)) continue;
      lines.add('${field.$1}: ${_toInlineText(value)}');
    }

    return lines.join('\n');
  }

  String _buildNearbyNarration(List<(SacredLocation, double)> nearby) {
    final dynamic nearbyInfo =
        _fetchedSiteData?['nearbyPlaces'] ??
        _fetchedSiteData?['nearby_places'] ??
        _fetchedSiteData?['nearby'];

    final chunks = <String>[];
    if (_hasValue(nearbyInfo)) {
      chunks.add(_toInlineText(nearbyInfo));
    }
    if (nearby.isNotEmpty) {
      final siteLine = nearby
          .map(
            (entry) =>
                '${entry.$1.name}, about ${entry.$2.toStringAsFixed(0)} kilometers away',
          )
          .join('. ');
      chunks.add('Nearby places include: $siteLine.');
    }
    return chunks.join('\n');
  }

  String _cleanForNarration(String text) {
    return text
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll(RegExp(r'[#*_`>\[\]]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(' - ', '. ')
        .trim();
  }

  String _buildNarrationText(
    String siteName,
    List<AudioNarrationSection> sections,
  ) {
    if (!sections.any((section) => section.hasContent)) {
      return '';
    }

    final buffer = StringBuffer();
    final cleanedTitle = _cleanForNarration(siteName);
    if (cleanedTitle.isNotEmpty) {
      buffer.writeln('Sacred site overview: $cleanedTitle.');
      buffer.writeln();
    }

    for (final section in sections.where((section) => section.hasContent)) {
      final heading = _cleanForNarration(section.heading);
      final body = _cleanForNarration(section.body);
      if (heading.isEmpty || body.isEmpty) continue;
      buffer.writeln('$heading.');
      buffer.writeln(body);
      buffer.writeln();
    }

    return buffer.toString().trim();
  }

  List<AudioNarrationSection> _buildNarrationSections(
    Map<String, dynamic> data,
    List<(SacredLocation, double)> nearby,
  ) {
    final sections = <AudioNarrationSection>[];

    void addSection(String heading, dynamic value) {
      if (!_hasValue(value)) return;
      sections.add(
        AudioNarrationSection(heading: heading, body: _toInlineText(value)),
      );
    }

    addSection('About', data['about']);
    addSection(
      'Best Time to Visit',
      data['bestTimeToVisit'] ?? data['best_time_to_visit'],
    );
    addSection('History', data['history']);

    final visitInfoNarration = _buildVisitInfoNarration(data);
    if (visitInfoNarration.trim().isNotEmpty) {
      sections.add(
        AudioNarrationSection(
          heading: 'Visit Information',
          body: visitInfoNarration,
        ),
      );
    }

    addSection(
      'Festivals',
      data['festivals'] ?? data['festivalInfo'] ?? data['festival_info'],
    );

    final nearbyNarration = _buildNearbyNarration(nearby);
    if (nearbyNarration.trim().isNotEmpty) {
      sections.add(
        AudioNarrationSection(
          heading: 'Nearby Sites to Visit',
          body: nearbyNarration,
        ),
      );
    }

    return sections;
  }

  Widget _buildNearbyBody(List<(SacredLocation, double)> nearby) {
    final theme = Theme.of(context);
    final dynamic nearbyInfo =
        _fetchedSiteData?['nearbyPlaces'] ??
        _fetchedSiteData?['nearby_places'] ??
        _fetchedSiteData?['nearby'];

    if (nearby.isEmpty && !_hasValue(nearbyInfo)) {
      return Text(
        'No nearby sites found within ${_nearbyRadiusKm.toStringAsFixed(0)} km.',
        style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilledButton.icon(
          onPressed: _openNearbyExplorer,
          icon: const Icon(Icons.travel_explore_rounded, size: 18),
          label: const Text('Open Nearby Explorer'),
        ),
        SizedBox(height: 1.2.h),
        if (_hasValue(nearbyInfo)) ...[
          _buildStructuredValue(nearbyInfo),
          SizedBox(height: 1.2.h),
        ],
        if (nearby.isNotEmpty)
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: nearby.map((entry) {
              final loc = entry.$1;
              final dist = entry.$2;
              return ActionChip(
                avatar: const Icon(Icons.place_rounded, size: 16),
                label: Text('${loc.name} (${dist.toStringAsFixed(0)} km)'),
                onPressed: () => SiteDetailRoute($extra: loc).push(context),
              );
            }).toList(),
          ),
      ],
    );
  }

  void _openNearbyExplorer() {
    NearbyPlacesRoute($extra: widget.location).push(context);
  }

  Future<void> _toggleAddToJourney(BuildContext context, int siteId) async {
    if (_isCustomGenerated && widget.customSubmissionId != null) {
      final data = _fetchedSiteData ?? <String, dynamic>{};
      final result = CustomSiteGenerationResult(
        submissionId: widget.customSubmissionId!,
        submissionStatus: 'pending',
        publishedLocationId: null,
        sacredLocation: widget.location,
        siteDetails: data,
        chatPrimer: widget.customChatPrimer ?? const {},
      );
      await CustomSiteStorageService.saveSite(result);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Saved in your journey.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    context.read<PilgrimageBloc>().add(MarkSiteVisited(siteId));

    final bool isNowVisited = !context
        .read<PilgrimageBloc>()
        .state
        .visitedSiteIds
        .contains(siteId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isNowVisited ? 'Added to your journey' : 'Removed from your journey',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int siteId = widget.location.id;
    if (_isDataLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null || _fetchedSiteData == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text(_error ?? 'Unable to load details right now.'),
        ),
      );
    }

    final data = _fetchedSiteData!;
    final colorScheme = Theme.of(context).colorScheme;
    final gradientExt = Theme.of(context).extension<GradientExtension>();
    return BlocBuilder<PilgrimageBloc, PilgrimageState>(
      builder: (context, state) {
        final nearby = _getNearbyLocations(state.allLocations);
        final siteName = (data['name'] ?? widget.location.name).toString();
        final hashtag = _buildHashtag(siteName);
        final narrationSections = _buildNarrationSections(data, nearby);
        final narrationText = _buildNarrationText(siteName, narrationSections);
        final hasNarration = narrationText.isNotEmpty;

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            _stopAudioNarration(resetToStart: false);
            goBackToMapLanding(context);
          },
          child: Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient:
                    gradientExt?.screenBackgroundGradient ??
                    LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        colorScheme.surface,
                        colorScheme.surfaceContainerHighest.withValues(alpha: 0.26),
                        colorScheme.surface,
                      ],
                      transform: const GradientRotation(3.14 / 1.5),
                    ),
              ),
              child: RefreshIndicator(
                onRefresh: _isCustomGenerated
                    ? () async {}
                    : _fetchSupabaseDetails,
                child: Stack(
                  children: [
                    CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverToBoxAdapter(
                          child: HeroImageSection(
                            imageUrl:
                                data['heroImage'] ??
                                widget.location.image ??
                                "",
                            semanticLabel:
                                data['heroImageLabel'] ?? data['name'],
                            onBackPressed: () {
                              _stopAudioNarration(resetToStart: false);
                              goBackToMapLanding(context);
                            },
                            scrollController: _scrollController,
                            onCreatePost: () {
                              GoRouter.of(context).push(
                                '/create-post',
                                extra: {
                                  'initialPostType': PostType.image,
                                  'initialContent': hashtag,
                                },
                              );
                            },
                            onShare: () =>
                                _shareSiteToChat(context, siteId, data),
                            showAudioButton: hasNarration,
                            isAudioPlaying: _isAudioPlaying,
                            onAudioTap: hasNarration
                                ? () => _toggleAudioNarration(narrationText)
                                : null,
                            audioTooltip: _isAudioPlaying
                                ? 'Pause narration'
                                : 'Play narration',
                          ),
                        ),

                        SliverToBoxAdapter(
                          child: SiteHeaderSection(
                            siteName: siteName,
                            location: data['location'] ?? "Bharat",
                          ),
                        ),
                        _buildHighlightsRow(data),

                        SliverToBoxAdapter(
                          child: ActionButtonsSection(
                            onAddToJourney: () async =>
                                _toggleAddToJourney(context, siteId),
                            onGetDirections: _getDirections,
                            onExploreNearby: _openNearbyExplorer,
                            onViewInMap: () =>
                                goToMapFocusingSite(context, siteId),
                            onShare: () =>
                                _shareSiteToChat(context, siteId, data),
                          ),
                        ),
                        _buildQuickAccessChips(),

                        _buildExpandableSection(
                          section: _SiteSection.visitInfo,
                          title: 'Visit Info',
                          body: _buildVisitInfoBody(data),
                          sectionKey: _visitInfoKey,
                        ),
                        _buildExpandableSection(
                          section: _SiteSection.about,
                          title: 'About',
                          content: _hasValue(data['about'])
                              ? _toInlineText(data['about'])
                              : null,
                          sectionKey: _aboutKey,
                          fallbackText: 'About details will be updated soon.',
                        ),
                        _buildExpandableSection(
                          section: _SiteSection.bestTime,
                          title: 'Best Time to Visit',
                          content:
                              _hasValue(
                                data['bestTimeToVisit'] ??
                                    data['best_time_to_visit'],
                              )
                              ? _toInlineText(
                                  data['bestTimeToVisit'] ??
                                      data['best_time_to_visit'],
                                )
                              : null,
                          sectionKey: _bestTimeKey,
                          fallbackText:
                              'Best time to visit info will be updated soon.',
                        ),
                        _buildExpandableSection(
                          section: _SiteSection.history,
                          title: 'History',
                          content: _hasValue(data['history'])
                              ? _toInlineText(data['history'])
                              : null,
                          sectionKey: _historyKey,
                          fallbackText:
                              'Historical details will be updated soon.',
                        ),
                        _buildExpandableSection(
                          section: _SiteSection.festivals,
                          title: 'Festivals',
                          body: _buildFestivalsBody(data['festivals']),
                          sectionKey: _festivalsKey,
                        ),
                        _buildExpandableSection(
                          section: _SiteSection.nearby,
                          title: 'Nearby Sites To Visit',
                          body: _buildNearbyBody(nearby),
                          sectionKey: _nearbyKey,
                        ),

                        SliverToBoxAdapter(
                          child: Container(
                            margin: EdgeInsets.all(4.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppTheme.navigationOrange,
                                        Color(0xFFFF9B44),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.navigationOrange
                                            .withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MapGuide(
                                            initialLocation: {
                                              'id':
                                                  data['id'] ??
                                                  widget.location.id,
                                              'name':
                                                  data['name'] ??
                                                  widget.location.name,
                                              'details': data['about'],
                                              'title':
                                                  widget
                                                      .customChatPrimer?['title'] ??
                                                  data['name'] ??
                                                  widget.location.name,
                                              'story_content':
                                                  widget
                                                      .customChatPrimer?['siteSummary'] ??
                                                  data['about'] ??
                                                  '',
                                              'moral':
                                                  (widget.customChatPrimer?['keyRituals']
                                                          as List?)
                                                      ?.join(', '),
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const CustomIconWidget(
                                      iconName: 'explore',
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    label: const Text(
                                      'Know More',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 2.h,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 1.5.h),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Theme.of(context).colorScheme.primary,
                                        Theme.of(context).colorScheme.tertiary,
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary.withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      if (_isCustomGenerated) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PlanPage(
                                              initialDestination:
                                                  widget.location,
                                              customSiteDetails: data,
                                            ),
                                          ),
                                        );
                                      } else {
                                        PlanRoute(
                                          $extra: widget.location,
                                        ).push(context);
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.calendar_month_outlined,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    label: const Text(
                                      'Plan a visit',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 2.h,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SliverToBoxAdapter(child: SizedBox(height: 6.h)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildExpandableSection({
    required _SiteSection section,
    required String title,
    String? content,
    Widget? body,
    Key? sectionKey,
    String? fallbackText,
  }) {
    final resolvedContent = (content ?? '').trim().isNotEmpty
        ? content!.trim()
        : (fallbackText ?? '');
    if (resolvedContent.isEmpty && body == null) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    return SliverToBoxAdapter(
      child: Container(
        key: sectionKey,
        child: ExpandableSection(
          title: title,
          content: body == null ? resolvedContent : null,
          body: body,
          isExpanded: _isSectionExpanded(section),
          onToggle: () => _toggleSection(section),
        ),
      ),
    );
  }

  Future<void> _getDirections() async {
    final siteName = _fetchedSiteData?['name'] ?? widget.location.name;

    // 1. Create the query-based URL for Google/Apple Maps
    final String googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(siteName)}";
    final String appleMapsUrl =
        "https://maps.apple.com/?q=${Uri.encodeComponent(siteName)}";

    try {
      if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
        // 2. Open Google Maps if available
        await launchUrl(
          Uri.parse(googleMapsUrl),
          mode: LaunchMode.externalApplication,
        );
      } else if (await canLaunchUrl(Uri.parse(appleMapsUrl))) {
        // 3. Fallback to Apple Maps on iOS
        await launchUrl(
          Uri.parse(appleMapsUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Could not launch maps';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              toUserFriendlyErrorMessage(
                e,
                fallback: 'Unable to open maps right now.',
              ),
            ),
          ),
        );
      }
    }
  }

  Future<void> _shareSiteToChat(
    BuildContext context,
    int siteId,
    Map<String, dynamic> data,
  ) async {
    final conversationId = await ShareToConversationSheet.show(context);
    if (conversationId == null || !context.mounted) return;

    final chatService = getIt<ChatService>();
    final siteName = (data['name'] ?? widget.location.name).toString();
    final content = siteName.trim().isEmpty
        ? 'Shared a sacred site'
        : 'Shared $siteName';

    try {
      await chatService.sendMessage(
        conversationId: conversationId,
        content: content,
        type: 'sacredSite',
        sharedContentId: siteId.toString(),
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Site shared'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to share site: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
