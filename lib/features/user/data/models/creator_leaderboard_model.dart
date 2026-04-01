import 'package:clapmi/features/user/domain/entities/user_entity.dart';

/// Represents a creator's leaderboard ranking
class CreatorRankingModel {
  final String creatorPid;
  final String creatorName;
  final String creatorUsername;
  final String creatorImage;
  final int progressPercentage;
  final CreatorLevel level;
  final String score;
  final int? leaderboardRank;
  final String? lastEvaluatedAt;
  final String promotionSource;
  final CreatorProgress progress;

  CreatorRankingModel({
    required this.creatorPid,
    required this.creatorName,
    required this.creatorUsername,
    required this.creatorImage,
    required this.progressPercentage,
    required this.level,
    required this.score,
    this.leaderboardRank,
    this.lastEvaluatedAt,
    required this.promotionSource,
    required this.progress,
  });

  factory CreatorRankingModel.fromJson(Map<String, dynamic> json) {
    // Check multiple possible field names for the avatar image
    String imageUrl = json['creator_image'] ??
        json['avatar'] ??
        json['profile_image'] ??
        json['avatar_url'] ??
        '';
    return CreatorRankingModel(
      creatorPid: json['creator_pid'] ?? '',
      creatorName: json['creator_name'] ?? '',
      creatorUsername: json['creator_username'] ?? '',
      creatorImage: imageUrl,
      progressPercentage: json['progress_percentage'] ?? 0,
      level: CreatorLevel.fromJson(json['level'] ?? {}),
      score: json['score'] ?? '0',
      leaderboardRank: json['leaderboard_rank'],
      lastEvaluatedAt: json['last_evaluated_at'],
      promotionSource: json['promotion_source'] ?? '',
      progress: CreatorProgress.fromJson(json['progress'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'creator_pid': creatorPid,
      'creator_name': creatorName,
      'creator_username': creatorUsername,
      'creator_image': creatorImage,
      'progress_percentage': progressPercentage,
      'level': level.toJson(),
      'score': score,
      'leaderboard_rank': leaderboardRank,
      'last_evaluated_at': lastEvaluatedAt,
      'promotion_source': promotionSource,
      'progress': progress.toJson(),
    };
  }
}

/// Represents the creator's level information
class CreatorLevel {
  final String name;
  final String badge;
  final List<LevelBenefit> benefits;
  final int comboShare;
  final int livestreamShare;

  CreatorLevel({
    required this.name,
    required this.badge,
    required this.benefits,
    required this.comboShare,
    required this.livestreamShare,
  });

  factory CreatorLevel.fromJson(Map<String, dynamic> json) {
    return CreatorLevel(
      name: json['name'] ?? '',
      badge: json['badge'] ?? '',
      benefits: (json['benefits'] as List<dynamic>?)
              ?.map((e) => LevelBenefit.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      comboShare: json['combo-share'] ?? 0,
      livestreamShare: json['livestream-share'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'badge': badge,
      'benefits': benefits.map((e) => e.toJson()).toList(),
      'combo-share': comboShare,
      'livestream-share': livestreamShare,
    };
  }
}

/// Represents a level benefit
class LevelBenefit {
  final String label;
  final bool isActive;

  LevelBenefit({
    required this.label,
    required this.isActive,
  });

  factory LevelBenefit.fromJson(Map<String, dynamic> json) {
    return LevelBenefit(
      label: json['label'] ?? '',
      isActive: json['is_active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'is_active': isActive,
    };
  }
}

/// Represents the creator's progress metrics
class CreatorProgress {
  final int? totalStreams30d;
  final double? avgViewers30d;
  final double? engagementRate30d;
  final double? revenue30d;
  final int? returningViewers30d;
  final double? winRate;
  final int? totalWins;
  final int? totalLivestream;

  CreatorProgress({
    this.totalStreams30d,
    this.avgViewers30d,
    this.engagementRate30d,
    this.revenue30d,
    this.returningViewers30d,
    this.winRate,
    this.totalWins,
    this.totalLivestream,
  });

  factory CreatorProgress.fromJson(Map<String, dynamic> json) {
    return CreatorProgress(
      totalStreams30d: json['total_streams_30d'],
      avgViewers30d: _parseDouble(json['avg_viewers_30d']),
      engagementRate30d: _parseDouble(json['engagement_rate_30d']),
      revenue30d: _parseDouble(json['revenue_30d']),
      returningViewers30d: json['returning_viewers_30d'],
      winRate: _parseDouble(json['win_rate']),
      totalWins: json['total_wins'],
      totalLivestream: json['total_livestream'],
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'total_streams_30d': totalStreams30d,
      'avg_viewers_30d': avgViewers30d,
      'engagement_rate_30d': engagementRate30d,
      'revenue_30d': revenue30d,
      'returning_viewers_30d': returningViewers30d,
      'win_rate': winRate,
      'total_wins': totalWins,
      'total_livestream': totalLivestream,
    };
  }
}

/// Represents the full API response for creator leaderboard
class CreatorLeaderboardResponse {
  final String message;
  final bool success;
  final CreatorLeaderboardData data;

  CreatorLeaderboardResponse({
    required this.message,
    required this.success,
    required this.data,
  });

  factory CreatorLeaderboardResponse.fromJson(Map<String, dynamic> json) {
    return CreatorLeaderboardResponse(
      message: json['message'] ?? '',
      success: json['success'] ?? false,
      data: CreatorLeaderboardData.fromJson(json['data'] ?? {}),
    );
  }
}

/// Represents the data portion of the API response
class CreatorLeaderboardData {
  final List<CreatorRankingModel> rankings;
  final PaginationInfo pagination;

  CreatorLeaderboardData({
    required this.rankings,
    required this.pagination,
  });

  factory CreatorLeaderboardData.fromJson(Map<String, dynamic> json) {
    return CreatorLeaderboardData(
      rankings: (json['rankings'] as List<dynamic>?)
              ?.map((e) =>
                  CreatorRankingModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: PaginationInfo.fromJson(json['pagination'] ?? {}),
    );
  }
}

/// Represents pagination information
class PaginationInfo {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  PaginationInfo({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      currentPage: json['current_page'] ?? 1,
      perPage: json['per_page'] ?? 30,
      total: json['total'] ?? 0,
      lastPage: json['last_page'] ?? 1,
    );
  }
}

/// Response model for creator levels API
class CreatorLevelsResponse {
  final String message;
  final bool success;
  final CreatorLevelsData data;

  CreatorLevelsResponse({
    required this.message,
    required this.success,
    required this.data,
  });

  factory CreatorLevelsResponse.fromJson(Map<String, dynamic> json) {
    return CreatorLevelsResponse(
      message: json['message'] ?? '',
      success: json['success'] ?? false,
      data: CreatorLevelsData.fromJson(json['data'] ?? {}),
    );
  }
}

/// Data container for creator levels
class CreatorLevelsData {
  final List<CreatorLevelModel> creatorLevels;

  CreatorLevelsData({required this.creatorLevels});

  factory CreatorLevelsData.fromJson(Map<String, dynamic> json) {
    return CreatorLevelsData(
      creatorLevels: (json['creator_levels'] as List<dynamic>?)
              ?.map(
                  (e) => CreatorLevelModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

/// Model for a single creator level
class CreatorLevelModel {
  final String uuid;
  final String name;
  final int position;
  final int minStreams;
  final int minAvgViewers;
  final String minEngagementRate;
  final int minRevenue;
  final int minReturningViewers;
  final int rollingWindowDays;
  final LevelWeights weights;
  final int payoutCreatorShare;
  final int payoutFansShare;
  final int payoutClapmiShare;
  final bool isInviteOnly;
  final int version;
  final String? createdAt;
  final String? updatedAt;
  final int subscriptionAmount;
  final String? badge;
  final int livestreamShare;
  final DateTime? subscriptionEndsAt;

  CreatorLevelModel({
    required this.uuid,
    required this.name,
    required this.position,
    required this.minStreams,
    required this.minAvgViewers,
    required this.minEngagementRate,
    required this.minRevenue,
    required this.minReturningViewers,
    required this.rollingWindowDays,
    required this.weights,
    required this.payoutCreatorShare,
    required this.payoutFansShare,
    required this.payoutClapmiShare,
    required this.isInviteOnly,
    required this.version,
    this.createdAt,
    this.updatedAt,
    required this.subscriptionAmount,
    this.badge,
    required this.livestreamShare,
    this.subscriptionEndsAt,
  });

  factory CreatorLevelModel.fromJson(Map<String, dynamic> json) {
    return CreatorLevelModel(
      uuid: json['uuid'] ?? '',
      name: json['name'] ?? '',
      position: json['position'] ?? 0,
      minStreams: json['min_streams'] ?? 0,
      minAvgViewers: json['min_avg_viewers'] ?? 0,
      minEngagementRate: json['min_engagement_rate'] ?? '0',
      minRevenue: json['min_revenue'] ?? 0,
      minReturningViewers: json['min_returning_viewers'] ?? 0,
      rollingWindowDays: json['rolling_window_days'] ?? 30,
      weights: LevelWeights.fromJson(json['weights'] ?? {}),
      payoutCreatorShare: json['payout_creator_share'] ?? 0,
      payoutFansShare: json['payout_fans_share'] ?? 0,
      payoutClapmiShare: json['payout_clapmi_share'] ?? 0,
      isInviteOnly: json['is_invite_only'] ?? false,
      version: json['version'] ?? 1,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      subscriptionAmount: json['subscription_amount'] ?? 0,
      badge: json['badge'],
      livestreamShare: json['livestream_share'] ?? 0,
      subscriptionEndsAt: json['subscription_ends_at'] != null
          ? DateTime.tryParse(json['subscription_ends_at'].toString())
          : null,
    );
  }
}

/// Weights for level calculation
class LevelWeights {
  final String consistency;
  final String audience;
  final String engagement;
  final String revenue;

  LevelWeights({
    required this.consistency,
    required this.audience,
    required this.engagement,
    required this.revenue,
  });

  factory LevelWeights.fromJson(Map<String, dynamic> json) {
    return LevelWeights(
      consistency: json['consistency']?.toString() ?? '0',
      audience: json['audience']?.toString() ?? '0',
      engagement: json['engagement']?.toString() ?? '0',
      revenue: json['revenue']?.toString() ?? '0',
    );
  }
}
