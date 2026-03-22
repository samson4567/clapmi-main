import 'dart:convert';

import 'package:clapmi/features/wallet/domain/entities/token_entity.dart';

class ChainTokenModel extends ChainTokenEntity {
  const ChainTokenModel(
      {super.contract, super.decimal, super.name, super.symbol});

  factory ChainTokenModel.fromMap(Map<String, dynamic> map) {
    return ChainTokenModel(
      name: map['name'] != null ? map['name'] as String : null,
      contract: map['contract'] != null ? map['contract'] as String : null,
      symbol: map['symbol'] != null ? map['symbol'] as String : null,
      decimal: map['decimal'] != null ? map['decimal'] as String : null,
    );
  }

  factory ChainTokenModel.fromJson(String source) =>
      ChainTokenModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
