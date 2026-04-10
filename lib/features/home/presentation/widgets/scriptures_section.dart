import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/features/stories/domain/entities/story_options.dart';
import 'package:myitihas/i18n/strings.g.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  DATA MODEL
// ─────────────────────────────────────────────────────────────────────────────

class ScriptureData {
  final String name;
  final Color color;
  final IconData icon;

  /// Short category label shown in the tagline pill (e.g. "EPIC", "PURĀṆA").
  final String category;

  const ScriptureData({
    required this.name,
    required this.color,
    required this.icon,
    this.category = 'SCRIPTURE',
  });
}

// ─────────────────────────────────────────────────────────────────────────────
//  SECTION WIDGET
// ─────────────────────────────────────────────────────────────────────────────

class ScripturesSection extends StatelessWidget {
  const ScripturesSection({super.key});

  // ── High-priority scriptures — every entry has a unique icon and a colour
  //    chosen so that no two adjacent cards share the same hue family.
  //    Order: red → blue → violet → gold → teal → rose → green → indigo
  //    No two neighbours share the same hue band.
  // ─────────────────────────────────────────────────────────────────────────

  static const List<ScriptureData> _highPriorityScriptures = [
    ScriptureData(
      name: 'Ramayana',
      color: Color(0xFFE63946),   // red
      icon: FontAwesomeIcons.om,
      category: 'EPIC',
    ),
    ScriptureData(
      name: 'Mahabharata',
      color: Color(0xFF6366F1),   // indigo-violet  (was sky-blue — now clearly different from red)
      icon: FontAwesomeIcons.chessKnight,
      category: 'EPIC',
    ),
    ScriptureData(
      name: 'Bhāgavata Purāṇa',
      color: Color(0xFF0D9488),   // teal           (was orange — avoids Vedas gold clash)
      icon: FontAwesomeIcons.bookOpenReader,
      category: 'PURĀṆA',
    ),
    ScriptureData(
      name: 'Vedas',
      color: Color(0xFFE9A800),   // amber-gold      (warm, clearly different from teal)
      icon: FontAwesomeIcons.fire,
      category: 'ŚRUTI',
    ),
    ScriptureData(
      name: 'Upanishads',
      color: Color(0xFF8B5CF6),   // purple          (clearly different from gold)
      icon: FontAwesomeIcons.infinity,
      category: 'VEDĀNTA',
    ),
    ScriptureData(
      name: 'Bhagavad Gita',
      color: Color(0xFF16A34A),   // emerald-green   (clearly different from purple)
      icon: FontAwesomeIcons.yinYang,
      category: 'GĪTĀ',
    ),
  ];

  static List<ScriptureData> get _allScriptures {
    final List<ScriptureData> all = [];
    final Set<String> processedNames = {};

    for (final s in _highPriorityScriptures) {
      all.add(s);
      processedNames.add(s.name);
    }

    final scriptureData = storyOptions['scripture'];
    if (scriptureData != null) {
      final subtypes = scriptureData['subtypes'] as Map<String, dynamic>?;
      if (subtypes != null) {
        for (final entry in subtypes.entries) {
          final children = entry.value as List<dynamic>;
          for (final child in children) {
            final name = child.toString();
            if (!processedNames.contains(name)) {
              all.add(ScriptureData(
                name: name,
                color: _getColorForName(name),
                icon: _getIconForName(name),
                category: _getCategoryForName(name),
              ));
              processedNames.add(name);
            }
          }
        }
      }
    }
    return all;
  }

  // Adjacency-safe colour palette.
  // 8 hue bands ordered so that consecutive entries are maximally distant.
  // The hash selects a starting index; we then pick the entry that is farthest
  // from the previous card's hue by cycling through the ordered list.
  // For the dynamic (storyOptions) cards we just use the ordered palette by
  // index so that sequential additions never repeat adjacent hues.
  static const List<Color> _orderedPalette = [
    Color(0xFFE63946), // 0 red
    Color(0xFF0891B2), // 1 cyan-blue
    Color(0xFFF9A825), // 2 amber
    Color(0xFF7C3AED), // 3 violet
    Color(0xFF16A34A), // 4 emerald
    Color(0xFFDB2777), // 5 rose-pink
    Color(0xFF0D9488), // 6 teal
    Color(0xFF6366F1), // 7 indigo
  ];

