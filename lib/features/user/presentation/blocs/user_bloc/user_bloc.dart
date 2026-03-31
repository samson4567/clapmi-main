import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/features/app/presentation/blocs/app/app_bloc.dart';
import 'package:clapmi/features/app/presentation/blocs/app/app_event.dart';
import 'package:clapmi/features/user/data/models/user_model.dart';
import 'package:clapmi/features/user/domain/repositories/user_repository.dart';
import 'package:clapmi/features/user/presentation/blocs/user_bloc/user_event.dart';
import 'package:clapmi/features/user/presentation/blocs/user_bloc/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  final AppBloc appBloc;

  UserBloc({required this.appBloc, required this.userRepository})
      : super(UserInitial()) {
    on<UserDetailUpdateEvent>(_onUserUpdate);
    on<DeleteAccountEvent>(_onDeleteAccountEvent);
    on<SelectBannerEvent>(_onSelectBannerEvent);
    on<SelectProfilePictureEvent>(_onSelectProfilePictureEvent);
    on<GetUserDetailsEvent>(_onGetUserDetailsEvent);
    on<GetCreatorLeaderboardEvent>(_onGetCreatorLeaderboardEvent);
    on<GetCreatorLevelsEvent>(_onGetCreatorLevelsEvent);

    // GetUserDetails
  }

  Future<void> _onUserUpdate(
      UserDetailUpdateEvent event, Emitter<UserState> emit) async {
    emit(UserDetailUpdateLoadingState());

    final result =
        await userRepository.updateUser(userDetails: event.userDetail);

    result.fold((error) {
      emit(UserDetailUpdateErrorState(errorMessage: error.message));
    }, (data) {
      Map formerUserDetail = userModelG?.toJson() ?? {};
      event.userDetail.forEach(
        (key, value) {
          formerUserDetail[key] = value;
        },
      );
      Map newUserDetail = formerUserDetail;
      UserModel updatedUserModel = UserModel.fromJson({...newUserDetail});
      appBloc.add(UserUpdateEvent(updatedUserModel: updatedUserModel));
      emit(
        UserDetailUpdateSuccessState(message: data),
      );
    });
  }

  Future<void> _onDeleteAccountEvent(
      DeleteAccountEvent event, Emitter<UserState> emit) async {
    emit(DeleteAccountLoadingState());
    final result = await userRepository.deleteAccount(password: event.password);

    result.fold(
        (error) => emit(DeleteAccountErrorState(errorMessage: error.message)),
        (data) {
      DeleteAccountEvent;

      emit(
        DeleteAccountSuccessState(message: data),
      );
    });
  }

  Future<void> _onSelectBannerEvent(
      SelectBannerEvent event, Emitter<UserState> emit) async {
    emit(SelectBannerLoadingState());
    final result =
        await userRepository.selectBanner(imageSource: event.imageSource);

    result.fold(
        (error) => emit(SelectBannerErrorState(errorMessage: error.message)),
        (data) {
      emit(
        SelectBannerSuccessState(file: data),
      );
    });
  }

  Future<void> _onSelectProfilePictureEvent(
      SelectProfilePictureEvent event, Emitter<UserState> emit) async {
    emit(SelectProfilePictureLoadingState());
    final result = await userRepository.selectProfilePicture(
        imageSource: event.imageSource);

    result.fold(
        (error) =>
            emit(SelectProfilePictureErrorState(errorMessage: error.message)),
        (data) {
      emit(
        SelectProfilePictureSuccessState(file: data),
      );
    });
  }

  Future<void> _onGetUserDetailsEvent(
      GetUserDetailsEvent event, Emitter<UserState> emit) async {
    emit(GetUserDetailsLoadingState());
    final result = await userRepository.getUserDetails();
    result.fold(
        (error) => emit(GetUserDetailsErrorState(errorMessage: error.message)),
        (data) {
      emit(
        GetUserDetailsSuccessState(userEntity: data),
      );
    });
  }

  Future<void> _onGetCreatorLeaderboardEvent(
      GetCreatorLeaderboardEvent event, Emitter<UserState> emit) async {
    print('UserBloc: Starting getCreatorLeaderboard request');
    emit(GetCreatorLeaderboardLoadingState(
      levelName: event.levelName,
      page: event.page,
      timeFilter: event.timeFilter,
      creator: event.creator,
    ));
    print('UserBloc: LoadingState emitted');
    final result = await userRepository.getCreatorLeaderboard(
      levelName: event.levelName,
      page: event.page,
      timeFilter: event.timeFilter,
      creator: event.creator,
    );
    print('UserBloc: Repository result received');
    result.fold(
      (error) {
        print('UserBloc: Error - ${error.message}');
        emit(GetCreatorLeaderboardErrorState(
          errorMessage: error.message,
          levelName: event.levelName,
          page: event.page,
          timeFilter: event.timeFilter,
          creator: event.creator,
        ));
      },
      (data) {
        print('UserBloc: Success - data.message: ${data.message}');
        print('UserBloc: Success - data.data: ${data.data}');
        print('UserBloc: Success - data.data.rankings: ${data.data.rankings}');
        print(
            'UserBloc: Success - data.data.rankings.length: ${data.data.rankings.length}');
        emit(GetCreatorLeaderboardSuccessState(
          response: data,
          levelName: event.levelName,
          page: event.page,
          timeFilter: event.timeFilter,
          creator: event.creator,
        ));
      },
    );
  }

  Future<void> _onGetCreatorLevelsEvent(
      GetCreatorLevelsEvent event, Emitter<UserState> emit) async {
    print('UserBloc: Starting getCreatorLevels request');
    emit(GetCreatorLevelsLoadingState());
    final result = await userRepository.getCreatorLevels();
    result.fold(
      (error) {
        print('UserBloc: Error - ${error.message}');
        emit(GetCreatorLevelsErrorState(errorMessage: error.message));
      },
      (data) {
        print('UserBloc: Success - data.message: ${data.message}');
        emit(GetCreatorLevelsSuccessState(response: data));
      },
    );
  }

  // _onGetUserDetailsEvent
}
