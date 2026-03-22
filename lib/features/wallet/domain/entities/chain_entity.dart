// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:clapmi/features/wallet/domain/entities/token_entity.dart';

class ChainEntity extends Equatable {
  final String? name;
  final String? rpcUrl;
  final String? chainId;
  final String? symbol;
  final double? balance;
  final List<ChainTokenEntity>? tokens;
  const ChainEntity({
    this.name,
    this.rpcUrl,
    this.chainId,
    this.symbol,
    this.balance,
    required this.tokens,
  });

  @override
  List<Object?> get props => [name, rpcUrl, chainId, symbol, balance, tokens];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'rpcUrl': rpcUrl,
      'chainId': chainId,
      'symbol': symbol,
      'balance': balance,
      'tokens': tokens?.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());


}
