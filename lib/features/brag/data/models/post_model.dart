// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names, must_be_immutable
import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class SingleVideoPostModel extends Equatable {
  final String? type;
  final String? creator;
  final String? content;
  final PostMetaData? metaData;
  final bool? has_clapped;
  final bool? has_saved;
  final String? creator_name;
  final String? creator_image;
  final List<SinglePostComment> comments;
  final List<String>? images;
  final List<String>? video;
  Uint8List? image;

   SingleVideoPostModel({
    this.type,
    this.creator,
    this.content,
    this.metaData,
    this.has_clapped,
    this.has_saved,
    this.creator_name,
    required this.comments,
    this.creator_image,
    this.images,
    this.video,
    this.image,
  });

  @override
  List<Object?> get props => [
        type,
        creator,
        content,
        metaData,
        has_clapped,
        has_saved,
        creator_name,
        comments,
        creator_image,
        images,
        video,
        image,
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'creator': creator,
      'content': content,
      'metaData': metaData?.toMap(),
      'has_clapped': has_clapped,
      'has_saved': has_saved,
      'creator_name': creator_name,
      'creator_image': creator_image,
      'comments': comments.map((x) => x.toMap()).toList(),
      'images': images,
      'video': video,
    };
  }

  factory SingleVideoPostModel.fromMap(Map<String, dynamic> map) {
    return SingleVideoPostModel(
        type: map['type'] != null ? map['type'] as String : null,
        creator: map['creator'] != null ? map['creator'] as String : null,
        content: map['content'] != null ? map['content'] as String : null,
        metaData: map['metaData'] != null
            ? PostMetaData.fromMap(map['metaData'] as Map<String, dynamic>)
            : null,
        has_clapped:
            map['has_clapped'] != null ? map['has_clapped'] as bool : null,
        has_saved: map['has_saved'] != null ? map['has_saved'] as bool : null,
        creator_name:
            map['creator_name'] != null ? map['creator_name'] as String : null,
        creator_image: map['creator_image'] != null
            ? map['creator_image'] as String
            : null,
        comments: List<SinglePostComment>.from(
          (map['comments'] as List<dynamic>).map<SinglePostComment?>(
            (x) => SinglePostComment.fromMap(x as Map<String, dynamic>),
          ),
        ));
  }

  String toJson() => json.encode(toMap());

  factory SingleVideoPostModel.fromJson(String source) =>
      SingleVideoPostModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class PostMetaData extends Equatable {
  final int? views;
  final int? comments;
  const PostMetaData({
    this.views,
    this.comments,
  });

  @override
  List<Object?> get props => [views, comments];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'views': views,
      'comments': comments,
    };
  }

  factory PostMetaData.fromMap(Map<String, dynamic> map) {
    return PostMetaData(
      views: map['views'] != null ? map['views'] as int : null,
      comments: map['comments'] != null ? map['comments'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostMetaData.fromJson(String source) =>
      PostMetaData.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SinglePostComment extends Equatable {
  final String? uuid;
  final String? creator;
  final String? comment;
  final CommentMetaData? metadata;
  final String? created_at;
  final String? created_name;
  final String? creator_image;
  const SinglePostComment({
    this.uuid,
    this.creator,
    this.comment,
    this.metadata,
    this.created_at,
    this.created_name,
    this.creator_image,
  });

  @override
  List<Object?> get props => [
        uuid,
        creator,
        comment,
        metadata,
        created_at,
        created_name,
        creator_image
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'creator': creator,
      'comment': comment,
      'metadata': metadata?.toMap(),
      'created_at': created_at,
      'created_name': created_name,
      'creator_image': creator_image,
    };
  }

  factory SinglePostComment.fromMap(Map<String, dynamic> map) {
    return SinglePostComment(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      creator: map['creator'] != null ? map['creator'] as String : null,
      comment: map['comment'] != null ? map['comment'] as String : null,
      metadata: map['metadata'] != null
          ? CommentMetaData.fromMap(map['metadata'] as Map<String, dynamic>)
          : null,
      created_at:
          map['created_at'] != null ? map['created_at'] as String : null,
      created_name:
          map['creator_name'] != null ? map['creator_name'] as String : null,
      creator_image:
          map['creator_image'] != null ? map['creator_image'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SinglePostComment.fromJson(String source) =>
      SinglePostComment.fromMap(json.decode(source) as Map<String, dynamic>);
}

class CommentMetaData extends Equatable {
  final int? comments;
  final int? shares;
  final int? claps;

  const CommentMetaData({
    this.comments,
    this.shares,
    this.claps,
  });

  @override
  List<Object?> get props => [comments, shares, claps];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'comments': comments,
      'shares': shares,
      'claps': claps,
    };
  }

  factory CommentMetaData.fromMap(Map<String, dynamic> map) {
    return CommentMetaData(
      comments: map['comments'] != null ? map['comments'] as int : null,
      shares: map['shares'] != null ? map['shares'] as int : null,
      claps: map['claps'] != null ? map['claps'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentMetaData.fromJson(String source) =>
      CommentMetaData.fromMap(json.decode(source) as Map<String, dynamic>);
}
