import 'package:clapmi/features/app/domain/entities/user_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required super.pid,
    super.name,
    required super.email,
    required super.username,
    required super.country,
    required super.mobile,
    required super.image,
    super.myAvatar,
    super.state,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      pid: json['pid'] ?? "",
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      username: json['username'] ?? "",
      country: json['country'] ?? "",
      mobile: json['mobile'] ?? "",
      state: json['state'] ?? "",
      image: json['image'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pid': pid,
      'name': name,
      'email': email,
      'username': username,
      'country': country,
      'mobile': mobile,
      'state': state,
      'image': image,
    };
  }
}