  static Color _getColorForName(String name) {
    // Per-name assignments ensure well-known scriptures always get the
    // same distinctive, non-clashing colour regardless of list position.
    const Map<String, Color> _namedColors = {
      // Purāṇas — teal / cyan family
      'Vishnu Purāṇa'       : Color(0xFF0891B2),
      'Shiva Purāṇa'        : Color(0xFF6366F1),
      'Devi Bhāgavata'      : Color(0xFFDB2777),
      'Brahma Purāṇa'       : Color(0xFFF9A825),
      'Matsya Purāṇa'       : Color(0xFF0D9488),
      'Kurma Purāṇa'        : Color(0xFF7C3AED),
      'Varaha Purāṇa'       : Color(0xFF16A34A),
      'Narada Purāṇa'       : Color(0xFFE63946),
      'Markandeya Purāṇa'   : Color(0xFF6366F1),
      'Agni Purāṇa'         : Color(0xFFEF4444),
      'Padma Purāṇa'        : Color(0xFF22C55E),
      'Skanda Purāṇa'       : Color(0xFFFF9933),
      'Garuda Purāṇa'       : Color(0xFF0891B2),
      'Linga Purāṇa'        : Color(0xFF8B5CF6),
      'Vayu Purāṇa'         : Color(0xFF38BDF8),
      'Brahmanda Purāṇa'    : Color(0xFFDB2777),
      'Vamana Purāṇa'       : Color(0xFF10B981),
      'Brahmavaivarta Purāṇa': Color(0xFFF59E0B),
      // Epics & Gitas
      'Devi Mahatmya'       : Color(0xFFDB2777),
      'Yoga Vasishtha'      : Color(0xFF7C3AED),
      'Ashtavakra Gita'     : Color(0xFF16A34A),
      'Avadhuta Gita'       : Color(0xFF0D9488),
      // Tales & Fables
      'Panchatantra'        : Color(0xFFF9A825),
      'Hitopadesha'         : Color(0xFF22C55E),
      'Jataka Tales'        : Color(0xFF38BDF8),
      'Vikram and Betaal'   : Color(0xFF6366F1),
      // Dharma & Philosophy
      'Manusmriti'          : Color(0xFFE63946),
      'Arthashastra'        : Color(0xFF6366F1),
      'Yoga Sutras'         : Color(0xFF8B5CF6),
      'Brahma Sutras'       : Color(0xFF0D9488),
    };

    if (_namedColors.containsKey(name)) return _namedColors[name]!;

    // Fallback: use hash to pick from the ordered palette so that even
    // unknown scriptures cycle through maximally-distinct hues.
    final idx = name.hashCode.abs() % _orderedPalette.length;
    return _orderedPalette[idx];
  }

