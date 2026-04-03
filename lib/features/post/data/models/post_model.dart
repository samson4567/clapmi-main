// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import 'create_post_model.dart';

// Enum to represent the type of post
enum PostType {
  image,
  text,
  video, // Added video for completeness, though we'll filter it out
  unknown // For any unexpected types
}

// Converts a string type from the backend to our PostType enum
PostType postTypeFromString(String? type) {
  switch (type?.toLowerCase()) {
    // Use lowercase for robust matching
    case 'image':
      return PostType.image;
    case 'text':
      return PostType.text;
    case 'video':
      return PostType.video;
    default:
      // Consider logging unexpected types
      print('Warning: Unknown post type received: $type');
      return PostType.unknown;
  }
}

// Data model representing a post fetched from the backend
class PostModel {
  final String postId;
  final PostType type;
  final List<Comment> comments;
  final String creatorId;
  final String content;
  final Map<String, dynamic>? metadata; // Metadata can be null or a map
  // Add other fields from CreatePostModel if they are also returned by getAllPosts
  final String? authorId;
  final List<String>? imageUrls;
  final List<String>? videoUrls;

  final String? authorName;
  final String? authorImage;
  final String? humanReadableDate;
  int? clapCount;
  int? commentCount;
  int? sharedCount;
  bool? hasClapped; // Made mutable for clap state updates
  final int? challenges;
  Uint8List? imageAvatar;

  final bool? hasSaved;
  final Map<String, dynamic>? user;
  final List<Map<String, dynamic>>? listOfTagDetails;
  final List<Map<String, dynamic>>? taggedUsers;
  final String? thumbnail;
  final ChallengeProp? challenge_properties;

  // Constructor for creating a PostModel instance
  PostModel({
    this.videoUrls,
    required this.postId,
    required this.type,
    required this.creatorId,
    required this.content,
    this.challenge_properties,
    this.challenges,
    this.metadata,
    this.imageUrls,
    // Add other fields
    this.authorId,
    this.authorName,
    this.authorImage,
    this.comments = const [], // Initialize comments as an empty list
    this.humanReadableDate,
    this.clapCount,
    this.commentCount,
    this.sharedCount,
    this.hasClapped,
    this.hasSaved,
    this.user,
    this.listOfTagDetails,
    this.taggedUsers,
    this.thumbnail,
    this.imageAvatar,
  });

