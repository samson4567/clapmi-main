import 'package:clapmi/features/wallet/domain/entities/transaction_entity.dart';

class TransactionHistoryModel extends TransactionHistoryEntity {
  const TransactionHistoryModel({
    required super.transaction,
    required super.operation,
    required super.currency,
    required super.amount,
    required super.date,
    required super.status,
    required super.recent,
    required super.perPage,
    // another
    super.from,
    super.to,
    super.time,
    super.orderId,
  });

  factory TransactionHistoryModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    return TransactionHistoryModel(
      transaction: data['transaction'] ?? '',
      operation: json['operation'] ?? '',
      currency: json['currency'] ?? '',
      amount: json['amount'] ?? '',
      date: json['date'] ?? '',
      status: json['status'] ?? '',
      recent: json['recent'] ?? false,
      perPage: json['perPage'] ?? 15,
      // another
      from: json['from'] ?? '',
      orderId: json['uuid'] ?? '',
      time: json['time'] ?? '',
      to: json['to'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction': transaction,
      'operation': operation,
      'currency': currency,
      'amount': amount,
      'date': date,
      'status': status,
      'recent': recent,
      'perPage': perPage,
      "from": from,
      "to": to,
      "order_id": orderId,
      "time": time,
    };
  }
}
