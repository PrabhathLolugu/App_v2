import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/features/settings/presentation/bloc/cache_settings_bloc.dart';
import 'package:myitihas/features/settings/presentation/bloc/cache_settings_event.dart';
import 'package:myitihas/features/settings/presentation/bloc/cache_settings_state.dart';
import 'package:myitihas/repository/my_itihas_repository.dart';

class CacheSettingsPage extends StatelessWidget {
  const CacheSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<CacheSettingsBloc>()
            ..add(const CacheSettingsEvent.loadSettings()),
      child: const _CacheSettingsView(),
    );
  }
}

class _CacheSettingsView extends StatelessWidget {
  const _CacheSettingsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cache Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<CacheSettingsBloc>().add(
                const CacheSettingsEvent.refreshUsage(),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CacheSettingsBloc, CacheSettingsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.errorMessage}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CacheSettingsBloc>().add(
                        const CacheSettingsEvent.loadSettings(),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Image Cache Section
              _CacheSizeSlider(
                title: 'Image Cache Size',
                currentSize: state.config.imageCacheSizeBytes,
                usedSize: state.imageUsageBytes,
                minSize: 100 * 1024 * 1024, // 100 MB
                maxSize: 2 * 1024 * 1024 * 1024, // 2 GB
                onChanged: (value) {
                  context.read<CacheSettingsBloc>().add(
                    CacheSettingsEvent.updateImageCacheSize(value.toInt()),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Video Cache Section
              _CacheSizeSlider(
                title: 'Video Cache Size',
                currentSize: state.config.videoCacheSizeBytes,
                usedSize: state.videoUsageBytes,
                minSize: 100 * 1024 * 1024, // 100 MB
                maxSize: 2 * 1024 * 1024 * 1024, // 2 GB
                onChanged: (value) {
                  context.read<CacheSettingsBloc>().add(
                    CacheSettingsEvent.updateVideoCacheSize(value.toInt()),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Audio Cache Section
              _CacheSizeSlider(
                title: 'Audio Cache Size',
                currentSize: state.config.audioCacheSizeBytes,
                usedSize: state.audioUsageBytes,
                minSize: 100 * 1024 * 1024, // 100 MB
                maxSize: 2 * 1024 * 1024 * 1024, // 2 GB
                onChanged: (value) {
                  context.read<CacheSettingsBloc>().add(
                    CacheSettingsEvent.updateAudioCacheSize(value.toInt()),
                  );
                },
              ),
              const SizedBox(height: 32),

              // WiFi-only mode toggle
              Card(
                child: SwitchListTile(
                  title: const Text('WiFi-Only Downloads'),
                  subtitle: const Text(
                    'Download media only when connected to WiFi',
                  ),
                  value: state.config.wifiOnlyMode,
                  onChanged: (value) {
                    context.read<CacheSettingsBloc>().add(
                      CacheSettingsEvent.toggleWifiOnly(value),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Clear cache button
              ElevatedButton.icon(
                onPressed: () => _showClearCacheDialog(context),
                icon: const Icon(Icons.delete_sweep),
                label: const Text('Clear All Cache'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),

              const SizedBox(height: 16),

              // Clear offline queue button
              OutlinedButton.icon(
                onPressed: () => _showClearOfflineQueueDialog(context),
                icon: const Icon(Icons.sync_problem),
                label: const Text('Clear Offline Queue'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.orange,
                  side: const BorderSide(color: Colors.orange),
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),

              const SizedBox(height: 24),

              // Total usage summary
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Cache Usage',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatBytes(
                          state.imageUsageBytes +
                              state.videoUsageBytes +
                              state.audioUsageBytes,
                        ),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text(
          'This will delete all cached images, videos, and audio. '
          'Are you sure you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<CacheSettingsBloc>().add(
                const CacheSettingsEvent.clearCache(),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showClearOfflineQueueDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear Offline Queue'),
        content: const Text(
          'This will delete all pending offline requests. '
          'Use this if you have stuck requests that keep failing. '
          'Are you sure you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              try {
                await MyItihasRepository.instance.clearOfflineQueue();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Offline queue cleared successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to clear queue: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}

class _CacheSizeSlider extends StatelessWidget {
  final String title;
  final int currentSize;
  final int usedSize;
  final int minSize;
  final int maxSize;
  final ValueChanged<double> onChanged;

  const _CacheSizeSlider({
    required this.title,
    required this.currentSize,
    required this.usedSize,
    required this.minSize,
    required this.maxSize,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = usedSize / currentSize;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _formatBytes(currentSize),
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Used: ${_formatBytes(usedSize)} (${(percentage * 100).toStringAsFixed(1)}%)',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: percentage.clamp(0.0, 1.0),
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                percentage > 0.9
                    ? Colors.red
                    : percentage > 0.7
                    ? Colors.orange
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Slider(
              value: currentSize.toDouble(),
              min: minSize.toDouble(),
              max: maxSize.toDouble(),
              divisions: 19, // 100MB increments
              label: _formatBytes(currentSize.toInt()),
              onChanged: onChanged,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatBytes(minSize),
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  _formatBytes(maxSize),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}
