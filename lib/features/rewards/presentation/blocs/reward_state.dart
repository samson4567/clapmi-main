import 'package:clapmi/features/rewards/data/models/claim_referral_reward_response.dart';
import 'package:clapmi/features/rewards/data/models/leaderboard_response.dart';
import 'package:clapmi/features/rewards/data/models/reward_balance_response.dart';
import 'package:clapmi/features/rewards/data/models/withdrawal_response.dart';
import 'package:clapmi/features/rewards/domain/repositories/entity.dart';
import 'package:equatable/equatable.dart';

abstract class RewardState extends Equatable {
  const RewardState();

  @override
  List<Object?> get props => [];
}

final class RewardLoadedState extends RewardState {
  final String balance;
  const RewardLoadedState({required this.balance});

  @override
  List<Object?> get props => [balance];
}

final class RewardInitialState extends RewardState {}

final class ClaimDailyRewardLoadingState extends RewardState {}

final class ClaimDailyRewardSuccessState extends RewardState {
  final String nextClaim;
  const ClaimDailyRewardSuccessState({required this.nextClaim});

  @override
  List<Object?> get props => [nextClaim];
}

final class ClaimDailyRewardErrorState extends RewardState {
  final String errorMessage;
  const ClaimDailyRewardErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

// States for fetching reward status
final class RewardStatusLoadingState extends RewardState {}

final class RewardStatusLoadedState extends RewardState {
  final List<String> incompleteTasks;
  const RewardStatusLoadedState({required this.incompleteTasks});

  @override
  List<Object?> get props => [incompleteTasks];
}

final class RewardStatusErrorState extends RewardState {
  final String errorMessage;
  const RewardStatusErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

final class RewardHistoryLoadingState extends RewardState {}

final class RewardHistorySuccessState extends RewardState {
  final List<RewardHistoryEntity> rewardModel;
  const RewardHistorySuccessState({required this.rewardModel});

  @override
  List<Object?> get props => [rewardModel];
}

final class RewardHistoryErrorState extends RewardState {
  final String errorMessage;
  const RewardHistoryErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

final class RewardBalanceLoadingState extends RewardState {}

final class RewardBalanceSuccessState extends RewardState {
  final RewardBalanceResponse response;
  const RewardBalanceSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

final class RewardBalanceErrorState extends RewardState {
  final String errorMessage;
  const RewardBalanceErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

final class WithdrawalLoadingState extends RewardState {}

final class WithdrawalSuccessState extends RewardState {
  final WithdrawalResponse response;
  const WithdrawalSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

final class WithdrawalErrorState extends RewardState {
  final String errorMessage;
  const WithdrawalErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

final class ClaimReferralRewardLoadingState extends RewardState {}

final class ClaimReferralRewardSuccessState extends RewardState {
  final ClaimReferralRewardResponse response;
  const ClaimReferralRewardSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

final class ClaimReferralRewardErrorState extends RewardState {
  final String errorMessage;
  const ClaimReferralRewardErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

final class ReferrerQrCodeLoadingState extends RewardState {}

final class ReferrerQrCodeSuccessState extends RewardState {
  final String qrCode;
  const ReferrerQrCodeSuccessState({required this.qrCode});

  @override
  List<Object?> get props => [qrCode];
}

final class ReferrerQrCodeErrorState extends RewardState {
  final String errorMessage;
  const ReferrerQrCodeErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

final class LeaderboardLoadingState extends RewardState {}

final class LeaderboardSuccessState extends RewardState {
  final LeaderboardResponse response;
  const LeaderboardSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

final class LeaderboardErrorState extends RewardState {
  final String errorMessage;
  const LeaderboardErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class ReferralCountState extends RewardState {
  final int referralCount;
  const ReferralCountState({required this.referralCount});
  @override
  List<Object?> get props => [referralCount];
}
