// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_core/query.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_sqlite/db.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_supabase/brick_supabase.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_sqlite/brick_sqlite.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:myitihas/features/social/data/models/user.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:myitihas/features/chat/domain/entities/conversation.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:myitihas/features/chat/domain/entities/message.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:myitihas/features/social/domain/entities/image_post.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:myitihas/features/social/domain/entities/post_mention.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:myitihas/features/social/domain/entities/post_poll.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:myitihas/features/social/domain/entities/text_post.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:myitihas/features/social/domain/entities/user.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:myitihas/features/social/domain/entities/video_post.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:myitihas/features/stories/domain/entities/story.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:myitihas/features/story_generator/domain/entities/story_translation.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:myitihas/core/logging/talker_setup.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:myitihas/features/story_generator/domain/entities/story_chat_message.dart';// GENERATED CODE DO NOT EDIT
// ignore: unused_import
import 'dart:convert';
import 'package:brick_sqlite/brick_sqlite.dart' show SqliteModel, SqliteAdapter, SqliteModelDictionary, RuntimeSqliteColumnDefinition, SqliteProvider;
import 'package:brick_supabase/brick_supabase.dart' show SupabaseProvider, SupabaseModel, SupabaseAdapter, SupabaseModelDictionary;
// ignore: unused_import, unused_shown_name
import 'package:brick_offline_first/brick_offline_first.dart' show RuntimeOfflineFirstDefinition;
// ignore: unused_import, unused_shown_name
import 'package:sqflite_common/sqlite_api.dart' show DatabaseExecutor;

import '../features/chat/data/models/conversation.model.dart';
import '../features/chat/data/models/message.model.dart';
import '../features/social/data/models/image_post.model.dart';
import '../features/social/data/models/text_post.model.dart';
import '../features/social/data/models/user.model.dart';
import '../features/social/data/models/video_post.model.dart';
import '../features/stories/data/models/story.model.dart';
import '../features/stories/data/models/story_attributes.model.dart';
import '../features/story_generator/data/models/story_chat_conversation.model.dart';

part 'adapters/conversation_model_adapter.g.dart';
part 'adapters/message_model_adapter.g.dart';
part 'adapters/image_post_model_adapter.g.dart';
part 'adapters/text_post_model_adapter.g.dart';
part 'adapters/user_model_adapter.g.dart';
part 'adapters/video_post_model_adapter.g.dart';
part 'adapters/story_model_adapter.g.dart';
part 'adapters/story_attributes_model_adapter.g.dart';
part 'adapters/story_chat_conversation_model_adapter.g.dart';

/// Supabase mappings should only be used when initializing a [SupabaseProvider]
final Map<Type, SupabaseAdapter<SupabaseModel>> supabaseMappings = {
  ConversationModel: ConversationModelAdapter(),
  MessageModel: MessageModelAdapter(),
  ImagePostModel: ImagePostModelAdapter(),
  TextPostModel: TextPostModelAdapter(),
  UserModel: UserModelAdapter(),
  VideoPostModel: VideoPostModelAdapter(),
  StoryModel: StoryModelAdapter(),
  StoryAttributesModel: StoryAttributesModelAdapter(),
  StoryChatConversationModel: StoryChatConversationModelAdapter()
};
final supabaseModelDictionary = SupabaseModelDictionary(supabaseMappings);

/// Sqlite mappings should only be used when initializing a [SqliteProvider]
final Map<Type, SqliteAdapter<SqliteModel>> sqliteMappings = {
  ConversationModel: ConversationModelAdapter(),
  MessageModel: MessageModelAdapter(),
  ImagePostModel: ImagePostModelAdapter(),
  TextPostModel: TextPostModelAdapter(),
  UserModel: UserModelAdapter(),
  VideoPostModel: VideoPostModelAdapter(),
  StoryModel: StoryModelAdapter(),
  StoryAttributesModel: StoryAttributesModelAdapter(),
  StoryChatConversationModel: StoryChatConversationModelAdapter()
};
final sqliteModelDictionary = SqliteModelDictionary(sqliteMappings);
