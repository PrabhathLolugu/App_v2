import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/features/social/domain/entities/user.dart';
import 'package:myitihas/features/social/domain/repositories/user_repository.dart';
import 'package:myitihas/features/social/presentation/widgets/svg_avatar.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/services/people_connect_follow_limit_service.dart';
import 'package:myitihas/services/people_connect_suggestion_storage_service.dart';
import 'package:myitihas/services/supabase_service.dart';

/// Bottom sheet showing 10 random user suggestions. Refreshes on every open.
/// Enforces 1-hour cooldown after 10 follows from this flow.
void showPeopleToConnectSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => const PeopleToConnectSheet(),
  );
}

class PeopleToConnectSheet extends StatefulWidget {
  const PeopleToConnectSheet({super.key});

  @override
  State<PeopleToConnectSheet> createState() => _PeopleToConnectSheetState();
}

class _PeopleToConnectSheetState extends State<PeopleToConnectSheet> {
  final UserRepository _userRepo = getIt<UserRepository>();
  final PeopleConnectFollowLimitService _limitService =
      getIt<PeopleConnectFollowLimitService>();
  final PeopleConnectSuggestionStorageService _suggestionStorage =
      getIt<PeopleConnectSuggestionStorageService>();

  List<User> _suggestions = [];
  List<User> _remainingSuggestions = [];
  bool _loading = true;
  String? _error;
  final Set<String> _followedIds = {};
  final Set<String> _usersFollowingMe = {};
  bool _cooldownTriggered = false;

  static const int _maxSuggestions = 10;

  @override
  void initState() {
    super.initState();
    _limitService.onSheetOpened();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _loadUsersFollowingMe();
    await _loadSuggestions();
  }

  Future<void> _loadUsersFollowingMe() async {
    final currentUserResult = await _userRepo.getCurrentUser();
    final currentUserId = currentUserResult.fold(
      (_) => null,
      (user) => user.id,
    );
    if (currentUserId == null) return;
    final followersResult = await _userRepo.getFollowers(
      currentUserId,
      limit: 200,
    );
    if (!mounted) return;
    followersResult.fold((_) => null, (followers) {
      setState(() {
        _usersFollowingMe
          ..clear()
          ..addAll(followers.map((f) => f.id));
      });
    });
  }

  Future<void> _loadSuggestions() async {
    setState(() {
      _loading = true;
      _error = null;
      _cooldownTriggered = _limitService.isInCooldown;
    });

    final result = await _userRepo.getAllUsers();
    result.fold(
      (failure) {
        if (mounted) {
          setState(() {
            _error = failure.message;
            _loading = false;
          });
        }
      },
      (users) async {
        if (!mounted) return;
        final currentId = SupabaseService.client.auth.currentUser?.id;
        final shownIds = await _suggestionStorage.getShownUserIds();

        _followedIds
          ..clear()
          ..addAll(users.where((u) => u.isFollowing).map((u) => u.id));

        // Deduplicate by user id and filter out current user, followed, shown
        final seen = <String>{};
        final candidates = users.where((u) {
          if (u.id == currentId || u.isFollowing || shownIds.contains(u.id)) {
            return false;
          }
          return seen.add(u.id);
        }).toList();

        final rng = Random();
        candidates.shuffle(rng);

        final visible = candidates.take(_maxSuggestions).toList();
        final remaining = candidates.skip(_maxSuggestions).toList();

        await _suggestionStorage.addShownUserIds(visible.map((u) => u.id));

        if (!mounted) return;
        setState(() {
          _suggestions = visible;
          _remainingSuggestions = remaining;
          _loading = false;
        });
      },
    );
  }

  void _removeSuggestionAndBackfill(String userId) {
    _suggestions.removeWhere((u) => u.id == userId);

    while (_suggestions.length < _maxSuggestions &&
        _remainingSuggestions.isNotEmpty) {
      final next = _remainingSuggestions.removeAt(0);
      if (_followedIds.contains(next.id)) continue;
      _suggestions.add(next);
    }
  }

  Future<void> _onFollow(User user) async {
    if (_limitService.isInCooldown) return;

    HapticFeedback.lightImpact();
    final result = await _userRepo.followUser(user.id);
    result.fold(
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(failure.message)));
        }
      },
      (_) async {
        final triggered = await _limitService.recordFollow();
        if (mounted) {
          setState(() {
            _followedIds.add(user.id);
            _removeSuggestionAndBackfill(user.id);
            if (triggered) _cooldownTriggered = true;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    t.notification.peopleToConnect,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => context.pop(),
                  ),
                ],
              ),
            ),
            if (_limitService.isInCooldown || _cooldownTriggered) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          t.notification.followAgainInMinutes(
                            minutes: _limitService.cooldownMinutesRemaining,
                          ),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _error!,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: _loadSuggestions,
                            child: Text(t.common.retry),
                          ),
                        ],
                      ),
                    )
                  : _suggestions.isEmpty
                  ? Center(
                      child: Text(
                        t.notification.noSuggestions,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) {
                        final user = _suggestions[index];
                        final isFollowing =
                            user.isFollowing || _followedIds.contains(user.id);
                        final isFollowBack =
                            !isFollowing && _usersFollowingMe.contains(user.id);
                        final canFollow =
                            !_limitService.isInCooldown &&
                            !_cooldownTriggered &&
                            !isFollowing;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              ProfileRoute(userId: user.id).push(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SvgAvatar(
                                    imageUrl: user.avatarUrl,
                                    radius: 24,
                                    fallbackText: user.displayName,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.displayName,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        if (user.username.isNotEmpty) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            '@${user.username}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                  color: colorScheme
                                                      .onSurfaceVariant,
                                                ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minWidth: 92,
                                    ),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: TextButton(
                                        onPressed: canFollow
                                            ? () => _onFollow(user)
                                            : null,
                                        style: TextButton.styleFrom(
                                          minimumSize: const Size(88, 36),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                        ),
                                        child: Text(
                                          isFollowing
                                              ? t.profile.following
                                              : isFollowBack
                                              ? 'Follow back'
                                              : t.profile.follow,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.labelMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                height: 1.2,
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
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
