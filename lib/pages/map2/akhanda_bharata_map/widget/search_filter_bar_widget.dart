import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myitihas/core/widgets/voice_input/voice_input_button.dart';
import 'package:myitihas/pages/map2/widgets/custom_icon_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchFilterBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onFilterPressed;

  const SearchFilterBarWidget({
    super.key,
    required this.controller,
    required this.onSearchChanged,
    required this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 6.5.h,
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isDark ? Colors.black.withOpacity(0.8) : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.8)
              : Colors.grey.withOpacity(0.45),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'search',
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            size: 24,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onSearchChanged,
              style: theme.textTheme.bodyLarge,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: 'Search sacred sites...',
                hintStyle: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                filled: false,
                fillColor: Colors.transparent,
                suffixIcon: VoiceInputButton(
                  controller: controller,
                  compact: true,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          SizedBox(width: 2.w),
          IconButton(
            onPressed: onFilterPressed,
            icon: CustomIconWidget(
              iconName: 'filter_list',
              color: theme.colorScheme.primary,
              size: 24,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),

          // inside lib/pages/map2/widgets/search_filter_bar_widget.dart
          InkWell(
            onTap: () => context.push('/my-journey'),
            borderRadius: BorderRadius.circular(30),
            child: FutureBuilder(
              // 1. Query the profiles table using the current user's ID
              future: Supabase.instance.client
                  .from('profiles')
                  .select('avatar_url')
                  .eq('id', Supabase.instance.client.auth.currentUser?.id ?? '')
                  .maybeSingle(),
              builder: (context, snapshot) {
                final String? avatarUrl = snapshot.data?['avatar_url'];

                return CircleAvatar(
                  radius: 18.sp,

                  backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                  // 2. Use NetworkImage if URL exists, otherwise show fallback icon
                  backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                      ? NetworkImage(avatarUrl)
                      : null,
                  child: (avatarUrl == null || avatarUrl.isEmpty)
                      ? Icon(
                          Icons.person,
                          color: isDark ? Colors.white70 : Colors.black45,
                          size: 20.sp,
                        )
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
