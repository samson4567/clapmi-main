import 'package:clapmi/features/app/data/models/user_model.dart';
import 'package:clapmi/features/post/data/models/post_model.dart';
import 'package:clapmi/features/user/data/models/user_model.dart';
import 'package:clapmi/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class AppRepository {
  Future<Either<Failure, UserModel>> getUserProfile({required String userId});
  Future<Either<Failure, String>> updateUser({required UserModel userModel});
  Future<Either<Failure, ProfileModel>> getMyProfile();
  Future<Either<Failure, List<PostModel>>> getPreviouslyStoredPostModelList();
  Future<Either<Failure, String>> setPreviouslyStoredPostModelList(
      List<PostModel> theListOfPostModel);
}
