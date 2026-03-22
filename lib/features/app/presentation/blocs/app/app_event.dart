import 'package:clapmi/features/post/data/models/post_model.dart';
import 'package:clapmi/features/user/data/models/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class UserUpdateEvent extends AppEvent {
  final UserModel updatedUserModel;

  const UserUpdateEvent({
    required this.updatedUserModel,
  });

  @override
  List<Object> get props => [updatedUserModel.toJson()];
}

class GetUserProfileEvent extends AppEvent {
  final String userId;

  const GetUserProfileEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class GetPreviouslyStoredPostModelListEvent extends AppEvent {
  const GetPreviouslyStoredPostModelListEvent();

  @override
  List<Object> get props => [];
}

class SetPreviouslyStoredPostModelListEvent extends AppEvent {
  final List<PostModel> listOfPostsToBeCached;
  const SetPreviouslyStoredPostModelListEvent(this.listOfPostsToBeCached);

  @override
  List<Object> get props => [listOfPostsToBeCached];
}

class GetMyProfileEvent extends AppEvent {}
