import 'package:clapmi/core/api/base_response.dart';
import 'package:clapmi/core/api/clapmi_network_client.dart';
import 'package:clapmi/core/constants/endpoint_constant.dart';
import 'package:clapmi/core/error/exception.dart';
import 'package:clapmi/features/rewards/data/models/claim_referral_reward_response.dart';
import 'package:clapmi/features/rewards/data/models/leaderboard_response.dart';
import 'package:clapmi/features/rewards/data/models/reward_balance_data.dart';
import 'package:clapmi/features/rewards/data/models/reward_balance_response.dart';
import 'package:clapmi/features/rewards/data/models/reward_history.dart';
import 'package:clapmi/features/rewards/data/models/reward_status_response.dart';
import 'package:clapmi/features/rewards/data/models/withdrawal_response.dart';
import 'package:dio/dio.dart';

/// Abstract class for Rewards remote data source.
/// defines methods for interacting with the rewards API endpoints.
abstract class RewardsRemoteDataSource {
  /// Claims the daily reward for the user.
  Future<String> claimDailyReward();

  /// Fetches the reward history for the user.

  Future<List<RewardHistoryModel>> getRewardHistory({
    RewardHistoryModel? rewardModel,
  });

  /// Fetches the current reward balance for the user.
  Future<RewardBalanceResponse> getRewardBalance();

  /// Initiates a withdrawal request for the 10k limit.
  Future<WithdrawalResponse> withdraw10kLimit();

  /// Claims the reward for referring 5 people.
  Future<ClaimReferralRewardResponse> claimReferralReward();

  /// Fetches the referrer QR code for the user.
  Future<String> getReferrerQrCode();

  /// Fetches the rewards leaderboard.
  Future<LeaderboardResponse> getLeaderboards({int page = 1});

  Future<WithdrawalResponse> withdrawReward(Map<String, dynamic> data);

  /// Fetches the status of reward activities.
  Future<RewardStatusResponse> getRewardStatus();

  Future<int> getReferralCount();
}

/// Implementation of [RewardsRemoteDataSource].
class RewardsRemoteDataSourceImpl implements RewardsRemoteDataSource {
  final ClapMiNetworkClient networkClient;

  RewardsRemoteDataSourceImpl({required this.networkClient});

