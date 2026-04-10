import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// ─────────────────────────────────────────────
//  PUBLIC WIDGET
// ─────────────────────────────────────────────

class HomeFeatureHeroCarousel extends StatefulWidget {
  final VoidCallback onGenerateStoryTap;
  final VoidCallback onCompanionChatTap;
  final VoidCallback onExploreMapTap;
  final VoidCallback onCommunityTap;
  final VoidCallback onTravelPlanTap;
  final VoidCallback onDiscussionForumTap;

  const HomeFeatureHeroCarousel({
    super.key,
    required this.onGenerateStoryTap,
    required this.onCompanionChatTap,
    required this.onExploreMapTap,
    required this.onCommunityTap,
    required this.onTravelPlanTap,
    required this.onDiscussionForumTap,
  });

  @override
  State<HomeFeatureHeroCarousel> createState() =>
      _HomeFeatureHeroCarouselState();
}

// ─────────────────────────────────────────────
//  COLOR PALETTE  (dramatically distinct light ↔ dark)
// ─────────────────────────────────────────────
//
//  Design intent per card:
//
//  CARD 1 – Story/Manuscript
//    Dark  → deep midnight indigo (#0D0621) with vivid neon-violet accent (#C084FC)
//    Light → warm antique parchment (#FAF4E8) with rich aubergine accent (#6D28D9)
//
//  CARD 2 – Companion Chat
//    Dark  → abyssal deep-ocean (#030F1A) with luminous cyan accent (#22D3EE)
//    Light → icy porcelain (#EFF8FC) with deep teal accent (#0E7490)
//
//  CARD 3 – Heritage Map
//    Dark  → forest-night earth (#050F07) with electric lime-jade accent (#4ADE80)
//    Light → sun-bleached linen (#F5F0E4) with forest-jade accent (#15803D)
//
//  CARD 4 – Community
//    Dark  → smouldering ember (#120600) with molten amber accent (#FB923C)
//    Light → desert sand (#FDF5EC) with burnt-sienna accent (#B45309)
//
//  CARD 5 – Travel Plan
//    Dark  → twilight atlas (#001722) with aurora cyan accent (#22D3EE)
//    Light → sky parchment (#EEF8FF) with route blue accent (#0369A1)
//
//  CARD 6 – Discussion Forums
//    Dark  → dusk maroon (#22080D) with ember coral accent (#FB7185)
//    Light → dawn rose-sand (#FFF3EE) with vermilion accent (#BE123C)

class _CardPalette {
  // Dark gradient: 3 stops (base → mid → edge glow)
  final List<Color> darkGradient;
  // Light gradient: 3 stops (base → warm highlight → soft rim)
  final List<Color> lightGradient;

  // Primary accent
  final Color darkAccent;
  final Color lightAccent;

  // Secondary accent (for dual-tone effects)
  final Color darkAccent2;
  final Color lightAccent2;

  // Shimmer band
  final Color darkShimmer;
  final Color lightShimmer;

  // Headline last-line colour
  final Color darkHeadlineAccent;
  final Color lightHeadlineAccent;

  // Subtle orb tint (large floating circle)
  final Color darkOrb;
  final Color lightOrb;

  // Feature-pill border
  final Color darkPillBorder;
  final Color lightPillBorder;

  const _CardPalette({
    required this.darkGradient,
    required this.lightGradient,
    required this.darkAccent,
    required this.lightAccent,
    required this.darkAccent2,
    required this.lightAccent2,
    required this.darkShimmer,
    required this.lightShimmer,
    required this.darkHeadlineAccent,
    required this.lightHeadlineAccent,
    required this.darkOrb,
    required this.lightOrb,
    required this.darkPillBorder,
    required this.lightPillBorder,
  });
}