  factory PostModel.fromCreatePostModel(CreatePostModel model) {
    return PostModel(
      challenge_properties: null,
      postId: model.uuid,
      type: model.images != null ? PostType.image : PostType.text,
      creatorId: model.author ?? "",
      content: model.content ?? "",
      imageUrls: model.images,
      metadata: Map<String, dynamic>.from(model.metadata ?? {}),
      authorId: model.author,
      authorName: model.authorName,
      authorImage: model.authorImage,
      comments: [], // Initialize comments as an empty list
      humanReadableDate: model.humanReadableDate,
      clapCount: model.clapCount,
      commentCount: model.commentCount,
      sharedCount: model.sharedCount,
      hasClapped: model.hasClapped,
      hasSaved: model.hasSaved,
      taggedUsers: model.tagUsers
          ?.whereType<Map>()
          .map((taggedUser) => Map<String, dynamic>.from(taggedUser))
          .toList(),
      thumbnail: model.thumbnail,
      imageAvatar: model.imageAvatar,
    );
  }
  // Factory constructor to create a PostModel from a JSON map (backend response item)
  factory PostModel.fromJson(Map<String, dynamic> json) {
    //
    String postId = json['post'] as String? ?? '';
    PostType type = postTypeFromString(json['type'] as String?);
    String creatorId = json['creator'] as String? ?? '';
    String content = json['content'] as String? ?? '';
    Map<String, dynamic>? metadata = json['metadata'] is Map<String, dynamic>
        ? json['metadata'] as Map<String, dynamic>
        : null;

    String? authorId = json['author'] as String? ??
        json['creator']
            as String?; // Fallback to creatorId if author isn't present
    String? thumbnail = json['thumbnail'] is String ? json['thumbnail'] : null;

    String? authorImage =
        json['creator_avatar'] as String? ?? json['creator_image'] as String?;
    List<String>? imageUrls = [
      ...(json['images'] as List<dynamic>?)
              ?.map((image) => image as String)
              .toList() ??
          []
    ];
    String? authorName = json['creator_name'] as String?;
    String? humanReadableDate =
        json['created_at'] as String?; // Assuming createdAt might be the date
    int? clapCount = json['metadata']?['claps'] as int? ?? 0;
    int? commentCount = json['metadata']?['comments'] as int? ?? 0;
    int? sharedCount = json['metadata']?['shares'] as int? ?? 0;
    bool? hasClapped = json['has_clapped'] as bool? ?? false;
    bool? hasSaved = json['has_saved'] as bool? ?? false;
    Map<String, dynamic>? user = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : null;
    List<Map<String, dynamic>>? listOfTagDetails =
        (json['tags'] as List?)?.cast<Map<String, dynamic>>();
    List<Map<String, dynamic>>? taggedUsers =
        (json['tagged_users'] as List?)
            ?.whereType<Map>()
            .map((taggedUser) => Map<String, dynamic>.from(taggedUser))
            .toList();
    final commentList = json['comments'] as List?;
    int? challenges = json['challenges'] as int?;
    List<Comment> comments = commentList != null
        ? commentList.map((comment) => Comment.fromMap(comment)).toList()
        : [];
    ChallengeProp? challenge_properties = json['challenge_properties'] != null
        ? ChallengeProp.fromMap(json['challenge_properties'])
        : null;
    final videoUrls = json['video'] is String ? [(json['video'])] : [];
    // --- End Placeholder/Assumed fields ---
    // videoUrls

    return PostModel(
        postId: postId,
        type: type,
        creatorId: creatorId,
        content: content,
        imageUrls: [...imageUrls],
        metadata: metadata,
        // Add other fields
        authorId: authorId,
        authorName: authorName,
        authorImage: authorImage,
        humanReadableDate:
            humanReadableDate, // You might need date formatting here
        clapCount: clapCount,
        comments: comments,
        commentCount: commentCount,
        sharedCount: sharedCount,
        hasClapped: hasClapped,
        hasSaved: hasSaved,
        user: user,
        listOfTagDetails: listOfTagDetails,
        taggedUsers: taggedUsers,
        videoUrls: [...videoUrls],
        challenges: challenges,
        thumbnail: thumbnail,
        challenge_properties: challenge_properties);
  }

  // Optional: Method to convert PostModel back to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'post': postId,
      'type': type.toString().split('.').last, // Convert enum back to string
      'creator': creatorId,
      'content': content,
      'metadata': metadata,
      // Add other fields if needed for serialization
      'author': authorId,
      'authorName': authorName,
      'creator_name': authorName,

      'authorImage': authorImage,
      "creator_avatar": authorImage,
      "creator_image": authorImage,
      'createdAt': humanReadableDate, // Assuming this maps back
      'clapCount': clapCount,
      'comment': comments,
      'commentCount': commentCount,
      'hasClapped': hasClapped,
      'hasSaved': hasSaved,
      'user': user,
      'tags': listOfTagDetails,
      'tagged_users': taggedUsers,
    };
  }

  PostModel copyWith({
    String? postId,
    PostType? type,
    List<Comment>? comments,
    String? creatorId,
    String? content,
    Map<String, dynamic>? metadata,
    String? authorId,
    List<String>? imageUrls,
    List<String>? videoUrls,
    String? authorName,
    String? authorImage,
    String? humanReadableDate,
    int? clapCount,
    int? commentCount,
    int? sharedCount,
    bool? hasClapped,
    int? challenges,
    Uint8List? imageAvatar,
    bool? hasSaved,
    Map<String, dynamic>? user,
    List<Map<String, dynamic>>? listOfTagDetails,
    List<Map<String, dynamic>>? taggedUsers,
    String? thumbnail,
    ChallengeProp? challenge_properties,
  }) {
    return PostModel(
      postId: postId ?? this.postId,
      type: type ?? this.type,
      creatorId: creatorId ?? this.creatorId,
      content: content ?? this.content,
      comments: comments ?? this.comments,
      metadata: metadata ?? this.metadata,
      authorId: authorId ?? this.authorId,
      imageUrls: imageUrls ?? this.imageUrls,
      videoUrls: videoUrls ?? this.videoUrls,
      authorName: authorName ?? this.authorName,
      authorImage: authorImage ?? this.authorImage,
      humanReadableDate: humanReadableDate ?? this.humanReadableDate,
      clapCount: clapCount ?? this.clapCount,
      commentCount: commentCount ?? this.commentCount,
      sharedCount: sharedCount ?? this.sharedCount,
      hasClapped: hasClapped ?? this.hasClapped,
      challenges: challenges ?? this.challenges,
      imageAvatar: imageAvatar ?? this.imageAvatar,
      hasSaved: hasSaved ?? this.hasSaved,
      user: user ?? this.user,
      listOfTagDetails: listOfTagDetails ?? this.listOfTagDetails,
      taggedUsers: taggedUsers ?? this.taggedUsers,
      thumbnail: thumbnail ?? this.thumbnail,
      challenge_properties: challenge_properties ?? this.challenge_properties,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is PostModel && other.postId == postId);
}

