// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:clapmi/features/post/domain/entities/create_video_post_entity.dart';
import "package:dio/dio.dart" as dio;
// CreateVideoPostEntity

class CreateVideoPostModel extends CreateVideoPostEntity {
  CreateVideoPostModel({
    super.tags,
    super.category,
    super.description,
    super.video,
  });

  CreateVideoPostModel copyWith({
    String? category,
    String? description,
    File? video,
    List<String>? tags,
  }) {
    return CreateVideoPostModel(
      category: category ?? this.category,
      description: description ?? this.description,
      video: video ?? this.video,
      tags: tags ?? this.tags,
    );
  }

  factory CreateVideoPostModel.fromjson(Map json) {
    return CreateVideoPostModel(
      category: json["category"],
      description: json["description"],
      video: json["video"],
      tags: json["tags"],
    );
  }

  factory CreateVideoPostModel.fromEntity(
      CreateVideoPostEntity createVideoPostEntity) {
    return CreateVideoPostModel(
      category: createVideoPostEntity.category,
      description: createVideoPostEntity.description,
      video: createVideoPostEntity.video,
      tags: createVideoPostEntity.tags,
    );
  }

// fromEntity
  factory CreateVideoPostModel.dummy() {
    return CreateVideoPostModel();
  }

  Map toOnlineMap() {
    return {
      "category": category,
      "description": description,
      "title": "",
      "video": video,
      "tags": tags,
    };
  }

  Future<Map<String, dynamic>> toOnlineMapWithConvertedFile() async {
    return {
      "category": category,
      "title": "name",
      "description": description,
      "video": (video != null)
          ? await dio.MultipartFile.fromFile(video!.path,
              filename: video!.path.split("/").lastOrNull)
          : null,
      "tags[]": tags,
    };
  }

  @override
  String toString() {
    return "${super.toString()}>>> ${toOnlineMap()}";
  }
}

class VideoPostModel extends VideoPostEntity {
  const VideoPostModel(
      {super.challenges,
      super.type,
      super.content,
      super.post,
      super.has_clapped,
      super.has_saved,
      super.created_at,
      super.creator_avatar,
      super.creator_email,
      super.creator_name,
      super.thumbnail,
      super.video});

  factory VideoPostModel.fromMap(Map<String, dynamic> map) {
    String videoTemp = '';
    String thumbnailTemp = '';
    if (map['video'] is List) {
      videoTemp = '';
    } else {
      videoTemp = map['video'];
    }
    if (map['thumbnail'] is List) {
      thumbnailTemp = '';
    } else {
      thumbnailTemp = map['thumbnail'];
    }
    return VideoPostModel(
      post: map['post'] != null ? map['post'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      content: map['content'] != null ? map['content'] as String : null,
      // has_clapped:
      //     map['has_clapped'] != null ? map['has_clapped'] as bool : null,
      // has_saved: map['has_saved'] != null ? map['has_saved'] as bool : null,
      // created_at:
      //     map['created_at'] != null ? map['created_at'] as String : null,
      // creator_name:
      //     map['creator_name'] != null ? map['creator_name'] as String : null,
      // creator_avatar: map['creator_avatar'] != null
      //     ? map['creator_avatar'] as String
      //     : null,
      // creator_email:
      //     map['creator_email'] != null ? map['creator_email'] as String : null,
      // challenges: map['challenges'] != null ? map['challenges'] as int : null,
      video: videoTemp,
      // map['video'] != null ? map['video'] as String : null,
      thumbnail: thumbnailTemp,
      // map['thumbnail'] != null ? map['thumbnail'] as String : null,
    );
  }

  factory VideoPostModel.fromJson(String source) =>
      VideoPostModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
