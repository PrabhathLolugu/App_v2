// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260129123818_up = [
  InsertTable('StoryChatConversationModel'),
  InsertColumn('characters', Column.varchar, onTable: 'StoryAttributesModel'),
  InsertColumn(
    'character_details',
    Column.varchar,
    onTable: 'StoryAttributesModel',
  ),
  InsertColumn('translations', Column.varchar, onTable: 'StoryAttributesModel'),
  InsertColumn('id', Column.varchar, onTable: 'StoryChatConversationModel'),
  InsertColumn(
    'story_id',
    Column.varchar,
    onTable: 'StoryChatConversationModel',
  ),
  InsertColumn(
    'user_id',
    Column.varchar,
    onTable: 'StoryChatConversationModel',
  ),
  InsertColumn('title', Column.varchar, onTable: 'StoryChatConversationModel'),
  InsertColumn(
    'messages',
    Column.varchar,
    onTable: 'StoryChatConversationModel',
  ),
  InsertColumn(
    'created_at',
    Column.datetime,
    onTable: 'StoryChatConversationModel',
  ),
  InsertColumn(
    'updated_at',
    Column.datetime,
    onTable: 'StoryChatConversationModel',
  ),
];

const List<MigrationCommand> _migration_20260129123818_down = [
  DropTable('StoryChatConversationModel'),
  DropColumn('characters', onTable: 'StoryAttributesModel'),
  DropColumn('character_details', onTable: 'StoryAttributesModel'),
  DropColumn('translations', onTable: 'StoryAttributesModel'),
  DropColumn('id', onTable: 'StoryChatConversationModel'),
  DropColumn('story_id', onTable: 'StoryChatConversationModel'),
  DropColumn('user_id', onTable: 'StoryChatConversationModel'),
  DropColumn('title', onTable: 'StoryChatConversationModel'),
  DropColumn('messages', onTable: 'StoryChatConversationModel'),
  DropColumn('created_at', onTable: 'StoryChatConversationModel'),
  DropColumn('updated_at', onTable: 'StoryChatConversationModel'),
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260129123818',
  up: _migration_20260129123818_up,
  down: _migration_20260129123818_down,
)
class Migration20260129123818 extends Migration {
  const Migration20260129123818()
    : super(
        version: 20260129123818,
        up: _migration_20260129123818_up,
        down: _migration_20260129123818_down,
      );
}