class Comment {
  final String? creator;
  final String? comment;
  final String? created_at;
  final String? creator_name;
  final String? creator_image;
  final Metadata? metadata;

  const Comment({
    this.creator,
    this.comment,
    this.created_at,
    this.creator_name,
    this.creator_image,
    this.metadata,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'creator': creator,
      'comment': comment,
      'created_at': created_at,
      'creator_name': creator_name,
      'creator_image': creator_image,
      'metadata': metadata?.toMap(),
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      creator: map['creator'] != null ? map['creator'] as String : null,
      comment: map['comment'] != null ? map['comment'] as String : null,
      created_at:
          map['created_at'] != null ? map['created_at'] as String : null,
      creator_name:
          map['creator_name'] != null ? map['creator_name'] as String : null,
      creator_image:
          map['creator_image'] != null ? map['creator_image'] as String : null,
      metadata: map['metadata'] != null
          ? Metadata.fromMap(map['metadata'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.decode(source) as Map<String, dynamic>);

  Comment copyWith({
    String? creator,
    String? comment,
    String? created_at,
    String? creator_name,
    String? creator_image,
    Metadata? metadata,
  }) {
    return Comment(
      creator: creator ?? this.creator,
      comment: comment ?? this.comment,
      created_at: created_at ?? this.created_at,
      creator_name: creator_name ?? this.creator_name,
      creator_image: creator_image ?? this.creator_image,
      metadata: metadata ?? this.metadata,
    );
  }
}

class Metadata {
  final int? comments;
  final int? shares;
  final int? claps;
  const Metadata({
    this.comments,
    this.shares,
    this.claps,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'comments': comments,
      'shares': shares,
      'claps': claps,
    };
  }

  factory Metadata.fromMap(Map<String, dynamic> map) {
    return Metadata(
      comments: map['comments'] != null ? map['comments'] as int : null,
      shares: map['shares'] != null ? map['shares'] as int : null,
      claps: map['claps'] != null ? map['claps'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Metadata.fromJson(String source) =>
      Metadata.fromMap(json.decode(source) as Map<String, dynamic>);
  Metadata copyWith({
    int? comments,
    int? shares,
    int? claps,
  }) {
    return Metadata(
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      claps: claps ?? this.claps,
    );
  }
}

class ChallengeProp extends Equatable {
  final String? challenge;
  final bool? has_challenged;
  final bool? has_created_combo;

  const ChallengeProp(
      {required this.challenge,
      required this.has_challenged,
      required this.has_created_combo});

  @override
  List<Object?> get props => [challenge, has_challenged, has_created_combo];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'challenge': challenge,
      'has_challenged': has_challenged,
      'has_created_combo': has_created_combo,
    };
  }

  factory ChallengeProp.fromMap(Map<String, dynamic> map) {
    return ChallengeProp(
      challenge: map['challenge'] != null ? map['challenge'] as String : null,
      has_challenged:
          map['has_challenged'] != null ? map['has_challenged'] as bool : null,
      has_created_combo: map['has_created_combo'] != null
          ? map['has_created_combo'] as bool
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChallengeProp.fromJson(String source) =>
      ChallengeProp.fromMap(json.decode(source) as Map<String, dynamic>);
  ChallengeProp copyWith({
    String? challenge,
    bool? has_challenged,
    bool? has_created_combo,
  }) {
    return ChallengeProp(
      challenge: challenge ?? this.challenge,
      has_challenged: has_challenged ?? this.has_challenged,
      has_created_combo: has_created_combo ?? this.has_created_combo,
    );
  }
}