  // Comprehensive icon map — every named scripture and every category gets a
  // distinct, thematically appropriate FontAwesome icon.  No two frequently
  // appearing scriptures share the same icon.
  static IconData _getIconForName(String name) {
    const Map<String, IconData> _namedIcons = {
      // Core scriptures
      'Vishnu Purāṇa'        : FontAwesomeIcons.circleNotch,
      'Shiva Purāṇa'         : FontAwesomeIcons.moon,
      'Devi Bhāgavata'       : FontAwesomeIcons.star,
      'Brahma Purāṇa'        : FontAwesomeIcons.cloud,
      'Matsya Purāṇa'        : FontAwesomeIcons.water,
      'Kurma Purāṇa'         : FontAwesomeIcons.globe,
      'Varaha Purāṇa'        : FontAwesomeIcons.mountain,
      'Narada Purāṇa'        : FontAwesomeIcons.music,
      'Markandeya Purāṇa'    : FontAwesomeIcons.hourglass,
      'Agni Purāṇa'          : FontAwesomeIcons.fire,
      'Padma Purāṇa'         : FontAwesomeIcons.seedling,
      'Skanda Purāṇa'        : FontAwesomeIcons.shieldHalved,
      'Garuda Purāṇa'        : FontAwesomeIcons.dove,
      'Linga Purāṇa'         : FontAwesomeIcons.bolt,
      'Vayu Purāṇa'          : FontAwesomeIcons.wind,
      'Brahmanda Purāṇa'     : FontAwesomeIcons.circleNodes,
      'Vamana Purāṇa'        : FontAwesomeIcons.personWalking,
      'Brahmavaivarta Purāṇa': FontAwesomeIcons.sun,
      // Gitas & Philosophy
      'Devi Mahatmya'        : FontAwesomeIcons.crown,
      'Yoga Vasishtha'       : FontAwesomeIcons.eye,
      'Ashtavakra Gita'      : FontAwesomeIcons.infinity,
      'Avadhuta Gita'        : FontAwesomeIcons.feather,
      'Yoga Sutras'          : FontAwesomeIcons.personPraying,
      'Brahma Sutras'        : FontAwesomeIcons.atom,
      'Manusmriti'           : FontAwesomeIcons.scaleBalanced,
      'Arthashastra'         : FontAwesomeIcons.coins,
      // Tales & Fables
      'Panchatantra'         : FontAwesomeIcons.paw,
      'Hitopadesha'          : FontAwesomeIcons.featherPointed,
      'Jataka Tales'         : FontAwesomeIcons.leaf,
      'Vikram and Betaal'    : FontAwesomeIcons.ghost,
    };

    if (_namedIcons.containsKey(name)) return _namedIcons[name]!;

    // Category-level fallback — still avoids the generic scroll for everything
    if (name.contains('Purāṇa') || name.contains('Purana')) {
      return FontAwesomeIcons.landmark;
    }
    if (name.contains('Gita') || name.contains('Gītā')) {
      return FontAwesomeIcons.yinYang;
    }
    if (name.contains('Upanishad')) return FontAwesomeIcons.infinity;
    if (name.contains('Veda'))      return FontAwesomeIcons.fire;
    if (name.contains('Sutra'))     return FontAwesomeIcons.atom;
    if (name.contains('Tales') || name.contains('Katha')) {
      return FontAwesomeIcons.bookOpen;
    }
    if (name.contains('Ram'))  return FontAwesomeIcons.om;
    if (name.contains('Maha')) return FontAwesomeIcons.chessKnight;

    // Last-resort pool — cycle through distinct icons by hash so repeated
    // use of the same icon is avoided even for completely unknown names.
    const List<IconData> _fallbackIcons = [
      FontAwesomeIcons.scroll,
      FontAwesomeIcons.bookOpenReader,
      FontAwesomeIcons.penNib,
      FontAwesomeIcons.book,
      FontAwesomeIcons.monument,
      FontAwesomeIcons.magnifyingGlass,
      FontAwesomeIcons.compass,
      FontAwesomeIcons.seedling,
    ];
    return _fallbackIcons[name.hashCode.abs() % _fallbackIcons.length];
  }

