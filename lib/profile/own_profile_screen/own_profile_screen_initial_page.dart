import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/pages/map2/widgets/custom_icon_widget.dart';
import 'package:myitihas/utils/constants.dart';
import 'package:sizer/sizer.dart';

import './widgets/profile_action_buttons_widget.dart';
import './widgets/profile_bio_widget.dart';
import './widgets/profile_content_grid_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/profile_stats_widget.dart';

class OwnProfileScreenInitialPage extends StatefulWidget {
  const OwnProfileScreenInitialPage({super.key});

  @override
  State<OwnProfileScreenInitialPage> createState() =>
      _OwnProfileScreenInitialPageState();
}

class _OwnProfileScreenInitialPageState
    extends State<OwnProfileScreenInitialPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  late AnimationController _introController;
  late Animation<Offset> _cardSlideAnimation;
  late Animation<double> _cardFadeAnimation;

  final Map<String, dynamic> _profileData = {
    "username": "sarah_johnson",
    "displayName": "Sarah Johnson",
    "profileImage":
        "https://img.rocket.new/generatedImages/rocket_gen_img_103b528db-1763293982935.png",
    "profileImageSemanticLabel":
        "Professional portrait of a woman with long brown hair wearing a white blouse against a neutral background",
    "bio":
        "Digital creator & lifestyle enthusiast 🌟\nSharing moments that matter ✨\nLos Angeles, CA 📍",
    "followers": 12500,
    "following": 892,
    "posts": 347,
    "isVerified": true,
    "contentItems": [
      {
        "id": 1,
        "type": "photo",
        "thumbnail":
            "https://images.unsplash.com/photo-1727334579394-85c303142945",
        "semanticLabel":
            "Scenic mountain landscape with snow-capped peaks under blue sky with white clouds",
        "likes": 1234,
        "comments": 89,
        "images": [
          "https://images.unsplash.com/photo-1727334579394-85c303142945",
          "https://images.unsplash.com/photo-1726739652123-85c303142945",
          "https://images.unsplash.com/photo-1725739652123-85c303142945",
          "https://images.unsplash.com/photo-1724739652123-85c303142945",
          "https://images.unsplash.com/photo-1723739652123-85c303142945",
        ],
      },
      {
        "id": 2,
        "type": "photo",
        "thumbnail":
            "https://images.unsplash.com/photo-1621263552350-c2115d829c82",
        "semanticLabel":
            "Tranquil mountain lake reflecting surrounding peaks with clear blue water",
        "likes": 2156,
        "comments": 145,
        "images": [
          "https://images.unsplash.com/photo-1621263552350-c2115d829c82",
          "https://images.unsplash.com/photo-1621263552350-c2115d829c83",
        ],
      },
      {
        "id": 3,
        "type": "video",
        "thumbnail":
            "https://images.unsplash.com/photo-1616736594913-b21e6d80a26d",
        "videoUrl": "https://samplelib.com/lib/preview/mp4/sample-5s.mp4",
        "semanticLabel":
            "Coastal sunset scene with orange and pink sky over ocean waves",
        "likes": 3421,
        "comments": 234,
      },
      {
        "id": 4,
        "type": "photo",
        "thumbnail":
            "https://images.unsplash.com/photo-1723459640576-560af9d58f55",
        "semanticLabel":
            "Tropical beach with turquoise water and palm trees swaying in breeze",
        "likes": 1876,
        "comments": 112,
      },
      {
        "id": 5,
        "type": "photo",
        "thumbnail":
            "https://images.unsplash.com/photo-1653522427232-28edac49d13b",
        "semanticLabel":
            "Misty forest path with tall trees and morning fog creating atmospheric scene",
        "likes": 2543,
        "comments": 178,
      },
      {
        "id": 6,
        "type": "video",
        "thumbnail":
            "https://images.unsplash.com/photo-1696247833485-bcd2014cbdb9",
        "videoUrl": "https://samplelib.com/lib/preview/mp4/sample-10s.mp4",
        "semanticLabel":
            "Desert landscape with rolling sand dunes under golden hour lighting",
        "likes": 1987,
        "comments": 156,
      },
      {
        "id": 7,
        "type": "photo",
        "thumbnail":
            "https://images.unsplash.com/photo-1599413143314-e1829bb4fd93",
        "semanticLabel":
            "Alpine meadow filled with wildflowers and mountain peaks in background",
        "likes": 3102,
        "comments": 201,
        "images": [
          "https://images.unsplash.com/photo-1599413143314-e1829bb4fd93",
          "https://images.unsplash.com/photo-1599413143314-e1829bb4fd94",
          "https://images.unsplash.com/photo-1599413143314-e1829bb4fd95",
        ],
      },
      {
        "id": 8,
        "type": "photo",
        "thumbnail":
            "https://images.unsplash.com/photo-1574877495507-dd907df6d918",
        "semanticLabel":
            "Dramatic waterfall cascading down rocky cliff surrounded by lush greenery",
        "likes": 2789,
        "comments": 189,
      },
      {
        "id": 9,
        "type": "photo",
        "thumbnail":
            "https://images.unsplash.com/photo-1671643095727-171b61a67880",
        "semanticLabel":
            "Vibrant autumn forest with colorful foliage in red, orange, and yellow tones",
        "likes": 2234,
        "comments": 167,
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _cardSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
          CurvedAnimation(parent: _introController, curve: Curves.easeOutCubic),
        );

    _cardFadeAnimation = CurvedAnimation(
      parent: _introController,
      curve: Curves.easeOut,
    );

    _introController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _introController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  void _navigateToSettings() {
    const AccountEditProfileRoute().push(context);
  }

  void _navigateToProfileImage() {
    const ProfileImageViewerRoute().push(context);
  }

  List<Map<String, dynamic>> _getFilteredContent() {
    final allContent = _profileData["contentItems"] as List;
    final currentTab = _tabController.index;

    switch (currentTab) {
      case 0: // Photos
        return allContent
            .where((item) => item["type"] == "photo")
            .toList()
            .cast<Map<String, dynamic>>();
      case 1: // Videos
        return allContent
            .where((item) => item["type"] == "video")
            .toList()
            .cast<Map<String, dynamic>>();
      case 2: // Thoughts
        return allContent
            .where((item) => item["type"] == "thought")
            .toList()
            .cast<Map<String, dynamic>>();
      case 3: // Shares
        return allContent
            .where((item) => item["type"] == "share")
            .toList()
            .cast<Map<String, dynamic>>();
      default:
        return allContent.cast<Map<String, dynamic>>();
    }
  }

  Widget _buildHeroHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final gradients = theme.extension<GradientExtension>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 7.h),
          // Greeting and Notification Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 0.5.h),
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        (gradients?.brandTextGradient ??
                                LinearGradient(
                                  colors: [
                                    colorScheme.primary,
                                    colorScheme.secondary,
                                  ],
                                ))
                            .createShader(bounds),
                    child: Text(
                      'Profile',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.5,
                        fontSize: 22.sp,
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              IconButton(
                icon: const Icon(Icons.person_search_rounded),
                onPressed: () {
                  const DiscoverRoute().push(context);
                },
                tooltip: 'Search Users',
              ),
              IconButton(
                icon: const Icon(Icons.settings_rounded),
                onPressed: () {
                  const SettingsRoute().push(context);
                },
                tooltip: 'Settings',
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    Color textColor = isDark ? DarkColors.textPrimary : LightColors.textPrimary;

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('My Profile'),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.person_search_rounded),
      //       onPressed: () {
      //         const DiscoverRoute().push(context);
      //       },
      //       tooltip: 'Search Users',
      //     ),
      //     IconButton(
      //       icon: const Icon(Icons.settings_rounded),
      //       onPressed: () {
      //         const SettingsRoute().push(context);
      //       },
      //       tooltip: 'Settings',
      //     ),
      //   ],
      // ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              // padding: EdgeInsets.only(bottom: 12.h),
              // width: double.infinity,
              // height: double.infinity,
              decoration: BoxDecoration(
                gradient:
                    theme
                        .extension<GradientExtension>()
                        ?.screenBackgroundGradient ??
                    LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.surface,
                        colorScheme.surfaceContainerHighest,
                      ],
                    ),
              ),
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _buildHeroHeader(context)),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 2.h,
                          horizontal: 4.w,
                        ),
                        child: FadeTransition(
                          opacity: _cardFadeAnimation,
                          child: SlideTransition(
                            position: _cardSlideAnimation,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 12,
                                  sigmaY: 12,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        theme
                                            .extension<GradientExtension>()
                                            ?.glassCardBackground ??
                                        (isDark
                                            ? Colors.black.withValues(
                                                alpha: 0.4,
                                              )
                                            : Colors.white.withValues(
                                                alpha: 0.4,
                                              )),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color:
                                          theme
                                              .extension<GradientExtension>()
                                              ?.glassCardBorder ??
                                          (isDark
                                              ? Colors.white.withValues(
                                                  alpha: 0.1,
                                                )
                                              : Colors.black.withValues(
                                                  alpha: 0.1,
                                                )),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: colorScheme.shadow.withValues(
                                          alpha: 0.1,
                                        ),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 3.h),
                                      ProfileHeaderWidget(
                                        profileImage:
                                            _profileData["profileImage"],
                                        profileImageSemanticLabel:
                                            _profileData["profileImageSemanticLabel"],
                                        displayName:
                                            _profileData["displayName"],
                                        isVerified: _profileData["isVerified"],
                                        onProfileImageTap:
                                            _navigateToProfileImage,
                                      ),
                                      SizedBox(height: 2.h),
                                      ProfileStatsWidget(
                                        posts: _profileData["posts"],
                                        followers: _profileData["followers"],
                                        following: _profileData["following"],
                                      ),
                                      SizedBox(height: 2.h),
                                      ProfileBioWidget(
                                        bio: _profileData["bio"],
                                      ),
                                      SizedBox(height: 2.h),
                                      ProfileActionButtonsWidget(
                                        onEditProfile: _navigateToSettings,
                                      ),
                                      SizedBox(height: 3.h),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverTabBarDelegate(
                        TabBar(
                          controller: _tabController,
                          isScrollable: false,
                          indicatorColor: theme.colorScheme.primary,
                          labelColor: theme.colorScheme.primary,
                          unselectedLabelColor: Colors.white.withValues(
                            alpha: 0.6,
                          ),
                          labelStyle: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          onTap: (index) => setState(() {}),
                          tabs: [
                            Tab(
                              icon: CustomIconWidget(
                                iconName: 'grid_on',
                                color: _tabController.index == 0
                                    ? theme.colorScheme.primary
                                    : isDark
                                    ? Colors.white.withValues(alpha: 0.6)
                                    : Colors.black.withValues(alpha: 0.6),
                                size: 24,
                              ),
                              child: Text(
                                Translations.of(context).feed.tabs.images,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  color: _tabController.index == 0
                                      ? theme.colorScheme.primary
                                      : textColor.withValues(alpha: 0.7),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Tab(
                              icon: CustomIconWidget(
                                iconName: 'videocam',
                                color: _tabController.index == 1
                                    ? theme.colorScheme.primary
                                    : isDark
                                    ? Colors.white.withValues(alpha: 0.6)
                                    : Colors.black.withValues(alpha: 0.6),
                                size: 24,
                              ),
                              child: Text(
                                Translations.of(context).feed.tabs.videos,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  color: _tabController.index == 1
                                      ? theme.colorScheme.primary
                                      : textColor.withValues(alpha: 0.7),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Tab(
                              icon: CustomIconWidget(
                                iconName: 'text_fields',
                                color: _tabController.index == 2
                                    ? theme.colorScheme.primary
                                    : isDark
                                    ? Colors.white.withValues(alpha: 0.6)
                                    : Colors.black.withValues(alpha: 0.6),
                                size: 24,
                              ),
                              child: Text(
                                Translations.of(context).feed.tabs.text,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  color: _tabController.index == 2
                                      ? theme.colorScheme.primary
                                      : textColor.withValues(alpha: 0.7),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Tab(
                              icon: CustomIconWidget(
                                iconName: 'auto_stories',
                                color: _tabController.index == 3
                                    ? theme.colorScheme.primary
                                    : isDark
                                    ? Colors.white.withValues(alpha: 0.6)
                                    : Colors.black.withValues(alpha: 0.6),
                                size: 24,
                              ),
                              child: Text(
                                Translations.of(context).feed.tabs.stories,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  color: _tabController.index == 3
                                      ? theme.colorScheme.primary
                                      : textColor.withValues(alpha: 0.7),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 2.h,
                      ),
                      sliver: ProfileContentGridWidget(
                        contentItems: _getFilteredContent(),
                        isLoading: _isLoading,
                        currentTabIndex: _tabController.index,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    // Rebuild when the underlying TabBar changes (e.g. theme, labels, or controller)
    return oldDelegate._tabBar != _tabBar;
  }
}

Widget buildDetailsButton(
  BuildContext context,
  bool isDark,
  String txt,
  VoidCallback onPressed,
  Widget icon,
) {
  return SizedBox(
    // width: double.infinity,
    child: Container(
      height: 5.5.h,
      decoration: BoxDecoration(
        gradient: isDark
            ? DarkColors.messageUserGradient
            : LightColors.messageUserGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        icon: icon,
        label: Text(
          txt,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}
