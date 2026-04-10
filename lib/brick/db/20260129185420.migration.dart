// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260129185420_up = [
  InsertColumn('post_type', Column.varchar, onTable: 'ImagePostModel'),
  InsertColumn('post_type', Column.varchar, onTable: 'TextPostModel'),
  InsertColumn('post_type', Column.varchar, onTable: 'VideoPostModel')
];

const List<MigrationCommand> _migration_20260129185420_down = [
  DropColumn('post_type', onTable: 'ImagePostModel'),
  DropColumn('post_type', onTable: 'TextPostModel'),
  DropColumn('post_type', onTable: 'VideoPostModel')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260129185420',
  up: _migration_20260129185420_up,
  down: _migration_20260129185420_down,
)
class Migration20260129185420 extends Migration {
  const Migration20260129185420()
    : super(
        version: 20260129185420,
        up: _migration_20260129185420_up,
        down: _migration_20260129185420_down,
      );
}
