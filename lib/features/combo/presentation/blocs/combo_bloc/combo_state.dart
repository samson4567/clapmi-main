import 'package:clapmi/features/combo/domain/entities/combo_entity.dart';
import 'package:clapmi/features/combo/data/datasources/combo_remote_datasource.dart';
import 'package:equatable/equatable.dart';

sealed class ComboState extends Equatable {
  const ComboState();

  @override
  List<Object> get props => [];
}

final class ComboInitial extends ComboState {
  const ComboInitial();
}

// GetLiveCombos

final class GetLiveCombosSuccessState extends ComboState {
  final List<ComboEntity> listOfComboEntity;

  const GetLiveCombosSuccessState({required this.listOfComboEntity});

  @override
  List<Object> get props => [listOfComboEntity];
}

final class GetLiveCombosErrorState extends ComboState {
  final String errorMessage;

  const GetLiveCombosErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// GetLiveCombos ended ......

// GetUpcomingCombos

final class GetCombosLoadingState extends ComboState {
  const GetCombosLoadingState();
}

final class GetUpcomingCombosSuccessState extends ComboState {
  final List<ComboEntity> listOfComboEntity;

  const GetUpcomingCombosSuccessState({required this.listOfComboEntity});

  @override
  List<Object> get props => [listOfComboEntity];
}

final class GetUpcomingCombosErrorState extends ComboState {
  final String errorMessage;

  const GetUpcomingCombosErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// GetUpcomingCombos ended ......

// GetComboDetail
final class GetComboDetailLoadingState extends ComboState {
  const GetComboDetailLoadingState();
}

final class GetComboDetailSuccessState extends ComboState {
  final ComboEntity comboEntity;

  const GetComboDetailSuccessState({required this.comboEntity});

  @override
  List<Object> get props => [comboEntity];
}

final class GetComboDetailErrorState extends ComboState {
  final String errorMessage;

  const GetComboDetailErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// GetComboDetail ended ......

// StartCombo
final class StartComboLoadingState extends ComboState {
  const StartComboLoadingState();
}

final class StartComboSuccessState extends ComboState {
  final String message;

  const StartComboSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

final class StartComboErrorState extends ComboState {
  final String errorMessage;

  const StartComboErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// StartCombo ended ......

// SetRemindalForCombo
final class SetReminderForComboLoadingState extends ComboState {
  const SetReminderForComboLoadingState();
}

final class SetReminderForComboSuccessState extends ComboState {
  final String message;

  const SetReminderForComboSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

final class SetRemindalForComboErrorState extends ComboState {
  final String errorMessage;

  const SetRemindalForComboErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// SetRemindalForCombo ended ......

// JoinComboGround
final class JoinComboGroundLoadingState extends ComboState {
  const JoinComboGroundLoadingState();
}

final class JoinComboGroundSuccessState extends ComboState {
  final String message;

  const JoinComboGroundSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

final class JoinComboGroundErrorState extends ComboState {
  final String errorMessage;

  const JoinComboGroundErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// JoinComboGround ended ......

// LeaveComboGround
final class LeaveComboGroundLoadingState extends ComboState {
  const LeaveComboGroundLoadingState();
}

final class LeaveComboGroundSuccessState extends ComboState {
  final String message;

  const LeaveComboGroundSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

final class LeaveComboGroundErrorState extends ComboState {
  final String errorMessage;

  const LeaveComboGroundErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
// LeaveComboGround ended ......

// LeaveComboGround
class RescheduleChallengeState extends ComboState {
  final String message;
  const RescheduleChallengeState({required this.message});

  @override
  List<Object> get props => [message];
}

class RescheduleChallengeLoading extends ComboState {
  const RescheduleChallengeLoading();
}

class RescheduleChallengeErrorState extends ComboState {
  const RescheduleChallengeErrorState();
}

class LiveComboLoaded extends ComboState {
  final LiveComboEntity liveCombo;

  const LiveComboLoaded({
    required this.liveCombo,
  });

  @override
  List<Object> get props => [liveCombo];
}

class LiveComboLoading extends ComboState {
  const LiveComboLoading();
}

class GetLiveComboErrorState extends ComboState {
  final String errorMessage;

  const GetLiveComboErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// SwitchDevice
final class SwitchDeviceLoadingState extends ComboState {
  const SwitchDeviceLoadingState();
}

final class SwitchDeviceSuccessState extends ComboState {
  final SwitchDeviceResult result;

  const SwitchDeviceSuccessState({required this.result});

  @override
  List<Object> get props => [result];
}

final class SwitchDeviceErrorState extends ComboState {
  final String errorMessage;

  const SwitchDeviceErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// JoinCompanion
final class JoinCompanionLoadingState extends ComboState {
  const JoinCompanionLoadingState();
}

final class JoinCompanionSuccessState extends ComboState {
  final JoinCompanionResult result;

  const JoinCompanionSuccessState({required this.result});

  @override
  List<Object> get props => [result];
}

final class JoinCompanionErrorState extends ComboState {
  final String errorMessage;

  const JoinCompanionErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
