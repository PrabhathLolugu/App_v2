// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260129150730_up = [
  InsertTable('ImagePostModel'),
  InsertTable('TextPostModel'),
  InsertTable('UserModel'),
  InsertTable('VideoPostModel'),
  InsertColumn('id', Column.varchar, onTable: 'ImagePostModel'),
  InsertColumn('image_url', Column.varchar, onTable: 'ImagePostModel'),
  InsertColumn('caption', Column.varchar, onTable: 'ImagePostModel'),
  InsertColumn('location', Column.varchar, onTable: 'ImagePostModel'),
  InsertColumn('aspect_ratio', Column.Double, onTable: 'ImagePostModel'),
  InsertColumn('created_at', Column.datetime, onTable: 'ImagePostModel'),
  InsertColumn('author_id', Column.varchar, onTable: 'ImagePostModel'),
  InsertForeignKey('ImagePostModel', 'UserModel', foreignKeyColumn: 'author_UserModel_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  InsertColumn('likes', Column.integer, onTable: 'ImagePostModel'),
  InsertColumn('comment_count', Column.integer, onTable: 'ImagePostModel'),
  InsertColumn('share_count', Column.integer, onTable: 'ImagePostModel'),
  InsertColumn('is_liked_by_current_user', Column.boolean, onTable: 'ImagePostModel'),
  InsertColumn('is_favorite', Column.boolean, onTable: 'ImagePostModel'),
  InsertColumn('metadata', Column.varchar, onTable: 'ImagePostModel'),
  InsertColumn('id', Column.varchar, onTable: 'TextPostModel'),
  InsertColumn('body', Column.varchar, onTable: 'TextPostModel'),
  InsertColumn('image_url', Column.varchar, onTable: 'TextPostModel'),
  InsertColumn('created_at', Column.datetime, onTable: 'TextPostModel'),
  InsertColumn('author_id', Column.varchar, onTable: 'TextPostModel'),
  InsertForeignKey('TextPostModel', 'UserModel', foreignKeyColumn: 'author_UserModel_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  InsertColumn('likes', Column.integer, onTable: 'TextPostModel'),
  InsertColumn('comment_count', Column.integer, onTable: 'TextPostModel'),
  InsertColumn('share_count', Column.integer, onTable: 'TextPostModel'),
  InsertColumn('is_liked_by_current_user', Column.boolean, onTable: 'TextPostModel'),
  InsertColumn('is_favorite', Column.boolean, onTable: 'TextPostModel'),
  InsertColumn('metadata', Column.varchar, onTable: 'TextPostModel'),
  InsertColumn('id', Column.varchar, onTable: 'UserModel'),
  InsertColumn('username', Column.varchar, onTable: 'UserModel'),
  InsertColumn('display_name', Column.varchar, onTable: 'UserModel'),
  InsertColumn('avatar_url', Column.varchar, onTable: 'UserModel'),
  InsertColumn('bio', Column.varchar, onTable: 'UserModel'),
  InsertColumn('follower_count', Column.integer, onTable: 'UserModel'),
  InsertColumn('following_count', Column.integer, onTable: 'UserModel'),
  InsertColumn('is_following', Column.boolean, onTable: 'UserModel'),
  InsertColumn('is_current_user', Column.boolean, onTable: 'UserModel'),
  InsertColumn('saved_stories', Column.varchar, onTable: 'UserModel'),
  InsertColumn('id', Column.varchar, onTable: 'VideoPostModel'),
  InsertColumn('media_urls', Column.varchar, onTable: 'VideoPostModel'),
  InsertColumn('video_url', Column.varchar, onTable: 'VideoPostModel'),
  InsertColumn('thumbnail_url', Column.varchar, onTable: 'VideoPostModel'),
  InsertColumn('caption', Column.varchar, onTable: 'VideoPostModel'),
  InsertColumn('aspect_ratio', Column.Double, onTable: 'VideoPostModel'),
  InsertColumn('created_at', Column.datetime, onTable: 'VideoPostModel'),
  InsertColumn('author_id', Column.varchar, onTable: 'VideoPostModel'),
  InsertForeignKey('VideoPostModel', 'UserModel', foreignKeyColumn: 'author_UserModel_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  InsertColumn('likes', Column.integer, onTable: 'VideoPostModel'),
  InsertColumn('comment_count', Column.integer, onTable: 'VideoPostModel'),
  InsertColumn('share_count', Column.integer, onTable: 'VideoPostModel'),
  InsertColumn('is_liked_by_current_user', Column.boolean, onTable: 'VideoPostModel'),
  InsertColumn('is_favorite', Column.boolean, onTable: 'VideoPostModel'),
  InsertColumn('metadata', Column.varchar, onTable: 'VideoPostModel')
];

const List<MigrationCommand> _migration_20260129150730_down = [
  DropTable('ImagePostModel'),
  DropTable('TextPostModel'),
  DropTable('UserModel'),
  DropTable('VideoPostModel'),
  DropColumn('id', onTable: 'ImagePostModel'),
  DropColumn('image_url', onTable: 'ImagePostModel'),
  DropColumn('caption', onTable: 'ImagePostModel'),
  DropColumn('location', onTable: 'ImagePostModel'),
  DropColumn('aspect_ratio', onTable: 'ImagePostModel'),
  DropColumn('created_at', onTable: 'ImagePostModel'),
  DropColumn('author_id', onTable: 'ImagePostModel'),
  DropColumn('author_UserModel_brick_id', onTable: 'ImagePostModel'),
  DropColumn('likes', onTable: 'ImagePostModel'),
  DropColumn('comment_count', onTable: 'ImagePostModel'),
  DropColumn('share_count', onTable: 'ImagePostModel'),
  DropColumn('is_liked_by_current_user', onTable: 'ImagePostModel'),
  DropColumn('is_favorite', onTable: 'ImagePostModel'),
  DropColumn('metadata', onTable: 'ImagePostModel'),
  DropColumn('id', onTable: 'TextPostModel'),
  DropColumn('body', onTable: 'TextPostModel'),
  DropColumn('image_url', onTable: 'TextPostModel'),
  DropColumn('created_at', onTable: 'TextPostModel'),
  DropColumn('author_id', onTable: 'TextPostModel'),
  DropColumn('author_UserModel_brick_id', onTable: 'TextPostModel'),
  DropColumn('likes', onTable: 'TextPostModel'),
  DropColumn('comment_count', onTable: 'TextPostModel'),
  DropColumn('share_count', onTable: 'TextPostModel'),
  DropColumn('is_liked_by_current_user', onTable: 'TextPostModel'),
  DropColumn('is_favorite', onTable: 'TextPostModel'),
  DropColumn('metadata', onTable: 'TextPostModel'),
  DropColumn('id', onTable: 'UserModel'),
  DropColumn('username', onTable: 'UserModel'),
  DropColumn('display_name', onTable: 'UserModel'),
  DropColumn('avatar_url', onTable: 'UserModel'),
  DropColumn('bio', onTable: 'UserModel'),
  DropColumn('follower_count', onTable: 'UserModel'),
  DropColumn('following_count', onTable: 'UserModel'),
  DropColumn('is_following', onTable: 'UserModel'),
  DropColumn('is_current_user', onTable: 'UserModel'),
  DropColumn('saved_stories', onTable: 'UserModel'),
  DropColumn('id', onTable: 'VideoPostModel'),
  DropColumn('media_urls', onTable: 'VideoPostModel'),
  DropColumn('video_url', onTable: 'VideoPostModel'),
  DropColumn('thumbnail_url', onTable: 'VideoPostModel'),
  DropColumn('caption', onTable: 'VideoPostModel'),
  DropColumn('aspect_ratio', onTable: 'VideoPostModel'),
  DropColumn('created_at', onTable: 'VideoPostModel'),
  DropColumn('author_id', onTable: 'VideoPostModel'),
  DropColumn('author_UserModel_brick_id', onTable: 'VideoPostModel'),
  DropColumn('likes', onTable: 'VideoPostModel'),
  DropColumn('comment_count', onTable: 'VideoPostModel'),
  DropColumn('share_count', onTable: 'VideoPostModel'),
  DropColumn('is_liked_by_current_user', onTable: 'VideoPostModel'),
  DropColumn('is_favorite', onTable: 'VideoPostModel'),
  DropColumn('metadata', onTable: 'VideoPostModel')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260129150730',
  up: _migration_20260129150730_up,
  down: _migration_20260129150730_down,
)
class Migration20260129150730 extends Migration {
  const Migration20260129150730()
    : super(
        version: 20260129150730,
        up: _migration_20260129150730_up,
        down: _migration_20260129150730_down,
      );
}
