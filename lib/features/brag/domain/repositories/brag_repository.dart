import 'dart:io';

import 'package:clapmi/features/brag/data/models/brag_challengers.dart';
import 'package:clapmi/features/brag/data/models/post_model.dart';
import 'package:clapmi/features/post/data/models/avatar_model.dart';
import 'package:clapmi/features/post/data/models/create_combo_model.dart';
import 'package:clapmi/features/post/data/models/create_post_model.dart';
import 'package:dartz/dartz.dart';
import 'package:clapmi/core/error/failure.dart';
import 'package:image_picker/image_picker.dart';

abstract class BragRepository {
  Future<Either<Failure, File?>> selectImage({
    required ImageSource imageSource,
  });

  Future<Either<Failure, CreatePostModel?>> createPost(
      {required CreatePostModel postModel});
  Future<Either<Failure, String>> challengePost({required String postID});
  Future<Either<Failure, String>> singlechallengeLiveStream(
      {required String bradID});
  Future<Either<Failure, String>> createCombo(
      {required CreateComboModel comboModel, required bool isSingleLiveStream});
  Future<Either<Failure, List<AvatarModel>>> getAvatars();
  Future<Either<Failure, String>> commentOnAPost({
    required String postID,
    required String comment,
  });
  Future<Either<Failure, List<BragChallengersModel>>> getlistofBragchallengers({
    required String postId,
    required String contextType,
    required String list,
    required String status,
  });

  Future<Either<Failure, List<SingleLiveStreamBragChallengerModel>>>
      getlistofSingleBragchallengers(
          {required String contextType,
          required String list,
          required String status,
          required String brags});

  Future<Either<Failure, SingleVideoPostModel>> getSinglePost(
      {required String postId});

  Future<Either<Failure, String>> acceptChallenge(
      {required String challengeId});

  Future<Either<Failure, String>> declineChallenge(
      {required String challengeId});

  Future<Either<Failure, String>> singleLiveacceptChallenge(
      {required String challenge});

  Future<Either<Failure, String>> singleLivedeclineChallenge(
      {required String challenge});

  Future<Either<Failure, String>> boostPoints(
      {required int boostPoint, required String challengeId});
}
