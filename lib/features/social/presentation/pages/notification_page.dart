import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/features/notifications/presentation/cubit/notification_count_cubit.dart';
import 'package:myitihas/features/notifications/presentation/cubit/notification_page_cubit.dart';
import 'package:myitihas/features/notifications/presentation/cubit/notification_page_state.dart';
import 'package:myitihas/features/notifications/presentation/models/notification_item.dart';
import 'package:myitihas/features/social/domain/entities/user.dart';
import 'package:myitihas/features/social/domain/repositories/user_repository.dart';
import 'package:myitihas/features/social/presentation/widgets/people_to_connect_sheet.dart';
import 'package:myitihas/features/social/presentation/widgets/svg_avatar.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/services/notification_service.dart';
import 'package:myitihas/services/people_connect_follow_limit_service.dart';
import 'package:myitihas/services/people_connect_suggestion_storage_service.dart';
import 'package:myitihas/services/supabase_service.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NotificationPageCubit>()..loadNotifications(),
      child: const _NotificationView(),
    );
  }
}

class _NotificationView extends StatefulWidget {
  const _NotificationView();

  @override
  State<_NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<_NotificationView> {
  final ScrollController _scrollController = ScrollController();
  final Set<String> _selectedNotificationIds = <String>{};

  bool get _isSelectionMode => _selectedNotificationIds.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<NotificationPageCubit>().loadMore();
    }
  }

  void _clearSelection() {
    if (_selectedNotificationIds.isEmpty) return;
    setState(() {
      _selectedNotificationIds.clear();
    });
  }

  void _toggleNotificationSelection(String notificationId) {
    setState(() {
      if (!_selectedNotificationIds.remove(notificationId)) {
        _selectedNotificationIds.add(notificationId);
      }
    });
  }

  void _onNotificationLongPress(String notificationId) {
    HapticFeedback.mediumImpact();
    _toggleNotificationSelection(notificationId);
  }

  void _onNotificationTap(NotificationItem notification) {
    if (_isSelectionMode) {
      HapticFeedback.selectionClick();
      _toggleNotificationSelection(notification.id);
      return;
    }

    HapticFeedback.lightImpact();
    context.read<NotificationPageCubit>().markAsRead(notification.id);
    _handleNotificationTap(context, notification);
  }

  Future<void> _deleteSelectedNotifications() async {
    final selectedIds = List<String>.from(_selectedNotificationIds);
    if (selectedIds.isEmpty) return;

    HapticFeedback.mediumImpact();
    _clearSelection();

    final cubit = context.read<NotificationPageCubit>();
    for (final notificationId in selectedIds) {
      await cubit.deleteNotification(notificationId);
    }

    if (!mounted) return;
    context.read<NotificationCountCubit>().refresh();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          _isSelectionMode
              ? MaterialLocalizations.of(
                  context,
                ).selectedRowCountTitle(_selectedNotificationIds.length)
              : t.notification.title,
        ),
        leading: _isSelectionMode
            ? IconButton(
                tooltip: MaterialLocalizations.of(context).cancelButtonLabel,
                onPressed: _clearSelection,
                icon: const Icon(Icons.close_rounded),
              )
            : null,
        actions: [
          if (_isSelectionMode)
            IconButton(
              tooltip: t.notification.delete,
              onPressed: _deleteSelectedNotifications,
              icon: const Icon(Icons.delete_outline_rounded),
            )
          else
            BlocBuilder<NotificationPageCubit, NotificationPageState>(
              builder: (context, state) {
                return state.maybeWhen(
                  loaded: (notifications, _, isLoadingMore) {
                    final hasUnread = notifications.any((n) => !n.isRead);
                    if (!hasUnread) return const SizedBox.shrink();
                    return TextButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        context.read<NotificationPageCubit>().markAllAsRead();
                      },
                      child: Text(t.notification.markAllRead),
                    );
                  },
                  orElse: () => const SizedBox.shrink(),
                );
              },
            ),
        ],
      ),
      body: BlocBuilder<NotificationPageCubit, NotificationPageState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (notifications, hasMore, isLoadingMore) {
              if (notifications.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () async {
                    HapticFeedback.mediumImpact();
                    _clearSelection();
                    final cubit = context.read<NotificationPageCubit>();
                    final countCubit = context.read<NotificationCountCubit>();
                    await cubit.loadNotifications();
                    countCubit.refresh();
                  },
                  color: colorScheme.primary,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                      top: 8.h,
                      bottom: 8.h + MediaQuery.paddingOf(context).bottom,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _PeopleToConnectInline(),
                        SizedBox(height: 16.h),
                        _EmptyState(isDark: isDark),
                      ],
                    ),
                  ),
                );
              }

              final grouped = _groupNotifications(notifications);
              const int peopleConnectOffset = 1;

              return RefreshIndicator(
                onRefresh: () async {
                  HapticFeedback.mediumImpact();
                  _clearSelection();
                  final cubit = context.read<NotificationPageCubit>();
                  final countCubit = context.read<NotificationCountCubit>();
                  await cubit.loadNotifications();
                  countCubit.refresh();
                },
                color: colorScheme.primary,
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: EdgeInsets.only(
                    left: 16.w,
                    right: 16.w,
                    top: 8.h,
                    bottom: 8.h + MediaQuery.paddingOf(context).bottom,
                  ),
                  itemCount:
                      peopleConnectOffset +
                      grouped.length +
                      (isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const _PeopleToConnectInline();
                    }
                    if (index >= peopleConnectOffset + grouped.length) {
                      return Padding(
                        padding: EdgeInsets.all(16.w),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }

                    final entry = grouped[index - peopleConnectOffset];
                    if (entry is String) {
                      return _SectionHeader(title: entry);
                    }

                    final notification = entry as NotificationItem;
                    return _AnimatedNotificationCard(
                      index: index,
                      notification: notification,
                      isSelectionMode: _isSelectionMode,
                      isSelected: _selectedNotificationIds.contains(
                        notification.id,
                      ),
                      isDark: isDark,
                      onTap: () => _onNotificationTap(notification),
                      onLongPress: () =>
                          _onNotificationLongPress(notification.id),
                      onDismissed: () {
                        HapticFeedback.mediumImpact();
                        context
                            .read<NotificationPageCubit>()
                            .deleteNotification(notification.id);
                      },
                    );
                  },
                ),
              );
            },
            error: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 48.sp,
                    color: colorScheme.error,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    '${t.notification.errorPrefix} $message',
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  FilledButton.icon(
                    onPressed: () {
                      context.read<NotificationPageCubit>().loadNotifications();
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(t.notification.retry),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<dynamic> _groupNotifications(List<NotificationItem> notifications) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final weekStart = todayStart.subtract(
      Duration(days: todayStart.weekday - 1),
    );

    final today = <NotificationItem>[];
    final thisWeek = <NotificationItem>[];
    final earlier = <NotificationItem>[];

    for (final n in notifications) {
      if (n.createdAt.isAfter(todayStart)) {
        today.add(n);
      } else if (n.createdAt.isAfter(weekStart)) {
        thisWeek.add(n);
      } else {
        earlier.add(n);
      }
    }

    final result = <dynamic>[];
    if (today.isNotEmpty) {
      result.add(t.notification.today);
      result.addAll(today);
    }
    if (thisWeek.isNotEmpty) {
      result.add(t.notification.thisWeek);
      result.addAll(thisWeek);
    }
    if (earlier.isNotEmpty) {
      result.add(t.notification.earlier);
      result.addAll(earlier);
    }
    return result;
  }

  void _handleNotificationTap(
    BuildContext context,
    NotificationItem notification,
  ) {
    String resolvePostType(NotificationItem n, String? entityType) {
      final normalized = (n.contentType ?? entityType ?? n.entityType ?? '')
          .toLowerCase();
      switch (normalized) {
        case 'text':
        case 'text_post':
        case 'textpost':
        case 'thought':
          return 'text';
        case 'video':
        case 'video_post':
        case 'videopost':
          return 'video';
        default:
          return 'image';
      }
    }

    void openPostDetail(
      BuildContext ctx,
      String postId,
      String postType,
      String? commentId,
    ) {
      final encodedId = Uri.encodeComponent(postId);
      ctx.push(
        '/post/$encodedId',
        extra: {
          'postType': postType,
          if (commentId != null && commentId.isNotEmpty) 'commentId': commentId,
        },
      );
    }

    switch (notification.parsedType) {
      case NotificationType.storySuggestion:
        if (notification.entityId != null) {
          StoryDetailRoute(id: notification.entityId!).push(context);
        }
        break;
      case NotificationType.like:
      case NotificationType.comment:
      case NotificationType.reply:
      case NotificationType.share:
      case NotificationType.repost:
      case NotificationType.mention:
      case NotificationType.newPost:
        final entityType =
            (notification.parentEntityType ?? notification.entityType)
                ?.toLowerCase();
        final entityId = notification.parentEntityId ?? notification.entityId;
        if (entityId != null) {
          if (entityType == 'story') {
            StoryDetailRoute(id: entityId).push(context);
            break;
          }

          final postType = resolvePostType(notification, entityType);
          openPostDetail(
            context,
            entityId,
            postType,
            notification.targetCommentId,
          );
        } else {
          context.push('/social-feed');
        }
        break;
      case NotificationType.follow:
        if (notification.actorId != null) {
          ProfileRoute(userId: notification.actorId!).push(context);
        }
        break;
      case NotificationType.message:
      case NotificationType.groupMessage:
        final conversationId = notification.conversationId;
        if (conversationId != null && conversationId.isNotEmpty) {
          ChatDetailRoute(
            $extra: {
              'conversationId': conversationId,
              'userId':
                  notification.metadataString('sender_id') ??
                  notification.actorId ??
                  '',
              'name':
                  notification.metadataString('sender_name') ??
                  notification.displayName,
              'avatarUrl':
                  notification.metadataString('sender_avatar_url') ??
                  notification.actorAvatarUrl,
              'isGroup':
                  notification.parsedType == NotificationType.groupMessage ||
                  notification.isGroupConversation,
            },
          ).push(context);
        } else {
          context.push('/home?tab=2');
        }
        break;
      case null:
        break;
    }
  }
}

