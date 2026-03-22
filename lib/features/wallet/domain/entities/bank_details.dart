// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

class BankDetails extends Equatable {
  final String? accountNumber;
  final String? accountName;
  final String? logo;
  final String? bankName;
  final String? uuid;

  const BankDetails(
      {this.accountName,
      this.accountNumber,
      this.bankName,
      this.logo,
      this.uuid});
  @override
  List<Object?> get props => [accountName, accountNumber, bankName, logo];
}

class BankDataEntity extends Equatable {
  final String? name;
  final String? code;

  const BankDataEntity({this.name, this.code});
  @override
  List<Object?> get props => [name, code];
}

class AddBankRequest extends Equatable {
  final String bankName;
  final String accountNumber;
  final String accountName;
  final String bankCode;
  final String? uuid;

  const AddBankRequest({
    required this.bankName,
    required this.accountNumber,
    required this.accountName,
    required this.bankCode,
    this.uuid,
  });

  @override
  List<Object?> get props =>
      [bankName, accountNumber, accountName, bankCode, uuid];
}

class GetQuoteRequest extends Equatable {
  final String? amount;
  final String? bankCode;
  final String? accountName;
  final String? accountNumber;
  final String? id;
  final num? amountNGN;
  final num? transactionFee;

  const GetQuoteRequest({
    this.amount,
    this.bankCode,
    this.accountName,
    this.accountNumber,
    this.id,
    this.amountNGN,
    this.transactionFee,
  });
  @override
  List<Object?> get props => [
        amount,
        bankCode,
        accountName,
        accountNumber,
        id,
        amountNGN,
        transactionFee
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'amount': amount,
      'bankCode': bankCode,
      'accountName': accountName,
      'accountNumber': accountNumber,
    };
  }
}
