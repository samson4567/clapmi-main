import 'dart:io';

import 'package:clapmi/core/error/failure.dart';
import 'package:clapmi/core/mapper/failure_mapper.dart';
import 'package:clapmi/features/post/data/datasources/post_local_datasource.dart';
import 'package:clapmi/features/post/data/datasources/post_remote_datasource.dart';
import 'package:clapmi/features/post/data/models/avatar_model.dart';
import 'package:clapmi/features/post/data/models/create_combo_model.dart';
import 'package:clapmi/features/post/data/models/create_post_model.dart';
import 'package:clapmi/features/post/data/models/create_video_post_model.dart';
import 'package:clapmi/features/post/data/models/edit_post_model.dart';
import 'package:clapmi/features/post/data/models/post_model.dart'; // Import PostModel
import 'package:clapmi/features/post/domain/entities/category_entity.dart';
import 'package:clapmi/features/post/domain/entities/create_video_post_entity.dart';
import 'package:clapmi/features/post/domain/repositories/post_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl({
    required this.postLocalDatasource,
    required this.postRemoteDatasource,
  });

  final PostRemoteDatasource postRemoteDatasource;
  final PostLocalDatasource postLocalDatasource;

  @override
  Future<Either<Failure, List<File>>> selectImage(
      {required ImageSource imageSource}) async {
    try {
      final result =
          await postLocalDatasource.selectImage(imageSource: imageSource);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String?>> createPost(
      {required CreatePostModel postModel}) async {
    try {
      final result =
          await postRemoteDatasource.createPost(postModel: postModel);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> challengePost(
      {required String postID}) async {
    try {
      final result = await postRemoteDatasource.challengePost(postID: postID);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> createCombo(
      {required CreateComboModel comboModel}) async {
    try {
      final result =
          await postRemoteDatasource.createCombo(comboModel: comboModel);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> editPostContent(
      {required EditPostContentModel editPost}) async {
    try {
      final result = await postRemoteDatasource.editPost(editPost: editPost);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> delPost({String? postDeleted}) async {
    try {
      final result =
          await postRemoteDatasource.delUser(postDeleted: postDeleted ?? '');
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> singlecreateCombo(
      {required SingleLiveCreateModel singlecomboModel}) async {
    try {
      final result = await postRemoteDatasource.singlecreateCombo(
          singlecomboModel: singlecomboModel);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<AvatarModel>>> getAvatars() async {
    try {
      final result = await postRemoteDatasource.getAvatars();
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> commentOnAPost(
      {required String postID, required String comment}) async {
    try {
      final result = await postRemoteDatasource.commentOnAPost(
          postID: postID, comment: comment);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<PostModel>>> getAllPosts(
      {required int index, required bool isRefresh}) async {
    try {
      var result = await postRemoteDatasource.getAllPosts(
          index: index, isRefresh: isRefresh);
      // int index = 0;
      // print('This is the post length ${result.length}');
      // for (var post in result) {
      //   if (post.authorImage!.contains(".svg")) {
      //     print('Calling the looping functionality ${post.authorImage}');
      //     post.imageAvatar = await fetchSvg(post.authorImage ?? '');
      //     print("$index");
      //     print("${post.imageAvatar}");
      //   }
      //   index = index++;
      // }
      // print("This is the first post avatar ${result.first.imageAvatar}");
      return right(result);
    } catch (e) {
      print("This is the error in the bag ${e.toString()}");
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> clapAPost({required String postID}) async {
    try {
      final result = await postRemoteDatasource.clapAPost(postID: postID);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> notInterestedInAPost(
      {required String postID}) async {
    try {
      final result =
          await postRemoteDatasource.notInterestedInAPost(postID: postID);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PostModel>> getSinglePost(
      {required String postID}) async {
    try {
      final result = await postRemoteDatasource.getSinglePost(postId: postID);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  // Implement unclap method
  @override
  Future<Either<Failure, String>> unclapAPost({required String postID}) async {
    try {
      final result = await postRemoteDatasource.unclapAPost(postID: postID);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  // Implementation for saving a post
  @override
  Future<Either<Failure, String>> savePost({required String postID}) async {
    try {
      final result = await postRemoteDatasource.savePost(postID: postID);
      return right(result);
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  // Implementation for sharing a post
  @override
  Future<Either<Failure, String>> sharePost({required String postID}) async {
    try {
      final result = await postRemoteDatasource.sharePost(postID: postID);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final result = await postRemoteDatasource.getCategories();
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> createVideoPost(
      {required CreateVideoPostEntity createVideoPostEntity}) async {
    try {
      final result = await postRemoteDatasource.createVideoPost(
          createVideoPostEntity: createVideoPostEntity);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, File?>> selectVideo(
      {required ImageSource imageSource}) async {
    try {
      final result =
          await postLocalDatasource.selectVideo(imageSource: imageSource);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<PostModel>>> getAllVideoPosts(
      {required int index, required bool isRefresh}) async {
    try {
      final result = await postRemoteDatasource.getAllVideoPosts(
          index: index, isRefresh: isRefresh);
      print("The first video Post in the list is ${result.first.comments}");
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> acceptChallenge(
      {required String postID}) async {
    try {
      final result = await postRemoteDatasource.acceptChallenge(postID: postID);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<PostModel>>> getUserPosts(String uid) async {
    try {
      final result = await postRemoteDatasource.getUserPosts(uid);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<PostModel>>> getFollowersPost() async {
    try {
      final result = await postRemoteDatasource.getFollowersPost();
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, (List<VideoPostModel>, List<String>)>> getClapmiVideos(
      {required int index}) async {
    try {
      final result = await postRemoteDatasource.getClapmiVideos(index: index);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  // @override
  // Future<Either<Failure, VideoUrlEntity>> uploadUrl(
  //     {required Map<String, dynamic> cred}) async {
  //   try {
  //     final result = await postRemoteDatasource.uploadUrl(cred: cred);
  //     return right(result);
  //   } catch (e) {
  //     return left(mapExceptionToFailure(e));
  //   }
  // }
}
