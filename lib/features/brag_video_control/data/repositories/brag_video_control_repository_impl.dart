import 'dart:io';

import 'package:clapmi/core/error/exception.dart';
import 'package:clapmi/core/mapper/failure_mapper.dart';
import 'package:clapmi/features/user/data/datasources/user_local_datasource.dart';
import 'package:clapmi/features/user/data/datasources/user_remote_datasource.dart';
import 'package:clapmi/features/user/domain/entities/user_entity.dart';
import 'package:clapmi/features/user/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:clapmi/core/error/failure.dart';
import 'package:image_picker_platform_interface/src/types/image_source.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({
    required this.userLocalDatasource,
    required this.userRemoteDatasource,
  });

  final UserRemoteDatasource userRemoteDatasource;
  final UserLocalDatasource userLocalDatasource;

  @override
  Future<Either<Failure, String>> updateUser({required Map userDetails}) async {
    try {
      final result =
          await userRemoteDatasource.updateUser(userDetails: userDetails);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> deleteAccount(
      {required String password}) async {
    try {
      final result =
          await userRemoteDatasource.deleteAccount(password: password);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, File>> selectBanner(
      {required ImageSource imageSource}) async {
    try {
      final result =
          await userLocalDatasource.selectImage(imageSource: imageSource);
      if (result == null) throw "No File Selected";
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, File>> selectProfilePicture(
      {required ImageSource imageSource}) async {
    try {
      final result =
          await userLocalDatasource.selectImage(imageSource: imageSource);
      if (result == null) throw "No File Selected";
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserDetails() async {
    try {
      print("debug_print-UserRepositoryImpl-getUserDetails-start");
      final result = await userRemoteDatasource.getUserDetails();
      print("debug_print-UserRepositoryImpl-getUserDetails-result_is_$result");
      // if (result == null) throw "No File Selected";
      return right(result);
    } catch (e) {
      try {
        print(
            "debug_print-UserRepositoryImpl-getUserDetails-error_is_${(e as NetworkException).message}");
      } catch (e2) {
        print("debug_print-UserRepositoryImpl-getUserDetails-error_is_$e");
      }
      return left(mapExceptionToFailure(e));
    }
  }
}
