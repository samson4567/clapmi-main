import 'package:shared_preferences/shared_preferences.dart';

class SimplePersistentOfflineStorageHandler {
  static final SimplePersistentOfflineStorageHandler _singleton =
      SimplePersistentOfflineStorageHandler._internal();

  factory SimplePersistentOfflineStorageHandler() {
    return _singleton;
  }

  SimplePersistentOfflineStorageHandler._internal();

  SharedPreferences? prefs;
  Future<T?> load<T>(
    String key,
  ) async {
    prefs ??= await SharedPreferences.getInstance();

    try {
      return (prefs!.getString(key) ?? '') as T?;
    } catch (e) {
      try {
        return (prefs!.getBool(key) ?? false) as T?;
      } catch (e) {
        try {
          return (prefs!.getInt(key) ?? 0) as T?;
        } catch (e) {}
      }
    }
    return null;
  }

  Future save<T>(String key, T value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      return prefs.setString(key, value as String) as T?;
    } catch (e) {
      try {
        return prefs.setBool(key, value as bool) as T?;
      } catch (e) {
        try {
          return prefs.setInt(key, value as int) as T?;
        } catch (e) {}
      }
    }
    return null;
  }
}
