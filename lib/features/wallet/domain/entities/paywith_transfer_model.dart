import 'package:equatable/equatable.dart';

class GetQuoteRequestFiat extends Equatable {
  final String? amount;
  final String? bank;
  final String? accountName;
  final String? accountNumber;
  final String? id;
  final String? amountNGN;

  const GetQuoteRequestFiat({
    this.amount,
    this.bank,
    this.accountName,
    this.accountNumber,
    this.id,
    this.amountNGN,
  });

  @override
  List<Object?> get props =>
      [amount, bank, accountName, accountNumber, id, amountNGN];

  Map<String, dynamic> toMap() {
    return {
      // If amount is null, fallback to amountNGN as string
      'amount': amount,
      'bank': bank,
      'accountName': accountName,
      'accountNumber': accountNumber,
      'amount_ngn': amountNGN,
    };
  }
}
