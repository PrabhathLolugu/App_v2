/// Aggregated poll results for a chat message (from `get_chat_poll_summaries` RPC).
class ChatPollSummary {
  final String messageId;
  /// Vote counts for indices 0–3 (unused indices are zero for shorter polls).
  final List<int> counts;
  final int totalVotes;
  final int? myOptionIndex;

  const ChatPollSummary({
    required this.messageId,
    required this.counts,
    required this.totalVotes,
    this.myOptionIndex,
  });

  factory ChatPollSummary.fromJson(Map<String, dynamic> json) {
    final rawCounts = json['counts'];
    final counts = List<int>.filled(4, 0);
    if (rawCounts is List) {
      for (var i = 0; i < 4 && i < rawCounts.length; i++) {
        final n = rawCounts[i];
        counts[i] = n is int ? n : (n as num?)?.toInt() ?? 0;
      }
    }
    final total = json['total_votes'];
    final my = json['my_option'];
    return ChatPollSummary(
      messageId: json['message_id'] as String,
      counts: counts,
      totalVotes: total is int ? total : (total as num?)?.toInt() ?? 0,
      myOptionIndex: my == null
          ? null
          : (my is int ? my : (my as num).toInt()),
    );
  }
}
