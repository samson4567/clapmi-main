import 'package:clapmi/features/rewards/domain/repositories/entity.dart';

class RewardHistoryModel extends RewardHistoryEntity {
  const RewardHistoryModel({
    super.id,
    super.rewardId,
    super.userId,
    super.clapPoints,
    super.type,
    super.createdAt,
    super.updatedAt,
  });

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }

  factory RewardHistoryModel.fromJson(Map<String, dynamic> json) {
    return RewardHistoryModel(
      id: _toInt(json['id']),
      rewardId: _toInt(json['reward_id']),
      userId: _toInt(json['user_id']),
      clapPoints: _toInt(json['clap_points']),
      type: json['type']?.toString(),
      createdAt: _toDate(json['created_at']),
      updatedAt: _toDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reward_id': rewardId,
      'user_id': userId,
      'clap_points': clapPoints,
      'type': type,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory RewardHistoryModel.fromEntity(RewardHistoryEntity entity) {
    return RewardHistoryModel(
      id: entity.id,
      rewardId: entity.rewardId,
      userId: entity.userId,
      clapPoints: entity.clapPoints,
      type: entity.type,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
