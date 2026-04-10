import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/pages/Chat/Widget/share_to_conversation_sheet.dart';
import 'package:myitihas/pages/map2/forum_community/discussion_hashtag_utils.dart';
import 'package:myitihas/pages/map2/forum_community/forum_discussion_launch_context.dart';
import 'package:myitihas/pages/map2/indian_foods/food_item_detail_payload.dart';
import 'package:myitihas/pages/map2/map_navigation.dart';
import 'package:myitihas/pages/map2/site_detail/widget/expandable_section.dart';
import 'package:myitihas/pages/map2/site_detail/widget/hero_image_section.dart';
import 'package:myitihas/services/chat_service.dart';
import 'package:myitihas/services/post_service.dart';
import 'package:sizer/sizer.dart';

class FoodItemDetailPage extends StatefulWidget {
  const FoodItemDetailPage({super.key, required this.payload});

  final FoodItemDetailPayload payload;

  @override
  State<FoodItemDetailPage> createState() => _FoodItemDetailPageState();
}

class _FoodItemDetailPageState extends State<FoodItemDetailPage> {
  final ScrollController _scrollController = ScrollController();
  bool _about = true;
  bool _history = false;
  bool _ingredients = false;
  bool _preparation = false;
  bool _serving = false;
  bool _nutrition = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final item = widget.payload.item;
    final stateName = widget.payload.stateName;
    final hashtag =
        '#${stateName.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '')} #${item.foodName.replaceAll(' ', '')}';
    final launchContext = ForumDiscussionLaunchContext(
      suggestedHashtags: buildHashtagsFromParts([
        item.foodName,
        'Indian Foods',
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
              semanticLabel: '${item.foodName}-$stateName',
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
                  item.foodName,
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
                  title: 'About this state food tradition',
                  content: _fallback(
                    item.aboutFood,
                    'Detailed state-food context will be updated soon.',
                  ),
                  isExpanded: _about,
                  onToggle: () => setState(() => _about = !_about),
                ),
                ExpandableSection(
                  title: 'History',
                  content: _fallback(
                    item.history,
                    'Historical context and culinary evolution will be updated soon.',
                  ),
                  isExpanded: _history,
                  onToggle: () => setState(() => _history = !_history),
                ),
                ExpandableSection(
                  title: 'Ingredients',
                  content: _fallback(
                    item.ingredients,
                    'Ingredients details will be updated soon.',
                  ),
                  isExpanded: _ingredients,
                  onToggle: () => setState(() => _ingredients = !_ingredients),
                ),
                ExpandableSection(
                  title: 'Preparation style',
                  content: _fallback(
                    item.preparationStyle,
                    'Preparation notes will be updated soon.',
                  ),
                  isExpanded: _preparation,
                  onToggle: () => setState(() => _preparation = !_preparation),
                ),
                ExpandableSection(
                  title: 'Serving context',
                  content: _fallback(
                    item.servingContext,
                    'Serving context details will be updated soon.',
                  ),
                  isExpanded: _serving,
                  onToggle: () => setState(() => _serving = !_serving),
                ),
                ExpandableSection(
                  title: 'Nutrition notes',
                  content: _fallback(
                    item.nutritionNotes,
                    'Nutrition notes will be updated soon.',
                  ),
                  isExpanded: _nutrition,
                  onToggle: () => setState(() => _nutrition = !_nutrition),
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
      ..writeln('Shared food profile: ${payload.item.foodName}')
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
