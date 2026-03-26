import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:clapmi/core/services/device_service.dart';
import 'package:clapmi/core/services/device_switch_service.dart' as switch_service;

// Events
abstract class DeviceSwitchBlocEvent extends Equatable {
  const DeviceSwitchBlocEvent();

  @override
  List<Object?> get props => [];
}

class InitializeDeviceSwitchEvent extends DeviceSwitchBlocEvent {
  final String roomId;
  final String userId;

  const InitializeDeviceSwitchEvent({
    required this.roomId,
    required this.userId,
  });

  @override
  List<Object?> get props => [roomId, userId];
}

class InitiateDeviceSwitchEvent extends DeviceSwitchBlocEvent {
  final String roomId;
  final String userId;

  const InitiateDeviceSwitchEvent({
    required this.roomId,
    required this.userId,
  });

  @override
  List<Object?> get props => [roomId, userId];
}

class JoinAsCompanionEvent extends DeviceSwitchBlocEvent {
  final String roomId;
  final String userId;

  const JoinAsCompanionEvent({
    required this.roomId,
    required this.userId,
  });

  @override
  List<Object?> get props => [roomId, userId];
}

class HandleDeviceSwitchRequestedEvent extends DeviceSwitchBlocEvent {
  final switch_service.DeviceSwitchRequested switchData;

  const HandleDeviceSwitchRequestedEvent({required this.switchData});

  @override
  List<Object?> get props => [switchData];
}

class HandleDeviceSwitchReadyEvent extends DeviceSwitchBlocEvent {
  final switch_service.DeviceSwitchReady switchData;

  const HandleDeviceSwitchReadyEvent({required this.switchData});

  @override
  List<Object?> get props => [switchData];
}

class HandleCompanionJoinedEvent extends DeviceSwitchBlocEvent {
  final switch_service.CompanionJoined companionData;

  const HandleCompanionJoinedEvent({required this.companionData});

  @override
  List<Object?> get props => [companionData];
}

class DisconnectDeviceSwitchEvent extends DeviceSwitchBlocEvent {
  const DisconnectDeviceSwitchEvent();
}

// States
abstract class DeviceSwitchState extends Equatable {
  const DeviceSwitchState();

  @override
  List<Object?> get props => [];
}

class DeviceSwitchInitial extends DeviceSwitchState {
  const DeviceSwitchInitial();
}

class DeviceSwitchConnecting extends DeviceSwitchState {
  const DeviceSwitchConnecting();
}

class DeviceSwitchConnected extends DeviceSwitchState {
  final String deviceId;
  final String deviceType;

  const DeviceSwitchConnected({
    required this.deviceId,
    required this.deviceType,
  });

  @override
  List<Object?> get props => [deviceId, deviceType];
}

class DeviceSwitchReadyReceived extends DeviceSwitchState {
  final switch_service.DeviceSwitchReady switchData;

  const DeviceSwitchReadyReceived({required this.switchData});

  @override
  List<Object?> get props => [switchData];
}

class DeviceSwitchRequestedByServer extends DeviceSwitchState {
  final String newDevice;
  final String message;

  const DeviceSwitchRequestedByServer({
    required this.newDevice,
    required this.message,
  });

  @override
  List<Object?> get props => [newDevice, message];
}

class CompanionJoinedReceived extends DeviceSwitchState {
  final switch_service.CompanionJoined companionData;

  const CompanionJoinedReceived({required this.companionData});

  @override
  List<Object?> get props => [companionData];
}

class DeviceSwitchDisconnected extends DeviceSwitchState {
  const DeviceSwitchDisconnected();
}

class DeviceSwitchError extends DeviceSwitchState {
  final String message;

  const DeviceSwitchError({required this.message});

  @override
  List<Object?> get props => [message];
}

// BLoC
class DeviceSwitchBloc extends Bloc<DeviceSwitchBlocEvent, DeviceSwitchState> {
  final DeviceService _deviceService = DeviceService();
  final switch_service.DeviceSwitchService _deviceSwitchService = switch_service.DeviceSwitchService();
  
  StreamSubscription<switch_service.DeviceSwitchReady>? _deviceSwitchReadySubscription;
  StreamSubscription<switch_service.DeviceSwitchRequested>? _deviceSwitchRequestedSubscription;
  StreamSubscription<switch_service.CompanionJoined>? _companionJoinedSubscription;

