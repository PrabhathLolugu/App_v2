// GENERATED CODE DO NOT EDIT
// This file should be version controlled
import 'package:brick_sqlite/db.dart';
part '20260129103441.migration.dart';
part '20260129123818.migration.dart';
part '20260129150730.migration.dart';
part '20260129185420.migration.dart';
part '20260129195228.migration.dart';
part '20260129195806.migration.dart';
part '20260129195916.migration.dart';
part '20260129201101.migration.dart';
part '20260129201552.migration.dart';
part '20260129202000.migration.dart';
part '20260130062644.migration.dart';
part '20260131214652.migration.dart';
part '20260203062018.migration.dart';
part '20260205211846.migration.dart';
part '20260205215617.migration.dart';
part '20260210161847.migration.dart';
part '20260212140613.migration.dart';
part '20260212143820.migration.dart';
part '20260212144746.migration.dart';
part '20260212155105.migration.dart';
part '20260217032826.migration.dart';
part '20260329070403.migration.dart';
part '20260329195146.migration.dart';
part '20260329201809.migration.dart';

/// All intelligently-generated migrations from all `@Migratable` classes on disk
final migrations = <Migration>{
  const Migration20260129103441(),
  const Migration20260129123818(),
  const Migration20260129150730(),
  const Migration20260129185420(),
  const Migration20260129195228(),
  const Migration20260129195806(),
  const Migration20260129195916(),
  const Migration20260129201101(),
  const Migration20260129201552(),
  const Migration20260129202000(),
  const Migration20260130062644(),
  const Migration20260131214652(),
  const Migration20260203062018(),
  const Migration20260205211846(),
  const Migration20260205215617(),
  const Migration20260210161847(),
  const Migration20260212140613(),
  const Migration20260212143820(),
  const Migration20260212144746(),
  const Migration20260212155105(),
  const Migration20260217032826(),
  const Migration20260329070403(),
  const Migration20260329195146(),
  const Migration20260329201809(),
};

