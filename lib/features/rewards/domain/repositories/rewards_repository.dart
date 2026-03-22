import 'package:clapmi/core/error/failure.dart';
// Assuming models are used directly for simplicity, or create domain entities
import 'package:clapmi/features/rewards/data/models/claim_referral_reward_response.dart';
import 'package:clapmi/features/rewards/data/models/leaderboard_response.dart';
import 'package:clapmi/features/rewards/data/models/reward_balance_response.dart';
import 'package:clapmi/features/rewards/data/models/reward_history.dart';
import 'package:clapmi/features/rewards/data/models/reward_status_response.dart';
import 'package:clapmi/features/rewards/data/models/withdrawal_response.dart';
import 'package:clapmi/features/rewards/domain/repositories/entity.dart';
import 'package:dartz/dartz.dart';

/// Abstract repository defining the contract for rewards feature operations.
/// It uses Either to handle success (Right) and failure (Left).
abstract class RewardsRepository {
  /// Claims the daily reward.
  Future<Either<Failure, String>> claimDailyReward();

  /// Fetches the reward history.
  Future<Either<Failure, List<RewardHistoryEntity>>> getRewardHistory({
    RewardHistoryModel? rewardModel,
  });

  /// Fetches the reward balance.
  Future<Either<Failure, RewardBalanceResponse>> getRewardBalance();

  /// Initiates a 10k limit withdrawal.
  Future<Either<Failure, WithdrawalResponse>> withdraw10kLimit();

  /// Claims the reward for referring 5 people.
  Future<Either<Failure, ClaimReferralRewardResponse>> claimReferralReward();

  /// Fetches the referrer QR code.
  Future<Either<Failure, String>> getReferrerQrCode();

  /// Fetches the leaderboards, optionally specifying a page.
  Future<Either<Failure, LeaderboardResponse>> getLeaderboards({int page = 1});

  Future<Either<Failure, WithdrawalResponse>> withdrawReward(
      Map<String, dynamic> data);

  /// Fetches the status of reward activities.
  Future<Either<Failure, RewardStatusResponse>> getRewardStatus();

  Future<Either<Failure, int>> getReferralCount();
}
