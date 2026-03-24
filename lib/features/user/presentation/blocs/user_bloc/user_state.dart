import 'dart:io';

import 'package:clapmi/features/user/data/models/creator_leaderboard_model.dart';
import 'package:clapmi/features/user/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {
  const UserInitial();
}

// user update States
final class UserDetailUpdateLoadingState extends UserState {
  const UserDetailUpdateLoadingState();
}

final class UserDetailUpdateSuccessState extends UserState {
  final String message;

  const UserDetailUpdateSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

final class UserDetailUpdateErrorState extends UserState {
  final String errorMessage;

  const UserDetailUpdateErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// DeleteAccount States
final class DeleteAccountLoadingState extends UserState {
  const DeleteAccountLoadingState();
}

final class DeleteAccountSuccessState extends UserState {
  final String message;

  const DeleteAccountSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

final class DeleteAccountErrorState extends UserState {
  final String errorMessage;

  const DeleteAccountErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// SelectBanner states
final class SelectBannerLoadingState extends UserState {
  const SelectBannerLoadingState();
}

final class SelectBannerSuccessState extends UserState {
  final File file;

  const SelectBannerSuccessState({required this.file});

  @override
  List<Object> get props => [file];
}

final class SelectBannerErrorState extends UserState {
  final String errorMessage;

  const SelectBannerErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// SelectProfilePicture states
final class SelectProfilePictureLoadingState extends UserState {
  const SelectProfilePictureLoadingState();
}

final class SelectProfilePictureSuccessState extends UserState {
  final File file;

  const SelectProfilePictureSuccessState({required this.file});

  @override
  List<Object> get props => [file];
}

final class SelectProfilePictureErrorState extends UserState {
  final String errorMessage;

  const SelectProfilePictureErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// GetUserDetails States
final class GetUserDetailsLoadingState extends UserState {
  const GetUserDetailsLoadingState();
}

final class GetUserDetailsSuccessState extends UserState {
  final UserEntity userEntity;

  const GetUserDetailsSuccessState({required this.userEntity});

  @override
  List<Object> get props => [userEntity];
}

final class GetUserDetailsErrorState extends UserState {
  final String errorMessage;

  const GetUserDetailsErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// Creator Leaderboard States
final class GetCreatorLeaderboardLoadingState extends UserState {
  const GetCreatorLeaderboardLoadingState();
}

final class GetCreatorLeaderboardSuccessState extends UserState {
  final CreatorLeaderboardResponse response;

  const GetCreatorLeaderboardSuccessState({required this.response});

  @override
  List<Object> get props => [response];
}

final class GetCreatorLeaderboardErrorState extends UserState {
  final String errorMessage;

  const GetCreatorLeaderboardErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}



// GetUserDetails