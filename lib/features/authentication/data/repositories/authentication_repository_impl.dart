import 'package:clapmi/core/error/failure.dart';
import 'package:clapmi/core/mapper/failure_mapper.dart';
import 'package:clapmi/features/authentication/data/datasources/authentication_local_datasource.dart';
import 'package:clapmi/features/authentication/data/datasources/authentication_remote_datasource.dart';
import 'package:clapmi/features/authentication/data/models/logout_model.dart';
import 'package:clapmi/features/authentication/data/models/new_user_request_model.dart';
import 'package:clapmi/features/authentication/data/models/token_model.dart';
import 'package:clapmi/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:dartz/dartz.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl(
      {required this.authenticationRemoteDatasource,
      required this.authenticationLocalDatasource});
  final AuthenticationRemoteDatasource authenticationRemoteDatasource;
  final AuthenticationLocalDatasource authenticationLocalDatasource;

  @override
  Future<Either<Failure, String>> newUserSignUp(
      {required NewUserRequestModel newUserRequest}) async {
    try {
      final result = await authenticationRemoteDatasource.newUserSignUp(
          newUserRequest: newUserRequest);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> verifySignUp(
      {required String email, required String otp}) async {
    try {
      final result = await authenticationRemoteDatasource.verifySignUp(
          email: email, otp: otp);

      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Map>> userLogin(
      {required String email, required String password}) async {
    try {
      final result = await authenticationRemoteDatasource.userLogin(
          email: email, password: password);

      TokenModel tokenModel = TokenModel.fromJson({...result});
      await authenticationLocalDatasource.cacheAuthToken(tokenModel);

      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(
      {required String email}) async {
    try {
      final result =
          await authenticationRemoteDatasource.forgotPassword(email: email);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> verifyForgotPassword(
      {required String email, required String otp}) async {
    try {
      final result = await authenticationRemoteDatasource.verifyForgotPassword(
          email: email, otp: otp);

      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> resetPassword(
      {required String email,
      required String token,
      required String password,
      required String confirmPassword}) async {
    try {
      final result = await authenticationRemoteDatasource.resetPassword(
          token: token,
          email: email,
          password: password,
          confirmPassword: confirmPassword);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> updatePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) async {
    try {
      final result = await authenticationRemoteDatasource.updatePassword(
        email: email,
        currentPassword: currentPassword,
        newPassword: newPassword,
        passwordConfirmation: passwordConfirmation,
      );
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> resendVerificationCode(
      {required String email}) async {
    try {
      final result = await authenticationRemoteDatasource
          .resendVerificationCode(email: email);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> blockUser({String? creator}) async {
    try {
      final result = await authenticationRemoteDatasource.blockUser(
          creator: creator ?? '');
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> logOutUser() async {
    try {
      final tokenModel =
          await authenticationLocalDatasource.getCachedAuthToken();
      final result = await authenticationRemoteDatasource.logOut(
          refreshToken:
              LogoutModel(refreshToken: tokenModel?.refreshToken ?? ''));
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Map>> signUpwithGoogle() async {
    try {
      final result = await authenticationRemoteDatasource.loginWithGoogle();
      TokenModel tokenModel = TokenModel.fromJson({...result});
      await authenticationLocalDatasource.cacheAuthToken(tokenModel);
      return right(result);
    } catch (e) {
      print("🔴 signUpwithGoogle ERROR: $e");
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> setInitialLoginStatus(bool value) async {
    try {
      final result =
          await authenticationLocalDatasource.setInitialLoginStatus(value);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> registerFCMtoken(
      {required String token, required String deviceType}) async {
    try {
      final result = await authenticationRemoteDatasource.registerFCMtoken(
          token: token, deviceType: deviceType);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> unregisterFCMtoken(
      {required String token}) async {
    try {
      final result = await authenticationRemoteDatasource.unregisterFCMtoken(
        token: token,
      );
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> toogleNotificationState(
      {required String token, required bool toEnable}) async {
    try {
      final result =
          await authenticationRemoteDatasource.toogleNotificationState(
        token: token,
        toEnable: toEnable,
      );
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }
}
