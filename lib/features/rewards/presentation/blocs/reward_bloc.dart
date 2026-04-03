import 'package:clapmi/features/rewards/data/models/leaderboard_response.dart';
import 'package:clapmi/features/rewards/data/models/reward_balance_response.dart';
import 'package:clapmi/features/rewards/presentation/blocs/reward_event.dart';
import 'package:clapmi/features/rewards/presentation/blocs/reward_state.dart';
import 'package:clapmi/features/rewards/domain/repositories/rewards_repository.dart';
import 'package:clapmi/features/rewards/domain/repositories/entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RewardBloc extends Bloc<RewardEvent, RewardState> {
  static const Duration _cacheTtl = Duration(minutes: 2);
  final RewardsRepository rewardRepository;

  List<RewardHistoryEntity> _rewardHistory = [];
  DateTime? _rewardHistoryUpdatedAt;
  RewardBalanceResponse? _rewardBalance;
  DateTime? _rewardBalanceUpdatedAt;
  String _referrerQrCode = '';
  DateTime? _referrerQrCodeUpdatedAt;
  LeaderboardResponse? _leaderboardResponse;
  DateTime? _leaderboardUpdatedAt;
  List<String> _rewardStatus = [];
  DateTime? _rewardStatusUpdatedAt;
  int? _referralCount;
  DateTime? _referralCountUpdatedAt;

  List<RewardHistoryEntity> get rewardHistory => List.unmodifiable(_rewardHistory);
  RewardBalanceResponse? get rewardBalance => _rewardBalance;
  String get referrerQrCode => _referrerQrCode;
  LeaderboardResponse? get leaderboardResponse => _leaderboardResponse;
  List<String> get rewardStatus => List.unmodifiable(_rewardStatus);
  int? get referralCount => _referralCount;

  bool get hasRewardHistory => _rewardHistory.isNotEmpty;
  bool get hasRewardBalance => _rewardBalance != null;
  bool get hasReferrerQrCode => _referrerQrCode.isNotEmpty;
  bool get hasLeaderboard => _leaderboardResponse != null;
  bool get hasRewardStatus => _rewardStatus.isNotEmpty;
  bool get hasReferralCount => _referralCount != null;

  bool get isRewardHistoryFresh => _isFresh(_rewardHistoryUpdatedAt, hasRewardHistory);
  bool get isRewardBalanceFresh => _isFresh(_rewardBalanceUpdatedAt, hasRewardBalance);
  bool get isReferrerQrCodeFresh =>
      _isFresh(_referrerQrCodeUpdatedAt, hasReferrerQrCode);
  bool get isLeaderboardFresh => _isFresh(_leaderboardUpdatedAt, hasLeaderboard);
  bool get isRewardStatusFresh => _isFresh(_rewardStatusUpdatedAt, hasRewardStatus);
  bool get isReferralCountFresh =>
      _isFresh(_referralCountUpdatedAt, hasReferralCount);

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

  bool _isFresh(DateTime? updatedAt, bool hasData) {
    if (!hasData || updatedAt == null) {
      return false;
    }
    return DateTime.now().difference(updatedAt) < _cacheTtl;
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
    final hasFreshCache = !event.forceRefresh && isRewardHistoryFresh;
    if (hasFreshCache) {
      emit(RewardHistorySuccessState(rewardModel: _rewardHistory));
      return;
    }

    if (!(event.refreshInBackground && hasRewardHistory)) {
      emit(RewardHistoryLoadingState());
    }
    final result =
        await rewardRepository.getRewardHistory(rewardModel: event.rewardmodel);
    result.fold(
      (error) => emit(RewardHistoryErrorState(errorMessage: error.message)),
      (message) {
        _rewardHistory = message;
        _rewardHistoryUpdatedAt = DateTime.now();
        emit(RewardHistorySuccessState(rewardModel: message));
      },
    );
  }

  Future<void> _onRewardBalanceEvent(
      RewardBalanceEvent event, Emitter<RewardState> emit) async {
    final hasFreshCache = !event.forceRefresh && isRewardBalanceFresh;
    if (hasFreshCache && _rewardBalance != null) {
      emit(RewardBalanceSuccessState(response: _rewardBalance!));
      return;
    }

    if (!(event.refreshInBackground && hasRewardBalance)) {
      emit(RewardBalanceLoadingState());
    }
    final result = await rewardRepository.getRewardBalance();
    result.fold(
      (error) => emit(RewardBalanceErrorState(errorMessage: error.message)),
      (data) {
        _rewardBalance = data;
        _rewardBalanceUpdatedAt = DateTime.now();
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
    final hasFreshCache = !event.forceRefresh && isReferrerQrCodeFresh;
    if (hasFreshCache) {
      emit(ReferrerQrCodeSuccessState(qrCode: _referrerQrCode));
      return;
    }

    if (!(event.refreshInBackground && hasReferrerQrCode)) {
      emit(ReferrerQrCodeLoadingState());
    }
    final result = await rewardRepository.getReferrerQrCode();
    result.fold(
      (error) => emit(ReferrerQrCodeErrorState(errorMessage: error.message)),
      (message) {
        _referrerQrCode = message;
        _referrerQrCodeUpdatedAt = DateTime.now();
        emit(ReferrerQrCodeSuccessState(qrCode: message));
      },
    );
  }

  Future<void> _onLeaderboardEvent(
      LeaderboardEvent event, Emitter<RewardState> emit) async {
    final hasFreshCache = !event.forceRefresh && isLeaderboardFresh;
    if (hasFreshCache && _leaderboardResponse != null) {
      emit(LeaderboardSuccessState(response: _leaderboardResponse!));
      return;
    }

    if (!(event.refreshInBackground && hasLeaderboard)) {
      emit(LeaderboardLoadingState());
    }
    final result =
        await rewardRepository.getLeaderboards(page: event.pageNumber);
    result.fold(
      (error) => emit(LeaderboardErrorState(errorMessage: error.message)),
      (message) {
        _leaderboardResponse = message;
        _leaderboardUpdatedAt = DateTime.now();
        emit(LeaderboardSuccessState(response: message));
      },
    );
  }

  // Handler for GetRewardStatusEvent
  Future<void> _onGetRewardStatusEvent(
      GetRewardStatusEvent event, Emitter<RewardState> emit) async {
    final hasFreshCache = !event.forceRefresh && isRewardStatusFresh;
    if (hasFreshCache) {
      emit(RewardStatusLoadedState(incompleteTasks: _rewardStatus));
      return;
    }

    if (!(event.refreshInBackground && hasRewardStatus)) {
      emit(RewardStatusLoadingState());
    }
    final result = await rewardRepository.getRewardStatus();
    result.fold(
      (error) => emit(RewardStatusErrorState(errorMessage: error.message)),
      (response) {
        _rewardStatus = response.data;
        _rewardStatusUpdatedAt = DateTime.now();
        emit(RewardStatusLoadedState(incompleteTasks: response.data));
      },
    );
  }

  Future<void> _onGetReferralCountEventHandler(
      GetReferralCountEvent event, Emitter<RewardState> emit) async {
    final hasFreshCache = !event.forceRefresh && isReferralCountFresh;
    if (hasFreshCache && _referralCount != null) {
      emit(ReferralCountState(referralCount: _referralCount!));
      return;
    }

    final result = await rewardRepository.getReferralCount();
    result.fold(
        (error) => emit(RewardStatusErrorState(errorMessage: error.message)),
        (referralCount) {
          _referralCount = referralCount;
          _referralCountUpdatedAt = DateTime.now();
          emit(ReferralCountState(referralCount: referralCount));
        });
  }
}
