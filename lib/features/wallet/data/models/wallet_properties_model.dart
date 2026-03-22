import 'package:clapmi/features/wallet/domain/entities/wallet_properties.dart';

class WalletPropertiesModel extends WalletPropertiesEntity {
  const WalletPropertiesModel({
    required super.is2faSetUp,
    required super.isEmailVerified,
    required super.isWithdrawalPinCreated,
  });

  factory WalletPropertiesModel.fromMap(Map<String, dynamic> map) {
    return WalletPropertiesModel(
      is2faSetUp: map['has-setup-2fa'] as bool,
      isEmailVerified: map['has-verified-email'] as bool,
      isWithdrawalPinCreated: map['has-created-withdrawal-pin'] as bool,
    );
  }
}
