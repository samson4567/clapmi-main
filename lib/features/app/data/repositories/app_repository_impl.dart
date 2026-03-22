import 'package:clapmi/core/error/exception.dart';
import 'package:clapmi/core/error/failure.dart';
import 'package:clapmi/core/mapper/failure_mapper.dart';
import 'package:clapmi/core/utils.dart';
import 'package:clapmi/features/app/data/datasources/app_local_datasource.dart';
import 'package:clapmi/features/app/data/datasources/app_remote_datasource.dart';
import 'package:clapmi/features/app/data/models/user_model.dart';
import 'package:clapmi/features/app/domain/repositories/app_repository.dart';
import 'package:clapmi/features/post/data/models/post_model.dart';
import 'package:clapmi/features/user/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

class AppRepositoryImpl implements AppRepository {
  AppRepositoryImpl({
    required this.appRemoteDatasource,
    required this.appLocalDatasource,
  });

  final AppRemoteDatasource appRemoteDatasource;
  final AppLocalDatasource appLocalDatasource;

  @override
  Future<Either<Failure, UserModel>> getUserProfile(
      {required String userId}) async {
    try {
      final userProfile =
          await appRemoteDatasource.getUserProfile(userId: userId);
      return Right(userProfile);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, String>> updateUser({required UserModel userModel}) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, ProfileModel>> getMyProfile() async {
    try {
      var response = await appRemoteDatasource.getMyProfile();
      if (response.image!.contains('.svg')) {
        response.myAvatar = await fetchSvg(response.image ?? '');
      }
      return right(response);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<PostModel>>>
      getPreviouslyStoredPostModelList() async {
    try {
      var response =
          await appLocalDatasource.getPreviouslyStoredPostModelList();

      return right(response ?? []);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> setPreviouslyStoredPostModelList(
      List<PostModel> theListOfPostModel) async {
    try {
      var response = await appLocalDatasource
          .setPreviouslyStoredPostModelList(theListOfPostModel);

      return right("List Stored");
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }
}
