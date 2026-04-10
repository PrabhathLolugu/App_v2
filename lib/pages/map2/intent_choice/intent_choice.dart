import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/pages/map2/intent_choice/widget/bloc/pilgrimage_bloc.dart';
import 'package:myitihas/pages/map2/intent_choice/widget/intent_card_widget.dart';
import 'package:myitihas/pages/map2/intent_choice/widget/intent_discussion_composer_card.dart';
import 'package:myitihas/pages/map2/intent_choice/widget/intent_detail_sheet_widget.dart';
import 'package:myitihas/pages/map2/intent_choice/widget/map_intent_hero_carousel.dart';
import 'package:myitihas/pages/map2/intent_choice/widget/pilgrimage_event.dart';
import 'package:myitihas/pages/map2/intent_choice/widget/pilgrimage_state.dart';
import 'package:myitihas/pages/map2/map_navigation.dart';
import 'package:myitihas/pages/map2/map_state_storage.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:sizer/sizer.dart';

class IntentChoice extends StatelessWidget {
  IntentChoice({super.key});

  final List<Map<String, dynamic>> _spiritualIntents = [
    {
      "id": "All",
      "name": "All Sacred Sites",
      "icon": "temple_hindu",
      "description":
          "The complete spiritual and historical map of Akhanda Bharat.",
      "detailedDescription":
          """Unlock the full experience of MyItihas. This master path weaves together every thread of our heritage: • All 12 Jyotirlingas of Lord Shiva • The 18 Shaktipeethas of the Divine Mother • The high Himalayan Char Dham circuit • Indigenous UNESCO World Heritage sites and ancient Universities. Perfect for the ultimate seeker who wants to witness the total continuity of Indian civilization.""",
      "color": 0xFFE65100,
      "badge": "Flagship",
      "chips": ["Plan Journeys", "Forums", "Gov Shops"],
      "type": "sacred",
    },
    {
      "id": "UNESCO",
      "name": "UNESCO Heritage",
      "icon": "account_balance",
      "description": "Explore Bharat's globally recognized indigenous marvels.",
      "detailedDescription":
          """Journey through sites recognized for their Outstanding Universal Value. This path focuses on indigenous Indian genius, excluding colonial influences: • Ancient rock-cut architecture (Ajanta, Ellora) • Scientific hubs like Jantar Mantar and Nalanda • Engineering marvels like the Rani-ki-Vav and Ramappa Temple. A deep dive into the history, engineering, and cultural continuity of Bharat.""",
      "color": 0xFF00695C,
      "badge": "Curated",
      "chips": ["World Heritage", "Ancient Science", "Architecture"],
      "type": "sacred",
    },
    {
      "id": "Shaktipeethas",
      "name": "Shaktipeethas",
      "icon": "self_improvement",
      "description":
          "The Shaktipeethas are the most sacred sites of divine feminine energy in Hindu tradition. ",
      "detailedDescription":
          """Embark on a powerful journey to the Shakti Peethas. These are the sacred places where parts of Goddess Sati's body fell. This path focuses on: • Connecting with divine feminine energy (Shakti) • Visiting ancient high-energy vortexes • Understanding the legend of Shiva and Sati.""",
      "color": 0xFFC2185B,
      "badge": "Energy Trail",
      "chips": ["Divine Feminine", "Ancient Vortices", "Sacred Lore"],
      "type": "sacred",
    },
    {
      "id": "Char_Dham",
      "name": "Char Dham",
      "icon": "landscape",
      "description": "Embark on the sacred high-altitude Himalayan circuit.",
      "detailedDescription":
          """Experience the ultimate purification journey through the Garhwal Himalayas. This path covers the four abodes: • Yamunotri: The source of the Yamuna • Gangotri: The seat of Goddess Ganga • Kedarnath: The highest Jyotirlinga • Badrinath: The abode of Lord Vishnu. Perfect for those seeking spiritual elevation and physical endurance in the heart of the mountains.""",
      "color": 0xFFF57C00,
      "badge": "Pilgrimage",
      "chips": ["Himalayan Route", "Spiritual Trek", "Temple Circuit"],
      "type": "sacred",
    },
    {
      "id": "Jyotirlinga",
      "name": "Jyotirlingas",
      "icon": "flare",
      "description":
          "The twelve radiant manifestations of Lord Shiva's supreme light.",
      "detailedDescription":
          """Trace the twelve 'pillars of light' where Lord Shiva manifested in his infinite form. This journey spans the length and breadth of Bharat, from Somnath in the West to Baidyanath in the East. Focus on: • Spiritual liberation and Moksha • Vedic chanting and Rudrabhishek • Connecting with ancient geological vortexes of light and energy.""",
      "color": 0xFF6A1B9A,
      "badge": "Shiva Circuit",
      "chips": ["12 Shrines", "Rudrabhishek", "Moksha Path"],
      "type": "sacred",
    },
    {
      "id": "Other",
      "name": "Other Sacred Sites",
      "icon": "add_location_alt",
      "description":
          "Generate details for custom temples and sacred places not listed yet.",
      "detailedDescription":
          """Use this option when your temple or sacred place is not currently in our map catalog. You can share the place name and location, generate complete spiritual details, chat with the guide, and save it in your journey while it goes through moderation for wider visibility.""",
      "color": 0xFF455A64,
      "badge": "Custom",
      "chips": ["Your Temple", "AI Details", "Save Journey"],
      "type": "sacred",
    },
  ];

