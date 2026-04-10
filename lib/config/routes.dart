import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myitihas/config/go_router_refresh.dart';
import 'package:myitihas/features/chat/presentation/pages/chat_list_page.dart';
import 'package:myitihas/features/chat/presentation/pages/chat_view_page.dart';
import 'package:myitihas/features/festivals/domain/entities/hindu_festival.dart';
import 'package:myitihas/features/festivals/presentation/pages/festival_detail_page.dart';
import 'package:myitihas/features/festivals/presentation/pages/festivals_list_page.dart';
import 'package:myitihas/features/home/presentation/pages/activity_history_page.dart';
import 'package:myitihas/features/home/presentation/pages/saved_stories_page.dart';
import 'package:myitihas/features/settings/presentation/pages/blocked_users_page.dart';
import 'package:myitihas/features/settings/presentation/pages/cache_settings_page.dart';
import 'package:myitihas/features/social/domain/entities/feed_item.dart';
import 'package:myitihas/features/social/presentation/pages/create_post_page.dart';
import 'package:myitihas/features/social/presentation/pages/edit_profile_page.dart';
import 'package:myitihas/features/social/presentation/pages/followers_page.dart';
import 'package:myitihas/features/social/presentation/pages/following_page.dart';
import 'package:myitihas/features/social/presentation/pages/notification_page.dart';
import 'package:myitihas/features/social/presentation/pages/post_detail_page.dart';
import 'package:myitihas/features/social/presentation/pages/profile_page.dart';
import 'package:myitihas/features/social/presentation/pages/social_feed_page.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import 'package:myitihas/features/stories/presentation/pages/downloaded_stories_page.dart';
import 'package:myitihas/features/story_generator/presentation/pages/generated_story_by_id_page.dart';
import 'package:myitihas/features/story_generator/presentation/pages/generated_story_detail_page.dart';
import 'package:myitihas/features/story_generator/presentation/pages/story_generator_page.dart';
import 'package:myitihas/pages/Chat/Widget/add_group_members_page.dart';
import 'package:myitihas/pages/Chat/Widget/chat_detail_page.dart';
import 'package:myitihas/pages/Chat/Widget/chat_requests_page.dart';
import 'package:myitihas/pages/Chat/Widget/chatbot.dart';
import 'package:myitihas/pages/Chat/Widget/create_group_page.dart';
import 'package:myitihas/pages/Chat/Widget/edit_group_page.dart';
import 'package:myitihas/pages/Chat/Widget/group_profile_page.dart';
import 'package:myitihas/pages/Chat/Widget/join_group_via_link_page.dart';
import 'package:myitihas/pages/Chat/Widget/little_krishna_intro_page.dart';
import 'package:myitihas/pages/Chat/Widget/new_chat_page.dart';
import 'package:myitihas/pages/Chat/Widget/new_contact_page.dart';
import 'package:myitihas/pages/Chat/Widget/new_group_page.dart';
import 'package:myitihas/pages/Chat/Widget/profile_detail_page.dart';
import 'package:myitihas/pages/auth/account_deleted_page.dart';
import 'package:myitihas/pages/auth/login_page.dart';
import 'package:myitihas/pages/auth/reset_password_page.dart';
import 'package:myitihas/pages/auth/signup_page.dart';
import 'package:myitihas/pages/auth/welcome_page.dart';
import 'package:myitihas/pages/discover_page.dart';
import 'package:myitihas/pages/home_page.dart';
import 'package:myitihas/pages/map2/Model/sacred_location.dart';
import 'package:myitihas/pages/map2/akhanda_bharata_map/akhanda_bharata_map.dart';
import 'package:myitihas/pages/map2/forum_community/forum_community.dart';
import 'package:myitihas/pages/map2/forum_community/forum_discussion_launch_context.dart';
import 'package:myitihas/pages/map2/intent_choice/intent_choice.dart';
import 'package:myitihas/pages/map2/map_explore/map_explore_page.dart';
import 'package:myitihas/pages/map2/map_guide.dart';
import 'package:myitihas/pages/map2/my_journey/my_journey.dart';
import 'package:myitihas/pages/map2/nearby_places/nearby_places_page.dart';
import 'package:myitihas/pages/map2/plan/plan_page.dart';
import 'package:myitihas/pages/map2/plan/post_travel_story_page.dart';
import 'package:myitihas/pages/map2/plan/saved_plan_detail_page.dart';
import 'package:myitihas/pages/map2/plan/saved_travel_plan.dart';
import 'package:myitihas/pages/map2/indian_fabrics/fabric_hub.dart';
import 'package:myitihas/pages/map2/indian_fabrics/fabric_hub_detail_page.dart';
import 'package:myitihas/pages/map2/indian_fabrics/fabric_shop_page.dart';
import 'package:myitihas/pages/map2/indian_fabrics/indian_fabrics_map_page.dart';
import 'package:myitihas/pages/map2/indian_crafts/craft_hub.dart';
import 'package:myitihas/pages/map2/indian_crafts/craft_hub_detail_page.dart';
import 'package:myitihas/pages/map2/indian_crafts/craft_shop_page.dart';
import 'package:myitihas/pages/map2/indian_crafts/indian_crafts_map_page.dart';
import 'package:myitihas/pages/map2/indian_culture/cultural_category.dart';
import 'package:myitihas/pages/map2/indian_culture/cultural_item_detail_page.dart';
import 'package:myitihas/pages/map2/indian_culture/cultural_item_detail_payload.dart';
import 'package:myitihas/pages/map2/indian_culture/state_cultural_map_page.dart';
import 'package:myitihas/pages/map2/indian_foods/food_item_detail_page.dart';
import 'package:myitihas/pages/map2/indian_foods/food_item_detail_payload.dart';
import 'package:myitihas/pages/map2/indian_foods/state_foods_map_page.dart';
import 'package:myitihas/pages/map2/site_detail/site_detail.dart';
import 'package:myitihas/pages/settings_page.dart';
import 'package:myitihas/pages/splash.dart';
import 'package:myitihas/pages/stories_page.dart';
import 'package:myitihas/profile/edit_profile_screen/edit_profile_screen.dart';
import 'package:myitihas/profile/profile_image_viewer.dart';
import 'package:myitihas/services/post_service.dart';
import 'package:myitihas/services/supabase_service.dart';

