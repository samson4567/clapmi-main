import 'package:equatable/equatable.dart';

class KycVerificationEntity extends Equatable {
  final String verificationUuid;
  final String status;
  final int submissionAttempt;

  const KycVerificationEntity({
    required this.verificationUuid,
    required this.status,
    required this.submissionAttempt,
  });

  @override
  List<Object?> get props => [verificationUuid, status, submissionAttempt];
}
