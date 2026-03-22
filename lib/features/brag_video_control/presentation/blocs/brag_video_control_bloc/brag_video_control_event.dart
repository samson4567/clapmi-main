// import 'package:equatable/equatable.dart';
// import 'package:image_picker/image_picker.dart';

// abstract class UserEvent extends Equatable {
//   const UserEvent();

//   @override
//   List<Object> get props => [];
// }

// final class UserDetailUpdateEvent extends UserEvent {
//   final Map userDetail;

//   const UserDetailUpdateEvent({
//     required this.userDetail,
//   });

//   @override
//   List<Object> get props => [userDetail];
// }

// final class DeleteAccountEvent extends UserEvent {
//   final String password;

//   const DeleteAccountEvent({
//     required this.password,
//   });

//   @override
//   List<Object> get props => [password];
// }

// final class SelectBannerEvent extends UserEvent {
//   final ImageSource imageSource;

//   const SelectBannerEvent({
//     required this.imageSource,
//   });

//   @override
//   List<Object> get props => [imageSource];
// }

// final class SelectProfilePictureEvent extends UserEvent {
//   final ImageSource imageSource;

//   const SelectProfilePictureEvent({
//     required this.imageSource,
//   });

//   @override
//   List<Object> get props => [imageSource];
// }

// final class GetUserDetailsEvent extends UserEvent {
//   final String email;
//   const GetUserDetailsEvent(this.email);

//   @override
//   List<Object> get props => [email];
// }


// // GetUserDetails