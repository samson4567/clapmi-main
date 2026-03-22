import 'package:equatable/equatable.dart';

class KycStatusEntity extends Equatable {
  final String? verificationUuid;
  final String? documentType;
  final String? document;
  final String? idType;
  final bool? livenessCheckPassed;

  const KycStatusEntity({
    this.verificationUuid,
    this.documentType,
    this.document,
    this.idType,
    this.livenessCheckPassed,
  });

  @override
  List<Object?> get props => [
        verificationUuid,
        documentType,
        document,
        idType,
        livenessCheckPassed,
      ];
}
