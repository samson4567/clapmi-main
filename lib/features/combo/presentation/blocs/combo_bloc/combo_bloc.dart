import 'package:clapmi/features/app/presentation/blocs/app/app_bloc.dart';
import 'package:clapmi/features/combo/domain/repositories/combo_repository.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_event.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clapmi/core/services/device_service.dart';

class ComboBloc extends Bloc<ComboEvent, ComboState> {
  final ComboRepository comboRepository;
  final AppBloc appBloc;
  final DeviceService _deviceService = DeviceService();

  ComboBloc({required this.appBloc, required this.comboRepository})
      : super(ComboInitial()) {
    on<GetLiveCombosEvent>(_onGetLiveCombosEvent);
    on<GetUpcomingCombosEvent>(_onGetUpcomingCombosEvent);
    on<GetComboDetailEvent>(_onGetComboDetailEvent);
    on<StartComboEvent>(_onStartComboEvent);
    on<SetReminderForComboEvent>(_onSetReminderForComboEvent);
    on<JoinComboGroundEvent>(_onJoinComboGroundEvent);
    on<LeaveComboGroundEvent>(_onLeaveComboGroundEvent);
    on<RescheduleChallengeEvent>(_onRescheduleChallengeEventHandler);
    on<GetLiveComboEvent>(_getLiveComboEventHandler);
    on<SwitchDeviceEvent>(_onSwitchDeviceEvent);
    on<JoinCompanionEvent>(_onJoinCompanionEvent);
    // LeaveComboGround
  }

  Future<void> _onGetLiveCombosEvent(
      GetLiveCombosEvent event, Emitter<ComboState> emit) async {
    emit(GetCombosLoadingState());
    final result = await comboRepository.getLiveCombos();
    result.fold(
        (error) => emit(GetLiveCombosErrorState(errorMessage: error.message)),
        (listOfComboEntity) {
      emit(
        GetLiveCombosSuccessState(listOfComboEntity: listOfComboEntity),
      );
    });
  }

  Future<void> _onGetUpcomingCombosEvent(
      GetUpcomingCombosEvent event, Emitter<ComboState> emit) async {
    emit(GetCombosLoadingState());
    final result = await comboRepository.getUpcomingCombos();
    result.fold(
        (error) =>
            emit(GetUpcomingCombosErrorState(errorMessage: error.message)),
        (listOfComboEntity) {
      emit(
        GetUpcomingCombosSuccessState(listOfComboEntity: listOfComboEntity),
      );
    });
  }

  Future<void> _onGetComboDetailEvent(
      GetComboDetailEvent event, Emitter<ComboState> emit) async {
    emit(GetComboDetailLoadingState());
    final result = await comboRepository.getComboDetail(comboID: event.comboID);
    result.fold((error) {
      emit(GetComboDetailErrorState(errorMessage: error.message));
    }, (comboEntity) {
      emit(
        GetComboDetailSuccessState(comboEntity: comboEntity),
      );
    });
  }

  Future<void> _onStartComboEvent(
      StartComboEvent event, Emitter<ComboState> emit) async {
    emit(StartComboLoadingState());
    final result = await comboRepository.startCombo(
      comboID: event.comboID,
    );
    result.fold(
        (error) => emit(StartComboErrorState(errorMessage: error.message)),
        (message) {
      emit(
        StartComboSuccessState(message: message),
      );
    });
  }

  Future<void> _onSetReminderForComboEvent(
      SetReminderForComboEvent event, Emitter<ComboState> emit) async {
    emit(SetReminderForComboLoadingState());
    final result = await comboRepository.setReminderForCombo(
        comboID: event.comboID, time: event.time);
    result.fold(
        (error) =>
            emit(SetRemindalForComboErrorState(errorMessage: error.message)),
        (message) {
      emit(
        SetReminderForComboSuccessState(message: message),
      );
    });
  }

  Future<void> _onLeaveComboGroundEvent(
      LeaveComboGroundEvent event, Emitter<ComboState> emit) async {
    emit(LeaveComboGroundLoadingState());
    final result =
        await comboRepository.leaveComboGround(comboID: event.comboID);
    result.fold(
        (error) =>
            emit(LeaveComboGroundErrorState(errorMessage: error.message)), (_) {
      // emit(
      //   LeaveComboGroundSuccessState(message: message),
      // );
    });
  }

  Future<void> _onJoinComboGroundEvent(
      JoinComboGroundEvent event, Emitter<ComboState> emit) async {
    emit(JoinComboGroundLoadingState());
    final result =
        await comboRepository.joinComboGround(comboID: event.comboID);
    result.fold(
        (error) => emit(JoinComboGroundErrorState(errorMessage: error.message)),
        (message) {
      emit(
        JoinComboGroundSuccessState(message: message),
      );
    });
  }

  Future<void> _onRescheduleChallengeEventHandler(
      RescheduleChallengeEvent event, Emitter<ComboState> emit) async {
    emit(RescheduleChallengeLoading());
    final result = await comboRepository.rescheduleChallenge(
        postID: event.postID, newTime: event.newTime);
    result.fold((error) => emit(RescheduleChallengeErrorState()),
        (message) => emit(RescheduleChallengeState(message: message)));
  }

  // _onLeaveComboGroundEvent
  Future<void> _getLiveComboEventHandler(
      GetLiveComboEvent event, Emitter<ComboState> emit) async {
    emit(LiveComboLoading());
    final result = await comboRepository.getSingleLiveCombo(
        comboId: event.combo.combo ?? '');
    result.fold(
        (error) =>
            emit(LeaveComboGroundErrorState(errorMessage: error.message)),
        (liveCombo) {
      print("This is the liveComboEvent ${liveCombo.stake}");
      final tempLive = liveCombo.copyWith(end: event.combo.endAt);
      print("Mem from bloc class00000000 ${tempLive.stake}");
      emit(LiveComboLoaded(
        liveCombo: tempLive,
      ));
    });
  }

  // Handle SwitchDeviceEvent
  Future<void> _onSwitchDeviceEvent(
      SwitchDeviceEvent event, Emitter<ComboState> emit) async {
    emit(SwitchDeviceLoadingState());
    final result = await comboRepository.switchDevice(
      comboID: event.comboID,
      deviceId: event.deviceId,
    );
    result.fold(
      (error) => emit(SwitchDeviceErrorState(errorMessage: error.message)),
      (switchResult) {
        emit(SwitchDeviceSuccessState(result: switchResult));
      },
    );
  }

  // Handle JoinCompanionEvent
  Future<void> _onJoinCompanionEvent(
      JoinCompanionEvent event, Emitter<ComboState> emit) async {
    emit(JoinCompanionLoadingState());
    final result = await comboRepository.joinCompanion(
      comboID: event.comboID,
      deviceId: event.deviceId,
    );
    result.fold(
      (error) => emit(JoinCompanionErrorState(errorMessage: error.message)),
      (companionResult) async {
        // Persist device role as companion after successful join
        await _deviceService.setDeviceRole(DeviceRole.companion);
        emit(JoinCompanionSuccessState(result: companionResult));
      },
    );
  }
}
