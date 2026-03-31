import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:clapmi/core/services/device_service.dart';
import 'package:clapmi/core/services/device_switch_service.dart';
import 'device_mode_event.dart';

// States
abstract class DeviceModeState extends Equatable {
  const DeviceModeState();

  @override
  List<Object?> get props => [];
}

class DeviceModeInitial extends DeviceModeState {
  const DeviceModeInitial();
}

class DeviceModeLoading extends DeviceModeState {
  const DeviceModeLoading();
}

class DeviceModeConnected extends DeviceModeState {
  final String deviceId;
  final String deviceType;
  final DeviceRole deviceRole;

  const DeviceModeConnected({
    required this.deviceId,
    required this.deviceType,
    required this.deviceRole,
  });

  @override
  List<Object?> get props => [deviceId, deviceType, deviceRole];
}

class DeviceSwitchReadyState extends DeviceModeState {
  final DeviceSwitchReady switchData;

  const DeviceSwitchReadyState({required this.switchData});

  @override
  List<Object?> get props => [switchData];
}

class DeviceSwitchRequestedState extends DeviceModeState {
  final String newDevice;
  final String message;

  const DeviceSwitchRequestedState({
    required this.newDevice,
    required this.message,
  });

  @override
  List<Object?> get props => [newDevice, message];
}

class CompanionJoinedState extends DeviceModeState {
  final CompanionJoined companionData;

  const CompanionJoinedState({required this.companionData});

  @override
  List<Object?> get props => [companionData];
}

class DeviceModeError extends DeviceModeState {
  final String message;

  const DeviceModeError({required this.message});

  @override
  List<Object?> get props => [message];
}

class DeviceModeDisconnected extends DeviceModeState {
  const DeviceModeDisconnected();
}

// BLoC
class DeviceModeBloc extends Bloc<DeviceModeEvent, DeviceModeState> {
  final DeviceService _deviceService = DeviceService();
  final DeviceSwitchService _deviceSwitchService = DeviceSwitchService();

  StreamSubscription<DeviceSwitchReady>? _deviceSwitchReadySubscription;
  StreamSubscription<DeviceSwitchRequested>? _deviceSwitchRequestedSubscription;
  StreamSubscription<CompanionJoined>? _companionJoinedSubscription;
  StreamSubscription<bool>? _connectionSubscription;

  DeviceModeBloc() : super(const DeviceModeInitial()) {
    on<InitializeDeviceMode>(_onInitializeDeviceMode);
    on<RequestDeviceSwitch>(_onRequestDeviceSwitch);
    on<AcceptDeviceSwitch>(_onAcceptDeviceSwitch);
    on<RejectDeviceSwitch>(_onRejectDeviceSwitch);
    on<RequestCompanionMode>(_onRequestCompanionMode);
    on<LeaveCompanionMode>(_onLeaveCompanionMode);
    on<DeviceSwitchReadyReceived>(_onDeviceSwitchReadyReceived);
    on<DeviceSwitchRequestedReceived>(_onDeviceSwitchRequestedReceived);
    on<CompanionJoinedReceived>(_onCompanionJoinedReceived);
    on<ResetDeviceMode>(_onResetDeviceMode);

    _setupSocketListeners();
  }

  void _setupSocketListeners() {
    _deviceSwitchReadySubscription =
        _deviceSwitchService.onDeviceSwitchReady.listen(
      (data) => add(DeviceSwitchReadyReceived(
        roomId: data.roomId,
        producers: data.producers,
        routerRtpCapabilities: data.routerRtpCapabilities,
        creatorDevice: data.creatorDevice,
      )),
    );

    _deviceSwitchRequestedSubscription =
        _deviceSwitchService.onDeviceSwitchRequested.listen(
      (data) => add(DeviceSwitchRequestedReceived(
        newDevice: data.newDevice,
        message: data.message,
      )),
    );

    _companionJoinedSubscription =
        _deviceSwitchService.onCompanionJoined.listen(
      (data) => add(CompanionJoinedReceived(
        roomId: data.roomId,
        producers: data.producers,
        routerRtpCapabilities: data.routerRtpCapabilities,
        creatorDevice: data.creatorDevice,
      )),
    );

    _connectionSubscription = _deviceSwitchService.onConnectionChanged.listen(
      (connected) {
        if (!connected) {
          add(const ResetDeviceMode());
        }
      },
    );
  }

  Future<void> _onInitializeDeviceMode(
    InitializeDeviceMode event,
    Emitter<DeviceModeState> emit,
  ) async {
    try {
      emit(const DeviceModeLoading());

      final deviceId = await _deviceService.getDeviceId();
      final deviceType = _deviceService.getDeviceType();
      final deviceRole = await _deviceService.getDeviceRole();

      emit(DeviceModeConnected(
        deviceId: deviceId,
        deviceType: deviceType,
        deviceRole: deviceRole,
      ));
    } catch (e) {
      emit(DeviceModeError(message: e.toString()));
    }
  }

