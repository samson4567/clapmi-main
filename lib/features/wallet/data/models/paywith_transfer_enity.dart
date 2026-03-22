import 'package:clapmi/features/wallet/domain/entities/paywith_transfer_model.dart';

class GetQuoteRequestModelDeposit extends GetQuoteRequestFiat {
  const GetQuoteRequestModelDeposit({
    super.id,
    super.amount,
    super.amountNGN,
    super.accountName,
    super.accountNumber,
    super.bank,
  });

  factory GetQuoteRequestModelDeposit.fromMap(
    Map<String, dynamic> map, {
    num? originalAmount,
  }) {
    final accountDetails = map['accountDetails'];
    return GetQuoteRequestModelDeposit(
      id: map['id']?.toString(),
      amountNGN: map['amount_ngn']?.toString(),
      accountName: accountDetails['accountName']?.toString(),
      accountNumber: accountDetails['accountNumber']?.toString(),
      bank: accountDetails['bank']?.toString(),
    );
  }

  @override
  String toString() {
    return 'GetQuoteRequestModelDeposit(id: $id, amount: $amount, amountNGN: $amountNGN, '
        'accountName: $accountName, accountNumber: $accountNumber, bank: $bank)';
  }
}
