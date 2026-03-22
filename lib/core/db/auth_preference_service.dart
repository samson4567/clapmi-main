import 'package:clapmi/core/db/app_preference_service.dart';

class AuthPreferenceService {
  const AuthPreferenceService({required this.preferenceService});
  final AppPreferenceService preferenceService;

  static const String _initialLoginStatusKey = 'initialLoginStatusKey';

  Future<void> setInitialLoginStatus(bool value) async {
    await preferenceService.saveValue<bool>(_initialLoginStatusKey, value);
  }

  bool? getInitialLoginStatus() {
    final value = preferenceService.getValue<bool>(_initialLoginStatusKey);
    return value;
  }
}
