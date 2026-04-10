// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260205211846_up = [
  InsertColumn('image_url', Column.varchar, onTable: 'StoryModel')
];

const List<MigrationCommand> _migration_20260205211846_down = [
  DropColumn('image_url', onTable: 'StoryModel')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260205211846',
  up: _migration_20260205211846_up,
  down: _migration_20260205211846_down,
)
class Migration20260205211846 extends Migration {
  const Migration20260205211846()
    : super(
        version: 20260205211846,
        up: _migration_20260205211846_up,
        down: _migration_20260205211846_down,
      );
}