const _palettes = [
  // ── CARD 1: Story / Manuscript ──────────────────────────────────────────────
  _CardPalette(
    darkGradient: [
      Color(0xFF0D0621), // midnight indigo
      Color(0xFF1A0A40), // deep violet
      Color(0xFF2D1260), // rich purple
    ],
    lightGradient: [
      Color(0xFFFAF4E8), // antique parchment
      Color(0xFFF3E8D3), // aged vellum
      Color(0xFFEAD8BE), // warm papyrus edge
    ],
    darkAccent: Color(0xFFC084FC), // neon-violet
    lightAccent: Color(0xFF6D28D9), // deep aubergine
    darkAccent2: Color(0xFFF0ABFC), // pale orchid glow
    lightAccent2: Color(0xFF9333EA), // medium purple
    darkShimmer: Color(0xFFE9D5FF),
    lightShimmer: Color(0xFF7C3AED),
    darkHeadlineAccent: Color(0xFFDEB1FF),
    lightHeadlineAccent: Color(0xFF5B21B6),
    darkOrb: Color(0xFFA855F7),
    lightOrb: Color(0xFF8B5CF6),
    darkPillBorder: Color(0xFFA855F7),
    lightPillBorder: Color(0xFF7C3AED),
  ),

  // ── CARD 2: Companion Chat ───────────────────────────────────────────────────
  _CardPalette(
    darkGradient: [
      Color(0xFF030F1A), // abyssal deep-ocean
      Color(0xFF062233), // midnight blue
      Color(0xFF0A3A55), // deep teal-blue
    ],
    lightGradient: [
      Color(0xFFEEF9FC), // icy porcelain
      Color(0xFFD9F2F8), // pale aqua
      Color(0xFFC0E9F2), // soft cerulean
    ],
    darkAccent: Color(0xFF22D3EE), // luminous cyan
    lightAccent: Color(0xFF0E7490), // deep teal
    darkAccent2: Color(0xFF67E8F9), // bright sky-cyan
    lightAccent2: Color(0xFF0891B2), // medium teal
    darkShimmer: Color(0xFFA5F3FC),
    lightShimmer: Color(0xFF06B6D4),
    darkHeadlineAccent: Color(0xFF67E8F9),
    lightHeadlineAccent: Color(0xFF0C6B82),
    darkOrb: Color(0xFF0EA5E9),
    lightOrb: Color(0xFF22D3EE),
    darkPillBorder: Color(0xFF06B6D4),
    lightPillBorder: Color(0xFF0E7490),
  ),

  // ── CARD 3: Heritage Map ─────────────────────────────────────────────────────
  _CardPalette(
    darkGradient: [
      Color(0xFF050F07), // forest night
      Color(0xFF0A1F0E), // dark moss
      Color(0xFF0F3318), // deep jungle
    ],
    lightGradient: [
      Color(0xFFF5F0E4), // sun-bleached linen
      Color(0xFFE8E0CA), // warm hemp
      Color(0xFFD8CEB4), // aged canvas edge
    ],
    darkAccent: Color(0xFF4ADE80), // electric lime-jade
    lightAccent: Color(0xFF15803D), // forest jade
    darkAccent2: Color(0xFF86EFAC), // pale sage glow
    lightAccent2: Color(0xFF16A34A), // medium green
    darkShimmer: Color(0xFFBBF7D0),
    lightShimmer: Color(0xFF22C55E),
    darkHeadlineAccent: Color(0xFF86EFAC),
    lightHeadlineAccent: Color(0xFF14532D),
    darkOrb: Color(0xFF22C55E),
    lightOrb: Color(0xFF4ADE80),
    darkPillBorder: Color(0xFF22C55E),
    lightPillBorder: Color(0xFF15803D),
  ),

  // ── CARD 4: Community ────────────────────────────────────────────────────────
  _CardPalette(
    darkGradient: [
      Color(0xFF120600), // smouldering ember base
      Color(0xFF2C0E00), // deep bronze
      Color(0xFF4A1A00), // rich terra
    ],
    lightGradient: [
      Color(0xFFFDF5EC), // desert sand
      Color(0xFFF7E4CC), // warm biscuit
      Color(0xFFEFD0A8), // toasted almond
    ],
    darkAccent: Color(0xFFFB923C), // molten amber
    lightAccent: Color(0xFFB45309), // burnt sienna
    darkAccent2: Color(0xFFFBBF24), // gold glow
    lightAccent2: Color(0xFFD97706), // amber-brown
    darkShimmer: Color(0xFFFDE68A),
    lightShimmer: Color(0xFFF59E0B),
    darkHeadlineAccent: Color(0xFFFBBF24),
    lightHeadlineAccent: Color(0xFF92400E),
    darkOrb: Color(0xFFF97316),
    lightOrb: Color(0xFFFB923C),
    darkPillBorder: Color(0xFFF97316),
    lightPillBorder: Color(0xFFB45309),
  ),

  // ── CARD 5: Travel Plan ──────────────────────────────────────────────────────
  _CardPalette(
    darkGradient: [
      Color(0xFF001722), // twilight atlas
      Color(0xFF003249), // deep route blue
      Color(0xFF005270), // oceanic steel
    ],
    lightGradient: [
      Color(0xFFEEF8FF), // sky parchment
      Color(0xFFDDEFFF), // route mist
      Color(0xFFC9E4FB), // map paper blue
    ],
    darkAccent: Color(0xFF22D3EE), // aurora cyan
    lightAccent: Color(0xFF0369A1), // route blue
    darkAccent2: Color(0xFF7DD3FC), // bright sky line
    lightAccent2: Color(0xFF0EA5E9), // medium sky
    darkShimmer: Color(0xFFCFFAFE),
    lightShimmer: Color(0xFF0284C7),
    darkHeadlineAccent: Color(0xFF7DD3FC),
    lightHeadlineAccent: Color(0xFF075985),
    darkOrb: Color(0xFF0EA5E9),
    lightOrb: Color(0xFF38BDF8),
    darkPillBorder: Color(0xFF0891B2),
    lightPillBorder: Color(0xFF0369A1),
  ),

  // ── CARD 6: Discussion Forums ───────────────────────────────────────────────
  _CardPalette(
    darkGradient: [
      Color(0xFF22080D), // dusk maroon
      Color(0xFF3B0E18), // deep wine
      Color(0xFF5A1624), // ember berry
    ],
    lightGradient: [
      Color(0xFFFFF3EE), // dawn rose-sand
      Color(0xFFFFE4D9), // warm peach
      Color(0xFFFACCC1), // blush clay
    ],
    darkAccent: Color(0xFFFB7185), // ember coral
    lightAccent: Color(0xFFBE123C), // vermilion
    darkAccent2: Color(0xFFFDA4AF), // soft blush glow
    lightAccent2: Color(0xFFE11D48), // vivid rose red
    darkShimmer: Color(0xFFFCE7F3),
    lightShimmer: Color(0xFFFB7185),
    darkHeadlineAccent: Color(0xFFFDA4AF),
    lightHeadlineAccent: Color(0xFF9F1239),
    darkOrb: Color(0xFFFB7185),
    lightOrb: Color(0xFFFB7185),
    darkPillBorder: Color(0xFFFB7185),
    lightPillBorder: Color(0xFFBE123C),
  ),
];

// ─────────────────────────────────────────────
//  CARD DATA MODEL
// ─────────────────────────────────────────────

enum _HeroVisualType { manuscript, chat, map, community, travelPlan, discussions }

class _HeroCardData {
  final String tagline;
  final String headline;
  final String subHeadline;
  final List<String> lines;
  final String cta;
  final _CardPalette palette;
  final IconData icon;
  final _HeroVisualType visualType;
  final VoidCallback onTap;

  const _HeroCardData({
    required this.tagline,
    required this.headline,
    required this.subHeadline,
    required this.lines,
    required this.cta,
    required this.palette,
    required this.icon,
    required this.visualType,
    required this.onTap,
  });
}

// ─────────────────────────────────────────────
//  CAROUSEL STATE
// ─────────────────────────────────────────────

