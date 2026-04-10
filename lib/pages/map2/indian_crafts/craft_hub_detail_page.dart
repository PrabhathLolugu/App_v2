import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/pages/Chat/Widget/share_to_conversation_sheet.dart';
import 'package:myitihas/pages/map2/forum_community/discussion_hashtag_utils.dart';
import 'package:myitihas/pages/map2/forum_community/forum_discussion_launch_context.dart';
import 'package:myitihas/pages/map2/indian_crafts/craft_hub.dart';
import 'package:myitihas/pages/map2/map_navigation.dart';
import 'package:myitihas/pages/map2/site_detail/widget/expandable_section.dart';
import 'package:myitihas/pages/map2/site_detail/widget/hero_image_section.dart';
import 'package:myitihas/services/chat_service.dart';
import 'package:myitihas/services/post_service.dart';
import 'package:sizer/sizer.dart';

class CraftHubDetailPage extends StatefulWidget {
  const CraftHubDetailPage({super.key, required this.hub});

  final CraftHub hub;

  @override
  State<CraftHubDetailPage> createState() => _CraftHubDetailPageState();
}

class _CraftHubDetailPageState extends State<CraftHubDetailPage> {
  final ScrollController _scrollController = ScrollController();
  bool _about = true;
  bool _history = false;
  bool _culture = false;
  bool _materials = false;
  bool _process = false;
  bool _motifs = false;
  bool _auth = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hub = widget.hub;
    final hashtag =
        '#${hub.name.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '')} #${hub.craftName.replaceAll(' ', '')}';

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: HeroImageSection(
              imageUrl: hub.imageUrl ?? '',
              semanticLabel: '${hub.name}-${hub.craftName}',
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
              onShare: () => _shareToChat(context, hub),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  hub.craftName,
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
                  ),
                  child: Text(
                    hub.shortDescription,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
                  ),
                ),
                SizedBox(height: 1.4.h),
                ExpandableSection(
                  title: 'About',
                  content: _fallback(
                    hub.aboutPlaceAndCraft,
                    'Detailed craft profile will be updated soon.',
                  ),
                  isExpanded: _about,
                  onToggle: () => setState(() => _about = !_about),
                ),
                ExpandableSection(
                  title: 'History',
                  content: _fallback(
                    hub.history,
                    'Historical timeline and evolution notes will be updated soon.',
                  ),
                  isExpanded: _history,
                  onToggle: () => setState(() => _history = !_history),
                ),
                ExpandableSection(
                  title: 'Cultural Significance',
                  content: _fallback(
                    hub.culturalSignificance,
                    'Cultural significance details will be updated soon.',
                  ),
                  isExpanded: _culture,
                  onToggle: () => setState(() => _culture = !_culture),
                ),
                ExpandableSection(
                  title: 'Materials',
                  content: _fallback(
                    hub.materials,
                    'Primary materials and sourcing details will be updated soon.',
                  ),
                  isExpanded: _materials,
                  onToggle: () => setState(() => _materials = !_materials),
                ),
                ExpandableSection(
                  title: 'Making Process',
                  content: _fallback(
                    hub.makingProcess,
                    'Step-by-step production details will be updated soon.',
                  ),
                  isExpanded: _process,
                  onToggle: () => setState(() => _process = !_process),
                ),
                ExpandableSection(
                  title: 'Motifs & Style',
                  content: _fallback(
                    hub.motifsAndStyle,
                    'Signature motifs and style language details will be updated soon.',
                  ),
                  isExpanded: _motifs,
                  onToggle: () => setState(() => _motifs = !_motifs),
                ),
                ExpandableSection(
                  title: 'Buying & Authenticity',
                  content: _fallback(
                    hub.careAndAuthenticity,
                    'Buying and authenticity guidance will be updated soon.',
                  ),
                  isExpanded: _auth,
                  onToggle: () => setState(() => _auth = !_auth),
                ),
                SizedBox(height: 1.5.h),
                _gradientButton(
                  context,
                  label: 'Shop',
                  icon: Icons.storefront_outlined,
                  onPressed: () => CraftShopRoute($extra: hub).push(context),
                ),
                SizedBox(height: 1.5.h),
                OutlinedButton.icon(
                  onPressed: () => ForumCommunityRoute(
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
                  ).push(context),
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text('Discussion'),
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

  Future<void> _shareToChat(BuildContext context, CraftHub hub) async {
    final conversationId = await ShareToConversationSheet.show(context);
    if (conversationId == null || !context.mounted) return;
    final chatService = getIt<ChatService>();
    final message = StringBuffer()
      ..writeln('Shared craft hub: ${hub.name}')
      ..writeln('Craft: ${hub.craftName}')
      ..writeln('Region: ${hub.region}')
      ..writeln(hub.shortDescription);
    try {
      await chatService.sendMessage(
        conversationId: conversationId,
        content: message.toString(),
        type: 'text',
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Craft hub shared')));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to share: $e')));
    }
  }
}
