// ignore_for_file: non_constant_identifier_names

import 'package:clapmi/features/post/data/models/post_model.dart';
import 'package:flutter/foundation.dart';

class CreatePostEntity {
  final String uuid;
  final String? content;
  final String? creator;
  final String? humanReadableDate;
  final bool? hasSaved;
  bool? hasClapped; // Made mutable for clap state updates
  final String? author;
  final String? authorName;
  final String? authorImage;
  final List? tagUsers;
  int? commentCount;
  int? clapCount;
  int? sharedCount;
  int? challenges;
  final int? saveCount;
  final List? listOfTagDetails;
  final List? comments;
  final Map? user;
  final Map? metadata;
  final String? thumbnail;

  final List<String>? images;
  final String? whoCanSeePost;
  Uint8List? imageAvatar;
  final ChallengeProp? challenger_properties;

  CreatePostEntity({
    required this.tagUsers,
    required this.user,
    required this.uuid,
    required this.content,
    required this.images,
    required this.creator,
    required this.humanReadableDate,
    required this.hasSaved,
    required this.hasClapped,
    required this.author,
    required this.sharedCount,
    required this.challenges,
    this.authorName,
    this.metadata,
    this.thumbnail,
    required this.authorImage,
    required this.commentCount,
    required this.clapCount,
    required this.saveCount,
    required this.listOfTagDetails,
    required this.comments,
    this.whoCanSeePost,
    this.imageAvatar,
    required this.challenger_properties,
  });
}
