import 'dart:convert';

import 'package:clapmi/features/wallet/data/models/chain_token_model.dart';
import 'package:clapmi/features/wallet/domain/entities/chain_entity.dart';

class ChainEntityModel extends ChainEntity {
  const ChainEntityModel(
      {super.balance,
      super.chainId,
      super.name,
      super.rpcUrl,
      super.symbol,
      super.tokens});

  factory ChainEntityModel.fromMap(Map<String, dynamic> map) {
    return ChainEntityModel(
      name: map['name'] != null ? map['name'] as String : null,
      rpcUrl: map['rpcUrl'] != null ? map['rpcUrl'] as String : null,
      chainId: map['chainId'] != null ? map['chainId'] as String : null,
      symbol: map['symbol'] != null ? map['symbol'] as String : null,
      balance: map['balance'] != null ? map['balance'] as double : null,
      tokens: map['tokens'] != null
          ? List<ChainTokenModel>.from(
              (map['tokens'] as List<dynamic>).map<ChainTokenModel?>(
                (x) => ChainTokenModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  factory ChainEntityModel.fromJson(String source) =>
      ChainEntityModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
