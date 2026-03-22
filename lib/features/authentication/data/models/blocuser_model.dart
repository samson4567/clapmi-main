import 'package:clapmi/features/authentication/domain/entities/blockuser_entity.dart';

class BlokUserModel extends BlokUserEntity {
  const BlokUserModel({required super.creator});

  factory BlokUserModel.fromJson(Map<String, dynamic> json) {
    return BlokUserModel(
      creator: json['creator'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'creator': creator,
    };
  }
}