part 'routes.g.dart';

@TypedGoRoute<SplashRoute>(path: '/')
class SplashRoute extends GoRouteData with $SplashRoute {
  const SplashRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SplashScreen();
  }
}

@TypedGoRoute<HomeRoute>(
  path: '/home',
  routes: [
    TypedGoRoute<StoriesRoute>(
      path: 'stories',
      routes: [TypedGoRoute<StoryDetailRoute>(path: ':id')],
    ),
  ],
)
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomePage();
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: const HomePage(),
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        );
      },
    );
  }
}

/// Discover
@TypedGoRoute<DiscoverRoute>(path: '/discover')
class DiscoverRoute extends GoRouteData with $DiscoverRoute {
  const DiscoverRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DiscoverPage();
  }
}

/// Welcome / Onboarding
@TypedGoRoute<WelcomeRoute>(path: '/welcome')
class WelcomeRoute extends GoRouteData with $WelcomeRoute {
  const WelcomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const WelcomePage();
  }
}

/// Login
@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends GoRouteData with $LoginRoute {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginPage();
  }
}

/// Signup
@TypedGoRoute<SignupRoute>(path: '/signup')
class SignupRoute extends GoRouteData with $SignupRoute {
  const SignupRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SignupPage();
  }
}

/// Reset password
@TypedGoRoute<ResetPasswordRoute>(path: '/reset-password')
class ResetPasswordRoute extends GoRouteData with $ResetPasswordRoute {
  const ResetPasswordRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ResetPasswordPage();
  }
}

/// Account deleted (shown after user permanently deletes account in-app)
@TypedGoRoute<AccountDeletedRoute>(path: '/account-deleted')
class AccountDeletedRoute extends GoRouteData with $AccountDeletedRoute {
  const AccountDeletedRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AccountDeletedPage();
  }
}

/// New chat
@TypedGoRoute<NewChatRoute>(path: '/new-chat')
class NewChatRoute extends GoRouteData with $NewChatRoute {
  const NewChatRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const NewChatPage();
  }
}

/// Chat requests (message and group invite requests)
@TypedGoRoute<ChatRequestsRoute>(path: '/chat-requests')
class ChatRequestsRoute extends GoRouteData with $ChatRequestsRoute {
  const ChatRequestsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ChatRequestsPage();
  }
}

/// New group
@TypedGoRoute<NewGroupRoute>(path: '/new-group')
class NewGroupRoute extends GoRouteData with $NewGroupRoute {
  const NewGroupRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const NewGroupPage();
  }
}

