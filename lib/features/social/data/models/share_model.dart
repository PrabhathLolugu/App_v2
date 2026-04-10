import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myitihas/features/social/domain/entities/share.dart';

part 'share_model.freezed.dart';
part 'share_model.g.dart';

@freezed
abstract class ShareModel with _$ShareModel {
  const ShareModel._();

  const factory ShareModel({
    required String userId,
    required String contentId,
    required String contentType, // 'post' or 'story'
    required ShareType shareType,
    String? recipientId,
    String? repostId,
    required DateTime timestamp,
  }) = _ShareModel;

  factory ShareModel.fromJson(Map<String, dynamic> json) =>
      _$ShareModelFromJson(json);

  Share toEntity() {
    return Share(
      userId: userId,
      contentId: contentId,
      contentType: contentType,
      shareType: shareType,
      recipientId: recipientId,
      repostId: repostId,
      timestamp: timestamp,
    );
  }

  factory ShareModel.fromEntity(Share share) {
    return ShareModel(
      userId: share.userId,
      contentId: share.contentId,
      contentType: share.contentType,
      shareType: share.shareType,
      recipientId: share.recipientId,
      repostId: share.repostId,
      timestamp: share.timestamp,
    );
  }
}
