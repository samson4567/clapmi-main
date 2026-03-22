// ignore_for_file: non_constant_identifier_names

import 'package:clapmi/features/post/data/models/post_model.dart';
import 'package:clapmi/features/post/domain/entities/create_post_entity.dart';
import 'package:clapmi/global_object_folder_jacket/global_functions/global_functions.dart';

class CreatePostModel extends CreatePostEntity {
  CreatePostModel({
    super.tagUsers,
    super.content,
    required super.uuid,
    super.images,
    super.creator,
    super.humanReadableDate,
    super.hasSaved,
    super.hasClapped,
    super.author,
    super.authorName,
    super.authorImage,
    super.commentCount,
    super.clapCount,
    super.saveCount,
    super.sharedCount,
    super.challenges,
    super.listOfTagDetails,
    super.comments,
    super.user,
    super.metadata,
    super.whoCanSeePost,
    super.thumbnail,
    super.imageAvatar,
    super.challenger_properties,
  });

  factory CreatePostModel.fromJson(Map<String, dynamic> json) {
    return CreatePostModel(
        tagUsers: json["tagged_users"],
        uuid: json["uuid"],
        humanReadableDate: json["humanReadableDate"],
        hasSaved: json["hasSaved"],
        hasClapped: json["hasClapped"],
        author: json["author"],
        authorName: json["creator_name"],
        authorImage: json["authorImage"] ?? json["creator_image"],
        commentCount: json["metadata"]?["comments"],
        clapCount: json["metadata"]?["claps"],
        sharedCount: json["metadata"]?["shares"],
        saveCount: json["saveCount"],
        challenges: json["challenges"],
        listOfTagDetails: json["listOfTagDetails"],
        comments: json["comments"],
        content: json["content"],
        images: json["images"],
        creator: json["creator"],
        metadata: json["metadata"],
        whoCanSeePost: json["who_can_see_this_post"],
        thumbnail: json['thumbnail'],
        challenger_properties: json['challenger_properties'] != null
            ? ChallengeProp.fromMap(json['challenger_properties'])
            : null);
  }
  factory CreatePostModel.fromEntity(CreatePostEntity createPostEntity) {
    return CreatePostModel(
      tagUsers: createPostEntity.tagUsers,
      challenger_properties: null,
      uuid: createPostEntity.uuid,
      humanReadableDate: createPostEntity.humanReadableDate,
      hasSaved: createPostEntity.hasSaved,
      hasClapped: createPostEntity.hasClapped,
      author: createPostEntity.author,
      authorImage: createPostEntity.authorImage,
      commentCount: createPostEntity.commentCount,
      clapCount: createPostEntity.clapCount,
      saveCount: createPostEntity.saveCount,
      listOfTagDetails: createPostEntity.listOfTagDetails,
      comments: createPostEntity.comments,
      content: createPostEntity.content,
      images: createPostEntity.images,
      creator: createPostEntity.creator,
      metadata: createPostEntity.metadata,
    );
  }
  factory CreatePostModel.fromPostModel(PostModel post) {
    return CreatePostModel(
      challenger_properties: post.challenge_properties,
      uuid: post.postId,
      humanReadableDate: post.humanReadableDate,
      hasSaved: post.hasSaved,
      hasClapped: post.hasClapped,
      author: post.authorId,
      authorName: post.authorName,
      authorImage: post.authorImage,
      commentCount: post.commentCount,
      clapCount: post.clapCount,
      sharedCount: post.sharedCount,
      challenges: post.challenges,
      // saveCount: post.saveCount,
      listOfTagDetails: post.listOfTagDetails,
      comments: post.comments,
      content: post.content,
      thumbnail: post.thumbnail,
      imageAvatar: post.imageAvatar,
      // images: post.images,
      // creator: post.creator,
    );
    // (
    //   id: json["id"],
    // content: json["content"],
    // images: json["images"],
    // creator: json["creator"],
    // );
  }

  Map<String, dynamic> toJson() {
    return {
      'tagUsers': tagUsers,
      "uuid": uuid,
      "humanReadableDate": humanReadableDate,
      "hasSaved": hasSaved,
      "hasClapped": hasClapped,
      "author": author,
      "authorImage": authorImage,
      "commentCount": commentCount,
      "clapCount": clapCount,
      "saveCount": saveCount,
      "listOfTagDetails": listOfTagDetails,
      "comments": comments,
      "content": content,
      "images": images,
      "creator": creator,
      "who_can_see_this_post": whoCanSeePost
    };
  }

  factory CreatePostModel.empty() {
    return CreatePostModel(
      challenger_properties: null,
      uuid: generateLongNumber().toString(),
    );
  }
}
