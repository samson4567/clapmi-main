import 'dart:convert';

import 'package:clapmi/features/rewards/data/models/reward_history_item.dart';

/// Represents the response from the get reward history endpoint.
class RewardHistoryResponse {
  final int code;
  final bool success;
  final String message;
  final List<RewardHistoryItem> data;

  RewardHistoryResponse({
    required this.code,
    required this.success,
    required this.message,
    required this.data,
  });

  factory RewardHistoryResponse.fromMap(Map<String, dynamic> map) {
    return RewardHistoryResponse(
      code: map['code']?.toInt() ?? 0,
      success: map['success'] ?? false,
      message: map['message'] ?? '',
      data: List<RewardHistoryItem>.from(
        (map['data'] as List<dynamic>? ?? []).map<RewardHistoryItem>(
          (x) => RewardHistoryItem.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  factory RewardHistoryResponse.fromJson(String source) =>
      RewardHistoryResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'success': success,
      'message': message,
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());
}
