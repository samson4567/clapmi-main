import 'dart:convert';

import 'package:clapmi/features/authentication/domain/entities/token_entity.dart';
import 'package:equatable/equatable.dart';

class TokenModel extends TokenEntity with EquatableMixin {
  TokenModel({required super.accessToken, required super.refreshToken});

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      accessToken: json["access_token"],
      refreshToken: json["refresh_token"],
    );
  }

  static Map<String, dynamic> toMap(TokenModel tokenModel) {
    return <String, dynamic>{
      'access_token': tokenModel.accessToken,
      "refresh_token": tokenModel.refreshToken
    };
  }

  static String serialize(TokenModel tokenModel) =>
      json.encode(TokenModel.toMap(tokenModel));

  static TokenModel deserialize(String json) =>
      TokenModel.fromJson(jsonDecode(json));

  factory TokenModel.fromEntity(TokenEntity tokenEntity) => TokenModel(
      accessToken: tokenEntity.accessToken,
      refreshToken: tokenEntity.refreshToken);

  @override
  List<Object?> get props => [accessToken, refreshToken];
}
