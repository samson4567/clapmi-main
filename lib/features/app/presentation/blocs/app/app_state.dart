import 'package:clapmi/features/app/data/models/user_model.dart';
import 'package:clapmi/features/post/data/models/create_post_model.dart';
import 'package:clapmi/features/post/data/models/post_model.dart';
import 'package:clapmi/features/user/data/models/user_model.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
sealed class AppState extends Equatable {
  AppState({this.user, this.testPostModel}) {
    testPostModel ??= CreatePostModel.fromJson({
      "creator": "EZ3pgMqr2NUddWDO",
      "content": "My first Post Test 123 ashajsakjsha",
      "images": null,
      "uuid": "0d85609e-79b9-44a7-8a2f-4f552d4e5513"
      // "uuid": "b9dc7df8-d68c-476c-830b-1ee01321217b"
      // "uuid": "d0f5eb8b-c605-4554-b913-2c3177db41ab"
    });
  }
  UserModel? user = UserModel.empty();
  CreatePostModel? testPostModel;

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class AppInitial extends AppState {
  AppInitial();
}

// user update States
// ignore: must_be_immutable
class UserUpdateLoadingState extends AppState {
  UserUpdateLoadingState();
}

// ignore: must_be_immutable
class UserUpdateSuccessState extends AppState {
  final UserModel updatedUser;

  UserUpdateSuccessState({required UserModel user})
      : updatedUser = user,
        super(user: user);

  @override
  List<Object> get props => [updatedUser];
}

// ignore: must_be_immutable
class UserUpdateErrorState extends AppState {
  final String errorMessage;

  UserUpdateErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// user update States
// ignore: must_be_immutable
class PostCreationLoadingState extends AppState {
  PostCreationLoadingState();
}

// ignore: must_be_immutable
final class PostCreationSuccessState extends AppState {
  @override
  PostCreationSuccessState({super.user});

  @override
  List<Object> get props => [user!];
}

// ignore: must_be_immutable
final class PostCreationErrorState extends AppState {
  final String errorMessage;

  PostCreationErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// Get User Profile States
// ignore: must_be_immutable
final class GetUserProfileLoading extends AppState {
  GetUserProfileLoading();
}

// ignore: must_be_immutable
class GetUserProfileSuccess extends AppState {
  final UserModel userProfile;

  GetUserProfileSuccess({required this.userProfile});

  @override
  List<Object> get props => [userProfile];
}

// ignore: must_be_immutable
class GetUserProfileError extends AppState {
  final String errorMessage;

  GetUserProfileError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class ProfileSuccess extends AppState {
  final ProfileModel ownUser; // Change from ProfileModel? to UserModel?
  ProfileSuccess(this.ownUser);

  @override
  List<Object> get props => [ownUser];
}

// SetPreviouslyStoredPostModelListEvent

class SetPreviouslyStoredPostModelListSuccessState extends AppState {
  String message;
  SetPreviouslyStoredPostModelListSuccessState(this.message);

  @override
  List<Object> get props => [message];
}

class SetPreviouslyStoredPostModelListLoadingState extends AppState {
  SetPreviouslyStoredPostModelListLoadingState();

  @override
  List<Object> get props => [];
}

class SetPreviouslyStoredPostModelListErrorState extends AppState {
  String errorMessage;
  SetPreviouslyStoredPostModelListErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// GetPreviouslyStoredPostModelListEvent

class GetPreviouslyStoredPostModelListSuccessState extends AppState {
  List<PostModel> listOfCachedPosts;
  GetPreviouslyStoredPostModelListSuccessState(this.listOfCachedPosts);

  @override
  List<Object> get props => [listOfCachedPosts];
}

class GetPreviouslyStoredPostModelListLoadingState extends AppState {
  GetPreviouslyStoredPostModelListLoadingState();

  @override
  List<Object> get props => [];
}

class GetPreviouslyStoredPostModelListErrorState extends AppState {
  String errorMessage;
  GetPreviouslyStoredPostModelListErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
