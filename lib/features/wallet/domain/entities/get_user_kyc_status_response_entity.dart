import 'package:equatable/equatable.dart';

class GetUserKycStatusResponseEntity extends Equatable {
  final bool? isVerified;
  final bool? exists;
  final String? verificationUuid;
  final String? status;
  final String? reason;
  final String? level;
  final int? submissionAttempt;

  const GetUserKycStatusResponseEntity({
    this.exists,
    this.isVerified,
    this.verificationUuid,
    this.status,
    this.reason,
    this.level,
    this.submissionAttempt,
  });

  bool get hasVerificationUuid =>
      verificationUuid != null && verificationUuid!.trim().isNotEmpty;

  bool get isPending {
    final normalized = status?.toLowerCase().trim() ?? '';
    return normalized == 'pending' ||
        normalized == 'in_progress' ||
        normalized == 'under_review' ||
        normalized == 'processing' ||
        normalized == 'submitted';
  }

  bool get isRejected {
    final normalized = status?.toLowerCase().trim() ?? '';
    return normalized == 'rejected' ||
        normalized == 'declined' ||
        normalized == 'failed';
  }

  @override
  List<Object?> get props => [
        exists,
        isVerified,
        verificationUuid,
        status,
        reason,
        level,
        submissionAttempt,
      ];
}
