import 'dart:convert';

import 'package:clapmi/features/rewards/data/models/leaderboard_reward_details.dart';

/// Represents the reward structure within a leaderboard item.
class LeaderboardReward {
  final int? id;
  final int? clapPoints;
  final int? userId;
  final LeaderboardRewardDetails? details;

  LeaderboardReward({
    this.id,
    this.clapPoints,
    this.userId,
    this.details,
  });

  factory LeaderboardReward.fromMap(Map<String, dynamic> map) {
    return LeaderboardReward(
      id: map['id']?.toInt(),
      // Handle potential String value for clap_points
      clapPoints: map['clap_points'] is String
          ? int.tryParse(map['clap_points'])
          : map['clap_points']?.toInt(),
      userId: map['user_id']?.toInt(),
      details: map['details'] != null
          ? LeaderboardRewardDetails.fromMap(
              map['details'] as Map<String, dynamic>)
          : null,
    );
  }

  factory LeaderboardReward.fromJson(String source) =>
      LeaderboardReward.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clap_points': clapPoints,
      'user_id': userId,
      'details': details?.toMap(),
    };
  }

  String toJson() => json.encode(toMap());
}