  List<Map<String, dynamic>> get _allIntentCards => [
    ..._spiritualIntents,
  ];

  List<Map<String, dynamic>> get _heroCards => [
    {
      "id": "All",
      "type": "sacred",
      "icon": "temple_hindu",
      "title": "Explore Heritage Sites of India",
      "subtitle": "All Sacred Sites",
      "description":
          "Open one master route that blends devotion, history, architecture, oral memory, and living traditions across Akhanda Bharat with route-ready context.",
      "imageUrl":
          "https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/map-hero/heritage%20site%20of%20india.png",
      "highlights": [
        "Plan your spiritual journey with route guidance",
        "Create discussion forums with seekers",
        "Shop from verified government sellers",
        "Connect with classical performers and communities",
        "Unlock curated stories, insights and more",
      ],
      "color": 0xFFE65100,
    },
    {
      "id": "UNESCO",
      "type": "sacred",
      "icon": "account_balance",
      "title": "World Heritage, Civilizational Depth",
      "subtitle": "UNESCO Heritage",
      "description":
          "Travel through timeless architecture, ancient universities, inscriptions, and scientific brilliance to understand Bharat's civilizational continuity.",
      "imageUrl":
          "https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/map-hero/Indian%20pilgrimages.png",
      "highlights": ["Architecture", "Archaeology", "Civilizational Memory"],
      "color": 0xFF00695C,
    },
    {
      "id": "Jyotirlinga",
      "type": "sacred",
      "icon": "flare",
      "title": "The Twelve Pillars of Light",
      "subtitle": "Jyotirlingas",
      "description":
          "Follow a high-devotion route linking Shiva shrines across the subcontinent with temple lore, ritual context, and regional pilgrimage practices.",
      "imageUrl":
          "https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/map-hero/Jyotirlingas.png",
      "highlights": ["Moksha Path", "Temple Lore", "Vedic Rituals"],
      "color": 0xFF6A1B9A,
    },
    {
      "id": "Shaktipeethas",
      "type": "sacred",
      "icon": "self_improvement",
      "title": "Sacred Feminine Energy Trail",
      "subtitle": "Shaktipeethas",
      "description":
          "Experience living power centers of Devi worship through guided exploration of mythology, temple traditions, and sacred geography.",
      "imageUrl":
          "https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/map-hero/Shaktipeeths.png",
      "highlights": ["Shakti Sites", "Legends", "Regional Traditions"],
      "color": 0xFFC2185B,
    },
    {
      "id": "Char_Dham",
      "type": "sacred",
      "icon": "landscape",
      "title": "High Altitude Pilgrimage",
      "subtitle": "Char Dham",
      "description":
          "Enter a premium Himalayan route with altitude-aware planning, seasonal guidance, temple context, and route-ready details for each dham.",
      "imageUrl":
          "https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/map-hero/CharDham.png",
      "highlights": ["Yamunotri", "Gangotri", "Kedarnath", "Badrinath"],
      "color": 0xFFF57C00,
    },
    {
      "id": "Other",
      "type": "sacred",
      "icon": "add_location_alt",
      "title": "Bring Your Sacred Place",
      "subtitle": "Other Sacred Sites",
      "description":
          "Add custom temples and sacred places, generate AI-enriched background, and continue your journey with personalized spiritual context.",
      "imageUrl":
          "https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/map-hero/Local%20Temples.png",
      "highlights": ["Custom Entry", "AI Enrichment", "Community Discovery"],
      "color": 0xFF455A64,
    },
  ];