  DeviceSwitchBloc() : super(const DeviceSwitchInitial()) {
    on<InitializeDeviceSwitchEvent>(_onInitializeDeviceSwitch);
    on<InitiateDeviceSwitchEvent>(_onInitiateDeviceSwitch);
    on<JoinAsCompanionEvent>(_onJoinAsCompanion);
    on<HandleDeviceSwitchRequestedEvent>(_onHandleDeviceSwitchRequested);
    on<HandleDeviceSwitchReadyEvent>(_onHandleDeviceSwitchReady);
    on<HandleCompanionJoinedEvent>(_onHandleCompanionJoined);
    on<DisconnectDeviceSwitchEvent>(_onDisconnectDeviceSwitch);

    _setupSocketListeners();
  }

  void _setupSocketListeners() {
    _deviceSwitchReadySubscription = _deviceSwitchService.onDeviceSwitchReady.listen(
      (data) => add(HandleDeviceSwitchReadyEvent(switchData: data)),
    );

    _deviceSwitchRequestedSubscription = _deviceSwitchService.onDeviceSwitchRequested.listen(
      (data) => add(HandleDeviceSwitchRequestedEvent(switchData: data)),
    );

    _companionJoinedSubscription = _deviceSwitchService.onCompanionJoined.listen(
      (data) => add(HandleCompanionJoinedEvent(companionData: data)),
    );
  }

  Future<void> _onInitializeDeviceSwitch(
    InitializeDeviceSwitchEvent event,
    Emitter<DeviceSwitchState> emit,
  ) async {
    try {
      emit(const DeviceSwitchConnecting());
      
      await _deviceSwitchService.connect(
        roomId: event.roomId,
        userId: event.userId,
      );

      final deviceId = await _deviceService.getDeviceId();
      final deviceType = _deviceService.getDeviceType();

      emit(DeviceSwitchConnected(
        deviceId: deviceId,
        deviceType: deviceType,
      ));
    } catch (e) {
      emit(DeviceSwitchError(message: e.toString()));
    }
  }

  Future<void> _onInitiateDeviceSwitch(
    InitiateDeviceSwitchEvent event,
    Emitter<DeviceSwitchState> emit,
  ) async {
    try {
      _deviceSwitchService.emitSwitchDevice(
        roomId: event.roomId,
        userId: event.userId,
      );
    } catch (e) {
      emit(DeviceSwitchError(message: e.toString()));
    }
  }

  Future<void> _onJoinAsCompanion(
    JoinAsCompanionEvent event,
    Emitter<DeviceSwitchState> emit,
  ) async {
    try {
      _deviceSwitchService.emitJoinCompanion(
        roomId: event.roomId,
        userId: event.userId,
      );
    } catch (e) {
      emit(DeviceSwitchError(message: e.toString()));
    }
  }

  void _onHandleDeviceSwitchRequested(
    HandleDeviceSwitchRequestedEvent event,
    Emitter<DeviceSwitchState> emit,
  ) {
    emit(DeviceSwitchRequestedByServer(
      newDevice: event.switchData.newDevice,
      message: event.switchData.message,
    ));
  }

  void _onHandleDeviceSwitchReady(
    HandleDeviceSwitchReadyEvent event,
    Emitter<DeviceSwitchState> emit,
  ) {
    emit(DeviceSwitchReadyReceived(switchData: event.switchData));
  }

  void _onHandleCompanionJoined(
    HandleCompanionJoinedEvent event,
    Emitter<DeviceSwitchState> emit,
  ) {
    emit(CompanionJoinedReceived(companionData: event.companionData));
  }

  void _onDisconnectDeviceSwitch(
    DisconnectDeviceSwitchEvent event,
    Emitter<DeviceSwitchState> emit,
  ) {
    _deviceSwitchService.disconnect();
    emit(const DeviceSwitchDisconnected());
  }

  @override
  Future<void> close() {
    _deviceSwitchReadySubscription?.cancel();
    _deviceSwitchRequestedSubscription?.cancel();
    _companionJoinedSubscription?.cancel();
    return super.close();
  }
}