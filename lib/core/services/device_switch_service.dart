import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:mediasfu_mediasoup_client/mediasfu_mediasoup_client.dart';
import '../api/multi_env.dart';
import 'device_service.dart';

/// Socket.IO service for Device Switch & Companion Mode
/// Handles Socket.IO events for switching between devices and companion mode
class DeviceSwitchService {
  static final DeviceSwitchService _singleton = DeviceSwitchService._internal();
  factory DeviceSwitchService() => _singleton;
  DeviceSwitchService._internal();

  final DeviceService _deviceService = DeviceService();

  io.Socket? _socket;
  Device? _mediasoupDevice;
  bool _isConnected = false;

  // Stream controllers for events
  final _deviceSwitchReadyController =
      StreamController<DeviceSwitchReady>.broadcast();
  final _deviceSwitchRequestedController =
      StreamController<DeviceSwitchRequested>.broadcast();
  final _companionJoinedController =
      StreamController<CompanionJoined>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();

  // Streams
  Stream<DeviceSwitchReady> get onDeviceSwitchReady =>
      _deviceSwitchReadyController.stream;
  Stream<DeviceSwitchRequested> get onDeviceSwitchRequested =>
      _deviceSwitchRequestedController.stream;
  Stream<CompanionJoined> get onCompanionJoined =>
      _companionJoinedController.stream;
  Stream<bool> get onConnectionChanged => _connectionController.stream;

  bool get isConnected => _isConnected;
  io.Socket? get socket => _socket;
  Device? get mediasoupDevice => _mediasoupDevice;

  /// Connect to mediasoup Socket.IO server
  Future<void> connect({
    required String roomId,
    required String userId,
  }) async {
    if (_socket != null && _socket!.connected) {
      return;
    }

    final deviceId = await _deviceService.getDeviceId();
    final deviceType = _deviceService.getDeviceType();

    _socket = io.io(
      MultiEnv().socketIoUrl,
      <String, dynamic>{
        'transports': ['websocket'],
        'path': MultiEnv().socketPath,
        'query': {
          'device_id': deviceId,
          'user_id': userId,
        },
      },
    );

    _setupListeners();

    _socket?.connect();

    _socket?.onConnect((_) {
      debugPrint('✅ DeviceSwitchService: Connected to Socket.IO');
      _isConnected = true;
      _connectionController.add(true);

      // Emit join-room after connection
      _socket?.emit('join-room', {
        'roomId': roomId,
        'userId': userId,
        'deviceId': deviceId,
        'device': deviceType,
      });
    });

    _socket?.onConnectError((data) {
      debugPrint('❌ DeviceSwitchService: Connection Error: $data');
      _isConnected = false;
      _connectionController.add(false);
    });

    _socket?.onDisconnect((data) {
      debugPrint('🛑 DeviceSwitchService: Disconnected: $data');
      _isConnected = false;
      _connectionController.add(false);
    });
  }

  void _setupListeners() {
    // Device switch ready (NEW device receives room state)
    _socket?.on('device-switch-ready', (data) {
      debugPrint('📱 DeviceSwitchService: device-switch-ready received');
      final switchData = DeviceSwitchReady.fromJson(data);
      _deviceSwitchReadyController.add(switchData);
    });

    // Device switch requested (OLD device must stop)
    _socket?.on('device-switch-requested', (data) {
      debugPrint('📱 DeviceSwitchService: device-switch-requested received');
      final requestData = DeviceSwitchRequested.fromJson(data);
      _deviceSwitchRequestedController.add(requestData);
    });

    // Companion joined
    _socket?.on('companion-joined', (data) {
      debugPrint('📱 DeviceSwitchService: companion-joined received');
      final companionData = CompanionJoined.fromJson(data);
      _companionJoinedController.add(companionData);
    });
  }

  /// Emit switch-device event (NEW device)
  void emitSwitchDevice({
    required String roomId,
    required String userId,
  }) {
    final deviceType = _deviceService.getDeviceType();
    _socket?.emit('switch-device', {
      'roomId': roomId,
      'userId': userId,
      'device': deviceType,
    });
    debugPrint('📤 DeviceSwitchService: emit switch-device');
  }

  /// Emit join-companion event (COMPANION device)
  void emitJoinCompanion({
    required String roomId,
    required String userId,
  }) {
    final deviceType = _deviceService.getDeviceType();
    _socket?.emit('join-companion', {
      'roomId': roomId,
      'userId': userId,
      'device': deviceType,
    });
    debugPrint('📤 DeviceSwitchService: emit join-companion');
  }

  /// Disconnect from Socket.IO
  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _isConnected = false;
    _connectionController.add(false);
    debugPrint('🔌 DeviceSwitchService: Disconnected');
  }

  /// Clean up resources
  void dispose() {
    disconnect();
    _deviceSwitchReadyController.close();
    _deviceSwitchRequestedController.close();
    _companionJoinedController.close();
    _connectionController.close();
  }
}

/// Data class for device-switch-ready event
class DeviceSwitchReady {
  final String roomId;
  final List<dynamic> producers;
  final Map<String, dynamic> routerRtpCapabilities;
  final String creatorDevice;

  DeviceSwitchReady({
    required this.roomId,
    required this.producers,
    required this.routerRtpCapabilities,
    required this.creatorDevice,
  });

  factory DeviceSwitchReady.fromJson(Map<String, dynamic> json) {
    return DeviceSwitchReady(
      roomId: json['roomId'] ?? '',
      producers: json['producers'] ?? [],
      routerRtpCapabilities: json['routerRtpCapabilities'] ?? {},
      creatorDevice: json['creatorDevice'] ?? '',
    );
  }
}

/// Data class for device-switch-requested event
class DeviceSwitchRequested {
  final String newDevice;
  final String message;

  DeviceSwitchRequested({
    required this.newDevice,
    required this.message,
  });

  factory DeviceSwitchRequested.fromJson(Map<String, dynamic> json) {
    return DeviceSwitchRequested(
      newDevice: json['newDevice'] ?? '',
      message: json['message'] ?? '',
    );
  }
}

/// Data class for companion-joined event
class CompanionJoined {
  final String roomId;
  final List<dynamic> producers;
  final Map<String, dynamic> routerRtpCapabilities;
  final String creatorDevice;

  CompanionJoined({
    required this.roomId,
    required this.producers,
    required this.routerRtpCapabilities,
    required this.creatorDevice,
  });

  factory CompanionJoined.fromJson(Map<String, dynamic> json) {
    return CompanionJoined(
      roomId: json['roomId'] ?? '',
      producers: json['producers'] ?? [],
      routerRtpCapabilities: json['routerRtpCapabilities'] ?? {},
      creatorDevice: json['creatorDevice'] ?? '',
    );
  }
}