class _PeopleToConnectInline extends StatefulWidget {
  const _PeopleToConnectInline();

  @override
  State<_PeopleToConnectInline> createState() => _PeopleToConnectInlineState();
}

class _PeopleToConnectInlineState extends State<_PeopleToConnectInline> {
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

  static const int _maxSuggestions = 8;

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
    if (!mounted) return;
    result.fold(
      (failure) {
        setState(() {
          _error = failure.message;
          _loading = false;
        });
      },
      (users) async {
        final currentId = SupabaseService.client.auth.currentUser?.id;
        final shownIds = await _suggestionStorage.getShownUserIds();

        _followedIds
          ..clear()
          ..addAll(users.where((u) => u.isFollowing).map((u) => u.id));

        // Deduplicate by user id and filter out current user, followed, shown
        final seen = <String>{};
        final candidates = users.where((u) {
          if (u.id == currentId || u.isFollowing || shownIds.contains(u.id))
            return false;
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
    if (!mounted) return;
    result.fold(
      (failure) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failure.message)));
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

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
            child: Row(
              children: [
                Text(
                  t.notification.peopleToConnect,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    showPeopleToConnectSheet(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(
                        alpha: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      t.homeScreen.seeAll,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_loading)
            SizedBox(
              height: 120.h,
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            )
          else if (_error != null)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _error!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    onPressed: _loadSuggestions,
                    child: Text(t.common.retry),
                  ),
                ],
              ),
            )
          else if (_suggestions.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Text(
                t.notification.noSuggestions,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            )
          else
            SizedBox(
              height: 120.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: _suggestions.length,
                separatorBuilder: (_, __) => SizedBox(width: 12.w),
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

                  return SizedBox(
                    width: 112.w,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            ProfileRoute(userId: user.id).push(context);
                          },
                          child: SvgAvatar(
                            imageUrl: user.avatarUrl,
                            radius: 28,
                            fallbackText: user.displayName,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          user.displayName,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4.h),
                        TextButton(
                          onPressed: canFollow ? () => _onFollow(user) : null,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 4.h,
                            ),
                            minimumSize: Size(80.w, 24.h),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            isFollowing
                                ? t.profile.following
                                : isFollowBack
                                ? 'Follow back'
                                : t.profile.follow,
                            style: TextStyle(
                              fontSize: 11.sp,
                              height: 1.1,
                              color: canFollow
                                  ? colorScheme.primary
                                  : colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 8.h, left: 4.w),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _AnimatedNotificationCard extends StatefulWidget {
  final int index;
  final NotificationItem notification;
  final bool isSelectionMode;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onDismissed;

  const _AnimatedNotificationCard({
    required this.index,
    required this.notification,
    required this.isSelectionMode,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
    required this.onLongPress,
    required this.onDismissed,
  });

  @override
  State<_AnimatedNotificationCard> createState() =>
      _AnimatedNotificationCardState();
}

class _AnimatedNotificationCardState extends State<_AnimatedNotificationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.05, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(
      Duration(milliseconds: (widget.index * 50).clamp(0, 500)),
      () {
        if (mounted) _controller.forward();
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Dismissible(
          key: ValueKey(widget.notification.id),
          direction: widget.isSelectionMode
              ? DismissDirection.none
              : DismissDirection.endToStart,
          onDismissed: (_) => widget.onDismissed(),
          background: Container(
            margin: EdgeInsets.only(bottom: 8.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              gradient: const LinearGradient(
                colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
              ),
            ),
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.white,
                  size: 24.sp,
                ),
                SizedBox(height: 4.h),
                Text(
                  t.notification.delete,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          child: _NotificationCard(
            notification: widget.notification,
            isSelectionMode: widget.isSelectionMode,
            isSelected: widget.isSelected,
            isDark: widget.isDark,
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationItem notification;
  final bool isSelectionMode;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _NotificationCard({
    required this.notification,
    required this.isSelectionMode,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark
                          ? colorScheme.primary.withValues(alpha: 0.22)
                          : colorScheme.primary.withValues(alpha: 0.14))
                    : notification.isRead
                    ? (isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.black.withValues(alpha: 0.03))
                    : (isDark
                          ? colorScheme.primary.withValues(alpha: 0.12)
                          : colorScheme.primary.withValues(alpha: 0.06)),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: isSelected
                      ? colorScheme.primary.withValues(alpha: 0.65)
                      : notification.isRead
                      ? (isDark
                            ? Colors.white.withValues(alpha: 0.06)
                            : Colors.black.withValues(alpha: 0.04))
                      : colorScheme.primary.withValues(alpha: 0.2),
                  width: isSelected ? 1.4 : 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar with type icon overlay
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      notification.parsedType ==
                              NotificationType.storySuggestion
                          ? Container(
                              width: 44.r,
                              height: 44.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF1D4ED8),
                                    Color(0xFF0EA5E9),
                                  ],
                                ),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.25)
                                      : Colors.white,
                                  width: 1.2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF0EA5E9,
                                    ).withValues(alpha: isDark ? 0.35 : 0.25),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '✨',
                                style: TextStyle(
                                  fontSize: 19.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  height: 1,
                                ),
                              ),
                            )
                          : SvgAvatar(
                              imageUrl: notification.actorAvatarUrl ?? '',
                              radius: 22,
                              fallbackText: notification.displayName,
                            ),
                      Positioned(
                        bottom: -2,
                        right: -4,
                        child: Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: notification.color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : Colors.white,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            notification.icon,
                            size: 10.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 12.w),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getNotificationText(notification),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: notification.isRead
                                ? FontWeight.normal
                                : FontWeight.w600,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (notification.body != null &&
                            notification.body!.isNotEmpty) ...[
                          SizedBox(height: 4.h),
                          Text(
                            notification.body!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        SizedBox(height: 4.h),
                        Text(
                          timeago.format(notification.createdAt),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (isSelectionMode) ...[
                    SizedBox(width: 8.w),
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: Icon(
                        isSelected
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        size: 20.sp,
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant.withValues(
                                alpha: 0.55,
                              ),
                      ),
                    ),
                  ] else if (!notification.isRead) ...[
                    SizedBox(width: 8.w),
                    Padding(
                      padding: EdgeInsets.only(top: 6.h),
                      child: Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.primary,
                              colorScheme.primary.withValues(alpha: 0.7),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withValues(alpha: 0.4),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getNotificationText(NotificationItem n) {
    final name = n.displayName;

    String contentLabel(NotificationItem item) {
      final normalized = (item.contentType ?? item.entityType ?? '')
          .toLowerCase();
      switch (normalized) {
        case 'story':
          return 'story';
        case 'video':
        case 'video_post':
        case 'videopost':
          return 'video';
        case 'text':
        case 'text_post':
        case 'textpost':
        case 'thought':
          return 'thought';
        default:
          return 'post';
      }
    }

    switch (n.parsedType) {
      case NotificationType.like:
        return n.body ?? '$name liked your ${contentLabel(n)}';
      case NotificationType.comment:
        return n.body ?? '$name commented on your ${contentLabel(n)}';
      case NotificationType.reply:
        return n.body ?? '$name replied to your comment';
      case NotificationType.follow:
        return t.notification.startedFollowingYou(actorName: name);
      case NotificationType.share:
        return n.body ?? '$name shared your ${contentLabel(n)}';
      case NotificationType.repost:
        return n.body ?? '$name reposted your ${contentLabel(n)}';
      case NotificationType.mention:
        return t.notification.mentionedYou(actorName: name);
      case NotificationType.newPost:
        return n.body ?? t.notification.newPostFrom(actorName: name);
      case NotificationType.storySuggestion:
        return n.body ?? n.title ?? '';
      case NotificationType.message:
      case NotificationType.groupMessage:
        return n.body ?? '$name sent you a message';
      case null:
        return n.title ?? n.body ?? '';
    }
  }
}

class _EmptyState extends StatelessWidget {
  final bool isDark;
  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : colorScheme.primary.withValues(alpha: 0.05),
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                size: 56.sp,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              t.notification.noNotifications,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              t.notification.noNotificationsSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
