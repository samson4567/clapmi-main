import 'package:clapmi/core/utils.dart';
import 'package:clapmi/features/user/domain/entities/user_entity.dart';
import 'package:uuid/uuid.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.email,
    required super.id,
    required super.name,
    required super.pid,
    required super.username,
    required super.verified,
    required super.isBanned,
    required super.slug,
    required super.hasInterests,
    required super.authProvider,
    required super.ipAddress,
    required super.twoFactorPassed,
    required super.walletAddress,
    required super.bragWalletBalance,
    required super.createdAt,
    required super.updatedAt,
    super.image,
    super.bio,
    super.banner,
    super.whoCanSeeMyPost,
    super.whoCanShareMyPost,
    super.whoCanViewMyStories,
    super.private,
    super.activityStatus,
    super.showLingo,
    super.showEmail,
    super.showPhone,
    super.isFriend,
  });

  factory UserModel.fromJson(Map<dynamic, dynamic> json) {
    return UserModel(
      email: json["email"],
      id: json["id"] ?? 0,
      name: json["name"],
      pid: json["pid"],
      username: json["username"],
      verified: json["verified"],
      isBanned: json["isBanned"],
      bio: json["bio"],
      banner: json["banner"],
      whoCanSeeMyPost: json["privacy"]?["who_can_see_my_post"],
      whoCanShareMyPost: json["privacy"]?["who_can_share_my_post"],
      whoCanViewMyStories: json["privacy"]?["who_can_view_my_stories"],
      private: json["settings"]?["private"],
      activityStatus: json["settings"]?["activity_status"],
      showLingo: json["settings"]?["show_lingo"],
      showEmail: json["settings"]?["show_email"],
      showPhone: json["settings"]?["show_phone"],
      slug: json["slug"],
      hasInterests: json["hasInterests"],
      authProvider: json["authProvider"],
      ipAddress: json["ipAddress"],
      twoFactorPassed: json["twoFactorPassed"],
      walletAddress: json["walletAddress"],
      bragWalletBalance: json["bragWalletBalance"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      image: json["image"],
      isFriend: json["is_friend"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "id": id,
      "name": name,
      "pid": pid,
      "username": username,
      "verified": verified,
      "isBanned": isBanned,
      "slug": slug,
      "hasInterests": hasInterests,
      "authProvider": authProvider,
      "ipAddress": ipAddress,
      "twoFactorPassed": twoFactorPassed,
      "walletAddress": walletAddress,
      "bragWalletBalance": bragWalletBalance,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "image": image,
    };
  }

  factory UserModel.empty() {
    return UserModel(
      email: "dumable@gmail.com",
      id: generateLongNumber(),
      name: "dumable pasune",
      pid: Uuid().v4(),
      username: "dumablepasune",
      verified: true,
      isBanned: 0,
      slug: "dumable_pasune",
      hasInterests: 0,
      authProvider: "email",
      ipAddress: "nlsadub1b12212inbdn",
      twoFactorPassed: 0,
      walletAddress: "ajsjnsjkabsjabsabsajsbajsbasjasas",
      bragWalletBalance: "10",
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
      image: "assets/icons/Frame 1000003940@3x.png",
    );
  }

  UserModel copyWith({
    final int? id,
    final String? name,
    final String? email,
    final String? emailVerifiedAt,
    final String? pid,
    final String? username,
    final bool? verified,
    final int? isBanned,
    final String? slug,
    final String? image,
    final String? banner,
    final String? occupation,
    final int? hasInterests,
    final String? bio,
    final String? dateOfBirth,
    final String? country,
    final String? state,
    final String? authProvider,
    final String? mobile,
    final String? ipAddress,
    final String? location,
    final String? language,
    final String? google2faSecret,
    final int? twoFactorPassed,
    final String? referredBy,
    final String? walletAddress,
    final String? bragWalletBalance,
    final String? createdAt,
    final String? updatedAt,
  }) {
    return UserModel(
      email: email ?? this.email,
      id: id ?? this.id,
      name: name ?? this.name,
      pid: pid ?? this.pid,
      username: username ?? this.username,
      verified: verified ?? this.verified,
      isBanned: isBanned ?? this.isBanned,
      slug: slug ?? this.slug,
      hasInterests: hasInterests ?? this.hasInterests,
      authProvider: authProvider ?? this.authProvider,
      ipAddress: ipAddress ?? this.ipAddress,
      twoFactorPassed: twoFactorPassed ?? this.twoFactorPassed,
      walletAddress: walletAddress ?? this.walletAddress,
      bragWalletBalance: bragWalletBalance ?? this.bragWalletBalance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return "${super.toString()}>>> ${toJson()}";
  }

  factory UserModel.createFromLogin(Map json) {
    return UserModel(
      email: json["email"] ?? "",
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      pid: "",
      username: "",
      verified: true,
      isBanned: 0,
      slug: "",
      hasInterests: 0,
      authProvider: "",
      ipAddress: "",
      twoFactorPassed: 0,
      walletAddress: "",
      bragWalletBalance: "",
      createdAt: "",
      updatedAt: "",
    );
  }

  factory UserModel.fromEntity(UserEntity userEntity) {
    return UserModel(
      email: userEntity.email,
      id: userEntity.id,
      name: userEntity.name,
      pid: userEntity.pid,
      username: userEntity.username,
      verified: userEntity.verified,
      isBanned: userEntity.isBanned,
      slug: userEntity.slug,
      hasInterests: userEntity.hasInterests,
      authProvider: userEntity.authProvider,
      ipAddress: userEntity.ipAddress,
      twoFactorPassed: userEntity.twoFactorPassed,
      walletAddress: userEntity.walletAddress,
      bragWalletBalance: userEntity.bragWalletBalance,
      createdAt: userEntity.createdAt,
      updatedAt: userEntity.updatedAt,
    );
  }
}
