// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $splashRoute,
  $homeRoute,
  $discoverRoute,
  $welcomeRoute,
  $loginRoute,
  $signupRoute,
  $resetPasswordRoute,
  $accountDeletedRoute,
  $newChatRoute,
  $chatRequestsRoute,
  $newGroupRoute,
  $createGroupRoute,
  $newContactRoute,
  $chatDetailRoute,
  $profileDetailRoute,
  $groupProfileRoute,
  $editGroupRoute,
  $addGroupMembersRoute,
  $joinGroupViaLinkRoute,
  $settingsRoute,
  $editProfileRoute,
  $socialFeedRoute,
  $postDetailRoute,
  $createPostRoute,
  $profileRoute,
  $followersRoute,
  $followingRoute,
  $notificationRoute,
  $chatListRoute,
  $storyGeneratorRoute,
  $activityHistoryRoute,
  $intentChoiceRoute,
  $akhandaBharataMapRoute,
  $siteDetailRoute,
  $nearbyPlacesRoute,
  $indianFabricsMapRoute,
  $fabricHubDetailRoute,
  $fabricShopRoute,
  $indianCraftsMapRoute,
  $craftHubDetailRoute,
  $craftShopRoute,
  $classicalArtMapRoute,
  $classicalDanceMapRoute,
  $culturalItemDetailRoute,
  $indianFoodsMapRoute,
  $foodItemDetailRoute,
  $forumCommunityRoute,
  $myJourneyRoute,
  $planRoute,
  $postTravelStoryRoute,
  $savedPlanDetailRoute,
  $mapExploreRoute,
  $mapChatbotRoute,
  $savedStoriesRoute,
  $littleKrishnaIntroRoute,
  $chatbotRoute,
  $accountEditProfileRoute,
  $profileImageViewerRoute,
  $downloadedStoriesRoute,
  $festivalDetailRoute,
  $festivalsListRoute,
];

RouteBase get $splashRoute =>
    GoRouteData.$route(path: '/', factory: $SplashRoute._fromState);

mixin $SplashRoute on GoRouteData {
  static SplashRoute _fromState(GoRouterState state) => const SplashRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $homeRoute => GoRouteData.$route(
  path: '/home',
  factory: $HomeRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'stories',
      factory: $StoriesRoute._fromState,
      routes: [
        GoRouteData.$route(path: ':id', factory: $StoryDetailRoute._fromState),
      ],
    ),
  ],
);

