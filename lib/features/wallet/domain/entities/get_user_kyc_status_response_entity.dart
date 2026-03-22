import 'package:equatable/equatable.dart';

class GetUserKycStatusResponseEntity extends Equatable {
  final bool? isVerified;
  final bool? exists;
  final String? verificationUuid;

  const GetUserKycStatusResponseEntity({
    this.exists,
    this.isVerified,
    this.verificationUuid,
  });

  @override
  List<Object?> get props => [
        exists,
        isVerified,
        verificationUuid,
      ];
}
