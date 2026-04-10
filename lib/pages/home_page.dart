import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/core/navigation/home_back_stack.dart';
import 'package:myitihas/features/home/presentation/pages/home_screen_page.dart';
import 'package:myitihas/features/social/presentation/pages/profile_page.dart';
import 'package:myitihas/features/social/presentation/pages/social_feed_page.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/pages/Chat/chat_itihas_page.dart';
import 'package:myitihas/pages/map2/map_tab_content.dart';
import 'package:myitihas/services/chat_service.dart';
import 'package:myitihas/services/supabase_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentBottomBarIndex = 2;
  int? _enlargedIndex;
  Timer? _shrinkTimer;
  String? _currentMapParam;

  // Chat unread badge state
  int _unreadChatCount = 0;
  StreamSubscription<void>? _unreadCountSubscription;
  final ChatService _chatService = getIt<ChatService>();

  final List<String> titles = ["Home", "Chat", "Social Feed", "Map", "Profile"];

  @override
  void initState() {
    super.initState();
    _startShrinkTimer(2);

    // Initialize unread chat count
    _initializeUnreadChatCount();

    // Show "Email verified successfully" when app was opened from confirmation link (BG_04)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (SupabaseService.authService
          .getAndClearPendingEmailVerifiedMessage()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Email verified successfully. You can now use the app.',
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  /// Initialize unread chat count and realtime subscription
  Future<void> _initializeUnreadChatCount() async {
    try {
      // Fetch initial unread count
      final count = await _chatService.getUnreadConversationCount();
      if (mounted) {
        setState(() {
          _unreadChatCount = count;
        });
      }

      // Subscribe to realtime unread count changes
      _unreadCountSubscription ??= _chatService
          .subscribeToUnreadCountChanges()
          .listen(
            (_) async {
              // Refresh count whenever realtime event occurs
              final newCount = await _chatService.getUnreadConversationCount();
              if (mounted) {
                setState(() {
                  _unreadChatCount = newCount;
                });
              }
            },
            onError: (e) {
              // Log error but don't crash; badge will still show cached count
              debugPrint('[HomePage] Unread count subscription error: $e');
            },
          );
    } catch (e) {
      debugPrint('[HomePage] Failed to initialize unread chat count: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final uri = GoRouterState.of(context).uri;
    HomeBackStack.track(uri);
    final q = uri.queryParameters;
    final tabParam = q['tab'];
    final mapParam = q['map'];
    int? targetIndex;
    if (tabParam == 'map') {
      targetIndex = 3;
    } else if (tabParam != null) {
      final n = int.tryParse(tabParam);
      if (n != null && n >= 0 && n <= 4) targetIndex = n;
    }

    bool needsUpdate = false;

    if (targetIndex != null && currentBottomBarIndex != targetIndex) {
      currentBottomBarIndex = targetIndex;
      _startShrinkTimer(targetIndex);
      needsUpdate = true;
    }

    if (mapParam != _currentMapParam) {
      _currentMapParam = mapParam;
      needsUpdate = true;
    }

    if (needsUpdate) {
      setState(() {});
    }
  }

  void _startShrinkTimer(int index) {
    _shrinkTimer?.cancel();
    setState(() => _enlargedIndex = index);
    _shrinkTimer = Timer(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() => _enlargedIndex = null);
      }
    });
  }

  @override
  void dispose() {
    _shrinkTimer?.cancel();
    _unreadCountSubscription?.cancel();
    super.dispose();
  }

  List<Widget> get pages => [
    const HomeScreenPage(),
    const ChatItihasPage(),
    SocialFeedPage(isScreenSelected: currentBottomBarIndex == 2),
    const MapTabContent(),
    const ProfilePage(), // current user's profile
  ];
  final Gradient selectedGradient = const LinearGradient(
    colors: [Color(0xFF44009F), Color(0xFF0088FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  bool _shouldShowBottomNav(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    final mapSubRoutes = [
      '/intent-choice',
      '/akhanda-bharata-map',
      '/map-explore',
      '/site-detail',
      '/indian-fabrics-map',
      '/fabric-hub-detail',
      '/fabric-shop',
      '/indian-crafts-map',
      '/craft-hub-detail',
      '/craft-shop',
      '/classical-art-map',
      '/classical-dance-map',
      '/cultural-item-detail',
      '/indian-foods-map',
      '/food-item-detail',
      '/forum-community',
      '/my-journey',
      '/plan',
      '/post-travel-story',
      '/saved-plan-detail',
      '/saved-travel-plan',
      '/mapchatbot',
      '/map',
    ];
    return !mapSubRoutes.any((route) => path.startsWith(route));
  }

  void _handleBackNavigation() {
    if (context.canPop()) {
      context.pop();
      return;
    }

    if (HomeBackStack.goBack(context)) {
      return;
    }

    final uri = GoRouterState.of(context).uri;
    if (!HomeBackStack.isAtHomeRoot(uri)) {
      context.go('/home?tab=2');
      return;
    }

    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackNavigation();
      },
      child: Scaffold(
        // Extend body under the glass nav bar so content shows through.
        extendBody: true,
        body: _buildBody(context),
        bottomNavigationBar: _shouldShowBottomNav(context)
            ? (Theme.of(context).platform == TargetPlatform.iOS
                  ? _buildCupertinoBottomNav(context)
                  : _buildAnimatedBottomNav(context))
            : null,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final theme = Theme.of(context);
    final gradients = theme.extension<GradientExtension>();
    final gradient =
        gradients?.screenBackgroundGradient ??
        LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surfaceContainerHigh,
          ],
        );

    return Container(
      decoration: BoxDecoration(gradient: gradient),
      child: IndexedStack(index: currentBottomBarIndex, children: pages),
    );
  }

  Widget _buildCupertinoBottomNav(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;
    const Color iosBlue = Color(0xFF007AFF);

    return CupertinoTabBar(
      currentIndex: currentBottomBarIndex,
      onTap: _handleBottomNavTap,
      activeColor: iosBlue,
      inactiveColor: colorScheme.onSurface.withValues(
        alpha: isDark ? 0.72 : 0.62,
      ),
      backgroundColor: isDark
          ? const Color(0xFF1C1C1E).withValues(alpha: 0.94)
          : const Color(0xFFFFFFFF).withValues(alpha: 0.95),
      border: Border(
        top: BorderSide(
          color: isDark
              ? Colors.white.withValues(alpha: 0.12)
              : Colors.black.withValues(alpha: 0.08),
          width: 0.5,
        ),
      ),
      iconSize: 24,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.explore_rounded),
          label: t.navigation.home,
        ),
        BottomNavigationBarItem(
          icon: _buildCupertinoChatIcon(),
          activeIcon: _buildCupertinoChatIcon(),
          label: t.navigation.chat,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.groups_rounded),
          label: t.navigation.community,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.map_rounded),
          label: t.navigation.map,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person_rounded),
          label: t.navigation.profile,
        ),
      ],
    );
  }

  Widget _buildCupertinoChatIcon() {
    final String unreadBadgeText = _unreadChatCount > 99
        ? '99+'
        : _unreadChatCount.toString();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(Icons.chat_bubble_rounded),
        if (_unreadChatCount > 0)
          Positioned(
            top: -4,
            right: -9,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: unreadBadgeText.length > 1 ? 4 : 0,
                vertical: 0,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFE53935),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  unreadBadgeText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAnimatedBottomNav(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;
    const Color iosBlue = Color(0xFF007AFF);
    final Color unselectedIconColor = colorScheme.onSurface.withValues(
      alpha: isDark ? 0.72 : 0.62,
    );
    final Color unselectedLabelColor = colorScheme.onSurface.withValues(
      alpha: isDark ? 0.72 : 0.62,
    );
    const Color selectedLabelColor = iosBlue;
    final Color selectedItemBackgroundColor = iosBlue.withValues(
      alpha: isDark ? 0.2 : 0.14,
    );
    final Color unselectedItemBackgroundColor = Colors.transparent;
    final Color navBarBackgroundTopColor = isDark
      ? const Color(0xFF232326).withValues(alpha: 0.95)
      : const Color(0xFFFFFFFF).withValues(alpha: 0.97);
    final Color navBarBackgroundBottomColor = isDark
      ? const Color(0xFF17181A).withValues(alpha: 0.95)
      : const Color(0xFFF6F8FB).withValues(alpha: 0.96);
    final Color navBarBorderColor = isDark
      ? Colors.white.withValues(alpha: 0.14)
      : Colors.black.withValues(alpha: 0.09);
    final Color navBarShadowColor = isDark
      ? Colors.black.withValues(alpha: 0.35)
      : Colors.black.withValues(alpha: 0.08);

    const double visualBarHeight = 62;
    const double minVisualBarHeight = 60;
    const double maxVisualBarHeight = 66;
    const double iconCircleSize = 38;
    const double enlargedIconCircleSize = 42;
    const double iconSize = 20;
    const double enlargedIconSize = 22;
    const double iconLift = 6;
    const double labelTopSpacing = 4;
    const double labelBottomPadding = 2;
    const double labelFontSize = 11.5;

    final double resolvedVisualBarHeight = visualBarHeight.clamp(
      minVisualBarHeight,
      maxVisualBarHeight,
    );
    // For 3-button navigation devices, keep full inset so system buttons do
    // not overlap app controls. For gesture navigation, keep compact spacing.
    final double mediaPaddingBottom = MediaQuery.paddingOf(context).bottom;
    final double mediaViewPaddingBottom =
        MediaQuery.of(context).viewPadding.bottom;
    final double rawBottomInset = mediaPaddingBottom > mediaViewPaddingBottom
        ? mediaPaddingBottom
        : mediaViewPaddingBottom;
    final double bottomReserve = rawBottomInset >= 32
        ? rawBottomInset
        : rawBottomInset.clamp(0.0, 20.0).toDouble();
    final double totalHeight = resolvedVisualBarHeight + bottomReserve;
    return SizedBox(
      height: totalHeight,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
          child: Container(
            height: totalHeight,
            padding: EdgeInsets.only(bottom: bottomReserve),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [navBarBackgroundTopColor, navBarBackgroundBottomColor],
              ),
              border: Border(
                top: BorderSide(color: navBarBorderColor, width: 1),
              ),
              boxShadow: [
                BoxShadow(
                  color: navBarShadowColor,
                  blurRadius: isDark ? 18 : 14,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildPopupItem(
                  0,
                  Icons.explore_rounded,
                  t.navigation.home,
                  unselectedIconColor,
                  unselectedLabelColor,
                  selectedLabelColor,
                  selectedItemBackgroundColor,
                  unselectedItemBackgroundColor,
                  iconCircleSize,
                  enlargedIconCircleSize,
                  iconSize,
                  enlargedIconSize,
                  iconLift,
                  labelTopSpacing,
                  labelBottomPadding,
                  labelFontSize,
                ),
                _buildPopupItem(
                  1,
                  Icons.chat_bubble_rounded,
                  t.navigation.chat,
                  unselectedIconColor,
                  unselectedLabelColor,
                  selectedLabelColor,
                  selectedItemBackgroundColor,
                  unselectedItemBackgroundColor,
                  iconCircleSize,
                  enlargedIconCircleSize,
                  iconSize,
                  enlargedIconSize,
                  iconLift,
                  labelTopSpacing,
                  labelBottomPadding,
                  labelFontSize,
                ),
                _buildPopupItem(
                  2,
                  Icons.groups_rounded,
                  t.navigation.community,
                  unselectedIconColor,
                  unselectedLabelColor,
                  selectedLabelColor,
                  selectedItemBackgroundColor,
                  unselectedItemBackgroundColor,
                  iconCircleSize,
                  enlargedIconCircleSize,
                  iconSize,
                  enlargedIconSize,
                  iconLift,
                  labelTopSpacing,
                  labelBottomPadding,
                  labelFontSize,
                ),
                _buildPopupItem(
                  3,
                  Icons.map_rounded,
                  t.navigation.map,
                  unselectedIconColor,
                  unselectedLabelColor,
                  selectedLabelColor,
                  selectedItemBackgroundColor,
                  unselectedItemBackgroundColor,
                  iconCircleSize,
                  enlargedIconCircleSize,
                  iconSize,
                  enlargedIconSize,
                  iconLift,
                  labelTopSpacing,
                  labelBottomPadding,
                  labelFontSize,
                ),
                _buildPopupItem(
                  4,
                  Icons.person_rounded,
                  t.navigation.profile,
                  unselectedIconColor,
                  unselectedLabelColor,
                  selectedLabelColor,
                  selectedItemBackgroundColor,
                  unselectedItemBackgroundColor,
                  iconCircleSize,
                  enlargedIconCircleSize,
                  iconSize,
                  enlargedIconSize,
                  iconLift,
                  labelTopSpacing,
                  labelBottomPadding,
                  labelFontSize,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPopupItem(
    int index,
    IconData icon,
    String label,
    Color unselectedIconColor,
    Color unselectedLabelColor,
    Color selectedLabelColor,
    Color selectedItemBackgroundColor,
    Color unselectedItemBackgroundColor,
    double iconCircleSize,
    double enlargedIconCircleSize,
    double iconSize,
    double enlargedIconSize,
    double iconLift,
    double labelTopSpacing,
    double labelBottomPadding,
    double labelFontSize,
  ) {
    bool isTabActive = currentBottomBarIndex == index;
    bool isTemporarilyEnlarged = _enlargedIndex == index;
    final String unreadBadgeText = _unreadChatCount > 99
        ? '99+'
        : _unreadChatCount.toString();

    return GestureDetector(
      onTap: () => _handleBottomNavTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                transform: Matrix4.translationValues(
                  0,
                  isTemporarilyEnlarged ? -iconLift : 0,
                  0,
                ),
                width: isTemporarilyEnlarged
                    ? enlargedIconCircleSize
                    : iconCircleSize,
                height: isTemporarilyEnlarged
                    ? enlargedIconCircleSize
                    : iconCircleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isTabActive
                      ? selectedItemBackgroundColor
                      : unselectedItemBackgroundColor,
                ),
                child: Icon(
                  icon,
                  size: isTemporarilyEnlarged ? enlargedIconSize : iconSize,
                  color: isTabActive ? selectedLabelColor : unselectedIconColor,
                ),
              ),
              // Chat unread badge (index 1 = chat)
              if (index == 1 && _unreadChatCount > 0)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: unreadBadgeText.length > 1 ? 4 : 0,
                      vertical: 0,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        unreadBadgeText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: labelTopSpacing),
          Padding(
            padding: EdgeInsets.only(bottom: labelBottomPadding),
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: labelFontSize,
                fontWeight: isTabActive ? FontWeight.w600 : FontWeight.w500,
                color: isTabActive ? selectedLabelColor : unselectedLabelColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleBottomNavTap(int index) {
    if (currentBottomBarIndex != index) {
      HapticFeedback.selectionClick();
    }
    setState(() => currentBottomBarIndex = index);
    _startShrinkTimer(index);
    // Sync URL so back from pushed routes restores the correct tab.
    if (index == 3) {
      context.go('/home?tab=map');
    } else {
      context.go('/home?tab=$index');
    }
  }
}
