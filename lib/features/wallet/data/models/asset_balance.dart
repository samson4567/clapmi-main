// ignore_for_file: non_constant_identifier_names

import 'package:clapmi/features/wallet/domain/entities/asset_entity.dart';

class AssetModel extends AssetEntity {
  const AssetModel({
    required super.balance,
    required super.conversionRate,
    required super.id,
    required super.name,
    required super.symbol,
  });

  factory AssetModel.fromJson(Map<String, dynamic> json) {
    String parseString(dynamic value) {
      if (value == null) return '0';
      if (value is String) return value;
      if (value is num) return value.toString();
      return '0';
    }

    final assetData = json['asset'] as Map<String, dynamic>? ?? {};

    return AssetModel(
      balance: parseString(json['balance']),
      conversionRate: parseString(json['conversion-rate']),
      id: assetData['id'] as String? ?? '',
      name: assetData['name'] as String? ?? '',
      symbol: assetData['symbol'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'conversion-rate': conversionRate,
      'asset': {
        'name': name,
        'id': id,
        'symbol': symbol,
      },
    };
  }
}

class WalletAddressModel extends WalletAddress {
  const WalletAddressModel(
      {required super.type, required super.wallet_address});

  factory WalletAddressModel.fromMap(Map<String, dynamic> map) {
    return WalletAddressModel(
      type: map['type'] != null ? map['type'] as String : null,
      wallet_address: map['wallet_address'] != null
          ? map['wallet_address'] as String
          : null,
    );
  }
}

class WalletAddressUSDCModel extends WalletUSDCAddress {
  const WalletAddressUSDCModel(
      {required super.type, required super.wallet_address});

  factory WalletAddressUSDCModel.fromMap(Map<String, dynamic> map) {
    return WalletAddressUSDCModel(
      type: map['type'] != null ? map['type'] as String : null,
      wallet_address: map['wallet_address'] != null
          ? map['wallet_address'] as String
          : null,
    );
  }
}
