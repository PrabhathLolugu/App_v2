import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:myitihas/features/social/domain/entities/user.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'profiles'),
  sqliteConfig: SqliteSerializable(),
)
class UserModel extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  final String id;

  final String username;

  @Supabase(name: 'full_name')
  final String? displayName;

  @Supabase(name: 'avatar_url')
  final String? avatarUrl;

  final String? bio;

  @Supabase(name: 'is_verified')
  final bool isVerified;

  @Supabase(name: 'accepts_direct_messages')
  final bool acceptsDirectMessages;

  @Supabase(name: 'is_official_myitihas')
  final bool isOfficialMyitihas;

  @Supabase(ignore: true)
  @Sqlite(ignore: true)
  final int followerCount;

  @Supabase(ignore: true)
  @Sqlite(ignore: true)
  final int followingCount;

  @Supabase(ignore: true)
  @Sqlite(ignore: true)
  final bool isFollowing;

  @Supabase(ignore: true)
  @Sqlite(ignore: true)
  final bool isCurrentUser;

  @Supabase(ignore: true)
  @Sqlite(ignore: true)
  final List<String> savedStories;

  UserModel({
    required this.id,
    required this.username,
    this.displayName,
    this.avatarUrl,
    this.bio,
    this.isVerified = false,
    this.acceptsDirectMessages = true,
    this.isOfficialMyitihas = false,
    this.followerCount = 0,
    this.followingCount = 0,
    this.isFollowing = false,
    this.isCurrentUser = false,
    this.savedStories = const <String>[],
  });

  factory UserModel.fromDomain(User entity) {
    return UserModel(
      id: entity.id,
      username: entity.username,
      displayName: entity.displayName,
      avatarUrl: entity.avatarUrl,
      bio: entity.bio,
      isVerified: entity.isVerified,
      acceptsDirectMessages: entity.acceptsDirectMessages,
      isOfficialMyitihas: entity.isOfficialMyitihas,
      followerCount: entity.followerCount,
      followingCount: entity.followingCount,
      isFollowing: entity.isFollowing,
      isCurrentUser: entity.isCurrentUser,
      savedStories: entity.savedStories,
    );
  }

  User toDomain() {
    return User(
      id: id,
      username: username,
      displayName: displayName ?? username,
      avatarUrl: avatarUrl ?? '',
      bio: bio ?? '',
      isVerified: isVerified,
      acceptsDirectMessages: acceptsDirectMessages,
      isOfficialMyitihas: isOfficialMyitihas,
      followerCount: followerCount,
      followingCount: followingCount,
      isFollowing: isFollowing,
      isCurrentUser: isCurrentUser,
      savedStories: savedStories,
    );
  }
}
