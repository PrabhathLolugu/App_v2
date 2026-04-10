import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myitihas/features/social/domain/entities/user.dart';

part 'message.freezed.dart';

enum DeliveryStatus { sending, sent, delivered, read, failed }

enum MessageDeliveryStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}

@freezed
abstract class Message with _$Message {
  const factory Message({
    required String id,
    required String conversationId,
    required String senderId,
    required String senderName,
    required String senderAvatar,
    required String text,
    required DateTime timestamp,
    @Default(MessageDeliveryStatus.sending)
    MessageDeliveryStatus deliveryStatus,
    @Default([]) List<String> readBy,
    String? sharedContentId,
    String? type,
    /// Server JSONB (poll, location, etc.) when synced via Brick.
    Map<String, dynamic>? metadata,
  }) = _Message;

  const Message._();

  User get sender => User(
    id: senderId,
    username: senderName.toLowerCase().replaceAll(' ', '_'),
    displayName: senderName,
    avatarUrl: senderAvatar,
    bio: '',
    followerCount: 0,
    followingCount: 0,
    isFollowing: false,
    isCurrentUser: false,
  );

  DateTime get createdAt => timestamp;
}
