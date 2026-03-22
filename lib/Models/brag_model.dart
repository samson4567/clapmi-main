import 'dart:convert';
import 'package:clapmi/features/post/data/models/post_model.dart';

class BragModel {
  final int? wierdID;
  final String? pid;
  final int? userID;
  final String? content;
  final String? authorName;
  final String? humanReadableDate;
  final int? comboGroundId;
  final int? categoryID;
  final String? category;
  final String? thumbnail;
  final int? views;
  final int? challengeCount;
  final int? dragCount;
  final bool? trending;
  final bool? sponsored;
  final String? boostExpiry;
  final Map? video;
  final bool? boosted;
  final String? comboGround;
  final bool? hasSaved;
  final bool? hasClapped;
  final bool? hasDragged;
  final String? author;
  final String? authorImage;
  final int? authorID;
  final String? authorPID;
  final List? postVideoUrls;
  final List? comments;
  int? commentCount;
  int? clapCount;
  int? sharedCount;
  int? challenges;
  final int? saveCount;
  final String? authorWallet;
  final bool? fromFirebase;
  final List? listOfTagDetails;
  final List? listOfClappers;
  final List? listOfSavers;

  final Map? user;

  BragModel({
    required this.comboGroundId,
    required this.hasDragged,
    required this.categoryID,
    required this.category,
    required this.thumbnail,
    required this.views,
    required this.challengeCount,
    required this.dragCount,
    required this.trending,
    required this.sponsored,
    required this.boostExpiry,
    required this.video,
    required this.boosted,
    required this.comboGround,
    required this.pid,
    required this.wierdID,
    required this.userID,
    required this.humanReadableDate,
    required this.content,
    required this.hasSaved,
    required this.hasClapped,
    required this.author,
    required this.authorImage,
    required this.authorID,
    required this.authorPID,
    required this.authorName,
    required this.challenges,
    required this.postVideoUrls,
    required this.comments,
    required this.commentCount,
    required this.clapCount,
    required this.saveCount,
    required this.sharedCount,
    required this.authorWallet,
    required this.listOfTagDetails,
    required this.user,
    required this.fromFirebase,
    required this.listOfClappers,
    required this.listOfSavers,
  });

  BragModel copyWith(
      {int? wierdID,
      String? pid,
      int? userID,
      String? content,
      String? humanReadableDate,
      int? comboGroundId,
      int? categoryID,
      String? category,
      String? thumbnail,
      int? views,
      int? challengeCount,
      int? dragCount,
      bool? trending,
      bool? sponsored,
      String? boostExpiry,
      Map? video,
      bool? boosted,
      String? comboGround,
      bool? hasSaved,
      bool? hasClapped,
      String? author,
      String? authorImage,
      int? authorID,
      String? authorPID,
      List? postFiles,
      List? comments,
      int? commentCount,
      int? clapCount,
      int? sharedCount,
      int? saveCount,
      String? authorWallet,
      List? listOfTagDetails,
      List? listOfClappers,
      bool? hasDragged,
      Map? user,
      String? authorName,
      int? challenges,
      bool? fromFirebase,
      List? listOfSavers}) {
    return BragModel(
        comboGroundId: comboGroundId ?? this.comboGroundId,
        hasDragged: hasDragged ?? this.hasDragged,
        categoryID: categoryID ?? this.categoryID,
        category: category ?? this.category,
        thumbnail: thumbnail ?? this.thumbnail,
        views: views ?? this.views,
        challengeCount: challengeCount ?? this.challengeCount,
        dragCount: dragCount ?? this.dragCount,
        trending: trending ?? this.trending,
        sponsored: sponsored ?? this.sponsored,
        boostExpiry: boostExpiry ?? this.boostExpiry,
        video: video ?? this.video,
        boosted: boosted ?? this.boosted,
        comboGround: comboGround ?? this.comboGround,
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
        authorPID: authorPID ?? this.authorPID,
        authorName: authorName ?? this.authorName,
        postVideoUrls: postFiles ?? postVideoUrls,
        comments: comments ?? this.comments,
        commentCount: commentCount ?? this.commentCount,
        clapCount: clapCount ?? this.clapCount,
        saveCount: saveCount ?? this.saveCount,
        sharedCount: sharedCount ?? this.sharedCount,
        authorWallet: authorWallet ?? this.authorWallet,
        listOfTagDetails: listOfTagDetails ?? this.listOfTagDetails,
        user: user ?? this.user,
        fromFirebase: fromFirebase ?? this.fromFirebase,
        listOfClappers: listOfClappers ?? this.listOfClappers,
        listOfSavers: listOfSavers ?? this.listOfSavers,
        challenges: challenges ?? this.challenges);
  }