  Future<void> _onRequestDeviceSwitch(
    RequestDeviceSwitch event,
    Emitter<DeviceModeState> emit,
  ) async {
    try {
      emit(const DeviceModeLoading());

      await _deviceSwitchService.connect(
        roomId: event.roomId,
        userId: event.userId,
      );

      _deviceSwitchService.emitSwitchDevice(
        roomId: event.roomId,
        userId: event.userId,
      );

      final deviceId = await _deviceService.getDeviceId();
      final deviceType = _deviceService.getDeviceType();
      final deviceRole = await _deviceService.getDeviceRole();

      emit(DeviceModeConnected(
        deviceId: deviceId,
        deviceType: deviceType,
        deviceRole: deviceRole,
      ));
    } catch (e) {
      emit(DeviceModeError(message: e.toString()));
    }
  }

  void _onAcceptDeviceSwitch(
    AcceptDeviceSwitch event,
    Emitter<DeviceModeState> emit,
  ) {
    // The actual media handling should be done in the UI layer
    // This just emits a state to indicate acceptance
    debugPrint('DeviceModeBloc: Device switch accepted');
  }

  void _onRejectDeviceSwitch(
    RejectDeviceSwitch event,
    Emitter<DeviceModeState> emit,
  ) {
    // Reset to connected state
    final deviceId = _deviceService.getDeviceIdSync();
    if (deviceId != null) {
      emit(DeviceModeConnected(
        deviceId: deviceId,
        deviceType: _deviceService.getDeviceType(),
        deviceRole: DeviceRole.primary,
      ));
    }
  }

  Future<void> _onRequestCompanionMode(
    RequestCompanionMode event,
    Emitter<DeviceModeState> emit,
  ) async {
    try {
      emit(const DeviceModeLoading());

      await _deviceSwitchService.connect(
        roomId: event.roomId,
        userId: event.userId,
      );

      _deviceSwitchService.emitJoinCompanion(
        roomId: event.roomId,
        userId: event.userId,
      );

      // Persist device role as companion after successful join
      await _deviceService.setDeviceRole(DeviceRole.companion);

      final deviceId = await _deviceService.getDeviceId();
      final deviceType = _deviceService.getDeviceType();

      emit(DeviceModeConnected(
        deviceId: deviceId,
        deviceType: deviceType,
        deviceRole: DeviceRole.companion,
      ));
    } catch (e) {
      emit(DeviceModeError(message: e.toString()));
    }
  }

  Future<void> _onLeaveCompanionMode(
    LeaveCompanionMode event,
    Emitter<DeviceModeState> emit,
  ) async {
    try {
      await _deviceService.setDeviceRole(DeviceRole.primary);

      final deviceId = await _deviceService.getDeviceId();
      final deviceType = _deviceService.getDeviceType();

      emit(DeviceModeConnected(
        deviceId: deviceId,
        deviceType: deviceType,
        deviceRole: DeviceRole.primary,
      ));
    } catch (e) {
      emit(DeviceModeError(message: e.toString()));
    }
  }

  void _onDeviceSwitchReadyReceived(
    DeviceSwitchReadyReceived event,
    Emitter<DeviceModeState> emit,
  ) {
    emit(DeviceSwitchReadyState(
      switchData: DeviceSwitchReady(
        roomId: event.roomId,
        producers: event.producers,
        routerRtpCapabilities: event.routerRtpCapabilities,
        creatorDevice: event.creatorDevice,
      ),
    ));
  }

  void _onDeviceSwitchRequestedReceived(
    DeviceSwitchRequestedReceived event,
    Emitter<DeviceModeState> emit,
  ) {
    emit(DeviceSwitchRequestedState(
      newDevice: event.newDevice,
      message: event.message,
    ));
  }

  void _onCompanionJoinedReceived(
    CompanionJoinedReceived event,
    Emitter<DeviceModeState> emit,
  ) {
    emit(CompanionJoinedState(
      companionData: CompanionJoined(
        roomId: event.roomId,
        producers: event.producers,
        routerRtpCapabilities: event.routerRtpCapabilities,
        creatorDevice: event.creatorDevice,
      ),
    ));
  }

  void _onResetDeviceMode(
    ResetDeviceMode event,
    Emitter<DeviceModeState> emit,
  ) {
    emit(const DeviceModeDisconnected());
  }

  @override
  Future<void> close() {
    _deviceSwitchReadySubscription?.cancel();
    _deviceSwitchRequestedSubscription?.cancel();
    _companionJoinedSubscription?.cancel();
    _connectionSubscription?.cancel();
    return super.close();
  }
}
