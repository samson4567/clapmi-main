// import 'dart:convert';

// class UserModel {
//   final int? wierdID;
//   final String? PID;
//   final String? avatarImage;
//   final String? bannerImage;
//   final String? name;
//   final String? username;
//   final Map? fullDetails;

//   UserModel({
//     required this.PID,
//     required this.wierdID,
//     required this.avatarImage,
//     required this.bannerImage,
//     required this.name,
//     required this.username,
//     required this.fullDetails,
//   });

//   UserModel copyWith({
//     final int? wierdID,
//     final String? PID,
//     final String? avatarImage,
//     final String? bannerImage,
//     final String? name,
//     final String? username,
//     final Map? fullDetails,
//   }) {
//     return UserModel(
//       fullDetails: fullDetails ?? this.fullDetails,
//       PID: PID ?? this.PID,
//       wierdID: wierdID ?? this.wierdID,
//       avatarImage: avatarImage ?? this.avatarImage,
//       bannerImage: bannerImage ?? this.bannerImage,
//       name: name ?? this.name,
//       username: username ?? this.username,
//     );
//   }

//   factory UserModel.fromjson(Map json) {
//     return UserModel(
//       PID: json['PID'],
//       wierdID: json['wierdID'],
//       avatarImage: json['avatarImage'],
//       bannerImage: json['bannerImage'],
//       name: json['name'],
//       username: json['username'],
//       fullDetails: jsonDecode(json['fullDetails']),
//     );
//   }

//   factory UserModel.fromJson(Map json) {
//     return UserModel(
//       PID: json['pid'],
//       wierdID: json['id'],
//       avatarImage: json['image'],
//       bannerImage: json['banner'],
//       name: json['name'],
//       username: json['username'],
//       fullDetails: json,
//     );
//   }

//   factory UserModel.empty() {
//     return UserModel(
//       PID: "PID",
//       wierdID: 10000,
//       avatarImage:
//           "https://res.cloudinary.com/clapmi-alt/image/upload/v1700033675/avatarr_lq3cnv.jpg",
//       bannerImage:
//           "https://res.cloudinary.com/clapmi-alt/image/upload/v1700033675/avatarr_lq3cnv.jpg",
//       name: "Dume bean",
//       username: "bumbean",
//       fullDetails: {},
//     );
//   }

//   Map toMap() {
//     return {
//       "PID": PID,
//       "wierdID": wierdID,
//       "avatarImage": avatarImage,
//       "bannerImage": bannerImage,
//       "name": name,
//       "username": username,
//       "fullDetails": jsonEncode(fullDetails),
//     };
//   }

//   @override
//   String toString() {
//     return "${super.toString()}>>> ${toMap()}";
//   }

// }
