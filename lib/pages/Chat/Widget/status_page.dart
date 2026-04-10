import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:myitihas/utils/constants.dart';
import 'package:sizer/sizer.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? DarkColors.textPrimary : LightColors.textPrimary;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Video Status", isDark, textColor),
          SizedBox(height: 0.5.h),

          _videoStatusSection(isDark, textColor),
          SizedBox(height: 1.h),

          _sectionTitle("Recent Updates", isDark, textColor),
          SizedBox(height: 1.5.h),

          _otherStoriesGrid(isDark, textColor),
          SizedBox(height: 2.h),

          _sectionTitle("Voice Notes (24 hours)", isDark, textColor),
          SizedBox(height: 1.5.h),

          _addVoiceNoteCard(isDark, textColor),
          SizedBox(height: 1.h),

          _voiceNoteItem("Guru Nanak's Wisdom", isDark, textColor),
          _voiceNoteItem("Mirabai's Bhajans", isDark, textColor),
          _voiceNoteItem("Kabir's Teachings", isDark, textColor),
          SizedBox(height: 12.h), // Space for bottom nav
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, bool isDark, final textColor) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _videoStatusSection(bool isDark, final textColor) {
    final List<Map<String, String>> statusData = [
      {"name": "You", "img": ""},
      {"name": "Ashoka ", "img": "https://i.pravatar.cc/150?u=1"},
      {"name": "Akbar", "img": "https://i.pravatar.cc/150?u=2"},
      {"name": "Tipu", "img": "https://i.pravatar.cc/150?u=3"},
      {"name": "Rani", "img": "https://i.pravatar.cc/150?u=4"},
    ];

    return SizedBox(
      height: 12.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: statusData.length,
        itemBuilder: (context, index) {
          bool isMe = index == 0;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Column(
              children: [
                SizedBox(height: 1.h),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.cyanAccent, Colors.blueAccent.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: DarkColors.accentPrimary.withValues(alpha: 0.3),
                        blurRadius: 5,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 22.sp,
                    backgroundColor: const Color(0xFF1A2233),
                    backgroundImage: !isMe
                        ? NetworkImage(statusData[index]['img']!)
                        : null,
                    child: isMe
                        ? Icon(Icons.add, color: Colors.cyanAccent, size: 25.sp)
                        : null,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  statusData[index]['name']!,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _otherStoriesGrid(bool isDark, final textColor) {
    return SizedBox(
      height: 15.h, // Fixed height for vertical rectangular cards

      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            width: 12.h, // Controls the width of the story card
            margin: EdgeInsets.only(right: 3.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background Image
                  Image.network(
                    "https://picsum.photos/400/700?random=${index + 10}",
                    fit: BoxFit.cover,
                  ),
                  // Bottom Gradient for readability
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6),
                        ],
                      ),
                    ),
                  ),
                  // Indicator and Name
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Colors.cyanAccent,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.cyanAccent,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Name",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _addVoiceNoteCard(bool isDark, final textColor) {
    return _glassContainer(
      isDark: isDark,
      child: Row(
        children: [
          Icon(Icons.mic, color: Colors.amber, size: 22.sp),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              "Tap to add your voice note",
              style: TextStyle(
                color: textColor,
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Text("1:00", style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _voiceNoteItem(String title, bool isDark, final textColor) {
    return _glassContainer(
      margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.6.h),
      isDark: isDark,
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 18,
            child: Icon(Icons.play_arrow, color: Colors.black),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Listen to",
                  style: TextStyle(color: textColor, fontSize: 13.sp),
                ),
                Text(
                  '"$title"',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 15.sp,
                  ),
                ),
              ],
            ),
          ),
          // Waveform placeholder
          Icon(
            Icons.graphic_eq,
            color: textColor.withValues(alpha: 0.6),
            size: 25.sp,
          ),
          SizedBox(width: 2.w),
          Text("1:00", style: TextStyle(color: textColor)),
        ],
      ),
    );
  }
}

Widget _glassContainer({
  required Widget child,
  EdgeInsets? margin,
  required bool isDark,
}) {
  return Container(
    margin: margin ?? EdgeInsets.symmetric(horizontal: 2.w),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.sp),
      border: Border.all(
        color: isDark
            ? Colors.white.withValues(alpha: 0.2)
            : Colors.black.withValues(alpha: 0.1),
      ),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.1),
          blurRadius: 1,
          spreadRadius: 1,
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20.sp),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          padding: EdgeInsets.all(1.8.h),
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.08),
          child: child,
        ),
      ),
    ),
  );
}
