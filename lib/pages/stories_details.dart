import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myitihas/core/widgets/image_loading_placeholder/image_loading_placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myitihas/utils/constants.dart';

class StoryDetailsView extends StatelessWidget {
  final Map<String, dynamic> storyData;

  const StoryDetailsView({super.key, required this.storyData});

  @override
  Widget build(BuildContext context) {
    // Hardcoded data based on the screenshot/request if not provided
    final String title = storyData['title'] ?? 'Untitled Story';
    final String scripture = storyData['scripture'] ?? 'Bhagavad Gita';
    final String message = storyData['message'] ?? 'Bhagavad Gita';
    final String imageUrl =
        storyData['imageUrl'] ??
        'https://myitihas.com/img/ramayan-1.png'; // Placeholder
    final String learning =
        storyData['learning'] ??
        "Unity creates unbreakable strength while division leads to vulnerability; a kingdom's true power lies in its people's harmony.";

    bool isDark = Theme.of(context).brightness == Brightness.dark;
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;
    // double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Theme.of(context).primaryColor.withAlpha(5),
              Theme.of(context).brightness == Brightness.dark
                  ? Color(0xFF1E293B)
                  : Color(0xFFF1F5F9),
            ],
            transform: GradientRotation(3.14 / 1.5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: aspectRatio * 130),
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: aspectRatio > 0.5 ? 32 : 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: aspectRatio * 50),
                    Text(
                      message,
                      style: GoogleFonts.inter(
                        fontSize: aspectRatio > 0.5 ? 18 : 16,
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: aspectRatio * 50),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? DarkColors.glassBorder
                              : LightColors.glassBorder,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.fill,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const ImageLoadingPlaceholder();
                          },
                          errorBuilder: (c, o, s) => Container(
                            color: Colors.grey[800],
                            child: Center(
                              child: Icon(
                                Icons.image,
                                size: 50,
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: aspectRatio * 50),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: aspectRatio * 20,
                        horizontal: aspectRatio * 20,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? DarkColors.glowPrimary
                            : LightColors.glowPrimary,
                        border: Border(
                          top: BorderSide(
                            color: isDark
                                ? DarkColors.glassBorder
                                : LightColors.glassBorder,
                            width: 1.5,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        scripture,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: aspectRatio > 0.5 ? 16 : 14,
                          color: isDark
                              ? DarkColors.textPrimary
                              : LightColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: aspectRatio * 50),
                    Container(
                      padding: EdgeInsets.all(aspectRatio * 20),
                      decoration: BoxDecoration(
                        color: isDark
                            ? DarkColors.glowPrimary
                            : LightColors.glowPrimary,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark
                              ? DarkColors.glassBorder
                              : LightColors.glassBorder,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Key Learnings From The Story",
                            style: GoogleFonts.inter(
                              fontSize: aspectRatio > 0.5 ? 19 : 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF38BDF8),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: aspectRatio * 10),
                          Text(
                            learning,
                            style: GoogleFonts.inter(
                              fontSize: aspectRatio > 0.5 ? 16 : 14,
                              color: isDark
                                  ? DarkColors.textPrimary
                                  : LightColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: aspectRatio * 50),
                    Text(
                      "✨ Story Insights & Interactions",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: aspectRatio > 0.5 ? 22 : 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFA78BFA),
                      ),
                    ),
                    SizedBox(height: aspectRatio * 30),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: aspectRatio * 20,
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Wrap(
                            spacing: aspectRatio > 0.5 ? 20 : 10,
                            runSpacing: aspectRatio > 0.5 ? 20 : 10,
                            alignment: WrapAlignment.center,
                            children: [
                              _buildInteractionCard(
                                title: "Expand Story",
                                description:
                                    "Continue the narrative with the next chapter of your tale",
                                icon: Icons.fullscreen,
                                buttonText: "Continue Story",
                                buttonColor: Color(0xFF38BDF8),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                isDark: isDark,
                              ),
                              _buildInteractionCard(
                                title: "Character Details",
                                description:
                                    "Explore the personalities and roles of story characters",
                                icon: Icons.person_outline,
                                buttonText:
                                    "Coming Soon", // Mocked as select in screenshot but simplified here
                                buttonColor: Colors.transparent,
                                isOutline: true,
                                isDark: isDark,
                              ),
                              _buildInteractionCard(
                                title: "Discuss Story",
                                description:
                                    "Chat about themes, meanings, and interpretations",
                                icon: CupertinoIcons.chat_bubble_2,
                                buttonText: "Start Discussion",
                                buttonColor: Color(0xFFA78BFA),
                                isDark: isDark,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                bottom: aspectRatio * 40,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: aspectRatio * 30,
                      vertical: aspectRatio * 15,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? DarkColors.glassBg : LightColors.glassBg,
                      borderRadius: BorderRadius.circular(aspectRatio * 30),
                      border: Border.all(
                        color: isDark
                            ? DarkColors.glassBorder
                            : LightColors.glassBorder,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).primaryColor,
                          blurRadius: 300,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildBottomAction(Icons.flag_rounded, "English"),
                          SizedBox(width: aspectRatio * 12),
                          Container(
                            width: 1,
                            height: aspectRatio * 80,
                            color: Colors.white24,
                          ),
                          SizedBox(width: aspectRatio * 12),
                          _buildBottomIconButton(Icons.bookmark_border),
                          _buildBottomIconButton(Icons.thumb_down_outlined),
                          _buildBottomIconButton(Icons.volume_up_outlined),
                          _buildBottomIconButton(Icons.refresh),
                          _buildBottomIconButton(Icons.download_outlined),
                          _buildBottomIconButton(Icons.copy_rounded),
                          _buildBottomIconButton(Icons.share),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInteractionCard({
    required String title,
    required String description,
    required IconData icon,
    required String buttonText,
    required Color buttonColor,
    bool isOutline = false,
    VoidCallback? onTap,
    bool isDark = false,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark
            ? DarkColors.glassBg.withAlpha(50)
            : LightColors.glassBg.withAlpha(50),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: LightColors.accentPrimary.withAlpha(50),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: isOutline ? Colors.white70 : buttonColor),
          SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Text(
            description,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white60,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isOutline ? Colors.transparent : buttonColor,
                borderRadius: BorderRadius.circular(8),
                border: isOutline ? Border.all(color: Colors.white30) : null,
                gradient: !isOutline
                    ? LinearGradient(
                        colors: [
                          buttonColor,
                          buttonColor.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
              ),
              child: Center(
                child: Text(
                  buttonText,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white), // Flag icon usually
        SizedBox(width: 6),
        Text(text, style: GoogleFonts.inter(color: Colors.white, fontSize: 13)),
        Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.white54),
      ],
    );
  }

  Widget _buildBottomIconButton(IconData icon) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 18, color: Colors.white70),
    );
  }
}
