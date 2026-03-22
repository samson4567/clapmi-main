import 'dart:convert';

import 'package:clapmi/core/db/app_preference_service.dart';
import 'package:clapmi/core/db/auth_preference_service.dart';
import 'package:clapmi/core/security/secure_key.dart';
import 'package:clapmi/features/authentication/data/models/token_model.dart';

import 'package:clapmi/features/user/data/models/user_model.dart';

abstract class AuthenticationLocalDatasource {
  Future<void> cacheAuthToken(TokenModel tokenModel);
  Future<TokenModel?> getCachedAuthToken();
  Future<void> clearCachedAuthToken();

  Future<void> cacheUserData(UserModel userModel);
  Future<UserModel?> getCachedUserData();
  Future<void> clearCachedUserData();

  Future<void> setInitialLoginStatus(bool value);
}

class AuthenticationLocalDatasourceImpl
    implements AuthenticationLocalDatasource {
  AuthenticationLocalDatasourceImpl(
      {required this.appPreferenceService,
      required this.authPreferenceService});
  final AppPreferenceService appPreferenceService;
  final AuthPreferenceService authPreferenceService;

  @override
  Future<void> cacheAuthToken(TokenModel tokenModel) async {
    await appPreferenceService.saveValue(
        SecureKey.loginAuthTokenKey, TokenModel.serialize(tokenModel));
  }

  @override
  Future<void> clearCachedAuthToken() async {
    await appPreferenceService.removeValue(SecureKey.loginAuthTokenKey);
  }

  @override
  Future<TokenModel?> getCachedAuthToken() async {
    final tokenModel =
        appPreferenceService.getValue<String>(SecureKey.loginAuthTokenKey);
    if (tokenModel == null) return null;
    return TokenModel.deserialize(tokenModel);
  }

  @override
  Future<void> cacheUserData(UserModel userModel) async {
    await appPreferenceService.saveValue(
        SecureKey.loginUserDataKey, jsonEncode(userModel.toJson()));
  }

  @override
  Future<void> clearCachedUserData() async {
    await appPreferenceService.removeValue(SecureKey.loginUserDataKey);
  }

  @override
  Future<UserModel?> getCachedUserData() async {
    final userModel =
        appPreferenceService.getValue<String>(SecureKey.loginUserDataKey);
    if (userModel == null) return null;
    return UserModel.fromJson(jsonDecode(userModel));
  }

  @override
  Future<void> setInitialLoginStatus(bool value) async {
    await authPreferenceService.setInitialLoginStatus(value);
  }
}
