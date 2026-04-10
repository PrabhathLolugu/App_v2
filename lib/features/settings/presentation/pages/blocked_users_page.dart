import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/services/user_block_service.dart';
import 'package:myitihas/features/social/domain/repositories/user_repository.dart';
import 'package:myitihas/features/social/domain/entities/user.dart';
import 'package:talker_flutter/talker_flutter.dart';

class BlockedUsersPage extends StatefulWidget {
  const BlockedUsersPage({super.key});

  @override
  State<BlockedUsersPage> createState() => _BlockedUsersPageState();
}

class _BlockedUsersPageState extends State<BlockedUsersPage> {
  final _blockService = getIt<UserBlockService>();
  final _userRepository = getIt<UserRepository>();
  final _logger = getIt<Talker>();

  List<User> _blockedUsers = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBlockedUsers();
  }

  Future<void> _loadBlockedUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final blockedUserIds = await _blockService.getBlockedUsers();
      _logger.info(
        '[BlockedUsersPage] Found ${blockedUserIds.length} blocked users',
      );

      if (blockedUserIds.isEmpty) {
        setState(() {
          _blockedUsers = [];
          _isLoading = false;
        });
        return;
      }

      // Fetch user details for all blocked users
      final users = <User>[];
      for (final userId in blockedUserIds) {
        final result = await _userRepository.getUserProfile(userId);
        result.fold(
          (failure) {
            _logger.warning(
              '[BlockedUsersPage] Failed to load user $userId: ${failure.message}',
            );
          },
          (user) {
            users.add(user);
          },
        );
      }

      setState(() {
        _blockedUsers = users;
        _isLoading = false;
      });
    } catch (e) {
      _logger.error('[BlockedUsersPage] Error loading blocked users', e);
      setState(() {
        _errorMessage = 'Failed to load blocked users';
        _isLoading = false;
      });
    }
  }

  Future<void> _unblockUser(User user) async {
    try {
      await _blockService.unblockUser(user.id);
      _logger.info('[BlockedUsersPage] Unblocked user ${user.id}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unblocked ${user.displayName}')),
        );
      }

      // Refresh the list
      await _loadBlockedUsers();
    } catch (e) {
      _logger.error('[BlockedUsersPage] Error unblocking user', e);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to unblock user')));
      }
    }
  }

  void _showUnblockConfirmation(User user) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Unblock User'),
          content: Text(
            'Are you sure you want to unblock ${user.displayName}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _unblockUser(user);
              },
              child: const Text('Unblock'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blocked Users'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(_errorMessage!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadBlockedUsers,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : _blockedUsers.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.block,
                    size: 64,
                    color: theme.colorScheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text('No blocked users', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Users you block will appear here',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadBlockedUsers,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _blockedUsers.length,
                itemBuilder: (context, index) {
                  final user = _blockedUsers[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: theme.colorScheme.primary.withOpacity(
                          0.1,
                        ),
                        backgroundImage: user.avatarUrl.isNotEmpty
                            ? CachedNetworkImageProvider(user.avatarUrl)
                            : null,
                        child: user.avatarUrl.isEmpty
                            ? Text(
                                user.displayName.isNotEmpty
                                    ? user.displayName[0].toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              )
                            : null,
                      ),
                      title: Text(
                        user.displayName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: user.username.isNotEmpty
                          ? Text('@${user.username}')
                          : null,
                      trailing: OutlinedButton(
                        onPressed: () => _showUnblockConfirmation(user),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: theme.colorScheme.primary,
                          side: BorderSide(color: theme.colorScheme.primary),
                        ),
                        child: const Text('Unblock'),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
