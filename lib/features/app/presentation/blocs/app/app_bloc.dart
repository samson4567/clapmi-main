import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/features/app/domain/repositories/app_repository.dart';
import 'package:clapmi/features/app/presentation/blocs/app/app_event.dart';
import 'package:clapmi/features/app/presentation/blocs/app/app_state.dart';
import 'package:clapmi/global_object_folder_jacket/global_variables/global_variables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AppRepository appRepository;

  AppBloc({required this.appRepository}) : super(AppInitial()) {
    on<GetUserProfileEvent>(_onGetUserProfile);
    on<UserUpdateEvent>(_onUserUpdate);
    on<GetMyProfileEvent>(_onGetMyProfileEventHandler);
    on<SetPreviouslyStoredPostModelListEvent>(
        _onSetPreviouslyStoredPostModelList);
    on<GetPreviouslyStoredPostModelListEvent>(
        _onGetPreviouslyStoredPostModelList);
  }
// SetPreviouslyStoredPostModelListEvent
// _onSetPreviouslyStoredPostModelList
  Future<void> _onUserUpdate(
      UserUpdateEvent event, Emitter<AppState> emit) async {
    emit(UserUpdateLoadingState());
    emit(UserUpdateSuccessState(user: event.updatedUserModel));
  }

  Future<void> _onGetUserProfile(
      GetUserProfileEvent event, Emitter<AppState> emit) async {
    emit(GetUserProfileLoading());
    final result = await appRepository.getUserProfile(userId: event.userId);
    result.fold(
        (failure) => emit(GetUserProfileError(errorMessage: failure.message)),
        (userProfile) {
      userModelG = userModelG?.copyWith(
        banner: userProfile.banner,
        occupation: userProfile.occupation,
        bio: userProfile.bio,
      );
      emit(GetUserProfileSuccess(userProfile: userProfile));
    });
  }

  Future<void> _onGetMyProfileEventHandler(
      GetMyProfileEvent event, Emitter<AppState> emit) async {
    if (!event.forceRefresh && profileModelG != null) {
      emit(ProfileSuccess(profileModelG!));
      return;
    }

    emit(GetUserProfileLoading());
    final result = await appRepository.getMyProfile();
    result.fold((failure) {
      print(
          "dfbdskfbsdkfbjdsf-_onGetMyProfileEventHandler>>eeeeeeeeee>>${failure.message}");
      emit(GetUserProfileError(errorMessage: failure.message));
    }, (user) {
      profileModelG = user;
      print(
          "dfbdskfbsdkfbjdsf-_onGetMyProfileEventHandler>>${profileModelG?.pid}");
      emit(ProfileSuccess(user));
    });
  }

  Future<void> _onSetPreviouslyStoredPostModelList(
      SetPreviouslyStoredPostModelListEvent event,
      Emitter<AppState> emit) async {
    emit(SetPreviouslyStoredPostModelListLoadingState());
    final result = await appRepository
        .setPreviouslyStoredPostModelList(event.listOfPostsToBeCached);
    result.fold(
        (failure) =>
            emit(SetPreviouslyStoredPostModelListErrorState(failure.message)),
        (user) {
      emit(SetPreviouslyStoredPostModelListSuccessState(user));
    });
  }

  Future<void> _onGetPreviouslyStoredPostModelList(
      GetPreviouslyStoredPostModelListEvent event,
      Emitter<AppState> emit) async {
    emit(GetPreviouslyStoredPostModelListLoadingState());
    final result = await appRepository.getPreviouslyStoredPostModelList();
    result.fold(
        (failure) =>
            emit(GetPreviouslyStoredPostModelListErrorState(failure.message)),
        (user) {
      theListOfPreviouslyStoredPostModelListG = user;

      emit(GetPreviouslyStoredPostModelListSuccessState(user));
    });
  }

  // SetPreviouslyStoredPostModelListEvent
}
