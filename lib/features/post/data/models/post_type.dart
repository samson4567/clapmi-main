/// Enum representing the type of a post.
enum PostType {
  image,
  text,
  video,
  unknown; // For handling unexpected types

  /// Converts a string type from the backend to a [PostType].
  ///
  /// Defaults to [PostType.unknown] if the string doesn't match known types.
  static PostType fromString(String? type) {
    switch (type?.toLowerCase()) {
      case 'image':
        return PostType.image;
      case 'text':
        return PostType.text;
      case 'video':
        return PostType.video;
      default:
        return PostType.unknown;
    }
  }
}
