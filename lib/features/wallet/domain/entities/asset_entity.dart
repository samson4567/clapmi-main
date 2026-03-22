// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

import 'package:equatable/equatable.dart';

class AssetEntity extends Equatable {
  final String balance;
  final String conversionRate;
  final String id;
  final String name;
  final String symbol;

  const AssetEntity({
    required this.balance,
    required this.conversionRate,
    required this.id,
    required this.name,
    required this.symbol,
  });

  @override
  List<Object?> get props => [balance, id, conversionRate, name, symbol];
}

class WalletAddress extends Equatable {
  final String? type;
  final String? wallet_address;
  const WalletAddress({
    this.type,
    this.wallet_address,
  });

  @override
  List<Object?> get props => [type, wallet_address];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'wallet_address': wallet_address,
    };
  }

  String toJson() => json.encode(toMap());
}

class WalletUSDCAddress extends Equatable {
  final String? type;
  final String? wallet_address;
  const WalletUSDCAddress({
    this.type,
    this.wallet_address,
  });

  @override
  List<Object?> get props => [type, wallet_address];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'wallet_address': wallet_address,
    };
  }

  String toJson() => json.encode(toMap());
}

class InitiateWithdrawalRequest extends Equatable {
  final String amount;
  final String network;
  final String address;
  final String assets;
  final String idempotentKey;
  const InitiateWithdrawalRequest(
      {required this.amount,
      required this.network,
      required this.address,
      required this.idempotentKey,
      required this.assets});

  @override
  List<Object?> get props => [amount, address, network];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'amount': amount,
      'network': network,
      'address': address,
      'asset': assets,
      'idempotency_key': idempotentKey,
    };
  }
}
