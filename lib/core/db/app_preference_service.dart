import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';


class AppPreferenceService {
  late SharedPreferences _preferences;

  Future<void> init() async {
    try {
      _preferences = await SharedPreferences.getInstance();
    } catch (e) {
      debugPrint("Error initializing SharedPreferences: $e");
    }
  }

  Future<void> saveValue<T>(String key, T value) async {
    try {
      if (value is String) {
        await _preferences.setString(key, value);
      } else if (value is int) {
        await _preferences.setInt(key, value);
      } else if (value is bool) {
        await _preferences.setBool(key, value);
      } else if (value is double) {
        await _preferences.setDouble(key, value);
      } else {
        debugPrint("Unsupported type for saving preference");
      }
    } catch (e) {
      debugPrint("Error saving preference: $e");
    }
  }

  T? getValue<T>(String key) {
    try{
      if (T == String) {
        return _preferences.getString(key) as T?;
      } else if (T == int) {
        return _preferences.getInt(key) as T?;
      } else if (T == bool) {
        return _preferences.getBool(key) as T?;
      } else if (T == double) {
        return _preferences.getDouble(key) as T?;
      } else {
        debugPrint("Unsupported type for getting preference");
        return null;
      }
    } catch (e) {
      debugPrint("Error getting preference: $e");
      return null;
    }
  }

  Future<void> removeValue(String key) async {
    try {
      await _preferences.remove(key);
    } catch (e) {
      debugPrint("Error removing preference: $e");
    }
  }


  Future<void> clearAll() async {
    try {
      await _preferences.clear();
    } catch (e) {
      debugPrint("Error clearing all preferences: $e");
    }
  }
}
