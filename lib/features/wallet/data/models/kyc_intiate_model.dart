import 'package:clapmi/features/wallet/domain/entities/kyc_intiate_entiy.dart';

class KycVerificationModel extends KycVerificationEntity {
  const KycVerificationModel({
    required super.verificationUuid,
    required super.status,
    required super.submissionAttempt,
  });

  factory KycVerificationModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return KycVerificationModel(
      verificationUuid: data['verification_uuid'] ?? '',
      status: data['status'] ?? '',
      submissionAttempt: data['submission_attempt'] ?? 0,
    );
  }
}
