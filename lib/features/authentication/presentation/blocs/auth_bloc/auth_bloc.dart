import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/global_object_folder_jacket/global_variables/global_variables.dart';
import 'package:clapmi/features/app/presentation/blocs/app/app_bloc.dart';
import 'package:clapmi/features/app/presentation/blocs/app/app_event.dart';
import 'package:clapmi/features/authentication/data/models/new_user_request_model.dart';
import 'package:clapmi/features/authentication/data/models/token_model.dart';
import 'package:clapmi/features/authentication/domain/entities/token_entity.dart';
import 'package:clapmi/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:clapmi/features/user/data/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationRepository authenticationRepository;
  final AppBloc appBloc;

  AuthBloc({
    required this.authenticationRepository,
    required this.appBloc,
  }) : super(AuthInitial()) {
    on<NewUserSignUpEvent>(_onNewUserSignUpEvent);
    on<VerifyNewSignUpEmailEvent>(_onVerifyNewSignUpEmailEvent);
    on<UserLoginEvent>(_onUserLoginEvent);
    on<ForgotPasswordEvent>(_onForgotPasswordEvent);
    on<VerifyForgotPasswordEvent>(_onVerifyForgotPasswordEvent);
    on<ResetPasswordEvent>(_onResetPasswordEvent);
    on<UpdatePasswordEvent>(_onUpdatePasswordEvent);
    on<ResendVerificationCodeEvent>(_onResendVerificationCodeEvent);
    on<BlockUserEvent>(_onBlockUserEvent);

    on<LogOutEvent>(_onLogoutEvent);
    on<GoogleSignuPEvent>(_onGoogleSignUpEvent);
    on<RegisterFCMtokenEvent>(_onRegisterFCMtokenEvent);
    on<UnregisterFCMtokenEvent>(_onUnregisterFCMtokenEvent);
    on<ToogleNotificationStateEvent>(_onToogleNotificationStateEvent);

    // ToogleNotificationState
  }

  Future<void> _onNewUserSignUpEvent(
      NewUserSignUpEvent event, Emitter<AuthState> emit) async {
    emit(NewUserSignUpLoadingState());
    final result = await authenticationRepository.newUserSignUp(
        newUserRequest: NewUserRequestModel(
            name: event.fullName,
            username: event.username,
            email: event.email,
            password: event.password,
            passwordConfirmation: event.confirmPassword));
    result.fold(
      (error) => emit(NewUserSignUpErrorState(errorMessage: error.message)),
      (message) => emit(NewUserSignUpSuccessState(message: message)),
    );
  }

  Future<void> _onVerifyNewSignUpEmailEvent(
      VerifyNewSignUpEmailEvent event, Emitter<AuthState> emit) async {
    emit(VerifyNewSignUpEmailLoadingState());
    final result = await authenticationRepository.verifySignUp(
        email: event.email, otp: event.otp);
    result.fold(
      (error) =>
          emit(VerifyNewSignUpEmailErrorState(errorMessage: error.message)),
      (message) => emit(VerifyNewSignUpEmailSuccessState(message: message)),
    );
  }

  Future<void> _onUserLoginEvent(
      UserLoginEvent event, Emitter<AuthState> emit) async {
    emit(UserLoginLoadingState());
    final result = await authenticationRepository.userLogin(
        email: event.email, password: event.password);

    await result.fold(
      (error) {
        print('dfghjkl${error.moreInformation}');
        emit(UserLoginErrorState(
            errorMessage:
                error.moreInformation ?? {"theMessage": error.message}));
      },
      (data) async {
        appBloc.add(
          UserUpdateEvent(
            updatedUserModel: UserModel.createFromLogin(
              data["user"],
            ),
          ),
        );
        appBloc.add(GetMyProfileEvent());
        userModelG = UserModel.createFromLogin(
          data["user"],
        );
        await authenticationRepository.setInitialLoginStatus(false);
        isLoggedIn = true;
        emit(UserLoginSuccessState(loginData: TokenModel.fromJson({...data})));
      },
    );
  }

  Future<void> _onForgotPasswordEvent(
      ForgotPasswordEvent event, Emitter<AuthState> emit) async {
    emit(ForgotPasswordLoadingState());
    final result =
        await authenticationRepository.forgotPassword(email: event.email);
    result.fold(
      (error) => emit(ForgotPasswordErrorState(errorMessage: error.message)),
      (message) => emit(ForgotPasswordSuccessState(message: message)),
    );
  }

  Future<void> _onVerifyForgotPasswordEvent(
      VerifyForgotPasswordEvent event, Emitter<AuthState> emit) async {
    emit(VerifyForgotPasswordLoadingState());
    final result = await authenticationRepository.verifyForgotPassword(
        email: event.email, otp: event.otp);
    result.fold(
      (error) =>
          emit(VerifyForgotPasswordErrorState(errorMessage: error.message)),
      (message) =>
          emit(VerifyForgotPasswordSuccessState(refreshToken: message)),
    );
  }

  Future<void> _onResetPasswordEvent(
      ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(ResetPasswordLoadingState());
    final result = await authenticationRepository.resetPassword(
        token: event.token,
        email: event.email,
        password: event.password,
        confirmPassword: event.confirmPassword);
    result.fold(
      (error) => emit(ResetPasswordErrorState(errorMessage: error.message)),
      (message) => emit(ResetPasswordSuccessState(message: message)),
    );
  }

  Future<void> _onUpdatePasswordEvent(
      UpdatePasswordEvent event, Emitter<AuthState> emit) async {
    emit(UpdatePasswordLoadingState());
    String? userEmail = appBloc.state.user?.email;
    final result = await authenticationRepository.updatePassword(
      email: userEmail ?? "",
      currentPassword: event.currentPassword,
      newPassword: event.newPassword,
      passwordConfirmation: event.passwordConfirmation,
    );

    result.fold(
      (error) => emit(UpdatePasswordErrorState(errorMessage: error.message)),
      (message) => emit(UpdatePasswordSuccessState(message: message)),
    );
  }

  Future<void> _onResendVerificationCodeEvent(
      ResendVerificationCodeEvent event, Emitter<AuthState> emit) async {
    emit(ResendVerificationCodeLoadingState());

    final result = await authenticationRepository.resendVerificationCode(
      email: event.email,
    );

    result.fold(
      (error) =>
          emit(ResendVerificationCodeErrorState(errorMessage: error.message)),
      (message) => emit(ResendVerificationCodeSuccessState(message: message)),
    );
  }

  Future<void> _onBlockUserEvent(
    BlockUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(BlockUserLoadingState());
    final result =
        await authenticationRepository.blockUser(creator: event.userId);
    result.fold(
      (failure) => emit(
        BlockUserErrorState(errorMessage: failure.message),
      ),
      // onSuccess
      (blockedUsers) => emit(
        BlockUserSuccessState(
          blockedUsers,
          message: 'User successfully blocked',
        ),
      ),
    );
  }

  Future<void> _onLogoutEvent(
    LogOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(LogOutLoadingState());
    final result = await authenticationRepository.logOutUser();
    await result.fold((failure) {
      emit(
        LogOutErrorState(errorMessage: failure.message),
      );
    }, (message) async {
      await authenticationRepository.setInitialLoginStatus(true);
      isLoggedIn = false;
      emit(
        LogOutStateSuccessState(
          message: 'Logout successfully ',
        ),
      );
    });
  }

  Future<void> _onRegisterFCMtokenEvent(
    RegisterFCMtokenEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(RegisterFCMtokenLoadingState());
    final result = await authenticationRepository.registerFCMtoken(
        token: event.token, deviceType: event.deviceType);
    await result.fold((failure) {
      emit(
        RegisterFCMtokenErrorState(errorMessage: failure.message),
      );
    }, (message) async {
      // Do NOT set login status here - this is just registering FCM token
      emit(
        RegisterFCMtokenSuccessState(
          message: 'FCM token registered successfully',
        ),
      );
    });
  }

  Future<void> _onUnregisterFCMtokenEvent(
    UnregisterFCMtokenEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(UnregisterFCMtokenLoadingState());
    final result = await authenticationRepository.unregisterFCMtoken(
      token: event.token,
    );
    await result.fold((failure) {
      emit(
        UnregisterFCMtokenErrorState(errorMessage: failure.message),
      );
    }, (message) async {
      // Do NOT set login status here - this is just unregistering FCM token
      emit(
        UnregisterFCMtokenSuccessState(
          message: 'FCM token unregistered successfully',
        ),
      );
    });
  }

  Future<void> _onToogleNotificationStateEvent(
    ToogleNotificationStateEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(ToogleNotificationStateLoadingState());
    final result = await authenticationRepository.toogleNotificationState(
        token: event.token, toEnable: event.toEnable);
    await result.fold((failure) {
      emit(
        ToogleNotificationStateErrorState(errorMessage: failure.message),
      );
    }, (message) async {
      // Do NOT set login status here - this is just toggling notification state
      emit(
        ToogleNotificationStateSuccessState(
          message: 'Notification state updated successfully',
        ),
      );
    });
  }

  Future<void> _onGoogleSignUpEvent(
    GoogleSignuPEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(UserLoginLoadingState());
    final result = await authenticationRepository.signUpwithGoogle();
    await authenticationRepository.setInitialLoginStatus(false);
    result.fold(
      (error) =>
          emit(UserLoginErrorState(errorMessage: error.moreInformation ?? {})),
      (data) async {
        isLoggedIn = true;
        appBloc.add(
          UserUpdateEvent(
            updatedUserModel: UserModel.createFromLogin(
              data["user"],
            ),
          ),
        );
        appBloc.add(GetMyProfileEvent());
        userModelG = UserModel.createFromLogin(
          data["user"],
        );
        emit(UserLoginSuccessState(loginData: TokenModel.fromJson({...data})));
      },
    );
  }
}
