import 'dart:io';

import 'package:clapmi/features/user/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:clapmi/core/error/failure.dart';
import 'package:image_picker/image_picker.dart';
import 'package:clapmi/features/user/data/models/creator_leaderboard_model.dart';

abstract class UserRepository {
  Future<Either<Failure, String>> updateUser({required Map userDetails});
  Future<Either<Failure, String>> deleteAccount({
    required String password,
  });
  Future<Either<Failure, File>> selectBanner({
    required ImageSource imageSource,
  });
  Future<Either<Failure, File>> selectProfilePicture({
    required ImageSource imageSource,
  });
  Future<Either<Failure, UserEntity>> getUserDetails();
  Future<Either<Failure, CreatorLeaderboardResponse>> getCreatorLeaderboard({
    String? levelName,
    int page = 1,
    String timeFilter = 'all',
    String? creator,
  });
  Future<Either<Failure, CreatorLevelsResponse>> getCreatorLevels();
}