class _HomeFeatureHeroCarouselState extends State<HomeFeatureHeroCarousel>
    with SingleTickerProviderStateMixin {
  static const Duration _autoScrollInterval = Duration(seconds: 5);

  late final PageController _pageController;
  late final AnimationController _entranceController;
  late final Animation<double> _entranceFade;
  late final Animation<Offset> _entranceSlide;
  Timer? _autoScrollTimer;
  int _currentIndex = 0;
  bool _isInteracting = false;

  late final List<_HeroCardData> _cards;

  @override
  void initState() {
    super.initState();
    _cards = _buildCards();
    _pageController = PageController(viewportFraction: 0.90);
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    );
    _entranceFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.75, curve: Curves.easeOut),
    );
    _entranceSlide =
        Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: const Interval(0.0, 0.85, curve: Curves.easeOutCubic),
          ),
        );
    _entranceController.forward();
    _startAutoScroll();
  }

  List<_HeroCardData> _buildCards() => [
    _HeroCardData(
      tagline: 'AI Story Generation',
      headline: 'Generate\nImmersive\nStories',
      subHeadline: 'Powered by ancient wisdom',
      lines: const [
        '✦  Choose a sacred scripture…',
        '✦  Select a vivid setting…',
        '✦  Let AI weave a mesmerising tale…',
      ],
      cta: 'Generate Story',
      palette: _palettes[3],
      icon: Icons.auto_stories_rounded,
      visualType: _HeroVisualType.manuscript,
      onTap: widget.onGenerateStoryTap,
    ),
    _HeroCardData(
      tagline: 'Spiritual Companion',
      headline: 'Your Divine\nGuide,\nAlways Near',
      subHeadline: "Inspired by Krishna's wisdom",
      lines: const [
        '✦  A friend who truly listens…',
        "✦  Wisdom for life's struggles…",
        '✦  Conversations that uplift you…',
      ],
      cta: 'Start Chat',
      palette: _palettes[1],
      icon: Icons.self_improvement_rounded,
      visualType: _HeroVisualType.chat,
      onTap: widget.onCompanionChatTap,
    ),
    _HeroCardData(
      tagline: 'Heritage Map',
      headline: 'Discover\nTimeless\nHeritage',
      subHeadline: '5000+ sacred sites mapped',
      lines: const [
        '✦  Explore sacred places…',
        '✦  Read history and lore…',
        '✦  Plan meaningful journeys…',
      ],
      cta: 'Explore Map',
      palette: _palettes[2],
      icon: Icons.explore_rounded,
      visualType: _HeroVisualType.map,
      onTap: widget.onExploreMapTap,
    ),
    _HeroCardData(
      tagline: 'Community Space',
      headline: 'Share\nCulture With\nThe World',
      subHeadline: 'A vibrant global community',
      lines: const [
        '✦  Posts and deep discussions…',
        '✦  Short cultural videos…',
        '✦  Stories from around the world…',
      ],
      cta: 'Join Community',
      palette: _palettes[0],
      icon: Icons.groups_rounded,
      visualType: _HeroVisualType.community,
      onTap: widget.onCommunityTap,
    ),
    _HeroCardData(
      tagline: 'Travel Planner',
      headline: 'Craft Your\nPilgrimage\nRoute',
      subHeadline: 'Plan sacred journeys with confidence',
      lines: const [
        '✦  Build multi-stop travel plans…',
        '✦  Pick dates and destinations…',
        '✦  Navigate every sacred milestone…',
      ],
      cta: 'Open Travel Plan',
      palette: _palettes[4],
      icon: Icons.route_rounded,
      visualType: _HeroVisualType.travelPlan,
      onTap: widget.onTravelPlanTap,
    ),
    _HeroCardData(
      tagline: 'Discussion Forums',
      headline: 'Ask, Share\nAnd Grow\nTogether',
      subHeadline: 'Thoughtful discussions with seekers',
      lines: const [
        '✦  Start focused discussion threads…',
        '✦  Exchange cultural insights…',
        '✦  Learn from community journeys…',
      ],
      cta: 'Open Discussions',
      palette: _palettes[5],
      icon: Icons.forum_rounded,
      visualType: _HeroVisualType.discussions,
      onTap: widget.onDiscussionForumTap,
    ),
  ];

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(_autoScrollInterval, (_) {
      if (!mounted || !_pageController.hasClients || _isInteracting) return;
      final next = (_currentIndex + 1) % _cards.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.sizeOf(context).height;
    // Larger card – feel premium and spacious
    final heroH = (screenH * 0.52).clamp(390.0, 490.0);

    return FadeTransition(
      opacity: _entranceFade,
      child: SlideTransition(
        position: _entranceSlide,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: heroH.h,
              child: NotificationListener<ScrollNotification>(
                onNotification: (n) {
                  if (n is ScrollStartNotification) {
                    setState(() => _isInteracting = true);
                  }
                  if (n is ScrollEndNotification) {
                    setState(() => _isInteracting = false);
                  }
                  return false;
                },
                child: PageView.builder(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _cards.length,
                  onPageChanged: (i) => setState(() => _currentIndex = i),
                  itemBuilder: (context, index) {
                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double delta = 0;
                        if (_pageController.hasClients &&
                            _pageController.position.haveDimensions) {
                          delta =
                              (_pageController.page ??
                                  _currentIndex.toDouble()) -
                              index;
                        }
                        final scale = (1 - delta.abs() * 0.04).clamp(0.93, 1.0);
                        final opacity = (1 - delta.abs() * 0.18).clamp(
                          0.82,
                          1.0,
                        );
                        return Transform.translate(
                          offset: Offset(delta * -8.w, delta.abs() * 4.h),
                          child: Transform.scale(
                            scale: scale,
                            child: Opacity(
                              opacity: opacity,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5.w,
                                  vertical: 6.h,
                                ),
                                child: _HeroCard(data: _cards[index]),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 14.h),
            _PageIndicatorRow(
              controller: _pageController,
              count: _cards.length,
              currentIndex: _currentIndex,
              cards: _cards,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  PAGE INDICATOR
// ─────────────────────────────────────────────

class _PageIndicatorRow extends StatelessWidget {
  final PageController controller;
  final int count;
  final int currentIndex;
  final List<_HeroCardData> cards;

  const _PageIndicatorRow({
    required this.controller,
    required this.count,
    required this.currentIndex,
    required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final palette = cards[currentIndex].palette;
    final accent = isDark ? palette.darkAccent : palette.lightAccent;

    return Column(
      children: [
        Center(
          child: SmoothPageIndicator(
            controller: controller,
            count: count,
            effect: ExpandingDotsEffect(
              expansionFactor: 4.2,
              spacing: 5.w,
              radius: 100.r,
              dotWidth: 5.w,
              dotHeight: 5.h,
              dotColor: theme.colorScheme.onSurface.withValues(alpha: 0.13),
              activeDotColor: accent,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 320),
            child: Text(
              cards[currentIndex].tagline.toUpperCase(),
              key: ValueKey(currentIndex),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.38),
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
                fontSize: 9.5.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  HERO CARD
// ─────────────────────────────────────────────

class _HeroCard extends StatefulWidget {
  final _HeroCardData data;
  const _HeroCard({required this.data});

  @override
  State<_HeroCard> createState() => _HeroCardState();
}

class _HeroCardState extends State<_HeroCard> with TickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final AnimationController _particleCtrl;
  late final AnimationController _iconCtrl;
  late final AnimationController _tapHintCtrl;
  late final AnimationController _breatheCtrl;

  late final Animation<double> _pressScale;
  late final Animation<double> _iconBob;
  late final Animation<double> _tapHintFade;
  late final Animation<double> _breathe;

  @override
  void initState() {
    super.initState();

    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 130),
    );
    _pressScale = Tween<double>(
      begin: 1.0,
      end: 0.972,
    ).animate(CurvedAnimation(parent: _pressCtrl, curve: Curves.easeOutCubic));

    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();

    _iconCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);
    _iconBob = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _iconCtrl, curve: Curves.easeInOut));

    // Slow breathing pulse for the radial orb
    _breatheCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3800),
    )..repeat(reverse: true);
    _breathe = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _breatheCtrl, curve: Curves.easeInOut));

    // Tap hint fades after 1.2 s
    _tapHintCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      value: 1.0,
    );
    _tapHintFade = CurvedAnimation(parent: _tapHintCtrl, curve: Curves.easeOut);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) _tapHintCtrl.reverse();
    });
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    _particleCtrl.dispose();
    _iconCtrl.dispose();
    _tapHintCtrl.dispose();
    _breatheCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final d = widget.data;
    final palette = d.palette;

    final gradient = isDark ? palette.darkGradient : palette.lightGradient;
    final accent = isDark ? palette.darkAccent : palette.lightAccent;
    final accent2 = isDark ? palette.darkAccent2 : palette.lightAccent2;
    final headlineAccent = isDark
        ? palette.darkHeadlineAccent
        : palette.lightHeadlineAccent;
    final orbColor = isDark ? palette.darkOrb : palette.lightOrb;

    final shadowColor = isDark
        ? gradient[2].withValues(alpha: 0.55)
        : gradient[2].withValues(alpha: 0.28);

    return GestureDetector(
      onTapDown: (_) {
        _pressCtrl.forward();
      },
      onTapCancel: () => _pressCtrl.reverse(),
      onTapUp: (_) {
        _pressCtrl.reverse();
        d.onTap();
      },
      child: ScaleTransition(
        scale: _pressScale,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28.r),
            boxShadow: [
              // Primary depth shadow
              BoxShadow(
                color: shadowColor,
                blurRadius: 36,
                spreadRadius: -4,
                offset: const Offset(0, 16),
              ),
              // Soft inner ambient
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.30)
                    : Colors.black.withValues(alpha: 0.07),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
              // Accent colour bleed (dark only)
              if (isDark)
                BoxShadow(
                  color: accent.withValues(alpha: 0.14),
                  blurRadius: 50,
                  spreadRadius: -10,
                  offset: const Offset(0, 20),
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28.r),
            child: Stack(
              children: [
                // ── Base gradient ─────────────────────────────────────────────
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: gradient,
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                ),

                // ── Secondary diagonal tint (adds richness) ───────────────────
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          accent2.withValues(alpha: isDark ? 0.08 : 0.06),
                          Colors.transparent,
                          accent.withValues(alpha: isDark ? 0.05 : 0.04),
                        ],
                        stops: const [0.0, 0.50, 1.0],
                      ),
                    ),
                  ),
                ),

                // ── Light-mode paper texture overlay ──────────────────────────
                if (!isDark)
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.topLeft,
                          radius: 1.4,
                          colors: [
                            Colors.white.withValues(alpha: 0.55),
                            Colors.white.withValues(alpha: 0.12),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.35, 1.0],
                        ),
                      ),
                    ),
                  ),

                // ── Particles ─────────────────────────────────────────────────
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _particleCtrl,
                    builder: (context, _) => CustomPaint(
                      painter: _ParticlePainter(
                        progress: _particleCtrl.value,
                        accent: accent,
                        accent2: accent2,
                        isDark: isDark,
                      ),
                    ),
                  ),
                ),

                // ── Breathing radial orb (top-right) ──────────────────────────
                Positioned(
                  top: -70.h,
                  right: -50.w,
                  child: AnimatedBuilder(
                    animation: _breathe,
                    builder: (_, __) {
                      final sz = 210.w + _breathe.value * 20.w;
                      final alpha =
                          (isDark ? 0.22 : 0.18) + _breathe.value * 0.06;
                      return Container(
                        width: sz,
                        height: sz,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              orbColor.withValues(alpha: alpha),
                              accent2.withValues(alpha: alpha * 0.3),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.55, 1.0],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ── Secondary orb (bottom-left) ───────────────────────────────
                Positioned(
                  bottom: -60.h,
                  left: -40.w,
                  child: Container(
                    width: 160.w,
                    height: 160.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          accent2.withValues(alpha: isDark ? 0.14 : 0.12),
                          accent.withValues(alpha: isDark ? 0.06 : 0.05),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),

                // ── Top edge glass highlight ───────────────────────────────────
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 80.h,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: isDark ? 0.08 : 0.55),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Bottom fade to deeper tone ─────────────────────────────────
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 100.h,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          (isDark ? Colors.black : gradient[2]).withValues(
                            alpha: isDark ? 0.30 : 0.20,
                          ),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // ── CONTENT ───────────────────────────────────────────────────
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 18.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TaglineRow(
                          data: d,
                          iconBob: _iconBob,
                          accent: accent,
                          accent2: accent2,
                          isDark: isDark,
                        ),
                        SizedBox(height: 16.h),
                        _HeadlineBlock(
                          data: d,
                          headlineAccent: headlineAccent,
                          isDark: isDark,
                        ),
                        SizedBox(height: 12.h),
                        _FeaturePanel(
                          data: d,
                          accent: accent,
                          accent2: accent2,
                          isDark: isDark,
                        ),
                        const Spacer(),
                        _CtaRow(
                          data: d,
                          accent: accent,
                          accent2: accent2,
                          isDark: isDark,
                          tapHintFade: _tapHintFade,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  TAGLINE ROW
// ─────────────────────────────────────────────

class _TaglineRow extends StatelessWidget {
  final _HeroCardData data;
  final Animation<double> iconBob;
  final Color accent;
  final Color accent2;
  final bool isDark;

  const _TaglineRow({
    required this.data,
    required this.iconBob,
    required this.accent,
    required this.accent2,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textSecondary = isDark
        ? Colors.white.withValues(alpha: 0.52)
        : Colors.black.withValues(alpha: 0.44);

    return Row(
      children: [
        // Animated icon container with dual-accent glow
        AnimatedBuilder(
          animation: iconBob,
          builder: (context, child) {
            final t = iconBob.value;
            return Transform.translate(
              offset: Offset(0, -3.5 * math.sin(t * math.pi)),
              child: child,
            );
          },
          child: Container(
            padding: EdgeInsets.all(11.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        Colors.white.withValues(alpha: 0.18),
                        accent.withValues(alpha: 0.10),
                      ]
                    : [
                        Colors.white.withValues(alpha: 0.90),
                        accent.withValues(alpha: 0.08),
                      ],
              ),
              border: Border.all(
                color: isDark
                    ? accent.withValues(alpha: 0.30)
                    : accent.withValues(alpha: 0.25),
                width: 1.1,
              ),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: isDark ? 0.32 : 0.22),
                  blurRadius: 16,
                  spreadRadius: -2,
                  offset: const Offset(0, 4),
                ),
                if (isDark)
                  BoxShadow(
                    color: accent2.withValues(alpha: 0.12),
                    blurRadius: 24,
                    spreadRadius: -4,
                    offset: const Offset(0, 6),
                  ),
              ],
            ),
            child: Icon(
              data.icon,
              color: isDark ? accent : accent,
              size: 22.sp,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.tagline.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w800,
                  fontSize: 9.sp,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                data.subHeadline,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: textSecondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 10.5.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  HEADLINE BLOCK
// ─────────────────────────────────────────────

class _HeadlineBlock extends StatelessWidget {
  final _HeroCardData data;
  final Color headlineAccent;
  final bool isDark;

  const _HeadlineBlock({
    required this.data,
    required this.headlineAccent,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lines = data.headline.split('\n');
    final bodyColor = isDark
        ? Colors.white.withValues(alpha: 0.97)
        : Colors.black.withValues(alpha: 0.84);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.asMap().entries.map((e) {
        final isLast = e.key == lines.length - 1;
        return Text(
          e.value,
          style: theme.textTheme.displaySmall?.copyWith(
            color: isLast ? headlineAccent : bodyColor,
            fontWeight: FontWeight.w900,
            height: 1.05,
            fontSize: 28.sp,
            letterSpacing: -0.8,
            shadows: isLast
                ? [
                    Shadow(
                      color: headlineAccent.withValues(
                        alpha: isDark ? 0.55 : 0.22,
                      ),
                      blurRadius: 16,
                    ),
                  ]
                : null,
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────
//  FEATURE PANEL
// ─────────────────────────────────────────────

class _FeaturePanel extends StatelessWidget {
  final _HeroCardData data;
  final Color accent;
  final Color accent2;
  final bool isDark;

  const _FeaturePanel({
    required this.data,
    required this.accent,
    required this.accent2,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: _AnimatedLinesCycler(
            lines: data.lines,
            accent: accent,
            accent2: accent2,
            isDark: isDark,
          ),
        ),
        SizedBox(width: 10.w),
        _CardIllustration(
          type: data.visualType,
          accent: accent,
          accent2: accent2,
          isDark: isDark,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  ANIMATED LINES CYCLER
// ─────────────────────────────────────────────

class _AnimatedLinesCycler extends StatefulWidget {
  final List<String> lines;
  final Color accent;
  final Color accent2;
  final bool isDark;

  const _AnimatedLinesCycler({
    required this.lines,
    required this.accent,
    required this.accent2,
    required this.isDark,
  });

  @override
  State<_AnimatedLinesCycler> createState() => _AnimatedLinesCyclerState();
}

class _AnimatedLinesCyclerState extends State<_AnimatedLinesCycler>
    with SingleTickerProviderStateMixin {
  int _idx = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 2400), (_) {
      if (!mounted) return;
      setState(() => _idx = (_idx + 1) % widget.lines.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = widget.lines[_idx];
    final isDark = widget.isDark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        // Richer pill background
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Colors.black.withValues(alpha: 0.32),
                  widget.accent.withValues(alpha: 0.08),
                ]
              : [
                  Colors.white.withValues(alpha: 0.70),
                  widget.accent.withValues(alpha: 0.06),
                ],
        ),
        border: Border.all(
          color: isDark
              ? widget.accent.withValues(alpha: 0.22)
              : widget.accent.withValues(alpha: 0.20),
          width: 0.9,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.accent.withValues(alpha: isDark ? 0.10 : 0.07),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              height: 46.h,
              child: ClipRect(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 700),
                  switchInCurve: Curves.easeOutBack,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, anim) {
                    final isIn = child.key == ValueKey(text);
                    return FadeTransition(
                      opacity: anim,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: isIn ? const Offset(0, 0.55) : Offset.zero,
                          end: isIn ? Offset.zero : const Offset(0, -0.55),
                        ).animate(anim),
                        child: child,
                      ),
                    );
                  },
                  layoutBuilder: (cur, prev) => Stack(
                    alignment: Alignment.centerLeft,
                    children: [...prev, if (cur != null) cur],
                  ),
                  child: Text(
                    text,
                    key: ValueKey(text),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.90)
                          : Colors.black.withValues(alpha: 0.72),
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                      height: 1.40,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          // Progress track (accent-coloured)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.lines.length, (i) {
              final isActive = i == _idx;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(vertical: 2.5.h),
                width: 3.5.w,
                height: isActive ? 16.h : 4.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: isActive
                      ? widget.accent
                      : (isDark
                            ? Colors.white.withValues(alpha: 0.20)
                            : widget.accent.withValues(alpha: 0.20)),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: widget.accent.withValues(alpha: 0.50),
                            blurRadius: 6,
                          ),
                        ]
                      : null,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  CARD ILLUSTRATION
// ─────────────────────────────────────────────

class _CardIllustration extends StatefulWidget {
  final _HeroVisualType type;
  final Color accent;
  final Color accent2;
  final bool isDark;

  const _CardIllustration({
    required this.type,
    required this.accent,
    required this.accent2,
    required this.isDark,
  });

  @override
  State<_CardIllustration> createState() => _CardIllustrationState();
}

class _CardIllustrationState extends State<_CardIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76.w,
      height: 72.h,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => CustomPaint(
          painter: _IllustrationPainter(
            progress: _ctrl.value,
            type: widget.type,
            accent: widget.accent,
            accent2: widget.accent2,
            isDark: widget.isDark,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  CTA ROW
// ─────────────────────────────────────────────

class _CtaRow extends StatelessWidget {
  final _HeroCardData data;
  final Color accent;
  final Color accent2;
  final bool isDark;
  final Animation<double> tapHintFade;

  const _CtaRow({
    required this.data,
    required this.accent,
    required this.accent2,
    required this.isDark,
    required this.tapHintFade,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 11.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      accent.withValues(alpha: 0.30),
                      accent2.withValues(alpha: 0.15),
                    ]
                  : [
                      accent.withValues(alpha: 0.95),
                      accent2.withValues(alpha: 0.85),
                    ],
            ),
            border: Border.all(
              color: isDark
                  ? accent.withValues(alpha: 0.35)
                  : Colors.transparent,
              width: isDark ? 1.0 : 0,
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: isDark ? 0.25 : 0.35),
                blurRadius: 14,
                spreadRadius: -2,
                offset: const Offset(0, 5),
              ),
              if (!isDark)
                BoxShadow(
                  color: accent2.withValues(alpha: 0.20),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                data.cta,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: isDark ? accent : Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 13.sp,
                  letterSpacing: 0.1,
                ),
              ),
              SizedBox(width: 7.w),
              Icon(
                Icons.arrow_forward_rounded,
                color: isDark ? accent : Colors.white,
                size: 15.sp,
              ),
            ],
          ),
        ),
        const Spacer(),
        FadeTransition(
          opacity: tapHintFade,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 6.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: isDark
                  ? Colors.black.withValues(alpha: 0.18)
                  : Colors.black.withValues(alpha: 0.06),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.10)
                    : Colors.black.withValues(alpha: 0.06),
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.touch_app_rounded,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.45)
                      : Colors.black.withValues(alpha: 0.30),
                  size: 11.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  'Tap to explore',
                  style: TextStyle(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.45)
                        : Colors.black.withValues(alpha: 0.30),
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  PARTICLE PAINTER  (dual-accent particles)
// ─────────────────────────────────────────────

class _ParticlePainter extends CustomPainter {
  final double progress;
  final Color accent;
  final Color accent2;
  final bool isDark;

  const _ParticlePainter({
    required this.progress,
    required this.accent,
    required this.accent2,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(42);
    final maxOpacity = isDark ? 0.36 : 0.24;
    for (var i = 0; i < 16; i++) {
      final baseX = rng.nextDouble() * size.width;
      final baseY = rng.nextDouble() * size.height;
      final speed = 0.20 + rng.nextDouble() * 0.60;
      final phase = rng.nextDouble();
      final t = (progress * speed + phase) % 1.0;
      final y = baseY - t * size.height * 0.52;
      final opacity =
          (math.sin(t * math.pi) * maxOpacity * (0.4 + rng.nextDouble() * 0.6))
              .clamp(0.0, maxOpacity);
      final radius = 1.0 + rng.nextDouble() * 2.2;
      // Alternate between accent and accent2 for visual depth
      final color = (i % 3 == 0) ? accent2 : accent;
      canvas.drawCircle(
        Offset(baseX + math.sin(t * 2 * math.pi + phase) * 10, y),
        radius,
        Paint()..color = color.withValues(alpha: opacity),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) =>
      old.progress != progress || old.isDark != isDark;
}

// ─────────────────────────────────────────────
//  ILLUSTRATION PAINTER  (enhanced per-card art)
// ─────────────────────────────────────────────

class _IllustrationPainter extends CustomPainter {
  final double progress;
  final _HeroVisualType type;
  final Color accent;
  final Color accent2;
  final bool isDark;

  const _IllustrationPainter({
    required this.progress,
    required this.type,
    required this.accent,
    required this.accent2,
    required this.isDark,
  });

  Paint _fill(Color c) => Paint()
    ..style = PaintingStyle.fill
    ..color = c;

  Paint _stroke(Color c, double w) => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = w
    ..color = c
    ..strokeCap = StrokeCap.round;

  Color get _baseWhite => isDark ? Colors.white : Colors.black;

  @override
  void paint(Canvas canvas, Size s) {
    switch (type) {
      case _HeroVisualType.manuscript:
        _drawManuscript(canvas, s);
      case _HeroVisualType.chat:
        _drawChat(canvas, s);
      case _HeroVisualType.map:
        _drawMap(canvas, s);
      case _HeroVisualType.community:
        _drawCommunity(canvas, s);
      case _HeroVisualType.travelPlan:
        _drawTravelPlan(canvas, s);
      case _HeroVisualType.discussions:
        _drawDiscussions(canvas, s);
    }
  }

  void _drawManuscript(Canvas canvas, Size s) {
    final t = progress;
    // Stacked page layers
    for (var i = 2; i >= 0; i--) {
      final shift = math.sin((t + i * 0.15) * 2 * math.pi) * 2.2;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          7 + i * 3.2,
          5 + shift + i * 2.2,
          s.width - 20,
          s.height - 16,
        ),
        const Radius.circular(7),
      );
      canvas.drawRRect(
        rect,
        _fill(
          _baseWhite.withValues(
            alpha: isDark ? 0.04 + i * 0.07 : 0.04 + i * 0.05,
          ),
        ),
      );
      canvas.drawRRect(
        rect,
        _stroke(
          (i == 0 ? accent : _baseWhite).withValues(
            alpha: isDark ? 0.14 + i * 0.07 : 0.10 + i * 0.04,
          ),
          0.8,
        ),
      );
    }
    // Text lines
    final lineShift = math.sin(t * 2 * math.pi) * 0.7;
    final lineWidths = [0.72, 0.52, 0.68, 0.42];
    for (var l = 0; l < lineWidths.length; l++) {
      final y = 16 + l * 9.5 + lineShift;
      final w = s.width * lineWidths[l];
      canvas.drawLine(
        Offset(16, y),
        Offset(16 + w - 12, y),
        _stroke(
          (l == 0 ? accent : (l == 2 ? accent2 : _baseWhite)).withValues(
            alpha: l == 0 ? 0.75 : 0.30,
          ),
          l == 0 ? 1.6 : 0.9,
        ),
      );
    }
    // Glowing star/seal top-right
    final glow = (math.sin(t * 2 * math.pi) + 1) / 2;
    canvas.drawCircle(
      Offset(s.width - 13, 11),
      3.5 + glow * 2.5,
      _fill(accent.withValues(alpha: 0.45 + glow * 0.35)),
    );
    canvas.drawCircle(
      Offset(s.width - 13, 11),
      1.5,
      _fill(accent2.withValues(alpha: 0.80 + glow * 0.20)),
    );
  }

  void _drawChat(Canvas canvas, Size s) {
    final t = progress;
    final bubbles = [
      (left: true, w: 0.62, y: 6.0, delay: 0.0),
      (left: false, w: 0.48, y: 26.0, delay: 0.28),
      (left: true, w: 0.54, y: 46.0, delay: 0.56),
    ];
    for (var i = 0; i < bubbles.length; i++) {
      final b = bubbles[i];
      final phase = (t + b.delay) % 1.0;
      final opacity = (math.sin(phase * math.pi) * 0.68 + 0.22).clamp(
        0.0,
        0.85,
      );
      final x = b.left ? 5.0 : s.width - (s.width * b.w) - 5;
      final bubbleColor = b.left ? _baseWhite : accent;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, b.y, s.width * b.w, 14),
        const Radius.circular(8),
      );
      canvas.drawRRect(
        rect,
        _fill(bubbleColor.withValues(alpha: opacity * 0.18)),
      );
      canvas.drawRRect(
        rect,
        _stroke(bubbleColor.withValues(alpha: opacity * 0.55), 0.9),
      );
      // Dot indicators inside bubble
      for (var d = 0; d < 3; d++) {
        canvas.drawCircle(
          Offset(x + 7 + d * 5.5, b.y + 7),
          1.3,
          _fill(bubbleColor.withValues(alpha: opacity * 0.50)),
        );
      }
    }
    // Glow dot for online indicator
    final pulse = (math.sin(t * 3 * math.pi) + 1) / 2;
    canvas.drawCircle(
      Offset(s.width - 8, 6),
      2.5 + pulse * 1.5,
      _fill(accent2.withValues(alpha: 0.22 + pulse * 0.18)),
    );
    canvas.drawCircle(
      Offset(s.width - 8, 6),
      1.5,
      _fill(accent.withValues(alpha: 0.80)),
    );
  }

  void _drawMap(Canvas canvas, Size s) {
    final t = progress;
    // Map background
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(4, 6, s.width - 8, s.height - 12),
        const Radius.circular(8),
      ),
      _fill(_baseWhite.withValues(alpha: isDark ? 0.08 : 0.06)),
    );
    // Grid lines
    for (var i = 1; i < 3; i++) {
      canvas.drawLine(
        Offset(s.width * (i / 3.0), 6),
        Offset(s.width * (i / 3.0), s.height - 6),
        _stroke(_baseWhite.withValues(alpha: isDark ? 0.08 : 0.06), 0.5),
      );
      canvas.drawLine(
        Offset(4, s.height * (i / 3.0)),
        Offset(s.width - 4, s.height * (i / 3.0)),
        _stroke(_baseWhite.withValues(alpha: isDark ? 0.08 : 0.06), 0.5),
      );
    }
    // Route path between pins
    final pinPositions = [
      Offset(s.width * 0.24, s.height * 0.37),
      Offset(s.width * 0.57, s.height * 0.56),
      Offset(s.width * 0.76, s.height * 0.24),
    ];
    final path = Path()
      ..moveTo(pinPositions[0].dx, pinPositions[0].dy)
      ..lineTo(pinPositions[1].dx, pinPositions[1].dy)
      ..lineTo(pinPositions[2].dx, pinPositions[2].dy);
    canvas.drawPath(
      path,
      _stroke(accent.withValues(alpha: 0.28), 1.0)
        ..strokeJoin = StrokeJoin.round,
    );
    // Animated map pins
    for (var i = 0; i < pinPositions.length; i++) {
      final pulse = (math.sin((t + i * 0.25) * 2 * math.pi) + 1) / 2;
      final pos = pinPositions[i];
      // Outer ring pulse
      canvas.drawCircle(
        pos,
        6.0 + pulse * 4.5,
        _fill(accent.withValues(alpha: 0.09 + pulse * 0.10)),
      );
      // Pin body
      canvas.drawCircle(pos, 3.2, _fill(accent.withValues(alpha: 0.78)));
      // Pin highlight
      canvas.drawCircle(pos, 1.4, _fill(accent2.withValues(alpha: 0.90)));
    }
  }

  void _drawCommunity(Canvas canvas, Size s) {
    final t = progress;
    // Rising feed cards
    for (var i = 0; i < 3; i++) {
      final phase = (t + i * 0.30) % 1.0;
      final y = s.height - phase * s.height * 1.15 - 8;
      final opacity = (math.sin(phase * math.pi) * 0.60).clamp(0.0, 0.60);
      final w = s.width - 18 - i * 4;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(9 + i * 2, y, w, 14),
          const Radius.circular(5),
        ),
        _fill(_baseWhite.withValues(alpha: opacity * 0.12)),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(9 + i * 2, y, w, 14),
          const Radius.circular(5),
        ),
        _stroke(
          (i % 2 == 0 ? accent : accent2).withValues(alpha: opacity * 0.45),
          0.8,
        ),
      );
    }
    // Floating reaction emoji (♥ ★ ✦)
    final icons = ['♥', '★', '✦'];
    final iconRng = math.Random(7);
    for (var i = 0; i < icons.length; i++) {
      final phase = (t + i * 0.33) % 1.0;
      final x = 10 + iconRng.nextDouble() * (s.width - 22);
      final y = s.height - phase * s.height - 4;
      final opacity = (math.sin(phase * math.pi) * 0.60).clamp(0.0, 0.60);
      TextPainter(
          text: TextSpan(
            text: icons[i],
            style: TextStyle(
              color: (i == 0 ? accent : (i == 1 ? accent2 : _baseWhite))
                  .withValues(alpha: opacity),
              fontSize: 9,
            ),
          ),
          textDirection: TextDirection.ltr,
        )
        ..layout()
        ..paint(canvas, Offset(x, y));
    }
  }

  void _drawTravelPlan(Canvas canvas, Size s) {
    final t = progress;
    final checkpoints = [
      Offset(s.width * 0.20, s.height * 0.70),
      Offset(s.width * 0.42, s.height * 0.38),
      Offset(s.width * 0.68, s.height * 0.55),
      Offset(s.width * 0.84, s.height * 0.24),
    ];

    final route = Path()..moveTo(checkpoints.first.dx, checkpoints.first.dy);
    for (var i = 1; i < checkpoints.length; i++) {
      route.lineTo(checkpoints[i].dx, checkpoints[i].dy);
    }
    canvas.drawPath(
      route,
      _stroke(accent.withValues(alpha: 0.38), 1.3)..strokeJoin = StrokeJoin.round,
    );

    for (var i = 0; i < checkpoints.length; i++) {
      final pulse = (math.sin((t + i * 0.18) * 2 * math.pi) + 1) / 2;
      final point = checkpoints[i];
      canvas.drawCircle(
        point,
        5 + pulse * 3.2,
        _fill(accent2.withValues(alpha: 0.10 + pulse * 0.18)),
      );
      canvas.drawCircle(point, 2.8, _fill(accent.withValues(alpha: 0.85)));
      canvas.drawCircle(point, 1.2, _fill(_baseWhite.withValues(alpha: 0.78)));
    }

    final progressDot = Offset(
      checkpoints.first.dx +
          (checkpoints.last.dx - checkpoints.first.dx) * ((t + 0.1) % 1.0),
      checkpoints.first.dy +
          (checkpoints.last.dy - checkpoints.first.dy) * ((t + 0.1) % 1.0),
    );
    canvas.drawCircle(progressDot, 3.1, _fill(accent2.withValues(alpha: 0.85)));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(6, 8, s.width - 12, 11),
        const Radius.circular(6),
      ),
      _fill(_baseWhite.withValues(alpha: isDark ? 0.08 : 0.06)),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(6, 8, s.width * 0.62, 11),
        const Radius.circular(6),
      ),
      _fill(accent.withValues(alpha: 0.32)),
    );
  }

  void _drawDiscussions(Canvas canvas, Size s) {
    final t = progress;
    final leftPhase = (t * 0.90) % 1.0;
    final rightPhase = ((t + 0.42) * 0.90) % 1.0;
    final leftOpacity = math.sin(leftPhase * math.pi).clamp(0.0, 0.75);
    final rightOpacity = math.sin(rightPhase * math.pi).clamp(0.0, 0.75);

    // Left bubble
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(5, 8, 38, 14),
        const Radius.circular(9),
      ),
      _fill(_baseWhite.withValues(alpha: leftOpacity * 0.16)),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(5, 8, 38, 14),
        const Radius.circular(9),
      ),
      _stroke(_baseWhite.withValues(alpha: leftOpacity * 0.52), 0.9),
    );

    // Right bubble (accent)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(s.width - 43, 28, 38, 14),
        const Radius.circular(9),
      ),
      _fill(accent.withValues(alpha: rightOpacity * 0.22)),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(s.width - 43, 28, 38, 14),
        const Radius.circular(9),
      ),
      _stroke(accent.withValues(alpha: rightOpacity * 0.62), 0.9),
    );

    // Third bubble (accent2)
    final thirdPhase = ((t + 0.75) * 0.85) % 1.0;
    final thirdOpacity = math.sin(thirdPhase * math.pi).clamp(0.0, 0.60);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(10, 48, 28, 11),
        const Radius.circular(6),
      ),
      _fill(accent2.withValues(alpha: thirdOpacity * 0.18)),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(10, 48, 28, 11),
        const Radius.circular(6),
      ),
      _stroke(accent2.withValues(alpha: thirdOpacity * 0.48), 0.7),
    );

    // Activity pulse
    final pulse = (math.sin(t * 2 * math.pi) + 1) / 2;
    canvas.drawCircle(
      Offset(s.width - 9, 7),
      5 + pulse * 3,
      _fill(accent.withValues(alpha: 0.12 + pulse * 0.16)),
    );
    canvas.drawCircle(
      Offset(s.width - 9, 7),
      3.0,
      _fill(accent.withValues(alpha: 0.60 + pulse * 0.28)),
    );
    canvas.drawCircle(
      Offset(s.width - 9, 7),
      1.3,
      _fill(Colors.white.withValues(alpha: 0.90)),
    );

    // Typing dots
    for (var d = 0; d < 3; d++) {
      final dotT = (t * 2 + d * 0.22) % 1.0;
      final yOff = math.sin(dotT * math.pi) * 2.8;
      canvas.drawCircle(
        Offset(s.width * 0.5 + (d - 1) * 7.0, s.height - 7 + yOff),
        1.8,
        _fill(_baseWhite.withValues(alpha: 0.38)),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _IllustrationPainter old) =>
      old.progress != progress || old.type != type || old.isDark != isDark;
}
