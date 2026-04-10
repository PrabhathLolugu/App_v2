import 'package:flutter/material.dart';
import 'package:myitihas/features/social/presentation/pages/home_feed_screen/post_card_widget.dart';
import 'package:myitihas/utils/constants.dart';
import 'package:sizer/sizer.dart';

class HomeFeedScreenInitialPage extends StatefulWidget {
  const HomeFeedScreenInitialPage({super.key});

  @override
  State<HomeFeedScreenInitialPage> createState() =>
      _HomeFeedScreenInitialPageState();
}

class _HomeFeedScreenInitialPageState extends State<HomeFeedScreenInitialPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _isRefreshing = false;

  final List<Map<String, dynamic>> _posts = [
    {
      "id": "1",
      "username": "sarah_wilson",
      "avatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_176e07230-1763293461602.png",
      "avatarSemanticLabel":
          "Profile photo of a woman with long blonde hair and blue eyes, wearing a white top",
      "timestamp": "2 hours ago",
      "images": [
        {
          "url": "https://images.unsplash.com/photo-1585159594019-fc0591603b28",
          "semanticLabel":
              "Mountain landscape with snow-capped peaks under a clear blue sky at sunset",
        },
      ],
      "likes": 1234,
      "isLiked": false,
      "isSaved": false,
      "caption": "Beautiful sunset at the mountains 🌄",
      "commentCount": 89,
    },
    {
      "id": "2",
      "username": "mike_johnson",
      "avatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1907e5900-1763296402708.png",
      "avatarSemanticLabel":
          "Profile photo of a man with short black hair and glasses, wearing a blue shirt",
      "timestamp": "5 hours ago",
      "images": [
        {
          "url": "https://images.unsplash.com/photo-1697898108745-bd718dcf41b2",
          "semanticLabel":
              "Gourmet pasta dish with fresh basil and tomato sauce on a white plate",
        },
      ],
      "likes": 892,
      "isLiked": true,
      "isSaved": false,
      "caption": "Homemade pasta night 🍝",
      "commentCount": 45,
    },
    {
      "id": "3",
      "username": "emma_davis",
      "avatar": "https://images.unsplash.com/photo-1583712614713-3a796fe7c696",
      "avatarSemanticLabel":
          "Profile photo of a woman with curly brown hair and green eyes, wearing a red dress",
      "timestamp": "8 hours ago",
      "images": [
        {
          "url": "https://images.unsplash.com/photo-1629955822542-7f10309b61b5",
          "semanticLabel":
              "Golden retriever dog sitting in a green park with a happy expression",
        },
        {
          "url": "https://images.unsplash.com/photo-1593828659120-4fbf50bb4eac",
          "semanticLabel":
              "Close-up of a white and brown puppy with blue eyes looking at the camera",
        },
      ],
      "likes": 2156,
      "isLiked": false,
      "isSaved": true,
      "caption": "My furry friends enjoying the park 🐕",
      "commentCount": 134,
    },
    {
      "id": "4",
      "username": "alex_brown",
      "avatar": "https://images.unsplash.com/photo-1539266705491-e7fa53d1e3ba",
      "avatarSemanticLabel":
          "Profile photo of a man with short blonde hair and a smile, wearing a gray hoodie",
      "timestamp": "12 hours ago",
      "images": [
        {
          "url": "https://images.unsplash.com/photo-1723474319200-ce9f705e419c",
          "semanticLabel":
              "Serene lake surrounded by pine trees with mountains in the background at dawn",
        },
      ],
      "likes": 3421,
      "isLiked": true,
      "isSaved": true,
      "caption": "Morning hike vibes 🏔️",
      "commentCount": 201,
    },
    {
      "id": "5",
      "username": "lisa_martinez",
      "avatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_176e07230-1763293461602.png",
      "avatarSemanticLabel":
          "Profile photo of a woman with long dark hair and brown eyes, wearing a black top",
      "timestamp": "1 day ago",
      "images": [
        {
          "url": "https://images.unsplash.com/photo-1657664118838-20257b71ce55",
          "semanticLabel":
              "Modern coffee shop interior with wooden tables and hanging plants",
        },
      ],
      "likes": 567,
      "isLiked": false,
      "isSaved": false,
      "caption": "New favorite coffee spot ☕",
      "commentCount": 32,
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading) {
        _loadMorePosts();
      }
    }
  }

  Future<void> _loadMorePosts() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _refreshFeed() async {
    if (_isRefreshing) return;

    setState(() => _isRefreshing = true);

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isRefreshing = false);
    }
  }

  void _toggleLike(String postId) {
    setState(() {
      final postIndex = _posts.indexWhere((post) => post["id"] == postId);
      if (postIndex != -1) {
        final post = _posts[postIndex];
        final isLiked = post["isLiked"] as bool;
        post["isLiked"] = !isLiked;
        post["likes"] = (post["likes"] as int) + (isLiked ? -1 : 1);
      }
    });
  }

  void _toggleSave(String postId) {
    setState(() {
      final postIndex = _posts.indexWhere((post) => post["id"] == postId);
      if (postIndex != -1) {
        final post = _posts[postIndex];
        post["isSaved"] = !(post["isSaved"] as bool);
      }
    });
  }

  void _navigateToPostDetail(String postId) {
    Navigator.of(context, rootNavigator: true).pushNamed('/post-detail-screen');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    DarkColors.accentPrimary.withValues(
                      alpha: 0.2,
                    ), // deep navy
                    DarkColors.accentSecondary.withValues(alpha: 0.1), // blue
                    DarkColors.accentSecondary.withValues(
                      alpha: 0.1,
                    ), // purple tou
                  ]
                : [
                    Colors.white, // white background
                    Colors.white, // blue
                    Colors.white,
                  ],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _refreshFeed,
          color: theme.colorScheme.primary,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Divider(
                  height: 1,
                  thickness: 0.5,
                  color: theme.dividerColor,
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.only(top: 1.h),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (index < _posts.length) {
                      return PostCardWidget(
                        post: _posts[index],
                        onLike: () =>
                            _toggleLike(_posts[index]["id"] as String),
                        onSave: () =>
                            _toggleSave(_posts[index]["id"] as String),
                        onComment: () => _navigateToPostDetail(
                          _posts[index]["id"] as String,
                        ),
                        onShare: () {},
                      );
                    } else if (_isLoading) {
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          color: theme.colorScheme.onSurface,
                        ),
                      );
                    }
                    return null;
                  }, childCount: _posts.length + (_isLoading ? 1 : 0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
