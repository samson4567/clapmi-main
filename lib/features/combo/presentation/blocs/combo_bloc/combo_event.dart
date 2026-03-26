import 'package:clapmi/features/combo/domain/entities/combo_entity.dart';
import 'package:clapmi/features/combo/data/datasources/combo_remote_datasource.dart';
import 'package:equatable/equatable.dart';

abstract class ComboEvent extends Equatable {
  const ComboEvent();

  @override
  List<Object> get props => [];
}

// GetLiveCombos
final class GetLiveCombosEvent extends ComboEvent {
  const GetLiveCombosEvent();

  @override
  List<Object> get props => [];
}

// GetUpcomingCombos
final class GetUpcomingCombosEvent extends ComboEvent {
  const GetUpcomingCombosEvent();

  @override
  List<Object> get props => [];
}

// GetComboDetail
final class GetComboDetailEvent extends ComboEvent {
  final String comboID;
  const GetComboDetailEvent(this.comboID);

  @override
  List<Object> get props => [comboID];
}

// StartCombo
final class StartComboEvent extends ComboEvent {
  final String comboID;
  const StartComboEvent(this.comboID);

  @override
  List<Object> get props => [comboID];
}

// SetRemindalForCombo
final class SetReminderForComboEvent extends ComboEvent {
  final String comboID;
  final String time;
  const SetReminderForComboEvent({required this.comboID, required this.time});

  @override
  List<Object> get props => [comboID, time];
} // SetRemindalForCombo

// LeaveComboGround
final class LeaveComboGroundEvent extends ComboEvent {
  final String comboID;
  const LeaveComboGroundEvent(this.comboID);

  @override
  List<Object> get props => [comboID];
}

// JoinComboGround
final class JoinComboGroundEvent extends ComboEvent {
  final String comboID;
  const JoinComboGroundEvent(this.comboID);

  @override
  List<Object> get props => [comboID];
}

class RescheduleChallengeEvent extends ComboEvent {
  const RescheduleChallengeEvent({required this.postID, required this.newTime});
  final String postID;
  final String newTime;
}

class GetLiveComboEvent extends ComboEvent {
  const GetLiveComboEvent({required this.combo});
  final ComboEntity combo;
}

// SwitchDevice
final class SwitchDeviceEvent extends ComboEvent {
  final String comboID;
  final String deviceId;

  const SwitchDeviceEvent({required this.comboID, required this.deviceId});

  @override
  List<Object> get props => [comboID, deviceId];
}

// JoinCompanion
final class JoinCompanionEvent extends ComboEvent {
  final String comboID;
  final String deviceId;

  const JoinCompanionEvent({required this.comboID, required this.deviceId});

  @override
  List<Object> get props => [comboID, deviceId];
}
// JoinComboGround
