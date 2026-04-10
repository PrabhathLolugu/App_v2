class ForumDiscussionLaunchContext {
  const ForumDiscussionLaunchContext({
    this.suggestedHashtags = const [],
    this.originSiteId,
    this.siteName,
    this.defaultLocationMode = false,
    this.openComposerOnLoad = false,
  });

  final List<String> suggestedHashtags;
  final Object? originSiteId;
  final String? siteName;
  final bool defaultLocationMode;
  final bool openComposerOnLoad;

  bool get hasLocationContext => originSiteId != null;
}
