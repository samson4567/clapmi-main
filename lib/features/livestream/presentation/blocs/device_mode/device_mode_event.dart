import 'package:equatable/equatable.dart';

/// Events for Device Mode BLoC
abstract class DeviceModeEvent extends Equatable {
  const DeviceModeEvent();

  @override
  List<Object?> get props => [];
}

/// Initialize device mode - get device ID
class InitializeDeviceMode extends DeviceModeEvent {
  const InitializeDeviceMode();
}

/// Request to switch device (NEW device initiates)
class RequestDeviceSwitch extends DeviceModeEvent {
  final String roomId;
  final String userId;

  const RequestDeviceSwitch({
    required this.roomId,
    required this.userId,
  });

  @override
  List<Object?> get props => [roomId, userId];
}

/// Accept device switch request (OLD device)
class AcceptDeviceSwitch extends DeviceModeEvent {
  const AcceptDeviceSwitch();
}

/// Reject device switch request
class RejectDeviceSwitch extends DeviceModeEvent {
  const RejectDeviceSwitch();
}

/// Request to join as companion
class RequestCompanionMode extends DeviceModeEvent {
  final String roomId;
  final String userId;

  const RequestCompanionMode({
    required this.roomId,
    required this.userId,
  });

  @override
  List<Object?> get props => [roomId, userId];
}

/// Leave companion mode
class LeaveCompanionMode extends DeviceModeEvent {
  const LeaveCompanionMode();
}

/// Device switch ready received (NEW device)
class DeviceSwitchReadyReceived extends DeviceModeEvent {
  final String roomId;
  final List<dynamic> producers;
  final Map<String, dynamic> routerRtpCapabilities;

  const DeviceSwitchReadyReceived({
    required this.roomId,
    required this.producers,
    required this.routerRtpCapabilities,
  });

  @override
  List<Object?> get props => [roomId, producers, routerRtpCapabilities];
}

/// Device switch requested received (OLD device)
class DeviceSwitchRequestedReceived extends DeviceModeEvent {
  final String newDevice;
  final String message;

  const DeviceSwitchRequestedReceived({
    required this.newDevice,
    required this.message,
  });

  @override
  List<Object?> get props => [newDevice, message];
}

/// Companion joined received
class CompanionJoinedReceived extends DeviceModeEvent {
  final String roomId;
  final List<dynamic> producers;
  final Map<String, dynamic> routerRtpCapabilities;

  const CompanionJoinedReceived({
    required this.roomId,
    required this.producers,
    required this.routerRtpCapabilities,
  });

  @override
  List<Object?> get props => [roomId, producers, routerRtpCapabilities];
}

/// Reset device mode state
class ResetDeviceMode extends DeviceModeEvent {
  const ResetDeviceMode();
}
