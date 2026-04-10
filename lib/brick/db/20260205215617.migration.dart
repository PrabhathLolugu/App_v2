// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260205215617_up = [
  InsertColumn('user_id', Column.varchar, onTable: 'StoryModel')
];

const List<MigrationCommand> _migration_20260205215617_down = [
  DropColumn('user_id', onTable: 'StoryModel')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260205215617',
  up: _migration_20260205215617_up,
  down: _migration_20260205215617_down,
)
class Migration20260205215617 extends Migration {
  const Migration20260205215617()
    : super(
        version: 20260205215617,
        up: _migration_20260205215617_up,
        down: _migration_20260205215617_down,
      );
}
