/// Resolved @mention from post `metadata.mentions` for taps and rendering.
class PostMention {
  const PostMention({
    required this.username,
    required this.userId,
  });

  final String username;
  final String userId;
}
