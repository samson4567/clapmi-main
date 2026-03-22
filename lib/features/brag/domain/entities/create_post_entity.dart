class CreatePostEntity {
  final String uuid;
  final String? content;
  final String? creator;
  final String? humanReadableDate;
  final bool? hasSaved;
  final bool? hasClapped;
  final String? author;
  final String? authorImage;
  final int? commentCount;
  final int? clapCount;
  final int? saveCount;
  final List? listOfTagDetails;
  final List? comments;
  final Map? user;

  final List<String>? images;

  CreatePostEntity({
    required this.user,
    required this.uuid,
    required this.content,
    required this.images,
    required this.creator,
    required this.humanReadableDate,
    required this.hasSaved,
    required this.hasClapped,
    required this.author,
    required this.authorImage,
    required this.commentCount,
    required this.clapCount,
    required this.saveCount,
    required this.listOfTagDetails,
    required this.comments,
  });
}