  Widget _buildHeroHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final gradients = theme.extension<GradientExtension>();
    final t = Translations.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting and Notification Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.map.title,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                        letterSpacing: -0.5,
                        fontSize: 23.sp,
                      ),
                    ),
                    SizedBox(height: 0.4.h),
                    Text(
                      t.map.subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.72),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    HapticFeedback.selectionClick();
                    context.go('/home?tab=3&map=plan');
                  },
                  splashColor: Colors.white.withValues(alpha: 0.16),
                  highlightColor: Colors.white.withValues(alpha: 0.08),
                  child: Container(
                    height: 44,
                    width: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorScheme.primary.withValues(alpha: 0.98),
                          colorScheme.secondary.withValues(alpha: 0.92),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.18),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.34),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.edit_location_alt_rounded,
                      size: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openIntentCard(
    BuildContext context,
    Map<String, dynamic> card,
  ) async {
    final type = card['type']?.toString() ?? 'sacred';

    HapticFeedback.lightImpact();

    if (type == 'fabrics') {
      const IndianFabricsMapRoute().push(context);
      return;
    }

    if (type == 'crafts') {
      const IndianCraftsMapRoute().push(context);
      return;
    }

    if (type == 'classical_art') {
      const ClassicalArtMapRoute().push(context);
      return;
    }

    if (type == 'classical_dance') {
      const ClassicalDanceMapRoute().push(context);
      return;
    }

    if (type == 'foods') {
      const IndianFoodsMapRoute().push(context);
      return;
    }

    final intentId = card['id']?.toString();
    if (intentId == null || intentId.isEmpty) return;

    context.read<PilgrimageBloc>().add(UpdateIntents({intentId}));
    await MapStateStorage.saveSelectedIntents([intentId]);
    if (!context.mounted) return;

    context.go('/home?tab=3&map=akhanda', extra: [intentId]);
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
        final validIds = _spiritualIntents
            .map((intent) => intent['id'].toString())
            .toSet();

        final gradients = theme.extension<GradientExtension>();
        final bgGradient =
            gradients?.screenBackgroundGradient ??
            LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.surface,
                theme.colorScheme.surfaceContainerHigh,
              ],
            );

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            goBackToMapLanding(context);
          },
          child: Scaffold(
            body: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(gradient: bgGradient),
                    child: Padding(
                      padding: EdgeInsets.zero,
                      child: SafeArea(
                        top: false,
                        bottom: true,
                        child: CustomScrollView(
                          physics: const BouncingScrollPhysics(),
                          slivers: [
                            SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  SizedBox(height: 5.3.h),
                                  _buildHeroHeader(context),
                                  SizedBox(height: 1.2.h),
                                  MapIntentHeroCarousel(
                                    cards: _heroCards,
                                    onCardTap: (card) =>
                                        _openIntentCard(context, card),
                                  ),
                                  SizedBox(height: 1.8.h),
                                ],
                              ),
                            ),
                            const SliverToBoxAdapter(
                              child: IntentDiscussionComposerCard(),
                            ),
                            SliverPadding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate((
                                  context,
                                  index,
                                ) {
                                  final intent = _allIntentCards[index];
                                  final intentId =
                                      intent['id']?.toString() ?? '';
                                  final isSacred =
                                      intent['type']?.toString() == 'sacred';
                                  final isSelected =
                                      isSacred &&
                                      validIds.contains(intentId) &&
                                      state.selectedIntents.contains(intentId);

                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 1.5.h),
                                    child: IntentCardWidget(
                                      intent: intent,
                                      isSelected: isSelected,
                                      onTap: () =>
                                          _openIntentCard(context, intent),
                                      onLongPress: isSacred
                                          ? () => _showIntentDetails(
                                              context,
                                              intent,
                                            )
                                          : null,
                                    ),
                                  );
                                }, childCount: _allIntentCards.length),
                              ),
                            ),
                            SliverToBoxAdapter(child: SizedBox(height: 2.h)),
                          ],
                        ),
                      ),
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

  void _showIntentDetails(BuildContext context, Map<String, dynamic> intent) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => IntentDetailSheet(intent: intent),
    );
  }
}
