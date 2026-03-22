import 'dart:io';

import 'package:clapmi/features/user/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:clapmi/core/error/failure.dart';
import 'package:image_picker/image_picker.dart';

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
}
