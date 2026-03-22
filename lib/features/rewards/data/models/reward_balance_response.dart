import 'dart:convert';

import 'package:clapmi/features/rewards/data/models/reward_balance_data.dart';

/// Represents the response from the get reward balance endpoint.
class RewardBalanceResponse {
  final int code;
  final bool success;
  final String message;
  final RewardBalanceData data;

  RewardBalanceResponse({
    required this.code,
    required this.success,
    required this.message,
    required this.data,
  });

  factory RewardBalanceResponse.fromMap(Map<String, dynamic> map) {
    return RewardBalanceResponse(
      code: map['code']?.toInt() ?? 0,
      success: map['success'] ?? false,
      message: map['message'] ?? '',
      data: RewardBalanceData.fromMap(map['data'] as Map<String, dynamic>),
    );
  }

  factory RewardBalanceResponse.fromJson(String source) =>
      RewardBalanceResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'success': success,
      'message': message,
      'data': data.toMap(),
    };
  }

  String toJson() => json.encode(toMap());
}
