import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_poll.freezed.dart';

@freezed
abstract class PostPoll with _$PostPoll {
  const factory PostPoll({
    @Default([]) List<String> options,
    @Default([0, 0, 0, 0]) List<int> voteCounts,
    @Default(0) int totalVotes,
    int? mySelectedIndex,
  }) = _PostPoll;

  const PostPoll._();

  bool get hasVoted => mySelectedIndex != null;

  List<int> get countsForVisibleOptions {
    if (options.isEmpty) return const [];
    return List<int>.generate(
      options.length,
      (index) => index < voteCounts.length ? voteCounts[index] : 0,
    );
  }
}
