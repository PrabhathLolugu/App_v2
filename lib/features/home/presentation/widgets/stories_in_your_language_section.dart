import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/features/story_generator/domain/entities/generator_options.dart';
import 'package:myitihas/i18n/strings.g.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  LANGUAGE METADATA
//  Each language gets: a culturally resonant accent colour, the first letter
//  of its own script as a badge glyph, a transliterated script name for the
//  tagline pill, and a second (harmony) colour for the orb tint.
// ─────────────────────────────────────────────────────────────────────────────

class _LangMeta {
  final Color accent;
  final Color accent2;
  final String scriptGlyph;   // First letter in native script
  final String scriptName;    // Tagline pill (e.g. "DEVANĀGARĪ")

  const _LangMeta({
    required this.accent,
    required this.accent2,
    required this.scriptGlyph,
    required this.scriptName,
  });
}

_LangMeta _metaFor(StoryLanguage language) {
  switch (language) {
    case StoryLanguage.english:
      return const _LangMeta(
        accent: Color(0xFF3B82F6),
        accent2: Color(0xFF60A5FA),
        scriptGlyph: 'A',
        scriptName: 'LATIN',
      );
    case StoryLanguage.hindi:
      return const _LangMeta(
        accent: Color(0xFFFF9933),
        accent2: Color(0xFFFBBF24),
        scriptGlyph: 'अ',
        scriptName: 'DEVANĀGARĪ',
      );
    case StoryLanguage.tamil:
      return const _LangMeta(
        accent: Color(0xFFE63946),
        accent2: Color(0xFFFB7185),
        scriptGlyph: 'அ',
        scriptName: 'TAMIL',
      );
    case StoryLanguage.telugu:
      return const _LangMeta(
        accent: Color(0xFF22C55E),
        accent2: Color(0xFF4ADE80),
        scriptGlyph: 'అ',
        scriptName: 'TELUGU',
      );
    case StoryLanguage.bengali:
      return const _LangMeta(
        accent: Color(0xFFD84315),
        accent2: Color(0xFFF97316),
        scriptGlyph: 'অ',
        scriptName: 'BENGĀLI',
      );
    case StoryLanguage.marathi:
      return const _LangMeta(
        accent: Color(0xFFEA580C),
        accent2: Color(0xFFFB923C),
        scriptGlyph: 'अ',
        scriptName: 'DEVANĀGARĪ',
      );
    case StoryLanguage.gujarati:
      return const _LangMeta(
        accent: Color(0xFF10B981),
        accent2: Color(0xFF34D399),
        scriptGlyph: 'અ',
        scriptName: 'GUJARĀTĪ',
      );
    case StoryLanguage.kannada:
      return const _LangMeta(
        accent: Color(0xFFEF4444),
        accent2: Color(0xFFFCA5A5),
        scriptGlyph: 'ಅ',
        scriptName: 'KANNAḌA',
      );
    case StoryLanguage.malayalam:
      return const _LangMeta(
        accent: Color(0xFF0D9488),
        accent2: Color(0xFF2DD4BF),
        scriptGlyph: 'അ',
        scriptName: 'MALAYĀḶAM',
      );
    case StoryLanguage.punjabi:
      return const _LangMeta(
        accent: Color(0xFFF9A825),
        accent2: Color(0xFFFCD34D),
        scriptGlyph: 'ਅ',
        scriptName: 'GURMUKHĪ',
      );
    case StoryLanguage.odia:
      return const _LangMeta(
        accent: Color(0xFFEF6C00),
        accent2: Color(0xFFFB923C),
        scriptGlyph: 'ଅ',
        scriptName: 'OḌIĀ',
      );
    case StoryLanguage.urdu:
      return const _LangMeta(
        accent: Color(0xFF0F766E),
        accent2: Color(0xFF14B8A6),
        scriptGlyph: 'ا',
        scriptName: 'NASTAʿLĪQ',
      );
    case StoryLanguage.sanskrit:
      return const _LangMeta(
        accent: Color(0xFFB8860B),
        accent2: Color(0xFFE9C46A),
        scriptGlyph: 'अ',
        scriptName: 'DEVABHĀṢĀ',
      );
    case StoryLanguage.assamese:
      return const _LangMeta(
        accent: Color(0xFFBF360C),
        accent2: Color(0xFFEF6C00),
        scriptGlyph: 'অ',
        scriptName: 'ASSAMESE',
      );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SECTION WIDGET
// ─────────────────────────────────────────────────────────────────────────────

class StoriesInYourLanguageSection extends StatelessWidget {
  const StoriesInYourLanguageSection({super.key});

  static void _showSeeAllLanguagesSheet(BuildContext context) {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _SeeAllLanguagesSheet(
        languages: StoryLanguage.values,
        onLanguageTap: (language) {
          Navigator.pop(context);
          StoryGeneratorRoute(initialLanguageCode: language.code).push(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final t = Translations.of(context);
    final allLanguages = StoryLanguage.values;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section header ──
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              _SectionHeaderIcon(
                icon: FontAwesomeIcons.language,
                gradient: const LinearGradient(
                  colors: [Color(0xFF0891B2), Color(0xFF06B6D4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                glowColor: const Color(0xFF06B6D4),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.homeScreen.storiesInYourLanguage,
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
                      'Your mother tongue, your mythology',
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
                  colors: [Color(0xFF0891B2), Color(0xFF06B6D4)],
                ),
                onTap: () => _showSeeAllLanguagesSheet(context),
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
            physics: const BouncingScrollPhysics(),
            itemCount: allLanguages.length,
            itemBuilder: (context, index) {
              final language = allLanguages[index];
              return Padding(
                padding: EdgeInsets.only(right: 14.w),
                child: _LanguageCard(
                  language: language,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    StoryGeneratorRoute(initialLanguageCode: language.code)
                        .push(context);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  LANGUAGE CARD
//  Giant script-letter watermark, per-language gradient, orb, particles,
//  glass badge, tagline pill, display name.
//  Light theme: rich tinted fills with strong-contrast text.
//  Dark theme: deep near-black tinted fills unchanged from original.
// ─────────────────────────────────────────────────────────────────────────────

class _LanguageCard extends StatefulWidget {
  final StoryLanguage language;
  final VoidCallback onTap;

  const _LanguageCard({required this.language, required this.onTap});

  @override
  State<_LanguageCard> createState() => _LanguageCardState();
}

class _LanguageCardState extends State<_LanguageCard>
    with TickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final AnimationController _orbCtrl;
  late final AnimationController _particleCtrl;
  late final AnimationController _glyphCtrl;

  late final Animation<double> _pressScale;
  late final Animation<double> _orb;
  late final Animation<double> _glyphPulse;

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
      duration: const Duration(milliseconds: 3800),
    )..repeat(reverse: true);
    _orb = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _orbCtrl, curve: Curves.easeInOut),
    );

    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat();

    _glyphCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4500),
    )..repeat(reverse: true);
    _glyphPulse = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glyphCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    _orbCtrl.dispose();
    _particleCtrl.dispose();
    _glyphCtrl.dispose();
    super.dispose();
  }

  // Dark theme: near-black tinted gradient — unchanged from original
  List<Color> _buildDarkGradient(Color accent) {
    final hsl = HSLColor.fromColor(accent);
    final base = hsl.withLightness(0.04).withSaturation(0.88).toColor();
    final mid = hsl.withLightness(0.08).withSaturation(0.84).toColor();
    final edge = hsl.withLightness(0.13).withSaturation(0.78).toColor();
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
    final meta = _metaFor(widget.language);
    final accent = meta.accent;
    final accent2 = meta.accent2;

    final gradient = isDark
        ? _buildDarkGradient(accent)
        : _buildLightGradient(accent);

    // Light shadow is slightly more visible so card lifts off the page.
    final shadowColor = accent.withValues(alpha: isDark ? 0.30 : 0.22);

    // Light: dark-end-of-hue text for strong contrast on tinted background.
    final nameColor = isDark
        ? Colors.white.withValues(alpha: 0.96)
        : HSLColor.fromColor(accent).withLightness(0.10).toColor();

    final displayName = widget.language.displayName;

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

                // ── Light mode: subtle inner highlight (top-left corner only,
                //    reduced opacity so it doesn't bleach the tinted fill) ──
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
                        seed: widget.language.hashCode,
                        count: 9,
                      ),
                    ),
                  ),
                ),

                // ── Breathing orb (top-right) ──
                AnimatedBuilder(
                  animation: _orb,
                  builder: (_, __) {
                    final sz = 90.w + _orb.value * 14.w;
                    // Light orb is more visible against the tinted fill.
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
                              accent2.withValues(alpha: alpha * 0.30),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.55, 1.0],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // ── Pulsing script watermark — more visible in light mode ──
                AnimatedBuilder(
                  animation: _glyphPulse,
                  builder: (_, __) {
                    final alpha = isDark
                        ? 0.07 + _glyphPulse.value * 0.04
                        : 0.10 + _glyphPulse.value * 0.05;
                    return Positioned(
                      bottom: -10.h,
                      right: -8.w,
                      child: Text(
                        meta.scriptGlyph,
                        style: TextStyle(
                          fontSize: 80.sp,
                          fontWeight: FontWeight.w900,
                          color: accent.withValues(alpha: alpha),
                          height: 1.0,
                        ),
                      ),
                    );
                  },
                ),

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
                            .withValues(alpha: isDark ? 0.28 : 0.32),
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
                        // Script glyph badge (glass container)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(13.r),
                          child: BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                            child: Container(
                              width: 42.w,
                              height: 42.w,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(13.r),
                                color: accent.withValues(
                                  alpha: isDark ? 0.16 : 0.14,
                                ),
                                border: Border.all(
                                  color: accent.withValues(
                                    alpha: isDark ? 0.38 : 0.40,
                                  ),
                                  width: 0.9,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: accent.withValues(
                                      alpha: isDark ? 0.28 : 0.20,
                                    ),
                                    blurRadius: 10,
                                    spreadRadius: -2,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  meta.scriptGlyph,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w800,
                                    // Light: use dark end of hue for glyph
                                    color: isDark
                                        ? accent
                                        : HSLColor.fromColor(accent)
                                            .withLightness(0.16)
                                            .toColor(),
                                    height: 1.15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const Spacer(),

                        // Script name tagline pill
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            color: accent.withValues(
                              alpha: isDark ? 0.12 : 0.14,
                            ),
                            border: Border.all(
                              color: accent.withValues(
                                alpha: isDark ? 0.32 : 0.40,
                              ),
                              width: 0.75,
                            ),
                          ),
                          child: Text(
                            meta.scriptName,
                            style: TextStyle(
                              // Light: full opacity for crisp pill text
                              color: isDark
                                  ? accent.withValues(alpha: 0.88)
                                  : HSLColor.fromColor(accent)
                                      .withLightness(0.18)
                                      .toColor(),
                              fontWeight: FontWeight.w800,
                              fontSize: 7.sp,
                              letterSpacing: 0.7,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        SizedBox(height: 5.h),

                        // Display name
                        Text(
                          displayName,
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            fontSize: 14.sp,
                            letterSpacing: -0.3,
                            height: 1.1,
                            color: nameColor,
                            shadows: isDark
                                ? [
                                    Shadow(
                                      color:
                                          accent.withValues(alpha: 0.40),
                                      blurRadius: 10,
                                    ),
                                  ]
                                : null,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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

class _SeeAllLanguagesSheet extends StatefulWidget {
  final List<StoryLanguage> languages;
  final ValueChanged<StoryLanguage> onLanguageTap;

  const _SeeAllLanguagesSheet({
    required this.languages,
    required this.onLanguageTap,
  });

  @override
  State<_SeeAllLanguagesSheet> createState() => _SeeAllLanguagesSheetState();
}

class _SeeAllLanguagesSheetState extends State<_SeeAllLanguagesSheet> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final filtered = widget.languages
        .where(
          (l) => l.displayName
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()),
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
                  icon: FontAwesomeIcons.language,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0891B2), Color(0xFF06B6D4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  glowColor: const Color(0xFF06B6D4),
                  size: 36.w,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    Translations.of(context).homeScreen.storiesInYourLanguage,
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
              hint: Translations.of(context).homeScreen.searchLanguages,
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          // Grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 30.h),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.22,
                crossAxisSpacing: 14.w,
                mainAxisSpacing: 14.h,
              ),
              itemCount: filtered.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final language = filtered[index];
                return _LanguageCard(
                  language: language,
                  onTap: () => widget.onLanguageTap(language),
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
//  SHARED HEADER COMPONENTS
// ─────────────────────────────────────────────────────────────────────────────

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
//  PARTICLE PAINTER
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
    this.count = 9,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(seed);
    final maxOpacity = isDark ? 0.42 : 0.28;

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