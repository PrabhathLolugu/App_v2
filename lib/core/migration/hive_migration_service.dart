import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:myitihas/core/logging/talker_setup.dart';

@lazySingleton
class HiveMigrationService {
  static const String _migrationCompleteKey = 'hive_migration_complete';
  static const String _migrationFailedKey = 'hive_migration_failed_count';

  Future<void> runMigration() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if already completed
    if (prefs.getBool(_migrationCompleteKey) == true) {
      talker.debug('Hive migration already completed');
      return;
    }

    // Check if Hive directory exists
    final appDocDir = await getApplicationDocumentsDirectory();
    final hiveDir = Directory('${appDocDir.path}/hive');

    if (!await hiveDir.exists()) {
      talker.info('No Hive data found, marking migration complete');
      await prefs.setBool(_migrationCompleteKey, true);
      return;
    }

    talker.info('Starting Hive data cleanup...');
    await _cleanupHiveData(hiveDir, prefs);
  }

  Future<void> _cleanupHiveData(Directory hiveDir, SharedPreferences prefs) async {
    try {
      await hiveDir.delete(recursive: true);
      talker.info('Hive directory deleted successfully');

      await prefs.setBool(_migrationCompleteKey, true);
      await prefs.remove(_migrationFailedKey);
    } catch (e, stack) {
      talker.error('Failed to delete Hive directory', e, stack);

      final failCount = prefs.getInt(_migrationFailedKey) ?? 0;

      if (failCount < 1) {
        talker.info('Retrying Hive cleanup (attempt 2/2)');
        await prefs.setInt(_migrationFailedKey, failCount + 1);

        // Wait a bit before retry
        await Future.delayed(const Duration(seconds: 2));

        if (await hiveDir.exists()) {
          return _cleanupHiveData(hiveDir, prefs);
        }
      } else {
        talker.error('Hive migration abandoned after retry - continuing silently');
        await prefs.setBool(_migrationCompleteKey, true);
      }
    }
  }
}
