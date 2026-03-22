import 'dart:io';
import 'package:clapmi/core/mapper/failure_mapper.dart';
import 'package:clapmi/core/utils.dart';
import 'package:clapmi/features/brag/data/datasources/brag_local_datasource.dart';
import 'package:clapmi/features/brag/data/datasources/brag_remote_datasource.dart';
import 'package:clapmi/features/brag/data/models/brag_challengers.dart';
import 'package:clapmi/features/brag/data/models/post_model.dart';
import 'package:clapmi/features/brag/domain/repositories/brag_repository.dart';
import 'package:clapmi/features/post/data/models/avatar_model.dart';
import 'package:clapmi/features/post/data/models/create_combo_model.dart';
import 'package:clapmi/features/post/data/models/create_post_model.dart';
import 'package:dartz/dartz.dart';
import 'package:clapmi/core/error/failure.dart';
import 'package:image_picker/image_picker.dart';

class BragRepositoryImpl implements BragRepository {
  BragRepositoryImpl({
    required this.bragLocalDatasource,
    required this.bragRemoteDatasource,
  });

  final BragRemoteDatasource bragRemoteDatasource;
  final BragLocalDatasource bragLocalDatasource;

  @override
  Future<Either<Failure, File?>> selectImage(
      {required ImageSource imageSource}) async {
    try {
      final result =
          await bragLocalDatasource.selectImage(imageSource: imageSource);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, CreatePostModel?>> createPost(
      {required CreatePostModel postModel}) async {
    try {
      final result =
          await bragRemoteDatasource.createPost(postModel: postModel);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> challengePost(
      {required String postID}) async {
    try {
      final result = await bragRemoteDatasource.challengePost(postID: postID);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> singlechallengeLiveStream(
      {required String bradID}) async {
    try {
      final result =
          await bragRemoteDatasource.singlechallengeLiveStream(bragID: bradID);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> createCombo(
      {required CreateComboModel comboModel,
      required bool isSingleLiveStream}) async {
    try {
      final result = await bragRemoteDatasource.createCombo(
          comboModel: comboModel, isSingleLiveStream: isSingleLiveStream);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<AvatarModel>>> getAvatars() async {
    try {
      final result = await bragRemoteDatasource.getAvatars();
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> commentOnAPost(
      {required String postID, required String comment}) async {
    try {
      final result = await bragRemoteDatasource.commentOnAPost(
          postID: postID, comment: comment);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<BragChallengersModel>>> getlistofBragchallengers({
    required String postId,
    required String contextType,
    required String list,
    required String status,
  }) async {
    try {
      var result = await bragRemoteDatasource.getlistofBragchallengers(
          postId: postId, contextType: contextType, list: list, status: status);
      for (var challenger in result) {
        if (challenger.challenger.image.contains(".svg")) {
          challenger.challenger.imageConvert =
              await fetchSvg(challenger.challenger.image);
        }
      }
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<SingleLiveStreamBragChallengerModel>>>
      getlistofSingleBragchallengers(
          {required String contextType,
          required String list,
          required String brags,
          required String status}) async {
    try {
      var result = await bragRemoteDatasource.getlistofSingleBragchallengers(
          contextType: contextType, list: list, status: status, brags: brags);
      for (var challenger in result) {
        if (challenger.challengerImage.contains(".svg")) {
          challenger.imageConvert = await fetchSvg(challenger.challengerImage);
        }
      }
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, SingleVideoPostModel>> getSinglePost(
      {required String postId}) async {
    try {
      var result = await bragRemoteDatasource.getSinglePost(postId: postId);
      if (result.creator_image!.contains(".svg")) {
        result.image = await fetchSvg(result.creator_image ?? '');
      }
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> acceptChallenge(
      {required String challengeId}) async {
    try {
      final result =
          await bragRemoteDatasource.acceptChallenge(challengeId: challengeId);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> declineChallenge(
      {required String challengeId}) async {
    try {
      final result =
          await bragRemoteDatasource.declineChallenge(challengeId: challengeId);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> singleLiveacceptChallenge(
      {required String challenge}) async {
    try {
      final result =
          await bragRemoteDatasource.acceptChallenge(challengeId: challenge);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> singleLivedeclineChallenge(
      {required String challenge}) async {
    try {
      final result =
          await bragRemoteDatasource.declineChallenge(challengeId: challenge);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> boostPoints(
      {required int boostPoint, required String challengeId}) async {
    try {
      final result = await bragRemoteDatasource.boostPoints(
          boostPoint: boostPoint, challengeId: challengeId);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }
}
