import 'package:equatable/equatable.dart';

class KycUploadEntity extends Equatable {
  final String verificationUuid;
  final String status;

  const KycUploadEntity({
    required this.verificationUuid,
    required this.status,
  });

  @override
  List<Object?> get props => [verificationUuid, status];
}
