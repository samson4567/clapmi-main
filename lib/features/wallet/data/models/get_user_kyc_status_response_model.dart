import 'package:clapmi/features/wallet/domain/entities/get_user_kyc_status_response_entity.dart';

// GetUserKycStatusResponseEntity
class GetUserKycStatusResponseModel extends GetUserKycStatusResponseEntity {
  const GetUserKycStatusResponseModel({
    super.exists,
    super.isVerified,
    super.verificationUuid,
    super.status,
    super.reason,
    super.level,
    super.submissionAttempt,
  });

  /// From JSON
  factory GetUserKycStatusResponseModel.fromJson(Map<String, dynamic> json) {
    final kycStatus = (json['kyc_status'] as Map<String, dynamic>?) ?? {};
    return GetUserKycStatusResponseModel(
      exists: kycStatus["exists"] as bool?,
      isVerified: kycStatus["is_verified"] as bool?,
      verificationUuid: (kycStatus["verification_uuid"] ??
              kycStatus["verificationUuid"])
          ?.toString(),
      status: (kycStatus["status"] ?? kycStatus["state"])?.toString(),
      reason: (kycStatus["reason"] ??
              kycStatus["rejection_reason"] ??
              kycStatus["message"])
          ?.toString(),
      level: (kycStatus["level"] ?? kycStatus["kyc_level"])?.toString(),
      submissionAttempt: kycStatus["submission_attempt"] is int
          ? kycStatus["submission_attempt"] as int
          : int.tryParse('${kycStatus["submission_attempt"] ?? ''}'),
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      "kyc_status": {
        "exists": exists,
        "is_verified": isVerified,
        "verification_uuid": verificationUuid,
        "status": status,
        "reason": reason,
        "level": level,
        "submission_attempt": submissionAttempt,
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
      status: entity.status,
      reason: entity.reason,
      level: entity.level,
      submissionAttempt: entity.submissionAttempt,
    );
  }
}
