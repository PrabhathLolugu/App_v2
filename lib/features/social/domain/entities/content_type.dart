/// Enum representing the different types of content in the social feed
enum ContentType {
  story,
  imagePost,
  textPost,
  videoPost,
  post,
  comment;

  String get displayName {
    switch (this) {
      case ContentType.story:
        return 'Story';
      case ContentType.imagePost:
        return 'Image';
      case ContentType.textPost:
        return 'Text';
      case ContentType.videoPost:
        return 'Video';
      case ContentType.post:
        return 'Post';
      case ContentType.comment:
        return 'Comment';
    }
  }

  /// Maps this content type to the database enum string.
  String get dbValue {
    switch (this) {
      case ContentType.story:
        return 'story';
      case ContentType.imagePost:
      case ContentType.textPost:
      case ContentType.videoPost:
      case ContentType.post:
        return 'post';
      case ContentType.comment:
        return 'comment';
    }
  }
}
