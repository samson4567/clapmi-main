import 'package:clapmi/features/authentication/data/models/token_model.dart';
import 'package:clapmi/features/authentication/domain/entities/verify_sign_up_entity.dart';
import 'package:clapmi/features/user/data/models/user_model.dart';
import 'package:equatable/equatable.dart';

class VerifySignUpModel extends VerifySignUpEntity with EquatableMixin {
  VerifySignUpModel({required super.tokenEntity, required super.userEntity});

  factory VerifySignUpModel.fromJson(Map<String, dynamic> json) {
    return VerifySignUpModel(
      tokenEntity: TokenModel.fromJson(json['token']),
      userEntity: UserModel.fromJson(json['user']),
    );
  }

  @override
  List<Object?> get props => [tokenEntity, userEntity];
}
