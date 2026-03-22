import 'package:equatable/equatable.dart';

class TransactionHistoryEntity extends Equatable {
  final String transaction;
  final String operation;
  final String currency;
  final String amount;
  final String date;
  final String status;
  final bool recent;
  final int perPage;
// from detail endpoint
  final String? orderId;
  final String? time;
  final String? to;
  final String? from;

  // order_id

  const TransactionHistoryEntity({
    required this.transaction,
    required this.operation,
    required this.currency,
    required this.amount,
    required this.date,
    required this.status,
    required this.recent,
    required this.perPage,
    required this.from,
    required this.to,
    required this.orderId,
    required this.time,
  });

  @override
  List<Object?> get props => [
        transaction,
        operation,
        currency,
        amount,
        date,
        status,
        recent,
        perPage,
      ];
}
