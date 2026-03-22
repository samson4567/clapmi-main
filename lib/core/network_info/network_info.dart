import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityHelper {
  static Future<bool> hasInternetConnection() async {
    try {
      return await InternetConnection().hasInternetAccess;
    } catch (_) {
      return false;
    }
  }
}
