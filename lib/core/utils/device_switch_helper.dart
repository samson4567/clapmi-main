import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:clapmi/core/services/device_service.dart';
import 'package:clapmi/core/services/device_switch_service.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_bloc.dart';
import 'package:clapmi/features/combo/presentation/blocs/combo_bloc/combo_event.dart';

/// Helper class to manage device switch and companion mode functionality
/// within livestream screens
class DeviceSwitchHelper {
  final DeviceService _deviceService = DeviceService();
  final DeviceSwitchService _deviceSwitchService = DeviceSwitchService();
  
  // Callbacks for handling events
  Function(DeviceSwitchReady)? onDeviceSwitchReady;
  Function(DeviceSwitchRequested)? onDeviceSwitchRequested;
  Function(CompanionJoined)? onCompanionJoined;
  Function(bool)? onConnectionChanged;
  
  // Streams
  StreamSubscription<DeviceSwitchReady>? _deviceSwitchReadySub;
  StreamSubscription<DeviceSwitchRequested>? _deviceSwitchRequestedSub;
  StreamSubscription<CompanionJoined>? _companionJoinedSub;
  StreamSubscription<bool>? _connectionSub;
  
  // Current state
  bool _isInitialized = false;
  String? _currentRoomId;
  String? _currentUserId;
  
  bool get isInitialized => _isInitialized;
  
  /// Initialize device switch helper and set up listeners
  void initialize({
    Function(DeviceSwitchReady)? onDeviceSwitchReady,
    Function(DeviceSwitchRequested)? onDeviceSwitchRequested,
    Function(CompanionJoined)? onCompanionJoined,
    Function(bool)? onConnectionChanged,
  }) {
    this.onDeviceSwitchReady = onDeviceSwitchReady;
    this.onDeviceSwitchRequested = onDeviceSwitchRequested;
    this.onCompanionJoined = onCompanionJoined;
    this.onConnectionChanged = onConnectionChanged;
    
    _setupListeners();
    _isInitialized = true;
  }
  
  void _setupListeners() {
    _deviceSwitchReadySub = _deviceSwitchService.onDeviceSwitchReady.listen((data) {
      debugPrint('DeviceSwitchHelper: device-switch-ready received');
      onDeviceSwitchReady?.call(data);
    });
    
    _deviceSwitchRequestedSub = _deviceSwitchService.onDeviceSwitchRequested.listen((data) {
      debugPrint('DeviceSwitchHelper: device-switch-requested received');
      onDeviceSwitchRequested?.call(data);
    });
    
    _companionJoinedSub = _deviceSwitchService.onCompanionJoined.listen((data) {
      debugPrint('DeviceSwitchHelper: companion-joined received');
      onCompanionJoined?.call(data);
    });
    
    _connectionSub = _deviceSwitchService.onConnectionChanged.listen((connected) {
      debugPrint('DeviceSwitchHelper: connection changed - $connected');
      onConnectionChanged?.call(connected);
    });
  }
  
  /// Connect to Socket.IO for device switch
  Future<void> connect(String roomId, String userId) async {
    _currentRoomId = roomId;
    _currentUserId = userId;
    
    await _deviceSwitchService.connect(
      roomId: roomId,
      userId: userId,
    );
  }
  
  /// Initiate device switch (call this from NEW device)
  Future<void> initiateDeviceSwitch() async {
    if (_currentRoomId == null || _currentUserId == null) {
      debugPrint('DeviceSwitchHelper: Cannot initiate switch - not connected');
      return;
    }
    
    _deviceSwitchService.emitSwitchDevice(
      roomId: _currentRoomId!,
      userId: _currentUserId!,
    );
  }
  
  /// Join as companion device
  Future<void> joinAsCompanion() async {
    if (_currentRoomId == null || _currentUserId == null) {
      debugPrint('DeviceSwitchHelper: Cannot join companion - not connected');
      return;
    }
    
    _deviceSwitchService.emitJoinCompanion(
      roomId: _currentRoomId!,
      userId: _currentUserId!,
    );
  }
  
  /// Handle device switch requested (call this on OLD device)
  /// Stops all media and disconnects
  Future<void> handleDeviceSwitchRequested({
    required Function() stopMedia,
    required Function() closeTransports,
    required Function() disconnect,
  }) async {
    debugPrint('DeviceSwitchHelper: Handling device switch request');
    
    // Stop all local media tracks
    stopMedia();
    
    // Close transports
    closeTransports();
    
    // Disconnect from Socket.IO
    disconnect();
  }
  
  /// Handle device switch ready (call this on NEW device after receiving event)
  /// The screen should implement all the media handling itself
  /// This just provides the data and callbacks
  Future<void> handleDeviceSwitchReady({
    required DeviceSwitchReady data,
    required Future<void> Function(dynamic routerRtpCapabilities) loadDevice,
    required Future<void> Function() createSendTransport,
    required Future<void> Function() createRecvTransport,
    required Future<void> Function() produceMedia,
    required Future<void> Function(List<dynamic> producers) consumeExistingProducers,
  }) async {
    debugPrint('DeviceSwitchHelper: Handling device switch ready');
    
    // 1. Load mediasoup device with router capabilities
    await loadDevice(data.routerRtpCapabilities);
    
    // 2. Create transports
    await createSendTransport();
    await createRecvTransport();
    
    // 3. Produce media (get user media and produce)
    await produceMedia();
    
    // 4. Consume existing producers
    await consumeExistingProducers(data.producers);
  }
  
  /// Handle companion joined (call this on companion device)
  Future<void> handleCompanionJoined({
    required CompanionJoined data,
    required Future<void> Function(dynamic routerRtpCapabilities) loadDevice,
    required Future<void> Function() createRecvTransport,
    required Future<void> Function(List<dynamic> producers) consumeExistingProducers,
  }) async {
    debugPrint('DeviceSwitchHelper: Handling companion joined');
    
    // 1. Load mediasoup device
    await loadDevice(data.routerRtpCapabilities);
    
    // 2. Create only receive transport (companions cannot produce)
    await createRecvTransport();
    
    // 3. Consume existing producers
    await consumeExistingProducers(data.producers);
  }
  
  /// Call REST API to switch device
  Future<void> callSwitchDeviceApi({
    required ComboBloc comboBloc,
    required String comboId,
  }) async {
    final deviceId = await _deviceService.getDeviceId();
    
    comboBloc.add(SwitchDeviceEvent(
      comboID: comboId,
      deviceId: deviceId,
    ));
  }
  
  /// Call REST API to join as companion
  Future<void> callJoinCompanionApi({
    required ComboBloc comboBloc,
    required String comboId,
  }) async {
    final deviceId = await _deviceService.getDeviceId();
    
    comboBloc.add(JoinCompanionEvent(
      comboID: comboId,
      deviceId: deviceId,
    ));
  }
  
  /// Get current device ID
  Future<String> getDeviceId() async {
    return await _deviceService.getDeviceId();
  }
  
  /// Get device type
  String getDeviceType() {
    return _deviceService.getDeviceType();
  }
  
  /// Check if this device is primary
  Future<bool> isPrimaryDevice() async {
    return await _deviceService.isPrimaryDevice();
  }
  
  /// Disconnect and cleanup
  void dispose() {
    _deviceSwitchReadySub?.cancel();
    _deviceSwitchRequestedSub?.cancel();
    _companionJoinedSub?.cancel();
    _connectionSub?.cancel();
    
    _deviceSwitchService.disconnect();
    _isInitialized = false;
  }
}