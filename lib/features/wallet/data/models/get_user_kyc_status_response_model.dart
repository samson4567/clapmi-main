import 'package:clapmi/features/wallet/domain/entities/get_user_kyc_status_response_entity.dart';

// GetUserKycStatusResponseEntity
class GetUserKycStatusResponseModel extends GetUserKycStatusResponseEntity {
  const GetUserKycStatusResponseModel({
    super.exists,
    super.isVerified,
    super.verificationUuid,
  });

  /// From JSON
  factory GetUserKycStatusResponseModel.fromJson(Map<String, dynamic> json) {
    return GetUserKycStatusResponseModel(
      exists: json['kyc_status']?["exists"],
      isVerified: json['kyc_status']["is_verified"],
      verificationUuid: json['kyc_status']?["verification_uuid"],
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      "kyc_status": {
        "exists": exists,
        "is_verified": isVerified,
        "verification_uuid": verificationUuid,
      }
    };
  }

  /// From Entity
  factory GetUserKycStatusResponseModel.fromEntity(
      GetUserKycStatusResponseEntity entity) {
    return GetUserKycStatusResponseModel(
      exists: entity.exists,
      isVerified: entity.isVerified,
      verificationUuid: entity.verificationUuid,
    );
  }
}