/// Create group - takes selected users
@TypedGoRoute<CreateGroupRoute>(path: '/create-group')
class CreateGroupRoute extends GoRouteData with $CreateGroupRoute {
  const CreateGroupRoute({required this.$extra});

  final List<Map<String, dynamic>> $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CreateGroupPage(selectedUsers: $extra);
  }
}

/// New contact
@TypedGoRoute<NewContactRoute>(path: '/new-contact')
class NewContactRoute extends GoRouteData with $NewContactRoute {
  const NewContactRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const NewContactPage();
  }
}

/// Chat detail page route - requires parameters passed via $extra
@TypedGoRoute<ChatDetailRoute>(path: '/chat_detail')
class ChatDetailRoute extends GoRouteData with $ChatDetailRoute {
  const ChatDetailRoute({required this.$extra});

  final Map<String, dynamic> $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ChatDetailPage(
      conversationId: $extra['conversationId'], // Now nullable
      userId: $extra['userId'] ?? '',
      name: $extra['name'] ?? "User",
      avatarUrl: $extra['avatarUrl'],
      avatarColor: $extra['color'] != null
          // ignore: deprecated_member_use
          ? "0xFF${($extra['color'] as Color).value.toRadixString(16).substring(2)}"
          : null,
      isGroup: $extra['isGroup'] ?? false,
    );
  }
}

/// Profile detail page route - requires name parameter via $extra
@TypedGoRoute<ProfileDetailRoute>(path: '/profile_detail')
class ProfileDetailRoute extends GoRouteData with $ProfileDetailRoute {
  const ProfileDetailRoute({required this.$extra});

  final Map<String, dynamic> $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProfileDetailPage(name: $extra['name'] ?? "User");
  }
}

/// Group profile page route - requires conversationId via $extra
@TypedGoRoute<GroupProfileRoute>(path: '/group_profile')
class GroupProfileRoute extends GoRouteData with $GroupProfileRoute {
  const GroupProfileRoute({required this.$extra});

  final Map<String, dynamic> $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return GroupProfilePage(conversationId: $extra['conversationId'] ?? '');
  }
}

/// Edit group page route - requires conversationId via $extra
@TypedGoRoute<EditGroupRoute>(path: '/edit_group')
class EditGroupRoute extends GoRouteData with $EditGroupRoute {
  const EditGroupRoute({required this.$extra});

  final Map<String, dynamic> $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return EditGroupPage(conversationId: $extra['conversationId'] ?? '');
  }
}

/// Add members to group page route - requires conversationId and existingMemberIds via $extra
@TypedGoRoute<AddGroupMembersRoute>(path: '/add_group_members')
class AddGroupMembersRoute extends GoRouteData with $AddGroupMembersRoute {
  const AddGroupMembersRoute({required this.$extra});

  final Map<String, dynamic> $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return AddGroupMembersPage(
      conversationId: $extra['conversationId'] ?? '',
      existingMemberIds: List<String>.from($extra['existingMemberIds'] ?? []),
    );
  }
}

/// Join group via invite link route.
@TypedGoRoute<JoinGroupViaLinkRoute>(path: '/join-group-via-link/:code')
class JoinGroupViaLinkRoute extends GoRouteData with $JoinGroupViaLinkRoute {
  const JoinGroupViaLinkRoute({required this.code});

  final String code;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return JoinGroupViaLinkPage(inviteCode: code);
  }
}

/// Settings page
@TypedGoRoute<SettingsRoute>(
  path: '/settings',
  routes: [
    TypedGoRoute<CacheSettingsRoute>(path: 'cache'),
    TypedGoRoute<BlockedUsersRoute>(path: 'blocked-users'),
  ],
)
class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingsPage();
  }
}

/// Cache settings page
class CacheSettingsRoute extends GoRouteData with $CacheSettingsRoute {
  const CacheSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CacheSettingsPage();
  }
}

/// Blocked users page
class BlockedUsersRoute extends GoRouteData with $BlockedUsersRoute {
  const BlockedUsersRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const BlockedUsersPage();
  }
}

/// Edit Profile page
@TypedGoRoute<EditProfileRoute>(path: '/edit-profile/:userId')
class EditProfileRoute extends GoRouteData with $EditProfileRoute {
  final String userId;
  final String displayName;
  final String bio;
  final String avatarUrl;

