import 'dart:convert';

/// Represents a pagination link in the leaderboard response.
class LeaderboardLink {
  final String? url;
  final String label;
  final bool active;

  LeaderboardLink({
    this.url,
    required this.label,
    required this.active,
  });

  factory LeaderboardLink.fromMap(Map<String, dynamic> map) {
    return LeaderboardLink(
      url: map['url'],
      label: map['label'] ?? '',
      active: map['active'] ?? false,
    );
  }

  factory LeaderboardLink.fromJson(String source) =>
      LeaderboardLink.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'label': label,
      'active': active,
    };
  }

  String toJson() => json.encode(toMap());
}
