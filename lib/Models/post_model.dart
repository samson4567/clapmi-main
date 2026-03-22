// import 'dart:convert';

// import 'package:clapmi/Models/comment_model.dart';
// import 'package:clapmi/Models/user_model.dart';
// import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';

// class PostModel {
//   final int? wierdID;
//   final String? pid;
//   final int? userID;
//   final String? humanReadableDate;
//   final String? content;
//   final bool? hasSaved;
//   final bool? hasClapped;
//   final String? author;
//   final String? authorImage;
//   final int? authorID;
//   final String? authorPID;
//   final List? postFiles;
//   final int? commentCount;
//   final int? clapCount;
//   final int? saveCount;
//   final String? authorWallet;
//   final List? listOfTagDetails;
//   final List? comments;
//   final Map? user;

//   PostModel({
//     required this.pid,
//     required this.wierdID,
//     required this.userID,
//     required this.humanReadableDate,
//     required this.content,
//     required this.hasSaved,
//     required this.hasClapped,
//     required this.author,
//     required this.authorImage,
//     required this.authorID,
//     required this.authorPID,
//     required this.postFiles,
//     required this.commentCount,
//     required this.clapCount,
//     required this.saveCount,
//     required this.authorWallet,
//     required this.listOfTagDetails,
//     required this.user,
//     required this.comments,
//   });

//   PostModel copyWith({
//     int? wierdID,
//     String? pid,
//     int? userID,
//     String? humanReadableDate,
//     String? content,
//     bool? hasSaved,
//     bool? hasClapped,
//     String? author,
//     String? authorImage,
//     int? authorID,
//     String? authorPID,
//     List? postFiles,
//     int? commentCount,
//     int? clapCount,
//     int? saveCount,
//     String? authorWallet,
//     List? listOfTagDetails,
//     List? comments,
//     Map? user,
//   }) {
//     return PostModel(
//       authorPID: authorPID ?? this.authorPID,
//       comments: comments ?? this.comments,
//       pid: pid ?? this.pid,
//       wierdID: wierdID ?? this.wierdID,
//       userID: userID ?? this.userID,
//       humanReadableDate: humanReadableDate ?? this.humanReadableDate,
//       content: content ?? this.content,
//       hasSaved: hasSaved ?? this.hasSaved,
//       hasClapped: hasClapped ?? this.hasClapped,
//       author: author ?? this.author,
//       authorImage: authorImage ?? this.authorImage,
//       authorID: authorID ?? this.authorID,
//       postFiles: postFiles ?? this.postFiles,
//       commentCount: commentCount ?? this.commentCount,
//       clapCount: clapCount ?? this.clapCount,
//       saveCount: saveCount ?? this.saveCount,
//       authorWallet: authorWallet ?? this.authorWallet,
//       listOfTagDetails: listOfTagDetails ?? this.listOfTagDetails,
//       user: user ?? this.user,
//     );
//   }

//   factory PostModel.fromSqlitejson(Map json) {
//     return PostModel(
//       authorPID: json['author_pid'],
//       pid: json['pid'],
//       wierdID: json['id'],
//       userID: json['user_id'],
//       humanReadableDate: json['human_readable_date'],
//       content: json['content'],
//       hasSaved: convertIntToBool(json['has_saved'] ?? 0),
//       hasClapped: convertIntToBool(json['has_clapped'] ?? 0),
//       author: json['author'],
//       authorImage: json['author_image'],
//       authorID: json['author_id'],
//       postFiles: (functionToAddressTheIssueOfNullbeingGivenToJsonDecoding(
//           json['post_files']) as List?),
//       comments: (functionToAddressTheIssueOfNullbeingGivenToJsonDecoding(
//           json['comments']) as List?),
//       commentCount: json['comment_count'],
//       clapCount: json['clap_count'],
//       saveCount: json['save_count'],
//       authorWallet: json['author_wallet'],
//       listOfTagDetails:
//           (functionToAddressTheIssueOfNullbeingGivenToJsonDecoding(json['tags'])
//               as List?),
//       user:
//           (functionToAddressTheIssueOfNullbeingGivenToJsonDecoding(json['user'])
//               as Map?),
//     );
//   }
//   @override
//   bool operator ==(Object other) {
//     if (other is! PostModel) return false;

//     return ((other).pid == pid || (other).wierdID == wierdID);
//   }

//   factory PostModel.fromOnlinejson(Map json) {
//     return PostModel(
//       authorPID: json['author_pid'],
//       pid: json['pid'],
//       wierdID: json['id'],
//       userID: json['user_id'],
//       humanReadableDate: json['human_readable_date'],
//       content: json['content'],
//       hasSaved: json['has_saved'],
//       hasClapped: json['has_clapped'],
//       author: json['author'],
//       authorImage: json['author_image'],
//       authorID: json['author_id'],
//       postFiles: json['post_files'],
//       commentCount: json['comment_count'],
//       clapCount: json['clap_count'],
//       saveCount: json['save_count'],
//       authorWallet: json['author_wallet'],
//       listOfTagDetails: json['tags'],
//       comments: json['comments'],
//       user: json['user'],
//     );
//   }

//   factory PostModel.dummy() {
//     List commentss = List.filled(4, CommentModel.dummy().toOnlineMap());
//     return PostModel(
//       pid: "pid",
//       wierdID: 0,
//       userID: 0,
//       humanReadableDate: "humanReadableDate",
//       content: "content",
//       hasSaved: false,
//       hasClapped: false,
//       author: "author",
//       authorImage:
//           "https://res.cloudinary.com/clapmi-alt/image/upload/v1700033675/avatarr_lq3cnv.jpg",
//       authorID: 122,
//       authorPID: "authorPID",
//       postFiles: ["assets/icons/Frame 1000003916.png"],
//       commentCount: commentss.length,
//       clapCount: 10,
//       saveCount: 10,
//       authorWallet: "authorWallet",
//       listOfTagDetails: [],
//       comments: commentss,
//       user: UserModel.empty().toMap(),
//     );
//   }

//   Map toMap() {
//     return {
//       'author_pid': authorPID,
//       'pid': pid,
//       'wierdID': wierdID,
//       'user_id': userID,
//       'human_readable_date': humanReadableDate,
//       'content': content,
//       'has_saved': (hasSaved ?? false) ? 1 : 0,
//       'has_clapped': (hasClapped ?? false) ? 1 : 0,
//       'author': author,
//       'author_image': authorImage,
//       'author_id': authorID,
//       'post_files': jsonEncode(postFiles),
//       'comment_count': commentCount,
//       'clap_count': clapCount,
//       'save_count': saveCount,
//       'author_wallet': authorWallet,
//       'tags': jsonEncode(listOfTagDetails),
//       'user': jsonEncode(user),
//       'comments': jsonEncode(comments),
//     };
//   }

//   @override
//   String toString() {
//     return "${super.toString()}>>> ${toMap()}";
//   }
// }
