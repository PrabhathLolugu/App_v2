import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myitihas/features/social/domain/entities/like.dart';

part 'like_model.freezed.dart';
part 'like_model.g.dart';

@freezed
abstract class LikeModel with _$LikeModel {
  const LikeModel._();

  const factory LikeModel({
    required String userId,
    required String contentId,
    @Default('story') String contentType,
    required DateTime timestamp,
  }) = _LikeModel;

  factory LikeModel.fromJson(Map<String, dynamic> json) =>
      _$LikeModelFromJson(json);

  Like toEntity() {
    return Like(
      userId: userId,
      contentId: contentId,
      contentType: contentType,
      timestamp: timestamp,
    );
  }

  factory LikeModel.fromEntity(Like like) {
    return LikeModel(
      userId: like.userId,
      contentId: like.contentId,
      contentType: like.contentType,
      timestamp: like.timestamp,
    );
  }
}
