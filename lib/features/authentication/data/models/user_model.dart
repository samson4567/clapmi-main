// import 'dart:convert';

// import 'package:clapmi/features/authentication/domain/entities/user_entity.dart';
// import 'package:equatable/equatable.dart';

// class UserModel extends UserEntity with EquatableMixin {
//   UserModel(
//       {required super.id,
//       required super.name,
//       required super.email,
//       super.emailVerifiedAt,
//       super.image,
//       super.banner,
//       super.occupation,
//       super.bio,
//       super.dateOfBirth,
//       super.country,
//       super.state,
//       super.mobile,
//       super.language,
//       super.location,
//       super.google2faSecret,
//       super.referredBy,
//       required super.pid,
//       required super.username,
//       required super.verified,
//       required super.isBanned,
//       required super.slug,
//       required super.hasInterests,
//       required super.authProvider,
//       required super.ipAddress,
//       required super.twoFactorPassed,
//       required super.walletAddress,
//       required super.bragWalletBalance,
//       required super.createdAt,
//       required super.updatedAt});

//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       id: json["id"],
//       name: json["name"],
//       email: json["email"],
//       emailVerifiedAt: json["email_verified_at"],
//       pid: json["pid"],
//       username: json["username"],
//       verified: json["verified"],
//       isBanned: json["is_banned"],
//       slug: json["slug"],
//       image: json["image"],
//       banner: json["banner"],
//       occupation: json["occupation"],
//       hasInterests: json["has_interests"],
//       bio: json["bio"],
//       dateOfBirth: json["date_of_birth"],
//       country: json["country"],
//       state: json["state"],
//       authProvider: json["auth_provider"],
//       mobile: json["mobile"],
//       ipAddress: json["ip_address"],
//       location: json["location"],
//       language: json["language"],
//       google2faSecret: json["google2fa_secret"],
//       twoFactorPassed: json["two_factor_passed"],
//       referredBy: json["referred_by"],
//       walletAddress: json["wallet_address"],
//       bragWalletBalance: json["brag_wallet_balance"],
//       createdAt: json["created_at"],
//       updatedAt: json["updated_at"],
//     );
//   }

//   static Map<String, dynamic> toMap(UserModel userModel) {
//     return <String, dynamic>{
//       "id": userModel.id,
//       "name": userModel.name,
//       "email": userModel.email,
//       "email_verified_at": userModel.emailVerifiedAt,
//       "pid": userModel.pid,
//       "username": userModel.username,
//       "verified": userModel.verified,
//       "is_banned": userModel.isBanned,
//       "slug": userModel.slug,
//       "image": userModel.image,
//       "banner": userModel.banner,
//       "occupation": userModel.occupation,
//       "has_interests": userModel.hasInterests,
//       "bio": userModel.bio,
//       "date_of_birth": userModel.dateOfBirth,
//       "country": userModel.country,
//       "state": userModel.state,
//       "auth_provider": userModel.authProvider,
//       "mobile": userModel.mobile,
//       "ip_address": userModel.ipAddress,
//       "location": userModel.location,
//       "language": userModel.language,
//       "google2fa_secret": userModel.google2faSecret,
//       "two_factor_passed": userModel.twoFactorPassed,
//       "referred_by": userModel.referredBy,
//       "wallet_address": userModel.walletAddress,
//       "brag_wallet_balance": userModel.bragWalletBalance,
//       "created_at": userModel.createdAt,
//       "updated_at": userModel.updatedAt,
//     };
//   }

//   static UserModel fromMap(Map<String, dynamic> map) {
//     return UserModel(
//       id: map["id"],
//       name: map["name"],
//       email: map["email"],
//       emailVerifiedAt: map["email_verified_at"],
//       pid: map["pid"],
//       username: map["username"],
//       verified: map["verified"],
//       isBanned: map["is_banned"],
//       slug: map["slug"],
//       image: map["image"],
//       banner: map["banner"],
//       occupation: map["occupation"],
//       hasInterests: map["has_interests"],
//       bio: map["bio"],
//       dateOfBirth: map["date_of_birth"],
//       country: map["country"],
//       state: map["state"],
//       authProvider: map["auth_provider"],
//       mobile: map["mobile"],
//       ipAddress: map["ip_address"],
//       location: map["location"],
//       language: map["language"],
//       google2faSecret: map["google2fa_secret"],
//       twoFactorPassed: map["two_factor_passed"],
//       referredBy: map["referred_by"],
//       walletAddress: map["wallet_address"],
//       bragWalletBalance: map["brag_wallet_balance"],
//       createdAt: map["created_at"],
//       updatedAt: map["updated_at"],
//     );
//   }

//   static String serialize(UserModel userModel) =>
//       json.encode(UserModel.toMap(userModel));

//   static UserModel deserialize(String json) =>
//       UserModel.fromMap(jsonDecode(json));

//   @override
//   List<Object?> get props => throw UnimplementedError();

//   static fromOnlinejson(host) {}
// }
