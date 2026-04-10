// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260129195806_up = [
  DropColumn('scripture', onTable: 'StoryModel'),
  DropColumn('story', onTable: 'StoryModel'),
  DropColumn('quotes', onTable: 'StoryModel'),
  DropColumn('trivia', onTable: 'StoryModel'),
  DropColumn('activity', onTable: 'StoryModel'),
  DropColumn('lesson', onTable: 'StoryModel'),
  DropColumn('attributes_StoryAttributesModel_brick_id', onTable: 'StoryModel'),
  DropColumn('is_liked_by_current_user', onTable: 'ImagePostModel'),
  DropColumn('is_favorite', onTable: 'ImagePostModel'),
  DropColumn('is_liked_by_current_user', onTable: 'TextPostModel'),
  DropColumn('is_favorite', onTable: 'TextPostModel'),
  DropColumn('follower_count', onTable: 'UserModel'),
  DropColumn('following_count', onTable: 'UserModel'),
  DropColumn('is_following', onTable: 'UserModel'),
  DropColumn('is_current_user', onTable: 'UserModel'),
  DropColumn('saved_stories', onTable: 'UserModel'),
  DropColumn('is_liked_by_current_user', onTable: 'VideoPostModel'),
  DropColumn('is_favorite', onTable: 'VideoPostModel'),
  InsertColumn('content', Column.varchar, onTable: 'StoryModel'),
  InsertColumn('attributes_json', Column.varchar, onTable: 'StoryModel'),
  InsertColumn('metadata', Column.varchar, onTable: 'StoryModel'),
  InsertColumn('comment_count', Column.integer, onTable: 'StoryModel'),
  InsertColumn('share_count', Column.integer, onTable: 'StoryModel')
];

const List<MigrationCommand> _migration_20260129195806_down = [
  DropColumn('content', onTable: 'StoryModel'),
  DropColumn('attributes_json', onTable: 'StoryModel'),
  DropColumn('metadata', onTable: 'StoryModel'),
  DropColumn('comment_count', onTable: 'StoryModel'),
  DropColumn('share_count', onTable: 'StoryModel')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260129195806',
  up: _migration_20260129195806_up,
  down: _migration_20260129195806_down,
)
class Migration20260129195806 extends Migration {
  const Migration20260129195806()
    : super(
        version: 20260129195806,
        up: _migration_20260129195806_up,
        down: _migration_20260129195806_down,
      );
}