  const EditProfileRoute({
    required this.userId,
    required this.displayName,
    this.bio = '',
    this.avatarUrl = '',
  });

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final currentUserId = SupabaseService.client.auth.currentUser?.id;
    if (currentUserId == null || currentUserId != userId) {
      // Prevent exposing profile-edit controls outside the profile edit flow.
      return ProfilePage(userId: userId);
    }

    return EditProfilePage(
      userId: userId,
      currentDisplayName: displayName,
      currentBio: bio,
      currentAvatarUrl: avatarUrl,
    );
  }
}

// ============================================================================
// MyItihasRouter - GoRouter Configuration
// ============================================================================
class MyItihasRouter {
  final GoRouterRefreshStream _refreshStream = GoRouterRefreshStream();
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  MyItihasRouter() {
    // Register refresh stream with SupabaseService so AuthService can access it
    SupabaseService.setRefreshStream(_refreshStream);
  }

  GoRouter get router => GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    routes: $appRoutes,
    refreshListenable: _refreshStream,
    redirect: (context, state) {
      final isAuthenticated = SupabaseService.getCurrentSession() != null;
      final isRecovering = _refreshStream.isRecovering;

      final currentPath = state.matchedLocation;
      final isOnLogin = currentPath == '/login';
      final isOnSignup = currentPath == '/signup';
      final isOnSplash = currentPath == '/';
      final isOnResetPassword = currentPath == '/reset-password';
      final isOnWelcome = currentPath == '/welcome';
      final isOnAccountDeleted = currentPath == '/account-deleted';

      // HIGHEST PRIORITY: Password recovery flow
      // If user is in recovery mode, FORCE them to /reset-password
      if (isRecovering) {
        if (!isOnResetPassword) {
          return '/reset-password';
        }
        return null;
      }

      // Authenticated user trying to access login/signup/welcome
      if (isAuthenticated && (isOnLogin || isOnSignup || isOnWelcome)) {
        return '/home?tab=2';
      }

      // Splash screen should be shown only for unauthenticated users.
      // Signed-in users land directly on the social tab.
      if (isOnSplash) {
        return isAuthenticated ? '/home?tab=2' : null;
      }

      // Reset password page without recovery mode
      if (isOnResetPassword && !isRecovering) {
        return '/login';
      }

      // Unauthenticated: allow account-deleted page (post-deletion screen)
      if (!isAuthenticated &&
          !isOnLogin &&
          !isOnSignup &&
          !isOnResetPassword &&
          !isOnWelcome &&
          !isOnAccountDeleted) {
        return '/welcome';
      }

      return null;
    },
  );
}

// ============================================================================
// Feature Routes (TypedGoRoute – from main branch)
// ============================================================================

class StoriesRoute extends GoRouteData with $StoriesRoute {
  const StoriesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const StoriesPage();
  }
}

class StoryDetailRoute extends GoRouteData with $StoryDetailRoute {
  final String id;

  const StoryDetailRoute({required this.id});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return GeneratedStoryByIdPage(storyId: id);
  }
}

@TypedGoRoute<SocialFeedRoute>(path: '/social-feed')
class SocialFeedRoute extends GoRouteData with $SocialFeedRoute {
  const SocialFeedRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SocialFeedPage();
  }
}

@TypedGoRoute<PostDetailRoute>(path: '/post/:postId')
class PostDetailRoute extends GoRouteData with $PostDetailRoute {
  final String postId;
  final String postType;

  const PostDetailRoute({required this.postId, this.postType = 'image'});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    FeedItem? initialFeedItem;
    String? initialCommentId;
    String resolvedPostType = postType;
    final extra = state.extra;

    if (extra is FeedItem) {
      initialFeedItem = extra;
    } else if (extra is Map<String, dynamic>) {
      final maybeFeedItem = extra['feedItem'];
      if (maybeFeedItem is FeedItem) {
        initialFeedItem = maybeFeedItem;
      }
      final maybeCommentId = extra['commentId'];
      if (maybeCommentId is String && maybeCommentId.trim().isNotEmpty) {
        initialCommentId = maybeCommentId.trim();
      }
      // Extract postType from extra map (passed from notification routing)
      final maybePostType = extra['postType'];
      if (maybePostType is String && maybePostType.trim().isNotEmpty) {
        resolvedPostType = maybePostType.trim();
      }
    }

