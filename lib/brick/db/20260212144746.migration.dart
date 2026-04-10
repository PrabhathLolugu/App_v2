// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260212144746_up = [
  InsertColumn('is_deleted_for_everyone', Column.boolean, onTable: 'MessageModel')
];

const List<MigrationCommand> _migration_20260212144746_down = [
  DropColumn('is_deleted_for_everyone', onTable: 'MessageModel')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260212144746',
  up: _migration_20260212144746_up,
  down: _migration_20260212144746_down,
)
class Migration20260212144746 extends Migration {
  const Migration20260212144746()
    : super(
        version: 20260212144746,
        up: _migration_20260212144746_up,
        down: _migration_20260212144746_down,
      );
}
