// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260130062644_up = [
  InsertTable('ConversationModel'),
  InsertTable('MessageModel'),
  InsertColumn('id', Column.varchar, onTable: 'ConversationModel'),
  InsertColumn('is_group', Column.boolean, onTable: 'ConversationModel'),
  InsertColumn('group_name', Column.varchar, onTable: 'ConversationModel'),
  InsertColumn('group_avatar_url', Column.varchar, onTable: 'ConversationModel'),
  InsertColumn('group_description', Column.varchar, onTable: 'ConversationModel'),
  InsertColumn('last_message', Column.varchar, onTable: 'ConversationModel'),
  InsertColumn('last_message_at', Column.datetime, onTable: 'ConversationModel'),
  InsertColumn('last_message_sender_id', Column.varchar, onTable: 'ConversationModel'),
  InsertColumn('created_at', Column.datetime, onTable: 'ConversationModel'),
  InsertColumn('updated_at', Column.datetime, onTable: 'ConversationModel'),
  InsertColumn('participant_ids', Column.varchar, onTable: 'ConversationModel'),
  InsertColumn('unread_count', Column.integer, onTable: 'ConversationModel'),
  InsertColumn('id', Column.varchar, onTable: 'MessageModel'),
  InsertColumn('conversation_id', Column.varchar, onTable: 'MessageModel'),
  InsertColumn('sender_id', Column.varchar, onTable: 'MessageModel'),
  InsertForeignKey('MessageModel', 'UserModel', foreignKeyColumn: 'sender_UserModel_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  InsertColumn('content', Column.varchar, onTable: 'MessageModel'),
  InsertColumn('type', Column.varchar, onTable: 'MessageModel'),
  InsertColumn('created_at', Column.datetime, onTable: 'MessageModel'),
  InsertColumn('delivery_status', Column.varchar, onTable: 'MessageModel'),
  InsertColumn('read_by', Column.varchar, onTable: 'MessageModel'),
  InsertColumn('shared_story_id', Column.varchar, onTable: 'MessageModel')
];

const List<MigrationCommand> _migration_20260130062644_down = [
  DropTable('ConversationModel'),
  DropTable('MessageModel'),
  DropColumn('id', onTable: 'ConversationModel'),
  DropColumn('is_group', onTable: 'ConversationModel'),
  DropColumn('group_name', onTable: 'ConversationModel'),
  DropColumn('group_avatar_url', onTable: 'ConversationModel'),
  DropColumn('group_description', onTable: 'ConversationModel'),
  DropColumn('last_message', onTable: 'ConversationModel'),
  DropColumn('last_message_at', onTable: 'ConversationModel'),
  DropColumn('last_message_sender_id', onTable: 'ConversationModel'),
  DropColumn('created_at', onTable: 'ConversationModel'),
  DropColumn('updated_at', onTable: 'ConversationModel'),
  DropColumn('participant_ids', onTable: 'ConversationModel'),
  DropColumn('unread_count', onTable: 'ConversationModel'),
  DropColumn('id', onTable: 'MessageModel'),
  DropColumn('conversation_id', onTable: 'MessageModel'),
  DropColumn('sender_id', onTable: 'MessageModel'),
  DropColumn('sender_UserModel_brick_id', onTable: 'MessageModel'),
  DropColumn('content', onTable: 'MessageModel'),
  DropColumn('type', onTable: 'MessageModel'),
  DropColumn('created_at', onTable: 'MessageModel'),
  DropColumn('delivery_status', onTable: 'MessageModel'),
  DropColumn('read_by', onTable: 'MessageModel'),
  DropColumn('shared_story_id', onTable: 'MessageModel')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260130062644',
  up: _migration_20260130062644_up,
  down: _migration_20260130062644_down,
)
class Migration20260130062644 extends Migration {
  const Migration20260130062644()
    : super(
        version: 20260130062644,
        up: _migration_20260130062644_up,
        down: _migration_20260130062644_down,
      );
}