mixin $HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  @override
  String get location => GoRouteData.$location('/home');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $StoriesRoute on GoRouteData {
  static StoriesRoute _fromState(GoRouterState state) => const StoriesRoute();

  @override
  String get location => GoRouteData.$location('/home/stories');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $StoryDetailRoute on GoRouteData {
  static StoryDetailRoute _fromState(GoRouterState state) =>
      StoryDetailRoute(id: state.pathParameters['id']!);

  StoryDetailRoute get _self => this as StoryDetailRoute;

  @override
  String get location =>
      GoRouteData.$location('/home/stories/${Uri.encodeComponent(_self.id)}');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $discoverRoute =>
    GoRouteData.$route(path: '/discover', factory: $DiscoverRoute._fromState);

mixin $DiscoverRoute on GoRouteData {
  static DiscoverRoute _fromState(GoRouterState state) => const DiscoverRoute();

  @override
  String get location => GoRouteData.$location('/discover');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $welcomeRoute =>
    GoRouteData.$route(path: '/welcome', factory: $WelcomeRoute._fromState);

mixin $WelcomeRoute on GoRouteData {
  static WelcomeRoute _fromState(GoRouterState state) => const WelcomeRoute();

  @override
  String get location => GoRouteData.$location('/welcome');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $loginRoute =>
    GoRouteData.$route(path: '/login', factory: $LoginRoute._fromState);

mixin $LoginRoute on GoRouteData {
  static LoginRoute _fromState(GoRouterState state) => const LoginRoute();

  @override
  String get location => GoRouteData.$location('/login');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $signupRoute =>
    GoRouteData.$route(path: '/signup', factory: $SignupRoute._fromState);

mixin $SignupRoute on GoRouteData {
  static SignupRoute _fromState(GoRouterState state) => const SignupRoute();

  @override
  String get location => GoRouteData.$location('/signup');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $resetPasswordRoute => GoRouteData.$route(
  path: '/reset-password',
  factory: $ResetPasswordRoute._fromState,
);

mixin $ResetPasswordRoute on GoRouteData {
  static ResetPasswordRoute _fromState(GoRouterState state) =>
      const ResetPasswordRoute();

  @override
  String get location => GoRouteData.$location('/reset-password');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $accountDeletedRoute => GoRouteData.$route(
  path: '/account-deleted',
  factory: $AccountDeletedRoute._fromState,
);

mixin $AccountDeletedRoute on GoRouteData {
  static AccountDeletedRoute _fromState(GoRouterState state) =>
      const AccountDeletedRoute();

  @override
  String get location => GoRouteData.$location('/account-deleted');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $newChatRoute =>
    GoRouteData.$route(path: '/new-chat', factory: $NewChatRoute._fromState);

mixin $NewChatRoute on GoRouteData {
  static NewChatRoute _fromState(GoRouterState state) => const NewChatRoute();

  @override
  String get location => GoRouteData.$location('/new-chat');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $chatRequestsRoute => GoRouteData.$route(
  path: '/chat-requests',
  factory: $ChatRequestsRoute._fromState,
);

mixin $ChatRequestsRoute on GoRouteData {
  static ChatRequestsRoute _fromState(GoRouterState state) =>
      const ChatRequestsRoute();

  @override
  String get location => GoRouteData.$location('/chat-requests');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $newGroupRoute =>
    GoRouteData.$route(path: '/new-group', factory: $NewGroupRoute._fromState);

mixin $NewGroupRoute on GoRouteData {
  static NewGroupRoute _fromState(GoRouterState state) => const NewGroupRoute();

  @override
  String get location => GoRouteData.$location('/new-group');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $createGroupRoute => GoRouteData.$route(
  path: '/create-group',
  factory: $CreateGroupRoute._fromState,
);

mixin $CreateGroupRoute on GoRouteData {
  static CreateGroupRoute _fromState(GoRouterState state) =>
      CreateGroupRoute($extra: state.extra as List<Map<String, dynamic>>);

  CreateGroupRoute get _self => this as CreateGroupRoute;

  @override
  String get location => GoRouteData.$location('/create-group');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $newContactRoute => GoRouteData.$route(
  path: '/new-contact',
  factory: $NewContactRoute._fromState,
);

mixin $NewContactRoute on GoRouteData {
  static NewContactRoute _fromState(GoRouterState state) =>
      const NewContactRoute();

  @override
  String get location => GoRouteData.$location('/new-contact');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $chatDetailRoute => GoRouteData.$route(
  path: '/chat_detail',
  factory: $ChatDetailRoute._fromState,
);

mixin $ChatDetailRoute on GoRouteData {
  static ChatDetailRoute _fromState(GoRouterState state) =>
      ChatDetailRoute($extra: state.extra as Map<String, dynamic>);

  ChatDetailRoute get _self => this as ChatDetailRoute;

  @override
  String get location => GoRouteData.$location('/chat_detail');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $profileDetailRoute => GoRouteData.$route(
  path: '/profile_detail',
  factory: $ProfileDetailRoute._fromState,
);

mixin $ProfileDetailRoute on GoRouteData {
  static ProfileDetailRoute _fromState(GoRouterState state) =>
      ProfileDetailRoute($extra: state.extra as Map<String, dynamic>);

  ProfileDetailRoute get _self => this as ProfileDetailRoute;

  @override
  String get location => GoRouteData.$location('/profile_detail');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $groupProfileRoute => GoRouteData.$route(
  path: '/group_profile',
  factory: $GroupProfileRoute._fromState,
);

mixin $GroupProfileRoute on GoRouteData {
  static GroupProfileRoute _fromState(GoRouterState state) =>
      GroupProfileRoute($extra: state.extra as Map<String, dynamic>);

  GroupProfileRoute get _self => this as GroupProfileRoute;

  @override
  String get location => GoRouteData.$location('/group_profile');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $editGroupRoute => GoRouteData.$route(
  path: '/edit_group',
  factory: $EditGroupRoute._fromState,
);

mixin $EditGroupRoute on GoRouteData {
  static EditGroupRoute _fromState(GoRouterState state) =>
      EditGroupRoute($extra: state.extra as Map<String, dynamic>);

  EditGroupRoute get _self => this as EditGroupRoute;

  @override
  String get location => GoRouteData.$location('/edit_group');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $addGroupMembersRoute => GoRouteData.$route(
  path: '/add_group_members',
  factory: $AddGroupMembersRoute._fromState,
);

mixin $AddGroupMembersRoute on GoRouteData {
  static AddGroupMembersRoute _fromState(GoRouterState state) =>
      AddGroupMembersRoute($extra: state.extra as Map<String, dynamic>);

  AddGroupMembersRoute get _self => this as AddGroupMembersRoute;

  @override
  String get location => GoRouteData.$location('/add_group_members');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $joinGroupViaLinkRoute => GoRouteData.$route(
  path: '/join-group-via-link/:code',
  factory: $JoinGroupViaLinkRoute._fromState,
);

mixin $JoinGroupViaLinkRoute on GoRouteData {
  static JoinGroupViaLinkRoute _fromState(GoRouterState state) =>
      JoinGroupViaLinkRoute(code: state.pathParameters['code']!);

  JoinGroupViaLinkRoute get _self => this as JoinGroupViaLinkRoute;

  @override
  String get location => GoRouteData.$location(
    '/join-group-via-link/${Uri.encodeComponent(_self.code)}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $settingsRoute => GoRouteData.$route(
  path: '/settings',
  factory: $SettingsRoute._fromState,
  routes: [
    GoRouteData.$route(path: 'cache', factory: $CacheSettingsRoute._fromState),
    GoRouteData.$route(
      path: 'blocked-users',
      factory: $BlockedUsersRoute._fromState,
    ),
  ],
);

mixin $SettingsRoute on GoRouteData {
  static SettingsRoute _fromState(GoRouterState state) => const SettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CacheSettingsRoute on GoRouteData {
  static CacheSettingsRoute _fromState(GoRouterState state) =>
      const CacheSettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings/cache');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $BlockedUsersRoute on GoRouteData {
  static BlockedUsersRoute _fromState(GoRouterState state) =>
      const BlockedUsersRoute();

  @override
  String get location => GoRouteData.$location('/settings/blocked-users');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $editProfileRoute => GoRouteData.$route(
  path: '/edit-profile/:userId',
  factory: $EditProfileRoute._fromState,
);

mixin $EditProfileRoute on GoRouteData {
  static EditProfileRoute _fromState(GoRouterState state) => EditProfileRoute(
    userId: state.pathParameters['userId']!,
    displayName: state.uri.queryParameters['display-name']!,
    bio: state.uri.queryParameters['bio'] ?? '',
    avatarUrl: state.uri.queryParameters['avatar-url'] ?? '',
  );

  EditProfileRoute get _self => this as EditProfileRoute;

  @override
  String get location => GoRouteData.$location(
    '/edit-profile/${Uri.encodeComponent(_self.userId)}',
    queryParams: {
      'display-name': _self.displayName,
      if (_self.bio != '') 'bio': _self.bio,
      if (_self.avatarUrl != '') 'avatar-url': _self.avatarUrl,
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $socialFeedRoute => GoRouteData.$route(
  path: '/social-feed',
  factory: $SocialFeedRoute._fromState,
);

mixin $SocialFeedRoute on GoRouteData {
  static SocialFeedRoute _fromState(GoRouterState state) =>
      const SocialFeedRoute();

  @override
  String get location => GoRouteData.$location('/social-feed');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $postDetailRoute => GoRouteData.$route(
  path: '/post/:postId',
  factory: $PostDetailRoute._fromState,
);

mixin $PostDetailRoute on GoRouteData {
  static PostDetailRoute _fromState(GoRouterState state) => PostDetailRoute(
    postId: state.pathParameters['postId']!,
    postType: state.uri.queryParameters['post-type'] ?? 'image',
  );

  PostDetailRoute get _self => this as PostDetailRoute;

  @override
  String get location => GoRouteData.$location(
    '/post/${Uri.encodeComponent(_self.postId)}',
    queryParams: {if (_self.postType != 'image') 'post-type': _self.postType},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $createPostRoute => GoRouteData.$route(
  path: '/create-post',
  factory: $CreatePostRoute._fromState,
);

mixin $CreatePostRoute on GoRouteData {
  static CreatePostRoute _fromState(GoRouterState state) =>
      const CreatePostRoute();

  @override
  String get location => GoRouteData.$location('/create-post');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $profileRoute => GoRouteData.$route(
  path: '/profile/:userId',
  factory: $ProfileRoute._fromState,
);

mixin $ProfileRoute on GoRouteData {
  static ProfileRoute _fromState(GoRouterState state) =>
      ProfileRoute(userId: state.pathParameters['userId']!);

  ProfileRoute get _self => this as ProfileRoute;

  @override
  String get location =>
      GoRouteData.$location('/profile/${Uri.encodeComponent(_self.userId)}');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $followersRoute => GoRouteData.$route(
  path: '/followers/:userId',
  factory: $FollowersRoute._fromState,
);

mixin $FollowersRoute on GoRouteData {
  static FollowersRoute _fromState(GoRouterState state) =>
      FollowersRoute(userId: state.pathParameters['userId']!);

  FollowersRoute get _self => this as FollowersRoute;

  @override
  String get location =>
      GoRouteData.$location('/followers/${Uri.encodeComponent(_self.userId)}');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $followingRoute => GoRouteData.$route(
  path: '/following/:userId',
  factory: $FollowingRoute._fromState,
);

mixin $FollowingRoute on GoRouteData {
  static FollowingRoute _fromState(GoRouterState state) =>
      FollowingRoute(userId: state.pathParameters['userId']!);

  FollowingRoute get _self => this as FollowingRoute;

  @override
  String get location =>
      GoRouteData.$location('/following/${Uri.encodeComponent(_self.userId)}');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $notificationRoute => GoRouteData.$route(
  path: '/notifications',
  factory: $NotificationRoute._fromState,
);

mixin $NotificationRoute on GoRouteData {
  static NotificationRoute _fromState(GoRouterState state) =>
      const NotificationRoute();

  @override
  String get location => GoRouteData.$location('/notifications');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $chatListRoute => GoRouteData.$route(
  path: '/chat',
  factory: $ChatListRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: ':conversationId',
      factory: $ChatViewRoute._fromState,
    ),
  ],
);

mixin $ChatListRoute on GoRouteData {
  static ChatListRoute _fromState(GoRouterState state) => const ChatListRoute();

  @override
  String get location => GoRouteData.$location('/chat');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ChatViewRoute on GoRouteData {
  static ChatViewRoute _fromState(GoRouterState state) =>
      ChatViewRoute(conversationId: state.pathParameters['conversationId']!);

  ChatViewRoute get _self => this as ChatViewRoute;

  @override
  String get location => GoRouteData.$location(
    '/chat/${Uri.encodeComponent(_self.conversationId)}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $storyGeneratorRoute => GoRouteData.$route(
  path: '/story-generator',
  factory: $StoryGeneratorRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'result',
      factory: $GeneratedStoryResultRoute._fromState,
    ),
    GoRouteData.$route(
      path: ':storyId',
      factory: $GeneratedStoryByIdRoute._fromState,
    ),
  ],
);

mixin $StoryGeneratorRoute on GoRouteData {
  static StoryGeneratorRoute _fromState(GoRouterState state) =>
      StoryGeneratorRoute(
        initialPrompt: state.uri.queryParameters['initial-prompt'],
        initialLanguageCode: state.uri.queryParameters['initial-language-code'],
      );

  StoryGeneratorRoute get _self => this as StoryGeneratorRoute;

  @override
  String get location => GoRouteData.$location(
    '/story-generator',
    queryParams: {
      if (_self.initialPrompt != null) 'initial-prompt': _self.initialPrompt,
      if (_self.initialLanguageCode != null)
        'initial-language-code': _self.initialLanguageCode,
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $GeneratedStoryResultRoute on GoRouteData {
  static GeneratedStoryResultRoute _fromState(GoRouterState state) =>
      GeneratedStoryResultRoute($extra: state.extra as Story);

  GeneratedStoryResultRoute get _self => this as GeneratedStoryResultRoute;

  @override
  String get location => GoRouteData.$location('/story-generator/result');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

mixin $GeneratedStoryByIdRoute on GoRouteData {
  static GeneratedStoryByIdRoute _fromState(GoRouterState state) =>
      GeneratedStoryByIdRoute(storyId: state.pathParameters['storyId']!);

  GeneratedStoryByIdRoute get _self => this as GeneratedStoryByIdRoute;

  @override
  String get location => GoRouteData.$location(
    '/story-generator/${Uri.encodeComponent(_self.storyId)}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $activityHistoryRoute => GoRouteData.$route(
  path: '/activity',
  factory: $ActivityHistoryRoute._fromState,
);

mixin $ActivityHistoryRoute on GoRouteData {
  static ActivityHistoryRoute _fromState(GoRouterState state) =>
      const ActivityHistoryRoute();

  @override
  String get location => GoRouteData.$location('/activity');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $intentChoiceRoute => GoRouteData.$route(
  path: '/intent-choice',
  factory: $IntentChoiceRoute._fromState,
);

mixin $IntentChoiceRoute on GoRouteData {
  static IntentChoiceRoute _fromState(GoRouterState state) =>
      const IntentChoiceRoute();

  @override
  String get location => GoRouteData.$location('/intent-choice');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $akhandaBharataMapRoute => GoRouteData.$route(
  path: '/akhanda-bharata-map',
  factory: $AkhandaBharataMapRoute._fromState,
);

mixin $AkhandaBharataMapRoute on GoRouteData {
  static AkhandaBharataMapRoute _fromState(GoRouterState state) =>
      AkhandaBharataMapRoute($extra: state.extra as List<String>?);

  AkhandaBharataMapRoute get _self => this as AkhandaBharataMapRoute;

  @override
  String get location => GoRouteData.$location('/akhanda-bharata-map');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $siteDetailRoute => GoRouteData.$route(
  path: '/site-detail',
  factory: $SiteDetailRoute._fromState,
);

mixin $SiteDetailRoute on GoRouteData {
  static SiteDetailRoute _fromState(GoRouterState state) =>
      SiteDetailRoute($extra: state.extra as SacredLocation);

  SiteDetailRoute get _self => this as SiteDetailRoute;

  @override
  String get location => GoRouteData.$location('/site-detail');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $nearbyPlacesRoute => GoRouteData.$route(
  path: '/nearby-places',
  factory: $NearbyPlacesRoute._fromState,
);

mixin $NearbyPlacesRoute on GoRouteData {
  static NearbyPlacesRoute _fromState(GoRouterState state) =>
      NearbyPlacesRoute($extra: state.extra as SacredLocation);

  NearbyPlacesRoute get _self => this as NearbyPlacesRoute;

  @override
  String get location => GoRouteData.$location('/nearby-places');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $indianFabricsMapRoute => GoRouteData.$route(
  path: '/indian-fabrics-map',
  factory: $IndianFabricsMapRoute._fromState,
);

mixin $IndianFabricsMapRoute on GoRouteData {
  static IndianFabricsMapRoute _fromState(GoRouterState state) =>
      const IndianFabricsMapRoute();

  @override
  String get location => GoRouteData.$location('/indian-fabrics-map');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $fabricHubDetailRoute => GoRouteData.$route(
  path: '/fabric-hub-detail',
  factory: $FabricHubDetailRoute._fromState,
);

mixin $FabricHubDetailRoute on GoRouteData {
  static FabricHubDetailRoute _fromState(GoRouterState state) =>
      FabricHubDetailRoute($extra: state.extra as FabricHub);

  FabricHubDetailRoute get _self => this as FabricHubDetailRoute;

  @override
  String get location => GoRouteData.$location('/fabric-hub-detail');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $fabricShopRoute => GoRouteData.$route(
  path: '/fabric-shop',
  factory: $FabricShopRoute._fromState,
);

mixin $FabricShopRoute on GoRouteData {
  static FabricShopRoute _fromState(GoRouterState state) =>
      FabricShopRoute($extra: state.extra as FabricHub);

  FabricShopRoute get _self => this as FabricShopRoute;

  @override
  String get location => GoRouteData.$location('/fabric-shop');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $indianCraftsMapRoute => GoRouteData.$route(
  path: '/indian-crafts-map',
  factory: $IndianCraftsMapRoute._fromState,
);

mixin $IndianCraftsMapRoute on GoRouteData {
  static IndianCraftsMapRoute _fromState(GoRouterState state) =>
      const IndianCraftsMapRoute();

  @override
  String get location => GoRouteData.$location('/indian-crafts-map');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $craftHubDetailRoute => GoRouteData.$route(
  path: '/craft-hub-detail',
  factory: $CraftHubDetailRoute._fromState,
);

mixin $CraftHubDetailRoute on GoRouteData {
  static CraftHubDetailRoute _fromState(GoRouterState state) =>
      CraftHubDetailRoute($extra: state.extra as CraftHub);

  CraftHubDetailRoute get _self => this as CraftHubDetailRoute;

  @override
  String get location => GoRouteData.$location('/craft-hub-detail');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $craftShopRoute => GoRouteData.$route(
  path: '/craft-shop',
  factory: $CraftShopRoute._fromState,
);

mixin $CraftShopRoute on GoRouteData {
  static CraftShopRoute _fromState(GoRouterState state) =>
      CraftShopRoute($extra: state.extra as CraftHub);

  CraftShopRoute get _self => this as CraftShopRoute;

  @override
  String get location => GoRouteData.$location('/craft-shop');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $classicalArtMapRoute => GoRouteData.$route(
  path: '/classical-art-map',
  factory: $ClassicalArtMapRoute._fromState,
);

mixin $ClassicalArtMapRoute on GoRouteData {
  static ClassicalArtMapRoute _fromState(GoRouterState state) =>
      const ClassicalArtMapRoute();

  @override
  String get location => GoRouteData.$location('/classical-art-map');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $classicalDanceMapRoute => GoRouteData.$route(
  path: '/classical-dance-map',
  factory: $ClassicalDanceMapRoute._fromState,
);

mixin $ClassicalDanceMapRoute on GoRouteData {
  static ClassicalDanceMapRoute _fromState(GoRouterState state) =>
      const ClassicalDanceMapRoute();

  @override
  String get location => GoRouteData.$location('/classical-dance-map');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $culturalItemDetailRoute => GoRouteData.$route(
  path: '/cultural-item-detail',
  factory: $CulturalItemDetailRoute._fromState,
);

mixin $CulturalItemDetailRoute on GoRouteData {
  static CulturalItemDetailRoute _fromState(GoRouterState state) =>
      CulturalItemDetailRoute($extra: state.extra as CulturalItemDetailPayload);

  CulturalItemDetailRoute get _self => this as CulturalItemDetailRoute;

  @override
  String get location => GoRouteData.$location('/cultural-item-detail');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $indianFoodsMapRoute => GoRouteData.$route(
  path: '/indian-foods-map',
  factory: $IndianFoodsMapRoute._fromState,
);

mixin $IndianFoodsMapRoute on GoRouteData {
  static IndianFoodsMapRoute _fromState(GoRouterState state) =>
      const IndianFoodsMapRoute();

  @override
  String get location => GoRouteData.$location('/indian-foods-map');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $foodItemDetailRoute => GoRouteData.$route(
  path: '/food-item-detail',
  factory: $FoodItemDetailRoute._fromState,
);

mixin $FoodItemDetailRoute on GoRouteData {
  static FoodItemDetailRoute _fromState(GoRouterState state) =>
      FoodItemDetailRoute($extra: state.extra as FoodItemDetailPayload);

  FoodItemDetailRoute get _self => this as FoodItemDetailRoute;

  @override
  String get location => GoRouteData.$location('/food-item-detail');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $forumCommunityRoute => GoRouteData.$route(
  path: '/forum-community/:siteId',
  factory: $ForumCommunityRoute._fromState,
);

mixin $ForumCommunityRoute on GoRouteData {
  static ForumCommunityRoute _fromState(GoRouterState state) =>
      ForumCommunityRoute(
        siteId: state.pathParameters['siteId']!,
        $extra: state.extra as ForumDiscussionLaunchContext?,
      );

  ForumCommunityRoute get _self => this as ForumCommunityRoute;

  @override
  String get location => GoRouteData.$location(
    '/forum-community/${Uri.encodeComponent(_self.siteId)}',
  );

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $myJourneyRoute => GoRouteData.$route(
  path: '/my-journey',
  factory: $MyJourneyRoute._fromState,
);

mixin $MyJourneyRoute on GoRouteData {
  static MyJourneyRoute _fromState(GoRouterState state) =>
      const MyJourneyRoute();

  @override
  String get location => GoRouteData.$location('/my-journey');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $planRoute =>
    GoRouteData.$route(path: '/plan', factory: $PlanRoute._fromState);

mixin $PlanRoute on GoRouteData {
  static PlanRoute _fromState(GoRouterState state) =>
      PlanRoute($extra: state.extra as SacredLocation?);

  PlanRoute get _self => this as PlanRoute;

  @override
  String get location => GoRouteData.$location('/plan');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $postTravelStoryRoute => GoRouteData.$route(
  path: '/post-travel-story',
  factory: $PostTravelStoryRoute._fromState,
);

mixin $PostTravelStoryRoute on GoRouteData {
  static PostTravelStoryRoute _fromState(GoRouterState state) =>
      PostTravelStoryRoute($extra: state.extra as SacredLocation?);

  PostTravelStoryRoute get _self => this as PostTravelStoryRoute;

  @override
  String get location => GoRouteData.$location('/post-travel-story');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $savedPlanDetailRoute => GoRouteData.$route(
  path: '/saved-plan',
  factory: $SavedPlanDetailRoute._fromState,
);

mixin $SavedPlanDetailRoute on GoRouteData {
  static SavedPlanDetailRoute _fromState(GoRouterState state) =>
      SavedPlanDetailRoute($extra: state.extra as SavedTravelPlan);

  SavedPlanDetailRoute get _self => this as SavedPlanDetailRoute;

  @override
  String get location => GoRouteData.$location('/saved-plan');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $mapExploreRoute => GoRouteData.$route(
  path: '/map-explore',
  factory: $MapExploreRoute._fromState,
);

mixin $MapExploreRoute on GoRouteData {
  static MapExploreRoute _fromState(GoRouterState state) =>
      const MapExploreRoute();

  @override
  String get location => GoRouteData.$location('/map-explore');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mapChatbotRoute => GoRouteData.$route(
  path: '/mapchatbot',
  factory: $MapChatbotRoute._fromState,
);

mixin $MapChatbotRoute on GoRouteData {
  static MapChatbotRoute _fromState(GoRouterState state) =>
      MapChatbotRoute($extra: state.extra as String?);

  MapChatbotRoute get _self => this as MapChatbotRoute;

  @override
  String get location => GoRouteData.$location('/mapchatbot');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $savedStoriesRoute => GoRouteData.$route(
  path: '/saved-stories',
  factory: $SavedStoriesRoute._fromState,
);

mixin $SavedStoriesRoute on GoRouteData {
  static SavedStoriesRoute _fromState(GoRouterState state) =>
      SavedStoriesRoute($extra: state.extra as List<Story>);

  SavedStoriesRoute get _self => this as SavedStoriesRoute;

  @override
  String get location => GoRouteData.$location('/saved-stories');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $littleKrishnaIntroRoute => GoRouteData.$route(
  path: '/little-krishna-intro',
  factory: $LittleKrishnaIntroRoute._fromState,
);

mixin $LittleKrishnaIntroRoute on GoRouteData {
  static LittleKrishnaIntroRoute _fromState(GoRouterState state) =>
      const LittleKrishnaIntroRoute();

  @override
  String get location => GoRouteData.$location('/little-krishna-intro');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $chatbotRoute =>
    GoRouteData.$route(path: '/chatbot', factory: $ChatbotRoute._fromState);

mixin $ChatbotRoute on GoRouteData {
  static ChatbotRoute _fromState(GoRouterState state) => const ChatbotRoute();

  @override
  String get location => GoRouteData.$location('/chatbot');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $accountEditProfileRoute => GoRouteData.$route(
  path: '/edit-profile-screen2',
  factory: $AccountEditProfileRoute._fromState,
);

mixin $AccountEditProfileRoute on GoRouteData {
  static AccountEditProfileRoute _fromState(GoRouterState state) =>
      const AccountEditProfileRoute();

  @override
  String get location => GoRouteData.$location('/edit-profile-screen2');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $profileImageViewerRoute => GoRouteData.$route(
  path: '/profile-image-viewer',
  factory: $ProfileImageViewerRoute._fromState,
);

mixin $ProfileImageViewerRoute on GoRouteData {
  static ProfileImageViewerRoute _fromState(GoRouterState state) =>
      ProfileImageViewerRoute(
        imageUrl: state.uri.queryParameters['image-url'],
        username: state.uri.queryParameters['username'],
      );

  ProfileImageViewerRoute get _self => this as ProfileImageViewerRoute;

  @override
  String get location => GoRouteData.$location(
    '/profile-image-viewer',
    queryParams: {
      if (_self.imageUrl != null) 'image-url': _self.imageUrl,
      if (_self.username != null) 'username': _self.username,
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $downloadedStoriesRoute => GoRouteData.$route(
  path: '/downloaded-stories',
  factory: $DownloadedStoriesRoute._fromState,
);

mixin $DownloadedStoriesRoute on GoRouteData {
  static DownloadedStoriesRoute _fromState(GoRouterState state) =>
      const DownloadedStoriesRoute();

  @override
  String get location => GoRouteData.$location('/downloaded-stories');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $festivalDetailRoute => GoRouteData.$route(
  path: '/festival-detail',
  factory: $FestivalDetailRoute._fromState,
);

mixin $FestivalDetailRoute on GoRouteData {
  static FestivalDetailRoute _fromState(GoRouterState state) =>
      FestivalDetailRoute($extra: state.extra as HinduFestival);

  FestivalDetailRoute get _self => this as FestivalDetailRoute;

  @override
  String get location => GoRouteData.$location('/festival-detail');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $festivalsListRoute => GoRouteData.$route(
  path: '/festivals',
  factory: $FestivalsListRoute._fromState,
);

mixin $FestivalsListRoute on GoRouteData {
  static FestivalsListRoute _fromState(GoRouterState state) =>
      const FestivalsListRoute();

  @override
  String get location => GoRouteData.$location('/festivals');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
