import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/pages/Chat/Widget/share_to_conversation_sheet.dart';
import 'package:myitihas/pages/map2/forum_community/discussion_hashtag_utils.dart';
import 'package:myitihas/pages/map2/forum_community/forum_discussion_launch_context.dart';
import 'package:myitihas/pages/map2/indian_culture/cultural_category.dart';
import 'package:myitihas/pages/map2/indian_culture/cultural_item_detail_payload.dart';
import 'package:myitihas/pages/map2/map_navigation.dart';
import 'package:myitihas/pages/map2/site_detail/widget/expandable_section.dart';
import 'package:myitihas/pages/map2/site_detail/widget/hero_image_section.dart';
import 'package:myitihas/services/chat_service.dart';
import 'package:myitihas/services/post_service.dart';
import 'package:sizer/sizer.dart';

class CulturalItemDetailPage extends StatefulWidget {
  const CulturalItemDetailPage({super.key, required this.payload});

  final CulturalItemDetailPayload payload;

  @override
  State<CulturalItemDetailPage> createState() => _CulturalItemDetailPageState();
}

class _CulturalItemDetailPageState extends State<CulturalItemDetailPage> {
  final ScrollController _scrollController = ScrollController();
  bool _about = true;
  bool _history = false;
  bool _significance = false;
  bool _practice = false;
  bool _context = false;
  bool _exponents = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final item = widget.payload.item;
    final stateName = widget.payload.stateName;
    final hashtag =
        '#${stateName.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '')} #${item.itemName.replaceAll(' ', '')}';
    final launchContext = ForumDiscussionLaunchContext(
      suggestedHashtags: buildHashtagsFromParts([
        item.itemName,
        widget.payload.category == CulturalCategory.classicalArt
            ? 'Indian Classical Art'
            : 'Indian Classical Dance',
        stateName,
      ]),
      originSiteId: item.discussionSiteId,
      siteName: stateName,
      defaultLocationMode: true,
    );

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: HeroImageSection(
              imageUrl: item.coverImageUrl ?? '',
              semanticLabel: '${item.itemName}-$stateName',
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
              onShare: () => _shareToChat(context),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  item.itemName,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 0.8.h),
                Text(
                  stateName,
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
                    item.shortDescription,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
                  ),
                ),
                SizedBox(height: 1.4.h),
                ExpandableSection(
                  title: 'About this state tradition',
                  content: _fallback(
                    item.aboutStateTradition,
                    'Detailed state tradition notes will be updated soon.',
                  ),
                  isExpanded: _about,
                  onToggle: () => setState(() => _about = !_about),
                ),
                ExpandableSection(
                  title: 'History',
                  content: _fallback(
                    item.history,
                    'Historical context and evolution details will be updated soon.',
                  ),
                  isExpanded: _history,
                  onToggle: () => setState(() => _history = !_history),
                ),
                ExpandableSection(
                  title: 'Cultural significance',
                  content: _fallback(
                    item.culturalSignificance,
                    'Cultural significance notes will be updated soon.',
                  ),
                  isExpanded: _significance,
                  onToggle: () =>
                      setState(() => _significance = !_significance),
                ),
                ExpandableSection(
                  title: 'Practice and pedagogy',
                  content: _fallback(
                    item.practiceAndPedagogy,
                    'Training pathways and pedagogy notes will be updated soon.',
                  ),
                  isExpanded: _practice,
                  onToggle: () => setState(() => _practice = !_practice),
                ),
                ExpandableSection(
                  title: 'Performance context',
                  content: _fallback(
                    item.performanceContext,
                    'Performance context notes will be updated soon.',
                  ),
                  isExpanded: _context,
                  onToggle: () => setState(() => _context = !_context),
                ),
                ExpandableSection(
                  title: 'Notable exponents',
                  content: _fallback(
                    item.notableExponents,
                    'Notable exponents information will be updated soon.',
                  ),
                  isExpanded: _exponents,
                  onToggle: () => setState(() => _exponents = !_exponents),
                ),
                SizedBox(height: 1.2.h),
                OutlinedButton.icon(
                  onPressed: () => ForumCommunityRoute(
                    siteId: 'general',
                    $extra: launchContext,
                  ).push(context),
                  icon: const Icon(Icons.forum_outlined),
                  label: const Text('Discussion forum'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size.fromHeight(5.5.h),
                  ),
                ),
                SizedBox(height: 1.h),
                FilledButton.icon(
                  onPressed: () {
                    GoRouter.of(context).push(
                      '/create-post',
                      extra: {
                        'initialPostType': PostType.text,
                        'initialContent': hashtag,
                      },
                    );
                  },
                  icon: const Icon(Icons.campaign_outlined),
                  label: const Text('Post to community'),
                  style: FilledButton.styleFrom(
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

  Future<void> _shareToChat(BuildContext context) async {
    final payload = widget.payload;
    final conversationId = await ShareToConversationSheet.show(context);
    if (conversationId == null || !context.mounted) return;
    final chatService = getIt<ChatService>();
    final message = StringBuffer()
      ..writeln('Shared cultural profile: ${payload.item.itemName}')
      ..writeln('State: ${payload.stateName}')
      ..writeln(payload.item.shortDescription);
    try {
      await chatService.sendMessage(
        conversationId: conversationId,
        content: message.toString(),
        type: 'text',
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile shared')));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to share: $e')));
    }
  }
}
