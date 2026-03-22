import 'dart:convert';

import 'package:clapmi/features/onboarding/domain/entities/other_user_entity.dart';
import 'package:equatable/equatable.dart';

class OtherUserModel extends OtherUserEntity with EquatableMixin {
  @override
  final String pid;
  @override
  final String? occupation;
  @override
  final String? name;
  @override
  final String? image;

  OtherUserModel({
    required this.pid,
    this.occupation,
    this.name,
    this.image,
  }) : super(
          image: image,
          name: name,
          occupation: occupation,
          pid: pid,
        );

  Map<String, dynamic> toJson() {
    return {
      "pid": pid,
      "occupation": occupation,
      "name": name,
      "image": image,
    };
  }

  factory OtherUserModel.fromJson(Map jsonMap) {
    return OtherUserModel(
      pid: jsonMap["pid"],
      occupation: jsonMap["occupation"],
      name: jsonMap["name"],
      image: jsonMap["image"],
    );
  }

  String serialize() {
    return json.encode(toJson());
  }

  factory OtherUserModel.deserialize(String serializedMap) {
    Map deserializedMap = jsonDecode(serializedMap);
    return OtherUserModel.fromJson(deserializedMap);
  }
  factory OtherUserModel.fromEntity(OtherUserEntity otherUserEntity) {
    return OtherUserModel(
      pid: otherUserEntity.pid,
      occupation: otherUserEntity.occupation,
      name: otherUserEntity.name,
      image: otherUserEntity.image,
    );
  }

  @override
  List<Object?> get props => [pid];
}
