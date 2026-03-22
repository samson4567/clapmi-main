import 'dart:convert';
import 'package:clapmi/features/wallet/domain/entities/bank_details.dart';

class BankDetailsModel extends BankDetails {
  const BankDetailsModel(
      {super.accountName, super.accountNumber, super.bankName, super.logo});

  factory BankDetailsModel.fromMap(Map<String, dynamic> map) {
    return BankDetailsModel(
      accountNumber:
          map['accountNumber'] != null ? map['accountNumber'] as String : null,
      accountName:
          map['accountName'] != null ? map['accountName'] as String : null,
      logo: map['logo'] != null ? map['logo'] as String : null,
      bankName: map['bankName'] != null ? map['bankName'] as String : null,
    );
  }
  factory BankDetailsModel.fromJson(String source) =>
      BankDetailsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class BankDataModel extends BankDataEntity {
  const BankDataModel({super.code, super.name});

  factory BankDataModel.fromMap(Map<String, dynamic> map) {
    return BankDataModel(
      name: map['name'] != null ? map['name'] as String : null,
      code: map['code'] != null ? map['code'] as String : null,
    );
  }

  factory BankDataModel.fromJson(String source) =>
      BankDataModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class AddBankRequestModel extends AddBankRequest {
  const AddBankRequestModel({
    required super.accountName,
    required super.accountNumber,
    required super.bankCode,
    required super.bankName,
    super.uuid,
  });

  factory AddBankRequestModel.fromMap(Map<String, dynamic> map) {
    return AddBankRequestModel(
      bankName: map['bank_name'] as String,
      accountNumber: map['account_number'] as String,
      accountName: map['account_name'] as String,
      bankCode: map['bank_code'] as String,
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
    );
  }

  factory AddBankRequestModel.fromJson(String source) =>
      AddBankRequestModel.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bank_name': bankName,
      'account_number': accountNumber,
      'account_name': accountName,
      'bank_code': bankCode,
    };
  }
}

class GetQuoteRequestModel extends GetQuoteRequest {
  const GetQuoteRequestModel({super.id, super.transactionFee, super.amountNGN});
  factory GetQuoteRequestModel.fromMap(Map<String, dynamic> map) {
    return GetQuoteRequestModel(
      id: map['id'] != null ? map['id'] as String : null,
      amountNGN: map['amount_ngn'] != null ? map['amount_ngn'] as num : null,
      transactionFee:
          map['transaction_fee'] != null ? map['transaction_fee'] as num : null,
    );
  }
}