    return PostDetailPage(
      postId: postId,
      postType: resolvedPostType,
      initialFeedItem: initialFeedItem,
      initialCommentId: initialCommentId,
    );
  }
}

@TypedGoRoute<CreatePostRoute>(path: '/create-post')
class CreatePostRoute extends GoRouteData with $CreatePostRoute {
  const CreatePostRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    PostType? initialPostType;
    String? initialContent;

    final extra = state.extra;
    if (extra is Map<String, dynamic>) {
      final type = extra['initialPostType'];
      if (type is PostType) {
        initialPostType = type;
      }
      final content = extra['initialContent'];
      if (content is String) {
        initialContent = content;
      }
    }

    return CreatePostPage(
      initialPostType: initialPostType,
      initialContent: initialContent,
    );
  }
}

@TypedGoRoute<ProfileRoute>(path: '/profile/:userId')
class ProfileRoute extends GoRouteData with $ProfileRoute {
  final String userId;

  const ProfileRoute({required this.userId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProfilePage(userId: userId);
  }
}

@TypedGoRoute<FollowersRoute>(path: '/followers/:userId')
class FollowersRoute extends GoRouteData with $FollowersRoute {
  final String userId;

  const FollowersRoute({required this.userId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FollowersPage(userId: userId);
  }
}

@TypedGoRoute<FollowingRoute>(path: '/following/:userId')
class FollowingRoute extends GoRouteData with $FollowingRoute {
  final String userId;

  const FollowingRoute({required this.userId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FollowingPage(userId: userId);
  }
}

@TypedGoRoute<NotificationRoute>(path: '/notifications')
class NotificationRoute extends GoRouteData with $NotificationRoute {
  const NotificationRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const NotificationPage();
  }
}

@TypedGoRoute<ChatListRoute>(
  path: '/chat',
  routes: [TypedGoRoute<ChatViewRoute>(path: ':conversationId')],
)
class ChatListRoute extends GoRouteData with $ChatListRoute {
  const ChatListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ChatListPage();
  }
}

class ChatViewRoute extends GoRouteData with $ChatViewRoute {
  final String conversationId;

  const ChatViewRoute({required this.conversationId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ChatViewPage(conversationId: conversationId);
  }
}

/// Story Generator route with result sub-route
@TypedGoRoute<StoryGeneratorRoute>(
  path: '/story-generator',
  routes: [
    TypedGoRoute<GeneratedStoryResultRoute>(path: 'result'),
    TypedGoRoute<GeneratedStoryByIdRoute>(path: ':storyId'),
  ],
)
class StoryGeneratorRoute extends GoRouteData with $StoryGeneratorRoute {
  final String? initialPrompt;
  final String? initialLanguageCode;

  const StoryGeneratorRoute({this.initialPrompt, this.initialLanguageCode});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return StoryGeneratorPage(
      initialPrompt: initialPrompt,
      initialLanguageCode: initialLanguageCode,
    );
  }
}

/// Generated story result page - receives Story via $extra
class GeneratedStoryResultRoute extends GoRouteData
    with $GeneratedStoryResultRoute {
  final Story $extra;

  const GeneratedStoryResultRoute({required this.$extra});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return GeneratedStoryDetailPage(story: $extra);
  }
}

/// Generated story by ID - fetches story from database
class GeneratedStoryByIdRoute extends GoRouteData
    with $GeneratedStoryByIdRoute {
  final String storyId;

  const GeneratedStoryByIdRoute({required this.storyId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return GeneratedStoryByIdPage(storyId: storyId);
  }
}

/// Activity History page
@TypedGoRoute<ActivityHistoryRoute>(path: '/activity')
class ActivityHistoryRoute extends GoRouteData with $ActivityHistoryRoute {
  const ActivityHistoryRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ActivityHistoryPage();
  }
}

// ============================================================================
// NEW: Akhanda Bharata / Map2 Feature Routes
// ============================================================================

@TypedGoRoute<IntentChoiceRoute>(path: '/intent-choice')
class IntentChoiceRoute extends GoRouteData with $IntentChoiceRoute {
  const IntentChoiceRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => IntentChoice();
}

@TypedGoRoute<AkhandaBharataMapRoute>(path: '/akhanda-bharata-map')
class AkhandaBharataMapRoute extends GoRouteData with $AkhandaBharataMapRoute {
  final List<String>? $extra;

