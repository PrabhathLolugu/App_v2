// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260217032826_up = [
  DropColumn('shared_story_id', onTable: 'MessageModel'),
  InsertColumn('shared_content_id', Column.varchar, onTable: 'MessageModel')
];

const List<MigrationCommand> _migration_20260217032826_down = [
  DropColumn('shared_content_id', onTable: 'MessageModel')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260217032826',
  up: _migration_20260217032826_up,
  down: _migration_20260217032826_down,
)
class Migration20260217032826 extends Migration {
  const Migration20260217032826()
    : super(
        version: 20260217032826,
        up: _migration_20260217032826_up,
        down: _migration_20260217032826_down,
      );
}
