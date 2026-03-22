// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:io';

import 'package:equatable/equatable.dart';

class CreateVideoPostEntity {
  final List<String>? tags;
  final String? category;
  final String? description;
  final File? video;

  CreateVideoPostEntity({
    required this.tags,
    required this.category,
    required this.description,
    required this.video,
  });
}

class VideoPostEntity extends Equatable {
  final String? post;
  final String? type;
  final String? content;
  final bool? has_clapped;
  final bool? has_saved;
  final String? created_at;
  final String? creator_name;
  final String? creator_avatar;
  final String? creator_email;
  final int? challenges;
  final String? video;
  final String? thumbnail;
  const VideoPostEntity({
    this.post,
    this.type,
    this.content,
    this.has_clapped,
    this.has_saved,
    this.created_at,
    this.creator_name,
    this.creator_avatar,
    this.creator_email,
    this.challenges,
    this.video,
    this.thumbnail,
  });

  @override
  List<Object?> get props => [
        post,
        type,
        content,
        has_clapped,
        has_saved,
        created_at,
        creator_name,
        creator_avatar,
        creator_email,
        challenges,
        video,
        thumbnail
      ];
}
