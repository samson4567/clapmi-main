// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:clapmi/features/wallet/domain/entities/chain_entity.dart';

class CryptoWalletEntity extends Equatable {
  final String? name;
  final String? publicAddress;
  final String? mnemonic;
  final String? privateKey;
  final List<ChainEntity>? chains;
  const CryptoWalletEntity({
    this.name,
    this.publicAddress,
    this.mnemonic,
    this.privateKey,
    required this.chains,
  });

  @override
  List<Object?> get props =>
      [name, publicAddress, mnemonic, privateKey, chains];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'publicAddress': publicAddress,
      'mnemonic': mnemonic,
      'privateKey': privateKey,
      'chains': chains?.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());


}