  const AkhandaBharataMapRoute({this.$extra});

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    final raw = $extra ?? state.extra;
    final List<String> intents = raw is List
        ? List<String>.from(
            raw
                .map((e) => e?.toString().trim() ?? '')
                .where((intent) => intent.isNotEmpty),
          )
        : const [];
    final selectedIntents = intents.isEmpty ? const ['All'] : intents;
    return CustomTransitionPage(
      key: state.pageKey,
      child: AkhandaBharataMap(selectedIntents: selectedIntents),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          child,
    );
  }
}

@TypedGoRoute<SiteDetailRoute>(path: '/site-detail')
class SiteDetailRoute extends GoRouteData with $SiteDetailRoute {
  final SacredLocation $extra;

  const SiteDetailRoute({required this.$extra});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SiteDetail(location: $extra);
  }
}

@TypedGoRoute<NearbyPlacesRoute>(path: '/nearby-places')
class NearbyPlacesRoute extends GoRouteData with $NearbyPlacesRoute {
  final SacredLocation $extra;

  const NearbyPlacesRoute({required this.$extra});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return NearbyPlacesPage(selectedLocation: $extra);
  }
}

@TypedGoRoute<IndianFabricsMapRoute>(path: '/indian-fabrics-map')
class IndianFabricsMapRoute extends GoRouteData with $IndianFabricsMapRoute {
  const IndianFabricsMapRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const IndianFabricsMapPage();
}

@TypedGoRoute<FabricHubDetailRoute>(path: '/fabric-hub-detail')
class FabricHubDetailRoute extends GoRouteData with $FabricHubDetailRoute {
  final FabricHub $extra;

  const FabricHubDetailRoute({required this.$extra});

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      FabricHubDetailPage(hub: $extra);
}

@TypedGoRoute<FabricShopRoute>(path: '/fabric-shop')
class FabricShopRoute extends GoRouteData with $FabricShopRoute {
  final FabricHub $extra;

  const FabricShopRoute({required this.$extra});

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      FabricShopPage(hub: $extra);
}

@TypedGoRoute<IndianCraftsMapRoute>(path: '/indian-crafts-map')
class IndianCraftsMapRoute extends GoRouteData with $IndianCraftsMapRoute {
  const IndianCraftsMapRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const IndianCraftsMapPage();
}

@TypedGoRoute<CraftHubDetailRoute>(path: '/craft-hub-detail')
class CraftHubDetailRoute extends GoRouteData with $CraftHubDetailRoute {
  final CraftHub $extra;

  const CraftHubDetailRoute({required this.$extra});

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      CraftHubDetailPage(hub: $extra);
}

@TypedGoRoute<CraftShopRoute>(path: '/craft-shop')
class CraftShopRoute extends GoRouteData with $CraftShopRoute {
  final CraftHub $extra;

  const CraftShopRoute({required this.$extra});

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      CraftShopPage(hub: $extra);
}

@TypedGoRoute<ClassicalArtMapRoute>(path: '/classical-art-map')
class ClassicalArtMapRoute extends GoRouteData with $ClassicalArtMapRoute {
  const ClassicalArtMapRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const StateCulturalMapPage(category: CulturalCategory.classicalArt);
}

@TypedGoRoute<ClassicalDanceMapRoute>(path: '/classical-dance-map')
class ClassicalDanceMapRoute extends GoRouteData with $ClassicalDanceMapRoute {
  const ClassicalDanceMapRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const StateCulturalMapPage(category: CulturalCategory.classicalDance);
}

@TypedGoRoute<CulturalItemDetailRoute>(path: '/cultural-item-detail')
class CulturalItemDetailRoute extends GoRouteData
    with $CulturalItemDetailRoute {
  final CulturalItemDetailPayload $extra;

  const CulturalItemDetailRoute({required this.$extra});

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      CulturalItemDetailPage(payload: $extra);
}

@TypedGoRoute<IndianFoodsMapRoute>(path: '/indian-foods-map')
class IndianFoodsMapRoute extends GoRouteData with $IndianFoodsMapRoute {
  const IndianFoodsMapRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const StateFoodsMapPage();
}

@TypedGoRoute<FoodItemDetailRoute>(path: '/food-item-detail')
class FoodItemDetailRoute extends GoRouteData with $FoodItemDetailRoute {
  final FoodItemDetailPayload $extra;

  const FoodItemDetailRoute({required this.$extra});

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      FoodItemDetailPage(payload: $extra);
}

