import 'package:clapmi/features/rewards/presentation/blocs/reward_event.dart';
import 'package:clapmi/features/rewards/presentation/blocs/reward_state.dart';
import 'package:clapmi/features/rewards/domain/repositories/rewards_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RewardBloc extends Bloc<RewardEvent, RewardState> {
  final RewardsRepository rewardRepository;

  RewardBloc({required this.rewardRepository}) : super(RewardInitialState()) {
    on<ClaimDailyRewardEvent>(_onClaimDailyRewardEvent);
    on<RewardHistoryEvent>(_onRewardHistoryEvent);
    on<RewardBalanceEvent>(_onRewardBalanceEvent);
    on<WithdrawalEvent>(_onWithdrawalEvent);
    on<ClaimReferralRewardEvent>(_onClaimReferralRewardEvent);
    on<ReferrerQrCodeEvent>(_onReferrerQrCodeEvent);
    on<LeaderboardEvent>(_onLeaderboardEvent);
    on<GetRewardStatusEvent>(_onGetRewardStatusEvent);
    on<GetReferralCountEvent>(_onGetReferralCountEventHandler);
    // on<GetRewardStatusEvent>(_onGetRewardStatusEvent);
  }

  Future<void> _onClaimDailyRewardEvent(
      ClaimDailyRewardEvent event, Emitter<RewardState> emit) async {
    emit(ClaimDailyRewardLoadingState());

    final result = await rewardRepository.claimDailyReward();
    result.fold(
      (error) {
        emit(ClaimDailyRewardErrorState(errorMessage: error.message));
      },
      (message) {
        emit(ClaimDailyRewardSuccessState(nextClaim: message));
        //* TODO: Get reward balance here
      },
    );
  }

  Future<void> _onRewardHistoryEvent(
    RewardHistoryEvent event,
    Emitter<RewardState> emit,
  ) async {
    emit(RewardHistoryLoadingState());
    final result =
        await rewardRepository.getRewardHistory(rewardModel: event.rewardmodel);
    result.fold(
      (error) => emit(RewardHistoryErrorState(errorMessage: error.message)),
      (message) {
        emit(RewardHistorySuccessState(rewardModel: message));
      },
    );
  }

  Future<void> _onRewardBalanceEvent(
      RewardBalanceEvent event, Emitter<RewardState> emit) async {
    emit(RewardBalanceLoadingState());
    final result = await rewardRepository.getRewardBalance();
    result.fold(
      (error) => emit(RewardBalanceErrorState(errorMessage: error.message)),
      (data) {
        print('${data.message} lo@@@@');
        emit(RewardBalanceSuccessState(response: data));
      },
    );
  }

  Future<void> _onWithdrawalEvent(
      WithdrawalEvent event, Emitter<RewardState> emit) async {
    emit(WithdrawalLoadingState());
    final result = await rewardRepository.withdraw10kLimit();
    result.fold(
      (error) => emit(WithdrawalErrorState(errorMessage: error.message)),
      (message) {
        emit(WithdrawalSuccessState(response: message));
      },
    );
  }

  Future<void> _onClaimReferralRewardEvent(
      ClaimReferralRewardEvent event, Emitter<RewardState> emit) async {
    emit(ClaimReferralRewardLoadingState());
    final result = await rewardRepository.claimReferralReward();
    result.fold(
      (error) =>
          emit(ClaimReferralRewardErrorState(errorMessage: error.message)),
      (message) {
        emit(ClaimReferralRewardSuccessState(response: message));
      },
    );
  }

  Future<void> _onReferrerQrCodeEvent(
      ReferrerQrCodeEvent event, Emitter<RewardState> emit) async {
    emit(ReferrerQrCodeLoadingState());
    final result = await rewardRepository.getReferrerQrCode();
    result.fold(
      (error) => emit(ReferrerQrCodeErrorState(errorMessage: error.message)),
      (message) {
        emit(ReferrerQrCodeSuccessState(qrCode: message));
      },
    );
  }

  Future<void> _onLeaderboardEvent(
      LeaderboardEvent event, Emitter<RewardState> emit) async {
    emit(LeaderboardLoadingState());
    final result =
        await rewardRepository.getLeaderboards(page: event.pageNumber);
    result.fold(
      (error) => emit(LeaderboardErrorState(errorMessage: error.message)),
      (message) {
        emit(LeaderboardSuccessState(response: message));
      },
    );
  }

  // Handler for GetRewardStatusEvent
  Future<void> _onGetRewardStatusEvent(
      GetRewardStatusEvent event, Emitter<RewardState> emit) async {
    emit(RewardStatusLoadingState());
    final result = await rewardRepository.getRewardStatus();
    result.fold(
      (error) => emit(RewardStatusErrorState(errorMessage: error.message)),
      (response) {
        // Emit the loaded state with the list of incomplete tasks
        emit(RewardStatusLoadedState(incompleteTasks: response.data));
      },
    );
  }

  Future<void> _onGetReferralCountEventHandler(
      GetReferralCountEvent event, Emitter<RewardState> emit) async {
    final result = await rewardRepository.getReferralCount();
    result.fold(
        (error) => emit(RewardStatusErrorState(errorMessage: error.message)),
        (referralCount) =>
            emit(ReferralCountState(referralCount: referralCount)));
  }
}
