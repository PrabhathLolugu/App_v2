import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/core/widgets/voice_input/voice_input_button.dart';
import 'package:myitihas/features/social/presentation/widgets/svg_avatar.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/services/profile_service.dart';
import 'package:myitihas/services/user_block_service.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage>
    with WidgetsBindingObserver {
  final TextEditingController _searchController = TextEditingController();
  final ProfileService _profileService = getIt<ProfileService>();
  final UserBlockService _blockService = getIt<UserBlockService>();
  Timer? _debounceTimer;

  List<Map<String, dynamic>> _profiles = [];
  bool _isLoading = true;
  String? _errorMessage;
  final int _limit = 20;
  final int _offset = 0;
  List<String> _blockedUserIds = []; // List of blocked user IDs
  List<String> _blockerUserIds = []; // List of users who blocked me

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadBlockedUsers();
    _loadProfiles();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Refresh blocked users when app resumes
      _loadBlockedUsers().then((_) {
        // Re-filter current profiles with updated block list
        if (_searchController.text.trim().isEmpty) {
          _loadProfiles();
        } else {
          _searchProfiles(_searchController.text.trim());
        }
      });
    }
  }

  void _onSearchChanged() {
    // Cancel previous timer
    _debounceTimer?.cancel();

    // Start new timer (400ms debounce)
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      final query = _searchController.text.trim();

      if (query.isEmpty) {
        // Load all profiles when search is empty
        _loadProfiles();
      } else {
        // Search profiles when query is non-empty
        _searchProfiles(query);
      }
    });
  }

  Future<void> _loadBlockedUsers() async {
    try {
      final blockedIds = await _blockService.getBlockedUsers();
      final blockerIds = await _blockService.getUsersWhoBlockedMe();
      setState(() {
        _blockedUserIds = blockedIds;
        _blockerUserIds = blockerIds;
      });
    } catch (e) {
      // Silently fail, assume no blocked users
      setState(() {
        _blockedUserIds = [];
        _blockerUserIds = [];
      });
    }
  }

  Future<void> _loadProfiles() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final profiles = await _profileService.fetchPublicProfiles(
        limit: _limit,
        offset: _offset,
      );

      // Filter out blocked users and users who blocked me
      final filteredProfiles = profiles.where((profile) {
        final userId = profile['id'] as String?;
        return userId != null &&
            !_blockedUserIds.contains(userId) &&
            !_blockerUserIds.contains(userId);
      }).toList();

      setState(() {
        _profiles = filteredProfiles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load profiles: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _searchProfiles(String query) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final profiles = await _profileService.searchProfiles(query);

      // Filter out blocked users and users who blocked me
      final filteredProfiles = profiles.where((profile) {
        final userId = profile['id'] as String?;
        return userId != null &&
            !_blockedUserIds.contains(userId) &&
            !_blockerUserIds.contains(userId);
      }).toList();

      setState(() {
        _profiles = filteredProfiles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to search profiles: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.discover.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search text field at the top
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _searchController,
                builder: (_, value, __) => TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: t.feed.searchUsers,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        VoiceInputButton(
                          controller: _searchController,
                          compact: true,
                        ),
                        if (value.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                            },
                          ),
                      ],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                  ),
                ),
              ),
            ),
            // Placeholder list below
            Expanded(child: _buildPlaceholderContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderContent() {
    if (_isLoading) {
      // Loading state
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      // Error state
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              Translations.of(context).discover.somethingWentWrong,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                Translations.of(context).discover.unableToLoadProfiles,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadProfiles,
              icon: const Icon(Icons.refresh),
              label: Text(Translations.of(context).discover.tryAgain),
            ),
          ],
        ),
      );
    }

    if (_profiles.isEmpty) {
      // Empty state - different message based on search
      final isSearching = _searchController.text.isNotEmpty;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearching ? Icons.search_off : Icons.people_outline,
              size: 64,
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              isSearching
                  ? Translations.of(context).discover.noResultsFound
                  : Translations.of(context).discover.noProfilesYet,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                isSearching
                    ? Translations.of(context).discover.tryDifferentKeywords
                    : Translations.of(context).discover.beFirstToDiscover,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Display profiles list
    return ListView.builder(
      itemCount: _profiles.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final profile = _profiles[index];
        final userId = profile['id'] as String;
        final displayName = profile['full_name'] as String? ?? 'Unknown';
        final username = profile['username'] as String? ?? '';
        final avatarUrl = profile['avatar_url'] as String?;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: SvgAvatar(
              imageUrl: avatarUrl ?? '',
              radius: 28,
              fallbackText: displayName,
            ),
            title: Text(
              displayName,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            subtitle: username.isNotEmpty
                ? Text(
                    '@$username',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  )
                : null,
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to other user's profile
              ProfileRoute(userId: userId).push(context);
            },
          ),
        );
      },
    );
  }
}