  /// Helper function to handle API calls and error mapping.
  Future<T> _handleApiCall<T>(
    Future<BaseResponse> Function() apiCall,
    T Function(Map<String, dynamic>) fromMap,
  ) async {
    try {
      final response = await apiCall();
      // Use BaseResponse structure for checking success
      // Assuming BaseResponse.fromMap can handle the structure
      // Note: This part might need adjustment based on actual BaseResponse implementation
      // and how it handles different success/error structures across endpoints.
      if (response.success == 'true' ||
          response.data['success'] == true ||
          response.data['code'] == 200) {
        // Check if the relevant data part exists before parsing
        if (response.data != null) {
          return fromMap(response.data as Map<String, dynamic>);
        } else {
          // Handle cases where success is true but data might be missing unexpectedly
          throw ServerException(
              message: 'Successful response with missing data.');
        }
      } else {
        // Throw ServerException with the message from the response
        throw ServerException(
            message: response.data['message'] ?? 'API returned an error');
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Network error',
      );
    } catch (e) {
      if (e is ServerException) rethrow; // Re-throw known server exceptions
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> claimDailyReward() async {
    // Specific handling for claimDailyReward as its success/error structure differs
    try {
      final response = await networkClient.post(
        endpoint: EndpointConstant.claimDailyReward,
        isAuthHeaderRequired: true,
      );
      // Directly parse using the specific model's fromMap
      return response.nextClaim as String;
    } catch (e) {
      throw Exception('Error occured: ${e.toString()}');
    }
  }

  @override
  Future<List<RewardHistoryModel>> getRewardHistory({
    RewardHistoryModel? rewardModel,
  }) async {
    final response = await networkClient.get(
      endpoint: EndpointConstant.getRewardHistory,
      isAuthHeaderRequired: true,
    );
    final raw = response.data;
    List<dynamic> listData;
    if (raw is List) {
      listData = raw;
    } else if (raw is Map && raw['data'] is List) {
      listData = raw['data'] as List;
    } else {
      // Unexpected structure — return empty list instead of crashing
      return [];
    }

    // ✅ Convert each entry safely
    return listData
        .whereType<Map>() // ensures only map entries are parsed
        .map((e) => RewardHistoryModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<RewardBalanceResponse> getRewardBalance() async {
    final response = await networkClient.get(
      endpoint: EndpointConstant.getRewardBalance,
      isAuthHeaderRequired: true,
    );
    return RewardBalanceResponse(
        code: 0,
        success: bool.tryParse(response.success) ?? false,
        message: response.message,
        data: RewardBalanceData.fromMap(
            Map<String, dynamic>.from(response.data)));
  }

  @override
  Future<WithdrawalResponse> withdraw10kLimit() async {
    // Similar specific handling for withdrawal due to differing response structure
    try {
      final response = await networkClient.post(
        endpoint: EndpointConstant.withdraw10kLimit,
        isAuthHeaderRequired: true,
      );
      return WithdrawalResponse.fromMap(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.data != null &&
          e.response!.data is Map<String, dynamic>) {
        try {
          return WithdrawalResponse.fromMap(
              e.response!.data as Map<String, dynamic>);
        } catch (_) {
          throw ServerException(
            message: e.message ?? 'Network error',
          );
        }
      } else {
        throw ServerException(
          message: e.message ?? 'Network error',
        );
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ClaimReferralRewardResponse> claimReferralReward() async {
    // Specific handling for claim referral reward
    try {
      final response = await networkClient.post(
        endpoint: EndpointConstant.claimReferred5People,
        isAuthHeaderRequired: true,
      );
      return ClaimReferralRewardResponse.fromMap(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.data != null &&
          e.response!.data is Map<String, dynamic>) {
        try {
          return ClaimReferralRewardResponse.fromMap(
              e.response!.data as Map<String, dynamic>);
        } catch (_) {
          throw ServerException(
            message: e.message ?? 'Network error',
          );
        }
      } else {
        throw ServerException(
          message: e.message ?? 'Network error',
        );
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> getReferrerQrCode() async {
    // Use _handleApiCall as success structure seems consistent (success: true)

    final response = await networkClient.get(
      endpoint: EndpointConstant.getReferrerQrCode,
      isAuthHeaderRequired: true,
    );
    final result = response.data['qr_code'] as String;
    print('THIS IS THE IMAGE RESULT OF THE QR CODE $result');
    return result;
  }

  @override
  Future<LeaderboardResponse> getLeaderboards({int page = 1}) async {
    return _handleApiCall(
      () => networkClient.get(
        endpoint: EndpointConstant.getLeaderboard,
        isAuthHeaderRequired: true,
        params: {'page': page},
      ),
      LeaderboardResponse.fromMap,
    );
  }

  @override
  Future<RewardStatusResponse> getRewardStatus() async {
    final response = await networkClient.get(
        endpoint: EndpointConstant.rewardClaimStatus,
        isAuthHeaderRequired: true);
    // Assuming the response structure matches RewardStatusResponse.fromJson
    return RewardStatusResponse(
        success: bool.tryParse(response.success) ?? false,
        message: response.message,
        data:
            ((response.data as List).map((item) => item.toString())).toList());
  }

  @override
  Future<WithdrawalResponse> withdrawReward(Map<String, dynamic> data) {
    // TODO: implement withdrawReward
    throw UnimplementedError();
  }

  @override
  Future<int> getReferralCount() async {
    final response = await networkClient.get(
        endpoint: EndpointConstant.referralCount, isAuthHeaderRequired: true);
    return response.data['referral_count'] as int;
  }
}
