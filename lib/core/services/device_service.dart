import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Service to manage unique device identifier
/// Required for Device Switch & Companion Mode feature
class DeviceService {
  static final DeviceService _singleton = DeviceService._internal();
  factory DeviceService() => _singleton;
  DeviceService._internal();

  static const String _deviceIdKey = 'clapmi_device_uuid';
  static const String _deviceRoleKey = 'clapmi_device_role';

  SharedPreferences? _prefs;
  String? _cachedDeviceId;

  /// Get the unique device ID, creating one if it doesn't exist
  /// The ID persists across app sessions
  Future<String> getDeviceId() async {
    if (_cachedDeviceId != null) {
      return _cachedDeviceId!;
    }

    _prefs ??= await SharedPreferences.getInstance();

    String? deviceId = _prefs!.getString(_deviceIdKey);

    if (deviceId == null || deviceId.isEmpty) {
      // Generate new UUID for this device
      deviceId = const Uuid().v4();
      await _prefs!.setString(_deviceIdKey, deviceId);
    }

    _cachedDeviceId = deviceId;
    return deviceId;
  }

  /// Get device ID synchronously (if already cached)
  /// Returns null if not yet initialized
  String? getDeviceIdSync() => _cachedDeviceId;

  /// Set device role (primary, companion)
  Future<void> setDeviceRole(DeviceRole role) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setString(_deviceRoleKey, role.name);
  }

  /// Get current device role
  Future<DeviceRole> getDeviceRole() async {
    _prefs ??= await SharedPreferences.getInstance();
    final roleName = _prefs!.getString(_deviceRoleKey);
    if (roleName == null) return DeviceRole.primary;
    return DeviceRole.fromName(roleName);
  }

  /// Check if this device is the primary streaming device
  Future<bool> isPrimaryDevice() async {
    final role = await getDeviceRole();
    return role == DeviceRole.primary;
  }

  /// Clear device ID (for testing/logout)
  Future<void> clearDeviceId() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.remove(_deviceIdKey);
    await _prefs!.remove(_deviceRoleKey);
    _cachedDeviceId = null;
  }

  /// Get device type string for Socket.IO events
  String getDeviceType() {
    // For mobile app, always use 'mobile'
    return 'mobile';
  }
}

/// Device roles for streaming
enum DeviceRole {
  primary,
  companion,
  spectator;

  static DeviceRole fromName(String name) {
    switch (name) {
      case 'companion':
        return DeviceRole.companion;
      case 'spectator':
        return DeviceRole.spectator;
      default:
        return DeviceRole.primary;
    }
  }
}
