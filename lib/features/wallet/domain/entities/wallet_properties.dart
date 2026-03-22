// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

class WalletPropertiesEntity extends Equatable {
  final bool is2faSetUp;
  final bool isEmailVerified;
  final bool isWithdrawalPinCreated;
  const WalletPropertiesEntity({
    required this.is2faSetUp,
    required this.isEmailVerified,
    required this.isWithdrawalPinCreated,
  });

  @override
  List<Object?> get props =>
      [is2faSetUp, isEmailVerified, isWithdrawalPinCreated];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'is2faSetUp': is2faSetUp,
      'isEmailVerified': isEmailVerified,
      'isWithdrawalPinCreated': isWithdrawalPinCreated,
    };
  }
}