/// A consumable database structure including the latest generated migration.
final schema = Schema(
  20260329201809,
  generatorVersion: 1,
  tables: <SchemaTable>{
    SchemaTable(
      'ConversationModel',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn('id', Column.varchar),
        SchemaColumn('is_group', Column.boolean),
        SchemaColumn('group_name', Column.varchar),
        SchemaColumn('group_avatar_url', Column.varchar),
        SchemaColumn('group_description', Column.varchar),
        SchemaColumn('last_message', Column.varchar),
        SchemaColumn('last_message_at', Column.datetime),
        SchemaColumn('last_message_sender_id', Column.varchar),
        SchemaColumn('created_at', Column.datetime),
        SchemaColumn('updated_at', Column.datetime),
        SchemaColumn('participant_ids', Column.varchar),
        SchemaColumn('unread_count', Column.integer),
      },
      indices: <SchemaIndex>{},
    ),
    SchemaTable(
      'MessageModel',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn('id', Column.varchar),
        SchemaColumn('conversation_id', Column.varchar),
        SchemaColumn('sender_id', Column.varchar),
        SchemaColumn(
          'sender_UserModel_brick_id',
          Column.integer,
          isForeignKey: true,
          foreignTableName: 'UserModel',
          onDeleteCascade: false,
          onDeleteSetDefault: false,
        ),
        SchemaColumn('content', Column.varchar),
        SchemaColumn('type', Column.varchar),
        SchemaColumn('created_at', Column.datetime),
        SchemaColumn('delivery_status', Column.varchar),
        SchemaColumn('read_by', Column.varchar),
        SchemaColumn('shared_content_id', Column.varchar),
        SchemaColumn('metadata', Column.varchar),
      },
      indices: <SchemaIndex>{},
    ),
    SchemaTable(
      'ImagePostModel',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn('id', Column.varchar),
        SchemaColumn('post_type', Column.varchar),
        SchemaColumn('media_urls', Column.varchar),
        SchemaColumn('content', Column.varchar),
        SchemaColumn('created_at', Column.datetime),
        SchemaColumn('author_id', Column.varchar),
        SchemaColumn(
          'author_UserModel_brick_id',
          Column.integer,
          isForeignKey: true,
          foreignTableName: 'UserModel',
          onDeleteCascade: false,
          onDeleteSetDefault: false,
        ),
        SchemaColumn('likes', Column.integer),
        SchemaColumn('comment_count', Column.integer),
        SchemaColumn('share_count', Column.integer),
        SchemaColumn('metadata', Column.varchar),
      },
      indices: <SchemaIndex>{},
    ),
    SchemaTable(
      'TextPostModel',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn('id', Column.varchar),
        SchemaColumn('post_type', Column.varchar),
        SchemaColumn('body', Column.varchar),
        SchemaColumn('image_url', Column.varchar),
        SchemaColumn('created_at', Column.datetime),
        SchemaColumn('author_id', Column.varchar),
        SchemaColumn(
          'author_UserModel_brick_id',
          Column.integer,
          isForeignKey: true,
          foreignTableName: 'UserModel',
          onDeleteCascade: false,
          onDeleteSetDefault: false,
        ),
        SchemaColumn('likes', Column.integer),
        SchemaColumn('comment_count', Column.integer),
        SchemaColumn('share_count', Column.integer),
        SchemaColumn('metadata', Column.varchar),
      },
      indices: <SchemaIndex>{},
    ),
    SchemaTable(
      'UserModel',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn('id', Column.varchar),
        SchemaColumn('username', Column.varchar),
        SchemaColumn('display_name', Column.varchar),
        SchemaColumn('avatar_url', Column.varchar),
        SchemaColumn('bio', Column.varchar),
        SchemaColumn('is_verified', Column.boolean),
        SchemaColumn('accepts_direct_messages', Column.boolean),
        SchemaColumn('is_official_myitihas', Column.boolean),
      },
      indices: <SchemaIndex>{},
    ),
    SchemaTable(
      'VideoPostModel',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn('id', Column.varchar),
        SchemaColumn('post_type', Column.varchar),
        SchemaColumn('media_urls', Column.varchar),
        SchemaColumn('thumbnail_url', Column.varchar),
        SchemaColumn('content', Column.varchar),
        SchemaColumn('video_duration_seconds', Column.integer),
        SchemaColumn('created_at', Column.datetime),
        SchemaColumn('author_id', Column.varchar),
        SchemaColumn(
          'author_UserModel_brick_id',
          Column.integer,
          isForeignKey: true,
          foreignTableName: 'UserModel',
          onDeleteCascade: false,
          onDeleteSetDefault: false,
        ),
        SchemaColumn('likes', Column.integer),
        SchemaColumn('comment_count', Column.integer),
        SchemaColumn('share_count', Column.integer),
        SchemaColumn('view_count', Column.integer),
        SchemaColumn('metadata', Column.varchar),
      },
      indices: <SchemaIndex>{},
    ),
    SchemaTable(
      'StoryModel',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn('id', Column.varchar),
        SchemaColumn('user_id', Column.varchar),
        SchemaColumn('title', Column.varchar),
        SchemaColumn('content', Column.varchar),
        SchemaColumn('attributes_json', Column.varchar),
        SchemaColumn('metadata', Column.varchar),
        SchemaColumn('image_url', Column.varchar),
        SchemaColumn('author', Column.varchar),
        SchemaColumn('author_id', Column.varchar),
        SchemaColumn('published_at', Column.datetime),
        SchemaColumn('created_at', Column.datetime),
        SchemaColumn('updated_at', Column.datetime),
        SchemaColumn('likes', Column.integer),
        SchemaColumn('views', Column.integer),
        SchemaColumn('is_favorite', Column.boolean),
        SchemaColumn('comment_count', Column.integer),
        SchemaColumn('share_count', Column.integer),
        SchemaColumn('is_featured', Column.boolean),
      },
      indices: <SchemaIndex>{},
    ),
    SchemaTable(
      'StoryAttributesModel',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn('id', Column.varchar),
        SchemaColumn('story_type', Column.varchar),
        SchemaColumn('theme', Column.varchar),
        SchemaColumn('main_character_type', Column.varchar),
        SchemaColumn('story_setting', Column.varchar),
        SchemaColumn('time_era', Column.varchar),
        SchemaColumn('narrative_perspective', Column.varchar),
        SchemaColumn('language_style', Column.varchar),
        SchemaColumn('emotional_tone', Column.varchar),
        SchemaColumn('narrative_style', Column.varchar),
        SchemaColumn('plot_structure', Column.varchar),
        SchemaColumn('story_length', Column.varchar),
        SchemaColumn('references', Column.varchar),
        SchemaColumn('tags', Column.varchar),
        SchemaColumn('characters', Column.varchar),
        SchemaColumn('character_details', Column.varchar),
        SchemaColumn('translations', Column.varchar),
      },
      indices: <SchemaIndex>{},
    ),
    SchemaTable(
      'StoryChatConversationModel',
      columns: <SchemaColumn>{
        SchemaColumn(
          '_brick_id',
          Column.integer,
          autoincrement: true,
          nullable: false,
          isPrimaryKey: true,
        ),
        SchemaColumn('id', Column.varchar),
        SchemaColumn('story_id', Column.varchar),
        SchemaColumn('user_id', Column.varchar),
        SchemaColumn('title', Column.varchar),
        SchemaColumn('messages', Column.varchar),
        SchemaColumn('created_at', Column.datetime),
        SchemaColumn('updated_at', Column.datetime),
      },
      indices: <SchemaIndex>{},
    ),
  },
);
