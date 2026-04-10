/// Stable keys for discussion list filters (not user-visible; use i18n for labels).
abstract final class DiscussionFeedFilter {
  static const all = 'all_discussions';
  static const myActivity = 'my_activity';
}

/// Search sheet scope: [all] = no category filter; otherwise matches `discussions.category`.
abstract final class DiscussionSearchScope {
  static const all = 'all';
  static const general = 'general';
  static const location = 'location';
}
