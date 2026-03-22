import 'package:clapmi/features/wallet/domain/entities/kyc_entityes.dart';

class KycUploadModel extends KycUploadEntity {
  const KycUploadModel({
    required super.verificationUuid,
    required super.status,
  });

  factory KycUploadModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return KycUploadModel(
      verificationUuid: data['verification_uuid'] ?? '',
      status: data['status'] ?? '',
    );
  }
}

class KycUploadParams {
  final String verificationUuid;
  final String documentType;
  final String document; // file path or base64
  final String idType;
  final int livenessCheckPassed;
  final String fullName;
  final String idNumber;
  final String dateOfBirth;

  const KycUploadParams({
    required this.idNumber,
    required this.dateOfBirth,
    required this.fullName,
    required this.verificationUuid,
    required this.documentType,
    required this.document,
    required this.idType,
    required this.livenessCheckPassed,
  });

  Map<String, dynamic> toJson() => {
        "date_of_birth": dateOfBirth,
        "id_number": idNumber,
        'full_name': fullName,
        'verification_uuid': verificationUuid,
        'document_type': documentType,
        'document': document,
        'id_type': idType,
        'liveness_check_passed': livenessCheckPassed,
      };
}
