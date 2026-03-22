import 'package:equatable/equatable.dart';

class ConfirmAddressDepositEntity extends Equatable {
  final String address;

  const ConfirmAddressDepositEntity({required this.address});

  @override
  List<Object?> get props => [address];
}
