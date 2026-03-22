import 'dart:convert';

/// Represents a single item in the reward history list.
class RewardHistoryItem {
  final int id;
  final int rewardId;
  final int userId;
  final int clapPoints;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;

  RewardHistoryItem({
    required this.id,
    required this.rewardId,
    required this.userId,
    required this.clapPoints,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RewardHistoryItem.fromMap(Map<String, dynamic> map) {
    return RewardHistoryItem(
      id: map['id']?.toInt() ?? 0,
      rewardId: map['reward_id']?.toInt() ?? 0,
      userId: map['user_id']?.toInt() ?? 0,
      clapPoints: map['clap_points']?.toInt() ?? 0,
      type: map['type'] ?? '',
      createdAt: DateTime.parse(map['created_at'] ?? ''),
      updatedAt: DateTime.parse(map['updated_at'] ?? ''),
    );
  }

  factory RewardHistoryItem.fromJson(String source) =>
      RewardHistoryItem.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reward_id': rewardId,
      'user_id': userId,
      'clap_points': clapPoints,
      'type': type,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());
}
