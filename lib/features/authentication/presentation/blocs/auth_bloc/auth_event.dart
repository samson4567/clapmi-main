part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

final class CheckAuthStatusEvent extends AuthEvent {}

final class NewUserSignUpEvent extends AuthEvent {
  const NewUserSignUpEvent(
      {required this.fullName,
      required this.username,
      required this.email,
      required this.password,
      required this.confirmPassword});
  final String fullName, username, email, password, confirmPassword;
  @override
  List<Object?> get props =>
      [fullName, username, email, password, confirmPassword];
}

final class VerifyNewSignUpEmailEvent extends AuthEvent {
  const VerifyNewSignUpEmailEvent({required this.email, required this.otp});
  final String email, otp;
  @override
  List<Object?> get props => [email, otp];
}

final class UserLoginEvent extends AuthEvent {
  const UserLoginEvent({required this.email, required this.password});
  final String email, password;
  @override
  List<Object?> get props => [email, password];
}

final class ForgotPasswordEvent extends AuthEvent {
  const ForgotPasswordEvent({required this.email});
  final String email;
  @override
  List<Object?> get props => [email];
}

final class VerifyForgotPasswordEvent extends AuthEvent {
  const VerifyForgotPasswordEvent({required this.email, required this.otp});
  final String email, otp;
  @override
  List<Object?> get props => [email, otp];
}

final class ResetPasswordEvent extends AuthEvent {
  const ResetPasswordEvent(
      {required this.email,
      required this.token,
      required this.password,
      required this.confirmPassword});
  final String email, password, token, confirmPassword;
  @override
  List<Object?> get props => [email, password, confirmPassword];
}

final class UpdatePasswordEvent extends AuthEvent {
  const UpdatePasswordEvent({
    required this.currentPassword,
    required this.newPassword,
    required this.passwordConfirmation,
  });

  final String currentPassword, newPassword, passwordConfirmation;

  @override
  List<Object?> get props =>
      [currentPassword, newPassword, passwordConfirmation];
}

final class ResendVerificationCodeEvent extends AuthEvent {
  const ResendVerificationCodeEvent({
    required this.email,
  });

  final String email;

  @override
  List<Object?> get props => [email];
}

// blocUserEvent

class BlockUserEvent extends AuthEvent {
  final String userId;

  const BlockUserEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

// Logout

class LogOutEvent extends AuthEvent {}

//googlsigup
class GoogleSignuPEvent extends AuthEvent {
  const GoogleSignuPEvent();
}

class RegisterFCMtokenEvent extends AuthEvent {
  final String token;
  final String deviceType;
  const RegisterFCMtokenEvent({required this.token, required this.deviceType});
}

class UnregisterFCMtokenEvent extends AuthEvent {
  final String token;

  const UnregisterFCMtokenEvent({required this.token});
}

class ToogleNotificationStateEvent extends AuthEvent {
  final String token;

  final bool toEnable;

  const ToogleNotificationStateEvent({
    required this.token,
    required this.toEnable,
  });
}

// toogleNotificationState
