import 'package:clapmi/core/error/failure.dart';
import 'package:clapmi/features/authentication/data/models/new_user_request_model.dart';
import 'package:dartz/dartz.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, String>> newUserSignUp(
      {required NewUserRequestModel newUserRequest});
  Future<Either<Failure, String>> verifySignUp(
      {required String email, required String otp});
  Future<Either<Failure, Map>> userLogin(
      {required String email, required String password});
  Future<Either<Failure, String>> forgotPassword({required String email});
  Future<Either<Failure, String>> verifyForgotPassword(
      {required String email, required String otp});
  Future<Either<Failure, String>> resetPassword(
      {required String email,
      required String token,
      required String password,
      required String confirmPassword});
  Future<Either<Failure, String>> resendVerificationCode({
    required String email,
  });
  Future<Either<Failure, String>> updatePassword({
    required String email,
    required String newPassword,
    required String passwordConfirmation,
    required String currentPassword,
  });
  Future<Either<Failure, String>> blockUser({String creator});

  Future<Either<Failure, String>> logOutUser();

  Future<Either<Failure, Map>> signUpwithGoogle();
  Future<Either<Failure, void>> setInitialLoginStatus(bool value);
  Future<Either<Failure, String>> registerFCMtoken({
    required String token,
    required String deviceType,
  });
  Future<Either<Failure, String>> unregisterFCMtoken({
    required String token,
  });

  Future<Either<Failure, String>> toogleNotificationState({
    required String token,
    required bool toEnable,
  });
  // toogleNotificationState
}
