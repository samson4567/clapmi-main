import 'package:clapmi/features/rewards/data/models/reward_history.dart';
import 'package:equatable/equatable.dart';

abstract class RewardEvent extends Equatable {
  const RewardEvent();

  @override
  List<Object?> get props => [];
}

final class ClaimDailyRewardEvent extends RewardEvent {
  const ClaimDailyRewardEvent();
}

class RewardHistoryEvent extends RewardEvent {
  final RewardHistoryModel? rewardmodel;

  const RewardHistoryEvent({this.rewardmodel});

  @override
  List<Object?> get props => [rewardmodel];
}

final class RewardBalanceEvent extends RewardEvent {
  const RewardBalanceEvent();
}

final class WithdrawalEvent extends RewardEvent {
  const WithdrawalEvent();
}

final class ClaimReferralRewardEvent extends RewardEvent {
  const ClaimReferralRewardEvent();
}

final class ReferrerQrCodeEvent extends RewardEvent {
  const ReferrerQrCodeEvent();
}

final class LeaderboardEvent extends RewardEvent {
  const LeaderboardEvent({this.pageNumber = 1});
  final int pageNumber;

  @override
  List<Object?> get props => [pageNumber];
}

/// Event to fetch the status of reward activities.
class GetRewardStatusEvent extends RewardEvent {}

class GetReferralCountEvent extends RewardEvent {}
