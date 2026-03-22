// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

class ChainTokenEntity extends Equatable {
  final String? name;
  final String? contract;
  final String? symbol;
  final String? decimal;
  const ChainTokenEntity({
    this.name,
    this.contract,
    this.symbol,
    this.decimal,
  });

  @override
  List<Object?> get props => [name, contract, symbol, decimal];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'contract': contract,
      'symbol': symbol,
      'decimal': decimal,
    };
  }
}
