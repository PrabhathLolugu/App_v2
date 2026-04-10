// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260129103441_up = [
  InsertTable('StoryModel'),
  InsertTable('StoryAttributesModel'),
  InsertColumn('id', Column.varchar, onTable: 'StoryModel'),
  InsertColumn('title', Column.varchar, onTable: 'StoryModel'),
  InsertColumn('scripture', Column.varchar, onTable: 'StoryModel'),
  InsertColumn('story', Column.varchar, onTable: 'StoryModel'),
  InsertColumn('quotes', Column.varchar, onTable: 'StoryModel'),
  InsertColumn('trivia', Column.varchar, onTable: 'StoryModel'),
  InsertColumn('activity', Column.varchar, onTable: 'StoryModel'),
  InsertColumn('lesson', Column.varchar, onTable: 'StoryModel'),
  InsertForeignKey('StoryModel', 'StoryAttributesModel', foreignKeyColumn: 'attributes_StoryAttributesModel_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  InsertColumn('image_url', Column.varchar, onTable: 'StoryModel'),
  InsertColumn('author', Column.varchar, onTable: 'StoryModel'),
  InsertColumn('published_at', Column.datetime, onTable: 'StoryModel'),
  InsertColumn('created_at', Column.datetime, onTable: 'StoryModel'),
  InsertColumn('updated_at', Column.datetime, onTable: 'StoryModel'),
  InsertColumn('likes', Column.integer, onTable: 'StoryModel'),
  InsertColumn('views', Column.integer, onTable: 'StoryModel'),
  InsertColumn('is_favorite', Column.boolean, onTable: 'StoryModel'),
  InsertColumn('author_id', Column.varchar, onTable: 'StoryModel'),
  InsertColumn('id', Column.varchar, onTable: 'StoryAttributesModel'),
  InsertColumn('story_type', Column.varchar, onTable: 'StoryAttributesModel'),
  InsertColumn('theme', Column.varchar, onTable: 'StoryAttributesModel'),
  InsertColumn('main_character_type', Column.varchar, onTable: 'StoryAttributesModel'),
  InsertColumn('story_setting', Column.varchar, onTable: 'StoryAttributesModel'),
  InsertColumn('time_era', Column.varchar, onTable: 'StoryAttributesModel'),
  InsertColumn('narrative_perspective', Column.varchar, onTable: 'StoryAttributesModel'),
  InsertColumn('language_style', Column.varchar, onTable: 'StoryAttributesModel'),
  InsertColumn('emotional_tone', Column.varchar, onTable: 'StoryAttributesModel'),
  InsertColumn('narrative_style', Column.varchar, onTable: 'StoryAttributesModel'),
  InsertColumn('plot_structure', Column.varchar, onTable: 'StoryAttributesModel'),
  InsertColumn('story_length', Column.varchar, onTable: 'StoryAttributesModel'),
  InsertColumn('references', Column.varchar, onTable: 'StoryAttributesModel'),
  InsertColumn('tags', Column.varchar, onTable: 'StoryAttributesModel')
];

const List<MigrationCommand> _migration_20260129103441_down = [
  DropTable('StoryModel'),
  DropTable('StoryAttributesModel'),
  DropColumn('id', onTable: 'StoryModel'),
  DropColumn('title', onTable: 'StoryModel'),
  DropColumn('scripture', onTable: 'StoryModel'),
  DropColumn('story', onTable: 'StoryModel'),
  DropColumn('quotes', onTable: 'StoryModel'),
  DropColumn('trivia', onTable: 'StoryModel'),
  DropColumn('activity', onTable: 'StoryModel'),
  DropColumn('lesson', onTable: 'StoryModel'),
  DropColumn('attributes_StoryAttributesModel_brick_id', onTable: 'StoryModel'),
  DropColumn('image_url', onTable: 'StoryModel'),
  DropColumn('author', onTable: 'StoryModel'),
  DropColumn('published_at', onTable: 'StoryModel'),
  DropColumn('created_at', onTable: 'StoryModel'),
  DropColumn('updated_at', onTable: 'StoryModel'),
  DropColumn('likes', onTable: 'StoryModel'),
  DropColumn('views', onTable: 'StoryModel'),
  DropColumn('is_favorite', onTable: 'StoryModel'),
  DropColumn('author_id', onTable: 'StoryModel'),
  DropColumn('id', onTable: 'StoryAttributesModel'),
  DropColumn('story_type', onTable: 'StoryAttributesModel'),
  DropColumn('theme', onTable: 'StoryAttributesModel'),
  DropColumn('main_character_type', onTable: 'StoryAttributesModel'),
  DropColumn('story_setting', onTable: 'StoryAttributesModel'),
  DropColumn('time_era', onTable: 'StoryAttributesModel'),
  DropColumn('narrative_perspective', onTable: 'StoryAttributesModel'),
  DropColumn('language_style', onTable: 'StoryAttributesModel'),
  DropColumn('emotional_tone', onTable: 'StoryAttributesModel'),
  DropColumn('narrative_style', onTable: 'StoryAttributesModel'),
  DropColumn('plot_structure', onTable: 'StoryAttributesModel'),
  DropColumn('story_length', onTable: 'StoryAttributesModel'),
  DropColumn('references', onTable: 'StoryAttributesModel'),
  DropColumn('tags', onTable: 'StoryAttributesModel')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260129103441',
  up: _migration_20260129103441_up,
  down: _migration_20260129103441_down,
)
class Migration20260129103441 extends Migration {
  const Migration20260129103441()
    : super(
        version: 20260129103441,
        up: _migration_20260129103441_up,
        down: _migration_20260129103441_down,
      );
}
