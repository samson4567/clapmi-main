import 'dart:convert';

import 'package:clapmi/features/user/data/models/user_model.dart';

class ClapperModel extends UserModel {
  var avatarImage;
  var bannerImage;
  @override
  var username;
  var PID;
  var wierdID;
  @override
  var name;
  var fullDetails;

  ClapperModel({
    this.avatarImage,
    this.bannerImage,
    required this.username,
    this.PID,
    this.wierdID,
    required this.name,
    this.fullDetails,

    // super.id = 0,
    // super.pid = "",
    // super.verified = true,
    // super.isBanned = 0,
    // super.slug = "",
    // super.hasInterests = 0,
    // super.authProvider = "",
    // super.ipAddress = "",
    // super.twoFactorPassed = 0,
    // super.walletAddress = "",
    // super.bragWalletBalance = "",
    // super.createdAt = "",
    // super.updatedAt = "",
    String email = "",
  }) : super(
            email: email,
            id: 0,
            name: '',
            pid: '',
            username: '',
            verified: false,
            isBanned: 0,
            slug: '',
            hasInterests: 0,
            authProvider: '',
            ipAddress: '',
            twoFactorPassed: 0,
            walletAddress: '',
            bragWalletBalance: '',
            createdAt: '',
            updatedAt: '');

  factory ClapperModel.fromjson(Map json) {
    return ClapperModel(
      PID: json['PID'],
      wierdID: json['wierdID'],
      avatarImage: json['avatarImage'],
      bannerImage: json['bannerImage'],
      name: json['name'],
      username: json['username'],
      fullDetails: jsonDecode(json['fullDetails']),
      email: '',
    );
  }

  factory ClapperModel.fromOnlinejson(Map json) {
    return ClapperModel(
      PID: json['pid'],
      wierdID: json['id'],
      avatarImage: json['image'],
      bannerImage: json['banner'],
      name: json['name'],
      username: json['username'],
      fullDetails: json,
      email: '',
    );
  }

  factory ClapperModel.dummy() {
    return ClapperModel(
      PID: "PID",
      wierdID: 10000,
      avatarImage:
          "https://res.cloudinary.com/clapmi-alt/image/upload/v1700033675/avatarr_lq3cnv.jpg",
      bannerImage:
          "https://res.cloudinary.com/clapmi-alt/image/upload/v1700033675/avatarr_lq3cnv.jpg",
      name: "dum fuck",
      username: "dumfucekry",
      fullDetails: {},
      email: '',
    );
  }
}
