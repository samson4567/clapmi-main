part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

final class NewUserSignUpLoadingState extends AuthState {}

final class NewUserSignUpSuccessState extends AuthState {
  const NewUserSignUpSuccessState({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

final class NewUserSignUpErrorState extends AuthState {
  const NewUserSignUpErrorState({required this.errorMessage});
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}

final class VerifyNewSignUpEmailLoadingState extends AuthState {}

final class VerifyNewSignUpEmailSuccessState extends AuthState {
  const VerifyNewSignUpEmailSuccessState({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

final class VerifyNewSignUpEmailErrorState extends AuthState {
  const VerifyNewSignUpEmailErrorState({required this.errorMessage});
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}

final class UserLoginLoadingState extends AuthState {}

final class UserLoginSuccessState extends AuthState {
  const UserLoginSuccessState({required this.loginData});
  final TokenEntity loginData;
  @override
  List<Object> get props => [loginData];
}

final class UserLoginErrorState extends AuthState {
  const UserLoginErrorState({required this.errorMessage});
  final Map<String, dynamic> errorMessage;
  @override
  List<Object> get props => [errorMessage];
}

final class ForgotPasswordLoadingState extends AuthState {}

final class ForgotPasswordSuccessState extends AuthState {
  const ForgotPasswordSuccessState({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

final class ForgotPasswordErrorState extends AuthState {
  const ForgotPasswordErrorState({required this.errorMessage});
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}

final class VerifyForgotPasswordLoadingState extends AuthState {}

final class VerifyForgotPasswordSuccessState extends AuthState {
  const VerifyForgotPasswordSuccessState({required this.refreshToken});
  final String refreshToken;
  @override
  List<Object> get props => [refreshToken];
}

final class VerifyForgotPasswordErrorState extends AuthState {
  const VerifyForgotPasswordErrorState({required this.errorMessage});
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}

final class ResetPasswordLoadingState extends AuthState {}

final class ResetPasswordSuccessState extends AuthState {
  const ResetPasswordSuccessState({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

final class ResetPasswordErrorState extends AuthState {
  const ResetPasswordErrorState({required this.errorMessage});
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}

final class UpdatePasswordLoadingState extends AuthState {}

final class UpdatePasswordSuccessState extends AuthState {
  const UpdatePasswordSuccessState({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

final class UpdatePasswordErrorState extends AuthState {
  const UpdatePasswordErrorState({required this.errorMessage});
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}

// resend verification code

final class ResendVerificationCodeLoadingState extends AuthState {}

final class ResendVerificationCodeSuccessState extends AuthState {
  const ResendVerificationCodeSuccessState({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

final class ResendVerificationCodeErrorState extends AuthState {
  const ResendVerificationCodeErrorState({required this.errorMessage});
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}

// bloc users
final class BlockUserLoadingState extends AuthState {
  const BlockUserLoadingState();
}

final class BlockUserSuccessState extends AuthState {
  final String blockedUsers;
  final String message;

  const BlockUserSuccessState(
    this.blockedUsers, {
    required this.message,
  });

  @override
  List<Object> get props => [blockedUsers, message];
}

final class BlockUserErrorState extends AuthState {
  final String errorMessage;

  const BlockUserErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// logout

final class LogOutLoadingState extends AuthState {}

final class LogOutStateSuccessState extends AuthState {
  final String message;
  const LogOutStateSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

final class AuthAuthenticated extends AuthState {
  final TokenModel token;
  final UserModel user;

  const AuthAuthenticated({
    required this.token,
    required this.user,
  });

  @override
  List<Object?> get props => [token, user];
}

final class AuthUnauthenticated extends AuthState {}

final class LogOutErrorState extends AuthState {
  final String errorMessage;
  const LogOutErrorState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

// google sigup
final class GoogleSigupLoadingState extends AuthState {}

final class GoogleSigupSuccessState extends AuthState {
  final Map user;
  const GoogleSigupSuccessState({required this.user});

  @override
  List<Object> get props => [user];
}

final class GoogleSigupErrorState extends AuthState {
  final String errorMessage;
  const GoogleSigupErrorState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

// RegisterFCMtoken

final class RegisterFCMtokenLoadingState extends AuthState {}

final class RegisterFCMtokenSuccessState extends AuthState {
  final String message;
  const RegisterFCMtokenSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

final class RegisterFCMtokenErrorState extends AuthState {
  final String errorMessage;
  const RegisterFCMtokenErrorState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

// UnregisterFCMtoken

final class UnregisterFCMtokenLoadingState extends AuthState {}

final class UnregisterFCMtokenSuccessState extends AuthState {
  final String message;
  const UnregisterFCMtokenSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

final class UnregisterFCMtokenErrorState extends AuthState {
  final String errorMessage;
  const UnregisterFCMtokenErrorState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
// ToogleNotificationState

final class ToogleNotificationStateLoadingState extends AuthState {}

final class ToogleNotificationStateSuccessState extends AuthState {
  final String message;
  const ToogleNotificationStateSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

final class ToogleNotificationStateErrorState extends AuthState {
  final String errorMessage;
  const ToogleNotificationStateErrorState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

// toogleNotificationState

