import 'dart:convert';

/// Represents the details structure within the reward object in the leaderboard item.
class LeaderboardRewardDetails {
  final String? title;

  LeaderboardRewardDetails({this.title});

  factory LeaderboardRewardDetails.fromMap(Map<String, dynamic> map) {
    return LeaderboardRewardDetails(
      title: map['title'],
    );
  }

  factory LeaderboardRewardDetails.fromJson(String source) =>
      LeaderboardRewardDetails.fromMap(
          json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return {
      'title': title,
    };
  }

  String toJson() => json.encode(toMap());
}
