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
  final bool refreshInBackground;
  final bool forceRefresh;

  const RewardHistoryEvent({
    this.rewardmodel,
    this.refreshInBackground = false,
    this.forceRefresh = false,
  });

  @override
  List<Object?> get props => [rewardmodel, refreshInBackground, forceRefresh];
}

final class RewardBalanceEvent extends RewardEvent {
  final bool refreshInBackground;
  final bool forceRefresh;

  const RewardBalanceEvent({
    this.refreshInBackground = false,
    this.forceRefresh = false,
  });

  @override
  List<Object?> get props => [refreshInBackground, forceRefresh];
}

final class WithdrawalEvent extends RewardEvent {
  const WithdrawalEvent();
}

final class ClaimReferralRewardEvent extends RewardEvent {
  const ClaimReferralRewardEvent();
}

final class ReferrerQrCodeEvent extends RewardEvent {
  final bool refreshInBackground;
  final bool forceRefresh;

  const ReferrerQrCodeEvent({
    this.refreshInBackground = false,
    this.forceRefresh = false,
  });

  @override
  List<Object?> get props => [refreshInBackground, forceRefresh];
}

final class LeaderboardEvent extends RewardEvent {
  final bool refreshInBackground;
  final bool forceRefresh;

  const LeaderboardEvent({
    this.pageNumber = 1,
    this.refreshInBackground = false,
    this.forceRefresh = false,
  });
  final int pageNumber;

  @override
  List<Object?> get props => [pageNumber, refreshInBackground, forceRefresh];
}

/// Event to fetch the status of reward activities.
class GetRewardStatusEvent extends RewardEvent {
  final bool refreshInBackground;
  final bool forceRefresh;

  const GetRewardStatusEvent({
    this.refreshInBackground = false,
    this.forceRefresh = false,
  });

  @override
  List<Object?> get props => [refreshInBackground, forceRefresh];
}

class GetReferralCountEvent extends RewardEvent {
  final bool refreshInBackground;
  final bool forceRefresh;

  const GetReferralCountEvent({
    this.refreshInBackground = false,
    this.forceRefresh = false,
  });

  @override
  List<Object?> get props => [refreshInBackground, forceRefresh];
}
