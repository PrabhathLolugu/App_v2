// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260329070403_up = [
  InsertColumn('metadata', Column.varchar, onTable: 'MessageModel')
];

const List<MigrationCommand> _migration_20260329070403_down = [
  DropColumn('metadata', onTable: 'MessageModel')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260329070403',
  up: _migration_20260329070403_up,
  down: _migration_20260329070403_down,
)
class Migration20260329070403 extends Migration {
  const Migration20260329070403()
    : super(
        version: 20260329070403,
        up: _migration_20260329070403_up,
        down: _migration_20260329070403_down,
      );
}
