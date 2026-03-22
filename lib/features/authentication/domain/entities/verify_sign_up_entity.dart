import 'package:clapmi/features/authentication/domain/entities/token_entity.dart';
import 'package:clapmi/features/user/domain/entities/user_entity.dart';

class VerifySignUpEntity {
  VerifySignUpEntity({required this.tokenEntity, required this.userEntity});
  final TokenEntity tokenEntity;
  final UserEntity userEntity;
}
