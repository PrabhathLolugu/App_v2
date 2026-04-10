import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/pages/Chat/Widget/share_to_conversation_sheet.dart';
import 'package:myitihas/pages/map2/forum_community/discussion_hashtag_utils.dart';
import 'package:myitihas/pages/map2/forum_community/forum_discussion_launch_context.dart';
import 'package:myitihas/pages/map2/indian_fabrics/fabric_hub.dart';
import 'package:myitihas/pages/map2/map_navigation.dart';
import 'package:myitihas/pages/map2/site_detail/widget/expandable_section.dart';
import 'package:myitihas/pages/map2/site_detail/widget/hero_image_section.dart';
import 'package:myitihas/services/chat_service.dart';
import 'package:myitihas/services/post_service.dart';
import 'package:sizer/sizer.dart';

class FabricHubDetailPage extends StatefulWidget {
  const FabricHubDetailPage({super.key, required this.hub});

  final FabricHub hub;

  @override
  State<FabricHubDetailPage> createState() => _FabricHubDetailPageState();
}

class _FabricHubDetailPageState extends State<FabricHubDetailPage> {
  final ScrollController _scrollController = ScrollController();
  bool _aboutExpanded = true;
  bool _historyExpanded = false;
  bool _culturalExpanded = false;
  bool _processExpanded = false;
  bool _motifsExpanded = false;
  bool _buyingExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);
    final hub = widget.hub;
    final hashtag =
        '#${hub.name.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '')} #${hub.fabricName.replaceAll(' ', '')}';

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: HeroImageSection(
              imageUrl: hub.imageUrl ?? '',
              semanticLabel: '${hub.name} - ${hub.fabricName}',
              onBackPressed: () => goBackToMapLanding(context),
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
              onShare: () => _shareHubToChat(context, hub),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  hub.fabricName,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 0.8.h),
                Text(
                  '${hub.name}, ${hub.region}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                SizedBox(height: 1.2.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(3.2.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.42,
                    ),
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant.withValues(
                        alpha: 0.45,
                      ),
                    ),
                  ),
                  child: Text(
                    hub.shortDescription,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
                  ),
                ),
                SizedBox(height: 1.h),
                Wrap(
                  spacing: 2.w,
                  runSpacing: 0.7.h,
                  children: [
                    _chip(
                      context,
                      Icons.auto_awesome,
                      'Premium handloom focus',
                    ),
                    _chip(context, Icons.public, hub.region),
                    if ((hub.bestBuyingSeason ?? '').isNotEmpty)
                      _chip(
                        context,
                        Icons.calendar_month_outlined,
                        hub.bestBuyingSeason!,
                      ),
                  ],
                ),
                SizedBox(height: 1.4.h),
                _buildQuickInfoGrid(context, hub),
                SizedBox(height: 2.2.h),
                ExpandableSection(
                  title: t.map.fabricMap.aboutTitle,
                  content: _buildAboutFallback(hub),
                  isExpanded: _aboutExpanded,
                  onToggle: () =>
                      setState(() => _aboutExpanded = !_aboutExpanded),
                ),
                ExpandableSection(
                  title: 'History',
                  content: _buildHistoryFallback(hub),
                  isExpanded: _historyExpanded,
                  onToggle: () =>
                      setState(() => _historyExpanded = !_historyExpanded),
                ),
                ExpandableSection(
                  title: 'Cultural Significance',
                  content: _buildCulturalFallback(hub),
                  isExpanded: _culturalExpanded,
                  onToggle: () =>
                      setState(() => _culturalExpanded = !_culturalExpanded),
                ),
                ExpandableSection(
                  title: 'Weaving Process',
                  content: _buildProcessFallback(hub),
                  isExpanded: _processExpanded,
                  onToggle: () =>
                      setState(() => _processExpanded = !_processExpanded),
                ),
                ExpandableSection(
                  title: 'Motifs & Design Language',
                  content: _buildMotifFallback(hub),
                  isExpanded: _motifsExpanded,
                  onToggle: () =>
                      setState(() => _motifsExpanded = !_motifsExpanded),
                ),
                ExpandableSection(
                  title: 'Buying & Authenticity',
                  content: _buildBuyingFallback(hub),
                  isExpanded: _buyingExpanded,
                  onToggle: () =>
                      setState(() => _buyingExpanded = !_buyingExpanded),
                ),
                SizedBox(height: 1.5.h),
                _gradientButton(
                  context,
                  label: t.map.fabricMap.shopCta,
                  icon: Icons.storefront_outlined,
                  onPressed: () =>
                      FabricShopRoute($extra: widget.hub).push(context),
                ),
                SizedBox(height: 1.5.h),
                OutlinedButton.icon(
                  onPressed: () => ForumCommunityRoute(
                    siteId: 'general',
                    $extra: ForumDiscussionLaunchContext(
                      suggestedHashtags: buildHashtagsFromParts([
                        widget.hub.fabricName,
                        'Indian Fabrics',
                        widget.hub.name,
                        widget.hub.state,
                        widget.hub.region,
                      ]),
                      originSiteId: widget.hub.discussionSiteId,
                      siteName: widget.hub.name,
                      defaultLocationMode: true,
                    ),
                  ).push(context),
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: Text(t.map.discussionTab),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size.fromHeight(5.5.h),
                  ),
                ),
                SizedBox(height: 4.h),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _fallback(String? value, String fallback) {
    final v = value?.trim() ?? '';
    return v.isEmpty ? fallback : v;
  }

  String _buildAboutFallback(FabricHub hub) {
    return _fallback(
      hub.aboutPlaceAndFabric,
      '${hub.fabricName} from ${hub.name}, ${hub.region} represents a living '
      'textile ecosystem where yarn preparation, loom setup, design planning, '
      'and finishing are distributed across specialist artisans and seller networks.',
    );
  }

  String _buildHistoryFallback(FabricHub hub) {
    return _fallback(
      hub.history,
      'The ${hub.fabricName} tradition in ${hub.name} developed through local '
      'weaving families, regional patronage, and trade networks. Over time, '
      'cooperatives and government channels helped preserve production quality '
      'and improve market access for artisans.',
    );
  }

  String _buildCulturalFallback(FabricHub hub) {
    return _fallback(
      hub.culturalSignificance,
      '${hub.fabricName} is widely used in ceremonial, festive, and heritage '
      'contexts. It carries regional identity through color language, drape style, '
      'and intergenerational usage in formal and family traditions.',
    );
  }

  String _buildProcessFallback(FabricHub hub) {
    return _fallback(
      hub.weavingProcess,
      'Typical production includes yarn sourcing and treatment, warp/weft planning, '
      'loom weaving, motif balancing, finishing, and quality checks. Differences in '
      'thread count, dye process, and border construction determine final quality.',
    );
  }

  String _buildMotifFallback(FabricHub hub) {
    return _fallback(
      hub.motifsAndDesign,
      'Design language usually combines regional geometry, nature-inspired motifs, '
      'and traditional border grammar. Signature patterns are often easiest to detect '
      'on the pallu, border transitions, and motif symmetry.',
    );
  }

  String _buildBuyingFallback(FabricHub hub) {
    return _fallback(
      hub.careAndAuthenticity,
      'For authenticity, check weave consistency, finish quality, and trusted seller '
      'channels. Prefer documented cooperative/government links, request fiber details, '
      'and follow recommended fabric care for long-term durability.',
    );
  }

  Widget _buildQuickInfoGrid(BuildContext context, FabricHub hub) {
    final season = (hub.bestBuyingSeason ?? '').trim();
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Professional snapshot',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 0.7.h,
            children: [
              _chip(
                context,
                Icons.place_outlined,
                '${hub.name}, ${hub.region}',
              ),
              _chip(context, Icons.inventory_2_outlined, hub.fabricName),
              _chip(
                context,
                Icons.storefront_outlined,
                '${hub.governmentSellers.length} verified sellers',
              ),
              if (season.isNotEmpty)
                _chip(context, Icons.calendar_month_outlined, season),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, IconData icon, String text) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.8.w, vertical: 0.65.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: colorScheme.primary),
          SizedBox(width: 1.5.w),
          Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _gradientButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 5.5.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF44009F), Color(0xFF0088FF)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Future<void> _shareHubToChat(BuildContext context, FabricHub hub) async {
    final conversationId = await ShareToConversationSheet.show(context);
    if (conversationId == null || !context.mounted) return;

    final chatService = getIt<ChatService>();
    final message = StringBuffer()
      ..writeln('Shared fabric hub: ${hub.name}')
      ..writeln('Fabric: ${hub.fabricName}')
      ..writeln('Region: ${hub.region}')
      ..writeln(hub.shortDescription)
      ..writeln()
      ..writeln('Open in app: /fabric-hub-detail (${hub.slug})');

    try {
      await chatService.sendMessage(
        conversationId: conversationId,
        content: message.toString(),
        type: 'text',
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fabric hub shared'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to share: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
