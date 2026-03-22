import 'package:equatable/equatable.dart';

class RewardHistoryEntity extends Equatable {
  final int? id;
  final int? rewardId;
  final int? userId;
  final int? clapPoints;
  final String? type;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const RewardHistoryEntity({
    this.id,
    this.rewardId,
    this.userId,
    this.clapPoints,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        rewardId,
        userId,
        clapPoints,
        type,
        createdAt,
        updatedAt,
      ];
}
