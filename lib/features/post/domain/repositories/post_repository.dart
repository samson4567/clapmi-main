import 'dart:io';

import 'package:clapmi/core/error/failure.dart';
import 'package:clapmi/features/post/data/models/avatar_model.dart';

import 'package:clapmi/features/post/data/models/create_combo_model.dart';
import 'package:clapmi/features/post/data/models/create_post_model.dart';
import 'package:clapmi/features/post/data/models/create_video_post_model.dart';
import 'package:clapmi/features/post/data/models/edit_post_model.dart';
import 'package:clapmi/features/post/data/models/post_model.dart'; // Import PostModel
import 'package:clapmi/features/post/domain/entities/category_entity.dart';
import 'package:clapmi/features/post/domain/entities/create_video_post_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

abstract class PostRepository {
  Future<Either<Failure, List<File>>> selectImage({
    required ImageSource imageSource,
  });
  Future<Either<Failure, File?>> selectVideo(
      {required ImageSource imageSource});
  Future<Either<Failure, String?>> createPost(
      {required CreatePostModel postModel});
  Future<Either<Failure, String>> challengePost({required String postID});
  Future<Either<Failure, String>> acceptChallenge({required String postID});
  Future<Either<Failure, String>> createCombo(
      {required CreateComboModel comboModel});
  Future<Either<Failure, String>> editPostContent(
      {required EditPostContentModel editPost});
  Future<Either<Failure, String>> delPost({String postDeleted});
  Future<Either<Failure, String>> singlecreateCombo(
      {required SingleLiveCreateModel singlecomboModel});
  Future<Either<Failure, List<AvatarModel>>> getAvatars();
  Future<Either<Failure, List<PostModel>>> getAllPosts(
      {required int index, required bool isRefresh}); // Updated return type
  Future<Either<Failure, List<PostModel>>> getAllVideoPosts(
      {required int index, required bool isRefresh});
  Future<Either<Failure, List<PostModel>>> getUserPosts(String uid);
  Future<Either<Failure, List<PostModel>>> getFollowersPost();

  Future<Either<Failure, String>> commentOnAPost({
    required String postID,
    required String comment,
  });

  Future<Either<Failure, String>> clapAPost({
    required String postID,
  });

  Future<Either<Failure, String>> notInterestedInAPost({
    required String postID,
  });

  Future<Either<Failure, PostModel>> getSinglePost({
    required String postID,
  });

  // Add unclap method signature
  Future<Either<Failure, String>> unclapAPost({
    required String postID,
  });

  // Method to save a post
  Future<Either<Failure, String>> savePost({required String postID});

  // Method to share a post
  Future<Either<Failure, String>> sharePost({required String postID});
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, String>> createVideoPost(
      {required CreateVideoPostEntity createVideoPostEntity});

  Future<Either<Failure, (List<VideoPostModel>, List<String>)>> getClapmiVideos(
      {required int index});

  // Future<Either<Failure, VideoUrlEntity>> uploadUrl(
  //     {required Map<String, dynamic> cred});
}
