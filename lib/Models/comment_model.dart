import 'package:clapmi/features/post/data/models/post_model.dart';
import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';

class CommentModel {
  final int? wierdID;
  final String? pid;
  final int? userID;
  final String? humanReadableDate;
  final String? content;
  final bool? hasSaved;
  final bool? hasClapped;
  final String? author;
  final String? authorImage;
  final int? authorID;
  final String? authorPID;
  final String? createdAt;
  final String? updatedAt;

  final int? replyCount;
  final int? clapCount;
  final int? saveCount;
  final int? likeCount;
  final int? dislikeCount;
  final bool? hasLiked;
  final bool? hasDisliked;
  final bool? fromFirebase;

  final String? authorUsername;

  final String? authorWallet;
  final List? listOfTagDetails;
  final List? listOfLikers;

  final List? replies;

  final Map? user;
  final Metadata? metadata;

  CommentModel({
    this.pid,
    this.authorUsername,
    this.hasDisliked,
    this.hasLiked,
    this.likeCount,
    this.dislikeCount,
    this.wierdID,
    this.userID,
    this.humanReadableDate,
    this.content,
    this.hasSaved,
    this.hasClapped,
    this.author,
    this.authorImage,
    this.authorID,
    this.authorPID,
    this.replyCount,
    this.clapCount,
    this.saveCount,
    this.authorWallet,
    this.listOfTagDetails,
    this.user,
    this.replies,
    this.updatedAt,
    this.createdAt,
    this.fromFirebase,
    this.listOfLikers,
    this.metadata,
  });

  CommentModel copyWith({
    int? wierdID,
    String? pid,
    int? userID,
    String? humanReadableDate,
    String? content,
    bool? hasSaved,
    bool? hasClapped,
    String? author,
    String? authorImage,
    int? authorID,
    String? authorPID,
    int? commentCount,
    int? clapCount,
    int? saveCount,
    String? authorWallet,
    List? listOfTagDetails,
    List? comments,
    int? likeCount,
    int? dislikeCount,
    bool? hasLiked,
    bool? hasDisliked,
    String? authorUsername,
    String? createdAt,
    String? updatedAt,
    List? replies,
    List? listOfLikers,
    Map? user,
    bool? fromFirebase,
  }) {
    return CommentModel(
      createdAt: createdAt ?? this.createdAt,
      listOfLikers: listOfLikers ?? this.listOfLikers,
      fromFirebase: fromFirebase ?? this.fromFirebase,
      updatedAt: updatedAt ?? this.updatedAt,
      authorPID: authorPID ?? this.authorPID,
      authorUsername: authorUsername ?? this.authorUsername,
      dislikeCount: dislikeCount ?? this.dislikeCount,
      hasDisliked: hasDisliked ?? this.hasDisliked,
      hasLiked: hasLiked ?? this.hasLiked,
      likeCount: likeCount ?? this.likeCount,
      replies: comments ?? this.replies,
      pid: pid ?? this.pid,
      wierdID: wierdID ?? this.wierdID,
      userID: userID ?? this.userID,
      humanReadableDate: humanReadableDate ?? this.humanReadableDate,
      content: content ?? this.content,
      hasSaved: hasSaved ?? this.hasSaved,
      hasClapped: hasClapped ?? this.hasClapped,
      author: author ?? this.author,
      authorImage: authorImage ?? this.authorImage,
      authorID: authorID ?? this.authorID,
      replyCount: commentCount ?? replyCount,
      clapCount: clapCount ?? this.clapCount,
      saveCount: saveCount ?? this.saveCount,
      authorWallet: authorWallet ?? this.authorWallet,
      listOfTagDetails: listOfTagDetails ?? this.listOfTagDetails,
      user: user ?? this.user,
    );
  }

  factory CommentModel.fromSqlitejson(Map json) {
    return CommentModel(
      authorPID: json['author_pid'],
      authorUsername: json['author_username'],
      dislikeCount: json['dislike_count'],
      hasDisliked: json['has_disliked'],
      hasLiked: json['has_liked'],
      likeCount: json['like_count'],
      pid: json['pid'],
      listOfLikers: (functionToAddressTheIssueOfNullbeingGivenToJsonDecoding(
          json['comments']) as List?),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      wierdID: json['id'],
      userID: json['user_id'],
      humanReadableDate: json['human_readable_date'],
      content: json['content'],
      hasSaved: convertIntToBool(json['has_saved'] ?? 0),
      fromFirebase: convertIntToBool(json['fromFirebase'] ?? 0),
      hasClapped: convertIntToBool(json['has_clapped'] ?? 0),
      author: json['author'],
      authorImage: json['author_image'],
      authorID: json['author_id'],
      replies: (functionToAddressTheIssueOfNullbeingGivenToJsonDecoding(
          json['comments']) as List?),
      replyCount: json['comment_count'],
      clapCount: json['clap_count'],
      saveCount: json['save_count'],
      authorWallet: json['author_wallet'],
      listOfTagDetails:
          (functionToAddressTheIssueOfNullbeingGivenToJsonDecoding(json['tags'])
              as List?),
      user:
          (functionToAddressTheIssueOfNullbeingGivenToJsonDecoding(json['user'])
              as Map?),
    );
  }

  factory CommentModel.fromPostComment(Comment json) {
    return CommentModel(
      authorPID: json.creator,
      content: json.comment,
      authorUsername: json.creator_name,
      humanReadableDate: json.created_at,
      authorImage: json.creator_image,
      metadata: json.metadata,
    );
  }

  factory CommentModel.fromOnlinejson(Map json) {
    return CommentModel(
      // fromFirebase
      authorPID: json['author_pid'],
      authorUsername: json['author_username'],
      dislikeCount: json['dislike_count'],
      hasDisliked: json['has_disliked'],
      hasLiked: json['has_liked'],
      likeCount: json['like_count'],
      pid: json['pid'],
      listOfLikers: json['listOfLikers'],

      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      wierdID: json['id'],
      userID: json['user_id'],
      humanReadableDate: json['human_readable_date'],
      content: json['content'],
      fromFirebase: json['fromFirebase'],
      hasSaved: json['has_saved'],
      hasClapped: json['has_clapped'],
      author: json['author'],
      authorImage: json['author_image'],
      authorID: json['author_id'],
      replyCount: json['comment_count'],
      clapCount: json['clap_count'],
      saveCount: json['save_count'],
      authorWallet: json['author_wallet'],
      listOfTagDetails: json['tags'],
      replies: json['replies'],
      user: json['user'],
    );
  }

  factory CommentModel.dummy() {
    return CommentModel(
      authorUsername: "author_username",
      dislikeCount: 0,
      hasDisliked: false,
      hasLiked: true,
      likeCount: 2,
      pid: "pid",
      listOfLikers: [],
      wierdID: 0,
      userID: 0,
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
      humanReadableDate: "humanReadableDate",
      content: "content",
      hasSaved: false,
      hasClapped: false,
      fromFirebase: false,
      author: "author",
      authorImage:
          "https://res.cloudinary.com/clapmi-alt/image/upload/v1700033675/avatarr_lq3cnv.jpg",
      authorID: 122,
      authorPID: "authorPID",
      replyCount: 2,
      clapCount: 10,
      saveCount: 10,
      authorWallet: "authorWallet",
      listOfTagDetails: [],
      replies: [],
      user: {},
    );
  }
}
