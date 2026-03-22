import 'dart:convert';

/// Represents the data structure within the reward balance response.
class RewardBalanceData {
  final int balance;
  final DateTime checkedAt;

  RewardBalanceData({
    required this.balance,
    required this.checkedAt,
  });

  factory RewardBalanceData.fromMap(Map<String, dynamic> map) {
    return RewardBalanceData(
      balance: map['balance']?.toInt() ?? 0,
      checkedAt: DateTime.parse(map['checked_at'] ?? ''),
    );
  }

  factory RewardBalanceData.fromJson(String source) =>
      RewardBalanceData.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return {
      'balance': balance,
      'checked_at': checkedAt.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());
}
