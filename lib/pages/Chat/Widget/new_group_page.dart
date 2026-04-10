import 'package:flutter/material.dart';
import 'package:myitihas/core/widgets/voice_input/voice_input_button.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myitihas/utils/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/services/profile_service.dart';

class NewGroupPage extends StatefulWidget {
  const NewGroupPage({super.key});

  @override
  State<NewGroupPage> createState() => _NewGroupPageState();
}

class _NewGroupPageState extends State<NewGroupPage> {
  final ProfileService _profileService = getIt<ProfileService>();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _allUsers = [];
  List<Map<String, dynamic>> _filteredUsers = [];
  bool _isLoading = true;
  String? _errorMessage;

  // Track selected contacts
  final Set<String> _selectedContacts = {};

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final users = await _profileService.fetchPublicProfiles(
        limit: 100,
        offset: 0,
      );

      setState(() {
        _allUsers = users;
        _filteredUsers = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load users: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();

    if (query.isEmpty) {
      setState(() {
        _filteredUsers = _allUsers;
      });
    } else {
      setState(() {
        _filteredUsers = _allUsers.where((user) {
          final username = (user['username'] ?? '').toLowerCase();
          final fullName = (user['full_name'] ?? '').toLowerCase();
          return username.contains(query) || fullName.contains(query);
        }).toList();
      });
    }
  }

  void _toggleSelection(String userId) {
    setState(() {
      if (_selectedContacts.contains(userId)) {
        _selectedContacts.remove(userId);
      } else {
        _selectedContacts.add(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? DarkColors.textPrimary : LightColors.textPrimary;
    final subTextColor = isDark
        ? DarkColors.textSecondary
        : LightColors.textSecondary;
    final glassBg = isDark ? DarkColors.glassBg : LightColors.cardBg;
    final glassBorder = isDark
        ? DarkColors.glassBorder
        : LightColors.glassBorder;
    final accentColor = isDark
        ? DarkColors.accentPrimary
        : LightColors.accentPrimary;

    return Scaffold(
      // 1. App Bar
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(6.h),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF121212) : Colors.white,
            border: Border(
              bottom: BorderSide(
                color: isDark ? Colors.white12 : Colors.black12,
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: textColor),
                    onPressed: () => context.pop(),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "New Group",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 18.sp,
                            color: textColor,
                          ),
                        ),
                        Text(
                          "Add participants",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.72)
                                : Colors.black.withValues(alpha: 0.62),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // 2. Body
      body: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F0F0F) : Colors.white,
        ),
        child: Column(
          children: [
            // Search Box
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? DarkColors.glassBg : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.3),
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: textColor, fontSize: 14.sp),
                  decoration: InputDecoration(
                    hintText: 'Search by name or username...',
                    suffixIcon: VoiceInputButton(
                      controller: _searchController,
                      compact: true,
                    ),
                    hintStyle: TextStyle(color: subTextColor, fontSize: 14.sp),
                    prefixIcon: Icon(
                      Icons.search,
                      color: subTextColor,
                      size: 20.sp,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 1.5.h,
                    ),
                  ),
                ),
              ),
            ),

            // User List
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    )
                  : _errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48.sp,
                            color: subTextColor,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            _errorMessage!,
                            style: TextStyle(color: subTextColor),
                          ),
                          SizedBox(height: 2.h),
                          ElevatedButton(
                            onPressed: _loadUsers,
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : _filteredUsers.isEmpty
                  ? Center(
                      child: Text(
                        'No users found',
                        style: TextStyle(color: subTextColor, fontSize: 14.sp),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      itemCount: _filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = _filteredUsers[index];
                        return _buildContactItem(
                          user,
                          isDark,
                          textColor,
                          subTextColor,
                          glassBg,
                          glassBorder,
                          accentColor,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // 3. Floating Action Button (Forward Arrow)
      floatingActionButton: _selectedContacts.isNotEmpty
          ? Container(
              margin: EdgeInsets.only(bottom: 2.h, right: 2.w),
              child: FloatingActionButton(
                onPressed: () {
                  // Check if at least 2 users are selected (minimum for a group)
                  if (_selectedContacts.length < 2) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please select more than 1 member to create a group',
                        ),
                        backgroundColor: isDark
                            ? DarkColors.accentPrimary
                            : LightColors.accentPrimary,
                      ),
                    );
                    return;
                  }

                  // Get selected users data
                  final selectedUsers = _filteredUsers
                      .where((user) => _selectedContacts.contains(user['id']))
                      .toList();

                  // Navigate to create group page
                  context.push('/create-group', extra: selectedUsers);
                },
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(Icons.arrow_forward, color: Colors.white),
              ),
            )
          : null,
    );
  }

  Widget _buildContactItem(
    Map<String, dynamic> user,
    bool isDark,
    Color textColor,
    Color subTextColor,
    Color glassBg,
    Color glassBorder,
    Color accentColor,
  ) {
    final userId = user['id'] as String;
    final username = user['username'] as String? ?? 'Unknown';
    final fullName = user['full_name'] as String?;
    final avatarUrl = user['avatar_url'] as String?;
    bool isSelected = _selectedContacts.contains(userId);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      child: Container(
        decoration: BoxDecoration(
          color: glassBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: glassBorder),
        ),
        child: InkWell(
          onTap: () => _toggleSelection(userId),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            child: Row(
          children: [
            // Avatar Stack - SizedBox.square ensures circle (not ellipse)
            SizedBox.square(
              dimension: 12.w,
              child: Stack(
                children: [
                  avatarUrl != null && avatarUrl.isNotEmpty
                      ? CircleAvatar(
                          radius: 6.w,
                          backgroundImage: NetworkImage(avatarUrl),
                          onBackgroundImageError: (_, _) {},
                          backgroundColor: accentColor.withValues(alpha: 0.2),
                        )
                      : Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: accentColor.withValues(alpha: 0.2),
                          ),
                          child: Icon(
                            Icons.person_rounded,
                            color: accentColor,
                            size: 20.sp,
                          ),
                        ),
                // Selection Checkmark (if selected)
                if (isSelected)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: DarkColors.profileGreen,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? DarkColors.bgColor : Colors.white,
                          width: 2,
                        ),
                      ),
                      child: Icon(Icons.check, size: 8.sp, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 4.w),

            // Name and Username
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName ?? username,
                    style: GoogleFonts.inter(
                      color: textColor,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (fullName != null)
                    Text(
                      '@$username',
                      style: GoogleFonts.inter(
                        color: subTextColor,
                        fontSize: 12.sp,
                      ),
                    ),
                ],
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
