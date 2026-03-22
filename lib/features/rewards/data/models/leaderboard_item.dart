import 'dart:convert';

import 'package:clapmi/features/rewards/data/models/leaderboard_reward.dart';

/// Represents a single item in the leaderboard data list.
class LeaderboardItem {
  final int id;
  final String? name;
  final String? totalPoints; // Can be string or null
  final LeaderboardReward? reward;

  LeaderboardItem({
    required this.id,
    this.name,
    this.totalPoints,
    this.reward,
  });

  factory LeaderboardItem.fromMap(Map<String, dynamic> map) {
    return LeaderboardItem(
      id: map['id']?.toInt() ?? 0,
      name: map['name'],
      totalPoints: map['total_points'],
      reward: map['reward'] != null
          ? LeaderboardReward.fromMap(map['reward'] as Map<String, dynamic>)
          : null,
    );
  }

  factory LeaderboardItem.fromJson(String source) =>
      LeaderboardItem.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'total_points': totalPoints,
      'reward': reward?.toMap(),
    };
  }

  String toJson() => json.encode(toMap());
}
