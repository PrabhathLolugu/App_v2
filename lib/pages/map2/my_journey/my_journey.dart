import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/pages/map2/Model/sacred_location.dart';
import 'package:myitihas/pages/map2/app_theme.dart';
import 'package:myitihas/pages/map2/custom_site/custom_site_models.dart';
import 'package:myitihas/pages/map2/custom_site/custom_site_storage_service.dart';
import 'package:myitihas/pages/map2/intent_choice/widget/bloc/pilgrimage_bloc.dart';
import 'package:myitihas/pages/map2/intent_choice/widget/pilgrimage_event.dart';
import 'package:myitihas/pages/map2/intent_choice/widget/pilgrimage_state.dart';
import 'package:myitihas/pages/map2/map_navigation.dart';
import 'package:myitihas/pages/map2/my_journey/widget/add_reflection_modal.dart';
import 'package:myitihas/pages/map2/my_journey/widget/intent_progress_card_widget.dart';
import 'package:myitihas/pages/map2/my_journey/widget/progress_overview_widget.dart';
import 'package:myitihas/pages/map2/my_journey/widget/recent_visit_card_widget.dart';
import 'package:myitihas/pages/map2/my_journey/widget/reflection_entry_widget.dart';
import 'package:myitihas/pages/map2/my_journey/widget/saved_plan_card_widget.dart';
import 'package:myitihas/pages/map2/plan/saved_travel_plan.dart';
import 'package:myitihas/pages/map2/site_detail/site_detail.dart';
import 'package:myitihas/pages/map2/widgets/custom_icon_widget.dart';
import 'package:myitihas/pages/map2/widgets/map_header_nav.dart';
import 'package:myitihas/services/supabase_service.dart';
import 'package:myitihas/utils/constants.dart';
import 'package:sizer/sizer.dart';

class MyJourney extends StatelessWidget {
  const MyJourney({super.key});

  @override
  Widget build(BuildContext context) {
    return const _MyJourneyContent();
  }
}

class _MyJourneyContent extends StatefulWidget {
  const _MyJourneyContent();

  @override
  State<_MyJourneyContent> createState() => _MyJourneyContentState();
}

