import 'package:clapmi/features/wallet/domain/entities/confirm_address_entity.dart';

class ConfirmAddressDepositModel extends ConfirmAddressDepositEntity {
  const ConfirmAddressDepositModel({required super.address});
  factory ConfirmAddressDepositModel.fromJson(Map<String, dynamic> json) {
    return ConfirmAddressDepositModel(
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
    };
  }
}
