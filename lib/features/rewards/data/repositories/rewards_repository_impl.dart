import 'package:clapmi/core/error/exception.dart';
import 'package:clapmi/core/error/failure.dart';
import 'package:clapmi/core/mapper/failure_mapper.dart';
import 'package:clapmi/features/rewards/data/datasources/rewards_remote_data_source.dart';
import 'package:clapmi/features/rewards/data/models/claim_daily_reward_response.dart';
import 'package:clapmi/features/rewards/data/models/claim_referral_reward_response.dart';
import 'package:clapmi/features/rewards/data/models/leaderboard_response.dart';
import 'package:clapmi/features/rewards/data/models/reward_balance_response.dart';
import 'package:clapmi/features/rewards/data/models/reward_history.dart';
import 'package:clapmi/features/rewards/data/models/reward_history_response.dart';
import 'package:clapmi/features/rewards/data/models/reward_status_response.dart';
import 'package:clapmi/features/rewards/data/models/withdrawal_response.dart';
import 'package:clapmi/features/rewards/domain/repositories/entity.dart';
import 'package:clapmi/features/rewards/domain/repositories/rewards_repository.dart';
import 'package:dartz/dartz.dart';

/// Implementation of the [RewardsRepository].
/// Handles data fetching from the remote source and error mapping.
class RewardsRepositoryImpl implements RewardsRepository {
  final RewardsRemoteDataSource remoteDataSource;

  RewardsRepositoryImpl({required this.remoteDataSource});

  /// Helper function to execute API calls and handle errors.
  Future<Either<Failure, T>> _handleRequest<T>(
      Future<T> Function() request) async {
    try {
      final result = await request();
      // Specific check for responses that indicate failure via 'success' flag
      if (result is ClaimDailyRewardResponse && !result.success) {
        return Left(ServerFailure(message: result.message));
      }
      if (result is RewardHistoryResponse && !result.success) {
        return Left(ServerFailure(message: result.message));
      }
      if (result is RewardBalanceResponse && !result.success) {
        return Left(ServerFailure(message: result.message));
      }
      if (result is WithdrawalResponse && !result.success) {
        return Left(ServerFailure(message: result.message));
      }
      if (result is ClaimReferralRewardResponse && !result.success) {
        return Left(ServerFailure(message: result.message));
      }
      if (result is String && result.isEmpty) {
        return Left(ServerFailure(message: result));
      }
      if (result is LeaderboardResponse && result.code != 200) {
        return Left(ServerFailure(message: result.message));
      }
      // Add other similar checks if necessary for other response types
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      // Catch-all for unexpected errors
      return Left(ServerFailure(
          message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> claimDailyReward() async {
    return _handleRequest(() => remoteDataSource.claimDailyReward());
  }

  // @override
  // Future<Either<Failure, RewardHistoryResponse>> getRewardHistory() async {
  //   return _handleRequest(() => remoteDataSource.getRewardHistory());
  // }

  @override
  Future<Either<Failure, List<RewardHistoryEntity>>> getRewardHistory({
    RewardHistoryModel? rewardModel,
  }) async {
    try {
      final result =
          await remoteDataSource.getRewardHistory(rewardModel: rewardModel);

      // Convert List<RewardHistoryModel> → List<RewardHistoryEntity>
      final entities = result
          .map((model) => RewardHistoryEntity(
                id: model.id,
                rewardId: model.rewardId,
                userId: model.userId,
                clapPoints: model.clapPoints,
                type: model.type,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt,
              ))
          .toList();

      return right(entities);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, RewardBalanceResponse>> getRewardBalance() async {
    return _handleRequest(() => remoteDataSource.getRewardBalance());
  }

  @override
  Future<Either<Failure, WithdrawalResponse>> withdraw10kLimit() async {
    return _handleRequest(() => remoteDataSource.withdraw10kLimit());
  }

  @override
  Future<Either<Failure, ClaimReferralRewardResponse>>
      claimReferralReward() async {
    return _handleRequest(() => remoteDataSource.claimReferralReward());
  }

  @override
  Future<Either<Failure, String>> getReferrerQrCode() async {
    try {
      final response = await remoteDataSource.getReferrerQrCode();
      return right(response);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, LeaderboardResponse>> getLeaderboards(
      {int page = 1}) async {
    return _handleRequest(() => remoteDataSource.getLeaderboards(page: page));
  }

  @override
  Future<Either<Failure, WithdrawalResponse>> withdrawReward(
      Map<String, dynamic> data) async {
    try {
      final response = await remoteDataSource.withdrawReward(data);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnKnownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RewardStatusResponse>> getRewardStatus() async {
    try {
      final response = await remoteDataSource.getRewardStatus();
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnKnownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getReferralCount() async {
    try {
      final response = await remoteDataSource.getReferralCount();
      return Right(response);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }
}