class _MyJourneyContentState extends State<_MyJourneyContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<SavedTravelPlan> _savedPlans = [];
  List<SavedCustomJourneySite> _savedCustomSites = [];
  bool _plansLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadSavedPlans();
    _loadSavedCustomSites();
  }

  Future<void> _loadSavedPlans() async {
    final userId = SupabaseService.client.auth.currentUser?.id;
    if (userId == null) {
      setState(() => _savedPlans = []);
      return;
    }
    setState(() => _plansLoading = true);
    try {
      final res = await SupabaseService.client
          .from('saved_travel_plans')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final plans = (res as List<dynamic>)
          .map((e) => SavedTravelPlan.fromJson(e as Map<String, dynamic>))
          .toList();
      if (mounted) setState(() => _savedPlans = plans);
    } catch (e) {
      if (mounted) setState(() => _savedPlans = []);
    } finally {
      if (mounted) setState(() => _plansLoading = false);
    }
  }

  Future<void> _loadSavedCustomSites() async {
    final sites = await CustomSiteStorageService.loadSavedSites();
    if (mounted) {
      setState(() => _savedCustomSites = sites);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddReflectionModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddReflectionModal(
        onSave: (title, content, siteName) {
          final reflection = {
            "title": title,
            "content": content,
            "siteName": siteName,
            "date":
                "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
            "mood": "Reflective",
          };

          context.read<PilgrimageBloc>().add(AddReflection(reflection));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final gradientExt = theme.extension<GradientExtension>();

    return BlocBuilder<PilgrimageBloc, PilgrimageState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final recentVisitIds = state.visitedSiteIds.reversed.toList();

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            goBackToMapLanding(context);
          },
          child: Scaffold(
            appBar: MapTabHeader(currentIndex: 1),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient:
                    gradientExt?.screenBackgroundGradient ??
                    LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        theme.colorScheme.surface,
                        theme.colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.3,
                        ),
                      ],
                    ),
              ),
              child: Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: () async {
                      context.read<PilgrimageBloc>().add(
                        const LoadJourneyData(),
                      );
                      await _loadSavedPlans();
                      await _loadSavedCustomSites();
                    },
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 4.w,
                              right: 4.w,
                              top: 1.h,
                              bottom: 2.5.h,
                            ),
                            child: ProgressOverviewWidget(
                              completionPercentage:
                                  (state.visitedSiteIds.length /
                                      state.allLocations.length) *
                                  100,
                              visitedSitesCount: state.visitedSiteIds.length,
                              badgesEarned: (state.visitedSiteIds.length / 5)
                                  .floor(),
                              totalSites: state.allLocations.length,
                            ),
                          ),
                        ),

                        SliverToBoxAdapter(child: _buildIntentSection(state)),

                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 4.w,
                              right: 4.w,
                              top: 2.h,
                              bottom: 1.h,
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () =>
                                    const MapExploreRoute().push(context),
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.w,
                                    vertical: 3.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.08)
                                        : Colors.black.withValues(alpha: 0.04),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: theme.dividerColor,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.explore_outlined,
                                        color: theme.colorScheme.primary,
                                        size: 28,
                                      ),
                                      SizedBox(width: 4.w),
                                      Expanded(
                                        child: Text(
                                          'Explore Sacred Sites',
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                                color:
                                                    theme.colorScheme.onSurface,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.chevron_right,
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.6),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SliverToBoxAdapter(
                          child: _buildSavedPlansSection(theme),
                        ),

                        SliverToBoxAdapter(
                          child: _buildCustomSitesSection(theme),
                        ),

                        if (recentVisitIds.isNotEmpty) ...[
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 4.w,
                                right: 4.w,
                                top: 2.h,
                                bottom: 1.5.h,
                              ),
                              child: Text(
                                'Recent Visits',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final id = recentVisitIds[index];

                              // SAFE FIND: don't crash if allLocations is empty or site not found
                              final siteIndex = state.allLocations.indexWhere(
                                (s) => s.id == id,
                              );
                              if (siteIndex == -1)
                                return const SizedBox.shrink();

                              final site = state.allLocations[siteIndex];
                              final date = state.visitHistory[id] ?? "Recently";

                              if (site.name.isEmpty)
                                return const SizedBox.shrink();

                              return Padding(
                                padding: EdgeInsets.only(
                                  left: 4.w,
                                  right: 4.w,
                                  bottom: 2.h,
                                ),
                                child: RecentVisitCardWidget(
                                  siteName: site.name,
                                  location: site.region ?? "Bharat",
                                  visitDate: date,
                                  imageUrl: site.image ?? "",
                                  onTap: () =>
                                      context.push('/site-detail', extra: site),
                                  semanticLabel: site.name,
                                ),
                              );
                            }, childCount: recentVisitIds.length),
                          ),
                        ],

                        if (state.reflections.isNotEmpty) ...[
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 4.w,
                                right: 4.w,
                                top: 0.5.h,
                              ),
                              child: Text(
                                'Reflection Journal',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                          SliverPadding(
                            padding: EdgeInsets.all(4.w),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final entry = state.reflections[index];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 2.h),
                                  child: ReflectionEntryWidget(
                                    title: entry["title"],
                                    content: entry["content"],
                                    date: entry["date"],
                                    siteName: entry["siteName"],
                                    mood: entry["mood"],
                                  ),
                                );
                              }, childCount: state.reflections.length),
                            ),
                          ),
                        ],
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 10.h + MediaQuery.paddingOf(context).bottom,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Add reflection FAB
                  Positioned(
                    bottom: 13.h,
                    right: 16,
                    child: FloatingActionButton.extended(
                      onPressed: _showAddReflectionModal,
                      backgroundColor: isDark
                          ? DarkColors.accentSecondary
                          : LightColors.accentPrimary,
                      icon: const CustomIconWidget(
                        iconName: 'add',
                        color: Colors.white,
                        size: 24,
                      ),
                      label: Text(
                        'Add Reflection',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIntentSection(PilgrimageState state) {
    final List<String> constantIntents = [
      'all',
      'shaktipeethas',
      'char_dham',
      'jyotirlinga',
      'unesco',
      'other',
    ];

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'Intent Progress',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        SizedBox(height: 1.5.h),
        SizedBox(
          height: 20.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),

            children: constantIntents.map((intentId) {
              final List<SacredLocation> sitesInCategory = state.allLocations
                  .where((site) {
                    if (intentId.toLowerCase() == 'all') return true;

                    return site.intent.any(
                      (tag) => tag.toLowerCase() == intentId.toLowerCase(),
                    );
                  })
                  .toList();

              final int totalSites = sitesInCategory.length;
              final int visitedInCategory = sitesInCategory
                  .where((s) => state.visitedSiteIds.contains(s.id))
                  .length;

              final double progress = totalSites > 0
                  ? (visitedInCategory / totalSites) * 100
                  : 0;

              return Padding(
                padding: EdgeInsets.only(right: 3.w),
                child: IntentProgressCardWidget(
                  intentName: intentId == 'all'
                      ? 'ALL SITES'
                      : intentId.toUpperCase().replaceAll('_', ' '),
                  progress: progress,
                  sitesCompleted: visitedInCategory,
                  totalSites: totalSites,
                  color: _getIntentColor(intentId, isDark),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Color _getIntentColor(String intentId, bool isDark) {
    switch (intentId.toLowerCase()) {
      case 'all':
        return const Color(0xFFE65100);
      case 'jyotirlinga':
        return const Color(0xFF6A1B9A);
      case 'shaktipeethas':
        return const Color(0xFFC2185B);
      case 'char_dham':
        return const Color(0xFFF57C00);
      case 'unesco':
        return const Color(0xFF00695C);
      case 'other':
        return const Color(0xFF455A64);
      default:
        return AppTheme.navigationOrange;
    }
  }

  Widget _buildSavedPlansSection(ThemeData theme) {
    if (_plansLoading && _savedPlans.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_savedPlans.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 2.h, bottom: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            // Saved pilgrimage plans
            Translations.of(context).storyGenerator.saved,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 1.5.h),
          ..._savedPlans.map(
            (plan) => Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: SavedPlanCardWidget(
                plan: plan,
                onTap: () => SavedPlanDetailRoute($extra: plan).push(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomSitesSection(ThemeData theme) {
    if (_savedCustomSites.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 2.h, bottom: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            // Saved custom sites
            Translations.of(context).storyGenerator.saved,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 1.5.h),
          ..._savedCustomSites.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: RecentVisitCardWidget(
                siteName: item.location.name,
                location: item.location.region ?? 'Bharat',
                visitDate: Translations.of(context).storyGenerator.saved,
                imageUrl: item.location.image ?? '',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SiteDetail(
                        location: item.location,
                        preloadedSiteData: item.siteDetails,
                        customSubmissionId: item.submissionId,
                        customChatPrimer: item.chatPrimer,
                      ),
                    ),
                  );
                },
                semanticLabel: item.location.name,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
