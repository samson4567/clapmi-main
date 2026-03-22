import '../../domain/entities/kyc_status_entity.dart';

class KycStatusModel extends KycStatusEntity {
  const KycStatusModel({
    super.verificationUuid,
    super.documentType,
    super.document,
    super.idType,
    super.livenessCheckPassed,
  });

  /// From JSON
  factory KycStatusModel.fromJson(Map<String, dynamic> json) {
    return KycStatusModel(
      verificationUuid: json['verification_uuid'],
      documentType: json['document_type'],
      document: json['document'],
      idType: json['id_type'],
      livenessCheckPassed: json['liveness_check_passed'],
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'verification_uuid': verificationUuid,
      'document_type': documentType,
      'document': document,
      'id_type': idType,
      'liveness_check_passed': livenessCheckPassed,
    };
  }

  /// From Entity
  factory KycStatusModel.fromEntity(KycStatusEntity entity) {
    return KycStatusModel(
      verificationUuid: entity.verificationUuid,
      documentType: entity.documentType,
      document: entity.document,
      idType: entity.idType,
      livenessCheckPassed: entity.livenessCheckPassed,
    );
  }
}