@TypedGoRoute<ForumCommunityRoute>(path: '/forum-community/:siteId')
class ForumCommunityRoute extends GoRouteData with $ForumCommunityRoute {
  final String siteId;
  final ForumDiscussionLaunchContext? $extra;

  const ForumCommunityRoute({required this.siteId, this.$extra});

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      CustomTransitionPage(
        key: state.pageKey,
        child: ForumCommunity(siteId: siteId, launchContext: $extra),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            child,
      );
}

@TypedGoRoute<MyJourneyRoute>(path: '/my-journey')
class MyJourneyRoute extends GoRouteData with $MyJourneyRoute {
  const MyJourneyRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      CustomTransitionPage(
        key: state.pageKey,
        child: const MyJourney(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            child,
      );
}

@TypedGoRoute<PlanRoute>(path: '/plan')
class PlanRoute extends GoRouteData with $PlanRoute {
  const PlanRoute({this.$extra});

  final SacredLocation? $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      CustomTransitionPage(
        key: state.pageKey,
        child: PlanPage(initialDestination: $extra),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            child,
      );
}

@TypedGoRoute<PostTravelStoryRoute>(path: '/post-travel-story')
class PostTravelStoryRoute extends GoRouteData with $PostTravelStoryRoute {
  const PostTravelStoryRoute({this.$extra});

  final SacredLocation? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      PostTravelStoryPage(destination: $extra);
}

@TypedGoRoute<SavedPlanDetailRoute>(path: '/saved-plan')
class SavedPlanDetailRoute extends GoRouteData with $SavedPlanDetailRoute {
  const SavedPlanDetailRoute({required this.$extra});

  final SavedTravelPlan $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      SavedPlanDetailPage(plan: $extra);
}

@TypedGoRoute<MapExploreRoute>(path: '/map-explore')
class MapExploreRoute extends GoRouteData with $MapExploreRoute {
  const MapExploreRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const MapExplorePage();
}

@TypedGoRoute<MapChatbotRoute>(path: '/mapchatbot')
class MapChatbotRoute extends GoRouteData with $MapChatbotRoute {
  const MapChatbotRoute({this.$extra});

  final String? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return MapGuide(initialMessage: $extra);
  }
}

@TypedGoRoute<SavedStoriesRoute>(path: '/saved-stories')
class SavedStoriesRoute extends GoRouteData with $SavedStoriesRoute {
  final List<Story> $extra;

  const SavedStoriesRoute({required this.$extra});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SavedStoriesPage(stories: $extra);
  }
}

@TypedGoRoute<LittleKrishnaIntroRoute>(path: '/little-krishna-intro')
class LittleKrishnaIntroRoute extends GoRouteData
    with $LittleKrishnaIntroRoute {
  const LittleKrishnaIntroRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LittleKrishnaIntroPage();
  }
}

@TypedGoRoute<ChatbotRoute>(path: '/chatbot')
class ChatbotRoute extends GoRouteData with $ChatbotRoute {
  const ChatbotRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ChatPage();
  }
}

@TypedGoRoute<AccountEditProfileRoute>(path: '/edit-profile-screen2')
class AccountEditProfileRoute extends GoRouteData
    with $AccountEditProfileRoute {
  const AccountEditProfileRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const EditProfile2Screen();
}

@TypedGoRoute<ProfileImageViewerRoute>(path: '/profile-image-viewer')
class ProfileImageViewerRoute extends GoRouteData
    with $ProfileImageViewerRoute {
  final String? imageUrl;
  final String? username;

  const ProfileImageViewerRoute({this.imageUrl, this.username});

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ProfileImageViewer(imageUrl: imageUrl, username: username);
}

@TypedGoRoute<DownloadedStoriesRoute>(path: '/downloaded-stories')
class DownloadedStoriesRoute extends GoRouteData with $DownloadedStoriesRoute {
  const DownloadedStoriesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const DownloadedStoriesPage();
}

@TypedGoRoute<FestivalDetailRoute>(path: '/festival-detail')
class FestivalDetailRoute extends GoRouteData with $FestivalDetailRoute {
  final HinduFestival $extra;

  const FestivalDetailRoute({required this.$extra});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FestivalDetailPage(festival: $extra);
  }
}

@TypedGoRoute<FestivalsListRoute>(path: '/festivals')
class FestivalsListRoute extends GoRouteData with $FestivalsListRoute {
  const FestivalsListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const FestivalsListPage();
  }
}
