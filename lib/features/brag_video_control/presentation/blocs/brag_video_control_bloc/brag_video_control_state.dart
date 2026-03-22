// import 'dart:io';

// import 'package:clapmi/features/user/domain/entities/user_entity.dart';
// import 'package:equatable/equatable.dart';

// sealed class UserState extends Equatable {
//   const UserState();

//   @override
//   List<Object> get props => [];
// }

// final class UserInitial extends UserState {
//   UserInitial();
// }

// // user update States
// final class UserDetailUpdateLoadingState extends UserState {
//   UserDetailUpdateLoadingState();
// }

// final class UserDetailUpdateSuccessState extends UserState {
//   final String message;

//   UserDetailUpdateSuccessState({required this.message});

//   @override
//   List<Object> get props => [message];
// }

// final class UserDetailUpdateErrorState extends UserState {
//   final String errorMessage;

//   UserDetailUpdateErrorState({required this.errorMessage});

//   @override
//   List<Object> get props => [errorMessage];
// }

// // DeleteAccount States
// final class DeleteAccountLoadingState extends UserState {
//   DeleteAccountLoadingState();
// }

// final class DeleteAccountSuccessState extends UserState {
//   final String message;

//   DeleteAccountSuccessState({required this.message});

//   @override
//   List<Object> get props => [message];
// }

// final class DeleteAccountErrorState extends UserState {
//   final String errorMessage;

//   DeleteAccountErrorState({required this.errorMessage});

//   @override
//   List<Object> get props => [errorMessage];
// }

// // SelectBanner states
// final class SelectBannerLoadingState extends UserState {
//   SelectBannerLoadingState();
// }

// final class SelectBannerSuccessState extends UserState {
//   final File file;

//   SelectBannerSuccessState({required this.file});

//   @override
//   List<Object> get props => [file];
// }

// final class SelectBannerErrorState extends UserState {
//   final String errorMessage;

//   SelectBannerErrorState({required this.errorMessage});

//   @override
//   List<Object> get props => [errorMessage];
// }

// // SelectProfilePicture states
// final class SelectProfilePictureLoadingState extends UserState {
//   SelectProfilePictureLoadingState();
// }

// final class SelectProfilePictureSuccessState extends UserState {
//   final File file;

//   SelectProfilePictureSuccessState({required this.file});

//   @override
//   List<Object> get props => [file];
// }

// final class SelectProfilePictureErrorState extends UserState {
//   final String errorMessage;

//   SelectProfilePictureErrorState({required this.errorMessage});

//   @override
//   List<Object> get props => [errorMessage];
// }

// // GetUserDetails States
// final class GetUserDetailsLoadingState extends UserState {
//   GetUserDetailsLoadingState();
// }

// final class GetUserDetailsSuccessState extends UserState {
//   final UserEntity userEntity;

//   GetUserDetailsSuccessState({required this.userEntity});

//   @override
//   List<Object> get props => [userEntity];
// }

// final class GetUserDetailsErrorState extends UserState {
//   final String errorMessage;

//   GetUserDetailsErrorState({required this.errorMessage});

//   @override
//   List<Object> get props => [errorMessage];
// }



// // GetUserDetails