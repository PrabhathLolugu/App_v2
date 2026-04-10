import 'package:flutter/material.dart';
import 'package:myitihas/core/widgets/voice_input/voice_input_button.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/features/social/domain/entities/user.dart';
import 'package:myitihas/features/social/domain/repositories/user_repository.dart';
import 'package:myitihas/i18n/strings.g.dart';

/// Bottom sheet widget for selecting a user to send content to.
class UserSelectorSheet extends StatefulWidget {
  /// Called when a user is selected. Returns the selected user's ID.
  final void Function(User user) onUserSelected;

  /// Title to display in the header
  final String? title;

  const UserSelectorSheet({
    super.key,
    required this.onUserSelected,
    this.title,
  });

  /// Shows the user selector sheet and returns the selected user, or null if dismissed.
  static Future<User?> show(
    BuildContext context, {
    String? title,
  }) async {
    User? selectedUser;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => UserSelectorSheet(
        title: title,
        onUserSelected: (user) {
          selectedUser = user;
          Navigator.pop(sheetContext);
        },
      ),
    );

    return selectedUser;
  }

  @override
  State<UserSelectorSheet> createState() => _UserSelectorSheetState();
}

class _UserSelectorSheetState extends State<UserSelectorSheet> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  List<User> _users = [];
  List<User> _filteredUsers = [];
  bool _isLoading = true;
  String? _error;

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
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      setState(() => _filteredUsers = _users);
    } else {
      setState(() {
        _filteredUsers = _users.where((user) {
          return user.username.toLowerCase().contains(query) ||
              user.displayName.toLowerCase().contains(query);
        }).toList();
      });
    }
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repository = getIt<UserRepository>();

      // First get current user to get their following list
      final currentUserResult = await repository.getCurrentUser();

      await currentUserResult.fold(
        (failure) async {
          setState(() => _error = failure.message);
        },
        (currentUser) async {
          // Get users the current user is following (most relevant for DM)
          final followingResult = await repository.getFollowing(
            currentUser.id,
            limit: 50,
          );

          followingResult.fold(
            (failure) {
              setState(() => _error = failure.message);
            },
            (following) {
              setState(() {
                _users = following;
                _filteredUsers = following;
              });
            },
          );
        },
      );
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _searchAllUsers(String query) async {
    if (query.isEmpty) return;

    try {
      final repository = getIt<UserRepository>();
      final result = await repository.searchUsers(query);

      result.fold(
        (failure) {
          // Keep current results on error
        },
        (users) {
          setState(() => _filteredUsers = users);
        },
      );
    } catch (e) {
      // Keep current results on error
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final gradients = theme.extension<GradientExtension>();
    final t = Translations.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          // Header
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Text(
                  widget.title ?? t.feed.selectUser,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          // Search bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: t.feed.searchUsers,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: VoiceInputButton(
                  controller: _searchController,
                  compact: true,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.r),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
              ),
              onSubmitted: _searchAllUsers,
            ),
          ),
          SizedBox(height: 8.h),
          Divider(height: 1),
          // User list
          Expanded(child: _buildContent(colorScheme, gradients, t)),
        ],
      ),
    );
  }

  Widget _buildContent(
    ColorScheme colorScheme,
    GradientExtension? gradients,
    Translations t,
  ) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
            SizedBox(height: 16.h),
            Text(_error!),
            SizedBox(height: 16.h),
            ElevatedButton(onPressed: _loadUsers, child: Text(t.common.retry)),
          ],
        ),
      );
    }

    if (_filteredUsers.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.people_outline,
              size: 48.sp,
              color: colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: 16.h),
            Text(
              _searchController.text.isEmpty
                  ? t.feed.noFollowingYet
                  : t.feed.noUsersFound,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
            if (_searchController.text.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Text(
                t.feed.tryDifferentSearch,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: _filteredUsers.length,
      itemBuilder: (context, index) {
        final user = _filteredUsers[index];
        return _UserTile(
          user: user,
          gradients: gradients,
          onTap: () {
            HapticFeedback.selectionClick();
            widget.onUserSelected(user);
          },
        );
      },
    );
  }
}

class _UserTile extends StatelessWidget {
  final User user;
  final GradientExtension? gradients;
  final VoidCallback onTap;

  const _UserTile({
    required this.user,
    this.gradients,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 24.r,
        backgroundColor: colorScheme.primaryContainer,
        backgroundImage:
            user.avatarUrl.isNotEmpty ? NetworkImage(user.avatarUrl) : null,
        child: user.avatarUrl.isEmpty
            ? Text(
                user.displayName.isNotEmpty
                    ? user.displayName[0].toUpperCase()
                    : user.username[0].toUpperCase(),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                ),
              )
            : null,
      ),
      title: Text(
        user.displayName.isNotEmpty ? user.displayName : user.username,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        '@${user.username}',
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          gradient: gradients?.primaryButtonGradient,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.send,
          size: 18.sp,
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }
}