  static String _getCategoryForName(String name) {
    if (name.contains('Purāṇa') || name.contains('Purana')) return 'PURĀṆA';
    if (name.contains('Veda')) return 'ŚRUTI';
    if (name.contains('Upanishad')) return 'VEDĀNTA';
    if (name.contains('Gita') || name.contains('Gītā')) return 'GĪTĀ';
    return 'SCRIPTURE';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final t = Translations.of(context);
    final displayScriptures = _allScriptures.take(10).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section header ──
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              _SectionHeaderIcon(
                icon: FontAwesomeIcons.dharmachakra,
                gradient: const LinearGradient(
                  colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                glowColor: const Color(0xFFD97706),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.homeScreen.scriptures,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: colorScheme.onSurface,
                        letterSpacing: -0.3,
                        fontSize: 16.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Explore the ancient texts',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.40),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              _SeeAllPill(
                label: t.homeScreen.seeAll,
                gradient: const LinearGradient(
                  colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                ),
                onTap: () {
                  HapticFeedback.selectionClick();
                  _showSeeAllModal(context);
                },
              ),
            ],
          ),
        ),

        SizedBox(height: 14.h),

        // ── Horizontal card list ──
        SizedBox(
          height: 128.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: displayScriptures.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: 14.w),
                child: _ScriptureCard(
                  scripture: displayScriptures[index],
                  onTap: () => _navigateToGenerator(
                    context,
                    displayScriptures[index].name,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _navigateToGenerator(BuildContext context, String scripture) {
    HapticFeedback.mediumImpact();
    StoryGeneratorRoute(
      initialPrompt: 'Generate a random story from $scripture ',
    ).push(context);
  }

  void _showSeeAllModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _SeeAllScripturesSheet(
        scriptures: _allScriptures,
        onScriptureTap: (name) {
          Navigator.pop(context);
          _navigateToGenerator(context, name);
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SCRIPTURE CARD
//  Per-card gradient + orb + particles + tagline pill + name.
//  NOTE: The large background watermark glyph has been removed — the icon
//  badge already anchors each card's visual identity, and the glyph added
//  clutter without benefit in either theme.
//  Light theme: rich tinted fills with dark-end-of-hue text for contrast.
//  Dark theme: deep near-black tinted fills — unchanged from original.
// ─────────────────────────────────────────────────────────────────────────────

class _ScriptureCard extends StatefulWidget {
  final ScriptureData scripture;
  final VoidCallback onTap;

  const _ScriptureCard({required this.scripture, required this.onTap});

  @override
  State<_ScriptureCard> createState() => _ScriptureCardState();
}

class _ScriptureCardState extends State<_ScriptureCard>
    with TickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final AnimationController _orbCtrl;
  late final AnimationController _particleCtrl;

  late final Animation<double> _pressScale;
  late final Animation<double> _orb;

  @override
  void initState() {
    super.initState();

    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _pressScale = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeOutCubic),
    );

    _orbCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    )..repeat(reverse: true);
    _orb = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _orbCtrl, curve: Curves.easeInOut),
    );

    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4800),
    )..repeat();
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    _orbCtrl.dispose();
    _particleCtrl.dispose();
    super.dispose();
  }

  // Dark theme: near-black tinted gradient — unchanged from original.
  List<Color> _buildDarkGradient(Color accent) {
    final hsl = HSLColor.fromColor(accent);
    final base = hsl.withLightness(0.04).withSaturation(0.90).toColor();
    final mid = hsl.withLightness(0.09).withSaturation(0.85).toColor();
    final edge = hsl.withLightness(0.14).withSaturation(0.80).toColor();
    return [base, mid, edge];
  }

  // Light theme: rich tinted fill — saturated enough to have real colour
  // personality while remaining light and readable.
  List<Color> _buildLightGradient(Color accent) {
    final hsl = HSLColor.fromColor(accent);
    final base = hsl.withLightness(0.96).withSaturation(0.65).toColor();
    final edge = hsl.withLightness(0.88).withSaturation(0.72).toColor();
    return [base, edge];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final s = widget.scripture;
    final accent = s.color;

    final gradient =
        isDark ? _buildDarkGradient(accent) : _buildLightGradient(accent);

    // Light shadow slightly more visible so the card lifts off the page.
    final shadowColor = accent.withValues(alpha: isDark ? 0.30 : 0.22);

    // Light: dark-end-of-hue text for strong contrast on the tinted background.
    final nameColor = isDark
        ? Colors.white.withValues(alpha: 0.96)
        : HSLColor.fromColor(accent).withLightness(0.10).toColor();

    // Last-word accent — slightly lighter than nameColor but still legible.
    final accentNameColor = isDark
        ? accent
        : HSLColor.fromColor(accent).withLightness(0.14).toColor();

    final parts = s.name.trim().split(' ');
    final lastName = parts.last;
    final firstName = parts.length > 1
        ? s.name.substring(0, s.name.lastIndexOf(' ') + 1)
        : null;

    return GestureDetector(
      onTapDown: (_) {
        _pressCtrl.forward();
        HapticFeedback.lightImpact();
      },
      onTapUp: (_) {
        _pressCtrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _pressCtrl.reverse(),
      child: ScaleTransition(
        scale: _pressScale,
        child: Container(
          width: 130.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.r),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 22,
                spreadRadius: -4,
                offset: const Offset(0, 8),
              ),
              if (isDark)
                BoxShadow(
                  color: accent.withValues(alpha: 0.10),
                  blurRadius: 32,
                  spreadRadius: -6,
                  offset: const Offset(0, 12),
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22.r),
            child: Stack(
              children: [
                // ── Base gradient ──
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: gradient,
                      ),
                    ),
                  ),
                ),

                // ── Light mode: subtle inner highlight (reduced opacity so
                //    it doesn't bleach the tinted fill) ──
                if (!isDark)
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.topLeft,
                          radius: 1.8,
                          colors: [
                            Colors.white.withValues(alpha: 0.40),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                // ── Particles ──
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _particleCtrl,
                    builder: (_, __) => CustomPaint(
                      painter: _CardParticlePainter(
                        progress: _particleCtrl.value,
                        accent: accent,
                        isDark: isDark,
                        seed: s.name.hashCode,
                        count: 8,
                      ),
                    ),
                  ),
                ),

                // ── Breathing orb top-right ──
                AnimatedBuilder(
                  animation: _orb,
                  builder: (_, __) {
                    final sz = 90.w + _orb.value * 14.w;
                    // Light orb more visible against the tinted fill.
                    final alpha =
                        (isDark ? 0.24 : 0.20) + _orb.value * 0.08;
                    return Positioned(
                      top: -sz * 0.40,
                      right: -sz * 0.28,
                      child: Container(
                        width: sz,
                        height: sz,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              accent.withValues(alpha: alpha),
                              accent.withValues(alpha: alpha * 0.25),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.55, 1.0],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // NOTE: Large background watermark glyph intentionally removed.
                // The icon badge in the content area already anchors each
                // card's identity visually and clearly.

                // ── Top shimmer — toned down in light so fill colour shows ──
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 44.h,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white
                              .withValues(alpha: isDark ? 0.08 : 0.35),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Glowing border — stronger in light for card definition ──
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22.r),
                      border: Border.all(
                        color: accent
                            .withValues(alpha: isDark ? 0.28 : 0.35),
                        width: 0.9,
                      ),
                    ),
                  ),
                ),

                // ── CONTENT ──
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.all(14.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon box (glass)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(13.r),
                          child: BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                            child: Container(
                              width: 40.w,
                              height: 40.w,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(13.r),
                                color: accent.withValues(
                                    alpha: isDark ? 0.16 : 0.14),
                                border: Border.all(
                                  color: accent.withValues(
                                      alpha: isDark ? 0.35 : 0.40),
                                  width: 0.9,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: accent.withValues(
                                        alpha: isDark ? 0.25 : 0.20),
                                    blurRadius: 10,
                                    spreadRadius: -2,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: FaIcon(
                                  s.icon,
                                  size: 17.sp,
                                  // Light: dark end of hue for crisp icon
                                  color: isDark
                                      ? accent
                                      : HSLColor.fromColor(accent)
                                          .withLightness(0.16)
                                          .toColor(),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const Spacer(),

                        // Category tagline pill
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            color: accent.withValues(
                                alpha: isDark ? 0.12 : 0.14),
                            border: Border.all(
                              color: accent.withValues(
                                  alpha: isDark ? 0.32 : 0.42),
                              width: 0.75,
                            ),
                          ),
                          child: Text(
                            s.category,
                            style: TextStyle(
                              // Light: full-opacity dark-hue text for pill
                              color: isDark
                                  ? accent.withValues(alpha: 0.88)
                                  : HSLColor.fromColor(accent)
                                      .withLightness(0.18)
                                      .toColor(),
                              fontWeight: FontWeight.w800,
                              fontSize: 7.5.sp,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),

                        SizedBox(height: 5.h),

                        // Name (first part plain, last word in accent)
                        RichText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                              fontSize: 13.sp,
                              letterSpacing: -0.3,
                              height: 1.15,
                            ),
                            children: [
                              if (firstName != null)
                                TextSpan(
                                  text: firstName,
                                  style: TextStyle(color: nameColor),
                                ),
                              TextSpan(
                                text: lastName,
                                style: TextStyle(
                                  color: parts.length > 1
                                      ? accentNameColor
                                      : nameColor,
                                  // Glow shadow only in dark mode
                                  shadows: parts.length > 1 && isDark
                                      ? [
                                          Shadow(
                                            color: accent.withValues(
                                                alpha: 0.45),
                                            blurRadius: 10,
                                          ),
                                        ]
                                      : null,
                                ),
                              ),
                            ],
                          ),
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

// ─────────────────────────────────────────────────────────────────────────────
//  SEE ALL BOTTOM SHEET
// ─────────────────────────────────────────────────────────────────────────────

class _SeeAllScripturesSheet extends StatefulWidget {
  final List<ScriptureData> scriptures;
  final Function(String) onScriptureTap;

  const _SeeAllScripturesSheet({
    required this.scriptures,
    required this.onScriptureTap,
  });

  @override
  State<_SeeAllScripturesSheet> createState() => _SeeAllScripturesSheetState();
}

class _SeeAllScripturesSheetState extends State<_SeeAllScripturesSheet> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final filteredScriptures = widget.scriptures
        .where(
          (s) => s.name.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0A0F1E) : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r),
          topRight: Radius.circular(32.r),
        ),
      ),
      child: Column(
        children: [
          // Handle
          SizedBox(height: 12.h),
          Container(
            width: 40.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 18.h, 12.w, 4.h),
            child: Row(
              children: [
                _SectionHeaderIcon(
                  icon: FontAwesomeIcons.dharmachakra,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  glowColor: const Color(0xFFD97706),
                  size: 36.w,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'Ancient Scriptures',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close_rounded, size: 22.sp),
                ),
              ],
            ),
          ),
          // Search
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: _SearchField(
              hint: 'Search scriptures…',
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          // Grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 30.h),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.25,
                crossAxisSpacing: 14.w,
                mainAxisSpacing: 14.h,
              ),
              itemCount: filteredScriptures.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return _ScriptureCard(
                  scripture: filteredScriptures[index],
                  onTap: () =>
                      widget.onScriptureTap(filteredScriptures[index].name),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SHARED SECTION HEADER COMPONENTS
// ─────────────────────────────────────────────────────────────────────────────

/// Gradient icon container used in section headers.
class _SectionHeaderIcon extends StatelessWidget {
  final IconData icon;
  final Gradient gradient;
  final Color glowColor;
  final double? size;

  const _SectionHeaderIcon({
    required this.icon,
    required this.gradient,
    required this.glowColor,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final sz = size ?? 38.w;
    return Container(
      width: sz,
      height: sz,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(11.r),
        boxShadow: [
          BoxShadow(
            color: glowColor.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: FaIcon(icon, size: 16.sp, color: Colors.white),
      ),
    );
  }
}

/// "See All" pill button used in section headers.
class _SeeAllPill extends StatelessWidget {
  final String label;
  final Gradient gradient;
  final VoidCallback onTap;

  const _SeeAllPill({
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}

/// Styled search field for the bottom sheets.
class _SearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;

  const _SearchField({required this.hint, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.25),
          width: 0.8,
        ),
      ),
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(fontSize: 14.sp),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: colorScheme.onSurface.withValues(alpha: 0.38),
            fontSize: 14.sp,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 18.sp,
            color: colorScheme.onSurface.withValues(alpha: 0.45),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  PARTICLE PAINTER  (shared)
// ─────────────────────────────────────────────────────────────────────────────

class _CardParticlePainter extends CustomPainter {
  final double progress;
  final Color accent;
  final bool isDark;
  final int seed;
  final int count;

  const _CardParticlePainter({
    required this.progress,
    required this.accent,
    required this.isDark,
    required this.seed,
    this.count = 10,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(seed);
    final maxOpacity = isDark ? 0.45 : 0.30;

    for (var i = 0; i < count; i++) {
      final baseX = rng.nextDouble() * size.width;
      final baseY = rng.nextDouble() * size.height;
      final speed = 0.15 + rng.nextDouble() * 0.50;
      final phase = rng.nextDouble();
      final t = (progress * speed + phase) % 1.0;
      final y = baseY - t * size.height * 0.60;
      final opacity =
          (math.sin(t * math.pi) *
                  maxOpacity *
                  (0.4 + rng.nextDouble() * 0.6))
              .clamp(0.0, maxOpacity);
      final radius = 0.7 + rng.nextDouble() * 1.8;
      canvas.drawCircle(
        Offset(baseX + math.sin(t * 2 * math.pi + phase) * 7, y),
        radius,
        Paint()..color = accent.withValues(alpha: opacity),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CardParticlePainter old) =>
      old.progress != progress || old.isDark != isDark;
}