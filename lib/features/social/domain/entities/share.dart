import 'package:freezed_annotation/freezed_annotation.dart';

part 'share.freezed.dart';

enum ShareType {
  repost,
  directMessage,
  external,
}

@freezed
abstract class Share with _$Share {
  const factory Share({
    required String userId,
    required String contentId,
    required String contentType, // 'post' or 'story'
    required ShareType shareType,
    String? recipientId, // For DM shares
    String? repostId, // For repost shares, the new post id
    required DateTime timestamp,
  }) = _Share;

  const Share._();
}
