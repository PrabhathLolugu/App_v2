// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260129195228_up = [
  DropColumn('location', onTable: 'ImagePostModel'),
  DropColumn('aspect_ratio', onTable: 'ImagePostModel'),
  DropColumn('aspect_ratio', onTable: 'VideoPostModel'),
  InsertColumn('media_urls', Column.varchar, onTable: 'ImagePostModel'),
  InsertColumn('content', Column.varchar, onTable: 'ImagePostModel'),
  InsertColumn('content', Column.varchar, onTable: 'VideoPostModel'),
  InsertColumn('video_duration_seconds', Column.integer, onTable: 'VideoPostModel'),
  InsertColumn('view_count', Column.integer, onTable: 'VideoPostModel')
];

const List<MigrationCommand> _migration_20260129195228_down = [
  DropColumn('media_urls', onTable: 'ImagePostModel'),
  DropColumn('content', onTable: 'ImagePostModel'),
  DropColumn('content', onTable: 'VideoPostModel'),
  DropColumn('video_duration_seconds', onTable: 'VideoPostModel'),
  DropColumn('view_count', onTable: 'VideoPostModel')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260129195228',
  up: _migration_20260129195228_up,
  down: _migration_20260129195228_down,
)
class Migration20260129195228 extends Migration {
  const Migration20260129195228()
    : super(
        version: 20260129195228,
        up: _migration_20260129195228_up,
        down: _migration_20260129195228_down,
      );
}
