// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260129201101_up = [
  DropColumn('content', onTable: 'StoryModel'),
  DropColumn('attributes_json', onTable: 'StoryModel'),
  DropColumn('metadata', onTable: 'StoryModel')
];

const List<MigrationCommand> _migration_20260129201101_down = [
  
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260129201101',
  up: _migration_20260129201101_up,
  down: _migration_20260129201101_down,
)
class Migration20260129201101 extends Migration {
  const Migration20260129201101()
    : super(
        version: 20260129201101,
        up: _migration_20260129201101_up,
        down: _migration_20260129201101_down,
      );
}
