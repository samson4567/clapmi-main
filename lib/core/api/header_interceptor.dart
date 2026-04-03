import 'package:clapmi/core/db/app_preference_service.dart';
import 'package:clapmi/core/security/secure_key.dart';
import 'package:clapmi/features/authentication/data/models/token_model.dart';
import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

class HeaderInterceptor extends Interceptor {
  HeaderInterceptor({
    required this.appPreferenceService,
    required this.dio,
  });
  static bool _isHandlingUnauthorized = false;
  final AppPreferenceService appPreferenceService;
  final Dio dio;
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final isAuthHeaderRequired = options.extra['isAuthHeaderRequired'] ?? false;
    final isLoginEndpoint = options.extra['isLoginEndpoint'] ?? false;
    if (isAuthHeaderRequired) {
      final serializedAccessToken =
          appPreferenceService.getValue<String>(SecureKey.loginAuthTokenKey);
      if (serializedAccessToken != null) {
        TokenModel result = TokenModel.deserialize(serializedAccessToken);
        options.headers['Authorization'] = result.accessToken;
      }
      // Add device ID header for authenticated requests
      final deviceId =
          appPreferenceService.getValue<String>(SecureKey.deviceIdKey);
      if (deviceId != null) {
        options.headers['X-Device-Id'] = deviceId;
      }
    }
    if (isLoginEndpoint) {
      options.headers['x-client-type'] = 'mobile';
    }
    options.extra.clear();
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 &&
        (err.response?.data['message'] == 'Token missing' ||
            err.response?.data['message'] == 'Invalid refresh token' ||
            err.response?.data['message'] ==
                'Invalid or expired refresh token')) {
      // Clear only auth tokens, preserve the login status flag
      // This way user goes to login (not onboarding) when token expires
      await appPreferenceService.removeValue(SecureKey.loginAuthTokenKey);
      await appPreferenceService.removeValue(SecureKey.loginUserDataKey);
      // Do NOT clear initialLoginStatusKey - keep it as false to indicate
      // user was logged in (just their token expired and needs refresh)

      if (!_isHandlingUnauthorized) {
        _isHandlingUnauthorized = true;
        final navigator = rootNavigatorKey.currentState;
        if (navigator != null && navigator.mounted) {
          navigator.context.go(MyAppRouteConstant.login);
        }
        Future.delayed(const Duration(seconds: 1), () {
          _isHandlingUnauthorized = false;
        });
      }
      handler.next(err);
    } else {
      super.onError(err, handler);
    }
  }
}
