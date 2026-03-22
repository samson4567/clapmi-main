import 'dart:convert';

import 'package:clapmi/features/wallet/data/models/chain_entity_model.dart';
import 'package:clapmi/features/wallet/domain/entities/crypto_wallet_entity.dart';

class CryptoWalletModel extends CryptoWalletEntity {
  const CryptoWalletModel(
      {super.chains,
      super.mnemonic,
      super.name,
      super.privateKey,
      super.publicAddress});

  factory CryptoWalletModel.fromMap(Map<String, dynamic> map) {
    return CryptoWalletModel(
      name: map['name'] != null ? map['name'] as String : null,
      publicAddress:
          map['publicAddress'] != null ? map['publicAddress'] as String : null,
      mnemonic: map['mnemonic'] != null ? map['mnemonic'] as String : null,
      privateKey:
          map['privateKey'] != null ? map['privateKey'] as String : null,
      chains: map['chains'] != null
          ? List<ChainEntityModel>.from(
              (map['chains'] as List<dynamic>).map<ChainEntityModel?>(
                (x) => ChainEntityModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  factory CryptoWalletModel.fromJson(String source) =>
      CryptoWalletModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