  factory BragModel.fromPostModel(PostModel postModel) {
    return BragModel(
      authorPID: postModel.creatorId,
      hasDragged: false,
      pid: postModel.postId,
      wierdID: null,
      userID: postModel.user?["id"],
      humanReadableDate: postModel.humanReadableDate,
      content: postModel.content,
      hasSaved: postModel.hasSaved,
      hasClapped: postModel.hasClapped,
      author: postModel.authorId,
      authorImage: postModel.authorImage,
      authorName: postModel.authorName,
      authorID: null,
      postVideoUrls: postModel.videoUrls,
      comments: postModel.comments,
      commentCount: postModel.commentCount,
      clapCount: postModel.clapCount,
      sharedCount: postModel.sharedCount,
      challenges: postModel.challenges,
      thumbnail: postModel.thumbnail,
      saveCount: 0,
      authorWallet: null,
      boostExpiry: null,
      boosted: null,
      category: null,
      categoryID: null,
      challengeCount: null,
      comboGround: null,
      comboGroundId: null,
      dragCount: null,
      sponsored: postModel.user?["sponsored"],
      trending: false,
      video: {
        "id": postModel.metadata?["video-uuid"],
        "url": postModel.videoUrls?.firstOrNull
      },
      views: null,
      listOfClappers: null,
      listOfSavers: null,
      listOfTagDetails: postModel.listOfTagDetails,
      user: postModel.user,
      fromFirebase: false,
    );
  }

  factory BragModel.dummy() {
    return BragModel(
      hasDragged: false,
      challenges: 0,
      pid: "pid",
      wierdID: 1002,
      userID: 0,
      humanReadableDate: "humanReadableDate",
      content: "content",
      hasSaved: false,
      hasClapped: false,
      author: "author",
      authorName: "authorName",
      authorImage:
          "https://res.cloudinary.com/clapmi-alt/image/upload/v1700033675/avatarr_lq3cnv.jpg",
      authorID: 122,
      authorPID: "authorPID",
      postVideoUrls: [],
      comments: [],
      commentCount: 2,
      clapCount: 10,
      saveCount: 10,
      sharedCount: 10,
      authorWallet: "authorWallet",
      listOfTagDetails: [],
      user: {},
      boostExpiry: "boostExpiry",
      boosted: false,
      category: "category",
      categoryID: 12,
      challengeCount: 12,
      comboGround: "comboGround",
      comboGroundId: 0,
      dragCount: 12,
      sponsored: false,
      thumbnail: "thumbnail",
      trending: true,
      video: {
        "file":
            "https://api.clapmi.com/storage/videos/CkH8pstY9ZgoW0RSwJ7bBfPe1zhiuzKNDgUngvq5.mp4"
      },
      views: 12,
      fromFirebase: false,
      listOfClappers: [],
      listOfSavers: [],
    );
  }

  Map toMapforsqlite() {
    return {
      'author_pid': authorPID,
      'has_dragged': (hasDragged ?? false) ? 1 : 0,
      'pid': pid,
      'wierdID': wierdID,
      'user_id': userID,
      'human_readable_date': humanReadableDate,
      'content': content,
      'has_saved': (hasSaved ?? false) ? 1 : 0,
      'has_clapped': (hasClapped ?? false) ? 1 : 0,
      'author': author,
      'comments': jsonEncode(comments),
      'author_image': authorImage,
      'author_id': authorID,
      'post_files': jsonEncode(postVideoUrls),
      'comment_count': commentCount,
      'clap_count': clapCount,
      'save_count': saveCount,
      'author_wallet': authorWallet,
      'tags': json.encode(listOfTagDetails),
      'user': json.encode(user),
      "video": jsonEncode(video),
      "boost_expiry": boostExpiry,
      "boosted": (boosted ?? false) ? 1 : 0,
      "category": category,
      "category_id": categoryID,
      "challenge_count": challengeCount,
      "combo_ground": comboGround,
      "combo_ground_id": comboGroundId,
      "drag_count": dragCount,
      "sponsored": (sponsored ?? false) ? 1 : 0,
      "thumbnail": thumbnail,
      "trending": (trending ?? false) ? 1 : 0,
      "views": views,
      "fromFirebase": (fromFirebase ?? false) ? 1 : 0,
      "listOfClappers": listOfClappers,
      "listOfSavers": listOfSavers,
    };
  }

  @override
  String toString() {
    return "${super.toString()}>>> }";
  }
}
