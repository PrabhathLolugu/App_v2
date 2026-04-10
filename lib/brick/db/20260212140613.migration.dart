// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260212140613_up = [
  InsertColumn('is_deleted_for_everyone', Column.boolean, onTable: 'MessageModel'),
  InsertColumn('deleted_for_user_ids', Column.varchar, onTable: 'MessageModel')
];

const List<MigrationCommand> _migration_20260212140613_down = [
  DropColumn('is_deleted_for_everyone', onTable: 'MessageModel'),
  DropColumn('deleted_for_user_ids', onTable: 'MessageModel')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260212140613',
  up: _migration_20260212140613_up,
  down: _migration_20260212140613_down,
)
class Migration20260212140613 extends Migration {
  const Migration20260212140613()
    : super(
        version: 20260212140613,
        up: _migration_20260212140613_up,
        down: _migration_20260212140613_down,
      );
}
