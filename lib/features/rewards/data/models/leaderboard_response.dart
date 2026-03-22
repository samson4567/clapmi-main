import 'dart:convert';

import 'package:clapmi/features/rewards/data/models/leaderboard_item.dart';
import 'package:clapmi/features/rewards/data/models/leaderboard_link.dart';

/// Represents the response from the get leaderboards endpoint.
class LeaderboardResponse {
  final int? code;
  final String message;
  final LeaderboardData data;

  LeaderboardResponse({
    this.code,
    required this.message,
    required this.data,
  });

  factory LeaderboardResponse.fromMap(Map<String, dynamic> map) {
    return LeaderboardResponse(
      code: map['code']?.toInt(),
      message: map['message'] ?? '',
      data: LeaderboardData.fromMap(map['data'] as Map<String, dynamic>),
    );
  }

  factory LeaderboardResponse.fromJson(String source) =>
      LeaderboardResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'message': message,
      'data': data.toMap(),
    };
  }

  String toJson() => json.encode(toMap());
}

/// Represents the data structure within the leaderboard response, including pagination.
class LeaderboardData {
  final int currentPage;
  final List<LeaderboardItem> data;
  final String? firstPageUrl;
  final int? from;
  final int lastPage;
  final String? lastPageUrl;
  final List<LeaderboardLink> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int? to;
  final int total;

  LeaderboardData({
    required this.currentPage,
    required this.data,
    this.firstPageUrl,
    this.from,
    required this.lastPage,
    this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    this.to,
    required this.total,
  });

  factory LeaderboardData.fromMap(Map<String, dynamic> map) {
    return LeaderboardData(
      currentPage: map['current_page']?.toInt() ?? 0,
      data: List<LeaderboardItem>.from(
        (map['data'] as List<dynamic>? ?? []).map<LeaderboardItem>(
          (x) => LeaderboardItem.fromMap(x as Map<String, dynamic>),
        ),
      ),
      firstPageUrl: map['first_page_url'],
      from: map['from']?.toInt(),
      lastPage: map['last_page']?.toInt() ?? 0,
      lastPageUrl: map['last_page_url'],
      links: List<LeaderboardLink>.from(
        (map['links'] as List<dynamic>? ?? []).map<LeaderboardLink>(
          (x) => LeaderboardLink.fromMap(x as Map<String, dynamic>),
        ),
      ),
      nextPageUrl: map['next_page_url'],
      path: map['path'] ?? '',
      perPage: map['per_page']?.toInt() ?? 0,
      prevPageUrl: map['prev_page_url'],
      to: map['to']?.toInt(),
      total: map['total']?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'current_page': currentPage,
      'data': data.map((x) => x.toMap()).toList(),
      'first_page_url': firstPageUrl,
      'from': from,
      'last_page': lastPage,
      'last_page_url': lastPageUrl,
      'links': links.map((x) => x.toMap()).toList(),
      'next_page_url': nextPageUrl,
      'path': path,
      'per_page': perPage,
      'prev_page_url': prevPageUrl,
      'to': to,
      'total': total,
    };
  }

  String toJson() => json.encode(toMap());
}
